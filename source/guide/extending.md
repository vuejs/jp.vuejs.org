title: Vue の拡張
type: guide
order: 14
---

## ミックスインによる拡張

ミックスイン (mixin) は、Vue のコンポーネントに再利用可能で柔軟性のある機能を持たせるための方法です。ミックスインは、通常の Vue コンポーネントのオプションと同じように記述できます。

``` js
// mixin.js
module.exports = {
  created: function () {
    this.hello()
  },
  methods: {
    hello: function () {
      console.log('hello from mixin!')
    }
  }
}
```

``` js
// test.js
var myMixin = require('./mixin')
var Component = Vue.extend({
  mixins: [myMixin]
})
var component = new Component() // -> "hello from mixin!"
```

## プラグインによる拡張

プラグインは、通常 Vue のグローバルメソッドの機能を追加します。

### プラグインの記述

1. 1つ、または複数のグローバル・メソッドを追加します（例：[vue-element](https://github.com/vuejs/vue-element)）。
2. 1つ、または複数のグローバル・アセットを追加します：ディレクティブ/フィルタ/トランジションなど（例：[vue-touch](https://github.com/vuejs/vue-touch)）。
3. Vue インスタンスメソッドを Vue.prototype に記述します。慣例として、Vue インスタンスメソッドは、`$` をつけることで、他のデータやメソッドと干渉を避けることができます。

``` js
exports.install = function (Vue, options) {
  Vue.myGlobalMethod = ...          // 1
  Vue.directive('my-directive', {}) // 2
  Vue.prototype.$myMethod = ...     // 3
}
```

### プラグインの使用

CommonJS ベースのビルドを行っていると仮定します。

``` js
var vueTouch = require('vue-touch')
// プラグインをグルーバルで使用
Vue.use(vueTouch)
```

プラグインには、オプションを追加することができます。

```js
Vue.use('my-plugin', {
  /* 追加オプションを渡します */
})
```

## 他の拡張ツール

- [vue-resource](https://github.com/vuejs/vue-resource): XMLHttpRequest または JSONP を使用する Web リクエストの生成、そしてレスポンスのハンドルのためサービスを提供するプラグイン。
- [vue-devtools](https://github.com/vuejs/vue-devtools): Vue.js アプリケーションのデバッグ用 Chrome devtools extension です。
- [vue-touch](https://github.com/vuejs/vue-touch): Hammer.js を利用して、タッチ操作のディレクティブを追加できます。
- [vue-element](https://github.com/vuejs/vue-element): Vue.js でカスタムエレメントを登録することができます。
- [ユーザーによって貢献されたコンポーネント & ツールのリスト](https://github.com/yyx990803/vue/wiki/User-Contributed-Components-&-Tools)

次: [FAQ](/guide/faq.html)
