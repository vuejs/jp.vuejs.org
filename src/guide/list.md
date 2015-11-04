---
title: リストレンダリング
type: guide
order: 8
---

## v-for

私達は配列に基づいて、アイテムのリストをレンダリングするために、`v-for` ディレクティブを使用することができます。`v-for` ディレクティブは `item in items` の形式で特別な構文を要求し、`items` はソースデータの配列で、`item` は配列要素がその上で反復されている**エイリアス**です:

**例:**

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

**結果:**

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
  },
  watch: {
    items: function () {
      smoothScroll.animateScroll(null, '#example-1')
    }
  }
})
</script>
{% endraw %}

`v-for` ブロック内では、私達が親スコープのプロパティへ完全なアクセスに加えて、恐らく推測しているとおり、現在のアイテムに対する配列のインデックスである特別な変数 `$index` を持っています:

``` html
<ul id="example-2">
  <li v-for="item in items">
    {{ parentMessage }} - {{ $index }} - {{ item.message }}
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

**結果:**

{% raw%}
<ul id="example-2" class="demo">
  <li v-for="item in items">
    {{ parentMessage }} - {{ $index }} - {{ item.message }}
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
  },
  watch: {
    items: function () {
      smoothScroll.animateScroll(null, '#example-2')
    }
  }
})
</script>
{% endraw %}

あるいは、インデックス(または、オブジェクト使用されている場合はキー)に対してエイリアスを指定することもできます:

``` html
<div v-for="(index, item) in items">
  {{ index }} {{ item.message }}
</div>
```

## テンプレートでの v-for

テンプレート `v-if` と同様、複数の要素のブロックをレンダリングするために `v-for` で `<template>` タグも使用することができます。例えば:

``` html
<ul>
  <template v-for="item in items">
    <li>{{ item.msg }}</li>
    <li class="divider"></li>
  </template>
</ul>
```

## 配列の変化を検出

### 変更メソッド

Vue.js は View の更新もトリガするために、監視された配列の変更メソッドをラップ (wrap) します。ラップされたメソッドは次のとおりです:

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

これは、Vue.js が既存の DOM を捨てて、リスト全体を再レンダリングの原因になると思うかもしれません。幸いにもそれはそうではありません。Vue.js は DOM 要素の再利用を最大化するためにいくつかのスマートなヒューリスティックを実装しているので、重複するオブジェクトを含んでいる他の配列を配列で置き換えることは、とても効率的な作業です。

### track-by

いくつかのケースで、完全に新しいオブジェクトで配列を置き換える必要があるかもしれません（例えば、API コールから作成されたオブジェクトなど）。デフォルトでは、`v-for` は既存のスコープとそのデータオブジェクトの識別情報を追跡することによって、DOM 要素の再利用性を決定するので、リスト全体が再レンダリングされる可能性があります。しかしながら、もし、各データオブジェクトがユニークな ID プロパティを持っているのであれば、できるだけ多くのインスタンスを再利用するための Vue.js へのヒントとして、`track-by` 特別な属性を利用することができます。

例として、もし data がこのようであるならば:

``` js
{
  items: [
    { _uid: '88f869d', ... },
    { _uid: '7496c10', ... }
  ]
}
```

このようにヒントを与えることができます:

``` html
<div v-for="item in items" track-by="_uid">
  <!-- content -->
</div>
```

後で、`items` 配列を置き換え、そして Vue.js は `_uid: '88f869d'` を持つ新しいオブジェクトを検出するとき、同じ `_uid` と関連する既存スコープと DOM 要素を再利用することができます。

### track-by $index

追跡するためにユニークなキーを持っていない場合、`track-by="$index"` も利用できます。これは、`v-for` を in-place 更新モードに強制します。フラグメントはもはや並べ替えておらず、それらは単純に対応するインデックスに新しい値でフラッシュして取得します。このモードはソースとなる配列に重複する値を扱うことができます。

これは配列の置き換えは非常に効率的にできますが、トレードオフもあります。なぜなら、DOM ノードはもはや順序の変更を反映するように移動されていないため、DOM 入力値とコンポーネントのプライベートな状態のような一時的な状態は同期できないです。このため、`v-for` ブロックが input 要素または子コンポーネントから含まれている場合は、`track-by="$index"` を使用するとき注意してください。

### 注意事項

JavaScript の制限のため、Vue.js は配列で以下の変更を検出することは**できません**:

1. インデックスでアイテムを直接設定するとき。例: `vm.items[0] = {}`
2. 配列の長さを変更するとき。例: `vm.items.length = 0`

上記の注意事項 (1) に対処するため、Vue.js は監視された配列を `$set()` メソッドで拡張します:

``` js
// `example1.items[0] ...` と同じであるが、View の更新をトリガする
example1.items.$set(0, { childMsg: 'Changed!'})
```

上記の注意事項 (2) に対処するため、代わりに空の配列で `items` を置き換えてください。

`$set()` に加えて、Vue.js は配列を便利なメソッド `$remove()` で拡張し、そのメソッドは、検索し、そして内部では `splice()` を呼びだすことによって対象の配列からアイテムを削除します。そういうわけで代わりは:

``` js
var index = this.items.indexOf(item)
if (index !== -1) {
  this.items.splice(index, 1)
}
```

というようになり、これと同じことをこのように行うことができます:

``` js
this.items.$remove(item)
```

## オブジェクトの v-for

オブジェクトのプロパティに対して、`v-for` を使って反復処理することができます。`$index` に加えて、それぞれのスコープは `$key` という特別なプロパティにアクセスします。

``` html
<ul id="repeat-object" class="demo">
  <li v-for="value in object">
    {{ $key }} : {{ value }}
  </li>
</ul>
```

``` js
new Vue({
  el: '#repeat-object',
  data: {
    object: {
      FirstName: 'John',
      LastName: 'Doe',
      Age: 30
    }
  }
})
```

**結果:**

{% raw %}
<ul id="repeat-object" class="demo">
  <li v-for="value in object">
    {{ $key }} : {{ value }}
  </li>
</ul>

<script>
new Vue({
  el: '#repeat-object',
  data: {
    object: {
      FirstName: 'John',
      LastName: 'Doe',
      Age: 30
    }
  }
})
</script>
{% endraw %}

キーに対してエイリアスも提供できます:

``` html
<div v-for="(key, val) in object">
  {{ key }} {{ val }}
</div>
```

<p class="tip">オブジェクトを反復処理するとき、順序は `Object.keys()` の列挙順のキーに基づいており、全ての JavaScript エンジンの実装で一貫性が保証されて**いません**。</p>

## 範囲の v-for

`v-for` は整数値を取ることも出来ます。このケースでは、指定された数だけテンプレートが繰り返されます。

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

## フィルタ/ソートされた結果の表示

時どき、私達は実際に変更するかまたは元のデータをリセットせずに配列フィルタリングやソートされたバージョンの配列を表示する必要があります。これを達成するに2つのオプションがあります:

1. フィルタまたはソートされた配列を返す算出プロパティを作成する
2. 組み込み `filterBy` そして `orderBy` されたフィルタを使用する

それは完全な JavaScript であるため、算出プロパティはあなたにより細かい制御と柔軟性を与えますが、フィルタは共通ユースケースに対してより便利にすることができます。配列フィルタの詳細な使用方法については、それらの[ドキュメント](/api/#filterBy)をチェックしてください。
