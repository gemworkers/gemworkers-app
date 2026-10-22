// Maker credit wording by product type — same rule as the admin's
// makerVerb (gemworkers_core/lib/pages/inventory/widgets/maker_picker.dart).
export function makerVerb(productType: string | null | undefined): string {
  if (productType === 'jewelry') return 'Made by'
  if (productType === 'specimen') return 'Collected by'
  return 'Cut by'
}

// Anchor of a maker's profile on /makers.
export const makerHref = (makerId: string) => `/makers#maker-${makerId}`
