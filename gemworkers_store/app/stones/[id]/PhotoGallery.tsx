'use client';

import { useCallback, useEffect, useRef, useState } from 'react';
import { createPortal } from 'react-dom';

interface PhotoGalleryProps {
  imageUrls: string[];
  title: string;
  // Uploaded stone video (inventory-videos bucket); shown as the 2nd item,
  // playing silently on a loop, like Etsy. Old YouTube links don't come here.
  videoUrl?: string | null;
}

type Media = { kind: 'image' | 'video'; url: string };

// Etsy-style stone photos:
//  - computer: thumbnail column on the left, big photo with ‹ › on its edges
//  - phone: edge-to-edge swipe carousel with dots
//  - full screen: photo fitted to the window, thumbnail row along the bottom,
//    click to zoom (mouse moves around the zoomed photo), pinch to zoom on phones
// Swiping uses native horizontal scroll with snapping, so it feels like the
// phone's own photo app.

function useSnapTrack(count: number) {
  const ref = useRef<HTMLDivElement>(null);
  const [index, setIndex] = useState(0);

  const onScroll = useCallback(() => {
    const el = ref.current;
    if (!el || el.clientWidth === 0) return;
    setIndex(Math.min(count - 1, Math.max(0, Math.round(el.scrollLeft / el.clientWidth))));
  }, [count]);

  const goTo = useCallback((i: number, smooth = true) => {
    const el = ref.current;
    if (!el) return;
    const target = Math.min(count - 1, Math.max(0, i));
    // 'instant' overrides the track's CSS smooth scrolling (used when opening).
    el.scrollTo({ left: target * el.clientWidth, behavior: smooth ? 'smooth' : 'instant' });
    setIndex(target);
  }, [count]);

  return { ref, index, onScroll, goTo };
}

// Frame follows the first photo's shape (between 4:5 portrait and 4:3
// landscape) so stones fill it with as little empty space as possible.
function useFrameRatio(firstUrl: string | undefined) {
  const [ratio, setRatio] = useState(1);
  useEffect(() => {
    if (!firstUrl) return;
    const img = new Image();
    img.onload = () => {
      if (img.naturalWidth > 0 && img.naturalHeight > 0) {
        setRatio(Math.min(4 / 3, Math.max(4 / 5, img.naturalWidth / img.naturalHeight)));
      }
    };
    img.src = firstUrl;
  }, [firstUrl]);
  return ratio;
}

// Silent looping clip — the Etsy listing-video behaviour.
function LoopVideo({ url, className, onClick }: { url: string; className?: string; onClick?: (e: React.MouseEvent) => void }) {
  return (
    <video
      src={url}
      className={className}
      autoPlay
      muted
      loop
      playsInline
      preload="metadata"
      onClick={onClick}
    />
  );
}

function Arrow({ dir, onClick, dark = false }: { dir: 'prev' | 'next'; onClick: () => void; dark?: boolean }) {
  return (
    <button
      type="button"
      onClick={e => { e.stopPropagation(); onClick(); }}
      aria-label={dir === 'prev' ? 'Previous' : 'Next'}
      className={`gallery-arrow gallery-arrow-${dir}${dark ? ' gallery-arrow-dark' : ''}`}
    >
      {dir === 'prev' ? '‹' : '›'}
    </button>
  );
}

function Thumb({ media, active, onClick, label }: { media: Media; active: boolean; onClick: () => void; label: string }) {
  return (
    <button type="button" onClick={onClick} aria-label={label} aria-current={active} className={`gallery-thumb${active ? ' is-active' : ''}`}>
      {media.kind === 'video' ? (
        <span className="gallery-thumb-video">
          <video src={`${media.url}#t=0.1`} muted playsInline preload="metadata" />
          <span className="gallery-thumb-play" aria-hidden="true">▶</span>
        </span>
      ) : (
        // eslint-disable-next-line @next/next/no-img-element
        <img src={media.url} alt="" />
      )}
    </button>
  );
}

// ── One full-screen photo with click-to-zoom ────────────────────────────────
function ZoomSlide({
  url, alt, zoomed, onToggleZoom,
}: {
  url: string; alt: string; zoomed: boolean; onToggleZoom: () => void;
}) {
  const [origin, setOrigin] = useState('50% 50%');

  function trackMouse(e: React.MouseEvent<HTMLImageElement>) {
    const r = e.currentTarget.getBoundingClientRect();
    const x = ((e.clientX - r.left) / r.width) * 100;
    const y = ((e.clientY - r.top) / r.height) * 100;
    setOrigin(`${Math.min(100, Math.max(0, x))}% ${Math.min(100, Math.max(0, y))}%`);
  }

  return (
    <div className="gallery-lightbox-slide">
      {/* eslint-disable-next-line @next/next/no-img-element */}
      <img
        src={url}
        alt={alt}
        draggable={false}
        className={`gallery-lightbox-img${zoomed ? ' is-zoomed' : ''}`}
        style={{ transformOrigin: origin }}
        onClick={e => {
          // Touch screens zoom with a pinch instead (browser's own zoom).
          if (window.matchMedia('(hover: none)').matches) return;
          trackMouse(e);
          onToggleZoom();
        }}
        onMouseMove={zoomed ? trackMouse : undefined}
      />
    </div>
  );
}

// ── Full-screen viewer ──────────────────────────────────────────────────────
function Lightbox({
  media, title, startIndex, onClose,
}: {
  media: Media[]; title: string; startIndex: number; onClose: (index: number) => void;
}) {
  const { ref, index, onScroll, goTo } = useSnapTrack(media.length);
  const [zoomed, setZoomed] = useState(false);
  const many = media.length > 1;
  const onVideo = media[index]?.kind === 'video';

  // Open on the item that was tapped; lock page scroll while open.
  useEffect(() => {
    goTo(startIndex, false);
    const prev = document.body.style.overflow;
    document.body.style.overflow = 'hidden';
    return () => { document.body.style.overflow = prev; };
  }, [goTo, startIndex]);

  // Changing item always starts zoomed out.
  const show = useCallback((i: number) => { setZoomed(false); goTo(i); }, [goTo]);

  useEffect(() => {
    function onKey(e: KeyboardEvent) {
      if (e.key === 'Escape') { if (zoomed) setZoomed(false); else onClose(index); }
      if (e.key === 'ArrowLeft') show(index - 1);
      if (e.key === 'ArrowRight') show(index + 1);
    }
    window.addEventListener('keydown', onKey);
    return () => window.removeEventListener('keydown', onKey);
  }, [index, zoomed, show, onClose]);

  return (
    <div className="gallery-lightbox" role="dialog" aria-modal="true" aria-label={`${title} photos`}>
      <div className="gallery-lightbox-bar">
        <span>{many ? `${index + 1} / ${media.length}` : ''}</span>
        <span className="gallery-lightbox-hint">
          {onVideo ? 'Click video to pause' : zoomed ? 'Click to zoom out' : 'Click photo to zoom'}
        </span>
        <button type="button" onClick={() => onClose(index)} aria-label="Close" className="gallery-close">✕</button>
      </div>

      <div
        ref={ref}
        onScroll={onScroll}
        className={`gallery-track gallery-lightbox-track${zoomed ? ' is-zoomed' : ''}`}
      >
        {media.map((m, i) =>
          m.kind === 'video' ? (
            <div key={i} className="gallery-lightbox-slide">
              <LoopVideo
                url={m.url}
                className="gallery-lightbox-img"
                onClick={e => {
                  const v = e.currentTarget as HTMLVideoElement;
                  if (v.paused) void v.play(); else v.pause();
                }}
              />
            </div>
          ) : (
            <ZoomSlide
              key={i}
              url={m.url}
              alt={`${title} — ${i + 1} of ${media.length}`}
              zoomed={zoomed && i === index}
              onToggleZoom={() => setZoomed(z => !z)}
            />
          ),
        )}
      </div>

      {many && !zoomed && index > 0 && <Arrow dir="prev" dark onClick={() => show(index - 1)} />}
      {many && !zoomed && index < media.length - 1 && <Arrow dir="next" dark onClick={() => show(index + 1)} />}

      {many && (
        <div className="gallery-lightbox-thumbs">
          {media.map((m, i) => (
            <Thumb key={i} media={m} active={i === index} onClick={() => show(i)} label={`Show ${m.kind} ${i + 1}`} />
          ))}
        </div>
      )}
    </div>
  );
}

export function PhotoGallery({ imageUrls, title, videoUrl }: PhotoGalleryProps) {
  // Photo 1, then the video, then the other photos (Etsy order).
  const media: Media[] = imageUrls.map(url => ({ kind: 'image' as const, url }));
  if (videoUrl) media.splice(Math.min(1, media.length), 0, { kind: 'video', url: videoUrl });

  const { ref, index, onScroll, goTo } = useSnapTrack(media.length);
  const ratio = useFrameRatio(imageUrls[0]);
  const [lightboxAt, setLightboxAt] = useState<number | null>(null);

  if (media.length === 0) {
    return <div className="gallery-empty" aria-hidden="true" />;
  }

  const many = media.length > 1;

  return (
    <div className={`gallery${many ? ' has-thumbs' : ''}`}>
      {/* Computer: vertical thumbnail column */}
      {many && (
        <div className="gallery-side-thumbs">
          {media.map((m, i) => (
            <Thumb key={i} media={m} active={i === index} onClick={() => goTo(i)} label={`View ${m.kind} ${i + 1}`} />
          ))}
        </div>
      )}

      <div className="gallery-main">
        <div className="gallery-stage">
          <div
            ref={ref}
            onScroll={onScroll}
            className="gallery-track gallery-frame"
            style={{ aspectRatio: String(ratio) }}
          >
            {media.map((m, i) => (
              <button
                key={i}
                type="button"
                className="gallery-slide"
                onClick={() => setLightboxAt(i)}
                aria-label={`Open ${m.kind} ${i + 1} full screen`}
              >
                {m.kind === 'video' ? (
                  <LoopVideo url={m.url} />
                ) : (
                  // eslint-disable-next-line @next/next/no-img-element
                  <img
                    src={m.url}
                    alt={`${title} — photo ${i + 1} of ${media.length}`}
                    draggable={false}
                  />
                )}
              </button>
            ))}
          </div>
          {many && index > 0 && <Arrow dir="prev" onClick={() => goTo(index - 1)} />}
          {many && index < media.length - 1 && <Arrow dir="next" onClick={() => goTo(index + 1)} />}
        </div>

        {/* Phone: dots */}
        {many && (
          <div className="gallery-dots" aria-hidden="true">
            {media.map((_, i) => (
              <span key={i} className={i === index ? 'is-active' : ''} />
            ))}
          </div>
        )}
      </div>

      {/* Portal to <body>: page-enter animations use transform, which would
          otherwise trap position: fixed inside the page. */}
      {lightboxAt !== null && createPortal(
        <Lightbox
          media={media}
          title={title}
          startIndex={lightboxAt}
          onClose={i => { setLightboxAt(null); goTo(i, false); }}
        />,
        document.body,
      )}
    </div>
  );
}
