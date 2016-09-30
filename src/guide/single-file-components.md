---
title: シングルファイル・コンポーネント
type: guide
order: 19
---

## 紹介

多くの Vue プロジェクトでは、各ページの本体でコンテナー要素を参照した `new Vue({ el: '#container '})` に従って、グローバルコンポーネントは `Vue.component` を使用して宣言されます。

これはビューを拡張するだけに利用された小さな中規模プロジェクトにおいてはとても有効です。 あなたのフロントエンドでJavaScript全体を操作するようなもっと複雑なプロジェクトでは、これらの点において不利益になることは明白です。:

- 全てのコンポーネントでユニークな名前の**グローバル宣言**が強制される
- **String templates** lack syntax highlighting and require ugly slashes for multiline HTML
- **No CSS support** means that while HTML and JavaScript are modularized into components, CSS is conspicuously left out
- **ビルドステップ無し** は Pug(前 Jade) やBabel のようなプリプロセッサよりむしろ、 HTMLや ES5 JavaScript を制限します 

これら全ては Webpack や Browserify のビルドルールで実現された `.vue` 拡張子の **シングルファイル・コンポーネント** で解決します。

こちらが `Hello.vue` と呼ばれたファイルのシンプルな例です:

<img src="/images/vue-component.png" style="display: block; margin: 30px auto">

Now we get:

- [Complete syntax highlighting](https://github.com/vuejs/awesome-vue#syntax-highlighting)
- [CommonJS modules](https://webpack.github.io/docs/commonjs.html)
- [Component-scoped CSS](https://github.com/vuejs/vue-loader/blob/master/docs/en/features/scoped-css.md)

約束したとおり、Jade、Babel(ES2015モジュールと一緒に）やStylusなどより美しつかつ機能が豊富なコンポーネントをプリプロセッサとして利用できます。

<img src="/images/vue-component-with-preprocessors.png" style="display: block; margin: 30px auto">

これらの特定の言語は単なる一例です。Babel, TypeScript, SCSS, PostCSS など生産的なプリプロセッサを簡単に使うことが出来ます。

<!-- TODO: include CSS modules once it's supported in vue-loader 9.x -->

## はじめに

### JavaScriptでモジュールビルドシステムが初めてなユーザー向け

`.vue` コンポーネントにより、高度な JavaScript アプリケーションの分野に入っていきます。これはあなたがまだ使ったことのない、いくつかの追加ツールの使い方を学ぶことを意味します。

- **Node Package Manager (NPM)**: [Getting Started guide](https://docs.npmjs.com/getting-started/what-is-npm) のセクション _10: Uninstalling global packages_ を読んで下さい。

- **Modern JavaScript with ES2015/16**: Babel の [Learn ES2015 guide](https://babeljs.io/docs/learn-es2015/) を読んで下さい。現状では全ての機能を暗記する必要はないですが、参考として戻れるようにしておいてください。

これらのリソースに飛び込んだ後は、 [webpack-simple](https://github.com/vuejs-templates/webpack-simple) テンプレートを確認することをオススメします。インストラクションに沿って学習することで、あっという間に ES2015 とホットリローディングで動作した `.vue` コンポーネントの Vue プロジェクトを持っているはずです！

テンプレートでは、多数の"モジュール"を取りまとめ最終的なアプリケーションに束ねてくれる [Webpack](https://webpack.github.io/) というモジュールバンドラーを使用します。 Webpackについてもっと学ぶには、 [このビデオ](https://www.youtube.com/watch?v=WQue1AN93YU) がとても良い導入となります。一度基本を終えてしまえば、[Egghead.io上の上級Webpackコース](https://egghead.io/courses/using-webpack-for-production-javascript-applications)もチェックしたくなるでしょう。

Webpackでバンドルの中に含まれる前にそれぞれのモジュールは "loader" により変換されます。また Vue では `.vue` シングルファイル・コンポーネントを翻訳するために [vue-loader](https://github.com/vuejs/vue-loader) を推奨しています。 [webpack-simple](https://github.com/vuejs-templates/webpack-simple) テンプレートはあなたのために全てセットアップ済みの状態で用意してありますが、もし Webpack と `.vue` コンポーネントについてもっと学びたい場合は、 [vue-loaderドキュメント](vue-loader.vuejs.org) を読むことも出来ます。

### 上級者ユーザー向け

Whether you prefer Webpack or Browserify, we have documented templates for both simple and more complex projects. We recommend browsing [github.com/vuejs-templates](https://github.com/vuejs-templates), picking a template that's right for you, then following the instructions in the README to generate a new project with [vue-cli](https://github.com/vuejs/vue-cli).

## 本番デプロイ

縮小されたスタンドアローンビルド版 Vue ではファイルサイズを小さくするために全ての警告を取り除いていますが、 Webpack や Browserify のようなツールを利用している場合にこれを成し遂げるには多少の設定が必要です。

### Webpack

Use Webpack's [DefinePlugin](http://webpack.github.io/docs/list-of-plugins.html#defineplugin) to indicate a production environment, so that warning blocks can be automatically dropped by UglifyJS during minification. Example config:

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

- Run your bundling command with `NODE_ENV` set to `"production"`. This tells `vueify` to avoid including hot-reload and development related code.
- Apply a global [envify](https://github.com/hughsk/envify) transform to your bundle. This allows the minifier to strip out all the warnings in Vue's source code wrapped in env variable conditional blocks. For example:


``` bash
NODE_ENV=production browserify -g envify -e main.js | uglifyjs -c -m > build.js
```

- To extract styles to a separate css file use a extract-css plugin which is included in vueify.

``` bash
NODE_ENV=production browserify -g envify -p [ vueify/plugins/extract-css -o build.css ] -e main.js | uglifyjs -c -m > build.js
```
