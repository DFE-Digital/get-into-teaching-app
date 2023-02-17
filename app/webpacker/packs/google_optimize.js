import GoogleOptimize from '../javascript/google_optimize'

const config = document.querySelector("[data-google-optimize-id]").dataset;

if (config.googleOptimizeId && config.googleOptimizePaths) {
  const paths = JSON.parse(config.googleOptimizePaths);
  const optimize = new GoogleOptimize(config.googleOptimizeId, paths)
  optimize.init()
}
