import { notFound, redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { formatEurExact } from '@/lib/money'
import { PrintButton } from '@/app/invoices/[id]/PrintButton'

export const metadata = { title: 'Payout statement · GemWorkers' }

// Payout statement (sql/payouts_setup.sql) — frozen copy in payouts.data.
// Readable by the owner and by the seller it was paid to (payouts RLS).
// Internal document: never linked from the store for buyers.

type Sale = { order: string; stone: string | null; date: string; kind: string; amount: number | string }
type Charge = { order: string | null; reason: string; date: string; amount: number | string }
type PayoutRow = {
  number: string; paid_at: string; sales_total: number | string; charges_total: number | string
  amount: number | string; method: string | null; reference: string | null; note: string | null
  data: { payee: string; company: { name: string; address: string | null; vat: string | null; kvk: string | null }; sales: Sale[]; charges: Charge[] }
}

const money = (v: number | string) => formatEurExact(Number(v))
const day = (iso: string) =>
  new Date(iso).toLocaleDateString('en-IE', { day: '2-digit', month: 'long', year: 'numeric', timeZone: 'Europe/Amsterdam' })

export default async function StatementPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect(`/auth/login?next=${encodeURIComponent(`/statements/${id}`)}`)

  const { data } = await supabase
    .from('payouts')
    .select('number, paid_at, sales_total, charges_total, amount, method, reference, note, data')
    .eq('id', id)
    .maybeSingle()
  const p = data as PayoutRow | null
  if (!p) notFound()

  const d = p.data
  const muted = { color: '#6B6052', fontSize: 13 } as const
  const cell = { padding: '8px 0', borderBottom: '1px solid #F1EBE0', verticalAlign: 'top' as const }

  return (
    <main className="pd-wrap" style={{ paddingTop: 28, paddingBottom: 96, maxWidth: 820 }}>
      <div className="no-print" style={{ display: 'flex', justifyContent: 'flex-end', marginBottom: 20 }}>
        <PrintButton />
      </div>
      <article className="invoice-doc" style={{
        background: '#fff', border: '1px solid #ECE5D8', borderRadius: 18,
        padding: 'clamp(20px, 5vw, 44px)', color: '#1F1B16', fontSize: 14, lineHeight: 1.5,
      }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', gap: 24, flexWrap: 'wrap' }}>
          <div>
            <p className="font-serif" style={{ fontSize: 28, margin: 0 }}>{d.company.name}</p>
            {d.company.address && <p style={{ ...muted, whiteSpace: 'pre-line', margin: '6px 0 0' }}>{d.company.address}</p>}
            <p style={{ ...muted, margin: '6px 0 0' }}>
              {d.company.vat ? `VAT ${d.company.vat}` : ''}{d.company.kvk ? ` · KvK ${d.company.kvk}` : ''}
            </p>
          </div>
          <div style={{ textAlign: 'right' }}>
            <p style={{ fontSize: 12, letterSpacing: '0.14em', textTransform: 'uppercase', color: '#7A5A22', margin: 0, fontWeight: 700 }}>
              Payout statement
            </p>
            <p style={{ fontSize: 20, margin: '4px 0 0', fontWeight: 600 }}>{p.number}</p>
            <p style={{ ...muted, margin: '6px 0 0' }}>Paid: {day(p.paid_at)}</p>
          </div>
        </div>

        <p style={{ marginTop: 28 }}>
          <span style={muted}>Paid to</span><br />
          <strong>{d.payee}</strong>
        </p>

        <h3 style={{ fontSize: 15, margin: '24px 0 4px' }}>Sales</h3>
        <table style={{ width: '100%', borderCollapse: 'collapse' }}>
          <tbody>
            {d.sales.map((s, i) => (
              <tr key={i}>
                <td style={cell}>{s.order} · {s.stone ?? 'Stone'}<div style={muted}>{s.date} · {s.kind === 'consignment' ? 'sold from NL (your share)' : 'your sale (after commission and fees)'}</div></td>
                <td style={{ ...cell, textAlign: 'right', width: 120 }}>{money(s.amount)}</td>
              </tr>
            ))}
          </tbody>
        </table>

        {d.charges.length > 0 && (
          <>
            <h3 style={{ fontSize: 15, margin: '24px 0 4px' }}>Deducted</h3>
            <table style={{ width: '100%', borderCollapse: 'collapse' }}>
              <tbody>
                {d.charges.map((c, i) => (
                  <tr key={i}>
                    <td style={cell}>{c.reason}<div style={muted}>{c.date}{c.order ? ` · ${c.order}` : ''}</div></td>
                    <td style={{ ...cell, textAlign: 'right', width: 120 }}>−{money(c.amount)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </>
        )}

        <div style={{ marginLeft: 'auto', maxWidth: 320, marginTop: 18 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between' }}><span>Sales</span><span>{money(p.sales_total)}</span></div>
          <div style={{ display: 'flex', justifyContent: 'space-between' }}><span>Deducted</span><span>−{money(p.charges_total)}</span></div>
          <div style={{ display: 'flex', justifyContent: 'space-between', borderTop: '1px solid #ECE5D8', marginTop: 6, paddingTop: 8, fontWeight: 700, fontSize: 16 }}>
            <span>Paid</span><span>{money(p.amount)}</span>
          </div>
        </div>

        <p style={{ ...muted, marginTop: 24 }}>
          {p.method ? `Paid via ${p.method}` : 'Paid'}{p.reference ? ` · reference ${p.reference}` : ''}
          {p.note ? <><br />{p.note}</> : null}
        </p>
      </article>
    </main>
  )
}
