// Weekly GemWorkers safety copy → iCloud Drive (encrypted).
//
// Exports every table in the public schema (all GemWorkers data: stones,
// orders, invoices, buyers, offers, messages, payouts…) plus the login list
// (auth.users: id, email, dates — no passwords) as JSON, compresses it and
// encrypts it with AES-256-GCM using the password in the Windows user
// variable GW_BACKUP_PASS. Uses the Supabase CLI login already on this laptop
// (no database password stored). page_views (visit statistics) is skipped.
// Keeps the newest KEEP copies. Writes "last backup.txt" with the result.
//
// Run by Windows Task Scheduler ("GemWorkers backup", Sundays) or by hand:
//   node gemworkers_core/tools/backup/backup.js
// Open a copy: node gemworkers_core/tools/backup/decrypt.js <file>

const { spawnSync } = require('child_process')
const crypto = require('crypto')
const fs = require('fs')
const os = require('os')
const path = require('path')
const zlib = require('zlib')

const APP_DIR = path.join(__dirname, '..', '..', '..')                      // gemworkers_app
const OUT_DIR = path.join(os.homedir(), 'iCloudDrive', 'GemWorkers backups')
const KEEP = 12
const SKIP = new Set(['page_views'])

function query(sql) {
  const file = path.join(os.tmpdir(), `gw-backup-${process.pid}.sql`)
  fs.writeFileSync(file, sql)
  const res = spawnSync(`npx supabase db query --linked -f "${file}" -o json`, {
    cwd: APP_DIR, encoding: 'utf8', shell: true, maxBuffer: 1024 * 1024 * 1024,
  })
  fs.rmSync(file, { force: true })
  if (res.status !== 0) throw new Error((res.stderr || res.stdout || 'query failed').slice(0, 500))
  const parsed = JSON.parse(res.stdout)
  return Array.isArray(parsed) ? parsed : parsed.rows ?? parsed
}

function status(text) {
  fs.mkdirSync(OUT_DIR, { recursive: true })
  fs.writeFileSync(path.join(OUT_DIR, 'last backup.txt'), `${new Date().toISOString()}  ${text}\n`)
}

function main() {
  const pass = process.env.GW_BACKUP_PASS
  if (!pass || pass.length < 10) throw new Error('GW_BACKUP_PASS is not set (or shorter than 10 characters)')
  if (!fs.existsSync(path.dirname(OUT_DIR))) throw new Error(`iCloud Drive folder not found: ${path.dirname(OUT_DIR)}`)

  const tables = query(`select table_name from information_schema.tables
                        where table_schema = 'public' and table_type = 'BASE TABLE' order by 1`)
    .map(r => r.table_name).filter(t => !SKIP.has(t))

  const data = { made_at: new Date().toISOString(), project: 'cvqzidqnwthzfodhzepz', tables: {} }
  for (const t of tables) {
    const rows = query(`select coalesce(json_agg(x), '[]'::json) as rows from public."${t.replace(/"/g, '""')}" x`)
    data.tables[t] = rows[0]?.rows ?? []
  }
  data.tables['auth.users'] = query(`select coalesce(json_agg(x), '[]'::json) as rows from (
      select id, email, phone, created_at, last_sign_in_at, email_confirmed_at, raw_user_meta_data from auth.users) x`)[0]?.rows ?? []

  const counts = Object.fromEntries(Object.entries(data.tables).map(([k, v]) => [k, v.length]))
  const plain = zlib.gzipSync(Buffer.from(JSON.stringify(data)))

  // AES-256-GCM, key from the password with scrypt. File = "GWB1" + salt + iv + tag + data.
  const salt = crypto.randomBytes(16)
  const iv = crypto.randomBytes(12)
  const key = crypto.scryptSync(pass, salt, 32, { N: 1 << 15, r: 8, p: 1, maxmem: 64 * 1024 * 1024 })
  const cipher = crypto.createCipheriv('aes-256-gcm', key, iv)
  const enc = Buffer.concat([cipher.update(plain), cipher.final()])
  const out = Buffer.concat([Buffer.from('GWB1'), salt, iv, cipher.getAuthTag(), enc])

  fs.mkdirSync(OUT_DIR, { recursive: true })
  const name = `gemworkers-${new Date().toISOString().slice(0, 10)}.gwbackup`
  fs.writeFileSync(path.join(OUT_DIR, name), out)

  // Keep the newest KEEP copies.
  const old = fs.readdirSync(OUT_DIR).filter(f => /^gemworkers-\d{4}-\d{2}-\d{2}\.gwbackup$/.test(f)).sort().reverse().slice(KEEP)
  for (const f of old) fs.rmSync(path.join(OUT_DIR, f), { force: true })

  const total = Object.values(counts).reduce((a, b) => a + b, 0)
  status(`OK  ${name}  ${(out.length / 1024).toFixed(0)} KB  ${tables.length + 1} tables  ${total} rows  (orders ${counts.orders ?? 0}, invoices ${counts.invoices ?? 0}, stones ${counts.inventory_items ?? 0})`)
  console.log(`Backup saved: ${name} (${(out.length / 1024).toFixed(0)} KB, ${total} rows)`)
}

try {
  main()
} catch (e) {
  const msg = e instanceof Error ? e.message : String(e)
  try { status(`FAILED  ${msg}`) } catch { /* folder missing */ }
  console.error('Backup FAILED: ' + msg)
  process.exit(1)
}
