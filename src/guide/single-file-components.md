---
title: 単一ファイルコンポーネント
type: guide
order: 19
---

## 前書き

多くの Vue プロジェクトでは、グローバルコンポーネントは、`new Vue({ el: '#container '})` の後に各ページの body においてコンテナ要素をターゲットにすることに続いて、`Vue.component` を使用して定義されています。

これは view を拡張するだけに利用された小さな中規模プロジェクトにおいてはとても有効です。 あなたのフロントエンドで JavaScript 全体を操作するようなもっと複雑なプロジェクトでは、これらの点において不利益になることは明白です。:

- **グローバル宣言**は全てのコンポーネントにユニークな名前を強制すること
- シンタックスハイライトの無い**文字列テンプレート**と複数行 HTML の時に醜いスラッシュが強要されること
- **CSS サポート無し**だと、 HTML と JavaScript がコンポーネントにモジュール化されている間、これ見よがしに無視されること
- **ビルド処理がない**と Pug(前 Jade) や Babel のようなプリプロセッサよりむしろ、 HTML や ES5 JavaScript を制限されること

これら全ては Webpack や Browserify のビルドツールにより実現された `.vue` 拡張子の **単一ファイルコンポーネント** で解決します。

こちらが `Hello.vue` と呼ばれたファイルの単純な例です:

<img src="/images/vue-component.png" style="display: block; margin: 30px auto">

さて次にこちらに入ります:

- [完全版シンタックスハイライト](https://github.com/vuejs/awesome-vue#syntax-highlighting)
- [CommonJS モジュール](https://webpack.github.io/docs/commonjs.html)
- [コンポーネントスコープ CSS](https://github.com/vuejs/vue-loader/blob/master/docs/en/features/scoped-css.md)

約束したとおり、 Pug、 Babel(ES2015 モジュールと一緒に）や Stylus などより美しくかつ機能が豊富なコンポーネントもプリプロセッサとして利用できます。

<img src="/images/vue-component-with-preprocessors.png" style="display: block; margin: 30px auto">

これらの特定の言語は単なる一例です。Bubble, TypeScript, SCSS, PostCSS などの生産的なプリプロセッサも簡単に使うことが出来ます。

<!-- TODO: include CSS modules once it's supported in vue-loader 9.x -->

## 始める

### JavaScript でモジュールビルドシステムが初めてなユーザー向け

`.vue` コンポーネントにより、高度な JavaScript アプリケーションの分野に入っていきます。これはあなたがまだ使ったことのない、いくつかの追加ツールの使い方を学ぶことを意味します。

- **Node Package Manager (NPM)**: [Getting Started guide](https://docs.npmjs.com/getting-started/what-is-npm) のセクション _10: Uninstalling global packages_ を読んで下さい。

- **Modern JavaScript with ES2015/16**: Babel の [Learn ES2015 guide](https://babeljs.io/docs/learn-es2015/) を読んで下さい。現状では全ての機能を暗記する必要はないですが、参考として戻れるようにしておいてください。

これらのリソースに没頭した後は、 [webpack-simple](https://github.com/vuejs-templates/webpack-simple) テンプレートを確認することをオススメします。手順に沿って学習することで、あっという間に ES2015 とホットリローディングで動作した `.vue` コンポーネントの Vue プロジェクトを持っているはずです！

テンプレートでは、多数の"モジュール"を取りまとめ最終的なアプリケーションに束ねてくれる [Webpack](https://webpack.github.io/) というモジュールバンドラーを使用します。 Webpack についてもっと学ぶには、 [このビデオ](https://www.youtube.com/watch?v=WQue1AN93YU) がとても良い導入となります。一度基本を終えてしまえば、[Egghead.io上の上級 Webpack コース](https://egghead.io/courses/using-webpack-for-production-javascript-applications)もチェックしたくなるでしょう。

Webpack でバンドルの中に含まれる前にそれぞれのモジュールは "loader" により変換されます。また Vue では `.vue` 単一ファイルコンポーネントをコンパイルするために [vue-loader](https://github.com/vuejs/vue-loader) を推奨しています。 [webpack-simple](https://github.com/vuejs-templates/webpack-simple) テンプレートはあなたのために全てセットアップ済みの状態で用意してありますが、もし Webpack と `.vue` コンポーネントについてもっと学びたい場合は、 [vue-loaderドキュメント](https://vue-loader.vuejs.org) を読むことも出来ます。

### 上級者ユーザー向け

あなたが Webpack か Browserify のどちらが好みでも、私達はシンプルなものと、複雑なプロジェクトのテンプレート両方を用意しました。[github.com/vuejs-templates](https://github.com/vuejs-templates) を閲覧し、あなたに合ったテンプレートを選んでください。そしたら、 [vue-cli](https://github.com/vuejs/vue-cli) で新しいプロジェクトを生成するために README 内の手順に沿ってください。

## 本番デプロイ

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
