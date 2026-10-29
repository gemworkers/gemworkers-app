import { createServerClient, type CookieOptions } from '@supabase/ssr'
import { NextResponse, type NextRequest } from 'next/server'

export async function middleware(request: NextRequest) {
  // ?ship_to=NL (links from the Google Shopping feed): show the page for that
  // country, so the price matches the feed. Saved like the header chooser.
  const shipTo = request.nextUrl.searchParams.get('ship_to')?.toUpperCase()
  const setShipTo = !!shipTo && /^[A-Z]{2}$/.test(shipTo)
  if (setShipTo) request.cookies.set('gw_ship_to', shipTo!)

  let supabaseResponse = NextResponse.next({ request })

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return request.cookies.getAll()
        },
        setAll(cookiesToSet: { name: string; value: string; options: CookieOptions }[]) {
          cookiesToSet.forEach(({ name, value }) =>
            request.cookies.set(name, value)
          )
          supabaseResponse = NextResponse.next({ request })
          cookiesToSet.forEach(({ name, value, options }) =>
            supabaseResponse.cookies.set(name, value, options)
          )
        },
      },
    }
  )

  // Refreshes the session cookie so it stays alive across navigations.
  // Must call getUser() (not getSession()) to validate the token server-side.
  await supabase.auth.getUser()

  if (setShipTo) {
    supabaseResponse.cookies.set('gw_ship_to', shipTo!, { path: '/', maxAge: 60 * 60 * 24 * 365, sameSite: 'lax' })
  }
  return supabaseResponse
}

export const config = {
  matcher: [
    '/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)',
  ],
}
