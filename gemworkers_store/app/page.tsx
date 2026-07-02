import { createClient } from "@/lib/supabase/server";
import { StoneGrid } from "@/app/components/StoneGrid";
import { HeroSection } from "@/app/components/HeroSection";
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
  seller_id: string;
  image_url: string | null;
};

export default async function HomePage() {
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
    selling_price:  item.selling_price,
    sale_method:    item.sale_method,
    shipping_cost:  item.shipping_cost,
    image_url:      item.image_url,
  }))

  return (
    <main>

      {/* ── Hero ──────────────────────────────────────────────────────── */}
      <HeroSection />

      <div className="gold-rule" />

      {/* ── Collection grid ───────────────────────────────────────────── */}
      <section style={{ maxWidth: 1400, margin: '0 auto', padding: '60px 32px 80px' }}>

        <div style={{
          display: 'flex', alignItems: 'baseline', justifyContent: 'space-between',
          marginBottom: 36, gap: 12,
        }}>
          <p style={{
            fontSize: 10, fontWeight: 700, letterSpacing: '0.2em', textTransform: 'uppercase',
            color: '#c9a962', fontFamily: 'var(--font-inter, system-ui)',
          }}>
            The Collection
          </p>
          <p style={{
            fontSize: 11, color: '#4a4440', letterSpacing: '0.06em',
            fontFamily: 'var(--font-inter, system-ui)',
          }}>
            {items.length} {items.length === 1 ? 'stone' : 'stones'}
          </p>
        </div>

        {items.length === 0 ? (
          <div style={{ textAlign: 'center', padding: '100px 0' }}>
            <div style={{
              fontSize: 32, color: '#2a2a30', marginBottom: 16,
              fontFamily: 'var(--font-cormorant, Georgia, serif)',
            }}>
              ◇
            </div>
            <p style={{
              fontSize: 15, color: '#4a4440', letterSpacing: '0.04em',
              fontFamily: 'var(--font-inter, system-ui)',
            }}>
              No stones listed yet.
            </p>
          </div>
        ) : (
          <StoneGrid items={cardItems} />
        )}
      </section>

    </main>
  );
}
