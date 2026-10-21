// Detects a link to a GemWorkers stone page inside a message body, so the
// message can carry that stone as its linked_inventory_item_id.
//
//   https://gemworkers.com/stones/{uuid}, www.gemworkers.com/stones/{uuid}, …
//   localhost[:port]/stones/{uuid} and 127.0.0.1 — development only
//
// Only the first link counts (messages carry at most one linked stone).

const UUID = '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}'

const PROD_HOST = '(?:[a-z0-9-]+\\.)*gemworkers\\.com'
const DEV_HOST  = '(?:localhost|127\\.0\\.0\\.1)'

function stoneLinkRegex(): RegExp {
  const host = process.env.NODE_ENV === 'production'
    ? PROD_HOST
    : `(?:${PROD_HOST}|${DEV_HOST})`
  // Not preceded by a host character (so "evilgemworkers.com" never matches),
  // optional scheme and port, then /stones/{uuid} not followed by more id chars.
  return new RegExp(
    `(?<![a-z0-9.@-])(?:https?:\\/\\/)?${host}(?::\\d+)?\\/stones\\/(${UUID})(?![0-9a-f-])`,
    'i'
  )
}

// First stone id linked in the text (lower-cased), or null.
export function findLinkedStoneId(text: string): string | null {
  const match = stoneLinkRegex().exec(text)
  return match ? match[1].toLowerCase() : null
}
