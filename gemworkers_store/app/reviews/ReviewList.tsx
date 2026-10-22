import { countryName } from '@/lib/countries'
import { Stars } from './Stars'

// public_reviews row (approved only; no buyer or seller data).
export type PublicReview = {
  id: string
  rating: number
  body: string | null
  photo_url: string | null
  reviewer_name: string | null
  reviewer_country: string | null
  owner_reply: string | null
  created_at: string
  maker_id: string | null
  stone_title: string | null
}

export function reviewAverage(reviews: PublicReview[]): number | null {
  if (reviews.length === 0) return null
  return reviews.reduce((s, r) => s + Number(r.rating), 0) / reviews.length
}

function formatDate(iso: string) {
  return new Date(iso).toLocaleDateString('en-IE', { day: 'numeric', month: 'short', year: 'numeric', timeZone: 'UTC' })
}

export function ReviewList({ reviews }: { reviews: PublicReview[] }) {
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 18 }}>
      {reviews.map(r => {
        const who = [r.reviewer_name || 'A GemWorkers customer', countryName(r.reviewer_country)]
          .filter(Boolean).join(', ')
        return (
          <article
            key={r.id}
            style={{ padding: '22px 26px', border: '1px solid #ECE5D8', borderRadius: 14, background: '#FFFFFF' }}
          >
            <div style={{ display: 'flex', justifyContent: 'space-between', gap: 12, flexWrap: 'wrap', alignItems: 'center' }}>
              <Stars rating={Number(r.rating)} />
              <span style={{ fontSize: 13, color: '#6B6052' }}>{formatDate(r.created_at)}</span>
            </div>
            <p style={{ fontSize: 14, fontWeight: 600, color: '#1F1B16', margin: '10px 0 0' }}>{who}</p>
            {r.stone_title && (
              <p style={{ fontSize: 13, color: '#6B6052', margin: '2px 0 0' }}>Bought: {r.stone_title}</p>
            )}
            {r.body && (
              <p style={{ fontSize: 15, lineHeight: 1.7, color: '#374151', margin: '12px 0 0', whiteSpace: 'pre-wrap' }}>
                {r.body}
              </p>
            )}
            {r.photo_url && (
              // eslint-disable-next-line @next/next/no-img-element
              <img
                src={r.photo_url}
                alt={`Photo from ${r.reviewer_name || 'a customer'}`}
                style={{ marginTop: 14, maxWidth: 220, maxHeight: 220, borderRadius: 10, objectFit: 'cover', display: 'block' }}
              />
            )}
            {r.owner_reply && (
              <div style={{ marginTop: 14, padding: '12px 16px', background: '#F9F5EE', borderRadius: 10 }}>
                <p style={{ fontSize: 11, fontWeight: 700, letterSpacing: '0.12em', textTransform: 'uppercase', color: '#7A5A22', margin: 0 }}>
                  Reply from GemWorkers
                </p>
                <p style={{ fontSize: 14, lineHeight: 1.6, color: '#374151', margin: '6px 0 0', whiteSpace: 'pre-wrap' }}>
                  {r.owner_reply}
                </p>
              </div>
            )}
          </article>
        )
      })}
    </div>
  )
}
