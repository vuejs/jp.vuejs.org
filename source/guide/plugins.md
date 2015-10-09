title: Plugins
type: guide
order: 17
---



## プラグインの記述

Plugins usually add global-level functionality to Vue. There is no strictly defined scope for a plugin - there are typically several types of plugins you can write:

1. 1つ、または複数のグローバル・メソッドを追加します（例：[vue-element](https://github.com/vuejs/vue-element)）。

2. 1つ、または複数のグローバル・アセットを追加します：ディレクティブ/フィルタ/トランジションなど（例：[vue-touch](https://github.com/vuejs/vue-touch)）。

3. Vue インスタンスメソッドを Vue.prototype に記述します。

4. A library that provides an API of its own, while at the same time injecting some combination of the above. e.g. [vue-router](https://github.com/vuejs/vue-router)

A Vue.js plugin should expose an `install` method. The method will be called with the `Vue` constructor as the first argument, along with possible options:

``` js
MyPlugin.install = function (Vue, options) {
  // 1. add global method or property
  Vue.myGlobalMethod = ...
  // 2. add a global asset
  Vue.directive('my-directive', {})
  // 3. add an instance method
  Vue.prototype.$myMethod = ...
}
```

## プラグインの使用

CommonJS ベースのビルドを行っていると仮定します。

Use plugins by calling the `Vue.use()` global method:

``` js
// calls `MyPlugin.install(Vue)`
Vue.use(MyPlugin)
```

You can optionally pass in some options:

``` js
Vue.use(MyPlugin, { someOption: true })
```

Some plugins such as `vue-router` automatically calls `Vue.use()` if `Vue` is available as a global variable. However in a module environment you always need to call `Vue.use()` explicitly:

``` js
// When using CommonJS via Browserify or Webpack
var Vue = require('vue')
var VueRouter = require('vue-router')

// Don't forget to call this
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

- [ユーザーによって貢献されたコンポーネント & ツールのリスト](https://github.com/yyx990803/vue/wiki/User-Contributed-Components-&-Tools)
