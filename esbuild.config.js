const esbuild = require('esbuild');
const path = require('path');

const watch = process.argv.includes('--watch');
const outdir = path.join(process.cwd(), 'app/assets/builds');
const target = ['es2020'];

// Page scripts are loaded as ES modules with a shared bundle per entry.
const moduleEntries = [
  'accessible_autocomplete',
  'application',
  'clarity',
  'fake_browser_time',
  'flatpickr',
  'govuk_frontend',
  'gtm',
  'internal',
  'js_enabled',
  'lazy_images',
  'sentry',
];

// The chat widget is a classic deferred script: its layout sets window.env
// after the script tag, so it must not run as a module.
const base = {
  bundle: true,
  sourcemap: watch,
  minify: !watch,
  target,
  logLevel: 'info',
  define: { 'process.env.NODE_ENV': '"production"' },
  outdir,
};

const configs = [
  { ...base, entryPoints: moduleEntries.map((n) => `app/javascript/${n}.js`), format: 'esm', splitting: false },
  { ...base, entryPoints: ['app/javascript/chat.js'], format: 'iife' },
];

(async () => {
  const contexts = await Promise.all(configs.map((c) => esbuild.context(c)));
  if (watch) {
    await Promise.all(contexts.map((c) => c.watch()));
  } else {
    await Promise.all(contexts.map((c) => c.rebuild()));
    await Promise.all(contexts.map((c) => c.dispose()));
  }
})().catch(() => process.exit(1));
