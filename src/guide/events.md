---
title: メソッドとイベントハンドリング
type: guide
order: 9
---

## メソッドハンドラ

私達は DOM イベントをリッスンするために `v-on` ディレクティブを使用することができます:

``` html
<div id="example">
  <button v-on:click="greet">Greet</button>
</div>
```

私達は `greet` という名のメソッドに click イベントリスナをバインドします。ここでは、私達の Vue インスタンスでメソッドを定義する方法は以下になります:

``` js
var vm = new Vue({
  el: '#example',
  data: {
    name: 'Vue.js'
  },
  // `methods` オブジェクトの下にメソッドを定義します
  methods: {
    greet: function (event) {
      // 内部メソッドの `this` は vm インスタンスを指します
      alert('Hello ' + this.name + '!')
      // `event` はネイティブ DOM イベントです
      alert(event.target.tagName)
    }
  }
})

// JavaScript でもメソッドを起動できます
vm.greet() // -> 'Hello Vue.js!'
```

あなた自身でそれをテストしてみましょう:

{% raw %}
<div id="example" class="demo">
  <button v-on:click="greet">Greet</button>
</div>
<script>
var vm = new Vue({
  el: '#example',
  data: {
    name: 'Vue.js'
  },
  methods: {
    greet: function (event) {
      alert('Hello ' + this.name + '!')
      alert(event.target.tagName)
    }
  }
})
</script>
{% endraw %}

## インラインステートメントハンドラ

メソッド名に直接バインドする代わりに、私達はインライン JavaScript 文も使用することができます:

``` html
<div id="example-2">
  <button v-on:click="say('hi')">Say Hi</button>
  <button v-on:click="say('what')">Say What</button>
</div>
```
``` js
new Vue({
  el: '#example-2',
  methods: {
    say: function (msg) {
      alert(msg)
    }
  }
})
```

結果:
{% raw %}
<div id="example-2" class="demo">
  <button v-on:click="say('hi')">Say Hi</button>
  <button v-on:click="say('what')">Say What</button>
</div>
<script>
new Vue({
  el: '#example-2',
  methods: {
    say: function (msg) {
      alert(msg)
    }
  }
})
</script>
{% endraw %}

インライン式での制限と同様に、イベントハンドラは**1つの文のみ**に制限されています。

時どき、私達はインラインステートメントハンドラで元の DOM イベントにアクセスする必要もあります。特別な `$event` 変数を使用してメソッドにそれを渡すことができます:

``` html
<button v-on:click="say('hello!', $event)">Submit</button>
```

``` js
// ...
methods: {
  say: function (msg, event) {
    // 私達はネイティブイベントにアクセスできます
    event.preventDefault()
  }
}
```

## イベント修飾子

イベントハンドラ内部で `event.preventDefault()` または `event.stopPropagation()` を呼びだすのは、非常に一般的に必要です。私達はメソッド内部で簡単にこれを実行することはできますが、メソッドが DOM イベントで詳細に対処することよりもむしろデータロジックに対して純粋に可能ならば、それがよいでしょう。

この問題に対処するため、Vue.js は `v-on` に対して、`.prevent` そして `.stop` という2つの**イベント修飾子 (event modifier)**を提供します。修飾子はドット(.) で表記されたディレクティブの接尾辞であることを想起させます:

``` html
<!-- click イベント propagation は停止されます -->
<a v-on:click.stop="doThis"></a>

<!-- submit イベントはもはやページをリロードしません -->
<form v-on:submit.prevent="onSubmit"></form>

<!-- 修飾子は繋ぎ合わせることができます -->
<a v-on:click.stop.prevent="doThat">

<!-- 修飾子だけ -->
<form v-on:submit.prevent></form>
```

## キー修飾子

キーボードイベントをリスニングするとき、私達はしばしば一般的なキーコードをチェックする必要があります。Vue.js はキーイベントに対してリスニングするとき、キー修飾子 (key modifier)を追加することができます:

``` html
<!-- キーコードが 13 のときだけ、vm.submit() が呼ばれます -->
<input v-on:keyup.13="submit">
```

全てのキーコードを覚えることは面倒ですので、Vue.js は最も一般的に使用されるキーのエイリアスを提供します:

``` html
<!-- 上記と同じです -->
<input v-on:keyup.enter="submit">

<!-- 省略記法に対しても動作します -->
<input @keyup.enter="submit">
```

以下は、キー修飾子のエイリアスの完全なリストです:

- enter
- tab
- delete
- esc
- space
- up
- down
- left
- right

## なぜ HTML 内にリスナを記述するのですか？

このようなイベント監視のアプローチは、「関心の分離」という古き良きルールを破っているのではないか、と心配されるかもしれません。安心してください。すべての Vue.js のハンドラ関数と expression は現在のビューのみを扱う ViewModel にのみバインドされるよう制限されています。それによってメンテナンスが難しくなることはありません。実際に、`v-on` を利用することでいくつかの利点があります:

1. HTML テンプレートを単に眺めることで、あなたの JS コード内のハンドラ関数を簡単に見つけ出すことができます。

2. JS 内のイベントリスナを手作業でアタッチする必要がないので、ViewModel のコードはロジックのみとなり、DOM 依存もなくなります。このことはテストをより簡単にします。

3. ViewModel が破棄されたとき、すべてのイベントリスナは自動的に削除されます。それらを自力でクリーンアップすることを気にかける必要もありません。
