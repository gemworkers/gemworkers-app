import Link from 'next/link'
import { ContentPage } from '@/app/components/ContentPage'

export default function AboutPage() {
  return (
    <ContentPage eyebrow="About" title="Our Story">
      <p>GemWorkers is a family story, generations deep.</p>
      <p>
        It began in Kunar, in eastern Afghanistan, where Zakaria&apos;s family has worked with
        gemstones for generations. More than thirty years ago, his father and uncles began
        trading gemstones themselves.
      </p>
      <p>
        Zakaria grew up in that world. In 2015 he began selling gemstones across Afghanistan
        and Pakistan, and after moving to the Netherlands he founded GemWorkers to bring
        fine gemstones to collectors and jewelry lovers around the world.
      </p>
      <p>
        Today we source from mines across Afghanistan and Pakistan, through trusted partners
        in Thailand, and from Africa, the Americas and Europe. We work with a small circle of
        experienced cutters and specialists, many of them family. Every piece is chosen by
        hand, described honestly, and shipped with care.
      </p>
      <p>
        Our promise is simple: natural stones, honest descriptions, and the kind of knowledge
        that only comes from generations in the trade. Read{' '}
        <Link href="/guarantee">Our Guarantee</Link>.
      </p>

      <div className="not-prose" style={{
        marginTop: 56,
        paddingTop: 40,
        borderTop: '1px solid #ECE5D8',
        display: 'flex',
        gap: 48,
        flexWrap: 'wrap',
      }}>
        {[
          { label: 'Founded', value: '2015' },
          { label: 'Makers',  value: '5+' },
          { label: 'Sourced', value: 'Worldwide' },
        ].map(stat => (
          <div key={stat.label}>
            <p style={{
              fontSize: 10,
              fontWeight: 700,
              letterSpacing: '0.12em',
              color: '#5A5045',
              textTransform: 'uppercase',
              marginBottom: 6,
              fontFamily: 'var(--font-inter, system-ui)',
            }}>
              {stat.label}
            </p>
            <p style={{
              fontSize: 22,
              fontWeight: 400,
              color: '#1F1B16',
              fontFamily: 'var(--font-cormorant, Georgia, serif)',
              margin: 0,
            }}>
              {stat.value}
            </p>
          </div>
        ))}
      </div>

      {/* Our record on Etsy (numbers as shown there, October 2026 — floors, so
          they stay true; update now and then). Only here, never on stone pages. */}
      <div className="not-prose" style={{ marginTop: 48, paddingTop: 32, borderTop: '1px solid #ECE5D8' }}>
        <h2 style={{ fontFamily: 'var(--font-cormorant, Georgia, serif)', fontSize: 26, fontWeight: 500, margin: '0 0 10px', color: '#1F1B16' }}>
          Trusted on Etsy since 2018
        </h2>
        <p style={{ fontSize: 15, color: '#5A5045', lineHeight: 1.6, margin: '0 0 16px' }}>
          Our family also sells through four GemWorkers shops on Etsy: together more than
          4,200 sales and 1,100 reviews, rated 4.8 to 5.0 stars. You can read every review there.
        </p>
        <ul style={{ listStyle: 'none', padding: 0, margin: 0, display: 'grid', gap: 6, fontSize: 14 }}>
          {[
            { name: 'GemWorkers1', url: 'https://www.etsy.com/shop/GemWorkers1', note: '★4.9 · 700+ reviews · 2,100+ sales' },
            { name: 'GemWorkers2', url: 'https://www.etsy.com/shop/GemWorkers2', note: '★4.8 · 400+ reviews · 1,900+ sales' },
            { name: 'GemWorkers', url: 'https://www.etsy.com/shop/GemWorkers', note: '★4.9 · 20+ reviews' },
            { name: 'GemWorkersEU', url: 'https://www.etsy.com/shop/GemWorkersEU', note: '★5.0' },
          ].map(s => (
            <li key={s.name}>
              <a href={s.url} target="_blank" rel="noopener noreferrer" className="pd-link">{s.name} on Etsy</a>
              <span style={{ color: '#6B6052' }}> — {s.note}</span>
            </li>
          ))}
        </ul>
      </div>
    </ContentPage>
  )
}
