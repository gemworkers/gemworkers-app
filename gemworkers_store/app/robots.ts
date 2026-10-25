import type { MetadataRoute } from 'next'
import { SITE_URL } from '@/lib/seo'

// www.gemworkers.com/robots.txt — personal and checkout pages stay out of Google.
export default function robots(): MetadataRoute.Robots {
  return {
    rules: {
      userAgent: '*',
      allow: '/',
      disallow: [
        '/api/', '/auth/', '/account', '/cart', '/orders', '/messages', '/business',
        '/invoices/', '/statements/', '/reviews/write/', '/seller/', '/search',
      ],
    },
    sitemap: `${SITE_URL}/sitemap.xml`,
    host: SITE_URL,
  }
}
