import { favouriteIds } from '@/lib/favourites'
import { fxContext } from '@/lib/fx'
import { priceContext } from '@/lib/display-price'
import { existsSync } from 'fs'
import { join } from 'path'
import Link from 'next/link'
import { createClient } from "@/lib/supabase/server";
import { ReviewSummary } from "@/app/components/ReviewSummary";
import { PUBLIC_REVIEW_COLUMNS, type PublicReview } from "@/app/reviews/ReviewList";
import { countryName } from "@/lib/countries";
import type { StoneCardItem } from "@/app/components/StoneCard";
import { HeroCollage } from '@/app/components/HeroCollage'
import { HomeBanner } from '@/app/components/HomeBanner'
import { StoneCarousel } from '@/app/components/StoneCarousel'

type ListedItem = {
  id: string;
  title: string;
  gem_type: string | null;
  variety: string | null;
  weight_value: number | null;
  weight_unit: string | null;
  origin_country: string | null;
  selling_price: number | null;
  sale_method: string;
  shipping_cost: number | null;
  seller_country: string | null;
  image_url: string | null;
  product_type?: string | null;
  listed_at?: string | null;    // sql/public_views_listed_at.sql
  is_featured?: boolean | null; // set by the owner in the admin
};

// The whole collection (all types), newest first
const SHOP_HREF = '/shop/all'

// Colour dot per gem for "Shop by gemstone"; other gems get the gold accent.
const GEM_COLORS: Record<string, string> = {
  Kunzite: '#D98BB3', Tourmaline: '#3E8E7E', Aquamarine: '#8EC3DE', Sapphire: '#2C3F8F',
  Emerald: '#2B7A3D', Spinel: '#B5333D', Ruby: '#9B1B30', Garnet: '#7A1F2B', Topaz: '#E0A458',
  Peridot: '#8DB33A', Amethyst: '#7A4E9B', Quartz: '#CFC5B4', Beryl: '#9CC7B4', Morganite: '#E8B4A8',
}

const CATEGORIES = [
  { type: 'loose_stone', label: 'Loose gemstones', blurb: 'Faceted and cabochon stones, ready to set.' },
  { type: 'specimen',    label: 'Mineral specimens', blurb: 'Crystals as nature made them.' },
  { type: 'jewelry',     label: 'Jewelry',           blurb: 'Natural gemstones, handmade settings.' },
]

const PROMISES = [
  { title: 'Natural, always',
    body: 'Never lab-grown. Every known treatment disclosed on the product page.' },
  { title: 'Certificate promise',
    body: 'If an independent lab disagrees with our description, you get a full refund, lab fee included.' },
  { title: 'Generations of knowledge',
    body: 'A family in the gem trade for over thirty years, sourcing from mines around the world.' },
]

// Facts only — each one is promised on its own page.
const TRUST = [
  { icon: '◆', title: 'Natural stones', body: 'Every treatment disclosed', href: '/guarantee' },
  { icon: '↺', title: '30-day returns', body: 'Changed your mind? Send it back', href: '/returns' },
  { icon: '✈', title: 'Tracked shipping', body: 'Worldwide, signature on high value', href: '/shipping' },
  { icon: '🔒', title: 'Secure checkout', body: 'Pay in your own currency', href: '/payment' },
]

const PAYMENTS = ['Visa', 'Mastercard', 'American Express', 'PayPal', 'Apple Pay', 'Google Pay', 'Klarna', 'iDEAL']

function SectionHeader({ title, linkLabel, href }: { title: string; linkLabel?: string; href?: string }) {
  return (
    <div className="home-section-head">
      <h2 className="font-serif home-h2">{title}</h2>
      {linkLabel && href && <Link href={href} className="home-text-link">{linkLabel}</Link>}
    </div>
  )
}

export default async function HomePage() {
  const hasHero = existsSync(join(process.cwd(), 'public', 'hero.jpg'))

  const supabase = await createClient();
  const { data, error } = await supabase.from("public_listings").select("*");
  if (error) console.error("[GemWorkers Store] Supabase error:", error.message);

  // Newest listed first — banner, carousels and everything below follow it.
  const items = ((data ?? []) as ListedItem[])
    .sort((a, b) => (b.listed_at ?? '').localeCompare(a.listed_at ?? ''));

  // Newest three approved reviews that have text — not hand-picked.
  const { data: reviewData } = await supabase
    .from("public_reviews")
    .select(PUBLIC_REVIEW_COLUMNS)
    .not("body", "is", null)
    .order("created_at", { ascending: false })
    .limit(3);
  const homeReviews = (reviewData ?? []) as PublicReview[];

  const toCard = (item: ListedItem): StoneCardItem => ({
    id:             item.id,
    title:          item.title,
    gem_type:       item.gem_type,
    variety:        item.variety,
    weight_value:   item.weight_value,
    weight_unit:    item.weight_unit,
    origin_country: item.origin_country,
    seller_country: item.seller_country,
    selling_price:  item.selling_price,
    sale_method:    item.sale_method,
    shipping_cost:  item.shipping_cost,
    image_url:      item.image_url,
  })
  const newArrivals = items.slice(0, 12).map(toCard)
  const featured = items.filter(i => i.is_featured).map(toCard)
  const withPhoto = items.filter(i => !!i.image_url)

  // Banner: a public/hero.jpg wins; otherwise the newest stones' photos.
  const heroStones = withPhoto.slice(0, 4).map(i => ({ id: i.id, title: i.title, image_url: i.image_url as string }))
  const spotlight = withPhoto.find(i => i.is_featured) ?? withPhoto[4] ?? withPhoto[0]
  const storyStone = withPhoto.find(i => i.product_type === 'specimen') ?? withPhoto[withPhoto.length - 1]

  // Category tiles: photo of the newest stone of that type.
  const categories = CATEGORIES.map(c => ({
    ...c,
    count: items.filter(i => i.product_type === c.type).length,
    photo: withPhoto.find(i => i.product_type === c.type)?.image_url ?? null,
  }))

  // Gems actually in stock, most stones first.
  const gemCounts = new Map<string, number>()
  for (const i of items) if (i.gem_type?.trim()) gemCounts.set(i.gem_type.trim(), (gemCounts.get(i.gem_type.trim()) ?? 0) + 1)
  const gems = [...gemCounts.entries()].sort((a, b) => b[1] - a[1]).slice(0, 8)

  const [pctx, favs, fx] = await Promise.all([priceContext(), favouriteIds(), fxContext()])

  const slides = [
    // 1 — who we are, with the newest stones
    <div key="s1" className="home-wrap home-hero">
      <div>
        <p className="home-eyebrow">From the mine to your hands</p>
        <h1 className="font-serif home-h1">Natural gemstones, chosen by a family of gem traders.</h1>
        <p className="home-lead">
          Every stone is hand-picked, honestly described and photographed as it is.
          Generations in the trade, now shipping worldwide.
        </p>
        <div className="home-cta-row">
          <Link href={SHOP_HREF} className="home-btn home-btn-solid">Shop the collection</Link>
          <Link href="/contact?topic=Request%20a%20stone" className="home-btn home-btn-outline">Request a stone</Link>
        </div>
        <ReviewSummary style={{ marginTop: 20 }} />
      </div>
      {hasHero ? (
        // eslint-disable-next-line @next/next/no-img-element
        <img src="/hero.jpg" alt="Natural gemstones" className="home-hero-media" style={{ objectFit: 'cover' }} />
      ) : heroStones.length > 0 ? (
        <HeroCollage stones={heroStones} />
      ) : (
        <div className="home-hero-media home-panel" aria-hidden="true" />
      )}
    </div>,
    // 2 — straight from the source, one big stone
    ...(spotlight ? [
      <div key="s2" className="home-wrap home-hero">
        <div>
          <p className="home-eyebrow">Straight from the source</p>
          <h2 className="font-serif home-h1">Afghan and Pakistani stones, chosen at the mines.</h2>
          <p className="home-lead">
            Tourmaline, kunzite, aquamarine and more — selected by our family where they are
            found, and sent to you without middlemen.
          </p>
          <div className="home-cta-row">
            <Link href={`/stones/${spotlight.id}`} className="home-btn home-btn-solid">See this stone</Link>
            <Link href={SHOP_HREF} className="home-btn home-btn-outline">New arrivals</Link>
          </div>
        </div>
        <Link href={`/stones/${spotlight.id}`} className="home-hero-media banner-photo" aria-label={spotlight.title}>
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img src={spotlight.image_url as string} alt={spotlight.title} />
        </Link>
      </div>,
    ] : []),
    // 3 — buying with confidence
    <div key="s3" className="home-wrap home-hero">
      <div>
        <p className="home-eyebrow">Buy with confidence</p>
        <h2 className="font-serif home-h1">30-day returns. Tracked worldwide.</h2>
        <p className="home-lead">
          Pay safely in your own currency with card, PayPal, Apple Pay or Klarna. If a stone
          isn&apos;t right, send it back within 30 days.
        </p>
        <div className="home-cta-row">
          <Link href="/returns" className="home-btn home-btn-solid">Returns</Link>
          <Link href="/shipping" className="home-btn home-btn-outline">Shipping</Link>
        </div>
      </div>
      <div className="home-hero-media banner-promise" aria-hidden="true">
        {TRUST.map(t => (
          <div key={t.title} className="banner-promise-item">
            <span className="banner-promise-icon">{t.icon}</span>
            <span className="banner-promise-title">{t.title}</span>
            <span className="banner-promise-body">{t.body}</span>
          </div>
        ))}
      </div>
    </div>,
  ]

  return (
    <main>
      {/* ── 1. Banner ── */}
      <HomeBanner slides={slides} />

      {/* ── 2. Trust bar ── */}
      <section className="home-trustbar">
        <div className="home-wrap home-trustbar-grid">
          {TRUST.map(t => (
            <Link key={t.title} href={t.href} className="home-trustbar-item">
              <span className="home-trustbar-icon" aria-hidden="true">{t.icon}</span>
              <span><strong>{t.title}</strong><span>{t.body}</span></span>
            </Link>
          ))}
        </div>
      </section>

      {/* ── 3. Featured (owner's ⭐ picks) ── */}
      {featured.length > 0 && (
        <section className="home-wrap home-section-tight">
          <SectionHeader title="Featured stones" linkLabel="View all →" href={SHOP_HREF} />
          <StoneCarousel items={featured} priceCtx={pctx} favouriteIds={favs} fx={fx} label="Featured stones" />
        </section>
      )}

      {/* ── 4. New arrivals ── */}
      <section className="home-wrap home-section-tight">
        <SectionHeader title="New arrivals" linkLabel="View all →" href={SHOP_HREF} />
        {newArrivals.length === 0 ? (
          <p className="home-empty">New stones are being added — check back soon.</p>
        ) : (
          <StoneCarousel items={newArrivals} priceCtx={pctx} favouriteIds={favs} fx={fx} label="New arrivals" />
        )}
      </section>

      {/* ── 5. Shop by category ── */}
      <section className="home-band">
        <div className="home-wrap home-section-tight">
          <SectionHeader title="Shop by category" linkLabel="All stones →" href={SHOP_HREF} />
          <div className="home-cat-grid">
            {categories.map(c => (
              <Link key={c.type} href={`/shop/${c.type}`} className="home-cat-tile">
                <span className="home-cat-photo">
                  {c.photo
                    // eslint-disable-next-line @next/next/no-img-element
                    ? <img src={c.photo} alt="" loading="lazy" />
                    : <span className="home-cat-empty" aria-hidden="true">◆</span>}
                </span>
                <span className="home-cat-text">
                  <span className="font-serif home-cat-label">{c.label}</span>
                  <span className="home-cat-blurb">{c.count > 0 ? `${c.count} ${c.count === 1 ? 'piece' : 'pieces'} · ${c.blurb}` : c.blurb}</span>
                </span>
              </Link>
            ))}
          </div>
        </div>
      </section>

      {/* ── 6. Shop by gemstone (gems in stock) ── */}
      {gems.length > 0 && (
        <section className="home-wrap home-section-tight">
          <SectionHeader title="Shop by gemstone" linkLabel="Search all →" href="/search" />
          <div className="home-gem-grid">
            {gems.map(([name, count]) => (
              <Link key={name} href={`${SHOP_HREF}?gem=${encodeURIComponent(name)}`} className="home-gem-tile">
                <span className="home-gem-stone" aria-hidden="true"
                  style={{ '--gem': GEM_COLORS[name] ?? '#B89A63' } as React.CSSProperties} />
                <span>{name}</span>
                <span className="home-gem-count">{count} {count === 1 ? 'piece' : 'pieces'}</span>
              </Link>
            ))}
          </div>
        </section>
      )}

      {/* ── 7. Promise band ── */}
      <section className="home-dark">
        <div className="home-wrap home-section">
          <div className="home-promise-grid">
            {PROMISES.map(p => (
              <div key={p.title}>
                <h3 className="font-serif home-promise-title">{p.title}</h3>
                <p className="home-promise-body">{p.body}</p>
              </div>
            ))}
          </div>
          <Link href="/guarantee" className="home-text-link home-promise-link">Our guarantee →</Link>
        </div>
      </section>

      {/* ── 8. Our story ── */}
      <section className="home-wrap home-section home-story">
        {storyStone ? (
          // eslint-disable-next-line @next/next/no-img-element
          <img src={storyStone.image_url as string} alt="" className="home-story-media home-story-photo" loading="lazy" />
        ) : (
          <div className="home-panel home-story-media" aria-hidden="true" />
        )}
        <div>
          <p className="home-eyebrow">Our story</p>
          <h2 className="font-serif home-h2" style={{ marginBottom: 20 }}>A family story, generations deep.</h2>
          <p className="home-lead" style={{ marginBottom: 28 }}>
            From the mines of Afghanistan and Pakistan to trusted partners in Thailand, Africa,
            the Americas and Europe. Every piece is chosen by hand.
          </p>
          <Link href="/about" className="home-text-link">Read our story →</Link>
        </div>
      </section>

      {/* ── 9. Customer reviews (only once there are approved reviews with text) ── */}
      {homeReviews.length > 0 && (
        <section className="home-band">
          <div className="home-wrap home-section">
            <SectionHeader title="What our customers say" linkLabel="Read all reviews →" href="/reviews" />
            <div className="home-review-grid">
              {homeReviews.map(r => (
                <figure key={r.id} className="home-review-card">
                  <span className="home-review-stars" aria-label={`${r.rating} out of 5 stars`}>
                    {'★'.repeat(Number(r.rating))}
                    <span style={{ color: '#DDD3C2' }}>{'★'.repeat(5 - Number(r.rating))}</span>
                  </span>
                  <blockquote className="home-review-quote">
                    “{r.body!.length > 220 ? `${r.body!.slice(0, 217).trimEnd()}…` : r.body}”
                  </blockquote>
                  <figcaption className="home-review-who">
                    {[r.reviewer_name || 'A GemWorkers customer', countryName(r.reviewer_country)]
                      .filter(Boolean).join(', ')}
                    {r.stone_title && <span className="home-review-stone">Purchased: {r.stone_title}</span>}
                  </figcaption>
                </figure>
              ))}
            </div>
          </div>
        </section>
      )}

      {/* ── 10. Ways to pay ── */}
      <section className="home-wrap home-payments">
        <p className="home-payments-label">Secure checkout by Stripe · pay with</p>
        <ul className="home-payments-list">
          {PAYMENTS.map(p => <li key={p}>{p}</li>)}
        </ul>
      </section>
    </main>
  );
}
