---
title: Vue インスタンス
updated: 2020-09-07
type: guide
order: 3
---

## Vue インスタンスの作成

全ての Vue アプリケーション は、`Vue` 関数で新しい **Vue インスタンス**を作成することによって起動されます。

```js
var vm = new Vue({
  // オプション
})
```

Vue のデザインは、[MVVM パターン](https://ja.wikipedia.org/wiki/Model_View_ViewModel)と厳密には関連が無いものの、部分的には影響を受けています。慣例として、 `vm` (ViewModel の略) を Vue インスタンスの変数名としてよく使います。

Vue インスタンスを生成するには、**オプションオブジェクト**を渡します。このガイドの大部分では、これらのオプションを使用して望んだ挙動にするための方法について説明しています。参考までに、全てのオプションの一覧は[API リファレンス](../api/#オプション-データ)で参照できます。

Vue アプリケーションは、 `new Vue` で作成された**ルート Vue インスタンス(root Vue instance)**で構成され、必要に応じてネストされたツリーや再利用可能なコンポーネントで形成されます。例えば、Todo アプリのコンポーネントツリーは次のようになります。

```
Root Instance
└─ TodoList
   ├─ TodoItem
   │  ├─ TodoButtonDelete
   │  └─ TodoButtonEdit
   └─ TodoListFooter
      ├─ TodosButtonClear
      └─ TodoListStatistics
```

[コンポーネントシステム](components.html) については後ほど詳細を説明します。今は、全ての Vue コンポーネントは Vue インスタンスで、同じオプションオブジェクトを受け入れる(いくつかのルート特有のオプションを除く)と理解しておけば十分です。

## データとメソッド

Vue インスタンスが作成されると、自身の `data` オブジェクトの全てのプロパティを**リアクティブシステム**に追加します。これらのプロパティの値を変更すると、ビューが"反応"し、新しい値に一致するように更新します。

```js
// データオブジェクト
var data = { a: 1 }

// Vue インスタンスにオブジェクトを追加する
var vm = new Vue({
  data: data
})

// インスタンスのプロパティを取得すると、
// 元のデータからそのプロパティが返されます
vm.a == data.a // => true

// プロパティへの代入は、元のデータにも反映されます
vm.a = 2
data.a // => 2

// ... そして、その逆もまたしかりです
data.a = 3
vm.a // => 3
```

このデータを変更すると、ビューが再レンダリングされます。`data`のプロパティは、インスタンスが作成されたときに存在していた場合にのみ**リアクティブ**です。 つまり、以下のように新しいプロパティを追加する場合、

```js
vm.b = 'hi'
```

その後、 `b` への変更はビューの更新を引き起こさないでしょう。 後でプロパティが必要になることがわかっているならば、空でも存在しない場合でも初期値を設定するだけで済みます。 例：

```js
data: {
  newTodoText: '',
  visitCount: 0,
  hideCompletedTodos: false,
  todos: [],
  error: null
}
```

これに対する唯一の例外は、既存のプロパティの変更を防ぐ `Object.freeze（）`の使用です。これはリアクティブシステムが変更を *追跡* することができないことも意味します。

```js
var obj = {
  foo: 'bar'
}

Object.freeze(obj)

new Vue({
  el: '#app',
  data: obj
})
```

```html
<div id="app">
  <p>{{ foo }}</p>
  <!-- これは `foo` を更新しなくなります! -->
  <button v-on:click="foo = 'baz'">Change it</button>
</div>
```

data プロパティに加えて、Vue インスタンスは、いくつかの便利なプロパティとメソッドを持っています。これらはユーザ定義のプロパティと区別するために、頭に `$` が付けられています。 例：

```js
var data = { a: 1 }
var vm = new Vue({
  el: '#example',
  data: data
})

vm.$data === data // => true
vm.$el === document.getElementById('example') // => true

// $watch はインスタンスメソッドです
vm.$watch('a', function (newValue, oldValue) {
   // このコールバックは `vm.a` の値が変わる時に呼ばれます
})
```

将来的には、インスタンスのプロパティとメソッドの完全なリストについては、 [API リファレンス](../api/#インスタンスプロパティ) を参照してください。

## インスタンスライフサイクルフック

<div class="vueschool"><a href="https://vueschool.io/lessons/understanding-the-vuejs-lifecycle-hooks?friend=vuejs" target="_blank" rel="sponsored noopener" title="Free Vue.js Lifecycle Hooks Lesson">Vue School で無料の動画レッスンを見る</a></div>

各 Vue インスタンスは、生成時に一連の初期化を行います。例えば、データの監視のセットアップやテンプレートのコンパイル、DOM へのインスタンスのマウント、データが変化したときの DOM の更新などがあります。その初期化の過程で、特定の段階でユーザー自身のコードを追加する、いくつかの **ライフサイクルフック(lifecycle hooks)** と呼ばれる関数を実行します。

例えば、[`created`](../api/#created) フックはインスタンスが生成された後にコードを実行したいときに使われます。

```js
new Vue({
  data: {
    a: 1
  },
  created: function () {
    // `this` は vm インスタンスを指します
    console.log('a is: ' + this.a)
  }
})
// => "a is: 1"
```

この他にもインスタンスのライフサイクルの様々な段階で呼ばれるフックがあります。例えば、[`mounted`](../api/#mounted)、 [`updated`](../api/#updated)、そして [`destroyed`](../api/#destroyed) などがあります。全てのライフサイクルフックは、`this` が Vue インスタンスを指す形で実行されます。

<p class="tip">インスタンスプロパティまたはコールバックで[アロー関数](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Functions/Arrow_functions) を使用しないでください。例えば、 `created: () => console.log(this.a)` や `vm.$watch('a', newValue => this.myMethod())` です。アロー関数は `this` をもたないため、`this` は他の変数と同様に見つかるまで親スコープをレキシカルに探索され、そしてしばしば、`Uncaught TypeError: Cannot read property of undefined` または `Uncaught TypeError: this.myMethod is not a function` のようなエラーが発生します。</p>

## ライフサイクルダイアグラム

以下は、インスタンスライフサイクルのダイアグラムです。
今はこのダイアグラムを完全に理解する必要はありませんが、将来役に立つことでしょう。

![The Vue Instance Lifecycle](/images/lifecycle.png)
