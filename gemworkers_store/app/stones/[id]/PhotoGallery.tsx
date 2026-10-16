'use client';

import { useState } from 'react';

interface PhotoGalleryProps {
  imageUrls: string[];
  title: string;
}

// Square frame shared by every state, so the layout never jumps.
const frameStyle: React.CSSProperties = {
  width: '100%', aspectRatio: '1 / 1',
  borderRadius: 18, background: '#F4EEE4', overflow: 'hidden',
};

const imgStyle: React.CSSProperties = {
  width: '100%', height: '100%', objectFit: 'contain', display: 'block',
};

export function PhotoGallery({ imageUrls, title }: PhotoGalleryProps) {
  const [selected, setSelected] = useState(0);

  // ── 0 photos ──────────────────────────────────────────────────────────────
  if (imageUrls.length === 0) {
    return <div style={frameStyle} aria-hidden="true" />;
  }

  // ── 1 photo ───────────────────────────────────────────────────────────────
  if (imageUrls.length === 1) {
    return (
      <div className="photo-zoom-wrapper" style={frameStyle}>
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img src={imageUrls[0]} alt={title} className="photo-zoom-img" style={imgStyle} />
      </div>
    );
  }

  // ── 2+ photos: main image + thumbnail strip ────────────────────────────────
  return (
    <div>
      {/* Main image */}
      <div className="photo-zoom-wrapper" style={{ ...frameStyle, marginBottom: 12 }}>
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img
          src={imageUrls[selected]}
          alt={`${title} — photo ${selected + 1} of ${imageUrls.length}`}
          className="photo-zoom-img"
          style={imgStyle}
        />
      </div>

      {/* Thumbnail strip */}
      <div style={{ display: 'flex', gap: 10, overflowX: 'auto', padding: 4 }}>
        {imageUrls.map((url, i) => (
          <button
            key={i}
            onClick={() => setSelected(i)}
            aria-label={`View photo ${i + 1}`}
            style={{
              flex: '0 0 72px', height: 72,
              padding: 0, border: 'none', cursor: 'pointer',
              borderRadius: 12, overflow: 'hidden',
              outline: i === selected ? '2px solid #1F1B16' : '2px solid transparent',
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
    </div>
  );
}
