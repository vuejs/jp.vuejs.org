---
title: インストール
updated: 2020-04-25
type: guide
order: 1
vue_version: 2.5.16
gz_size: "30.90"
---

### 互換性の注意

Vue.js は IE8 ではシム (shim) ができない ECMAScript 5 の機能を使用するため、IE8 とそれ以下のバージョンをサポートして**いません**。しかしながら、[ECMAScript 5 準拠のブラウザ](https://caniuse.com/#feat=es5) は全てサポートしています。

### セマンティックバージョニング

Vue は、すべての公式プロジェクトにおいてドキュメント化された機能や動作については、[セマンティックバージョニング](https://semver.org/ja/)に準拠しています。ドキュメント化されていない動作や公開されている内容については、[リリースノート](https://github.com/vuejs/vue/releases)に変更点が記載されています。

### リリースノート

最新の安定バージョン: {{vue_version}}

各バージョンの詳細なリリースノートは、[GitHub](https://github.com/vuejs/vue/releases) で入手できます。

## Vue Devtools

Vue を使用する場合は、ブラウザに [Vue Devtools](https://github.com/vuejs/vue-devtools#vue-devtools) をインストールすることをお勧めします。これにより、 Vue アプリケーションをよりユーザーフレンドリーなインターフェースで調査、デバッグすることが可能になります。

## `<script>` 直接組み込み

ダウンロードし script タグで読み込んでください。`Vue` はグローバル変数として登録されます。

<p class="tip">開発中は本番バージョンを使用しないでください。 警告や一般的な間違いを見逃す可能性があります!</p>

<div id="downloads">
  <a class="button" href="/js/vue.js" download>開発バージョン</a><span class="light info">警告出力とデバッグモードあり </span>

  <a class="button" href="/js/vue.min.js" download>本番バージョン</a><span class="light info">警告出力なし、 {{gz_size}} KB min+gzip</span>
</div>

### CDN

プロトタイピングや学習を目的とする場合は、以下のようにして最新バージョンを使うことができます:

``` html
<script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
```

本番環境では、新しいバージョンによる意図しない不具合を避けるため、特定のバージョン番号とビルド番号にリンクすることをお勧めします:

``` html
<script src="https://cdn.jsdelivr.net/npm/vue@2.6.0"></script>
```

もしもネイティブの ES Modules を使っているなら、ES Modules 互換のビルドもあります:

``` html
<script type="module">
  import Vue from 'https://cdn.jsdelivr.net/npm/vue@2.6.0/dist/vue.esm.browser.js'
</script>
```

[cdn.jsdelivr.net/npm/vue](https://cdn.jsdelivr.net/npm/vue/) で NPM パッケージのソースを参照することができます。


Vue は [unpkg](https://unpkg.com/vue@{{vue_version}}/dist/vue.js) または [cdnjs](https://cdnjs.cloudflare.com/ajax/libs/vue/{{vue_version}}/vue.js) 上でも利用可能です(cdnjs は同期に少し時間がかかるため、最新版ではない可能性があります)。

[Vue のさまざまなビルドについて](#さまざまなビルドについて)を読み、公開されたサイトでは**本番バージョン**を使用し、`vue.js` を `vue.min.js` に置き換えてください。これは開発体験の代わりにスピードのために最適化された小さなビルドです。

## NPM

Vue.js による大規模アプリケーションを構築するときには、NPM を利用したインストールを推奨しています。 [Webpack](https://webpack.js.org) または [Browserify](http://browserify.org/) のようモジュールハンドラとうまく組み合わせられます。 Vue は[単一ファイルコンポーネント](single-file-components.html)を作成するための、付随するツールも提供しています。

``` bash
# 最新の安定版
$ npm install vue
```

## CLI

大規模なシングルページアプリケーション開発のための足場を素早く組むために、Vue.js では[オフィシャル CLI](https://github.com/vuejs/vue-cli) を提供します。この CLI にはモダンなフロントエンドワークフローのための、すぐに使えるビルド設定を用意しています。ホットリロード、保存時のリント、製品リリース用ビルドができるようになるまでに、ほんの数分しかかかりません。より詳細は [Vue CLI ドキュメント](https://cli.vuejs.org) を参照してください。

<p class="tip">CLI は Node.js および関連するビルドツールに関する事前知識を前提としています。Vue またはフロントエンドビルドツールを初めて使用している場合、CLI を使用する前に、ビルドツールなしで[ガイド](./)を参照することを強くお勧めします。</p>

<div class="vue-mastery"><a href="https://www.vuemastery.com/courses/real-world-vue-js/vue-cli" target="_blank" rel="sponsored noopener" title="Vue CLI">Vue Masteryで動画の説明を見る</a></div>

## さまざまなビルドについて

[NPM パッケージの `dist/` ディレクトリ](https://cdn.jsdelivr.net/npm/vue/dist/) では Vue.js の多くのさまざまなビルドが見つかります。それらの違いの概要は以下の通りです:

| | UMD | CommonJS | ES Module (バンドラ用) | ES Module (ブラウザ用) |
| --- | --- | --- | --- | --- |
| **完全** | vue.js | vue.common.js | vue.esm.js | vue.esm.browser.js |
| **ランタイム限定** | vue.runtime.js | vue.runtime.common.js | vue.runtime.esm.js | - |
| **完全 (本番用)** | vue.min.js | - | - | vue.esm.browser.min.js |
| **ランタイム限定 (本番用)** | vue.runtime.min.js | - | - | - |

### 用語

- **完全**: コンパイラとランタイムの両方が含まれたビルドです。

- **コンパイラ**: テンプレート文字列を JavaScript レンダリング関数にコンパイルするためのコードです。

- **ランタイム**: Vue インスタンスの作成やレンダリング、仮想 DOM の変更などのためのコードです。基本的にコンパイラを除く全てのものです。

- **[UMD](https://github.com/umdjs/umd)**: UMD ビルドは `<script>` タグによってブラウザに直接利用されます。[https://cdn.jsdelivr.net/npm/vue](https://cdn.jsdelivr.net/npm/vue) の jsDelivr CDN からの既定のファイルは ランタイム + コンパイラ UMD ビルド (`vue.js`) です。

- **[CommonJS](http://wiki.commonjs.org/wiki/Modules/1.1)**: CommonJS ビルドは [browserify](http://browserify.org/) や [webpack 1](https://webpack.github.io) のような古いバンドラでの利用を意図しています。これらのバンドラ (`pkg.main`) のための既定のファイルはランタイム限定 CommonJS ビルド (`vue.runtime.common.js`) です。

- **[ES Module](http://exploringjs.com/es6/ch_modules.html)**: バージョン 2.6 から Vue は 2 種類の ES Modules (ESM) ビルドを提供します:

  - バンドラ用 ESM: [webpack 2](https://webpack.js.org) や [Rollup](https://rollupjs.org/) のようなモダンバンドラでの利用を想定しています。ESM フォーマットは、バンドラが "tree-shaking" を実行して最終バンドルから未使用コードを除去しやすいように、静的解析できる設計になっています。これらのバンドラ (`pkg.module`) のための既定のファイルは、ランタイム限定 ES Module ビルド (`vue.runtime.esm.js`) です。

  - ブラウザ用 ESM (2.6 以降のみ): モダンブラウザでの `<script type="module">` による直接インポートを想定しています。

### ランタイム + コンパイラとランタイム限定の違い

もしクライアントでテンプレートをコンパイルする必要がある (例えば、 `template` オプションに文字列を渡す、もしくは DOM 内の HTML をテンプレートとして利用し要素にマウントする) 場合は、コンパイラすなわち完全ビルドが必要です。


``` js
// これはコンパイラが必要です
new Vue({
  template: '<div>{{ hi }}</div>'
})

// これはコンパイラは必要ありません
new Vue({
  render (h) {
    return h('div', this.hi)
  }
})
```

`vue-loader` や `vueify` を利用する場合、 `*.vue` ファイルに中のテンプレートはビルド時に JavaScript に事前コンパイルされます。最終成果物の中にコンパイラは本当に必要なく、したがってランタイム限定ビルドを利用することが出来ます。

ランタイム限定ビルドは完全ビルドに比べおよそ 30% 軽量なため、利用できるときにはこれを利用したほうが良いでしょう。それでもなお完全ビルドを利用したい場合は、バンドラでエイリアスを設定する必要があります。


#### Webpack

``` js
module.exports = {
  // ...
  resolve: {
    alias: {
      'vue$': 'vue/dist/vue.esm.js' // 'vue/dist/vue.common.js' webpack 1 用
    }
  }
}
```

#### Rollup

``` js
const alias = require('rollup-plugin-alias')

rollup({
  // ...
  plugins: [
    alias({
      'vue': require.resolve('vue/dist/vue.esm.js')
    })
  ]
})
```

#### Browserify

プロジェクトの `package.json` に追加してください:

``` js
{
  // ...
  "browser": {
    "vue": "vue/dist/vue.common.js"
  }
}
```

#### Parcel

プロジェクトの `package.json` に追加してください:

``` js
{
  // ...
  "alias": {
    "vue" : "./node_modules/vue/dist/vue.common.js"
  }
}
```

### 開発モードと本番モードの違い

開発/本番モードは UMD ビルドではハードコードされています: 開発用では非縮小ファイルで、本番用では圧縮されたファイルになっています。

CommonJS と ES Module ビルドはバンドラでの利用を意図しているため、圧縮バージョンを提供していません。あなたの責任で最終成果物を圧縮する必要があります。

CommonJS と ES Module ビルドはまた、実行モードを決めるために `process.env.NODE_ENV` を直接チェックするように保持されています。 Vue が実行するモードをコントロールするために適切なバンドラ設定を利用してこれらの環境変数を置換するようにしてください。 `process.env.NODE_ENV` を置換することで、 UglifyJS のような圧縮ツールが開発用コードのブロックを削除し、最終ファイルのサイズを削減することができます。


#### Webpack

Webpack 4 以降では、`mode` オプションを使用できます:

``` js
module.exports = {
  mode: 'production'
}
```

しかし、Webpack 3 以前では、[DefinePlugin](https://webpack.js.org/plugins/define-plugin/) を使用する必要があります:

``` js
var webpack = require('webpack')

module.exports = {
  // ...
  plugins: [
    // ...
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: JSON.stringify('production')
      }
    })
  ]
}
```

#### Rollup

[rollup-plugin-replace](https://github.com/rollup/rollup-plugin-replace) は以下のようにして利用します:

``` js
const replace = require('rollup-plugin-replace')

rollup({
  // ...
  plugins: [
    replace({
      'process.env.NODE_ENV': JSON.stringify('production')
    })
  ]
}).then(...)
```

#### Browserify

グローバルな [envify](https://github.com/hughsk/envify) transform は以下のようにしてバンドラに適用します:

``` bash
NODE_ENV=production browserify -g envify -e main.js | uglifyjs -c -m > build.js
```

[プロダクション環境への配信のヒント](deployment.html) も参考にしてください。

### CSP 環境

Google Chrome アプリのようなある環境では、Content Security Policy (CSP) を強制し、そして式を評価するために `new Function()` の使用を禁止しています。テンプレートのコンパイルは、完全ビルドに依存するため、これらの環境では使用できません。

一方では、ランタイム限定ビルドでは CSP に準拠しています。 [Webpack + vue-loader](https://github.com/vuejs-templates/webpack-simple) または [Browserify + vueify](https://github.com/vuejs-templates/browserify-simple) でランタイム限定ビルドを使用する場合は、テンプレートは CSP 環境でも完璧に動作する `render` 関数にプリコンパイルされます。

## 開発版のビルド

**重要** GitHub 上の `/dist` フォルダに存在するビルドされたファイルは、リリース時にのみチェックインされます。 GitHub 上の最新のソースコードから Vue を使用するためには、あなた自身がそれをビルドしなければなりません！

``` bash
git clone https://github.com/vuejs/vue.git node_modules/vue
cd node_modules/vue
npm install
npm run build
```

## Bower

Bower では UMD ビルドのみで利用できます。

``` bash
# 最新の安定板
$ bower install vue
```

## AMD モジュールローダ

全ての UMD ビルドは AMD モジュールとして直接利用できます。
