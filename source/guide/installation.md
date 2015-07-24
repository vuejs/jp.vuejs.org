title: インストール
type: guide
order: 1
vue_version: 0.12.8
dev_size: "226.38"
min_size: "68.32"
gz_size: "22.36"
---

> **互換性に関する注意:** Vue.js は IE8 以下をサポートしていません。

## スタンドアロン

ダウンロードし script タグで読み込んでください。`Vue` はグローバル変数として登録されます。

<div id="downloads">
<a class="button" href="https://raw.github.com/yyx990803/vue/{{vue_version}}/dist/vue.js" download>開発版</a><span class="light info">{{dev_size}}kb, コメント、デバック、警告のメッセージが豊富です。</span>

<a class="button" href="https://raw.github.com/yyx990803/vue/{{vue_version}}/dist/vue.min.js" download>リリース版</a><span class="light info">{{min_size}}kb minified / {{gz_size}}kb gzipped</span>
</div>

### CDN

 [jsdelivr](//cdn.jsdelivr.net/vue/{{vue_version}}/vue.min.js) または [cdnjs](//cdnjs.cloudflare.com/ajax/libs/vue/{{vue_version}}/vue.min.js) を利用可能です。 (同期に少し時間がかかるので、最新版ではないかもしれません)。

### CSP 準拠ビルド

Google Chrome アプリのようなある環境では、Content Secuirty Policy (CSP) を強制し、そして式の評価するために `new Function()` の使用を許可しません。これらのケースの場合、[CSP 準拠ビルド](https://github.com/yyx990803/vue/tree/csp/dist) を代わりに使用できます。

## NPM

``` bash
$ npm install vue
# CSP 準拠バージョン向け:
$ npm install vue@csp
# 開発ビルド向け(Github):
$ npm install yyx990803/vue#dev
```

## Bower

``` bash
# Bower では安定版だけ利用できます
$ bower install vue
```

## AMD モジュールローダ
ダウンロードされたスタンドアロン版 Vue.js と Bower 経由でインストールされた Vue.js は UMD でラップされています。そのため、 AMD モジュールとして直接利用することができます。


## 準備はいいですか？

[はじめましょう！](/guide/)
