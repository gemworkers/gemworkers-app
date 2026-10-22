import { createClient } from '@/lib/supabase/server'
import { ReviewList, reviewAverage, type PublicReview } from './ReviewList'
import { Stars } from './Stars'

export const metadata = { title: 'Customer Reviews · GemWorkers' }

export default async function ReviewsPage() {
  const supabase = await createClient()
  const { data } = await supabase
    .from('public_reviews')
    .select('id, rating, body, photo_url, reviewer_name, reviewer_country, owner_reply, created_at, maker_id, stone_title')
    .order('created_at', { ascending: false })
    .limit(200)
  const reviews = (data ?? []) as PublicReview[]
  const avg = reviewAverage(reviews)

  return (
    <main style={{ maxWidth: 760, margin: '0 auto', padding: '72px 32px 100px' }}>
      <p style={{
        fontSize: 11, fontWeight: 700, letterSpacing: '0.14em',
        color: '#9ca3af', textTransform: 'uppercase', marginBottom: 16,
      }}>
        Reviews
      </p>
      <h1 style={{
        fontSize: 38, fontWeight: 700, color: '#111',
        fontFamily: "Georgia, 'Times New Roman', serif",
        lineHeight: 1.15, marginBottom: 16,
      }}>
        What Our Customers Say
      </h1>
      <p style={{ fontSize: 16, lineHeight: 1.7, color: '#374151', marginBottom: 32, maxWidth: 620 }}>
        Every review comes from a customer who bought and received a stone from GemWorkers.
      </p>

      {avg !== null ? (
        <>
          <div style={{ display: 'flex', alignItems: 'center', gap: 14, marginBottom: 32, flexWrap: 'wrap' }}>
            <span style={{ fontSize: 34, fontWeight: 700, color: '#1F1B16', fontFamily: "Georgia, 'Times New Roman', serif" }}>
              {avg.toFixed(1)}
            </span>
            <Stars rating={avg} size={22} />
            <span style={{ fontSize: 14, color: '#6B6052' }}>
              {reviews.length} review{reviews.length === 1 ? '' : 's'}
            </span>
          </div>
          <ReviewList reviews={reviews} />
        </>
      ) : (
        <div style={{ padding: '36px 40px', border: '1px solid #e5e7eb', borderRadius: 12, background: '#fff', maxWidth: 520 }}>
          <p style={{ fontSize: 15, color: '#374151', margin: 0, lineHeight: 1.7 }}>
            Our first customer reviews will appear here soon.
          </p>
        </div>
      )}
    </main>
  )
}
