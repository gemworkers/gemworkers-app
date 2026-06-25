export default function JournalPage() {
  return (
    <main style={{ maxWidth: 760, margin: '0 auto', padding: '72px 32px 100px' }}>

      <p style={{
        fontSize: 11, fontWeight: 700, letterSpacing: '0.14em',
        color: '#9ca3af', textTransform: 'uppercase', marginBottom: 16,
      }}>
        Journal
      </p>

      <h1 style={{
        fontSize: 38, fontWeight: 700, color: '#111',
        fontFamily: "Georgia, 'Times New Roman', serif",
        lineHeight: 1.15, marginBottom: 36,
      }}>
        Journal
      </h1>

      <div style={{ display: 'flex', flexDirection: 'column', gap: 20 }}>
        <p style={{ fontSize: 17, lineHeight: 1.75, color: '#374151', maxWidth: 640 }}>
          Behind every stone is a process — rough selection, cutting decisions, polishing
          stages, buying trips to origin, time spent at exhibitions with other dealers
          and collectors. The journal is where that process becomes readable.
        </p>
        <p style={{ fontSize: 17, lineHeight: 1.75, color: '#374151', maxWidth: 640 }}>
          Expect field notes, cutting diaries, origin stories, and the occasional
          opinion on what makes a stone worth cutting in the first place.
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
          Posts coming soon
        </p>
        <p style={{ fontSize: 13, lineHeight: 1.7, color: '#6b7280' }}>
          The first entries are in progress. Check back shortly, or browse the
          stones while you wait.
        </p>
      </div>

    </main>
  )
}
