title: Methods and Event Handling
type: guide
order: 6
---

イベントリスナを DOM イベントにバインドするために、`v-on` ディレクティブを利用することができます。`v-on` は、イベントハンドラ関数（関数呼び出しのための括弧は不要）と、インライン expression のどちらにもバインドすることができます。ハンドラ関数が提供されている場合には、オリジナルの DOM イベントを引数として取得します。イベントには、イベントが発生した特定の ViewModel を指す特別なプロパティ `targetVM` が付随します:

``` html
<div id="demo">
  <a v-on="click: onClick">Trigger a handler</a>
  <a v-on="click: n++">Trigger an expression</a>
</div>
```

``` js
new Vue({
  el: '#demo',
  data: {
    n: 0
  },
  methods: {
    onClick: function (e) {
      console.log(e.target.tagName) // "A"
      console.log(e.targetVM === this) // true
    }
  }
})
```

## Expression によるハンドラの呼び出し

たくさんの子 ViewModel を生成する `v-repeat` と、`v-on` を同時に利用している時には `targetVM` が便利です。しかしながら、現在反復されているデータオブジェクトと等しい現在のエイリアスを渡す呼び出し expression を使うほうがより便利で明示的でしょう:

``` html
<ul id="list">
  <li v-repeat="item in items" v-on="click: toggle(item)">
    {{item.text}}
  </li>
</ul>
```

``` js
new Vue({
  el: '#list',
  data: {
    items: [
      { text: 'one', done: true },
      { text: 'two', done: false }
    ]
  },
  methods: {
    toggle: function (item) {
      item.done = !item.done
    }
  }
})
```

もし、 expression ハンドラ内のオリジナルの DOM イベントにアクセスしたいのであれば、`$event` として渡すことができます:

``` html
<button v-on="click: submit('hello!', $event)">Submit</button>
```

``` js
/* ... */
{
  methods: {
    submit: function (msg, e) {
      e.stopPropagation()
    }
  }
}
/* ... */
```

## 特殊な `key` フィルタ

キーボードイベントを監視するとき、汎用のキーコードをチェックする必要がしばしばあります。Vue.js は、 `v-on` ディレクティブと一緒の場合にのみ利用できる、特殊な `key` フィルタを用意しています。`key` フィルタは、チェックしたいキーコードを示す一つの引数を取ります:

``` html
<!-- keyCode が 13 のときだけ、vm.submit() を呼ぶ -->
<input v-on="keyup:submit | key 13">
```

よく利用されるキーのプリセットもいくつか用意されています:

``` html
<!-- 上記と同じ -->
<input v-on="keyup:submit | key 'enter'">
```

詳しくは、API リファレンス内の、[key の全リスト](/api/filters.html#key) を参照してください。

## なぜ HTML 内にリスナを記述するのですか？

このようなイベント監視のアプローチは、「関心の分離」という古き良きルールを破っているのではないか、と心配されるかもしれません。安心して下さい。すべての Vue.js のハンドラ関数と expression は現在のビューのみを扱う ViewModel にのみバインドされるよう制限されています。それによってメンテナンスが難しくなることはありません。実際に、`v-on` を利用することでいくつかの利点があります:

1. HTML テンプレートを単に眺めることで、あなたの JS コード内のハンドラ関数を簡単に見つけ出すことができます。
2. JS 内のイベントリスナを手作業でアタッチする必要がないので、ViewModel のコードはロジックのみとなり、DOM 依存もなくなります。このことはテストをより簡単にします。
3. ViewModel が破棄されたとき、すべてのイベントリスナは自動的に削除されます。それらを自力でクリーンアップすることを気にかける必要もありません。

次: [フォームのハンドリング](/guide/forms.html)
