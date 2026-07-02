'use client'

export function AmbientBackground() {
  return (
    <div
      aria-hidden="true"
      style={{
        position: 'fixed', inset: 0, zIndex: 0,
        pointerEvents: 'none', overflow: 'hidden',
      }}
    >
      {/* Sapphire glow — top left */}
      <div style={{
        position: 'absolute',
        top: '-15%', left: '-10%',
        width: '60vw', height: '60vw',
        background: 'radial-gradient(ellipse, rgba(41,64,122,0.22) 0%, rgba(26,36,64,0.08) 45%, transparent 70%)',
        animation: 'orb-drift-1 90s ease-in-out infinite',
        willChange: 'transform',
      }} />

      {/* Emerald glow — bottom right */}
      <div style={{
        position: 'absolute',
        bottom: '-20%', right: '-8%',
        width: '52vw', height: '52vw',
        background: 'radial-gradient(ellipse, rgba(27,80,55,0.22) 0%, rgba(18,40,31,0.08) 45%, transparent 70%)',
        animation: 'orb-drift-2 75s ease-in-out infinite',
        willChange: 'transform',
      }} />

      {/* Champagne glow — center right */}
      <div style={{
        position: 'absolute',
        top: '25%', right: '15%',
        width: '38vw', height: '38vw',
        background: 'radial-gradient(ellipse, rgba(201,169,98,0.09) 0%, rgba(201,169,98,0.03) 50%, transparent 70%)',
        animation: 'orb-drift-3 65s ease-in-out infinite',
        willChange: 'transform',
      }} />
    </div>
  )
}
