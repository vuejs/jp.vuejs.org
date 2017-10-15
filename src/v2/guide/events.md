---
title: イベントハンドリング
updated: 2017-09-03
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
      if (event) {
        alert(event.target.tagName)
      }
    }
  }
})

// JavaScript からメソッドを呼び出すこともできます
example2.greet() // => 'Hello Vue.js!'
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
      if (event) {
        alert(event.target.tagName)
      }
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
<button v-on:click="warn('Form cannot be submitted yet.', $event)">
  Submit
</button>
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
- `.once`

``` html
<!-- クリックイベントの伝搬が止まります -->
<a v-on:click.stop="doThis"></a>

<!-- submit イベントによってページがリロードされません -->
<form v-on:submit.prevent="onSubmit"></form>

<!-- 修飾子は繋げることができます -->
<a v-on:click.stop.prevent="doThat"></a>

<!-- 値を指定せず、修飾子だけ利用することもできます -->
<form v-on:submit.prevent></form>

<!-- イベントリスナーを追加するときにキャプチャモードで使います -->
<!-- 言い換えれば、内部要素を対象とするイベントは、その要素によって処理される前にここで処理されます -->
<div v-on:click.capture="doThis">...</div>

<!-- event.target が要素自身のときだけ、ハンドラが呼び出されます -->
<!-- 言い換えると子要素のときは呼び出されません -->
<div v-on:click.self="doThat">...</div>
```

<p class="tip">修飾子を使用するとき、関連するコードが同じ順序で生成されるため注意してください。それゆえ、`@click.prevent.self` を使用すると**全てのクリックイベント**を防ぐことはできますが、`@click.self.prevent` は要素自身におけるクリックイベントを防ぐだけです。</p>

> 2.1.4 から新規

``` html
<!-- 最大1回、クリックイベントはトリガーされます -->
<a v-on:click.once="doThis"></a>
```

他の修飾子とは異なり、ネイティブ DOM イベントには排他的ですが、`.once` 修飾子は[コンポーネントイベント](components.html#カスタムイベントとの-v-on-の使用) でも使用することができます。まだコンポーネントについて読んでいないなら、今のところこれについて気にする必要はありません。

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

- `.enter`
- `.tab`
- `.delete` ("Delete" と "Backspace" キー両方をキャプチャします)
- `.esc`
- `.space`
- `.up`
- `.down`
- `.left`
- `.right`

グローバルな `config.keyCodes` オブジェクト経由で[カスタムキー修飾子のエイリアス](../api/#keyCodes)も定義できます:

``` js
// v-on:keyup.f1 を可能にします
Vue.config.keyCodes.f1 = 112
```

### Automatic Key Modifers

> New in 2.5.0+

You can also directly use any valid key names exposed via [`KeyboardEvent.key`](https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/key/Key_Values) as modifiers by converting them to kebab-case:

``` html
<input @keyup.page-down="onPageDown">
```

In the above example, the handler will only be called if `$event.key === 'PageDown'`.

<p class="tip">A few keys (`.esc` and all arrow keys) have inconsistent `key` values in IE9, their built-in aliases should be preferred if you need to support IE9.</p>

## System Modifier Keys

> 2.1.0 から新規

次の修飾子を使用すると、対応するキーが押されたときにのみマウスイベントリスナをトリガできます:

- `.ctrl`
- `.alt`
- `.shift`
- `.meta`

> 注意: Macintosh キーボードの場合、meta はコマンドキー（⌘）です。Windows のキーボードでは、meta はウィンドウキー（⊞）です。Sun Microsystems のキーボードでは、メタは実線のダイヤモンド（◆）とマークされています。特定のキーボードでは、特に MIT や Lisp マシンのキーボードと Knight キーボード、space-cadet キーボード、メタのような後継機には "META" と表示されます。 Symbolics のキーボードでは、 "META" または "Meta" というラベルが付いています。

例:

```html
<!-- Alt + C -->
<input @keyup.alt.67="clear">

<!-- Ctrl + Click -->
<div @click.ctrl="doSomething">Do something</div>
```

<p class="tip">修飾子キーは通常のキーとは異なり、`keyup` イベントと一緒に使用するときは、イベントが発生したときに押さなければならないことに注意してください。言い換えると、`keyup.ctrl` は `ctrl` を押しながらキーを離したときにのみ、トリガーされます。`ctrl` キーだけを離すと、トリガーされません。</p>

### `.exact` Modifier

> New in 2.5.0

The `.exact` modifier should be used in combination with other system modifiers to indicate that the exact combination of modifiers must be pressed for the handler to fire.

``` html
<!-- this will fire even if Alt or Shift is also pressed -->
<button @click.ctrl="onClick">A</button>

<!-- this will only fire when only Ctrl is pressed -->
<button @click.ctrl.exact="onCtrlClick">A</button>
```

### マウスボタンの修飾子

> 2.2.0 からの新機能

- `.left`
- `.right`
- `.middle`

これらの修飾子は、イベントのトリガーのハンドリングを、特定のマウスのボタンのみに制限します。

## なぜ HTML にリスナを記述するのですか

これまで説明してきたようなイベント監視のアプローチは、"関心の分離"という古き良きルールを破っているのではないか、と心配されるかもしれません。安心してください。すべての Vue ハンドラ関数と式は、現在の View を扱う ViewModel に厳密に閉じています。それによってメンテナンスが難しくなることはありません。実際、`v-on` を利用することでいくつかの利点があります。

1. HTML テンプレートを眺めることで、JS コード内のハンドラ関数を探すことを容易にします

2. JS 内のイベントリスナーを手作業でアタッチする必要がないので、ViewModel を DOM 依存のない純粋なロジックにできます。これはテスタビリティも向上します。

3. ViewModel が消去されるときに、すべてのイベントリスナーは自動で削除されます。手動でそれらの消去をおこなうことを気にする必要はありません。
