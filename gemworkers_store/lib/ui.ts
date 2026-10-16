import type { CSSProperties } from 'react'

// Shared button, panel and input styles (stone page, cart, orders, auth).

const pillBase: CSSProperties = {
  display: 'flex', alignItems: 'center', justifyContent: 'center',
  width: '100%', height: 52, padding: '0 24px', borderRadius: 28,
  fontSize: 15, fontWeight: 500, textDecoration: 'none',
  fontFamily: 'var(--font-inter, system-ui)', boxSizing: 'border-box',
}

export const pillDark: CSSProperties = {
  ...pillBase, background: '#1F1B16', color: '#F3EDE2',
  border: '1px solid #1F1B16', cursor: 'pointer',
}

export const pillOutline: CSSProperties = {
  ...pillBase, background: 'transparent', color: '#1F1B16',
  border: '1px solid #1F1B16', cursor: 'pointer',
}

export const pillDisabled: CSSProperties = {
  ...pillBase, background: '#F4EEE4', color: '#6B6052',
  border: '1px solid #ECE5D8', cursor: 'not-allowed',
}

// Smaller pills used inside confirm / offer panels
export const pillDarkSm: CSSProperties  = { ...pillDark,    height: 44, fontSize: 14 }
export const pillOutlineSm: CSSProperties = { ...pillOutline, height: 44, fontSize: 14 }
export const pillDisabledSm: CSSProperties = { ...pillDisabled, height: 44, fontSize: 14 }

export const panel: CSSProperties = {
  border: '1px solid #ECE5D8', borderRadius: 18,
  padding: '18px 20px', background: '#FFFFFF',
}

export const errorPanel: CSSProperties = {
  border: '1px solid rgba(180,35,24,0.25)', borderRadius: 18,
  padding: '16px 20px', background: 'rgba(180,35,24,0.06)',
}

// Same input look as the contact form
export const inputStyle: CSSProperties = {
  width: '100%', padding: '9px 12px', fontSize: 14,
  color: '#1F1B16', background: '#F4EEE4',
  border: '1px solid #ECE5D8', borderRadius: 6,
  boxSizing: 'border-box', outline: 'none',
  fontFamily: 'var(--font-inter, system-ui)',
}

export const labelStyle: CSSProperties = {
  display: 'block', fontSize: 11, fontWeight: 600,
  color: '#5A5045', marginBottom: 6, letterSpacing: '0.06em',
  fontFamily: 'var(--font-inter, system-ui)',
}
