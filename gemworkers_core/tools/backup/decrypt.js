// Opens a GemWorkers safety copy made by backup.js.
//   node gemworkers_core/tools/backup/decrypt.js "<path to .gwbackup>" [out.json]
// Needs the same password in GW_BACKUP_PASS. Writes plain JSON — it contains
// buyer data: keep it on this laptop only and delete it when done.
const crypto = require('crypto')
const fs = require('fs')
const zlib = require('zlib')

const [file, out] = process.argv.slice(2)
if (!file) { console.error('Usage: node decrypt.js <file.gwbackup> [out.json]'); process.exit(1) }
const pass = process.env.GW_BACKUP_PASS
if (!pass) { console.error('GW_BACKUP_PASS is not set'); process.exit(1) }

const buf = fs.readFileSync(file)
if (buf.subarray(0, 4).toString() !== 'GWB1') { console.error('Not a GemWorkers backup file'); process.exit(1) }
const salt = buf.subarray(4, 20), iv = buf.subarray(20, 32), tag = buf.subarray(32, 48)
const key = crypto.scryptSync(pass, salt, 32, { N: 1 << 15, r: 8, p: 1, maxmem: 64 * 1024 * 1024 })
const d = crypto.createDecipheriv('aes-256-gcm', key, iv)
d.setAuthTag(tag)
let plain
try {
  plain = zlib.gunzipSync(Buffer.concat([d.update(buf.subarray(48)), d.final()]))
} catch {
  console.error('Wrong password, or the file is damaged.')
  process.exit(1)
}
const data = JSON.parse(plain.toString())
const counts = Object.entries(data.tables).map(([k, v]) => `${k}: ${v.length}`).join(', ')
console.log(`Backup of ${data.made_at} — ${counts}`)
if (out) { fs.writeFileSync(out, JSON.stringify(data, null, 1)); console.log('Written to ' + out) }
