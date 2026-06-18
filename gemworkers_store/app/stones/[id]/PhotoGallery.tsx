'use client';

import { useState } from 'react';

interface PhotoGalleryProps {
  imageUrls: string[];
  title: string;
}

export function PhotoGallery({ imageUrls, title }: PhotoGalleryProps) {
  const [selected, setSelected] = useState(0);

  // ── 0 photos ──────────────────────────────────────────────────────────────
  if (imageUrls.length === 0) {
    return (
      <div style={{
        width: '100%', aspectRatio: '1 / 1',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        background: 'linear-gradient(145deg, #f6f3ef 0%, #ece8e2 100%)',
        borderRadius: 12,
      }}>
        <span style={{
          fontSize: 96, color: '#c4b8ab', fontWeight: 300,
          fontFamily: "Georgia, 'Times New Roman', serif", lineHeight: 1,
          userSelect: 'none',
        }}>
          ◇
        </span>
      </div>
    );
  }

  // ── 1 photo ───────────────────────────────────────────────────────────────
  if (imageUrls.length === 1) {
    return (
      <div style={{ borderRadius: 12, overflow: 'hidden', background: '#f6f3ef' }}>
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img
          src={imageUrls[0]}
          alt={title}
          style={{ width: '100%', display: 'block', objectFit: 'cover', maxHeight: 520 }}
        />
      </div>
    );
  }

  // ── 2+ photos: main image + thumbnail strip ────────────────────────────────
  return (
    <div>
      {/* Main image */}
      <div style={{
        borderRadius: 12, overflow: 'hidden', background: '#f6f3ef',
        marginBottom: 10,
      }}>
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img
          src={imageUrls[selected]}
          alt={`${title} — photo ${selected + 1} of ${imageUrls.length}`}
          style={{ width: '100%', display: 'block', objectFit: 'cover', maxHeight: 520 }}
        />
      </div>

      {/* Thumbnail strip */}
      <div style={{ display: 'flex', gap: 8, overflowX: 'auto', paddingBottom: 4 }}>
        {imageUrls.map((url, i) => (
          <button
            key={i}
            onClick={() => setSelected(i)}
            aria-label={`View photo ${i + 1}`}
            style={{
              flex: '0 0 72px', height: 72,
              padding: 0, border: 'none', cursor: 'pointer',
              borderRadius: 6, overflow: 'hidden',
              outline: i === selected ? '2px solid #374151' : '2px solid transparent',
              outlineOffset: 2,
              background: '#f6f3ef',
              transition: 'outline-color 0.1s ease',
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
