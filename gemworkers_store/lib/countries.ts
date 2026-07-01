const COUNTRY_NAMES: Record<string, string> = {
  AE: 'United Arab Emirates',
  AU: 'Australia',
  BE: 'Belgium',
  CA: 'Canada',
  DE: 'Germany',
  DK: 'Denmark',
  ES: 'Spain',
  FI: 'Finland',
  FR: 'France',
  GB: 'United Kingdom',
  IE: 'Ireland',
  IN: 'India',
  IT: 'Italy',
  JP: 'Japan',
  NL: 'Netherlands',
  PK: 'Pakistan',
  PL: 'Poland',
  PT: 'Portugal',
  SA: 'Saudi Arabia',
  SE: 'Sweden',
  SG: 'Singapore',
  TH: 'Thailand',
  US: 'United States',
  AT: 'Austria',
}

/** Returns the full country name for a 2-letter ISO code, or the raw code if unmapped. */
export function countryName(code: string | null | undefined): string | null {
  if (!code) return null
  return COUNTRY_NAMES[code.toUpperCase()] ?? code
}
