// Returns a same-site relative path for post-auth redirects, or '/' if the
// value is missing or could point off-site ('//evil.com', '/\evil.com',
// 'https://…', '@evil.com', control characters).
export function safeNext(raw: string | null | undefined): string {
  if (!raw) return '/'
  if (!raw.startsWith('/')) return '/'
  if (raw.startsWith('//') || raw.startsWith('/\\')) return '/'
  if (/[\u0000-\u001F\u007F]/.test(raw)) return '/'
  return raw
}
