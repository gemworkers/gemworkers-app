import { createClient } from '@/lib/supabase/server';
import Link from 'next/link';
import { PhotoGallery } from './PhotoGallery';
import { StoreHeader } from '@/app/components/StoreHeader';
import { BuyButton } from './BuyButton';
import { CartButton } from './CartButton';

// ── Types ─────────────────────────────────────────────────────────────────────

type ListingDetail = {
  id: string;
  title: string;
  product_type: 'loose_stone' | 'specimen' | 'jewelry';
  selling_price: number | null;
  description: string | null;
  image_urls: string[] | null;
  seller_name: string | null;

  // video_url is fetched but NOT rendered — placeholder for next session
  video_url: string | null;

  // Shared / common
  certification_lab: string | null;
  certification_number: string | null;
  treatment: string | null;
  dimensions_mm: string | null;

  // loose_stone
  gem_type: string | null;
  variety: string | null;
  origin_country: string | null;
  origin_region: string | null;
  shape: string | null;
  cut_type: string | null;
  cut: string | null;
  clarity: string | null;
  weight_value: number | null;
  weight_unit: string | null;

  // specimen
  species: string | null;
  locality: string | null;
  matrix: string | null;
  weight_grams: number | null;

  // jewelry
  jewelry_type: string | null;
  metal: string | null;
  metal_purity: string | null;
  size_or_length: string | null;
  gemstones_used: string | null;
  total_weight_grams: number | null;
};

// ── Helpers ───────────────────────────────────────────────────────────────────

const eur = new Intl.NumberFormat('en-IE', {
  style: 'currency',
  currency: 'EUR',
  maximumFractionDigits: 0,
});

/** Renders a single label/value row; returns null for empty/null values. */
function SpecRow({
  label,
  value,
}: {
  label: string;
  value: string | number | null | undefined;
}) {
  if (value == null || value === '') return null;
  return (
    <div style={{ display: 'flex', alignItems: 'flex-start', paddingTop: 7, paddingBottom: 7 }}>
      <span style={{
        flexShrink: 0, width: 120, paddingRight: 12,
        color: '#9ca3af', fontSize: 13, fontWeight: 500,
      }}>
        {label}
      </span>
      <span style={{ color: '#374151', fontSize: 13 }}>
        {String(value)}
      </span>
    </div>
  );
}

/** Section heading + spec rows wrapper. */
function SpecSection({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <div style={{ marginBottom: 24 }}>
      <p style={{
        fontSize: 10, fontWeight: 700, letterSpacing: '0.15em',
        color: '#9ca3af', textTransform: 'uppercase', marginBottom: 10,
      }}>
        {title}
      </p>
      <div>{children}</div>
    </div>
  );
}

// ── Not-available state ───────────────────────────────────────────────────────
// Shown for: missing id, unlisted, sold, inactive-seller — identical presentation
// regardless of reason (don't reveal whether an id exists).

function NotAvailable() {
  return (
    <>
      <style>{`
        body { background: #fafaf9; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif; }
      `}</style>
      <StoreHeader />
      <main style={{ maxWidth: 1100, margin: '0 auto', padding: '120px 32px', textAlign: 'center' }}>
        <div style={{ fontSize: 52, color: '#d1d5db', marginBottom: 18, lineHeight: 1 }}>◇</div>
        <p style={{ fontSize: 16, fontWeight: 600, color: '#374151', marginBottom: 8 }}>
          This item is not available
        </p>
        <p style={{ fontSize: 14, color: '#9ca3af', marginBottom: 36 }}>
          It may have been sold, unlisted, or the link may be incorrect.
        </p>
        <Link href="/" style={{
          display: 'inline-block', padding: '10px 24px',
          background: '#111', color: '#fff', borderRadius: 6,
          textDecoration: 'none', fontSize: 14, fontWeight: 600, letterSpacing: '0.02em',
        }}>
          Browse all stones
        </Link>
      </main>
    </>
  );
}

// ── Page ──────────────────────────────────────────────────────────────────────

export default async function StoneDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;

  // Fetch user, listing, and cart membership in parallel.
  // All three share one cookie-based client (buyer's session).
  // cartRow is null for anon users (RLS blocks) and for buyers who haven't added this item.
  const supabase = await createClient();
  const [{ data: { user } }, { data, error }, { data: cartRow }] = await Promise.all([
    supabase.auth.getUser(),
    supabase
      .from('public_listing_details')
      .select('*')
      .eq('id', id)
      .maybeSingle(),        // null if not found / filtered out by WHERE — no error thrown
    supabase
      .from('storefront_cart')
      .select('id')
      .eq('inventory_item_id', id)
      .maybeSingle(),        // null if not in cart or if anon (RLS returns 0 rows)
  ]);

  // Any error or no row → not available (don't distinguish between "doesn't exist"
  // and "exists but unlisted/sold" — both render identically)
  if (error || !data) {
    return <NotAvailable />;
  }

  const item = data as ListingDetail;
  const photos = item.image_urls ?? [];

  // Derived display values
  const looseStoneWeight =
    item.weight_value != null && Number(item.weight_value) > 0
      ? `${item.weight_value} ${item.weight_unit ?? ''}`.trim()
      : null;

  const specimenWeight =
    item.weight_grams != null && Number(item.weight_grams) > 0
      ? `${item.weight_grams} g`
      : null;

  const jewelryWeight =
    item.total_weight_grams != null && Number(item.total_weight_grams) > 0
      ? `${item.total_weight_grams} g`
      : null;

  const originFull = [item.origin_country, item.origin_region]
    .filter((v) => v && v.trim())
    .join(', ') || null;

  const certificationLine = [item.certification_lab, item.certification_number]
    .filter((v) => v && v.trim())
    .join(' · ') || null;

  const metalLine = [item.metal, item.metal_purity]
    .filter((v) => v && v.trim())
    .join(' ') || null;

  return (
    <>
      <style>{`
        body { background: #fafaf9; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif; }
        .back-link { color: #9ca3af; transition: color 0.1s ease; }
        .back-link:hover { color: #374151; }
        @media (max-width: 680px) {
          .detail-grid { grid-template-columns: 1fr !important; gap: 32px !important; }
        }
      `}</style>

      <StoreHeader />

      <main style={{ maxWidth: 1100, margin: '0 auto', padding: '32px 32px 80px' }}>
        {/* Back to browse */}
        <Link href="/" className="back-link" style={{
          display: 'inline-flex', alignItems: 'center', gap: 6,
          fontSize: 13, textDecoration: 'none',
          marginBottom: 28, letterSpacing: '0.02em',
        }}>
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none"
            stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <polyline points="15 18 9 12 15 6" />
          </svg>
          Back to browse
        </Link>

        {/* ── Two-column layout ── */}
        <div className="detail-grid" style={{
          display: 'grid',
          gridTemplateColumns: 'minmax(0, 1fr) minmax(0, 1fr)',
          gap: 56,
          alignItems: 'start',
        }}>

          {/* ── Left: photo gallery ── */}
          <PhotoGallery imageUrls={photos} title={item.title} />

          {/* ── Right: info panel ── */}
          <div>
            {/* Title */}
            <h1 style={{
              fontSize: 26, fontWeight: 700, color: '#111', lineHeight: 1.25,
              marginBottom: 8, fontFamily: "Georgia, 'Times New Roman', serif",
            }}>
              {item.title}
            </h1>

            {/* Seller */}
            {item.seller_name && (
              <div style={{
                display: 'flex', alignItems: 'center', gap: 5,
                fontSize: 12, color: '#9ca3af', marginBottom: 16,
              }}>
                <svg width="11" height="11" viewBox="0 0 24 24" fill="none"
                  stroke="currentColor" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round">
                  <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
                  <polyline points="9,22 9,12 15,12 15,22" />
                </svg>
                {item.seller_name}
              </div>
            )}

            {/* Price */}
            {item.selling_price != null ? (
              <p style={{
                fontSize: 32, fontWeight: 700, color: '#111',
                letterSpacing: '-0.02em', marginBottom: 16,
              }}>
                {eur.format(Number(item.selling_price))}
              </p>
            ) : (
              <p style={{ fontSize: 18, color: '#d1d5db', marginBottom: 16 }}>
                Price on request
              </p>
            )}

            {/* Buy + cart actions */}
            <div style={{ marginBottom: 22, display: 'flex', flexDirection: 'column', gap: 8 }}>
              <BuyButton
                itemId={item.id}
                itemTitle={item.title}
                sellingPrice={item.selling_price}
                isLoggedIn={!!user}
              />
              <CartButton
                itemId={item.id}
                isLoggedIn={!!user}
                initialInCart={!!cartRow}
              />
            </div>

            <hr style={{ border: 'none', borderTop: '1px solid #f3f4f6', marginBottom: 24 }} />

            {/* Description */}
            {item.description && (
              <div style={{ marginBottom: 28 }}>
                <p style={{
                  fontSize: 10, fontWeight: 700, letterSpacing: '0.15em',
                  color: '#9ca3af', textTransform: 'uppercase', marginBottom: 10,
                }}>
                  Description
                </p>
                <p style={{ fontSize: 14, color: '#374151', lineHeight: 1.7 }}>
                  {item.description}
                </p>
              </div>
            )}

            {/* ── Type-aware specs — only fields relevant to this product type ── */}

            {item.product_type === 'loose_stone' && (
              <SpecSection title="Stone Details">
                <SpecRow label="Gem type"      value={item.gem_type} />
                <SpecRow label="Variety"       value={item.variety} />
                <SpecRow label="Weight"        value={looseStoneWeight} />
                <SpecRow label="Shape"         value={item.shape} />
                <SpecRow label="Cut"           value={item.cut} />
                <SpecRow label="Cut type"      value={item.cut_type} />
                <SpecRow label="Clarity"       value={item.clarity} />
                <SpecRow label="Origin"        value={originFull} />
                <SpecRow label="Treatment"     value={item.treatment} />
                <SpecRow label="Dimensions"    value={item.dimensions_mm} />
                <SpecRow label="Certification" value={certificationLine} />
              </SpecSection>
            )}

            {item.product_type === 'specimen' && (
              <SpecSection title="Specimen Details">
                <SpecRow label="Species"       value={item.species} />
                <SpecRow label="Weight"        value={specimenWeight} />
                <SpecRow label="Locality"      value={item.locality} />
                <SpecRow label="Origin"        value={item.origin_country} />
                <SpecRow label="Matrix"        value={item.matrix} />
                <SpecRow label="Treatment"     value={item.treatment} />
                <SpecRow label="Dimensions"    value={item.dimensions_mm} />
                <SpecRow label="Certification" value={certificationLine} />
              </SpecSection>
            )}

            {item.product_type === 'jewelry' && (
              <SpecSection title="Jewelry Details">
                <SpecRow label="Type"          value={item.jewelry_type} />
                <SpecRow label="Metal"         value={metalLine} />
                <SpecRow label="Size / Length" value={item.size_or_length} />
                <SpecRow label="Gemstones"     value={item.gemstones_used} />
                <SpecRow label="Total weight"  value={jewelryWeight} />
                <SpecRow label="Treatment"     value={item.treatment} />
                <SpecRow label="Dimensions"    value={item.dimensions_mm} />
                <SpecRow label="Certification" value={certificationLine} />
              </SpecSection>
            )}

            {/*
             * ── VIDEO SLOT ──────────────────────────────────────────────────
             * video_url is present in `item.video_url` but video support is
             * OUT OF SCOPE for this version. Wire up a player here next session.
             * ────────────────────────────────────────────────────────────────
             */}
          </div>
        </div>
      </main>
    </>
  );
}
