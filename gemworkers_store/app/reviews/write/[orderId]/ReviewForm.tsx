'use client'

import { useState } from 'react'
import Link from 'next/link'
import { createClient } from '@/lib/supabase/client'
import { submitReview } from '@/app/actions/reviews'
import { pillDarkSm, pillDisabledSm, inputStyle, labelStyle, panel } from '@/lib/ui'

const MAX_LEN = 2000
const MAX_PHOTO_BYTES = 5 * 1024 * 1024
const PHOTO_TYPES: Record<string, string> = {
  'image/jpeg': 'jpg', 'image/png': 'png', 'image/webp': 'webp', 'image/heic': 'heic',
}

export function ReviewForm({ orderId, userId }: { orderId: string; userId: string }) {
  const [rating, setRating] = useState(0)
  const [hover, setHover] = useState(0)
  const [body, setBody] = useState('')
  const [photo, setPhoto] = useState<File | null>(null)
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [done, setDone] = useState(false)

  function pickPhoto(file: File | null) {
    setError(null)
    if (!file) { setPhoto(null); return }
    if (!PHOTO_TYPES[file.type]) { setError('Please choose a JPG, PNG, WebP or HEIC photo.'); return }
    if (file.size > MAX_PHOTO_BYTES) { setError('That photo is larger than 5 MB. Please choose a smaller one.'); return }
    setPhoto(file)
  }

  async function handleSubmit() {
    if (rating < 1 || busy) return
    setBusy(true)
    setError(null)

    let photoUrl: string | null = null
    if (photo) {
      // Buyers may only upload into review-photos/<their user id>/ (storage RLS).
      const supabase = createClient()
      const path = `${userId}/${Date.now()}.${PHOTO_TYPES[photo.type]}`
      const { error: upErr } = await supabase.storage
        .from('review-photos')
        .upload(path, photo, { contentType: photo.type })
      if (upErr) {
        setError('The photo could not be uploaded. Please try again, or send your review without it.')
        setBusy(false)
        return
      }
      photoUrl = supabase.storage.from('review-photos').getPublicUrl(path).data.publicUrl
    }

    const res = await submitReview(orderId, rating, body, photoUrl)
    if ('error' in res) {
      setError(res.error)
      setBusy(false)
      return
    }
    setDone(true)
  }

  if (done) {
    return (
      <div style={{ ...panel, display: 'flex', flexDirection: 'column', gap: 12 }}>
        <p style={{ fontSize: 18, fontWeight: 600, color: '#1F1B16', margin: 0 }}>Thank you for your review!</p>
        <p style={{ fontSize: 15, color: '#5A5045', lineHeight: 1.6, margin: 0 }}>
          We read every review before it appears on our Reviews page.
        </p>
        <Link href="/orders" className="pd-link">Back to my orders →</Link>
      </div>
    )
  }

  const shown = hover || rating
  const canSend = rating >= 1 && !busy && body.length <= MAX_LEN

  return (
    <div style={{ ...panel, display: 'flex', flexDirection: 'column', gap: 18 }}>
      <div>
        <p style={labelStyle}>Your rating *</p>
        <div role="radiogroup" aria-label="Rating" style={{ display: 'flex', gap: 6 }} onMouseLeave={() => setHover(0)}>
          {[1, 2, 3, 4, 5].map(n => (
            <button
              key={n}
              type="button"
              role="radio"
              aria-checked={rating === n}
              aria-label={`${n} star${n === 1 ? '' : 's'}`}
              onClick={() => setRating(n)}
              onMouseEnter={() => setHover(n)}
              disabled={busy}
              style={{
                background: 'none', border: 'none', padding: 2, cursor: busy ? 'default' : 'pointer',
                fontSize: 34, lineHeight: 1, color: n <= shown ? '#B8860B' : '#DDD3C2',
              }}
            >
              ★
            </button>
          ))}
        </div>
      </div>

      <div>
        <label htmlFor="review-body" style={labelStyle}>Your review (optional)</label>
        <textarea
          id="review-body"
          rows={5}
          maxLength={MAX_LEN}
          value={body}
          onChange={e => setBody(e.target.value)}
          disabled={busy}
          placeholder="How does the stone look in person? How was delivery?"
          style={{ ...inputStyle, resize: 'vertical', lineHeight: 1.5, minHeight: 120 }}
        />
        <p style={{ fontSize: 12, color: '#6B6052', margin: '4px 0 0' }}>{body.length} / {MAX_LEN}</p>
      </div>

      <div>
        <label htmlFor="review-photo" style={labelStyle}>Photo (optional)</label>
        <input
          id="review-photo"
          type="file"
          accept="image/jpeg,image/png,image/webp,image/heic"
          disabled={busy}
          onChange={e => pickPhoto(e.target.files?.[0] ?? null)}
          style={{ fontSize: 14 }}
        />
        {photo && <p style={{ fontSize: 13, color: '#5A5045', margin: '6px 0 0' }}>{photo.name}</p>}
      </div>

      <p style={{ fontSize: 13, color: '#6B6052', lineHeight: 1.6, margin: 0 }}>
        Your review is shown with your first name and country. Please don&apos;t include
        email addresses, phone numbers or links.
      </p>

      {error && <p role="alert" style={{ fontSize: 14, color: '#B42318', margin: 0 }}>{error}</p>}

      <button
        onClick={handleSubmit}
        disabled={!canSend}
        style={{ ...(canSend ? pillDarkSm : pillDisabledSm), cursor: canSend ? 'pointer' : 'default' }}
      >
        {busy ? 'Sending…' : rating < 1 ? 'Choose a star rating' : 'Send review'}
      </button>
    </div>
  )
}
