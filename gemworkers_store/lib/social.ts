// SERVER ONLY — GemWorkers' own social accounts (sql/social_links.sql), set by
// the owner in the admin (account menu → Social media).
import { cache } from 'react'
import { createClient } from '@supabase/supabase-js'

export type SocialLinks = Partial<Record<'instagram' | 'facebook' | 'tiktok' | 'pinterest' | 'youtube' | 'x', string>>

export const socialLinks = cache(async (): Promise<SocialLinks> => {
  try {
    const db = createClient(process.env.NEXT_PUBLIC_SUPABASE_URL!, process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!)
    const { data } = await db.from('public_social_links').select('*').maybeSingle()
    const out: SocialLinks = {}
    for (const [k, v] of Object.entries((data ?? {}) as Record<string, string | null>)) {
      if (v) out[k as keyof SocialLinks] = v
    }
    return out
  } catch {
    return {}
  }
})
