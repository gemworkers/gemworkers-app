'use client'

import { useState } from 'react'
import { updateDisplayName, changeEmail, changePassword, deleteAccount } from '@/app/actions/account'
import { inputStyle, labelStyle, pillDarkSm, pillDisabledSm, pillOutlineSm } from '@/lib/ui'

type Msg = { text: string; error: boolean } | null

function Message({ msg }: { msg: Msg }) {
  if (!msg) return null
  return <p style={{ fontSize: 14, lineHeight: 1.5, margin: '10px 0 0', color: msg.error ? '#B42318' : '#2F6B3B' }}>{msg.text}</p>
}

const field = { marginBottom: 12 } as const
const input = { ...inputStyle, fontSize: 16 } as const   // 16px: no zoom on iPhone

export function NameForm({ initial }: { initial: string }) {
  const [name, setName] = useState(initial)
  const [busy, setBusy] = useState(false)
  const [msg, setMsg] = useState<Msg>(null)
  return (
    <form onSubmit={async e => {
      e.preventDefault(); setBusy(true); setMsg(null)
      const r = await updateDisplayName(name)
      setBusy(false); setMsg('error' in r ? { text: r.error, error: true } : { text: r.message, error: false })
    }}>
      <div style={field}>
        <label style={labelStyle} htmlFor="acc-name">Name</label>
        <input id="acc-name" value={name} onChange={e => setName(e.target.value)} maxLength={80} autoComplete="name" style={input} />
      </div>
      <button type="submit" disabled={busy || !name.trim()} style={{ ...(busy ? pillDisabledSm : pillDarkSm), width: 'auto', padding: '0 20px' }}>Save name</button>
      <Message msg={msg} />
    </form>
  )
}

export function EmailForm({ current }: { current: string }) {
  const [email, setEmail] = useState('')
  const [busy, setBusy] = useState(false)
  const [msg, setMsg] = useState<Msg>(null)
  return (
    <form onSubmit={async e => {
      e.preventDefault(); setBusy(true); setMsg(null)
      const r = await changeEmail(email)
      setBusy(false); setMsg('error' in r ? { text: r.error, error: true } : { text: r.message, error: false })
    }}>
      <p style={{ fontSize: 14, color: '#5A5045', margin: '0 0 10px' }}>Current: <strong>{current}</strong></p>
      <div style={field}>
        <label style={labelStyle} htmlFor="acc-email">New email address</label>
        <input id="acc-email" type="email" value={email} onChange={e => setEmail(e.target.value)} autoComplete="email" style={input} />
      </div>
      <button type="submit" disabled={busy || !email.trim()} style={{ ...(busy ? pillDisabledSm : pillDarkSm), width: 'auto', padding: '0 20px' }}>Change email</button>
      <Message msg={msg} />
    </form>
  )
}

export function PasswordForm() {
  const [pw, setPw] = useState('')
  const [pw2, setPw2] = useState('')
  const [busy, setBusy] = useState(false)
  const [msg, setMsg] = useState<Msg>(null)
  return (
    <form onSubmit={async e => {
      e.preventDefault(); setBusy(true); setMsg(null)
      const r = await changePassword(pw, pw2)
      setBusy(false)
      if ('error' in r) setMsg({ text: r.error, error: true })
      else { setMsg({ text: r.message, error: false }); setPw(''); setPw2('') }
    }}>
      <div style={field}>
        <label style={labelStyle} htmlFor="acc-pw">New password</label>
        <input id="acc-pw" type="password" value={pw} onChange={e => setPw(e.target.value)} autoComplete="new-password" style={input} />
      </div>
      <div style={field}>
        <label style={labelStyle} htmlFor="acc-pw2">Repeat new password</label>
        <input id="acc-pw2" type="password" value={pw2} onChange={e => setPw2(e.target.value)} autoComplete="new-password" style={input} />
      </div>
      <button type="submit" disabled={busy || !pw || !pw2} style={{ ...(busy ? pillDisabledSm : pillDarkSm), width: 'auto', padding: '0 20px' }}>Change password</button>
      <Message msg={msg} />
    </form>
  )
}

export function DeleteForm() {
  const [open, setOpen] = useState(false)
  const [text, setText] = useState('')
  const [busy, setBusy] = useState(false)
  const [msg, setMsg] = useState<Msg>(null)
  if (!open) {
    return (
      <button type="button" onClick={() => setOpen(true)} style={{ ...pillOutlineSm, width: 'auto', padding: '0 20px', color: '#B42318' }}>
        Delete my account…
      </button>
    )
  }
  return (
    <form onSubmit={async e => {
      e.preventDefault(); setBusy(true); setMsg(null)
      const r = await deleteAccount(text)
      setBusy(false)
      if (r && 'error' in r) setMsg({ text: r.error, error: true })
    }}>
      <p style={{ fontSize: 14, color: '#5A5045', lineHeight: 1.6, margin: '0 0 10px' }}>
        This deletes your login, cart, saved business details and open offers, and removes your
        name from messages and reviews. <strong>This can&apos;t be undone.</strong> Order and invoice records
        are kept for 7–10 years because tax law requires it.
      </p>
      <div style={field}>
        <label style={labelStyle} htmlFor="acc-del">Type DELETE to confirm</label>
        <input id="acc-del" value={text} onChange={e => setText(e.target.value)} autoComplete="off" style={input} />
      </div>
      <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
        <button type="submit" disabled={busy || text.trim().toUpperCase() !== 'DELETE'}
          style={{ ...(busy || text.trim().toUpperCase() !== 'DELETE' ? pillDisabledSm : pillDarkSm), width: 'auto', padding: '0 20px', background: text.trim().toUpperCase() === 'DELETE' && !busy ? '#B42318' : undefined }}>
          {busy ? 'Deleting…' : 'Delete my account'}
        </button>
        <button type="button" onClick={() => { setOpen(false); setText(''); setMsg(null) }} style={{ ...pillOutlineSm, width: 'auto', padding: '0 18px' }}>
          Cancel
        </button>
      </div>
      <Message msg={msg} />
    </form>
  )
}
