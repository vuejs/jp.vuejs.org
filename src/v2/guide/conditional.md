---
title: 条件付きレンダリング
updated: 2019-02-23
type: guide
order: 7
---

<div class="vueschool"><a href="https://vueschool.io/lessons/vuejs-conditionals?friend=vuejs" target="_blank" rel="sponsored noopener" title="Learn how conditional rendering works with Vue School">条件付きレンダリングがどのように機能するか Vue School の無料レッスンで学ぶ</a></div>

## `v-if`

`v-if` ディレクティブは、ブロックを条件に応じて描画したい場合に使用されます。ブロックは、ディレクティブの式が真を返す場合のみ描画されます。

``` html
<h1 v-if="awesome">Vue is awesome!</h1>
```

これは、`v-else` で "else ブロック" を追加することも可能です:

``` html
<h1 v-if="awesome">Vue is awesome!</h1>
<h1 v-else>Oh no 😢</h1>
```

### テンプレートでの `v-if` による条件グループ

`v-if` はディレクティブなので、単一の要素に付加する必要があります。しかし、1 要素よりも多くの要素と切り替えたい場合はどうでしょうか？このケースでは、非表示ラッパー (wrapper) として提供される、`<template>` 要素で `v-if` を使用できます。最終的に描画される結果は、`<template>` 要素は含まれません。

``` html
<template v-if="ok">
  <h1>Title</h1>
  <p>Paragraph 1</p>
  <p>Paragraph 2</p>
</template>
```

### `v-else`

`v-if` に対して "else block" を示すために、`v-else` ディレクティブを使用できます:

``` html
<div v-if="Math.random() > 0.5">
  Now you see me
</div>
<div v-else>
  Now you don't
</div>
```

`v-else` 要素は、`v-if` または `v-else-if` 要素の直後になければなりません。それ以外の場合は認識されません。

### `v-else-if`

> 2.1.0 から新規

`v-else-if` は、名前が示唆するように、`v-if` の "else if block" として機能します。また、複数回連結することもできます:

```html
<div v-if="type === 'A'">
  A
</div>
<div v-else-if="type === 'B'">
  B
</div>
<div v-else-if="type === 'C'">
  C
</div>
<div v-else>
  Not A/B/C
</div>
```

`v-else` と同様に、`v-else-if` 要素は `v-if` 要素または`v-else-if` 要素の直後になければなりません。

### `key` による再利用可能な要素の制御

Vue は要素を可能な限り効率的に描画しようとしますが、スクラッチから描画する代わりにそれら要素を再利用することがよくあります。Vue を非常に速くするのに役立つ以外にも、これにはいくつかの便利な利点があります。たとえば、ユーザーが複数のログインタイプを切り替えることを許可する場合は、次のようにします:

``` html
<template v-if="loginType === 'username'">
  <label>Username</label>
  <input placeholder="Enter your username">
</template>
<template v-else>
  <label>Email</label>
  <input placeholder="Enter your email address">
</template>
```

上記のコードで `loginType` を切り替えても、ユーザーが既に入力した内容は消去されません。両方のテンプレートが同じ要素を使用するので、`<input>` は置き換えられられず、 `placeholder` だけが置き換えられます。

input にテキストを入力して、トグルボタンを押して自分で確認してください：

{% raw %}
<div id="no-key-example" class="demo">
  <div>
    <template v-if="loginType === 'username'">
      <label>Username</label>
      <input placeholder="Enter your username">
    </template>
    <template v-else>
      <label>Email</label>
      <input placeholder="Enter your email address">
    </template>
  </div>
  <button @click="toggleLoginType">Toggle login type</button>
</div>
<script>
new Vue({
  el: '#no-key-example',
  data: {
    loginType: 'username'
  },
  methods: {
    toggleLoginType: function () {
      return this.loginType = this.loginType === 'username' ? 'email' : 'username'
    }
  }
})
</script>
{% endraw %}

しかしこれは必ずしも望ましいことでないかもしれないので、Vue は"この 2 つの要素は完全に別個のもので、再利用しないでください" と伝える方法を提供します。それは、一意の値を持つ `key` 属性を追加するだけです:

``` html
<template v-if="loginType === 'username'">
  <label>Username</label>
  <input placeholder="Enter your username" key="username-input">
</template>
<template v-else>
  <label>Email</label>
  <input placeholder="Enter your email address" key="email-input">
</template>
```

トグルするたびにこれらの input が最初から描画されます。自分で確認してみましょう:

{% raw %}
<div id="key-example" class="demo">
  <div>
    <template v-if="loginType === 'username'">
      <label>Username</label>
      <input placeholder="Enter your username" key="username-input">
    </template>
    <template v-else>
      <label>Email</label>
      <input placeholder="Enter your email address" key="email-input">
    </template>
  </div>
  <button @click="toggleLoginType">Toggle login type</button>
</div>
<script>
new Vue({
  el: '#key-example',
  data: {
    loginType: 'username'
  },
  methods: {
    toggleLoginType: function () {
      return this.loginType = this.loginType === 'username' ? 'email' : 'username'
    }
  }
})
</script>
{% endraw %}

`<label>` 要素は、`key` 属性を持たないため、依然として効率的に再利用されていることに注意してください:

## `v-show`

条件的に要素を表示するための別のオプションは `v-show` です。使用方法はほとんど同じです:

``` html
<h1 v-show="ok">Hello!</h1>
```

違いは `v-show` による要素は常に描画されて DOM に維持するということです。`v-show` はシンプルに要素の `display` CSS プロパティを切り替えます。

<p class="tip">`v-show` は `<template>` 要素をサポートせず、`v-else` とも連動しないということに注意してください。</p>

## `v-if` vs `v-show`

`v-if` は、イベントリスナと子コンポーネント内部の条件ブロックが適切に破棄され、そして切り替えられるまでの間再作成されるため、”リアル”な条件レンダリングです。

`v-if` は **遅延描画 (lazy)** です。 初期表示において false の場合、何もしません。条件付きブロックは、条件が最初に true になるまで描画されません。

一方で、`v-show` はとてもシンプルです。要素は初期条件に関わらず常に描画され、シンプルな CSS ベースの切り替えとして保存されます。

一般的に、`v-if` はより高い切り替えコストを持っているのに対して、 `v-show` はより高い初期描画コストを持っています。 そのため、とても頻繁に何かを切り替える必要があれば `v-show` を選び、条件が実行時に変更することがほとんどない場合は、`v-if` を選びます。

## `v-if` と `v-for`

<p class="tip">`v-if` と `v-for` を同時に利用することは **推奨されません**。 詳細については [スタイルガイド](/v2/style-guide/#v-for-と一緒に-v-if-を使うのを避ける-必須) を参照ください。</p>

`v-if` といっしょに使用されるとき、`v-for` は `v-if` より優先度が高くなります。詳細については<a href="../guide/list.html#v-for-と-v-if">リストレンダリングのガイド</a>を参照してください。
