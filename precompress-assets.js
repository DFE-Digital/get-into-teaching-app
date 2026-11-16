// Writes .gz and .br siblings for compressible precompiled assets so that
// ActionDispatch::Static can serve them directly (Propshaft does not compress).
// Mirrors the compression-webpack-plugin behaviour this app had under webpack.
const fs = require('fs');
const path = require('path');
const zlib = require('zlib');

const root = path.resolve(process.argv[2] || 'public/assets');
const compressible = /\.(js|css|html|json|ico|svg|eot|otf|ttf|map)$/;
const minRatio = 0.8;

const walk = (dir) =>
  fs.readdirSync(dir, { withFileTypes: true }).flatMap((entry) => {
    const full = path.join(dir, entry.name);
    return entry.isDirectory() ? walk(full) : [full];
  });

const write = (file, suffix, compressed, original) => {
  if (compressed.length / original.length < minRatio) {
    fs.writeFileSync(`${file}${suffix}`, compressed);
    return 1;
  }
  return 0;
};

let written = 0;
walk(root)
  .filter((file) => compressible.test(file))
  .forEach((file) => {
    const original = fs.readFileSync(file);
    written += write(file, '.gz', zlib.gzipSync(original, { level: 9 }), original);
    written += write(
      file,
      '.br',
      zlib.brotliCompressSync(original, {
        params: { [zlib.constants.BROTLI_PARAM_QUALITY]: zlib.constants.BROTLI_MAX_QUALITY },
      }),
      original,
    );
  });

console.log(`Precompressed ${written} files in ${root}`);
