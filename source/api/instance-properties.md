title: インスタンスプロパティ
type: api
order: 3
---

### vm.$el

- **Type:** `HTMLElement`
- **Read only**

Vue インスタンスが管理している DOM 要素。

### vm.$data

- **Type:** `Object`

Vue インスタンスがオブザーブしているデータオブジェクト。新しいオブジェクトでスワップできます。Vue インスタンスプロキシはデータオブジェクトのプロパティにアクセスします。

### vm.$options

- **Type:** `Object`

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

- **Type:** `Vue`
- **Read only**

もし現在のインスタンスが1つ持つ場合は親のインスタンス。

### vm.$root

- **Type:** `Vue`
- **Read only**

現在のコンポーネントツリーのルート Vue インスタンス。もし現在のインスタンスが親ではない場合、この値はそれ自身でしょう。

### vm.$

- **Type:** `Object`
- **Read only**

`v-ref` で登録した子コンポーネントを保持するオブジェクト。詳細については、[v-ref](/api/directives.html#v-ref) を参照してください。

### vm.$$

- **Type:** `Object`
- **Read only**

`v-el` で登録した DOM 要素を保持するオブジェクト。詳細については、[v-el](/api/directives.html#v-el) を参照してください。

### メタプロパティ

`v-repeat` によって作成されたインスタンスは、いくつかのメタプロパティも持っています。例えば `vm.$index` 、`vm.$key` そして `vm.$value` 。詳細については、[the guide on using `v-repeat`](/guide/list.html) を参照してください。
