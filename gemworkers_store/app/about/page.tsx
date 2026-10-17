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
    </ContentPage>
  )
}
