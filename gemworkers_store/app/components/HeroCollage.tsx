import Link from 'next/link'

// Homepage hero picture made from the listed stones themselves (first photo
// of up to 4), so it is never empty and always shows what is for sale.
// 1 stone fills the box · 2 side by side · 3 = one large + two small · 4 = 2×2.
export type HeroStone = { id: string; title: string; image_url: string }

export function HeroCollage({ stones }: { stones: HeroStone[] }) {
  const s = stones.slice(0, 4)
  const n = s.length
  const grid =
    n === 1 ? { cols: '1fr', rows: '1fr' }
    : n === 2 ? { cols: '1fr 1fr', rows: '1fr' }
    : { cols: '1fr 1fr', rows: '1fr 1fr' }

  return (
    <div
      className="home-hero-media"
      style={{ display: 'grid', gap: 10, gridTemplateColumns: grid.cols, gridTemplateRows: grid.rows, overflow: 'hidden' }}
    >
      {s.map((stone, i) => (
        <Link
          key={stone.id}
          href={`/stones/${stone.id}`}
          aria-label={stone.title}
          style={{
            position: 'relative', display: 'block', overflow: 'hidden', borderRadius: 18, background: '#E9E1D2',
            // 3 stones: the first one takes the whole left column.
            ...(n === 3 && i === 0 ? { gridRow: '1 / span 2' } : {}),
          }}
        >
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img
            src={stone.image_url}
            alt={stone.title}
            loading={i === 0 ? 'eager' : 'lazy'}
            style={{ width: '100%', height: '100%', objectFit: 'cover', display: 'block', transition: 'transform 400ms ease' }}
            className="home-hero-tile"
          />
        </Link>
      ))}
    </div>
  )
}
