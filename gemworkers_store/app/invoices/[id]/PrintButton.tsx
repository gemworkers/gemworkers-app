'use client'

import { pillDarkSm } from '@/lib/ui'

export function PrintButton() {
  return (
    <button onClick={() => window.print()} className="no-print"
      style={{ ...pillDarkSm, width: 'auto', padding: '0 22px' }}>
      Print / save as PDF
    </button>
  )
}
