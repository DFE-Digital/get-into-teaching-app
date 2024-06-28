// use the new NPM package name, `shakapacker`.
// merge is webpack-merge from https://github.com/survivejs/webpack-merge
const { generateWebpackConfig, merge } = require('shakapacker')
const baseWebpackConfig = generateWebpackConfig()
const options = {
  resolve: {
    extensions: ['.pdf', '.scss', '.css', '.png', '.svg', '.gif', '.jpeg', '.jpg', 'ico', 'woff', 'woff2', '...']
  },
  module: {
    rules: [
      {
        test: /\.(pdf)$/i,
        loader: 'file-loader',
        options: {
          name: '[name].[ext]',
          outputPath: 'static/documents',
        },
      },
    ],
  },
}

// add hashing of generated JS and CSS files to fix caching
// issue in development see: https://github.com/shakacode/shakapacker/issues/88
baseWebpackConfig.output.filename = 'js/[name]-[contenthash].js'
baseWebpackConfig.output.chunkFilename = 'js/[name]-[contenthash].chunk.js'

baseWebpackConfig.plugins.forEach(plugin => {
  if (plugin.options && plugin.options.filename === 'css/[name].css') {
    plugin.options.filename = 'css/[name]-[contenthash].css'
  }
})

module.exports = merge({}, baseWebpackConfig, options)
