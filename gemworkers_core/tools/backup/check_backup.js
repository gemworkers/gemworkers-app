// Restore practice: opens the NEWEST backup in iCloud Drive\GemWorkers backups
// with GW_BACKUP_PASS and compares every table with the live database (row
// counts, plus newest order / invoice numbers). Read-only: changes nothing,
// writes no plain copy anywhere. Small differences are normal when orders came
// in after the backup was made.
//   node gemworkers_core/tools/backup/check_backup.js
const { spawnSync } = require('child_process')
const crypto = require('crypto')
const fs = require('fs')
const os = require('os')
const path = require('path')
const zlib = require('zlib')

const APP_DIR = path.join(__dirname, '..', '..', '..')
const DIR = path.join(os.homedir(), 'iCloudDrive', 'GemWorkers backups')

function query(sql) {
  const file = path.join(os.tmpdir(), `gw-check-${process.pid}.sql`)
  fs.writeFileSync(file, sql)
  const res = spawnSync(`npx supabase db query --linked -f "${file}" -o json`, { cwd: APP_DIR, encoding: 'utf8', shell: true, maxBuffer: 256 * 1024 * 1024 })
  fs.rmSync(file, { force: true })
  if (res.status !== 0) throw new Error((res.stderr || res.stdout).slice(0, 300))
  const p = JSON.parse(res.stdout)
  return Array.isArray(p) ? p : p.rows ?? p
}

const pass = process.env.GW_BACKUP_PASS
if (!pass) { console.log('GW_BACKUP_PASS is not set in this window. Close PowerShell, open it again and retry.'); process.exit(1) }
const files = fs.existsSync(DIR) ? fs.readdirSync(DIR).filter(f => f.endsWith('.gwbackup')).sort() : []
if (files.length === 0) { console.log('No backup found in ' + DIR); process.exit(1) }
const newest = files[files.length - 1]

// 1. Open it.
const buf = fs.readFileSync(path.join(DIR, newest))
const salt = buf.subarray(4, 20), iv = buf.subarray(20, 32), tag = buf.subarray(32, 48)
const key = crypto.scryptSync(pass, salt, 32, { N: 1 << 15, r: 8, p: 1, maxmem: 64 * 1024 * 1024 })
const d = crypto.createDecipheriv('aes-256-gcm', key, iv)
d.setAuthTag(tag)
let data
try {
  data = JSON.parse(zlib.gunzipSync(Buffer.concat([d.update(buf.subarray(48)), d.final()])).toString())
} catch {
  console.log(`Could not open ${newest}: wrong password, or the file is damaged.`)
  process.exit(1)
}
console.log(`Opened ${newest} (made ${data.made_at}) with your password.`)

// 2. Compare with the live database.
const tables = Object.keys(data.tables).filter(t => t !== 'auth.users')
const live = query(`select json_object_agg(t, n) as counts from (${tables.map(t =>
  `select '${t}' as t, (select count(*) from public."${t}") as n`).join(' union all ')}) x`)[0].counts
live['auth.users'] = query('select count(*) as n from auth.users')[0].n

let same = 0
const diffs = []
for (const t of [...tables, 'auth.users']) {
  const b = data.tables[t].length, l = Number(live[t] ?? 0)
  if (b === l) same++
  else diffs.push(`${t}: backup ${b}, live ${l}`)
}
const lastNo = (rows, col) => rows.map(r => r[col]).filter(Boolean).sort().pop() ?? '—'
console.log(`Tables identical: ${same} of ${tables.length + 1}.`)
console.log(`Newest order in backup: ${lastNo(data.tables.orders ?? [], 'order_number')} · newest invoice: ${lastNo(data.tables.invoices ?? [], 'number')}`)
if (diffs.length) {
  console.log('Different (normal if there was activity after the backup):')
  for (const x of diffs) console.log('  - ' + x)
} else {
  console.log('RESULT: the backup is complete and can be opened. ✔')
}
