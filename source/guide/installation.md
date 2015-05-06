title: Installation
type: guide
order: 1
vue_version: 0.11.5
dev_size: 181.31
min_size: 56.08
gz_size: 18.39
---

> **互換性に関する注意:** Vue.js は IE8 以下をサポートしていません。

## Standalone

ダウンロードし script タグで読み込んでください。`Vue` はグローバル変数として登録されます。

<div id="downloads">
<a class="button" href="https://raw.github.com/yyx990803/vue/{{vue_version}}/dist/vue.js" download>Development Version</a><span class="light info">{{dev_size}}kb, コメント、デバック、警告のメッセージが豊富です。</span>

<a class="button" href="https://raw.github.com/yyx990803/vue/{{vue_version}}/dist/vue.min.js" download>Production Version</a><span class="light info">{{min_size}}kb minified / {{gz_size}}kb gzipped</span>
</div>

 [cdnjs](//cdnjs.cloudflare.com/ajax/libs/vue/{{vue_version}}/vue.min.js)も利用可能です。 (同期に少し時間がかかるので、最新版ではないかもしれません)。

## NPM

``` bash
$ npm install vue
# for edge version:
$ npm install yyx990803/vue#dev
```

## Bower

``` bash
# only stable version is available through Bower
$ bower install vue
```

## Duo

```js
var Vue = require('yyx990803/vue')
// for edge version:
var Vue = require('yyx990803/vue@dev')
```

## Component

``` bash
$ component install yyx990803/vue
# for edge version:
$ component install yyx990803/vue@dev
```

## AMD Module Loaders
ダウンロードされたスタンドアローン版 vue と Bower 経由でインストールされた vue は UMD でラップされています。そのため、 AMD module のように直接利用することができます。


## Ready?

[Let's Get Started](/guide/).
