'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { saveBusinessDetails, removeBusinessDetails } from '@/app/actions/business'
import { inputStyle, labelStyle, pillDark, pillDisabled, pillOutlineSm } from '@/lib/ui'

export function BusinessForm({
  initialCompany,
  initialVat,
  hasDetails,
}: {
  initialCompany: string
  initialVat: string
  hasDetails: boolean
}) {
  const router = useRouter()
  const [company, setCompany] = useState(initialCompany)
  const [vat, setVat] = useState(initialVat)
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<{ text: string; error: boolean } | null>(null)

  const canSubmit = company.trim().length > 0 && !busy

  async function onSave(e: React.FormEvent) {
    e.preventDefault()
    setBusy(true)
    setMessage(null)
    const res = await saveBusinessDetails(company, vat)
    setBusy(false)
    if ('error' in res) {
      setMessage({ text: res.error, error: true })
    } else {
      setMessage({ text: res.message, error: false })
      router.refresh()
    }
  }

  async function onRemove() {
    setBusy(true)
    setMessage(null)
    const res = await removeBusinessDetails()
    setBusy(false)
    if ('error' in res) {
      setMessage({ text: res.error, error: true })
    } else {
      setCompany('')
      setVat('')
      setMessage({ text: 'Removed. You now buy as a private customer.', error: false })
      router.refresh()
    }
  }

  return (
    <form onSubmit={onSave} style={{ marginTop: 8 }}>
      <div style={{ marginBottom: 20 }}>
        <label style={labelStyle} htmlFor="company">Company name</label>
        <input
          id="company"
          value={company}
          onChange={e => setCompany(e.target.value)}
          maxLength={200}
          autoComplete="organization"
          style={inputStyle}
        />
      </div>
      <div style={{ marginBottom: 24 }}>
        <label style={labelStyle} htmlFor="vat">VAT number (optional)</label>
        <input
          id="vat"
          value={vat}
          onChange={e => setVat(e.target.value)}
          placeholder="e.g. DE123456789"
          maxLength={30}
          autoCapitalize="characters"
          style={inputStyle}
        />
      </div>

      {message && (
        <p style={{ fontSize: 14, lineHeight: 1.5, marginBottom: 16, color: message.error ? '#B42318' : '#2F6B3B' }}>
          {message.text}
        </p>
      )}

      <button type="submit" disabled={!canSubmit} style={canSubmit ? pillDark : pillDisabled}>
        {busy ? 'Checking…' : 'Save and check'}
      </button>
      {hasDetails && (
        <button
          type="button"
          onClick={onRemove}
          disabled={busy}
          style={{ ...pillOutlineSm, width: 'auto', marginTop: 14, padding: '0 20px' }}
        >
          Remove business details
        </button>
      )}
    </form>
  )
}
