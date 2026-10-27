import Link from 'next/link'
import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { formatEurExact } from '@/lib/money'
import { ratePercent } from '@/lib/tax'
import { PrintButton } from './PrintButton'

export const metadata = { title: 'Invoice · GemWorkers' }

// Printable invoice / credit note (sql/invoices_setup.sql). Everything shown
// comes from the frozen snapshot in invoices.data — never re-calculated.
// Buyers read their own through buyer_invoices; the owner (same login on the
// store) can open any invoice through the invoices table (owner RLS).
// Always in euros (GemWorkers charges euros only; Stripe converts for buyers
// who pay in their own currency).

type Line = { description: string; detail?: string | null; quantity: number; amount: number | string }
type InvoiceData = {
  company: { name: string; address: string | null; kvk: string | null; vat: string | null; eori?: string | null; email: string }
  order_number: string
  supply_date: string | null
  credits_invoice?: string
  customer: {
    type: string; name: string | null; company: string | null; vat: string | null
    address: string | null; email: string | null
  }
  ships_from: string | null
  lines: Line[]
  tax_name: string | null
  tax_rate: number | string | null
  vat_note: string | null
  diamond_statement: string | null
}
type InvoiceRow = {
  id: string; number: string; kind: 'invoice' | 'credit_note'; issued_at: string
  total: number | string; data: InvoiceData
}

const money = (v: number | string) => formatEurExact(Number(v))

function day(iso: string) {
  return new Date(iso).toLocaleDateString('en-IE', { day: '2-digit', month: 'long', year: 'numeric', timeZone: 'Europe/Amsterdam' })
}

export default async function InvoicePage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect(`/auth/login?next=${encodeURIComponent(`/invoices/${id}`)}`)

  const cols = 'id, number, kind, issued_at, total, data'
  let { data } = await supabase.from('buyer_invoices').select(cols).eq('id', id).maybeSingle()
  if (!data) ({ data } = await supabase.from('invoices').select(cols).eq('id', id).maybeSingle())
  const inv = data as InvoiceRow | null
  if (!inv) {
    // Not found, or not this login's document (RLS): say so instead of a bare 404.
    return (
      <main className="pd-wrap" style={{ paddingTop: 48, paddingBottom: 96, maxWidth: 640 }}>
        <h1 className="font-serif" style={{ fontSize: 30, fontWeight: 400 }}>This invoice isn&apos;t available</h1>
        <p style={{ color: '#5A5045', lineHeight: 1.6 }}>
          It can only be seen by the buyer and GemWorkers. You&apos;re logged in as <strong>{user.email}</strong> —
          log out and log in with the right account.
        </p>
      </main>
    )
  }

  const d = inv.data
  const credit = inv.kind === 'credit_note'
  const net = d.lines.reduce((s, l) => s + Math.round(Number(l.amount) * 100), 0) / 100
  const total = Number(inv.total)
  const vat = Math.round((total - net) * 100) / 100
  const rate = d.tax_rate == null ? null : Number(d.tax_rate)
  const muted = { color: '#6B6052', fontSize: 13, lineHeight: 1.55 } as const

  return (
    <main className="pd-wrap" style={{ paddingTop: 28, paddingBottom: 96, maxWidth: 820 }}>
      <div className="no-print" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: 12, marginBottom: 20, flexWrap: 'wrap' }}>
        <Link href="/orders" className="pd-link" style={{ fontSize: 14 }}>← My orders</Link>
        <PrintButton />
      </div>

      <article className="invoice-doc" style={{
        background: '#fff', border: '1px solid #ECE5D8', borderRadius: 18,
        padding: 'clamp(20px, 5vw, 44px)', color: '#1F1B16', fontSize: 14, lineHeight: 1.5,
      }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', gap: 24, flexWrap: 'wrap' }}>
          <div>
            <p className="font-serif" style={{ fontSize: 30, margin: 0 }}>{d.company.name}</p>
            {d.company.address && <p style={{ ...muted, whiteSpace: 'pre-line', margin: '6px 0 0' }}>{d.company.address}</p>}
            <p style={{ ...muted, margin: '6px 0 0' }}>
              {d.company.vat ? `VAT ${d.company.vat}` : 'VAT number: —'}
              {d.company.kvk ? ` · KvK ${d.company.kvk}` : ''}
              {d.company.eori ? ` · EORI ${d.company.eori}` : ''}
              <br />{d.company.email}
            </p>
          </div>
          <div style={{ textAlign: 'right', minWidth: 200 }}>
            <p style={{ fontSize: 12, letterSpacing: '0.14em', textTransform: 'uppercase', color: '#7A5A22', margin: 0, fontWeight: 700 }}>
              {credit ? 'Credit note' : 'Invoice'}
            </p>
            <p style={{ fontSize: 20, margin: '4px 0 0', fontWeight: 600 }}>{inv.number}</p>
            <p style={{ ...muted, margin: '6px 0 0' }}>
              Date: {day(inv.issued_at)}
              {d.supply_date && <><br />{credit ? 'Refund date' : 'Supply date'}: {day(d.supply_date)}</>}
              <br />Order: {d.order_number}
              {d.credits_invoice && <><br />Credits invoice: {d.credits_invoice}</>}
            </p>
          </div>
        </div>

        <div style={{ marginTop: 32 }}>
          <p style={{ fontSize: 11, letterSpacing: '0.12em', textTransform: 'uppercase', color: '#6B6052', margin: '0 0 6px', fontWeight: 700 }}>
            {credit ? 'Credited to' : 'Billed to'}
          </p>
          {d.customer.company && <p style={{ margin: 0, fontWeight: 600 }}>{d.customer.company}</p>}
          {d.customer.name && <p style={{ margin: 0 }}>{d.customer.name}</p>}
          {d.customer.address && <p style={{ margin: 0, whiteSpace: 'pre-line' }}>{d.customer.address}</p>}
          {d.customer.vat && <p style={{ margin: '4px 0 0' }}>VAT {d.customer.vat}</p>}
          {d.customer.email && <p style={{ ...muted, margin: '4px 0 0' }}>{d.customer.email}</p>}
        </div>

        <table style={{ width: '100%', borderCollapse: 'collapse', marginTop: 28 }}>
          <thead>
            <tr style={{ borderBottom: '1px solid #ECE5D8', textAlign: 'left', fontSize: 12, color: '#6B6052' }}>
              <th style={{ padding: '8px 0', fontWeight: 600 }}>Description</th>
              <th style={{ padding: '8px 0', fontWeight: 600, textAlign: 'right', width: 60 }}>Qty</th>
              <th style={{ padding: '8px 0', fontWeight: 600, textAlign: 'right', width: 120 }}>Amount</th>
            </tr>
          </thead>
          <tbody>
            {d.lines.map((l, i) => (
              <tr key={i} style={{ borderBottom: '1px solid #F1EBE0', verticalAlign: 'top' }}>
                <td style={{ padding: '10px 0' }}>
                  {l.description}
                  {l.detail && <div style={muted}>{l.detail}</div>}
                </td>
                <td style={{ padding: '10px 0', textAlign: 'right' }}>{l.quantity}</td>
                <td style={{ padding: '10px 0', textAlign: 'right' }}>{money(l.amount)}</td>
              </tr>
            ))}
          </tbody>
        </table>

        <div style={{ marginLeft: 'auto', maxWidth: 320, marginTop: 16 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', padding: '4px 0' }}>
            <span>Subtotal (excl. VAT)</span><span>{money(net)}</span>
          </div>
          <div style={{ display: 'flex', justifyContent: 'space-between', padding: '4px 0' }}>
            <span>{d.tax_name || 'VAT'} {vat !== 0 && rate != null ? `${ratePercent(rate)}%` : '0%'}</span>
            <span>{money(vat)}</span>
          </div>
          <div style={{ display: 'flex', justifyContent: 'space-between', padding: '8px 0', borderTop: '1px solid #ECE5D8', marginTop: 4, fontWeight: 700, fontSize: 16 }}>
            <span>{credit ? 'Total credited' : 'Total paid'}</span><span>{money(total)}</span>
          </div>
        </div>

        <div style={{ marginTop: 28 }}>
          {d.vat_note && <p style={{ ...muted, margin: '0 0 6px' }}>{d.vat_note}</p>}
          {d.ships_from && <p style={{ ...muted, margin: '0 0 6px' }}>Shipped from {d.ships_from}.</p>}
          {d.diamond_statement && <p style={{ ...muted, margin: '0 0 6px' }}>{d.diamond_statement}</p>}
          <p style={{ ...muted, margin: 0 }}>Paid in full by card or online payment · Currency: EUR</p>
        </div>
      </article>
    </main>
  )
}
