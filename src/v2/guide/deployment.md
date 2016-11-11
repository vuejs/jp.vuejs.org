---
title: 本番環境への配信
type: guide
order: 20
---

## 警告の取り除き

縮小されたスタンドアローンビルド版 Vue ではファイルサイズを小さくするために全ての警告を取り除いていますが、 Webpack や Browserify のようなツールを利用している場合にこれを成し遂げるには多少の設定が必要です。

### Webpack

Webpack の [DefinePlugin](http://webpack.github.io/docs/list-of-plugins.html#defineplugin) を使用して本番環境を指定ください。そうすると UglifyJS が圧縮・縮小化時に自動的に警告部を切り落としてくれます。 以下は設定例です:

``` js
var webpack = require('webpack')

module.exports = {
  // ...
  plugins: [
    // ...
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: '"production"'
      }
    }),
    new webpack.optimize.UglifyJsPlugin({
      compress: {
        warnings: false
      }
    })
  ]
}
```

### Browserify

- `NODE_ENV` に `"production"` をセットしてビルドコマンドを実行してください。これは `vueify` にホットリローディングと開発関連コードを含まないことを伝えます。
- あなたのバンドルに [envify](https://github.com/hughsk/envify) グローバル変換を適用してください。 これは minifier で Vue ソースコード内で環境変数の条件上で囲われた箇所全てを取り除くことを許可します。


``` bash
NODE_ENV=production browserify -g envify -e main.js | uglifyjs -c -m > build.js
```

- 別の CSS ファイルに抽出するには、 vueify に含まれている CSS 抽出プラグインを使用してください。

``` bash
NODE_ENV=production browserify -g envify -p [ vueify/plugins/extract-css -o build.css ] -e main.js | uglifyjs -c -m > build.js
```

## ランタイムエラーの追跡

コンポーネントの描画中にエラーが発生した場合、グローバルな `Vue.config.errorHandler` 関数に設定された関数にそれが渡されます。このフックを Vue 向けに[公式に統合された](https://sentry.io/for/vue/) [Sentry](https://sentry.io) のようなエラー追跡サービスと共に使用することは良いアイデアです。

## CSS の抽出

[単一ファイルコンポーネント](./single-file-components.html) を使用するとき、`<style>` タグは開発している間実行中に注入されます。プロダクション環境では、すべてのコンポーネントのスタイルを単一の CSS ファイルに抽出することができます。これを達成する方法の詳細については、[vue-loader](http://vue-loader.vuejs.org/en/configurations/extract-css.html) および [vueify](https://github.com/vuejs/vueify#css-extraction) を参照してください。

`vue-cli` から 公式に利用する `webpack` テンプレートは、そのまま既に設定されています。
