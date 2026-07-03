import { createClient } from '@/lib/supabase/server';
import Link from 'next/link';
import { PhotoGallery } from './PhotoGallery';
import { BuyButton } from './BuyButton';
import { CartButton } from './CartButton';
import { OfferPanel, type BuyerOffer } from './OfferPanel';
import { VideoPlayer } from './VideoPlayer';
import { cancelPendingOrder } from '@/app/actions/commerce';
import { countryName } from '@/lib/countries';

// ── Types ─────────────────────────────────────────────────────────────────────

type ListingDetail = {
  id: string;
  title: string;
  product_type: 'loose_stone' | 'specimen' | 'jewelry';
  selling_price: number | null;
  sale_method: 'buy_now' | 'accept_offers' | 'both';
  description: string | null;
  image_urls: string[] | null;

  video_url: string | null;

  // Shared / common
  certification_lab: string | null;
  certification_number: string | null;
  treatment: string | null;
  dimensions_mm: string | null;
  length: number | null;
  width: number | null;
  height: number | null;
  dimension_unit: string | null;

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
  weight_grams_unit: string | null;

  // jewelry
  jewelry_type: string | null;
  metal: string | null;
  metal_purity: string | null;
  size_or_length: string | null;
  gemstones_used: string | null;
  total_weight_grams: number | null;
  total_weight_grams_unit: string | null;

  // shipping
  seller_country: string | null;
  courier: string | null;
  shipping_cost: number | null;
  delivery_days_min: number | null;
  delivery_days_max: number | null;
  prep_days: number | null;
};

// ── Helpers ───────────────────────────────────────────────────────────────────

const eur = new Intl.NumberFormat('en-IE', {
  style: 'currency',
  currency: 'EUR',
  maximumFractionDigits: 0,
});

function SpecRow({
  label,
  value,
}: {
  label: string;
  value: string | number | null | undefined;
}) {
  if (value == null || value === '') return null;
  return (
    <div style={{
      display: 'flex', alignItems: 'flex-start',
      padding: '8px 12px',
      borderBottom: '1px solid #2a2a30',
    }}>
      <span style={{
        flexShrink: 0, width: 120, paddingRight: 12,
        color: '#9d9080', fontSize: 13,
        fontFamily: 'var(--font-inter, system-ui)',
      }}>
        {label}
      </span>
      <span style={{
        color: '#f5f0e8', fontSize: 13,
        fontFamily: 'var(--font-inter, system-ui)',
      }}>
        {String(value)}
      </span>
    </div>
  );
}

function SpecSection({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <div style={{ marginBottom: 24 }}>
      <p style={{
        fontSize: 9, fontWeight: 700, letterSpacing: '0.18em',
        color: '#c9a962', textTransform: 'uppercase', marginBottom: 8,
        fontFamily: 'var(--font-inter, system-ui)',
      }}>
        {title}
      </p>
      <div style={{
        border: '1px solid #2a2a30', borderRadius: 6, overflow: 'hidden',
      }}>
        {children}
      </div>
    </div>
  );
}

// ── Not-available state ───────────────────────────────────────────────────────

function NotAvailable() {
  return (
    <main style={{ maxWidth: 1100, margin: '0 auto', padding: '120px 32px', textAlign: 'center' }}>
      <div style={{
        fontSize: 52, color: '#2a2a30', marginBottom: 18, lineHeight: 1,
        fontFamily: 'var(--font-cormorant, Georgia, serif)',
      }}>◇</div>
      <p style={{
        fontSize: 18, fontWeight: 300, color: '#f5f0e8', marginBottom: 8,
        fontFamily: 'var(--font-cormorant, Georgia, serif)',
      }}>
        This item is not available
      </p>
      <p style={{
        fontSize: 13, color: '#9d9080', marginBottom: 36,
        fontFamily: 'var(--font-inter, system-ui)',
      }}>
        It may have been sold, unlisted, or the link may be incorrect.
      </p>
      <Link href="/" style={{
        display: 'inline-block', padding: '11px 28px',
        border: '1px solid rgba(201,169,98,0.5)', color: '#c9a962',
        borderRadius: 6, textDecoration: 'none', fontSize: 12,
        fontWeight: 600, letterSpacing: '0.1em',
        fontFamily: 'var(--font-inter, system-ui)',
      }}>
        Browse all stones
      </Link>
    </main>
  );
}

// ── Page ──────────────────────────────────────────────────────────────────────

export default async function StoneDetailPage({
  params,
  searchParams,
}: {
  params: Promise<{ id: string }>;
  searchParams: Promise<{ canceled?: string; order?: string }>;
}) {
  const [{ id }, { canceled, order: canceledOrderId }] = await Promise.all([
    params,
    searchParams,
  ]);

  if (canceled === '1' && canceledOrderId) {
    await cancelPendingOrder(canceledOrderId);
  }

  const supabase = await createClient();
  const [{ data: { user } }, { data, error }, { data: cartRow }, { data: offerRow }] =
    await Promise.all([
      supabase.auth.getUser(),
      supabase
        .from('public_listing_details')
        .select('*')
        .eq('id', id)
        .maybeSingle(),
      supabase
        .from('storefront_cart')
        .select('id')
        .eq('inventory_item_id', id)
        .maybeSingle(),
      supabase
        .from('storefront_offers')
        .select('id, offered_price, status')
        .eq('inventory_item_id', id)
        .in('status', ['pending', 'accepted', 'declined', 'expired'])
        .order('created_at', { ascending: false })
        .limit(1)
        .maybeSingle(),
    ]);

  if (error || !data) {
    return <NotAvailable />;
  }

  const item = data as ListingDetail;
  const photos = item.image_urls ?? [];

  const looseStoneWeight =
    item.weight_value != null && Number(item.weight_value) > 0
      ? `${item.weight_value} ${item.weight_unit ?? ''}`.trim()
      : null;

  const specimenWeight =
    item.weight_grams != null && Number(item.weight_grams) > 0
      ? `${item.weight_grams} ${item.weight_grams_unit ?? 'g'}`
      : null;

  const jewelryWeight =
    item.total_weight_grams != null && Number(item.total_weight_grams) > 0
      ? `${item.total_weight_grams} ${item.total_weight_grams_unit ?? 'g'}`
      : null;

  const structuredDimensions = (() => {
    const parts = [item.length, item.width, item.height]
      .filter((v): v is number => v != null)
      .map(String)
    if (parts.length === 0) return null
    return `${parts.join(' × ')} ${item.dimension_unit ?? 'mm'}`
  })()

  const originFull = [item.origin_country, item.origin_region]
    .filter((v) => v && v.trim())
    .join(', ') || null;

  const certificationLine = [item.certification_lab, item.certification_number]
    .filter((v) => v && v.trim())
    .join(' · ') || null;

  const metalLine = [item.metal, item.metal_purity]
    .filter((v) => v && v.trim())
    .join(' ') || null;

  const cost = item.shipping_cost == null ? null : Number(item.shipping_cost);
  const shippingCostDisplay =
    cost === null ? null : cost === 0 ? 'Free' : `€${cost.toFixed(0)}`;

  const deliveryRange =
    item.delivery_days_min != null && item.delivery_days_max != null
      ? `${item.delivery_days_min}–${item.delivery_days_max} days`
      : item.delivery_days_min != null
        ? `From ${item.delivery_days_min} days`
        : null;

  const shipFromName = countryName(item.seller_country)

  const hasShipping =
    item.seller_country != null ||
    item.courier != null ||
    item.shipping_cost != null ||
    item.delivery_days_min != null ||
    item.delivery_days_max != null ||
    item.prep_days != null;

  return (
    <main style={{ maxWidth: 1100, margin: '0 auto', padding: '32px 32px 80px' }}>
      {/* Back to browse */}
      <Link href="/" className="back-link" style={{
        display: 'inline-flex', alignItems: 'center', gap: 6,
        fontSize: 12, textDecoration: 'none',
        marginBottom: 28, letterSpacing: '0.04em',
        fontFamily: 'var(--font-inter, system-ui)',
      }}>
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none"
          stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <polyline points="15 18 9 12 15 6" />
        </svg>
        Back to browse
      </Link>

      {/* Cancel-return notice */}
      {canceled === '1' && (
        <div style={{
          marginBottom: 28,
          padding: '12px 16px',
          background: 'rgba(201,169,98,0.08)',
          border: '1px solid rgba(201,169,98,0.25)',
          borderRadius: 8,
          fontSize: 13,
          color: '#c9a962',
          fontFamily: 'var(--font-inter, system-ui)',
        }}>
          Payment canceled — this stone is available again.
        </div>
      )}

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
            fontSize: 28, fontWeight: 300, color: '#f5f0e8', lineHeight: 1.2,
            marginBottom: 10,
            fontFamily: 'var(--font-cormorant, Georgia, serif)',
          }}>
            {item.title}
          </h1>

          {/* Price */}
          {item.sale_method === 'accept_offers' ? (
            <p style={{
              fontSize: 20, color: '#9d9080', marginBottom: 16,
              fontFamily: 'var(--font-cormorant, Georgia, serif)',
            }}>
              Make an offer
            </p>
          ) : item.selling_price != null ? (
            <p style={{
              fontSize: 36, fontWeight: 400, color: '#f5f0e8',
              letterSpacing: '-0.01em', marginBottom: 16,
              fontFamily: 'var(--font-cormorant, Georgia, serif)',
            }}>
              {eur.format(Number(item.selling_price))}
            </p>
          ) : (
            <p style={{
              fontSize: 20, color: '#4a4440', marginBottom: 16,
              fontFamily: 'var(--font-cormorant, Georgia, serif)',
            }}>
              Price on request
            </p>
          )}

          {/* Stone / Shipping / Total */}
          {item.selling_price != null && cost !== null && cost > 0 && (
            <div style={{ marginBottom: 14 }}>
              <div style={{
                display: 'flex', justifyContent: 'space-between',
                fontSize: 13, color: '#9d9080', marginBottom: 3,
              }}>
                <span>Stone</span>
                <span>{eur.format(Number(item.selling_price))}</span>
              </div>
              <div style={{
                display: 'flex', justifyContent: 'space-between',
                fontSize: 13, color: '#9d9080', marginBottom: 6,
              }}>
                <span>Shipping</span>
                <span>{eur.format(cost)}</span>
              </div>
              <div style={{ height: 1, background: '#2a2a30', marginBottom: 6 }} />
              <div style={{
                display: 'flex', justifyContent: 'space-between',
                fontSize: 14, fontWeight: 600, color: '#f5f0e8',
              }}>
                <span>Total</span>
                <span>{eur.format(Number(item.selling_price) + cost)}</span>
              </div>
            </div>
          )}

          {/* Actions */}
          <div style={{ marginBottom: 22, display: 'flex', flexDirection: 'column', gap: 8 }}>
            {item.sale_method !== 'accept_offers' && (
              <BuyButton
                itemId={item.id}
                itemTitle={item.title}
                sellingPrice={item.selling_price}
                shippingCost={cost}
                isLoggedIn={!!user}
              />
            )}
            <CartButton
              itemId={item.id}
              isLoggedIn={!!user}
              initialInCart={!!cartRow}
            />
            {item.sale_method !== 'buy_now' && (
              <OfferPanel
                itemId={item.id}
                isLoggedIn={!!user}
                initialOffer={offerRow as BuyerOffer | null}
              />
            )}
          </div>

          <hr style={{ border: 'none', borderTop: '1px solid #2a2a30', marginBottom: 24 }} />

          {/* Description */}
          {item.description && (
            <div style={{ marginBottom: 28 }}>
              <p style={{
                fontSize: 9, fontWeight: 700, letterSpacing: '0.18em',
                color: '#c9a962', textTransform: 'uppercase', marginBottom: 8,
                fontFamily: 'var(--font-inter, system-ui)',
              }}>
                Description
              </p>
              <p style={{
                fontSize: 14, color: '#9d9080', lineHeight: 1.7,
                fontFamily: 'var(--font-inter, system-ui)',
              }}>
                {item.description}
              </p>
            </div>
          )}

          {/* Type-aware specs */}

          {item.product_type === 'loose_stone' && (
            <SpecSection title="Stone Details">
              <SpecRow label="Gem type"      value={item.gem_type} />
              <SpecRow label="Variety"       value={item.variety} />
              <SpecRow label="Weight"        value={looseStoneWeight} />
              <SpecRow label="Shape"         value={item.shape} />
              <SpecRow label="Cut"           value={item.cut_type} />
              <SpecRow label="Clarity"       value={item.clarity} />
              <SpecRow label="Origin"        value={originFull} />
              <SpecRow label="Treatment"     value={item.treatment} />
              <SpecRow label="Dimensions"    value={structuredDimensions} />
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
              <SpecRow label="Dimensions"    value={structuredDimensions} />
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
              <SpecRow label="Certification" value={certificationLine} />
            </SpecSection>
          )}

          {hasShipping && (
            <SpecSection title="Shipping">
              <SpecRow label="Ships from" value={shipFromName} />
              <SpecRow label="Courier"    value={item.courier} />
              <SpecRow label="Cost"       value={shippingCostDisplay} />
              <SpecRow label="Delivery"   value={deliveryRange} />
              {item.prep_days != null && (
                <SpecRow label="Handling" value={`Ready in ${item.prep_days} days`} />
              )}
            </SpecSection>
          )}

          {item.video_url && <VideoPlayer url={item.video_url} />}
        </div>
      </div>
    </main>
  );
}
