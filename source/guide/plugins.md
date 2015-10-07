title: Plugins
type: guide
order: 17
---

Plugins usually adds global-level functionality to Vue.

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
Vue.use(require('my-plugin'), {
  /* 追加オプションを渡します */
})
```

## 現在提供済みのプラグインとツール

- [vue-router](https://github.com/vuejs/vue-router): シングルページアプリケーションを簡単に作るために Vue.js コアにぐっと統合された Vue.js 向けのオフィシャルルータ。
- [vue-resource](https://github.com/vuejs/vue-resource): XMLHttpRequest または JSONP を使用する Web リクエストの生成、そしてレスポンスのハンドルのためサービスを提供するプラグイン。
- [vue-async-data](https://github.com/vuejs/vue-async-data): 非同期データ読み込みプラグイン。
- [vue-validator](https://github.com/vuejs/vue-validator): フォーム検証するためのプラグイン。
- [vue-devtools](https://github.com/vuejs/vue-devtools): Vue.js アプリケーションのデバッグ用 Chrome devtools extension 。
- [vue-touch](https://github.com/vuejs/vue-touch): Hammer.js を利用して、タッチ操作のディレクティブを追加するプラグイン。
- [vue-element](https://github.com/vuejs/vue-element): Vue.js でカスタムエレメントを登録できるようになるプラグイン。
- [ユーザーによって貢献されたコンポーネント & ツールのリスト](https://github.com/yyx990803/vue/wiki/User-Contributed-Components-&-Tools)
