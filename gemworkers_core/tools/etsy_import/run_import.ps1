# GemWorkers — run an Etsy import with a fresh one-time upload key.
# The key is made here, stored only as the Supabase secret MEDIA_MIGRATE_TOKEN,
# used by import.js through an environment variable, and never printed.
#
# Usage (from the gemworkers_app folder):
#   powershell -ExecutionPolicy Bypass -File gemworkers_core\tools\etsy_import\run_import.ps1 `
#     -Csv EtsyListingsDownload_Hamid.csv -SellerId <uuid> -Out <folder> -Options "--shipping 25 --days 4-8"

param(
  [Parameter(Mandatory = $true)][string]$Csv,
  [Parameter(Mandatory = $true)][string]$SellerId,
  [Parameter(Mandatory = $true)][string]$Out,
  [string]$Options = ''
)
$ErrorActionPreference = 'Stop'
$root = Resolve-Path (Join-Path $PSScriptRoot '..\..\..')
Set-Location $root

$bytes = New-Object byte[] 32
[System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($bytes)
$token = -join ($bytes | ForEach-Object { $_.ToString('x2') })

Write-Host 'Storing a fresh upload key in Supabase...'
npx supabase secrets set "MEDIA_MIGRATE_TOKEN=$token" | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'Could not store the key in Supabase (is the Supabase CLI logged in?)' }
Write-Host 'Waiting 30 seconds for Supabase to pick it up...'
Start-Sleep -Seconds 30

$env:GW_MIGRATE_TOKEN = $token
try {
  Set-Location (Join-Path $root 'gemworkers_store')
  $csvPath = Join-Path $root $Csv
  $extra = @($Options -split '\s+' | Where-Object { $_ })
  Write-Host 'Uploading photos (this can take 20-40 minutes for a big shop)...'
  node ..\gemworkers_core\tools\etsy_import\import.js $csvPath $SellerId $Out @extra
} finally {
  Remove-Item Env:GW_MIGRATE_TOKEN -ErrorAction SilentlyContinue
  Set-Location $root
}
Write-Host ''
Write-Host 'Done. Tell Claude: "upload finished".'
