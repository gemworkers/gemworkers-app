export default function ContactPage() {
  return (
    <main style={{ maxWidth: 760, margin: '0 auto', padding: '72px 32px 100px' }}>

      <p style={{
        fontSize: 11, fontWeight: 700, letterSpacing: '0.14em',
        color: '#9ca3af', textTransform: 'uppercase', marginBottom: 16,
      }}>
        Contact
      </p>

      <h1 style={{
        fontSize: 38, fontWeight: 700, color: '#111',
        fontFamily: "Georgia, 'Times New Roman', serif",
        lineHeight: 1.15, marginBottom: 36,
      }}>
        Get in Touch
      </h1>

      <p style={{ fontSize: 17, lineHeight: 1.75, color: '#374151', maxWidth: 580, marginBottom: 48 }}>
        Questions about a stone, a commission, working with us as a maker, or anything
        else — we read every message and reply personally.
      </p>

      <div style={{ display: 'flex', flexDirection: 'column', gap: 0, maxWidth: 440 }}>
        {[
          {
            label: 'General enquiries',
            value: 'hello@gemworkers.com',
            href: 'mailto:hello@gemworkers.com',
          },
          {
            label: 'Trade & wholesale',
            value: 'trade@gemworkers.com',
            href: 'mailto:trade@gemworkers.com',
          },
        ].map((row, i, arr) => (
          <div
            key={row.label}
            style={{
              padding: '24px 0',
              borderBottom: i < arr.length - 1 ? '1px solid #f3f4f6' : 'none',
            }}
          >
            <p style={{
              fontSize: 11, fontWeight: 700, letterSpacing: '0.1em',
              color: '#9ca3af', textTransform: 'uppercase', marginBottom: 8,
            }}>
              {row.label}
            </p>
            <a
              href={row.href}
              style={{
                fontSize: 16, color: '#111', textDecoration: 'none',
                fontFamily: "Georgia, 'Times New Roman', serif",
              }}
            >
              {row.value}
            </a>
          </div>
        ))}
      </div>

      <p style={{ fontSize: 13, color: '#9ca3af', marginTop: 48, maxWidth: 480, lineHeight: 1.7 }}>
        {/* placeholder — replace with real response-time note or form */}
        A contact form and response-time note will be added here. For now, email is the
        fastest way to reach us.
      </p>

    </main>
  )
}
