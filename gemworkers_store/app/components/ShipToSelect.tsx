'use client'

import { useRouter } from 'next/navigation'
import { useState } from 'react'

type Country = { code: string; name: string; region: string; enabled: boolean }

// Cookie name must match lib/ship-to.ts (SHIP_TO_COOKIE).
const COOKIE = 'gw_ship_to'

// "Ship to" chooser in the top bar. Saves the choice for a year and refreshes
// so stone pages, cart and checkout use it.
export function ShipToSelect({ countries, current }: { countries: Country[]; current: string }) {
  const router = useRouter()
  const [value, setValue] = useState(current)

  const regions: string[] = []
  for (const c of countries) if (!regions.includes(c.region)) regions.push(c.region)
  const known = countries.some(c => c.code === value)

  function choose(code: string) {
    setValue(code)
    document.cookie = `${COOKIE}=${code}; path=/; max-age=${60 * 60 * 24 * 365}; samesite=lax`
    router.refresh()
  }

  return (
    <label className="ship-to">
      <span className="ship-to-label">Ship to</span>
      <select
        value={value}
        onChange={e => choose(e.target.value)}
        aria-label="Ship to country"
        className="ship-to-select"
      >
        {!known && <option value={value}>{value}</option>}
        {regions.map(r => (
          <optgroup key={r} label={r}>
            {countries.filter(c => c.region === r).map(c => (
              <option key={c.code} value={c.code} disabled={!c.enabled}>
                {c.name}{c.enabled ? '' : ' — not available'}
              </option>
            ))}
          </optgroup>
        ))}
      </select>
    </label>
  )
}
