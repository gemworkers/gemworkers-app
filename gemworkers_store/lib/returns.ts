// Shared by the server page (My orders) and the client ReturnPanel.

const DAY = 24 * 60 * 60 * 1000

// Same window as request_return: 30 days from delivery, or 60 days from
// shipping when delivery wasn't confirmed.
export function canRequestReturn(o: { status: string; received_at: string | null; shipped_at: string | null }): boolean {
  if (!['shipped', 'received', 'paid'].includes(o.status)) return false
  const now = Date.now()
  if (o.received_at) return now - new Date(o.received_at).getTime() <= 30 * DAY
  if (o.shipped_at) return now - new Date(o.shipped_at).getTime() <= 60 * DAY
  return true
}
