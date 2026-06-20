// Server component — no 'use client' needed (no state or hooks).

type VideoResolution =
  | { type: 'youtube'; embedUrl: string }
  | { type: 'vimeo';   embedUrl: string }
  | { type: 'direct';  src: string }
  | { type: 'link';    href: string };

function resolveVideo(url: string): VideoResolution {
  const trimmed = url.trim();

  try {
    const parsed = new URL(trimmed);
    const host = parsed.hostname.replace(/^www\./, '');

    // ── YouTube ────────────────────────────────────────────────────────────
    if (host === 'youtube.com' || host === 'youtu.be') {
      let videoId: string | null = null;

      if (host === 'youtu.be') {
        // https://youtu.be/ID
        videoId = parsed.pathname.slice(1);
      } else if (parsed.pathname === '/watch') {
        // https://www.youtube.com/watch?v=ID
        videoId = parsed.searchParams.get('v');
      } else if (parsed.pathname.startsWith('/shorts/')) {
        // https://www.youtube.com/shorts/ID
        videoId = parsed.pathname.slice('/shorts/'.length);
      } else if (parsed.pathname.startsWith('/embed/')) {
        // https://www.youtube.com/embed/ID (already an embed link)
        videoId = parsed.pathname.slice('/embed/'.length);
      }

      if (videoId) {
        // Strip any trailing path segments or query leakage
        videoId = videoId.split('/')[0].split('?')[0];
        if (videoId) {
          return {
            type: 'youtube',
            embedUrl: `https://www.youtube.com/embed/${videoId}`,
          };
        }
      }
    }

    // ── Vimeo ──────────────────────────────────────────────────────────────
    if (host === 'vimeo.com' || host === 'player.vimeo.com') {
      // matches /123456789 and /video/123456789
      const match = parsed.pathname.match(/\/(video\/)?(\d+)/);
      if (match) {
        return {
          type: 'vimeo',
          embedUrl: `https://player.vimeo.com/video/${match[2]}`,
        };
      }
    }

    // ── Direct video file ──────────────────────────────────────────────────
    const ext = parsed.pathname.split('.').pop()?.toLowerCase();
    if (ext && ['mp4', 'webm', 'mov'].includes(ext)) {
      return { type: 'direct', src: trimmed };
    }
  } catch {
    // Unparseable URL — fall through to plain link
  }

  return { type: 'link', href: trimmed };
}

// ── Component ─────────────────────────────────────────────────────────────────

export function VideoPlayer({ url }: { url: string }) {
  if (!url.trim()) return null;

  const resolved = resolveVideo(url);

  return (
    <div style={{ marginTop: 28 }}>
      {/* Section label — matches the SpecSection uppercase label style */}
      <p style={{
        fontSize: 10, fontWeight: 700, letterSpacing: '0.15em',
        color: '#9ca3af', textTransform: 'uppercase', marginBottom: 10,
      }}>
        Video
      </p>

      {/* YouTube / Vimeo — 16:9 responsive iframe */}
      {(resolved.type === 'youtube' || resolved.type === 'vimeo') && (
        <div style={{
          position: 'relative', paddingTop: '56.25%',
          overflow: 'hidden', borderRadius: 8,
        }}>
          <iframe
            src={resolved.embedUrl}
            title="Product video"
            allowFullScreen
            frameBorder="0"
            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
            style={{
              position: 'absolute', top: 0, left: 0,
              width: '100%', height: '100%', border: 'none',
            }}
          />
        </div>
      )}

      {/* Direct video file — native player */}
      {resolved.type === 'direct' && (
        <video
          controls
          style={{ width: '100%', borderRadius: 8, display: 'block' }}
        >
          <source src={resolved.src} />
        </video>
      )}

      {/* Fallback — plain link, never a broken player */}
      {resolved.type === 'link' && (
        <a
          href={resolved.href}
          target="_blank"
          rel="noopener noreferrer"
          style={{
            display: 'inline-flex', alignItems: 'center', gap: 4,
            fontSize: 14, color: '#374151', fontWeight: 500,
            textDecoration: 'none',
            borderBottom: '1px solid #d1d5db', paddingBottom: 1,
          }}
        >
          View video ↗
        </a>
      )}
    </div>
  );
}
