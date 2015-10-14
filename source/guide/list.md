title: リスト表示
type: guide
order: 5
---

ViewModel 上のオブジェクトの配列に基づき、テンプレート要素を繰り返すために、`v-repeat` ディレクティブを利用することができます。`v-repeat` ディレクティブは、配列内の各オブジェクトを `$data` オブジェクトとして利用し、子の Vue インスタンスを作成します。それらの子インスタンスは親の全データを継承しているので、繰り返された要素内では、繰り返されたインスタンスと親インスタンス双方のプロパティにアクセスできます。加えて、レンダリングされたインスタンスの配列インデックスに対応する `$index` プロパティにもアクセスすることができます。

**例:**

``` html
<ul id="demo">
  <li v-repeat="items" class="item-{{$index}}">
    {{$index}} - {{parentMsg}} {{childMsg}}
  </li>
</ul>
```

``` js
var demo = new Vue({
  el: '#demo',
  data: {
    parentMsg: 'Hello',
    items: [
      { childMsg: 'Foo' },
      { childMsg: 'Bar' }
    ]
  }
})
```

**結果:**

<ul id="demo"><li v-repeat="items" class="item-{&#123;$index&#125;}">{&#123;$index&#125;} - {&#123;parentMsg&#125;} {&#123;childMsg&#125;}</li></ul>
<script>
var demo = new Vue({
  el: '#demo',
  data: {
    parentMsg: 'Hello',
    items: [
      { childMsg: 'Foo' },
      { childMsg: 'Bar' }
    ]
  }
})
</script>

## フラグメントの繰り返し

ときどき、複数のノードのフラグメントを繰り返したいかもしれません。そのケースでは、繰り返すフラグメントをラップするために `<template>` タグを使うことができます。ここでの `<template>` タグは、単にセマンティックなラッパ(wrapper)になります。例えば:

``` html
<ul>
  <template v-repeat="list">
    <li>{{msg}}</li>
    <li class="divider"></li>
  </template>
</ul>
```

## プリミティブ値の配列

プリミティブ値を含む配列では、単純に `$value` として値にアクセスできます:

``` html
<ul id="tags">
  <li v-repeat="tags">
    {{$value}}
  </li>
</ul>
```

``` js
new Vue({
  el: '#tags',
  data: {
    tags: ['JavaScript', 'MVVM', 'Vue.js']
  }
})
```

**結果:**
<ul id="tags" class="demo"><li v-repeat="tags">{&#123;$value&#125;}</li></ul>
<script>
new Vue({
  el: '#tags',
  data: {
    tags: ['JavaScript', 'MVVM', 'Vue.js']
  }
})
</script>

## エイリアスの利用

親スコープへの不明確なフォールバックよりは、もっと明確に変数を指定したい場合が多々あるでしょう。それを行うには、繰り返されるアイテムのエイリアスとして、 `v-repeat` にエイリアスを指定して下さい:

``` html
<ul id="users">
  <li v-repeat="user in users">
    {{user.name}} - {{user.email}}
  </li>
</ul>
```

``` js
new Vue({
  el: '#users',
  data: {
    users: [
      { name: 'Foo Bar', email: 'foo@bar.com' },
      { name: 'John Doh', email: 'john@doh.com' }
    ]
  }
})
```

**結果:**
<ul id="users" class="demo"><li v-repeat="user: users">{&#123;user.name&#125;} - {&#123;user.email&#125;}</li></ul>
<script>
new Vue({
  el: '#users',
  data: {
    users: [
      { name: 'Foo Bar', email: 'foo@bar.com' },
      { name: 'John Doh', email: 'john@doh.com' }
    ]
  }
})
</script>

<p class="tip">`user in users` シンタックスは 0.12.8 以降のみ利用可能です。古いバージョンでは、`user : users` シンタックスを使わなければなりません。</p>

<p class="tip">`v-repeat` でエイリアス使用すると、一般的な結果として、テンプレートがより読みやすくてわずかに性能がよいです。</p>

## 変更メソッド

内部的に、Vue.js は監視対象の配列の変更メソッド (`push()`, `pop()`, `shift()`, `unshift()`, `splice()`, `sort()` 及び `reverse()`) を横取りし、View の更新を引き起こします。

``` js
// この結果、DOM が更新される
demo.items.unshift({ childMsg: 'Baz' })
demo.items.pop()
```

## 拡張メソッド

Vue.js は配列の監視を、 `$set()` と `$remove()` の2つの便利なメソッドで補います。

データバインドされた配列に対して、直接インデックスを指定して要素を設定するのは避けて下さい。これは、 Vue.js によって変更を感知できなくなってしまうためです。代わりに、拡張メソッドの `$set()` を利用して下さい:

``` js
// `demo.items[0] = ...` と同様だが、View の更新が実行される
demo.items.$set(0, { childMsg: 'Changed!'})
```

`$remove()` は単なる `splice()` へのシンタックスシュガーです。引数で指定されたインデックスの要素を削除します。引数が数値でない場合、 `$remove()` は配列内をその値で検索し、最初に見つかった要素を削除します。

``` js
// インデックスが0のアイテムを削除
demo.items.$remove(0)
```

## 配列の置き換え

無変更メソッド (例:`filter()`, `concat()` または `slice()`) を使う場合、返却される配列は異なるインスタンスになります。このケースでは、古い配列を新しいものと置き換えることが出来ます:

``` js
demo.items = demo.items.filter(function (item) {
  return item.childMsg.match(/Hello/)
})
```

この操作により、既存の DOM を消し飛ばし、すべてが再構築されてしまうのではないかと思うかもしれませんが、その心配はありません。Vue.js は、既に配列に関連付けられた Vue インスタンスがあれば認識し、それらのインスタンスを可能な限り再利用します。

## `track-by` の利用

いくつかのケースで、完全に新しいオブジェクトで配列を置き換える必要があるかもしれません（例えば、API コールから返されたオブジェクトなど）。デフォルトでは、`v-repeat` は既存の子インスタンスとそのデータオブジェクトの識別情報を追跡することによって、DOM ノードの再利用性を決定するので、リスト全体が再レンダリングされる可能性があります。しかしながら、もし、各データオブジェクトがユニークな ID プロパティを持っているのであれば、できるだけ多くのインスタンスを再利用するための Vue.js へのヒントとして、`track-by` パラメータを利用することができます。

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
<div v-repeat="items" track-by="_uid">
  <!-- 内容 -->
</div>
```

後で、`items` 配列を置き換え、そして Vue.js は `_uid: '88f869d'` を持つ新しいオブジェクトを検出するとき、同じ `_uid` で既存インスタンス再利用することができます。もし、追跡する一意なキーを持っていない場合、`track-by=$index` を使用することができます。しかしながら、これは用心深く使用するようにしてください。なぜなら、`$index` で追跡しているとき、子インスタンスと DOM ノードを移動する代わりに、Vue は単にそれらが最初に作成された順序でそれらの場所に再利用します。`track-by="$index"` は2つの状況で使用を回避してください。繰り返されたブロックにリストを再描画するために使用することができる form の input を含んでいるとき、または、繰り返されるデータがそれに割り当てられる他に、可変な状態のコンポーネントを繰り返しているときです。

<p class="tip">`track-by` 属性は使用すると、完全に新しいデータを使用して大きい`v-repeat`リストを再描画するときに、性能を大いによくすることができます。</p>

## オブジェクトの反復処理

オブジェクトのプロパティに対して、 `v-repeat` を使って反復処理することができます。それぞれの繰り返されたインスタンスは `$key` という特別なプロパティを持ちます。また、プリミティブ値に対しては、配列と同様に、`$value` を取得することができます。

``` html
<ul id="repeat-object">
  <li v-repeat="primitiveValues">{{$key}} : {{$value}}</li>
  <li>===</li>
  <li v-repeat="objectValues">{{$key}} : {{msg}}</li>
</ul>
```

``` js
new Vue({
  el: '#repeat-object',
  data: {
    primitiveValues: {
      FirstName: 'John',
      LastName: 'Doe',
      Age: 30
    },
    objectValues: {
      one: {
        msg: 'Hello'
      },
      two: {
        msg: 'Bye'
      }
    }
  }
})
```

**結果:**
<ul id="repeat-object" class="demo"><li v-repeat="primitiveValues">{&#123;$key&#125;} : {&#123;$value&#125;}</li><li>===</li><li v-repeat="objectValues">{&#123;$key&#125;} : {&#123;msg&#125;}</li></ul>
<script>
new Vue({
  el: '#repeat-object',
  data: {
    primitiveValues: {
      FirstName: 'John',
      LastName: 'Doe',
      Age: 30
    },
    objectValues: {
      one: {
        msg: 'Hello'
      },
      two: {
        msg: 'Bye'
      }
    }
  }
})
</script>

<p class="tip">ECMAScript 5 では、オブジェクトに対して新たなプロパティが追加もしくは削除されたことを感知する方法がありません。これに対処する為、監視対象のオブジェクトを `$add(key, value)` 、`$set(key, value)` そして `$delete(key)` の3つのメソッドを使って補います。期待したビューの更新を実行しつつ、監視対象のオブジェクトのプロパティを追加・削除するために、これらのメソッドを利用することが出来ます。`$add` と `$set` との違いは、`$add` はもしオブジェクトにキーが既に存在している場合は、すぐにリターンして、`obj.$add(key)` を呼び出しただけでは、`undefined` で既存の値を上書きしません。
</p>

## 範囲の反復処理

`v-repeat` は整数値を取ることも出来ます。このケースでは、指定された数だけテンプレートが繰り返されます。

``` html
<div id="range">
    <div v-repeat="val">Hi! {{$index}}</div>
</div>
```

``` js
new Vue({
  el: '#range',
  data: {
    val: 3
  }
})
```
**結果:**
<ul id="range" class="demo"><li v-repeat="val">Hi! {&#123;$index&#125;}</li></ul>
<script>
new Vue({
  el: '#range',
  data: { val: 3 }
});
</script>

## 配列のフィルタ

オリジナルのデータに対して変更やリセットをせずに、フィルタリングやソートされた配列を表示のみ行いたい場合が時々あります。Vue は、そのような用途でシンプルに使えるよう、`filterBy` と `orderBy` という組み込みのフィルタを提供しています。詳しくはそれらの[ドキュメント](/api/filters.html#filterBy)を参照してください。

次: [イベントのリスニング](/guide/events.html)
