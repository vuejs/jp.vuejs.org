title: Displaying a List
type: guide
order: 5
---

ViewModel 上のオブジェクトの配列に基づき、テンプレート要素を繰り返すために、`v-repeat` directive を利用することができます。
`v-repeat` directive は、配列内の各オブジェクトを `$data` オブジェクトとして利用し、子の Vue インスタンスを作成します。それらの子インスタンスは親の全データを継承しているので、繰り返された要素内では、繰り返されたインスタンスと親インスタンス双方のプロパティにアクセスできます。加えて、レンダリングされたインスタンスの配列インデックスに対応する `$index` プロパティにもアクセスすることができます。

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

## プリミティブ値の配列

プリミティブ値を含む配列では、単純に `$value` として値にアクセスできます。

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

## 識別子の利用

親スコープへの不明確なフォールバックよりは、もっと明確に変数を指定したい場合が多々あるでしょう。それを行うには、繰り返されるアイテムの識別子として、 `v-repeat` に引数を指定して下さい。

``` html
<ul id="users">
  <!--これを "for each user in users" とみなす -->
  <li v-repeat="user: users">
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

## Mutation Methods

内部的に、Vue.js は監視対象の配列のミューテーションメソッド (`push()`, `pop()`, `shift()`, `unshift()`, `splice()`, `sort()` 及び `reverse()`) を横取りし、ビューの更新を引き起こします。

``` js
// この結果、DOM が更新される
demo.items.unshift({ childMsg: 'Baz' })
demo.items.pop()
```

## Augmented Methods

Vue.js は配列の監視を、 `$set()` と `$remove()` の２つの便利なメソッドで補います。

データバインドされた配列に対して、直接インデックスを指定して要素を設定するのは避けて下さい。これは、 Vue.js によって変更を感知できなくなってしまうためです。代わりに、augmented method の `$set()` を利用して下さい。

``` js
// `demo.items[0] = ...` と同様だが、ビューの更新が実行される
demo.items.$set(0, { childMsg: 'Changed!'})
```

`$remove()` は単なる `splice()` へのシンタックスシュガーです。引数で指定されたインデックスの要素を削除します。引数が数値でない場合、 `$remove()` は配列内をその値で検索し、最初に見つかった要素を削除します。

``` js
// インデックスが0のアイテムを削除
demo.items.$remove(0)
```

## 配列の置き換え

Non-mutating method（例： `filter()`, `concat()` または `slice()` ）を使う場合、返却される配列は異なるインスタンスになります。このケースでは、古い配列を新しいものと置き換えることが出来ます。

``` js
demo.items = demo.items.filter(function (item) {
  return item.childMsg.match(/Hello/)
})
```

この操作により、既存の DOM を消し飛ばし、すべてが再構築されてしまうのではないかと思うかもしれませんが、その心配はありません。Vue.js は、既に配列に関連付けられた Vue インスタンスがあれば認識し、それらのインスタンスを可能な限り再利用します。

## `track-by` の利用

いくつかのケースで、完全に新しいオブジェクトで配列を置き換える必要があるかもしれません（例えば、API コールから返されたオブジェクトなど）。もし、データオブジェクトがユニークな ID プロパティを持っているのであれば、同一 ID を持つデータに基づく既存のインスタンスを再利用するための Vue.js へのヒントとして、`track-by` 属性を利用することができます。

例として、もし data がこのようであるならば：

``` js
{
  items: [
    { _uid: 88f869d, ... },
    { _uid: 7496c10, ... }
  ]
}
```

このようにヒントを与えることができます：

``` html
<div v-repeat="items" track-by="_uid">
  <!-- 内容 -->
</div>
```

## オブジェクトをイテレーションする

オブジェクトのプロパティに対して、 `v-repeat` を使ってイテレーションすることができます。それぞれの繰り返されたインスタンスは `$key` という特別なプロパティを持ちます。また、プリミティブ値に対しては、配列と同様に、`$value` を取得することができます。

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

<p class="tip">ECMAScript 5 では、オブジェクトに対して新たなプロパティが追加もしくは削除されたことを感知する方法がありません。これに対処する為、監視対象のオブジェクトを `$add(key, value)` と `$delete(key)` の２つのメソッドを使って補います。期待したビューの更新を実行しつつ、監視対象のオブジェクトのプロパティを追加・削除するために、これらのメソッドを利用することが出来ます。
</p>


## 範囲のイテレーション

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
});
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

オリジナルのデータに対して変更やリセットをせずに、フィルタリングやソートされた配列を表示のみ行いたい場合が時々あります。Vue は、そのような用途でシンプルに使えるよう、`filterBy` と `orderBy` という組み込みのフィルタを提供しています。詳しくはそれらの [documentations](/api/filters.html#filterBy) を参照してください。


次は [Listening for Events](/guide/events.html) です。