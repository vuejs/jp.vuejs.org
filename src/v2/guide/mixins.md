---
title: Mixins
type: guide
order: 17
---

## 基本

ミックスイン (mixin) は、Vue コンポーネントに再利用可能で柔軟性のある機能を持たせるための方法です。ミックスインオブジェクトは任意のコンポーネントオプションを含むことができます。コンポーネントがミックスインを使用するとき、ミックスインの全てのオプションはコンポーネント自身のオプションに"混ぜられ"ます。

例:

``` js
// ミックスインオブジェクトを定義
var myMixin = {
  created: function () {
    this.hello()
  },
  methods: {
    hello: function () {
      console.log('hello from mixin!')
    }
  }
}

// このミックスインを使用するコンポーネントを定義
var Component = Vue.extend({
  mixins: [myMixin]
})

var component = new Component() // -> "hello from mixin!"
```

## オプションのマージ

ミックスインとコンポーネントそれ自身がオプションと重複するとき、それらは適切なストラテジを使用して"マージ"されます。例えば、同じ名前のフック関数はそれら全てが呼び出されるよう配列にマージされます。加えて、ミックスインのフックはコンポーネント自身のフック**前**に呼ばれます:


``` js
var mixin = {
  created: function () {
    console.log('mixin hook called')
  }
}

new Vue({
  mixins: [mixin],
  created: function () {
    console.log('component hook called')
  }
})

// -> "mixin hook called"
// -> "component hook called"
```

オブジェクトの値を期待するオプションは、例えば、`methods`、`components`、そして `directives` らは同じオブジェクトにマージされます。コンポーネントオプションはこれらのオブジェクトでキーのコンフリクトがあるとき、優先されます:

``` js
var mixin = {
  methods: {
    foo: function () {
      console.log('foo')
    },
    conflicting: function () {
      console.log('from mixin')
    }
  }
}

var vm = new Vue({
  mixins: [mixin],
  methods: {
    bar: function () {
      console.log('bar')
    },
    conflicting: function () {
      console.log('from self')
    }
  }
})

vm.foo() // -> "foo"
vm.bar() // -> "bar"
vm.conflicting() // -> "from self"
```

同じマージストラテジが `Vue.extend()` で使用されることに注意してください。

## グローバルミックスイン

グローバルにミックスインを適用することもできます。使用に注意してください！一度、グローバルにミックスインを適用すると、それはその後に作成する**全ての** Vue インスタンスに影響します。適切に使用されるとき、これはカスタムオプションに対して処理ロジックを注入するために使用することができます:

``` js
// `myOption` カスタムオプションにハンドラを注入する
Vue.mixin({
  created: function () {
    var myOption = this.$options.myOption
    if (myOption) {
      console.log(myOption)
    }
  }
})

new Vue({
  myOption: 'hello!'
})
// -> "hello!"
```

<p class="tip">サードパーティのコンポーネントを含んでいる、すべての単一の作成された Vue インスタンスに影響があるため、グローバルミックスインは多用せずかつ慎重に使用してください。多くのケースでは、上記の例のような、カスタムオプションを処理するようなものに使用すべきです。また、重複適用を避けるため [プラグイン](../guide/plugins.html) としてそれらを作成することをお勧めします。</p>

## カスタムオプションのマージストラテジ

カスタムオプションがマージされるとき、それらは単純に既存の値を上書きするデフォルトのストラテジを使用します。カスタムロジックを使用してカスタムオプションをマージする場合、`Vue.config.optionMergeStrategies` をアタッチする必要があります:

``` js
Vue.config.optionMergeStrategies.myOption = function (toVal, fromVal) {
  // マージされた値を返す
}
```

ほとんどのオブジェクトベースのオプションでは、単純に `methods` で使用されるのと同じストラテジを使用することができます:

``` js
var strategies = Vue.config.optionMergeStrategies
strategies.myOption = strategies.methods
```

より高度な例として [Vuex](https://github.com/vuejs/vuex) 1.x のマージストラテジがあります:

``` js
const merge = Vue.config.optionMergeStrategies.computed
Vue.config.optionMergeStrategies.vuex = function (toVal, fromVal) {
  if (!toVal) return fromVal
  if (!fromVal) return toVal
  return {
    getters: merge(toVal.getters, fromVal.getters),
    state: merge(toVal.state, fromVal.state),
    actions: merge(toVal.actions, fromVal.actions)
  }
}
```
