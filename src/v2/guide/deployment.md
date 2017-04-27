---
title: プロダクション環境への配信のヒント
type: guide
order: 20
---

## プロダクションモードを有効にする

開発中、Vue は一般的なエラーや落とし穴に役立つ多くの警告を表示します。しかし、これらの警告文字列は、プロダクション環境では役に立たなくなり、アプリケーションのペイロードサイズが大きくなります。さらに、これらの警告チェックの中には、運用モードで回避できるランタイムコストが小さいものがあります。

### ビルドツールなし

フルビルドを使用している場合、つまりビルドツールなしで直接スクリプトタグを使用して Vue を組み込む場合は、縮小バージョン (`vue.min.js`) をプロダクション用に使用してください。 いずれのバージョンも[インストールガイド](installation.html#lt-script-gt-直接組み込み)中にあります。

### ビルドツールあり

Webpack や Browserify のようなビルドツールを使用する場合、プロダクションモードは Vue のソースコード内の `process.env.NODE_ENV` によって決定され、デフォルトで開発モードになります。どちらのビルドツールも、この変数を上書きして Vue のプロダクションモードを有効にする方法を提供します。ビルド中に警告が縮小ツール (minifier) によって取り除かれます。全ての `vue-cli` テンプレートにはあなたのためにあらかじめ設定されたテンプレートがありますが、それがどのように行われるかを知ることは有益でしょう:

#### Webpack

Webpack の [DefinePlugin](https://webpack.js.org/plugins/define-plugin/) を使用して本番環境を指定してください。そうすると UglifyJS が圧縮・縮小化時に自動的に警告部を切り落としてくれます。 以下は設定例です:

```javascript
var webpack = require('webpack')

module.exports = {
  // ...
  plugins: [
    // ...
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: '"production"'
      }
    })
  ]
}
```

#### Browserify

- `"production"` に設定した `NODE_ENV` 環境変数を使ってバンドリングコマンドを実行してください。これは `vueify` にホットリロードと開発関連のコードを含まないように指示します。
- あなたのバンドルに [envify](https://github.com/hughsk/envify) グローバル変換を適用してください。 これは minifier で Vue ソースコード内で環境変数の条件上で囲われた箇所全てを取り除くことを許可します。


``` bash
NODE_ENV=production browserify -g envify -e main.js | uglifyjs -c -m > build.js
```

#### Rollup

[rollup-plugin-replace](https://github.com/rollup/rollup-plugin-replace) を使用します:

```javascript
const replace = require('rollup-plugin-replace')

rollup({
  // ...
  plugins: [
    replace({
      'process.env.NODE_ENV': JSON.stringify( 'production' )
    })
  ]
}).then(...)
```

## テンプレートのプリコンパイル

DOM 内のテンプレートまたは JavaScript 内のテンプレート文字列を使用する場合、テンプレートから描画関数へのコンパイルはその場 (on the fly) で実行されます。通常、ほとんどの場合、これは十分高速ですが、アプリケーションのパフォーマンスが重要な場合は避けるのが最善です。

テンプレートをプリコンパイルする最も簡単な方法は、[単一ファイルコンポーネント](single-file-components.html)を使用することです。関連するビルドのセットアップは自動的にプリコンパイルを実行するため、ビルドされたコードには生のテンプレート文字列ではなくすでにコンパイルされた描画関数が含まれています。

Webpack を使用している場合、JavaScript と テンプレートの分離を好むなら、ビルドステップ中にテンプレートファイルを JavaScript 描画関数に変換する [vue-template-loader](https://github.com/ktsn/vue-template-loader) を使用することができます。

## コンポーネント CSS の抽出

単一ファイルコンポーネントを使用する場合、コンポーネント内の CSS は JavaScript を介して `<style>` タグとして動的に挿入されます。これは実行時のコストが低く、サーバー側のレンダリングを使用している場合は、"スタイルのないコンテンツのフラッシュ"が発生します。すべてのコンポーネントにわたって CSS を同じファイルに抽出し、これらの問題を回避するには、より良い CSS の縮小化 (minification) とキャッシングをするのがより良いです。

それぞれのビルドツールのドキュメントを参照してください:

- [Webpack + vue-loader](http://vue-loader.vuejs.org/en/configurations/extract-css.html) (`vue-cli` の webpack テンプレートは既に設定済み)
- [Browserify + vueify](https://github.com/vuejs/vueify#css-extraction)
- [Rollup + rollup-plugin-vue](https://github.com/znck/rollup-plugin-vue#options)

## ランタイムエラーの追跡

コンポーネントの描画中にエラーが発生した場合、グローバルな `Vue.config.errorHandler` 関数に設定された関数にそれが渡されます。このフックを Vue 向けに[公式に統合された](https://sentry.io/for/vue/) [Sentry](https://sentry.io) のようなエラー追跡サービスと共に使用することは良いアイデアです。
