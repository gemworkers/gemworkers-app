# GemWorkers weekly backup — one-time setup (run by Zakaria himself).
#  1. asks for the backup password (twice) and saves it for this Windows user
#     only (user variable GW_BACKUP_PASS) — never shown, never sent anywhere
#  2. creates the Windows task "GemWorkers backup": Sundays 12:00, or as soon
#     as the laptop is on after a missed Sunday
#  3. makes the first backup now into iCloud Drive\GemWorkers backups
# Run:  powershell -ExecutionPolicy Bypass -File "C:\Users\Zakaria\Desktop\gemworkers_app\gemworkers_core\tools\backup\setup_backup.ps1"

$ErrorActionPreference = 'Stop'
$script = Join-Path $PSScriptRoot 'backup.js'
$appDir = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path

function Plain([Security.SecureString]$s) {
  [Runtime.InteropServices.Marshal]::PtrToStringBSTR([Runtime.InteropServices.Marshal]::SecureStringToBSTR($s))
}

Write-Host ''
Write-Host 'GemWorkers backup setup' -ForegroundColor Cyan
Write-Host 'Choose a backup password (at least 10 characters). Save it in your iPhone Passwords app too:'
Write-Host 'without it the backups can NOT be opened.'
$p1 = Plain (Read-Host 'Backup password' -AsSecureString)
$p2 = Plain (Read-Host 'Same password again' -AsSecureString)
if ($p1 -ne $p2) { Write-Host 'The two passwords are different - nothing was changed. Run this again.' -ForegroundColor Red; exit 1 }
if ($p1.Length -lt 10) { Write-Host 'Too short - use at least 10 characters. Nothing was changed.' -ForegroundColor Red; exit 1 }

[Environment]::SetEnvironmentVariable('GW_BACKUP_PASS', $p1, 'User')
$env:GW_BACKUP_PASS = $p1
Write-Host 'Password saved for this Windows user.' -ForegroundColor Green

$node = (Get-Command node).Source
$action = New-ScheduledTaskAction -Execute $node -Argument "`"$script`"" -WorkingDirectory $appDir
$trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Sunday -At 12:00
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -ExecutionTimeLimit (New-TimeSpan -Minutes 30)
Register-ScheduledTask -TaskName 'GemWorkers backup' -Action $action -Trigger $trigger -Settings $settings `
  -Description 'Weekly encrypted GemWorkers database copy to iCloud Drive (gemworkers_core/tools/backup/backup.js)' -Force | Out-Null
Write-Host 'Weekly task "GemWorkers backup" created (Sundays 12:00).' -ForegroundColor Green

Write-Host 'Making the first backup now (takes a few minutes)...'
Push-Location $appDir
node $script
Pop-Location
Write-Host ''
Write-Host 'Done. Check iCloud Drive > GemWorkers backups. You can close this window.' -ForegroundColor Cyan
Read-Host 'Press Enter to close'
