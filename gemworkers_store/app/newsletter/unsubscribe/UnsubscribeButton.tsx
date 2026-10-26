'use client'

import { useState } from 'react'
import { unsubscribeNewsletter } from '@/app/actions/newsletter'
import { pillDarkSm } from '@/lib/ui'

export function UnsubscribeButton({ token }: { token: string }) {
  const [state, setState] = useState<'idle' | 'busy' | 'done' | 'failed'>('idle')
  if (state === 'done') return <p><strong>You&apos;re unsubscribed.</strong> Sorry to see you go.</p>

  async function unsubscribe() {
    setState('busy')
    const r = await unsubscribeNewsletter(token)
    setState(r.ok ? 'done' : 'failed')
  }

  return (
    <div>
      <button onClick={unsubscribe} disabled={state === 'busy'} style={{ ...pillDarkSm, width: 'auto', padding: '0 24px' }}>
        {state === 'busy' ? 'One moment…' : 'Unsubscribe'}
      </button>
      {state === 'failed' && (
        <p style={{ color: '#B42318' }}>This link is not valid. Please email hello@gemworkers.com and we&apos;ll remove you.</p>
      )}
    </div>
  )
}
