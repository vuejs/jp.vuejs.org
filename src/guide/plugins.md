---
title: プラグイン
type: guide
order: 17
---


## プラグインの記述

プラグインは通常 Vue にグローバルレベルで機能を追加します。プラグインに対しては厳密に定義されたスコープはありません。書くことができるプラグインはいくつかのタイプがあります:

1. 1つ、または複数のグローバル・メソッドを追加します。例: [vue-element](https://github.com/vuejs/vue-element)

2. 1つ、または複数のグローバル・アセットを追加します。ディレクティブ/フィルタ/トランジションなど。例: [vue-touch](https://github.com/vuejs/vue-touch)

3. Vue インスタンスメソッドを Vue.prototype に記述します。

4. 同時に上記のいくつかの組み合わせを注入しながら、独自の API を提供するライブラリ。例: [vue-router](https://github.com/vuejs/vue-router)

Vue.js プラグインは `install` メソッドを公開する必要があります。このメソッドは起こりうるオプションと一緒に、最初の引数として `Vue` コンストラクタで呼び出されます:

``` js
MyPlugin.install = function (Vue, options) {
  // 1. グローバルメソッドまたはプロパティを追加
  Vue.myGlobalMethod = ...
  // 2. グローバルアセットを追加
  Vue.directive('my-directive', {})
  // 3. インスタンスメソッドを追加
  Vue.prototype.$myMethod = ...
}
```

## プラグインの使用

CommonJS ベースのビルドを行っていると仮定します。

`Vue.use()` グローバルメソッドを呼び出すことによってプラグインを使用します:

``` js
// `MyPlugin.install(Vue)` を呼び出します
Vue.use(MyPlugin)
```

いくつかのオプションに任意で渡すことができます:

``` js
Vue.use(MyPlugin, { someOption: true })
```

`vue-router` のようないくつかのプラグインは、`Vue` はグローバル変数として使用可能な場合、自動的に `Vue.use()` は呼びます。しかしながら、モジュール環境では常に明示的に `Vue.use()` を呼ぶ必要があります:

``` js
// Browserify または Webpack 経由で CommonJS を使用
var Vue = require('vue')
var VueRouter = require('vue-router')

// これを呼び出すのを忘れてはいけません
Vue.use(VueRouter)
```

## 現在提供済みのプラグインとツール

- [vue-router](https://github.com/vuejs/vue-router): シングルページアプリケーションを簡単に作るために Vue.js コアにぐっと統合された Vue.js 向けのオフィシャルルータ。

- [vue-resource](https://github.com/vuejs/vue-resource): XMLHttpRequest または JSONP を使用する Web リクエストの生成、そしてレスポンスのハンドルのためサービスを提供するプラグイン。

- [vue-async-data](https://github.com/vuejs/vue-async-data): 非同期データ読み込みプラグイン。

- [vue-validator](https://github.com/vuejs/vue-validator): フォーム検証するためのプラグイン。

- [vue-devtools](https://github.com/vuejs/vue-devtools): Vue.js アプリケーションのデバッグ用 Chrome devtools extension 。

- [vue-touch](https://github.com/vuejs/vue-touch): Hammer.js を利用して、タッチ操作のディレクティブを追加するプラグイン (outdated)。

- [vue-element](https://github.com/vuejs/vue-element): Vue.js でカスタムエレメントを登録できるようになるプラグイン。

- [ユーザーによって貢献されたコンポーネント & ツールのリスト](https://github.com/vuejs/vue/wiki/User-Contributed-Components-&-Tools)
