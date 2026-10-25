import type { MetadataRoute } from 'next'
import { createClient } from '@supabase/supabase-js'
import { SITE_URL } from '@/lib/seo'

// www.gemworkers.com/sitemap.xml — every public page Google should know.
// Stones come from public_listings (listed + available only), so sold or
// unlisted stones drop out automatically.
export const revalidate = 3600

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const now = new Date()
  const page = (path: string, priority: number, changeFrequency: 'daily' | 'weekly' | 'monthly' = 'weekly') =>
    ({ url: `${SITE_URL}${path}`, lastModified: now, changeFrequency, priority })

  const entries: MetadataRoute.Sitemap = [
    page('/', 1, 'daily'),
    page('/shop/loose_stone', 0.9, 'daily'),
    page('/shop/specimen', 0.8, 'daily'),
    page('/shop/jewelry', 0.8, 'daily'),
    page('/makers', 0.6),
    page('/reviews', 0.6),
    page('/about', 0.5, 'monthly'),
    page('/guarantee', 0.5, 'monthly'),
    page('/shipping', 0.4, 'monthly'),
    page('/returns', 0.4, 'monthly'),
    page('/payment', 0.3, 'monthly'),
    page('/faq', 0.4, 'monthly'),
    page('/contact', 0.3, 'monthly'),
    page('/terms', 0.2, 'monthly'),
    page('/privacy', 0.2, 'monthly'),
  ]

  try {
    // Public (anon) client: no login or cookies needed, same rows as visitors see.
    const supabase = createClient(process.env.NEXT_PUBLIC_SUPABASE_URL!, process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!)
    const { data } = await supabase.from('public_listings').select('id').limit(5000)
    for (const s of (data ?? []) as { id: string }[]) {
      entries.push({
        url: `${SITE_URL}/stones/${s.id}`,
        lastModified: now,
        changeFrequency: 'weekly',
        priority: 0.7,
      })
    }
  } catch (e) {
    console.error('[sitemap] stones not loaded:', e instanceof Error ? e.message : String(e))
  }
  return entries
}
