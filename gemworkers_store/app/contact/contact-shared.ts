export const TOPICS = [
  'General question',
  'Order question',
  'Request a stone',
  'Certificate request',
  'Wholesale & partnerships',
] as const

export type ContactState = {
  ok:     boolean
  error?: string
}
