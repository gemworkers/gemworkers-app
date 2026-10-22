import { existsSync } from 'fs'
import { join } from 'path'
import Link from 'next/link'
import { createClient } from "@/lib/supabase/server";
import { ReviewSummary } from "@/app/components/ReviewSummary";
import { StoneGrid } from "@/app/components/StoneGrid";
import type { StoneCardItem } from "@/app/components/StoneCard";

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
};

// Same route the header uses for "Loose Gemstones"
const SHOP_HREF = '/shop/loose_stone'

const GEMS = [
  { name: 'Kunzite',    color: '#D98BB3' },
  { name: 'Tourmaline', color: '#3E8E7E' },
  { name: 'Aquamarine', color: '#8EC3DE' },
  { name: 'Sapphire',   color: '#2C3F8F' },
  { name: 'Emerald',    color: '#2B7A3D' },
  { name: 'Spinel',     color: '#B5333D' },
]

const PROMISES = [
  { title: 'Natural, always',
    body: 'Never lab-grown. Every known treatment disclosed on the product page.' },
  { title: 'Certificate promise',
    body: 'If an independent lab disagrees with our description, you get a full refund, lab fee included.' },
  { title: 'Generations of knowledge',
    body: 'A family in the gem trade for over thirty years, sourcing from mines around the world.' },
]

function SectionHeader({ title, linkLabel, href }: { title: string; linkLabel: string; href: string }) {
  return (
    <div className="home-section-head">
      <h2 className="font-serif home-h2">{title}</h2>
      <Link href={href} className="home-text-link">{linkLabel}</Link>
    </div>
  )
}

export default async function HomePage() {
  const hasHero = existsSync(join(process.cwd(), 'public', 'hero.jpg'))

  const supabase = await createClient();
  const { data, error } = await supabase.from("public_listings").select("*");
  if (error) console.error("[GemWorkers Store] Supabase error:", error.message);

  const items = (data ?? []) as ListedItem[];
  const cardItems: StoneCardItem[] = items.map(item => ({
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
  }))
  // public_listings exposes no listing timestamp, so view order is used as-is.
  const newArrivals = cardItems.slice(0, 8)

  return (
    <main>
      {/* ── 1. Hero ── */}
      <section className="home-wrap home-hero">
        <div>
          <p className="home-eyebrow">From the mine to your hands</p>
          <h1 className="font-serif home-h1">
            Natural gemstones, chosen by a family of gem traders.
          </h1>
          <p className="home-lead">
            Every stone is hand-picked, honestly described and photographed as it is.
            Generations in the trade, now shipping worldwide.
          </p>
          <div className="home-cta-row">
            <Link href={SHOP_HREF} className="home-btn home-btn-solid">Shop the collection</Link>
            <Link href="/contact?topic=Request%20a%20stone" className="home-btn home-btn-outline">
              Request a stone
            </Link>
          </div>
          <ReviewSummary style={{ marginTop: 20 }} />
        </div>

        {hasHero ? (
          // eslint-disable-next-line @next/next/no-img-element
          <img src="/hero.jpg" alt="Natural gemstones" className="home-hero-media" style={{ objectFit: 'cover' }} />
        ) : (
          <div className="home-hero-media home-panel" aria-hidden="true" />
        )}
      </section>

      {/* ── 2. Shop by gemstone ── */}
      <section className="home-band">
        <div className="home-wrap home-section">
          <SectionHeader title="Shop by gemstone" linkLabel="All gemstones →" href="/search" />
          <div className="home-gem-grid">
            {GEMS.map(g => (
              <Link key={g.name} href={`/search?q=${encodeURIComponent(g.name)}`} className="home-gem-tile">
                <span className="home-gem-stone" aria-hidden="true"
                  style={{ '--gem': g.color } as React.CSSProperties} />
                <span>{g.name}</span>
              </Link>
            ))}
          </div>
        </div>
      </section>

      {/* ── 3. New arrivals ── */}
      <section className="home-wrap home-section">
        <SectionHeader title="New arrivals" linkLabel="View all →" href={SHOP_HREF} />
        {newArrivals.length === 0 ? (
          <p className="home-empty">New stones are being added — check back soon.</p>
        ) : (
          <StoneGrid items={newArrivals} className="home-arrivals-grid" />
        )}
      </section>

      {/* ── 5. Promise band ── */}
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

      {/* ── 6. Our story teaser ── */}
      <section className="home-wrap home-section home-story">
        <div className="home-panel home-story-media" aria-hidden="true" />
        <div>
          <p className="home-eyebrow">Our story</p>
          <h2 className="font-serif home-h2" style={{ marginBottom: 20 }}>
            A family story, generations deep.
          </h2>
          <p className="home-lead" style={{ marginBottom: 28 }}>
            From the mines of Afghanistan and Pakistan to trusted partners in Thailand, Africa,
            the Americas and Europe. Every piece is chosen by hand.
          </p>
          <Link href="/about" className="home-text-link">Read our story →</Link>
        </div>
      </section>
    </main>
  );
}
