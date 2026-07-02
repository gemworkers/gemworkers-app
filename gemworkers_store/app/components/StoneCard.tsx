import Link from 'next/link'

const eur = new Intl.NumberFormat('en-IE', {
  style: 'currency', currency: 'EUR', maximumFractionDigits: 0,
})

export type StoneCardItem = {
  id: string
  title: string
  gem_type: string | null
  variety: string | null
  weight_value: number | null
  weight_unit: string | null
  origin_country?: string | null
  selling_price: number | null
  sale_method: string | null
  shipping_cost: number | null
  image_url: string | null
}

export function StoneCard({ item, index = 0 }: { item: StoneCardItem; index?: number }) {
  const gemLabel    = item.variety?.trim() || item.gem_type?.trim() || null
  const originLabel = item.origin_country?.trim() || null
  const subtitle    = [gemLabel, originLabel].filter(Boolean).join(' · ')
  const initial     = gemLabel ? gemLabel.charAt(0).toUpperCase() : '◇'
  const hasWeight   = item.weight_value != null && Number(item.weight_value) > 0
  const cost        = item.shipping_cost == null ? null : Number(item.shipping_cost)

  return (
    <Link
      href={`/stones/${item.id}`}
      className="stone-card fade-up"
      style={{
        '--fade-delay': `${Math.min(index * 70, 560)}ms`,
        display: 'block', textDecoration: 'none', color: 'inherit',
        border: '1px solid #2a2a30', borderRadius: 8, overflow: 'hidden',
        background: '#16161a',
      } as React.CSSProperties}
    >
      {/* ── Image ── */}
      <div style={{ position: 'relative', aspectRatio: '1', overflow: 'hidden', background: '#1e1e24' }}>
        {item.image_url ? (
          // eslint-disable-next-line @next/next/no-img-element
          <img
            src={item.image_url}
            alt={item.title}
            style={{ width: '100%', height: '100%', objectFit: 'cover', display: 'block' }}
          />
        ) : (
          <div style={{
            width: '100%', height: '100%',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            background: 'linear-gradient(145deg, #1e1e24 0%, #252530 100%)',
          }}>
            <span style={{
              fontSize: 52, color: '#3a3530', fontWeight: 300, lineHeight: 1,
              fontFamily: 'var(--font-cormorant, Georgia, serif)', userSelect: 'none',
            }}>
              {initial}
            </span>
          </div>
        )}

        {hasWeight && (
          <div style={{
            position: 'absolute', top: 8, right: 8,
            background: 'rgba(14,14,16,0.85)', backdropFilter: 'blur(6px)',
            borderRadius: 4, padding: '2px 8px',
            fontSize: 10, fontWeight: 600, color: '#c9a962', letterSpacing: '0.08em',
            fontFamily: 'var(--font-inter, system-ui)',
          }}>
            {item.weight_value} {item.weight_unit}
          </div>
        )}
      </div>

      {/* ── Body ── */}
      <div style={{ padding: '13px 14px 15px' }}>
        <p style={{
          fontSize: 15, fontWeight: 500, color: '#f5f0e8',
          lineHeight: 1.3, marginBottom: subtitle ? 4 : 10,
          fontFamily: 'var(--font-cormorant, Georgia, serif)',
        }}>
          {item.title}
        </p>

        {subtitle && (
          <p style={{
            fontSize: 11, color: '#9d9080', marginBottom: 10,
            lineHeight: 1.4, letterSpacing: '0.04em',
            fontFamily: 'var(--font-inter, system-ui)',
          }}>
            {subtitle}
          </p>
        )}

        {item.sale_method === 'accept_offers' ? (
          <p style={{
            fontSize: 14, color: '#c9a962', fontStyle: 'italic',
            fontFamily: 'var(--font-cormorant, Georgia, serif)',
          }}>
            Accepting offers
          </p>
        ) : item.selling_price != null ? (
          <p style={{
            fontSize: 19, fontWeight: 600, color: '#f5f0e8',
            letterSpacing: '-0.01em',
            fontFamily: 'var(--font-cormorant, Georgia, serif)',
          }}>
            {eur.format(Number(item.selling_price))}
          </p>
        ) : (
          <p style={{ fontSize: 13, color: '#4a4440', fontFamily: 'var(--font-inter, system-ui)' }}>—</p>
        )}

        {cost !== null && (
          <p style={{
            fontSize: 10, marginTop: 5, letterSpacing: '0.04em',
            color: cost === 0 ? '#7a6234' : '#5c5346',
            fontFamily: 'var(--font-inter, system-ui)',
          }}>
            {cost === 0 ? 'Free shipping' : `+ €${cost.toFixed(0)} shipping`}
          </p>
        )}
      </div>
    </Link>
  )
}
