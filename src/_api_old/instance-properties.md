---
title: インスタンスプロパティ
type: api
order: 3
---

### vm.$el

- **型:** `HTMLElement`
- **Read only**

Vue インスタンスが管理している DOM 要素。これは[フラグメントインスタンス](/guide/best-practices.html#フラグメントインスタンス)向けであることに注意が必要で、`vm.$el` はフラグメントの開始位置を示すアンカーノードを返します。

### vm.$data

- **型:** `Object`

Vue インスタンスが監視しているデータオブジェクト。新しいオブジェクトでスワップできます。Vue インスタンスプロキシはデータオブジェクトのプロパティにアクセスします。

### vm.$options

- **型:** `Object`

現在の Vue インスタンスのためのインストールオプションとして使われます。これはオプションにカスタムプロパティを含めたいとき便利です:

``` js
new Vue({
  customOption: 'foo',
  created: function () {
    console.log(this.$options.customOption) // -> 'foo'
  }
})
```

### vm.$parent

- **型:** `Vue`
- **Read only**

もし現在のインスタンスが1つ持つ場合は親のインスタンス。

### vm.$root

- **型:** `Vue`
- **Read only**

現在のコンポーネントツリーのルート Vue インスタンス。もし現在のインスタンスが親ではない場合、この値はそれ自身でしょう。

### vm.$children

- **型:** `Array<Vue>`
- **Read only**

現在のインスタンスの直接的な子コンポーネント。

### vm.$

- **型:** `Object`
- **Read only**

`v-ref` で登録した子コンポーネントを保持するオブジェクト。詳細については、[v-ref](/api/directives.html#v-ref) を参照してください。

### vm.$$

- **型:** `Object`
- **Read only**

`v-el` で登録した DOM 要素を保持するオブジェクト。詳細については、[v-el](/api/directives.html#v-el) を参照してください。

### Meta properties

`v-repeat` によって作成されたインスタンスは、いくつかのメタプロパティ (Meta Property) も持っています。例えば `vm.$index` 、`vm.$key` そして `vm.$value` 。詳細については、[リスト表示](/guide/list.html) を参照してください。
