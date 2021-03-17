const { environment } = require('@rails/webpacker')
// ここからbootstrap用のコード
const webpack = require('webpack')
environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: 'popper.js'
  })
)
// ここまでbootstrap用のコード

module.exports = environment
