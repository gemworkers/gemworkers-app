'use client'

import { useEffect } from 'react'
import { isStaleVersionError, reloadForNewVersion } from '@/lib/stale-version'

// Buttons that call server actions outside a form (cart, favourites, offers…)
// fail as an unhandled promise when the page is from an older deployment:
// reload once so the visitor gets the current version.
export function StaleVersionReload() {
  useEffect(() => {
    const onRejection = (e: PromiseRejectionEvent) => { if (isStaleVersionError(e.reason)) reloadForNewVersion() }
    const onError = (e: ErrorEvent) => { if (isStaleVersionError(e.error ?? e.message)) reloadForNewVersion() }
    window.addEventListener('unhandledrejection', onRejection)
    window.addEventListener('error', onError)
    return () => {
      window.removeEventListener('unhandledrejection', onRejection)
      window.removeEventListener('error', onError)
    }
  }, [])
  return null
}
