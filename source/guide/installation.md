---
title: インストール
type: guide
order: 1
vue_version: 0.12.16
dev_size: "235.74"
min_size: "71.44"
gz_size: "23.22"
---

> **互換性に関する注意:** Vue.js は IE8 以下をサポートしていません。

## スタンドアロン

ダウンロードし script タグで読み込んでください。`Vue` はグローバル変数として登録されます。

<div id="downloads">
<a class="button" href="https://raw.github.com/vuejs/vue/{{vue_version}}/dist/vue.js" download>開発バージョン</a><span class="light info">警告出力とデバッグモードあり</span>

<a class="button" href="https://raw.github.com/vuejs/vue/{{vue_version}}/dist/vue.min.js" download>プロダクションバージョン</a><span class="light info">警告出力なし、{{gz_size}}kb min+gzip</span>
</div>

### CDN

 [jsdelivr](//cdn.jsdelivr.net/vue/{{vue_version}}/vue.min.js) または [cdnjs](//cdnjs.cloudflare.com/ajax/libs/vue/{{vue_version}}/vue.min.js) を利用可能です。 (同期に少し時間がかかるので、最新版ではないかもしれません)。

### CSP 準拠ビルド

Google Chrome アプリのようなある環境では、Content Security Policy (CSP) を強制し、そして式の評価するために `new Function()` の使用を許可しません。これらのケースの場合、[CSP 準拠ビルド](https://github.com/vuejs/vue/tree/csp/dist) を代わりに使用できます。

## NPM

NPM is the recommended installation method when building large scale apps with Vue.js. It pairs nicely with a CommonJS module bundler such as [Webpack](http://webpack.github.io/) or [Browserify](http://browserify.org/). Vue.js also provides accompanying tools for authoring [Single File Components](http://localhost:4000/guide/application.html#Single_File_Components).

``` bash
# latest stable
$ npm install vue
# 最新の安定版 + CSP 準拠
$ npm install vue@csp
# 開発ビルド (Github から直接):
$ npm install vuejs/vue#dev
```

## Bower

``` bash
# 最新の安定版
$ bower install vue
```

## AMD モジュールローダ
ダウンロードされたスタンドアロン版 Vue.js と Bower 経由でインストールされた Vue.js は UMD でラップされています。そのため、 AMD モジュールとして直接利用することができます。

