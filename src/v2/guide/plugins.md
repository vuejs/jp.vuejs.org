---
title: プラグイン
updated: 2018-10-13
type: guide
order: 304
---

プラグインは通常 Vue にグローバルレベルで機能を追加します。プラグインに対しては厳密に定義されたスコープはありません。プラグインはいくつかのタイプがあります:

1. 1つ、または複数のグローバル・メソッドを追加します。例: [vue-custom-element](https://github.com/karol-f/vue-custom-element)

2. 1つ、または複数のグローバル・アセットを追加します。ディレクティブ/フィルタ/トランジションなど。例: [vue-touch](https://github.com/vuejs/vue-touch)

3. グローバル・ミックスインにより、1つ、または複数のコンポーネントオプションを追加します。例: [vue-router](https://github.com/vuejs/vue-router)

4. Vue.prototype に記述することにより、1つまたは、複数の Vue インスタンスメソッドを追加します。

5. 同時に上記のいくつかの組み合わせを注入しながら、独自の API を提供するライブラリ。例: [vue-router](https://github.com/vuejs/vue-router)

## プラグインの使用

`Vue.use()` グローバルメソッドを呼び出すことによってプラグインを使用します。これは `new Vue()` を呼び出してアプリを起動するよりも前に行われる必要があります:

```js
// `MyPlugin.install(Vue)` を呼び出します
Vue.use(MyPlugin)

new Vue({
  // ... オプション
})
```

いくつかのオプションに任意で渡すことができます:

``` js
Vue.use(MyPlugin, { someOption: true })
```

`Vue.use` は、同じプラグインを 1 回以上使用することを自動的に防ぎます。そのため、同じプラグインを同時に複数回呼び出しても、一度しかそのプラグインをインストールしません。

`vue-router` のような Vue.js 公式プラグインによって提供されるプラグインは、`Vue` がグローバル変数として使用可能な場合、自動的に `Vue.use()` を呼びます。しかしながら、 `CommonJS` のようなモジュール環境では、常に明示的に `Vue.use()` を呼ぶ必要があります:

``` js
// Browserify または Webpack 経由で CommonJS を使用
var Vue = require('vue')
var VueRouter = require('vue-router')

// これを呼びだすのを忘れてはいけません
Vue.use(VueRouter)
```

コミュニティの貢献による膨大なプラグインやライブラリは [awesome-vue](https://github.com/vuejs/awesome-vue#components--libraries) で確認できます。

## プラグインの記述

Vue.js プラグインは `install` メソッドを公開する必要があります。このメソッドは第 1 引数は `Vue` コンストラクタ、第 2 引数は任意で `options` が指定されて呼び出されます:

``` js
MyPlugin.install = function (Vue, options) {
  // 1. グローバルメソッドまたはプロパティを追加
  Vue.myGlobalMethod = function () {
    // 何らかのロジック ...
  }
  // 2. グローバルアセットを追加
  Vue.directive('my-directive', {
    bind (el, binding, vnode, oldVnode) {
      // 何らかのロジック ...
    }
    ...
  })
  // 3. 1つ、または複数のコンポーネントオプションを注入
  Vue.mixin({
    created: function () {
      // 何らかのロジック ...
    }
    ...
  })
  // 4. インスタンスメソッドを追加
  Vue.prototype.$myMethod = function (methodOptions) {
    // 何らかのロジック ...
  }
}
```
