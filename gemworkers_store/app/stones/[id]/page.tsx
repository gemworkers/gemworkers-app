import { createClient } from '@/lib/supabase/server';
import Link from 'next/link';
import { PhotoGallery } from './PhotoGallery';
import { BuyButton } from './BuyButton';
import { CartButton } from './CartButton';
import { OfferPanel, type BuyerOffer } from './OfferPanel';
import { VideoPlayer } from './VideoPlayer';
import { pillDark } from '@/lib/ui';
import { cancelPendingOrder } from '@/app/actions/commerce';
import { countryName } from '@/lib/countries';
import { TrustList } from '@/app/components/TrustList';

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

const CATEGORY: Record<ListingDetail['product_type'], { label: string; href: string }> = {
  loose_stone: { label: 'Loose Gemstones', href: '/shop/loose_stone' },
  specimen:    { label: 'Specimens',       href: '/shop/specimen' },
  jewelry:     { label: 'Jewelry',         href: '/shop/jewelry' },
};

function DetailRow({ label, value }: { label: string; value: React.ReactNode }) {
  if (value == null || value === '') return null;
  return (
    <div className="pd-row">
      <dt>{label}</dt>
      <dd>{value}</dd>
    </div>
  );
}

function DetailSection({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <section>
      <h2 className="font-serif pd-h2">{title}</h2>
      <dl className="pd-dl">{children}</dl>
    </section>
  );
}

function joinParts(parts: (string | null | undefined)[], sep: string): string | null {
  return parts.filter((v): v is string => !!v && !!v.trim()).join(sep) || null;
}

// ── Not-available state ───────────────────────────────────────────────────────

function NotAvailable() {
  return (
    <main className="pd-wrap" style={{ paddingTop: 120, paddingBottom: 120, textAlign: 'center' }}>
      <h1 className="font-serif pd-title" style={{ marginBottom: 14 }}>
        This item is not available
      </h1>
      <p style={{ fontSize: 16, color: '#5A5045', marginBottom: 36, lineHeight: 1.6 }}>
        It may have been sold, unlisted, or the link may be incorrect.
      </p>
      <Link href="/shop/loose_stone" style={{ ...pillDark, display: 'inline-flex', width: 'auto' }}>
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
  const category = CATEGORY[item.product_type] ?? CATEGORY.loose_stone;
  const nextParam = encodeURIComponent(`/stones/${item.id}`);

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
  // Older listings only have the retired free-text field
  const dimensions = structuredDimensions ?? (item.dimensions_mm?.trim() || null);

  const originFull = joinParts([item.origin_country, item.origin_region], ', ');
  const certificationLine = joinParts([item.certification_lab, item.certification_number], ' · ');
  const metalLine = joinParts([item.metal, item.metal_purity], ' ');

  const treatmentValue = item.treatment?.trim() ? item.treatment : (
    <>
      Not specified — common treatments may apply (see{' '}
      <Link href="/guarantee" className="pd-link">Our Guarantee</Link>)
    </>
  );
  const certificateValue = item.certification_lab?.trim() ? certificationLine : (
    <Link href="/contact?topic=Certificate%20request" className="pd-link">Available on request</Link>
  );

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

  // ── Header copy ──
  const eyebrow =
    joinParts([item.gem_type, item.variety], ' · ') ?? item.species ?? item.jewelry_type ?? null;
  const metaLine = joinParts([
    looseStoneWeight ?? specimenWeight ?? jewelryWeight,
    item.shape || item.cut_type,
    item.origin_country,
  ], ' · ');
  const shippingLine = joinParts([
    cost === null ? null : cost === 0 ? 'Free shipping' : `+ ${eur.format(cost)} shipping`,
    shipFromName ? `Ships from ${shipFromName}` : null,
  ], ' · ');

  return (
    <main className="pd-wrap" style={{ paddingTop: 28, paddingBottom: 96 }}>
      {/* Breadcrumb */}
      <nav aria-label="Breadcrumb" className="pd-crumbs">
        <Link href="/">Home</Link>
        <span aria-hidden="true">/</span>
        <Link href={category.href}>{category.label}</Link>
        <span aria-hidden="true">/</span>
        <span aria-current="page" className="pd-crumb-current">{item.title}</span>
      </nav>

      {/* Cancel-return notice */}
      {canceled === '1' && (
        <div style={{
          marginBottom: 32, padding: '14px 20px',
          background: '#F4EEE4', border: '1px solid #ECE5D8', borderRadius: 18,
          fontSize: 15, color: '#1F1B16',
        }}>
          Payment canceled — this stone is available again.
        </div>
      )}

      {/* ── Two-column layout ── */}
      <div className="pd-grid">

        {/* ── Left: gallery + video ── */}
        <div style={{ minWidth: 0 }}>
          <PhotoGallery imageUrls={photos} title={item.title} />
          {item.video_url && <VideoPlayer url={item.video_url} />}
        </div>

        {/* ── Right: info panel ── */}
        <div className="pd-info">
          {eyebrow && <p className="pd-eyebrow">{eyebrow}</p>}

          <h1 className="font-serif pd-title">{item.title}</h1>

          {metaLine && <p className="pd-meta">{metaLine}</p>}

          {/* Price */}
          <div style={{ marginTop: 24, marginBottom: 28 }}>
            {item.sale_method === 'accept_offers' ? (
              <p className="pd-price">Make an offer</p>
            ) : item.selling_price != null ? (
              <p className="pd-price">{eur.format(Number(item.selling_price))}</p>
            ) : (
              <p className="pd-price" style={{ color: '#6B6052' }}>Price on request</p>
            )}
            {shippingLine && <p className="pd-shipline">{shippingLine}</p>}
          </div>

          {/* Actions */}
          {user ? (
            <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
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
          ) : (
            <div>
              <Link href={`/auth/login?next=${nextParam}`} style={pillDark}>
                Log in to buy
              </Link>
              <p style={{ fontSize: 14, color: '#6B6052', marginTop: 12, textAlign: 'center' }}>
                New here?{' '}
                <Link href={`/auth/signup?next=${nextParam}`} className="pd-link">Create an account</Link>
              </p>
            </div>
          )}

          {/* Trust list */}
          <TrustList />

          <Link href="/contact?topic=General%20question" className="pd-link" style={{ fontSize: 15 }}>
            Questions about this stone? →
          </Link>
        </div>
      </div>

      {/* ── Description + details ── */}
      <div className="pd-below">
        {item.description && (
          <section style={{ marginBottom: 56 }}>
            <h2 className="font-serif pd-h2">Description</h2>
            <p className="pd-desc">{item.description}</p>
          </section>
        )}

        <div className="pd-details-grid">
          {item.product_type === 'loose_stone' && (
            <DetailSection title="Details">
              <DetailRow label="Gem type"    value={item.gem_type} />
              <DetailRow label="Variety"     value={item.variety} />
              <DetailRow label="Weight"      value={looseStoneWeight} />
              <DetailRow label="Shape"       value={item.shape} />
              <DetailRow label="Cut"         value={item.cut_type} />
              <DetailRow label="Clarity"     value={item.clarity} />
              <DetailRow label="Origin"      value={originFull} />
              <DetailRow label="Treatment"   value={treatmentValue} />
              <DetailRow label="Dimensions"  value={dimensions} />
              <DetailRow label="Certificate" value={certificateValue} />
            </DetailSection>
          )}

          {item.product_type === 'specimen' && (
            <DetailSection title="Details">
              <DetailRow label="Species"     value={item.species} />
              <DetailRow label="Weight"      value={specimenWeight} />
              <DetailRow label="Locality"    value={item.locality} />
              <DetailRow label="Origin"      value={item.origin_country} />
              <DetailRow label="Matrix"      value={item.matrix} />
              <DetailRow label="Treatment"   value={treatmentValue} />
              <DetailRow label="Dimensions"  value={dimensions} />
              <DetailRow label="Certificate" value={certificateValue} />
            </DetailSection>
          )}

          {item.product_type === 'jewelry' && (
            <DetailSection title="Details">
              <DetailRow label="Type"          value={item.jewelry_type} />
              <DetailRow label="Metal"         value={metalLine} />
              <DetailRow label="Size / Length" value={item.size_or_length} />
              <DetailRow label="Gemstones"     value={item.gemstones_used} />
              <DetailRow label="Total weight"  value={jewelryWeight} />
              <DetailRow label="Treatment"     value={treatmentValue} />
              <DetailRow label="Certificate"   value={certificateValue} />
            </DetailSection>
          )}

          {hasShipping && (
            <DetailSection title="Shipping">
              <DetailRow label="Ships from" value={shipFromName} />
              <DetailRow label="Courier"    value={item.courier} />
              <DetailRow label="Cost"       value={shippingCostDisplay} />
              <DetailRow label="Delivery"   value={deliveryRange} />
              {item.prep_days != null && (
                <DetailRow label="Handling" value={`Ready in ${item.prep_days} days`} />
              )}
            </DetailSection>
          )}
        </div>
      </div>
    </main>
  );
}
