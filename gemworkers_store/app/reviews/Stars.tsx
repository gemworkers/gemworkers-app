// Read-only star row for reviews (1–5).
export function Stars({ rating, size = 16 }: { rating: number; size?: number }) {
  const full = Math.round(rating)
  return (
    <span aria-label={`${rating} out of 5 stars`} style={{ color: '#B8860B', fontSize: size, letterSpacing: 2 }}>
      {'★'.repeat(full)}
      <span style={{ color: '#DDD3C2' }}>{'★'.repeat(5 - full)}</span>
    </span>
  )
}
