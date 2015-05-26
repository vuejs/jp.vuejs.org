title: Extending Vue
type: guide
order: 14
---

## Mixinsによる拡張

Mixinsは、Vueのコンポーネントに再利用可能で柔軟性のある機能を持たせるための方法です。mixinは、通常のVueコンポーネントのoptionと同じように記述できます。

``` js
// mixin.js
exports.mixin = {
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

プラグインは、通常Vueのグローバルメソッドの機能を追加します。

### プラグインの記述

1. 1つ、または複数のグローバル・メソッドを追加します（例：[vue-element](https://github.com/vuejs/vue-element)）。
2. 1つ、または複数のグローバル・アセットを追加します：directives/filters/transitions など（例：[vue-touch](https://github.com/vuejs/vue-touch)）。
3. VueインスタンスメソッドをVue.prototypeに記述します。慣例として、Vueインスタンスメソッドは、`$`をつけることで、他のデータやメソッドと干渉を避けることができます。

``` js
exports.install = function (Vue, options) {
  Vue.myGlobalMethod = ...          // 1
  Vue.directive('my-directive', {}) // 2
  Vue.prototype.$myMethod = ...     // 3
}
```

### プラグインの使用

CommonJSベースのビルドを行っていると仮定します。

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

- [vue-devtools](https://github.com/vuejs/vue-devtools): Vue.jsアプリケーションのデバッグ用Chrome devtools extensionです。
- [vue-touch](https://github.com/vuejs/vue-touch): Hammer.jsを利用して、タッチ操作のディレクティブを追加できます。
- [vue-element](https://github.com/vuejs/vue-element): Vue.jsでカスタムエレメントを登録することができます。
- [List of User Contributed Tools](https://github.com/yyx990803/vue/wiki/User-Contributed-Components-&-Tools)
