// Photos and videos on Bunny (gemworkers_core/sql/media_bunny.sql).
//   Photos: https://media.gemworkers.com/items/<stone>/<name>.jpg, with a small
//           copy <name>_card.jpg (800 px) for grids, cards and thumbnails.
//   Videos: https://vz-192edce1-fc4.b-cdn.net/<video id>/play_720p.mp4 (or a
//           smaller size), poster image <video id>/thumbnail.jpg.
// Older Supabase Storage URLs still work and are used as they are.

const MEDIA_HOST = 'https://media.gemworkers.com/'
const STREAM_HOST = 'https://vz-192edce1-fc4.b-cdn.net/'

/** Small version of a stone photo, for cards and thumbnails. */
export function cardImage(url: string): string
export function cardImage(url: string | null | undefined): string | null
export function cardImage(url: string | null | undefined): string | null {
  if (!url) return null
  return url.startsWith(MEDIA_HOST) && url.endsWith('.jpg') && !url.endsWith('_card.jpg')
    ? url.slice(0, -4) + '_card.jpg'
    : url
}

/** True for a video we host (Bunny, or an older Supabase upload) — not a YouTube/Vimeo link. */
export function isUploadedVideo(url: string | null | undefined): boolean {
  return !!url && (url.startsWith(STREAM_HOST) || url.includes('/storage/v1/object/public/inventory-videos/'))
}

/** Still image Bunny makes for each video (null for older uploads). */
export function videoPoster(url: string | null | undefined): string | null {
  if (!url?.startsWith(STREAM_HOST)) return null
  const id = url.slice(STREAM_HOST.length).split('/')[0]
  return id ? `${STREAM_HOST}${id}/thumbnail.jpg` : null
}
