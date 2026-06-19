import { createClient } from "@/lib/supabase/server";
import Link from "next/link";
import { StoreHeader } from "@/app/components/StoreHeader";

type ListedItem = {
  id: string;
  title: string;
  gem_type: string;
  variety: string;
  weight_value: number | null;
  weight_unit: string;
  origin_country: string;
  selling_price: number | null;
  sale_method: string;
  shipping_cost: number | null;
  seller_id: string;
  seller_name: string | null;
  image_url: string | null;
};

const eur = new Intl.NumberFormat("en-IE", {
  style: "currency",
  currency: "EUR",
  maximumFractionDigits: 0,
});

export default async function HomePage() {
  const supabase = await createClient();
  const { data, error } = await supabase.from("public_listings").select("*");

  if (error) console.error("[GemWorkers Store] Supabase error:", error.message);

  const items = (data ?? []) as ListedItem[];

  return (
    <>
      <style>{`
        body { background: #fafaf9; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif; }
        .stone-card { transition: border-color 0.15s ease, box-shadow 0.15s ease; }
        .stone-card:hover { border-color: #9ca3af !important; box-shadow: 0 2px 14px rgba(0,0,0,0.07); }
        .stones-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 20px; }
        @media (max-width: 480px) {
          .stones-grid { grid-template-columns: repeat(auto-fill, minmax(160px, 1fr)); gap: 12px; }
        }
      `}</style>

      <StoreHeader />

      {/* ── Main ── */}
      <main style={{ maxWidth: 1400, margin: "0 auto", padding: "28px 32px 80px" }}>

        {/* Stone count */}
        <p style={{ fontSize: 12, color: "#9ca3af", marginBottom: 24, letterSpacing: "0.04em" }}>
          Showing {items.length} of {items.length} stones
        </p>

        {/* Empty state */}
        {items.length === 0 ? (
          <div style={{ textAlign: "center", padding: "100px 0" }}>
            <div style={{ fontSize: 36, color: "#d1d5db", marginBottom: 14 }}>◇</div>
            <p style={{ fontSize: 15, color: "#9ca3af", letterSpacing: "0.01em" }}>
              No stones listed yet.
            </p>
          </div>
        ) : (
          <div className="stones-grid">
            {items.map((item) => {
              const gemLabel = item.variety?.trim() || item.gem_type?.trim() || null;
              const originLabel = item.origin_country?.trim() || null;
              const subtitle = [gemLabel, originLabel].filter(Boolean).join(" · ");
              const initial = gemLabel ? gemLabel.charAt(0).toUpperCase() : "◇";
              const hasWeight = item.weight_value != null && Number(item.weight_value) > 0;
              // Normalize once: null → omit, 0 → free, >0 → cost
              const cost = item.shipping_cost == null ? null : Number(item.shipping_cost);

              return (
                <Link
                  key={item.id}
                  href={`/stones/${item.id}`}
                  className="stone-card"
                  style={{
                    display: "block", textDecoration: "none", color: "inherit",
                    border: "1px solid #e5e7eb", borderRadius: 10, overflow: "hidden",
                    background: "#fff",
                  }}
                >
                  {/* ── Image area ── */}
                  <div style={{ position: "relative", aspectRatio: "1", overflow: "hidden" }}>
                    {item.image_url ? (
                      // eslint-disable-next-line @next/next/no-img-element
                      <img
                        src={item.image_url}
                        alt={item.title}
                        style={{
                          width: "100%", height: "100%",
                          objectFit: "cover", display: "block",
                        }}
                      />
                    ) : (
                      <div style={{
                        width: "100%", height: "100%",
                        display: "flex", alignItems: "center", justifyContent: "center",
                        background: "linear-gradient(145deg, #f6f3ef 0%, #ece8e2 100%)",
                      }}>
                        <span style={{
                          fontSize: 48, color: "#c4b8ab", fontWeight: 300,
                          fontFamily: "Georgia, 'Times New Roman', serif", lineHeight: 1,
                          userSelect: "none",
                        }}>
                          {initial}
                        </span>
                      </div>
                    )}

                    {/* Carat badge */}
                    {hasWeight && (
                      <div style={{
                        position: "absolute", top: 8, right: 8,
                        background: "rgba(255,255,255,0.92)",
                        backdropFilter: "blur(6px)",
                        borderRadius: 4, padding: "2px 8px",
                        fontSize: 11, fontWeight: 600, color: "#374151", letterSpacing: "0.03em",
                      }}>
                        {item.weight_value} {item.weight_unit}
                      </div>
                    )}
                  </div>

                  {/* ── Card body ── */}
                  <div style={{ padding: "12px 14px 14px" }}>
                    <p style={{
                      fontSize: 14, fontWeight: 600, color: "#111",
                      lineHeight: 1.35, marginBottom: subtitle ? 4 : 10,
                    }}>
                      {item.title}
                    </p>
                    {subtitle && (
                      <p style={{ fontSize: 12, color: "#9ca3af", marginBottom: 10, lineHeight: 1.4 }}>
                        {subtitle}
                      </p>
                    )}
                    <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
                      {item.sale_method === 'accept_offers' ? (
                        <span style={{ fontSize: 13, color: "#9ca3af", fontStyle: "italic" }}>Offers</span>
                      ) : item.selling_price != null ? (
                        <span style={{ fontSize: 15, fontWeight: 700, color: "#111", letterSpacing: "-0.01em" }}>
                          {eur.format(Number(item.selling_price))}
                        </span>
                      ) : (
                        <span style={{ fontSize: 13, color: "#d1d5db" }}>—</span>
                      )}
                      {item.seller_name && (
                        <span style={{
                          display: "flex", alignItems: "center", gap: 4,
                          fontSize: 11, color: "#9ca3af",
                        }}>
                          {/* Store icon */}
                          <svg width="11" height="11" viewBox="0 0 24 24" fill="none"
                            stroke="currentColor" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round">
                            <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
                            <polyline points="9,22 9,12 15,12 15,22" />
                          </svg>
                          {item.seller_name}
                        </span>
                      )}
                    </div>
                    {/* cost: null → omit, 0 → "Free shipping", >0 → price */}
                    {cost !== null && (
                      <p style={{
                        fontSize: 11, marginTop: 5,
                        color: cost === 0 ? "#16a34a" : "#6b7280",
                      }}>
                        {cost === 0 ? "Free shipping" : `+ €${cost.toFixed(0)} shipping`}
                      </p>
                    )}
                  </div>
                </Link>
              );
            })}
          </div>
        )}
      </main>
    </>
  );
}
