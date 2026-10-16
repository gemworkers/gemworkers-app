// Accepted-offer payment window rules, shared by payAcceptedOffer and the
// pages that show the Pay buttons.
//
// Stripe Checkout sessions live at least 30 minutes. Starting one with less
// time than that left before payment_due_at would let a buyer pay after the
// sweep has cancelled the order, so payment is refused below this margin.
export const MIN_PAY_WINDOW_MS = 35 * 60 * 1000

export const PAY_WINDOW_CLOSING_MESSAGE =
  'The payment window for this offer has nearly closed. Please contact us at hello@gemworkers.com.'

export function canStartOfferPayment(paymentDueAt: string, now: number = Date.now()): boolean {
  return new Date(paymentDueAt).getTime() - now >= MIN_PAY_WINDOW_MS
}
