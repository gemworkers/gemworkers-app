'use client'

import { useEffect, useState } from 'react'
import Link from 'next/link'
import { isStaleVersionError, reloadForNewVersion } from '@/lib/stale-version'

// Error page for the whole store. A page left open from before an update
// (lib/stale-version.ts) just reloads; anything else gets a calm message.
export default function Error({ error, reset }: { error: Error & { digest?: string }; reset: () => void }) {
  const [reloading, setReloading] = useState(false)

  useEffect(() => {
    if (isStaleVersionError(error) && reloadForNewVersion()) setReloading(true)
  }, [error])

  return (
    <main className="pd-wrap" style={{ padding: '80px 16px', textAlign: 'center' }}>
      <h1 className="font-serif" style={{ fontSize: 32, marginBottom: 12 }}>
        {reloading ? 'Updating the page…' : 'Something went wrong'}
      </h1>
      {!reloading && (
        <>
          <p style={{ color: '#5A5045', marginBottom: 24 }}>
            Please try again. If it keeps happening, <Link href="/contact" className="pd-link">let us know</Link>.
          </p>
          <button type="button" onClick={() => reset()} className="home-btn home-btn-solid">Try again</button>
        </>
      )}
    </main>
  )
}
