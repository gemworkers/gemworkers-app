import { createClient } from '@/lib/supabase/server'
import { notFound, redirect } from 'next/navigation'
import Link from 'next/link'
import { ReviewForm } from './ReviewForm'
import { panel } from '@/lib/ui'

export const metadata = { title: 'Write a review · GemWorkers' }

const UUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i
const REVIEWABLE = ['shipped', 'received', 'paid']

export default async function WriteReviewPage({ params }: { params: Promise<{ orderId: string }> }) {
  const { orderId } = await params

  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect(`/auth/login?next=${encodeURIComponent(`/reviews/write/${orderId}`)}`)
  if (!UUID_RE.test(orderId)) notFound()

  // orders_buyer_select RLS: another buyer's order id returns nothing.
  const [{ data: order }, { data: existing }] = await Promise.all([
    supabase
      .from('orders')
      .select('id, order_number, status, order_items ( inventory_item_id )')
      .eq('id', orderId)
      .maybeSingle(),
    supabase.from('reviews').select('id').eq('order_id', orderId).maybeSingle(),
  ])
  if (!order) notFound()

  const itemId = (order.order_items as { inventory_item_id: string }[] | null)?.[0]?.inventory_item_id
  let title = 'your stone'
  let imageUrl: string | null = null
  if (itemId) {
    const { data: stone } = await supabase
      .from('buyer_purchased_stones')
      .select('title, image_url')
      .eq('id', itemId)
      .maybeSingle()
    title = stone?.title ?? title
    imageUrl = stone?.image_url ?? null
  }

  const reviewable = REVIEWABLE.includes(order.status as string)

  return (
    <main className="pd-wrap browse-main" style={{ maxWidth: 640 }}>
      <nav aria-label="Breadcrumb" className="pd-crumbs">
        <Link href="/">Home</Link>
        <span aria-hidden="true">/</span>
        <Link href="/orders">Orders</Link>
        <span aria-hidden="true">/</span>
        <span aria-current="page">Write a review</span>
      </nav>

      <h1 className="font-serif browse-title">Write a review</h1>

      <div style={{ display: 'flex', alignItems: 'center', gap: 14, margin: '8px 0 24px' }}>
        <div className="order-thumb" style={{ width: 64, height: 64 }}>
          {imageUrl && (
            // eslint-disable-next-line @next/next/no-img-element
            <img src={imageUrl} alt={title} />
          )}
        </div>
        <div>
          <p className="order-name" style={{ margin: 0 }}>{title}</p>
          <p className="order-muted" style={{ margin: 0 }}>{order.order_number as string}</p>
        </div>
      </div>

      {existing ? (
        <div style={panel}>
          <p style={{ fontSize: 15, color: '#1F1B16', margin: 0 }}>
            You have already reviewed this stone. Thank you!
          </p>
        </div>
      ) : !reviewable ? (
        <div style={panel}>
          <p style={{ fontSize: 15, color: '#1F1B16', margin: 0 }}>
            You can review this stone once it has been shipped to you.
          </p>
        </div>
      ) : (
        <ReviewForm orderId={orderId} userId={user.id} />
      )}
    </main>
  )
}
