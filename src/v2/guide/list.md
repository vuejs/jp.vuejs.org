---
title: リストレンダリング
updated: 2019-05-08
type: guide
order: 8
---

<div class="vueschool"><a href="https://vueschool.io/lessons/vuejs-loops?friend=vuejs" target="_blank" rel="sponsored noopener" title="Learn how to render lists on Vue School">Learn how to render list with a free Vue School lesson</a></div>

## `v-for` で配列に要素をマッピングする

配列に基づいて、アイテムのリストを描画するために、`v-for` ディレクティブを使用することができます。`v-for` ディレクティブは `item in items` の形式で特別な構文を要求し、`items` はソースデータの配列で、`item` は配列要素がその上で反復されている**エイリアス**です:

``` html
<ul id="example-1">
  <li v-for="item in items">
    {{ item.message }}
  </li>
</ul>
```

``` js
var example1 = new Vue({
  el: '#example-1',
  data: {
    items: [
      { message: 'Foo' },
      { message: 'Bar' }
    ]
  }
})
```

結果:

{% raw %}
<ul id="example-1" class="demo">
  <li v-for="item in items">
    {{item.message}}
  </li>
</ul>
<script>
var example1 = new Vue({
  el: '#example-1',
  data: {
    items: [
      { message: 'Foo' },
      { message: 'Bar' }
    ]
  }
})
</script>
{% endraw %}

`v-for` ブロック内では、親スコープのプロパティへの完全なアクセスを持っています。また `v-for` は現在のアイテムに対する配列のインデックスを、任意の2つ目の引数としてサポートしています。

``` html
<ul id="example-2">
  <li v-for="(item, index) in items">
    {{ parentMessage }} - {{ index }} - {{ item.message }}
  </li>
</ul>
```

``` js
var example2 = new Vue({
  el: '#example-2',
  data: {
    parentMessage: 'Parent',
    items: [
      { message: 'Foo' },
      { message: 'Bar' }
    ]
  }
})
```

結果:

{% raw%}
<ul id="example-2" class="demo">
  <li v-for="(item, index) in items">
    {{ parentMessage }} - {{ index }} - {{ item.message }}
  </li>
</ul>
<script>
var example2 = new Vue({
  el: '#example-2',
  data: {
    parentMessage: 'Parent',
    items: [
      { message: 'Foo' },
      { message: 'Bar' }
    ]
  }
})
</script>
{% endraw %}

また、区切り文字として `in` の代わりに `of` を使用することができます。これは JavaScript のイテレータ構文に近いものです:

``` html
<div v-for="item of items"></div>
```

## オブジェクトの `v-for`

オブジェクトのプロパティに対して、`v-for` を使って反復処理することができます。

``` html
<ul id="v-for-object" class="demo">
  <li v-for="value in object">
    {{ value }}
  </li>
</ul>
```

``` js
new Vue({
  el: '#v-for-object',
  data: {
    object: {
      title: 'How to do lists in Vue',
      author: 'Jane Doe',
      publishedAt: '2016-04-10'
    }
  }
})
```

結果:

{% raw %}
<ul id="v-for-object" class="demo">
  <li v-for="value in object">
    {{ value }}
  </li>
</ul>
<script>
new Vue({
  el: '#v-for-object',
  data: {
    object: {
      title: 'How to do lists in Vue',
      author: 'Jane Doe',
      publishedAt: '2016-04-10'
    }
  }
})
</script>
{% endraw %}

2 つ目の引数としてプロパティ名（すなわちキー）も提供できます:

``` html
<div v-for="(value, name) in object">
  {{ name }}: {{ value }}
</div>
```

{% raw %}
<div id="v-for-object-value-name" class="demo">
  <div v-for="(value, name) in object">
    {{ name }}: {{ value }}
  </div>
</div>
<script>
new Vue({
  el: '#v-for-object-value-name',
  data: {
    object: {
      title: 'How to do lists in Vue',
      author: 'Jane Doe',
      publishedAt: '2016-04-10'
    }
  }
})
</script>
{% endraw %}

index も提供できます:

``` html
<div v-for="(value, name, index) in object">
  {{ index }}. {{ name }}: {{ value }}
</div>
```

{% raw %}
<div id="v-for-object-value-name-index" class="demo">
  <div v-for="(value, name, index) in object">
    {{ index }}. {{ name }}: {{ value }}
  </div>
</div>
<script>
new Vue({
  el: '#v-for-object-value-name-index',
  data: {
    object: {
      title: 'How to do lists in Vue',
      author: 'Jane Doe',
      publishedAt: '2016-04-10'
    }
  }
})
</script>
{% endraw %}

<p class="tip">オブジェクトを反復処理するとき、順序は `Object.keys()` の列挙順のキーに基づいており、全ての JavaScript エンジンの実装で一貫性が保証されて**いません**。</p>

## 状態の維持

Vue が `v-for` で描画された要素のリストを更新する際、標準では "その場でパッチを適用する" (in-place patch) 戦略が用いられます。データのアイテムの順序が変更された場合、アイテムの順序に合わせて DOM 要素を移動する代わりに、 Vue は各要素にその場でパッチを適用して、その特定のインデックスに何を描画するべきかを確実に反映します。これは Vue 1.x にあった機能の `track-by="$index"` に似たものです。

この標準のモードは効率がいいです。しかしこれは、**描画されたリストが子コンポーネントの状態や、一時的な DOM の状態に依存していないときにだけ適しています (例: フォームのインプットの値)**。

Vue が各ノードの識別情報を追跡できるヒントを与えるために、また、先ほど説明したような既存の要素の再利用と並び替えができるように、一意な `key` 属性を全てのアイテムに与える必要があります:

``` html
<div v-for="item in items" v-bind:key="item.id">
  <!-- content -->
</div>
```

繰り返される DOM の内容が単純な場合や、性能向上のために標準の動作に意図的に頼る場合を除いて、可能なときはいつでも `v-for` に `key` 属性を与えることが推奨されます。

これは Vue がノードを識別する汎用的な仕組みなので、`key` はガイドの後半でわかるように `v-for` に縛られない他の用途もあります。

<p class="tip">オブジェクトや配列のような非プリミティブ値を `v-for` のキーとして使わないでください。代わりに、文字列や数値を使ってください。</p>

`key` 属性の詳細な使い方は、[`key` API ドキュメント](https://jp.vuejs.org/v2/api/#key) を参照してください。

## 配列の変化を検出

### 変更メソッド

Vue は画面の更新もトリガするために、監視された配列の変更メソッドを抱合 (wrap) します。抱合されたメソッドは次のとおりです:

- `push()`
- `pop()`
- `shift()`
- `unshift()`
- `splice()`
- `sort()`
- `reverse()`

コンソールを開いて前の `items` 配列の例で変更メソッドを呼び出して遊んでみてください。例えば `example1.items.push({ message: 'Baz' })` のようにしてみましょう。

### 配列の置き換え

変更メソッドは、名前が示唆するように、それらが呼ばれると元の配列を変更します。変更しないメソッドもあります。例えば、`filter()`、`concat()`、そして`slice()` のような、元の配列を変更しませんが、**常に新しい配列を返します**。変更しないメソッドで動作するとき、新しいもので古い配列を置き換えます:

``` js
example1.items = example1.items.filter(function (item) {
  return item.message.match(/Foo/)
})
```

これは、Vue が既存の DOM を捨てて、リスト全体を再描画の原因になると思うかもしれません。幸いにもそれはそうではありません。Vue は DOM 要素の再利用を最大化するためにいくつかのスマートなヒューリスティックを実装しているので、重複するオブジェクトを含んでいる他の配列を配列で置き換えることは、とても効率的な作業です。

### 注意事項

JavaScript の制限のため、Vue は配列で以下の変更を検出することは**できません**:

1. インデックスでアイテムを直接設定するとき。例: `vm.items[indexOfItem] = newValue`
2. 配列の長さを変更するとき。例: `vm.items.length = newLength`

例:

``` js
var vm = new Vue({
  data: {
    items: ['a', 'b', 'c']
  }
})
vm.items[1] = 'x' // リアクティブではありません
vm.items.length = 2 // リアクティブではありません
```

上記の注意事項 1 に対処するため、以下のどちらも `vm.items[indexOfItem] = newValue` と同じ動作になりますが、リアクティブなシステム内で状態の更新をトリガします。

``` js
// Vue.set
Vue.set(vm.items, indexOfItem, newValue)
```
``` js
// Array.prototype.splice
vm.items.splice(indexOfItem, 1, newValue)
```

[`vm.$set`](https://jp.vuejs.org/v2/api/#vm-set) インスタンスメソッドを使用することもできます。これはグローバル  `Vue.set` のエイリアスです:

``` js
vm.$set(vm.items, indexOfItem, newValue)
```

上記の注意事項 2 に対処するためにも `splice` を使います:

``` js
vm.items.splice(newLength)
```

## オブジェクトの変更検出の注意

再度になりますが、現代の JavaScript の制約のため、**Vue はプロパティの追加や削除を検出することはできません**。 例:

``` js
var vm = new Vue({
  data: {
    a: 1
  }
})
// `vm.a` はリアクティブです

vm.b = 2
// `vm.b` はリアクティブではありません
```

Vue はすでに作成されたインスタンスに新しいルートレベルのリアクティブプロパティを動的に追加することはできません。しかし、`Vue.set（object、propertyName、value）` メソッドを使ってネストされたオブジェクトにリアクティブなプロパティを追加することは可能です。例を挙げると：

``` js
var vm = new Vue({
  data: {
    userProfile: {
      name: 'Anika'
    }
  }
})
```

ネストされた `userProfile` オブジェクトに新しい `age` プロパティを追加することができます:

``` js
Vue.set(vm.userProfile, 'age', 27)
```

`vm.$set` インスタンスメソッドを使用することもできます。これはグローバル  `Vue.set` のエイリアスです:

``` js
vm.$set(vm.userProfile, 'age', 27)
```

例えば `Object.assign()` や `_.extend()` を使って既存のオブジェクトにいくつかの新しいプロパティを割り当てたいときがあります。このような場合は、両方のオブジェクトのプロパティを使用して新しいオブジェクトを作成する必要があります。 なので以下のやり方ではなくて：

``` js
Object.assign(vm.userProfile, {
  age: 27,
  favoriteColor: 'Vue Green'
})
```

新しいリアクティブプロパティをこのように追加します。

``` js
vm.userProfile = Object.assign({}, vm.userProfile, {
  age: 27,
  favoriteColor: 'Vue Green'
})
```

## フィルタ/ソートされた結果の表示

ときどき、元のデータを実際に変更またはリセットすることなしに、フィルタリングやソートされたバージョンの配列を表示したいことがあります。このケースでは、フィルタリングやソートされた配列を返す算出プロパティを作ることができます。

例えば:

``` html
<li v-for="n in evenNumbers">{{ n }}</li>
```

``` js
data: {
  numbers: [ 1, 2, 3, 4, 5 ]
},
computed: {
  evenNumbers: function () {
    return this.numbers.filter(function (number) {
      return number % 2 === 0
    })
  }
}
```

算出プロパティが使えない状況ではメソッドを使うこともできます。(例: 入れ子になった `v-for` のループの中):

``` html
<li v-for="n in even(numbers)">{{ n }}</li>
```

``` js
data: {
  numbers: [ 1, 2, 3, 4, 5 ]
},
methods: {
  even: function (numbers) {
    return numbers.filter(function (number) {
      return number % 2 === 0
    })
  }
}
```

## 範囲付き `v-for`

`v-for` は整数値を取ることもできます。このケースでは、指定された数だけテンプレートが繰り返されます。

``` html
<div>
  <span v-for="n in 10">{{ n }} </span>
</div>
```

結果:

{% raw %}
<div id="range" class="demo">
  <span v-for="n in 10">{{ n }} </span>
</div>
<script>
  new Vue({ el: '#range' })
</script>
{% endraw %}

## `<template>` での `v-for`

テンプレート `v-if` と同様に、複数の要素のブロックをレンダリングするために、 ` v-for` で `<template>` タグを使うこともできます。例：

``` html
<ul>
  <template v-for="item in items">
    <li>{{ item.msg }}</li>
    <li class="divider" role="presentation"></li>
  </template>
</ul>
```

## `v-for` と `v-if`

<p class="tip">`v-if` と `v-for` を同時に利用することは **推奨されません**。 詳細については [スタイルガイド](/v2/style-guide/#v-for-と一緒に-v-if-を使うのを避ける-必須) を参照ください。</p>

それらが同じノードに存在するとき、 `v-for` は `v-if` よりも高い優先度を持ちます。これは `v-if` がループの各繰り返しで実行されることを意味します。以下のように、これは_いくつかの_項目のみのノードを描画する場合に便利です。

``` html
<li v-for="todo in todos" v-if="!todo.isComplete">
  {{ todo }}
</li>
```

上記は、完了していない項目だけを描画します。

代わりに、ループの実行を条件付きでスキップすることを目的にしている場合は、ラッパー(wrapper) 要素 (または [`<template>`](conditional.html#テンプレートでの-v-if-による条件グループ))上で `v-if` に置き換えます。例えば:

``` html
<ul v-if="todos.length">
  <li v-for="todo in todos">
    {{ todo }}
  </li>
</ul>
<p v-else>No todos left!</p>
```

## コンポーネントと `v-for`

> このセクションでは、[コンポーネント](components.html)についての知識を前提としています。もし分からなければ、このセクションを遠慮なく飛ばして、理解した後に戻ってきてください。

普通の要素のように、カスタムコンポーネントで直接 `v-for` を使うことができます:

``` html
<my-component v-for="item in items" :key="item.id"></my-component>
```

> 2.2.0 以降で、コンポーネントで `v-for` を使用するとき、[`key`](list.html#key) は必須です

しかしながら、これはいかなるデータもコンポーネントへ自動的に渡すことはありません。なぜなら、コンポーネントはコンポーネント自身の隔離されたスコープを持っているからです。反復してデータをコンポーネントに渡すためには、プロパティを使うべきです:

``` html
<my-component
  v-for="(item, index) in items"
  v-bind:item="item"
  v-bind:index="index"
  v-bind:key="item.id"
></my-component>
```

自動的に `item` をコンポーネントに渡さない理由は、それが `v-for` の動作と密結合になってしまうからです。どこからデータが来たのかを明確にすることが、他の場面でコンポーネントを再利用できるようにします。

これは、単純な ToDo リストの完全な例です:

``` html
<div id="todo-list-example">
  <form v-on:submit.prevent="addNewTodo">
    <label for="new-todo">Add a todo</label>
    <input
      v-model="newTodoText"
      id="new-todo"
      placeholder="E.g. Feed the cat"
    >
    <button>Add</button>
  </form>
  <ul>
    <li
      is="todo-item"
      v-for="(todo, index) in todos"
      v-bind:key="todo.id"
      v-bind:title="todo.title"
      v-on:remove="todos.splice(index, 1)"
    ></li>
  </ul>
</div>
```

<p class="tip">`is="todo-item"` 属性に注意してください。 これは DOM テンプレートでは必要で、なぜなら `<ul>` 要素の中では `<li>` のみが有効だからです。これは `<todo-item>` と同じ意味ですが、潜在的なブラウザの解析エラーを回避します。詳細は  [DOM テンプレート解析の注意事項](components.html#DOM-テンプレート解析の注意事項) を参照してください。</p>

``` js
Vue.component('todo-item', {
  template: '\
    <li>\
      {{ title }}\
      <button v-on:click="$emit(\'remove\')">Remove</button>\
    </li>\
  ',
  props: ['title']
})

new Vue({
  el: '#todo-list-example',
  data: {
    newTodoText: '',
    todos: [
      {
        id: 1,
        title: 'Do the dishes',
      },
      {
        id: 2,
        title: 'Take out the trash',
      },
      {
        id: 3,
        title: 'Mow the lawn'
      }
    ],
    nextTodoId: 4
  },
  methods: {
    addNewTodo: function () {
      this.todos.push({
        id: this.nextTodoId++,
        title: this.newTodoText
      })
      this.newTodoText = ''
    }
  }
})
```

{% raw %}
<div id="todo-list-example" class="demo">
  <form v-on:submit.prevent="addNewTodo">
    <label for="new-todo">Add a todo</label>
    <input
      v-model="newTodoText"
      id="new-todo"
      placeholder="E.g. Feed the cat"
    >
    <button>Add</button>
  </form>
  <ul>
    <li
      is="todo-item"
      v-for="(todo, index) in todos"
      v-bind:key="todo.id"
      v-bind:title="todo.title"
      v-on:remove="todos.splice(index, 1)"
    ></li>
  </ul>
</div>
<script>
Vue.component('todo-item', {
  template: '\
    <li>\
      {{ title }}\
      <button v-on:click="$emit(\'remove\')">Remove</button>\
    </li>\
  ',
  props: ['title']
})

new Vue({
  el: '#todo-list-example',
  data: {
    newTodoText: '',
    todos: [
      {
        id: 1,
        title: 'Do the dishes',
      },
      {
        id: 2,
        title: 'Take out the trash',
      },
      {
        id: 3,
        title: 'Mow the lawn'
      }
    ],
    nextTodoId: 4
  },
  methods: {
    addNewTodo: function () {
      this.todos.push({
        id: this.nextTodoId++,
        title: this.newTodoText
      })
      this.newTodoText = ''
    }
  }
})
</script>
{% endraw %}
