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
