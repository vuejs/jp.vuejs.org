title: インストール
type: guide
order: 1
vue_version: 0.12.5
dev_size: 218.88
min_size: 67.44
gz_size: 21.93
---

> **互換性に関する注意:** Vue.js は IE8 以下をサポートしていません。

## スタンドアロン

ダウンロードし script タグで読み込んでください。`Vue` はグローバル変数として登録されます。

<div id="downloads">
<a class="button" href="https://raw.github.com/yyx990803/vue/{{vue_version}}/dist/vue.js" download>開発版</a><span class="light info">{{dev_size}}kb, コメント、デバック、警告のメッセージが豊富です。</span>

<a class="button" href="https://raw.github.com/yyx990803/vue/{{vue_version}}/dist/vue.min.js" download>リリース版</a><span class="light info">{{min_size}}kb minified / {{gz_size}}kb gzipped</span>
</div>

 [cdnjs](//cdnjs.cloudflare.com/ajax/libs/vue/{{vue_version}}/vue.min.js) または [jsdelivr](//cdn.jsdelivr.net/vue/{{vue_version}}/vue.min.js) も利用可能です。 (同期に少し時間がかかるので、最新版ではないかもしれません)。

## NPM

``` bash
$ npm install vue
# 最新版向け:
$ npm install yyx990803/vue#dev
```

## Bower

``` bash
# Bower では安定版だけ利用できます
$ bower install vue
```

## Duo

```js
var Vue = require('yyx990803/vue')
// 最新版向け:
var Vue = require('yyx990803/vue@dev')
```

## AMD モジュールローダ
ダウンロードされたスタンドアロン版 Vue.js と Bower 経由でインストールされた Vue.js は UMD でラップされています。そのため、 AMD モジュールとして直接利用することができます。


## 準備はいいですか？

[はじめましょう！](/guide/)
