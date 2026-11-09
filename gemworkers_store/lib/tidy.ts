// Display-only tidy-up of seller-typed text (titles, places). Never changes
// words: only spaces around punctuation, stray symbols and capitals.
export function tidyTitle(t: string | null | undefined): string {
  let s = (t ?? '').replace(/\s+/g, ' ').trim()
  s = s.replace(/\s+([,.;:!?])/g, '$1')        // "Burma , Heated" → "Burma, Heated"
  s = s.replace(/([,;:])(?=\S)/g, '$1 ')        // "a,b" → "a, b"
  s = s.replace(/[\s~,;:\-–|]+$/g, '')           // trailing "~", ",", "-"
  s = s.replace(/^[\s~,;:\-–|]+/g, '')
  s = s.replace(/\bburma\b/g, 'Burma').replace(/\bceylon\b/g, 'Ceylon').replace(/\bafghanistan\b/g, 'Afghanistan')
    .replace(/\bpakistan\b/g, 'Pakistan')
  return s ? s[0].toUpperCase() + s.slice(1) : s
}

/** "burma" → "Burma", "sri lanka" → "Sri Lanka". */
export function tidyPlace(p: string | null | undefined): string | null {
  const s = (p ?? '').replace(/\s+/g, ' ').trim()
  return s ? s.replace(/\b\p{L}/gu, c => c.toUpperCase()) : null
}
