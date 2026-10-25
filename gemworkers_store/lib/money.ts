// Shared euro formatter for everything the store shows. Same rule as the
// offer-notify Edge Function: whole euros when the amount is a whole number
// (€55), otherwise exactly 2 decimals (€49.80) — never rounds cents away.

const eurWhole = new Intl.NumberFormat('en-IE', {
  style: 'currency', currency: 'EUR', maximumFractionDigits: 0,
})
const eurCents = new Intl.NumberFormat('en-IE', {
  style: 'currency', currency: 'EUR', minimumFractionDigits: 2, maximumFractionDigits: 2,
})

export function formatEur(amount: number | string): string {
  // Snap to cents first so float noise from sums (54.99999999) shows as €55,
  // not €55.00.
  const n = Math.round(Number(amount) * 100) / 100
  return Number.isInteger(n) ? eurWhole.format(n) : eurCents.format(n)
}

// Always 2 decimals (€49.80) — for places that must show the exact amount,
// e.g. the "Send offer of …" button.
export function formatEurExact(amount: number | string): string {
  return eurCents.format(Number(amount))
}

// Any currency the store charges in (EUR, USD, GBP, AUD, CAD) — same whole /
// 2-decimal rule. Each in its home style: $395 for a US buyer, £310, A$…
const LOCALE: Record<string, string> = { EUR: 'en-IE', USD: 'en-US', GBP: 'en-GB', AUD: 'en-AU', CAD: 'en-CA' }

export function formatMoney(amount: number | string, currency: string = 'EUR'): string {
  const code = (currency || 'EUR').toUpperCase()
  if (code === 'EUR') return formatEur(amount)
  const n = Math.round(Number(amount) * 100) / 100
  const digits = Number.isInteger(n) ? 0 : 2
  try {
    return new Intl.NumberFormat(LOCALE[code] ?? 'en-GB', {
      style: 'currency', currency: code, minimumFractionDigits: digits, maximumFractionDigits: digits,
    }).format(n)
  } catch {
    return `${n.toFixed(digits)} ${code}`
  }
}

// Always 2 decimals in any currency — invoices ($395.00).
export function formatMoneyExact(amount: number | string, currency: string = 'EUR'): string {
  const code = (currency || 'EUR').toUpperCase()
  if (code === 'EUR') return formatEurExact(amount)
  try {
    return new Intl.NumberFormat(LOCALE[code] ?? 'en-GB', {
      style: 'currency', currency: code, minimumFractionDigits: 2, maximumFractionDigits: 2,
    }).format(Number(amount))
  } catch {
    return `${Number(amount).toFixed(2)} ${code}`
  }
}
