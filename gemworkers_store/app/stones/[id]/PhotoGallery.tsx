'use client';

import { useCallback, useEffect, useRef, useState } from 'react';

interface PhotoGalleryProps {
  imageUrls: string[];
  title: string;
}

// Square frame shared by every state, so the layout never jumps.
const frameStyle: React.CSSProperties = {
  width: '100%', aspectRatio: '1 / 1',
  borderRadius: 18, background: '#F4EEE4', overflow: 'hidden',
};

// Swipe track: native horizontal scroll with snapping — smooth finger swipes
// on phones, trackpad swipes on laptops, arrows for mice.
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

function Arrow({ dir, onClick, dark = false }: { dir: 'prev' | 'next'; onClick: () => void; dark?: boolean }) {
  return (
    <button
      type="button"
      onClick={e => { e.stopPropagation(); onClick(); }}
      aria-label={dir === 'prev' ? 'Previous photo' : 'Next photo'}
      className={`gallery-arrow gallery-arrow-${dir}${dark ? ' gallery-arrow-dark' : ''}`}
    >
      {dir === 'prev' ? '‹' : '›'}
    </button>
  );
}

// ── Full-screen viewer ──────────────────────────────────────────────────────
function Lightbox({
  imageUrls, title, startIndex, onClose,
}: {
  imageUrls: string[]; title: string; startIndex: number; onClose: (index: number) => void;
}) {
  const { ref, index, onScroll, goTo } = useSnapTrack(imageUrls.length);

  // Open on the photo that was tapped; lock page scroll while open.
  useEffect(() => {
    goTo(startIndex, false);
    const prev = document.body.style.overflow;
    document.body.style.overflow = 'hidden';
    return () => { document.body.style.overflow = prev; };
  }, [goTo, startIndex]);

  useEffect(() => {
    function onKey(e: KeyboardEvent) {
      if (e.key === 'Escape') onClose(index);
      if (e.key === 'ArrowLeft') goTo(index - 1);
      if (e.key === 'ArrowRight') goTo(index + 1);
    }
    window.addEventListener('keydown', onKey);
    return () => window.removeEventListener('keydown', onKey);
  }, [index, goTo, onClose]);

  return (
    <div className="gallery-lightbox" role="dialog" aria-modal="true" aria-label={`${title} photos`}>
      <div className="gallery-lightbox-bar">
        <span>{imageUrls.length > 1 ? `${index + 1} / ${imageUrls.length}` : ''}</span>
        <button type="button" onClick={() => onClose(index)} aria-label="Close" className="gallery-close">✕</button>
      </div>
      <div ref={ref} onScroll={onScroll} className="gallery-track gallery-lightbox-track">
        {imageUrls.map((url, i) => (
          <div key={i} className="gallery-lightbox-slide" onClick={() => onClose(index)}>
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img
              src={url}
              alt={`${title} — photo ${i + 1} of ${imageUrls.length}`}
              className="gallery-lightbox-img"
              onClick={e => e.stopPropagation()}
            />
          </div>
        ))}
      </div>
      {imageUrls.length > 1 && index > 0 && <Arrow dir="prev" dark onClick={() => goTo(index - 1)} />}
      {imageUrls.length > 1 && index < imageUrls.length - 1 && <Arrow dir="next" dark onClick={() => goTo(index + 1)} />}
    </div>
  );
}

export function PhotoGallery({ imageUrls, title }: PhotoGalleryProps) {
  const { ref, index, onScroll, goTo } = useSnapTrack(imageUrls.length);
  const [lightboxAt, setLightboxAt] = useState<number | null>(null);

  // ── 0 photos ──────────────────────────────────────────────────────────────
  if (imageUrls.length === 0) {
    return <div style={frameStyle} aria-hidden="true" />;
  }

  const many = imageUrls.length > 1;

  return (
    <div>
      {/* Main swipe carousel */}
      <div style={{ position: 'relative', marginBottom: many ? 12 : 0 }}>
        <div ref={ref} onScroll={onScroll} className="gallery-track" style={frameStyle}>
          {imageUrls.map((url, i) => (
            <button
              key={i}
              type="button"
              className="gallery-slide"
              onClick={() => setLightboxAt(i)}
              aria-label={`Open photo ${i + 1} full screen`}
            >
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img
                src={url}
                alt={`${title} — photo ${i + 1} of ${imageUrls.length}`}
                draggable={false}
                style={{ width: '100%', height: '100%', objectFit: 'contain', display: 'block' }}
              />
            </button>
          ))}
        </div>
        {many && index > 0 && <Arrow dir="prev" onClick={() => goTo(index - 1)} />}
        {many && index < imageUrls.length - 1 && <Arrow dir="next" onClick={() => goTo(index + 1)} />}
        {many && <span className="gallery-count">{index + 1} / {imageUrls.length}</span>}
        <span className="gallery-expand" aria-hidden="true">⤢</span>
      </div>

      {/* Thumbnail strip */}
      {many && (
        <div style={{ display: 'flex', gap: 10, overflowX: 'auto', padding: 4 }}>
          {imageUrls.map((url, i) => (
            <button
              key={i}
              onClick={() => goTo(i)}
              aria-label={`View photo ${i + 1}`}
              style={{
                flex: '0 0 72px', height: 72,
                padding: 0, border: 'none', cursor: 'pointer',
                borderRadius: 12, overflow: 'hidden',
                outline: i === index ? '2px solid #1F1B16' : '2px solid transparent',
                outlineOffset: 2,
                background: '#F4EEE4',
                transition: 'outline-color 0.15s ease',
              }}
            >
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img
                src={url}
                alt=""
                style={{ width: '100%', height: '100%', objectFit: 'cover', display: 'block' }}
              />
            </button>
          ))}
        </div>
      )}

      {lightboxAt !== null && (
        <Lightbox
          imageUrls={imageUrls}
          title={title}
          startIndex={lightboxAt}
          onClose={i => { setLightboxAt(null); goTo(i, false); }}
        />
      )}
    </div>
  );
}
