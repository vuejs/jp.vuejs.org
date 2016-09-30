---
title: Event Handling
type: guide
order: 9
---

## イベントの購読

`v-on` ディレクティブを使うことで、DOM イベントの購読、イベント発火時の JavaScript の実行が可能になります。

例:

``` html
<div id="example-1">
  <button v-on:click="counter += 1">Add 1</button>
  <p>The button above has been clicked {{ counter }} times.</p>
</div>
```
``` js
var example1 = new Vue({
  el: '#example-1',
  data: {
    counter: 0
  }
})
```

結果:

{% raw %}
<div id="example-1" class="demo">
  <button v-on:click="counter += 1">Add 1</button>
  <p>The button above has been clicked {{ counter }} times.</p>
</div>
<script>
var example1 = new Vue({
  el: '#example-1',
  data: {
    counter: 0
  }
})
</script>
{% endraw %}

## メソッドイベントハンドラ

多くのイベントハンドラのロジックはより複雑になっていくので、`v-on` 属性の値に JavaScript 式を記述し続けるのは現実的ではありません。そのため、`v-on` は呼び出したいメソッドの名前も受け付けます。

例:

``` html
<div id="example-2">
  <!-- `greet` は、あらかじめ定義したメソッドの名前 -->
  <button v-on:click="greet">Greet</button>
</div>
```

``` js
var example2 = new Vue({
  el: '#example-2',
  data: {
    name: 'Vue.js'
  },
  // `methods` オブジェクトの下にメソッドを定義する
  methods: {
    greet: function (event) {
      // メソッド内の `this` は、 Vue インスタンスを参照します
      alert('Hello ' + this.name + '!')
      // `event` は、ネイティブ DOM イベントです
      alert(event.target.tagName)
    }
  }
})

// JavaScript からメソッドを呼び出すこともできます
example2.greet() // -> 'Hello Vue.js!'
```

結果:

{% raw %}
<div id="example-2" class="demo">
  <button v-on:click="greet">Greet</button>
</div>
<script>
var example2 = new Vue({
  el: '#example-2',
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

## インラインメソッドハンドラ

メソッド名を直接指定する代わりに、インライン JavaScript 式でメソッドを指定することもできます:

``` html
<div id="example-3">
  <button v-on:click="say('hi')">Say hi</button>
  <button v-on:click="say('what')">Say what</button>
</div>
```
``` js
new Vue({
  el: '#example-3',
  methods: {
    say: function (message) {
      alert(message)
    }
  }
})
```

結果:
{% raw %}
<div id="example-3" class="demo">
  <button v-on:click="say('hi')">Say hi</button>
  <button v-on:click="say('what')">Say what</button>
</div>
<script>
new Vue({
  el: '#example-3',
  methods: {
    say: function (message) {
      alert(message)
    }
  }
})
</script>
{% endraw %}

時には、インラインステートメントハンドラでオリジナルの DOM イベントを参照したいこともあるでしょう。特別な `$event` 変数を使うことでメソッドに DOM イベントを渡すことができます:

``` html
<button v-on:click="warn('Form cannot be submitted yet.', $event)">Submit</button>
```

``` js
// ...
methods: {
  warn: function (message, event) {
    // ネイティブイベントを参照しています
    if (event) event.preventDefault()
    alert(message)
  }
}
```

## イベント修飾子

イベントハンドラ内での `event.preventDefault()` または `event.stopPropagation()` の呼び出しは、様々な場面で共通に必要になります。これらはメソッド内部で簡単に呼び出すことができますが、DOM イベントの込み入った処理をおこなうよりも、純粋なデータロジックだけになっている方がより良いでしょう。

この問題に対応するために、Vue は `v-on` のために**イベント修飾子(event modifiers)**を提供しています。修飾子は、ドット(.)で表記されるディレクティブの接尾辞を思い返してください。

- `.stop`
- `.prevent`
- `.capture`
- `.self`

``` html
<!-- クリックイベントの伝搬が止まります -->
<a v-on:click.stop="doThis"></a>

<!-- submit イベントによってページがリロードされません -->
<form v-on:submit.prevent="onSubmit"></form>

<!-- 修飾子は繋げることができます -->
<a v-on:click.stop.prevent="doThat">

<!-- 値を指定せず、修飾子だけ利用することもできます -->
<form v-on:submit.prevent></form>

<!-- イベントリスナーを追加するときにキャプチャモードで使います -->
<div v-on:click.capture="doThis">...</div>

<!-- event.target が要素自身のときだけ、ハンドラが呼び出されます -->
<!-- 言い換えると子要素のときは呼び出されません -->
<div v-on:click.self="doThat">...</div>
```

## キー修飾子

キーボードイベントを購読するにあたって、時にはキーコードのチェックが共通で必要になります。Vue は、`v-on` に対してキー修飾子を追加することで、キーコードのチェックを可能にします:

``` html
<!-- keyCode が13のときだけ、vm.submit() が呼ばれます  -->
<input v-on:keyup.13="submit">
```

全てのキーコードを覚えることは大変なので、Vue は最も一般的に使用されるキーのエイリアスを提供します:

``` html
<!-- 上記と同じです -->
<input v-on:keyup.enter="submit">

<!-- 省略記法も同様に動作します -->
<input @keyup.enter="submit">
```

キー修飾子のエイリアスの全てのリストを示します:

- enter
- tab
- delete ("Delete" と "Backspace" キー両方をキャプチャします)
- esc
- space
- up
- down
- left
- right

単一文字のキーエイリアスもサポートされています。

``` html
<input v-on:keyup.v="say('That is the first letter in Vue')">
```

必要であれば、カスタムキー修飾子のエイリアスを定義することもできます:

``` js
// v-on:keyup.f1 を可能にします
Vue.config.keyCodes.f1 = 112
```

## なぜ HTML にリスナを記述するのですか

これまで説明してきたようなイベント監視のアプローチは、"関心の分離"という古き良きルールを破っているのではないか、と心配されるかもしれません。安心してください。すべての Vue ハンドラ関数と式は、現在の View を扱う ViewModel に厳密に閉じています。それによってメンテナンスが難しくなることはありません。実際、`v-on` を利用することでいくつかの利点があります。

1. HTML テンプレートを眺めることで、JS コード内のハンドラ関数を探すことを容易にします

2. JS 内のイベントリスナーを手作業でアタッチする必要がないので、ViewModel を DOM 依存のない純粋なロジックにできます。これはテスタビリティも向上します。

3. ViewModel が消去されるときに、すべてのイベントリスナーは自動で削除されます。手動でそれらの消去をおこなうことを気にする必要はありません。
