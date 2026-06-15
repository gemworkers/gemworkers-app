import { createClient } from "@/lib/supabase/server";

type ListedItem = {
  id: string;
  title: string;
  gem_type: string;
  variety: string;
  weight_value: number | null;
  weight_unit: string;
  origin_country: string;
  selling_price: number | null;
  seller_id: string;
  seller_name: string | null;
};

export default async function HomePage() {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from("public_listings")
    .select("*");

  if (error) {
    console.error("[GemWorkers Store] Supabase error:", error.message);
  }

  const items = (data ?? []) as ListedItem[];

  return (
    <main className="p-8 max-w-2xl mx-auto">
      <h1 className="text-2xl font-bold mb-6">GemWorkers Store</h1>

      {items.length === 0 ? (
        <p className="text-gray-500">No stones listed yet.</p>
      ) : (
        <ul className="space-y-4">
          {items.map((item) => (
            <li key={item.id} className="border border-gray-200 rounded p-4">
              <p className="font-semibold text-lg">{item.title}</p>
              {(item.gem_type || item.variety) && (
                <p className="text-sm text-gray-600">
                  Type: {[item.gem_type, item.variety].filter(Boolean).join(" · ")}
                </p>
              )}
              {item.weight_value != null && (
                <p className="text-sm text-gray-600">
                  Weight: {item.weight_value} {item.weight_unit}
                </p>
              )}
              {item.origin_country && (
                <p className="text-sm text-gray-600">Origin: {item.origin_country}</p>
              )}
              {item.selling_price != null && (
                <p className="text-sm text-gray-600">
                  Price: ${item.selling_price}
                </p>
              )}
              {item.seller_name && (
                <p className="text-sm text-gray-400">Seller: {item.seller_name}</p>
              )}
            </li>
          ))}
        </ul>
      )}
    </main>
  );
}
