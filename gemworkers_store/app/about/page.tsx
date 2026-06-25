export default function AboutPage() {
  return (
    <main style={{ maxWidth: 760, margin: '0 auto', padding: '72px 32px 100px' }}>

      <p style={{
        fontSize: 11, fontWeight: 700, letterSpacing: '0.14em',
        color: '#9ca3af', textTransform: 'uppercase', marginBottom: 16,
      }}>
        About
      </p>

      <h1 style={{
        fontSize: 38, fontWeight: 700, color: '#111',
        fontFamily: "Georgia, 'Times New Roman', serif",
        lineHeight: 1.15, marginBottom: 36,
      }}>
        About GemWorkers
      </h1>

      <div style={{ display: 'flex', flexDirection: 'column', gap: 20 }}>
        <p style={{ fontSize: 17, lineHeight: 1.75, color: '#374151', maxWidth: 640 }}>
          GemWorkers is a curated house of fine gemstones — loose stones, mineral
          specimens, and jewellery — sourced directly from the cutters and gem workers
          whose craft defines them. Every piece is selected by hand, with an eye for
          quality, character, and provenance.
        </p>
        <p style={{ fontSize: 17, lineHeight: 1.75, color: '#374151', maxWidth: 640 }}>
          We work with a small circle of specialist artisans: lapidaries who have spent
          decades at the wheel, buyers who travel to origin, and craftspeople who treat
          each stone as the subject — not the material. What you find here you will not
          find on a wholesale shelf.
        </p>
        <p style={{ fontSize: 15, lineHeight: 1.75, color: '#6b7280', maxWidth: 580, marginTop: 8 }}>
          {/* placeholder — replace with full brand story */}
          More about our origins, values, and approach coming soon.
        </p>
      </div>

      <div style={{
        marginTop: 56, paddingTop: 40, borderTop: '1px solid #e5e7eb',
        display: 'flex', gap: 48, flexWrap: 'wrap',
      }}>
        {[
          { label: 'Founded', value: '2024' },
          { label: 'Makers', value: 'Small circle' },
          { label: 'Origin', value: 'Direct source' },
        ].map(stat => (
          <div key={stat.label}>
            <p style={{
              fontSize: 10, fontWeight: 700, letterSpacing: '0.12em',
              color: '#9ca3af', textTransform: 'uppercase', marginBottom: 6,
            }}>
              {stat.label}
            </p>
            <p style={{
              fontSize: 20, fontWeight: 700, color: '#111',
              fontFamily: "Georgia, 'Times New Roman', serif",
            }}>
              {stat.value}
            </p>
          </div>
        ))}
      </div>

    </main>
  )
}
