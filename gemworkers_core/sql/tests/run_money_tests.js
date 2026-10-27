// Runs the money practice tests (money_tests.sql) on the live database and
// prints a short result. Nothing is kept: the test always rolls back.
// Usage, from C:\Users\Zakaria\Desktop\gemworkers_app:
//   node gemworkers_core/sql/tests/run_money_tests.js
const { spawnSync } = require('child_process')
const path = require('path')

const file = path.join(__dirname, 'money_tests.sql')
const res = spawnSync(`npx supabase db query --linked -f "${file}" -o json`, {
  encoding: 'utf8', shell: true, cwd: path.join(__dirname, '..', '..', '..'),
})
const out = (res.stdout || '') + (res.stderr || '')
const m = /TESTRESULT passed=(\d+) failed=(\d+)\s*(?::: (.*?))?(?:\\n|")/.exec(out)
if (!m) {
  const err = /ERROR:?\s*(.{0,400})/.exec(out)
  console.log('The tests could not finish: ' + (err ? err[1].replace(/\\n/g, ' ').replace(/\\"/g, '"') : out.slice(0, 400)))
  process.exit(2)
}
const [, passed, failed, details] = m
if (Number(failed) === 0) {
  console.log(`All ${passed} money checks passed.`)
} else {
  console.log(`${failed} money check(s) FAILED, ${passed} passed:`)
  for (const f of (details || '').split(' || ')) console.log('  - ' + f.replace(/\\"/g, '"'))
  process.exit(1)
}
