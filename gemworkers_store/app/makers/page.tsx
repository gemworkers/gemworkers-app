export default function MakersPage() {
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

    </main>
  )
}
