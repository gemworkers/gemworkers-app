import { ContentPage } from '@/app/components/ContentPage'

export default function AboutPage() {
  return (
    <ContentPage eyebrow="About" title="About GemWorkers">
      <p>
        GemWorkers is a curated house of fine gemstones — loose stones, mineral
        specimens, and jewellery — sourced directly from the cutters and gem workers
        whose craft defines them. Every piece is selected by hand, with an eye for
        quality, character, and provenance.
      </p>
      <p>
        We work with a small circle of specialist artisans: lapidaries who have spent
        decades at the wheel, buyers who travel to origin, and craftspeople who treat
        each stone as the subject — not the material. What you find here you will not
        find on a wholesale shelf.
      </p>
      <p>
        {/* placeholder — replace with full brand story */}
        More about our origins, values, and approach coming soon.
      </p>

      <div className="not-prose" style={{
        marginTop: 56,
        paddingTop: 40,
        borderTop: '1px solid #2a2a30',
        display: 'flex',
        gap: 48,
        flexWrap: 'wrap',
      }}>
        {[
          { label: 'Founded', value: '2024' },
          { label: 'Makers',  value: 'Small circle' },
          { label: 'Origin',  value: 'Direct source' },
        ].map(stat => (
          <div key={stat.label}>
            <p style={{
              fontSize: 10,
              fontWeight: 700,
              letterSpacing: '0.12em',
              color: '#9d9080',
              textTransform: 'uppercase',
              marginBottom: 6,
              fontFamily: 'var(--font-inter, system-ui)',
            }}>
              {stat.label}
            </p>
            <p style={{
              fontSize: 22,
              fontWeight: 400,
              color: '#f5f0e8',
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
