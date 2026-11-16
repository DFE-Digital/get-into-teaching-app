// Babel is only used by Jest and ESLint; esbuild bundles the application JavaScript.
module.exports = {
  presets: [['@babel/preset-env', { targets: { node: 'current' } }]],
};
