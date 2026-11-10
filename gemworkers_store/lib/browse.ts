// Colour and collection groups for browsing (homepage rows + /shop filters).
// Worked out from the words sellers already use in titles — no new fields.
type Row = {
  title?: string | null; variety?: string | null; gem_type?: string | null
  treatment?: string | null; description?: string | null; certification_lab?: string | null
}

export const COLOURS: { key: string; label: string; swatch: string; re: RegExp }[] = [
  { key: 'blue',   label: 'Blue',              swatch: '#3D7FC4', re: /\b(blue|neon|indicolite|aquamarine|cobalt|electric)\b/i },
  { key: 'teal',   label: 'Teal & lagoon',     swatch: '#2BA79B', re: /\b(teal|lagoon|seafoam|sea\s?foam|paraiba|blue[\s-]?green|bluish)\b/i },
  { key: 'green',  label: 'Green',             swatch: '#4F9A4A', re: /\b(green|mint|emerald|peridot|chrome|tsavorite|verdelite)\b/i },
  { key: 'pink',   label: 'Pink',              swatch: '#E07AA6', re: /\b(pink|rubell?ite|rubelite|rubilite|kunzite|morganite|rose)\b/i },
  { key: 'purple', label: 'Purple',            swatch: '#8A5BB5', re: /\b(purple|violet|lilac|lavender|amethyst|tanzanite)\b/i },
  { key: 'red',    label: 'Red',               swatch: '#B8323A', re: /\b(red|ruby|crimson)\b/i },
  { key: 'yellow', label: 'Yellow & orange',   swatch: '#E0A33A', re: /\b(yellow|golden|orange|citrine|peach|sunset|imperial|heliodor|spessartite|champagne)\b/i },
  { key: 'multi',  label: 'Bi-colour & multi', swatch: 'linear-gradient(135deg,#E07AA6 0 50%,#4F9A4A 50% 100%)', re: /\b(bi[\s-]?colou?r|tri[\s-]?colou?r|watermelon|multi[\s-]?colou?r|rainbow)\b/i },
]

export const COLLECTIONS: { key: string; label: string; blurb: string; test: (r: Row) => boolean }[] = [
  { key: 'pairs',     label: 'Matching pairs', blurb: 'For earrings and designs', test: r => /\bpairs?\b/i.test(r.title ?? '') },
  { key: 'lots',      label: 'Lots & parcels', blurb: 'Several stones, one price', test: r => /\b(lots?|parcels?)\b/i.test(r.title ?? '') },
  { key: 'untreated', label: 'Untreated',      blurb: 'No heat, no oil',           test: r => {
      // The seller's treatment field wins: anything filled in other than "none" = treated.
      const t = (r.treatment ?? '').trim()
      if (t) return /^(none|no treatment|untreated|unheated|not treated|natural)\b/i.test(t)
      // Otherwise the text must say untreated and must not also name a treatment.
      const text = `${r.title ?? ''} ${r.description ?? ''}`
      const withoutNegations = text.replace(/\b(untreated|unheated|not heated|no heat(ing)?|no oil(ing)?)\b/gi, '')
      return /\b(untreated|unheated|no heat|no oil|not heated)\b/i.test(text) &&
        !/\b(heated|heat[- ]treated|oiled|filled|irradiated|diffused|dyed)\b/i.test(withoutNegations)
    } },
  { key: 'certified', label: 'Certified',      blurb: 'With a lab report',         test: r => (r.certification_lab ?? '').trim() !== '' },
]

export function colourKeys(r: Row): string[] {
  const text = `${r.title ?? ''} ${r.variety ?? ''} ${r.gem_type ?? ''}`
  return COLOURS.filter(c => c.re.test(text)).map(c => c.key)
}

export function inCollection(r: Row, key: string): boolean {
  return COLLECTIONS.find(c => c.key === key)?.test(r) ?? false
}

/** "Ships in 3 days" — seller's prep days, else the GemWorkers standard. */
export function shipsIn(prepDays: number | null | undefined): string {
  return prepDays && prepDays > 0 ? `Ships in ${prepDays} ${prepDays === 1 ? 'day' : 'days'}` : 'Ships in 3–5 days'
}
