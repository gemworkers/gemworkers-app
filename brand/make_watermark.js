// Watermark from the ORIGINAL logo (public/logo-black.png): crystal + "GemWorkers"
// (tagline cropped off), unchanged pixels, with a soft white glow behind it.
const sharp = require(require.resolve('sharp', { paths: [process.cwd()] }));
const out = process.argv[2];
(async () => {
  const { data, info } = await sharp('public/logo-black.png').ensureAlpha().raw().toBuffer({ resolveWithObject: true });
  const W = info.width, H = info.height, A = (x, y) => data[(y * W + x) * 4 + 3];
  const empty = y => { for (let x = 0; x < W; x++) if (A(x, y) > 20) return false; return true; };
  let cut = 0;
  for (let y = Math.floor(H * 0.7); y < H; y++) if (empty(y)) { cut = y; break; }   // gap above the tagline
  let top = H, l = W, r = 0;
  for (let y = 0; y < cut; y++) for (let x = 0; x < W; x++) if (A(x, y) > 20) { top = Math.min(top, y); l = Math.min(l, x); r = Math.max(r, x); }
  const tw = 1200;
  const small = await sharp('public/logo-black.png').extract({ left: l, top, width: r - l + 1, height: cut - top })
    .resize(tw).ensureAlpha().raw().toBuffer({ resolveWithObject: true });
  const w = small.info.width, h = small.info.height, p = 36, PW = w + 2 * p, PH = h + 2 * p;
  const mask = Buffer.alloc(PW * PH);
  for (let y = 0; y < h; y++) for (let x = 0; x < w; x++) mask[(y + p) * PW + x + p] = small.data[(y * w + x) * 4 + 3];
  const blurred = await sharp(mask, { raw: { width: PW, height: PH, channels: 1 } }).blur(9).extractChannel(0).raw().toBuffer({ resolveWithObject: true }).then(r => { if (r.info.channels !== 1 || r.data.length !== PW * PH) throw new Error('mask ' + r.info.channels + ' ' + r.data.length); return r.data; });
  const halo = Buffer.alloc(PW * PH * 4);
  for (let i = 0; i < PW * PH; i++) {
    halo[i * 4] = halo[i * 4 + 1] = halo[i * 4 + 2] = 255;
    halo[i * 4 + 3] = Math.round(Math.min(255, blurred[i] * 2.4) * 0.85);
  }
  const logoPng = await sharp(small.data, { raw: { width: w, height: h, channels: 4 } }).png().toBuffer();
  await sharp(halo, { raw: { width: PW, height: PH, channels: 4 } })
    .composite([{ input: logoPng, left: p, top: p }]).png().toFile(out);
  console.log('cut at', cut, 'size', PW, PH);
})();
