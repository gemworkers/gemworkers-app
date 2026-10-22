import Link from 'next/link'
import { createClient } from '@/lib/supabase/server'

// "★ 4.9 · 12 customer reviews" linking to /reviews. Renders nothing until
// there is at least one approved review (public_reviews is approved only).
export async function ReviewSummary({ style }: { style?: React.CSSProperties }) {
  const supabase = await createClient()
  const { data } = await supabase.from('public_reviews').select('rating')
  const ratings = (data ?? []).map(r => Number((r as { rating: number | string }).rating))
  if (ratings.length === 0) return null

  const avg = ratings.reduce((s, n) => s + n, 0) / ratings.length
  return (
    <Link
      href="/reviews"
      style={{
        display: 'inline-flex', alignItems: 'center', gap: 8, fontSize: 14,
        color: '#5A5045', textDecoration: 'none', ...style,
      }}
    >
      <span style={{ color: '#B8860B', letterSpacing: 1 }} aria-hidden="true">★</span>
      <strong style={{ color: '#1F1B16' }}>{avg.toFixed(1)}</strong>
      <span style={{ textDecoration: 'underline', textUnderlineOffset: 3 }}>
        {ratings.length} customer review{ratings.length === 1 ? '' : 's'}
      </span>
    </Link>
  )
}
