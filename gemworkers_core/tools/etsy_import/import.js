// Etsy "Currently for sale listings" CSV → GemWorkers drafts (unlisted).
// Run from gemworkers_store (uses its sharp):
//   node ../gemworkers_core/tools/etsy_import/import.js <csv> <seller_id> <out_dir> [--dry] [--limit N]
// --dry      : read + recognise only, writes <out>/preview.json (no uploads)
// otherwise  : photos → Bunny (full ≤ 2000 px + 800 px card, via the media
//              function's migration token, env GW_MIGRATE_TOKEN), then writes
//              <out>/insert_drafts.sql for Zakaria to run (one transaction).
// Stone ids are kept in <out>/ids.json, so a re-run re-uses them (photos are
// overwritten under the same names, nothing doubles).
// Drafts: is_listed false, status available, price = CSV price (full price),
// shipping as the seller's other Pakistan stones (free, 10–20 days) — the
// seller checks each draft (treatment, shipping) before listing.

const fs = require('fs')
const path = require('path')
const crypto = require('crypto')

const [csvFile, sellerId, outDir, ...flags] = process.argv.slice(2)
const DRY = flags.includes('--dry')
const LIMIT = flags.includes('--limit') ? Number(flags[flags.indexOf('--limit') + 1]) : Infinity
// Seller's own shipping (copy from their listed stones): --shipping 25 --days 4-8 --prep 3. Default = Atal's (free, 10–20 days).
const flag = (n, d) => flags.includes(n) ? flags[flags.indexOf(n) + 1] : d
const SHIP = Number(flag('--shipping', '0'))
const [DMIN, DMAX] = flag('--days', '10-20').split('-').map(Number)
const PREP = flag('--prep', null)
// --usd-rate 1.1165 = ECB euro reference rate (1 EUR = x USD): USD prices → whole euros (GemWorkers is EUR-only).
const USD_RATE = Number(flag('--usd-rate', '0'))
// --max-qty 90: Etsy 'keep active' stock numbers (≥ this) become 1; the seller enters the real stock.
const MAX_QTY = Number(flag('--max-qty', '1000'))
// --vat-markup 1.21: own NL stock whose Etsy price had VAT inside by accident → GemWorkers price incl. VAT (whole euros).
const MARKUP = Number(flag('--vat-markup', '1'))
// --skip 1,5,16: CSV rows (1 = first listing) already on GemWorkers — not imported.
const SKIP = new Set(String(flag('--skip', '')).split(',').filter(Boolean).map(Number))
if (!csvFile || !sellerId || !outDir) { console.error('usage: import.js <csv> <seller_id> <out_dir> [--dry] [--limit N]'); process.exit(1) }
fs.mkdirSync(outDir, { recursive: true })

// ── CSV (quotes, commas and newlines inside fields) ─────────────────────────
function parseCsv(t) {
  const rows = []; let r = [], f = '', q = false
  for (let i = 0; i < t.length; i++) {
    const ch = t[i]
    if (q) { if (ch === '"') { if (t[i + 1] === '"') { f += '"'; i++ } else q = false } else f += ch }
    else if (ch === '"') q = true
    else if (ch === ',') { r.push(f); f = '' }
    else if (ch === '\n') { r.push(f); rows.push(r); r = []; f = '' }
    else if (ch !== '\r') f += ch
  }
  if (f || r.length) { r.push(f); rows.push(r) }
  const head = rows.shift()
  return rows.filter(x => x.length > 1).map(x => Object.fromEntries(head.map((h, i) => [h, x[i] ?? ''])))
}

// ── Recognise fields from title + description ───────────────────────────────
const GEMS = [  // [word in title, gem_type, variety]
  ['rubilite', 'Tourmaline', 'Rubellite'], ['rubelite', 'Tourmaline', 'Rubellite'], ['watermelon', 'Tourmaline', 'Watermelon'],
  ['flourite', 'Fluorite', null], ['herkimer', 'Quartz', 'Herkimer'], ["tiger's eye", "Tiger's Eye", null], ['tiger eye', "Tiger's Eye", null], ['ametrine', 'Quartz', 'Ametrine'], ['hauyne', 'Hauyne', null], ['moonstone', 'Moonstone', null], ['aqumarine', 'Aquamarine', null], ['imperial topa', 'Topaz', 'Imperial'],
  ['rubellite', 'Tourmaline', 'Rubellite'], ['indicolite', 'Tourmaline', 'Indicolite'], ['paraiba', 'Tourmaline', 'Paraiba'],
  ['tourmaline', 'Tourmaline', null], ['kunzite', 'Kunzite', null], ['hiddenite', 'Hiddenite', null], ['spodumene', 'Spodumene', null],
  ['aquamarine', 'Aquamarine', null], ['morganite', 'Morganite', null], ['heliodor', 'Beryl', 'Heliodor'], ['emerald', 'Emerald', null],
  ['beryl', 'Beryl', null], ['sapphire', 'Sapphire', null], ['ruby', 'Ruby', null], ['spinel', 'Spinel', null],
  ['spessartite', 'Garnet', 'Spessartite'], ['tsavorite', 'Garnet', 'Tsavorite'], ['garnet', 'Garnet', null], ['topaz', 'Topaz', null],
  ['peridot', 'Peridot', null], ['amethyst', 'Quartz', 'Amethyst'], ['citrine', 'Quartz', 'Citrine'], ['quartz', 'Quartz', null],
  ['apatite', 'Apatite', null], ['fluorite', 'Fluorite', null], ['lapis', 'Lapis Lazuli', null], ['opal', 'Opal', null],
  ['zircon', 'Zircon', null], ['tanzanite', 'Tanzanite', null], ['sphene', 'Sphene', null], ['titanite', 'Sphene', null],
  ['kyanite', 'Kyanite', null], ['jade', 'Jade', null], ['turquoise', 'Turquoise', null], ['diamond', 'Diamond', null],
  ['scapolite', 'Scapolite', null], ['zoisite', 'Zoisite', null], ['epidote', 'Epidote', null], ['vesuvianite', 'Vesuvianite', null],
]
const JEWELRY = /\b(ring|rings|necklace|pendant|bracelet|earrings?|jewelry|jewellery|chain|anklet|brooch)\b/i
const SPECIMEN = /\b(crystal|crystals|specimen|rough|cluster|matrix|mineral|raw)\b/i

function recognise(row) {
  const title = row.TITLE.trim()
  const desc = row.DESCRIPTION || ''
  const lower = title.toLowerCase()
  // The gem named FIRST in the title wins ("Aquamarine with black tourmaline" = aquamarine).
  // Else Etsy's own "Gemstone" attribute (one value, e.g. "Tourmaline").
  const attr = /^gemstone/i.test(row['VARIATION 1 NAME'] || '') && !/,/.test(row['VARIATION 1 VALUES'] || '')
    ? (row['VARIATION 1 VALUES'] || '').toLowerCase().trim() : ''
  const gem = GEMS.map(g => [g, lower.indexOf(g[0])]).filter(([, i]) => i >= 0)
    .sort((a, b) => a[1] - b[1])[0]?.[0] ?? GEMS.find(([w]) => attr.includes(w))
  const productType = JEWELRY.test(title) ? 'jewelry' : SPECIMEN.test(title) ? 'specimen' : 'loose_stone'
  let weight = null, unit = null
  const wt = title.match(/(\d+(?:\.\d+)?)\s*(cts?|carats?)\b/i)
  const wd = desc.match(/weight\s*:?\s*(\d+(?:\.\d+)?)\s*(cts?|carats?|grams?|gms?|g)\b/i)
  if (wt) { weight = Number(wt[1]); unit = 'ct' }
  else if (wd) { weight = Number(wd[1]); unit = /^c/i.test(wd[2]) ? 'ct' : 'g' }
  // "Origin : X", else a country named anywhere ("…from Afghanistan", "Swat").
  const COUNTRY = [[/\bafghan(istan)?\b|\bkunar\b|\bnuristan\b/i, 'Afghanistan'], [/\bpakistan\b|\bswat\b|\bskardu\b|\bgilgit\b/i, 'Pakistan'],
    [/\bsri lanka\b|\bceylon\b/i, 'Sri Lanka'], [/\bbrazil/i, 'Brazil'], [/\bnigeria/i, 'Nigeria'], [/\bmozambique\b/i, 'Mozambique'],
    [/\bmadagascar\b/i, 'Madagascar'], [/\bburm(a|ese)\b|\bmyanmar\b/i, 'Myanmar'], [/\btanzania/i, 'Tanzania'], [/\bkenya/i, 'Kenya'],
    [/\bnamibia/i, 'Namibia'], [/\bcolombia/i, 'Colombia'], [/\bzambia/i, 'Zambia'], [/\bvietnam/i, 'Vietnam']]
  const originLine = (desc.match(/origin\s*:\s*([A-Za-z][A-Za-z .'-]{1,40})/i) || [])[1]
  // The "Origin:" line only counts when it names a known place (not "Ethically sourced").
  const fromLine = originLine && (COUNTRY.find(([re]) => re.test(originLine)) || [])[1]
  const origin = fromLine ?? (COUNTRY.find(([re]) => re.test(title + ' ' + desc)) || [])[1]
  const size = (desc.match(/size\s*:\s*([\d.,]+\s*x\s*[\d.,]+(?:\s*x\s*[\d.,]+)?)\s*mm/i) || [])[1]
  const clarity = (desc.match(/clarity\s*:\s*([^\n\r]{1,60})/i) || [])[1]
  const images = Array.from({ length: 10 }, (_, i) => row[`IMAGE${i + 1}`]).filter(u => /^https:\/\/i\.etsystatic\.com\//.test(u || ''))
  const qty = Math.max(1, Math.min(999, Math.floor(Number(row.QUANTITY) || 1)))
  return {
    title, description: desc.trim(), price: Number(row.PRICE), currency: row.CURRENCY_CODE, quantity: qty,
    product_type: productType, gem_type: gem ? gem[1] : null, variety: gem ? gem[2] : null,
    weight_value: weight, weight_unit: unit,
    origin_country: origin ? origin.trim().replace(/\s+/g, ' ').replace(/\b\w/g, c => c.toUpperCase()) : null,
    clarity: clarity ? clarity.trim() : null,
    dimensions_mm: size ? size.replace(/s+/g, ' ').trim() : null,
    images, etsy_sku: row.SKU || null, tags: row.TAGS || '', materials: row.MATERIALS || '',
    // Only real choices count (several values); a single Etsy attribute is not one.
    variations: [1, 2, 3].some(n => (row[`VARIATION ${n} VALUES`] || '').includes(',')),
  }
}

// ── Photos ──────────────────────────────────────────────────────────────────
const FN = 'https://cvqzidqnwthzfodhzepz.supabase.co/functions/v1/media'
async function movePhoto(sharp, itemId, url, n) {
  const res = await fetch(url)
  if (!res.ok) throw new Error(`download ${res.status} ${url}`)
  const src = Buffer.from(await res.arrayBuffer())
  const full = await sharp(src).rotate().resize({ width: 2000, height: 2000, fit: 'inside', withoutEnlargement: true }).jpeg({ quality: 90, mozjpeg: true }).toBuffer()
  const card = await sharp(src).rotate().resize({ width: 800, withoutEnlargement: true }).jpeg({ quality: 82, mozjpeg: true }).toBuffer()
  for (let attempt = 1; ; attempt++) {
    const form = new FormData()
    form.set('item_id', itemId); form.set('name', `etsy-${n}`)
    form.set('file', new Blob([full], { type: 'image/jpeg' }), 'photo.jpg')
    form.set('card', new Blob([card], { type: 'image/jpeg' }), 'card.jpg')
    const up = await fetch(FN, { method: 'POST', headers: { 'x-migrate-token': process.env.GW_MIGRATE_TOKEN }, body: form })
    const data = await up.json().catch(() => ({}))
    if (up.ok) return data.url
    if (attempt >= 3) throw new Error(`upload ${up.status} ${data.error || ''}`)
    await new Promise(r => setTimeout(r, 1500 * attempt))
  }
}

const q = s => (s == null ? 'NULL' : `'${String(s).replace(/'/g, "''")}'`)

;(async () => {
  const rows = parseCsv(fs.readFileSync(csvFile, 'utf8')).slice(0, LIMIT)
  const items = rows.map(recognise).filter((_, i) => !SKIP.has(i + 1))
  for (const it of items) {
    if (it.currency === 'USD') {
      if (!USD_RATE) { console.error('Prices are in USD: pass --usd-rate (ECB rate, 1 EUR = x USD)'); process.exit(1) }
      it.etsy_price = `${it.price} USD`; it.price = Math.round(it.price / USD_RATE); it.currency = 'EUR'
    } else if (it.currency !== 'EUR') { console.error(`Unknown currency ${it.currency}`); process.exit(1) }
    if (MARKUP !== 1) { it.etsy_price = it.etsy_price || `${it.price} EUR`; it.price = Math.round(it.price * MARKUP) }
    if (it.quantity >= MAX_QTY) { it.etsy_qty = it.quantity; it.quantity = 1 }
  }
  const idsFile = path.join(outDir, 'ids.json')
  const ids = fs.existsSync(idsFile) ? JSON.parse(fs.readFileSync(idsFile, 'utf8')) : {}
  items.forEach((it, i) => { const k = `${i}|${it.title}`; ids[k] ??= crypto.randomUUID(); it.id = ids[k] })
  fs.writeFileSync(idsFile, JSON.stringify(ids, null, 1))

  const count = f => items.reduce((m, it) => (m[f(it) ?? '—'] = (m[f(it) ?? '—'] || 0) + 1, m), {})
  const summary = {
    listings: items.length,
    currency: count(it => it.currency),
    product_type: count(it => it.product_type),
    gem_type: count(it => it.gem_type),
    weight_found: items.filter(it => it.weight_value != null).length,
    origin: count(it => it.origin_country),
    size_found: items.filter(it => it.dimensions_mm).length,
    photos: items.reduce((n, it) => n + it.images.length, 0),
    no_photo: items.filter(it => !it.images.length).map(it => it.title),
    no_gem: items.filter(it => !it.gem_type).map(it => it.title),
    with_variations: items.filter(it => it.variations).map(it => it.title),
    more_than_one: items.filter(it => it.quantity > 1).map(it => `${it.title} × ${it.quantity}`),
  }
  fs.writeFileSync(path.join(outDir, 'preview.json'), JSON.stringify({ summary, items: items.map(({ description, ...x }) => x) }, null, 1))
  console.log(JSON.stringify(summary, null, 1))
  if (DRY) return

  if (!process.env.GW_MIGRATE_TOKEN) { console.error('GW_MIGRATE_TOKEN missing'); process.exit(1) }
  const sharp = require(require.resolve('sharp', { paths: [process.cwd()] }))
  const log = []
  let next = 0, done = 0
  async function worker() {
    while (next < items.length) {
      const it = items[next++]
      it.image_urls = []
      for (let n = 0; n < it.images.length; n++) {
        try { it.image_urls.push(await movePhoto(sharp, it.id, it.images[n], n + 1)) }
        catch (e) { log.push({ id: it.id, title: it.title, photo: n + 1, error: String(e.message || e) }) }
      }
      if (++done % 10 === 0) process.stdout.write(`${done}/${items.length} `)
    }
  }
  await Promise.all([worker(), worker(), worker(), worker()])
  fs.writeFileSync(path.join(outDir, 'photo_errors.json'), JSON.stringify(log, null, 1))

  const stamp = new Date().toISOString().slice(0, 10)
  const sql = [
    `-- GemWorkers — Etsy import (${items.length} drafts, unlisted) for seller ${sellerId}, ${stamp}.`,
    '-- Generated by gemworkers_core/tools/etsy_import/import.js. Safe to run twice (skips existing ids).',
    'BEGIN;',
  ]
  for (const it of items) {
    const notes = [`Imported from Etsy (${stamp}).`, it.etsy_sku && `Etsy SKU: ${it.etsy_sku}.`, it.etsy_price && `Etsy price ${it.etsy_price}${MARKUP !== 1 ? ` × ${MARKUP} (VAT)` : ', converted at ECB rate'}.`, it.etsy_qty && `Etsy quantity was ${it.etsy_qty} — set the real stock.`,
      it.tags && `Etsy tags: ${it.tags.replace(/_/g, ' ')}.`, it.variations && 'Had variations on Etsy — check size/options.']
      .filter(Boolean).join(' ')
    sql.push(`INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES (${q(it.id)}, ${q(it.title)}, ${q(it.description)}, ${q(sellerId)}, ${Number.isFinite(it.price) ? it.price : 'NULL'}, ${it.quantity}, ${q(it.product_type)}, ${q(it.gem_type)}, ${q(it.variety)}, ${it.weight_value ?? 'NULL'}, ${q(it.weight_unit)}, ${q(it.origin_country)}, ${q(it.clarity)}, ${q(it.dimensions_mm)}, ${q(JSON.stringify(it.image_urls))}::jsonb, ${q(notes)}, ${q(it.quantity > 1 ? 'buy_now' : 'both')}, ${SHIP}, ${DMIN}, ${DMAX}, ${PREP == null ? 'NULL' : Number(PREP)}, 'available', false)
ON CONFLICT (id) DO NOTHING;`)
  }
  sql.push(`-- Check: drafts for this seller, all unlisted`,
    `SELECT count(*) AS drafts, count(*) FILTER (WHERE is_listed) AS listed, sum(jsonb_array_length(image_urls)) AS photos FROM public.inventory_items WHERE seller_id = ${q(sellerId)} AND notes LIKE 'Imported from Etsy%';`,
    'COMMIT;')
  fs.writeFileSync(path.join(outDir, 'insert_drafts.sql'), sql.join('\n') + '\n')
  console.log(`\nphotos uploaded ${items.reduce((n, it) => n + it.image_urls.length, 0)}, errors ${log.length}`)
})()
