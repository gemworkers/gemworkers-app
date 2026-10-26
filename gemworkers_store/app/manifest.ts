import type { MetadataRoute } from 'next'

// "Add to Home screen" / "Install app" on phones: opens the shop full screen
// with the GemWorkers icon (public/icon-*.png, app/apple-icon.png for iPhone).
export default function manifest(): MetadataRoute.Manifest {
  return {
    name: 'GemWorkers — natural gemstones',
    short_name: 'GemWorkers',
    description: 'Natural gemstones, mineral specimens and jewellery, honestly described.',
    id: '/',
    start_url: '/',
    scope: '/',
    display: 'standalone',
    background_color: '#FBF8F3',
    theme_color: '#1F1B16',
    icons: [
      { src: '/icon-192.png', sizes: '192x192', type: 'image/png' },
      { src: '/icon-512.png', sizes: '512x512', type: 'image/png' },
      { src: '/icon-maskable-512.png', sizes: '512x512', type: 'image/png', purpose: 'maskable' },
    ],
  }
}
