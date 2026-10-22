import Link from 'next/link'
import { createClient } from '@/lib/supabase/server'
import { formatEur } from '@/lib/money'
import { ReviewList, reviewAverage, type PublicReview } from '@/app/reviews/ReviewList'
import { Stars } from '@/app/reviews/Stars'

export const metadata = { title: 'Our Makers · GemWorkers' }

// public.makers is readable by everyone (owner-managed profiles). Stones come
// from public_listings, so only listed + available stones are shown.
type Maker = {
  id: string
  name: string
  place: string | null
  story: string | null
  photo_url: string | null
}

type MakerStone = {
  id: string
  title: string
  image_url: string | null
  selling_price: number | string | null
  sale_method: string | null
  maker_id: string
}

export default async function MakersPage() {
  const supabase = await createClient()

  const { data: makerData } = await supabase
    .from('makers')
    .select('id, name, place, story, photo_url')
    .order('name')
  const makers = (makerData ?? []) as Maker[]

  const stonesByMaker = new Map<string, MakerStone[]>()
  const reviewsByMaker = new Map<string, PublicReview[]>()
  if (makers.length > 0) {
    const { data: reviewData } = await supabase
      .from('public_reviews')
      .select('id, rating, body, photo_url, reviewer_name, reviewer_country, owner_reply, created_at, maker_id, stone_title')
      .in('maker_id', makers.map(m => m.id))
      .order('created_at', { ascending: false })
    for (const r of (reviewData ?? []) as PublicReview[]) {
      if (r.maker_id) reviewsByMaker.set(r.maker_id, [...(reviewsByMaker.get(r.maker_id) ?? []), r])
    }

    const { data: stoneData } = await supabase
      .from('public_listings')
      .select('id, title, image_url, selling_price, sale_method, maker_id')
      .in('maker_id', makers.map(m => m.id))
    for (const s of (stoneData ?? []) as MakerStone[]) {
      stonesByMaker.set(s.maker_id, [...(stonesByMaker.get(s.maker_id) ?? []), s])
    }
  }

  return (
    <main style={{ maxWidth: 760, margin: '0 auto', padding: '72px 32px 100px' }}>

      <p style={{
        fontSize: 11, fontWeight: 700, letterSpacing: '0.14em',
        color: '#9ca3af', textTransform: 'uppercase', marginBottom: 16,
      }}>
        Our Makers
      </p>

      <h1 style={{
        fontSize: 38, fontWeight: 700, color: '#111',
        fontFamily: "Georgia, 'Times New Roman', serif",
        lineHeight: 1.15, marginBottom: 36,
      }}>
        The People Behind the Stones
      </h1>

      <div style={{ display: 'flex', flexDirection: 'column', gap: 20 }}>
        <p style={{ fontSize: 17, lineHeight: 1.75, color: '#374151', maxWidth: 640 }}>
          Every stone on GemWorkers exists because of a craftsperson who chose to work
          with it — a lapidary who spent hours at the wheel reading the rough, a gem
          buyer who travelled to source it, a cutter who made a dozen decisions before
          the first facet was ground.
        </p>
        <p style={{ fontSize: 17, lineHeight: 1.75, color: '#374151', maxWidth: 640 }}>
          Our makers are a deliberately small group: specialists whose reputations rest
          on the quality of what they produce, not the volume. We work with each of them
          closely, and we believe knowing who cut a stone changes how you see it.
        </p>
      </div>

      {makers.length === 0 ? (
        <div style={{
          marginTop: 56, padding: '36px 40px',
          border: '1px solid #e5e7eb', borderRadius: 12,
          background: '#fff', maxWidth: 520,
        }}>
          <p style={{
            fontSize: 13, fontWeight: 700, color: '#111',
            fontFamily: "Georgia, 'Times New Roman', serif",
            marginBottom: 10,
          }}>
            Maker profiles coming soon
          </p>
          <p style={{ fontSize: 13, lineHeight: 1.7, color: '#6b7280' }}>
            Individual profiles — with background, specialities, and current work — will
            be published here as we build out this section.
          </p>
        </div>
      ) : (
        <div style={{ marginTop: 56, display: 'flex', flexDirection: 'column', gap: 28 }}>
          {makers.map(m => {
            const stones = stonesByMaker.get(m.id) ?? []
            const makerReviews = reviewsByMaker.get(m.id) ?? []
            const makerAvg = reviewAverage(makerReviews)
            return (
              <section
                key={m.id}
                id={`maker-${m.id}`}
                style={{
                  padding: '28px 32px', border: '1px solid #e5e7eb', borderRadius: 12,
                  background: '#fff', scrollMarginTop: 96,
                }}
              >
                <div style={{ display: 'flex', gap: 20, alignItems: 'center', flexWrap: 'wrap' }}>
                  {m.photo_url && (
                    // eslint-disable-next-line @next/next/no-img-element
                    <img
                      src={m.photo_url}
                      alt={m.name}
                      style={{ width: 88, height: 88, borderRadius: '50%', objectFit: 'cover', flexShrink: 0 }}
                    />
                  )}
                  <div style={{ minWidth: 0 }}>
                    <h2 style={{
                      fontSize: 24, fontWeight: 700, color: '#111', margin: 0,
                      fontFamily: "Georgia, 'Times New Roman', serif", lineHeight: 1.2,
                    }}>
                      {m.name}
                    </h2>
                    {m.place && (
                      <p style={{ fontSize: 14, color: '#6b7280', margin: '6px 0 0' }}>{m.place}</p>
                    )}
                    {makerAvg !== null && (
                      <p style={{ fontSize: 13, color: '#6b7280', margin: '6px 0 0', display: 'flex', alignItems: 'center', gap: 8 }}>
                        <Stars rating={makerAvg} size={14} />
                        {makerAvg.toFixed(1)} · {makerReviews.length} review{makerReviews.length === 1 ? '' : 's'}
                      </p>
                    )}
                  </div>
                </div>

                {m.story && (
                  <p style={{
                    fontSize: 16, lineHeight: 1.75, color: '#374151',
                    margin: '20px 0 0', whiteSpace: 'pre-wrap',
                  }}>
                    {m.story}
                  </p>
                )}

                {makerReviews.length > 0 && (
                  <div style={{ marginTop: 24 }}>
                    <p style={{
                      fontSize: 11, fontWeight: 700, letterSpacing: '0.12em',
                      color: '#9ca3af', textTransform: 'uppercase', margin: '0 0 12px',
                    }}>
                      What customers say
                    </p>
                    <ReviewList reviews={makerReviews.slice(0, 2)} />
                  </div>
                )}

                {stones.length > 0 && (
                  <div style={{ marginTop: 24 }}>
                    <p style={{
                      fontSize: 11, fontWeight: 700, letterSpacing: '0.12em',
                      color: '#9ca3af', textTransform: 'uppercase', margin: '0 0 12px',
                    }}>
                      Available now
                    </p>
                    <div style={{ display: 'flex', gap: 14, flexWrap: 'wrap' }}>
                      {stones.map(s => (
                        <Link
                          key={s.id}
                          href={`/stones/${s.id}`}
                          style={{ width: 150, textDecoration: 'none', color: '#111' }}
                        >
                          <div style={{
                            width: 150, height: 150, borderRadius: 10, overflow: 'hidden',
                            background: '#F4EEE4',
                          }}>
                            {s.image_url && (
                              // eslint-disable-next-line @next/next/no-img-element
                              <img src={s.image_url} alt={s.title}
                                style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
                            )}
                          </div>
                          <p style={{ fontSize: 14, fontWeight: 600, margin: '8px 0 2px', lineHeight: 1.3 }}>
                            {s.title}
                          </p>
                          <p style={{ fontSize: 13, color: '#6b7280', margin: 0 }}>
                            {s.sale_method === 'accept_offers' || s.selling_price == null
                              ? 'Make an offer'
                              : formatEur(s.selling_price)}
                          </p>
                        </Link>
                      ))}
                    </div>
                  </div>
                )}
              </section>
            )
          })}
        </div>
      )}

    </main>
  )
}
