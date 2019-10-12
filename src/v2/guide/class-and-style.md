---
title: クラスとスタイルのバインディング
updated: 2019-07-22
type: guide
order: 6
---

データバインディングに一般に求められることの 1 つは、要素のクラスリストとインラインスタイルを操作することです。それらはどちらも属性ですから、`v-bind` を使って扱うことができます。最終的な文字列を式で計算するだけです。しかしながら、文字列の連結に手を出すのは煩わしく、エラーのもとです。そのため、Vue は `v-bind` が `class` と `style` と一緒に使われるとき、特別な拡張機能を提供します。文字列だけではなく、式はオブジェクトまたは配列を返すことができます。

## HTML クラスのバインディング
<div class="vueschool"><a href="https://vueschool.io/lessons/vuejs-dynamic-classes?friend=vuejs" target="_blank" rel="sponsored noopener" title="Free Vue.js Dynamic Classes Lesson">Vue School で無料の動画レッスンを見る</a></div>

### オブジェクト構文

`v-bind:class` にオブジェクトを渡すことでクラスを動的に切り替えることができます:

``` html
<div v-bind:class="{ active: isActive }"></div>
```

上記の構文は、`active` クラスの有無がデータプロパティ `isActive` の[真偽性](https://developer.mozilla.org/ja-JP/docs/Glossary/Truthy)によって決まることを意味しています。

オブジェクトにさらにフィールドを持たせることで複数のクラスを切り替えることができます。加えて、`v-bind:class` ディレクティブはプレーンな `class` 属性と共存できます。つまり、次のようなテンプレートと:

``` html
<div
  class="static"
  v-bind:class="{ active: isActive, 'text-danger': hasError }"
></div>
```

次のようなデータがあったとすると:

``` js
data: {
  isActive: true,
  hasError: false
}
```

このように描画されます:

``` html
<div class="static active"></div>
```

`isActive` もしくは `hasError` が変化するとき、クラスリストはそれに応じて更新されます。例えば、`hasError` が `true` になった場合、クラスリストは `"static active text-danger"` になります。

束縛されるオブジェクトはインラインでなくてもかまいません:

``` html
<div v-bind:class="classObject"></div>
```
``` js
data: {
  classObject: {
    active: true,
    'text-danger': false
  }
}
```

これは同じ結果を描画します。オブジェクトを返す[算出プロパティ](computed.html)に束縛することもできます。これは一般的で強力なパターンです:

``` html
<div v-bind:class="classObject"></div>
```
``` js
data: {
  isActive: true,
  error: null
},
computed: {
  classObject: function () {
    return {
      active: this.isActive && !this.error,
      'text-danger': this.error && this.error.type === 'fatal'
    }
  }
}
```

### 配列構文

`v-bind:class` に配列を渡してクラスのリストを適用することができます:

``` html
<div v-bind:class="[activeClass, errorClass]"></div>
```
``` js
data: {
  activeClass: 'active',
  errorClass: 'text-danger'
}
```

これは次のように描画されます:

``` html
<div class="active text-danger"></div>
```

リスト内のクラスを条件に応じて切り替えたい場合は、三項演算子式を使って実現することができます:

``` html
<div v-bind:class="[isActive ? activeClass : '', errorClass]"></div>
```

この場合 `errorClass` は常に適用されますが、`activeClass` クラスは `isActive` が真と評価されるときだけ適用されます。

しかしながら、これでは複数の条件つきクラスがあると少し冗長になってしまいます。そのため、配列構文の内部ではオブジェクト構文を使うこともできます:

``` html
<div v-bind:class="[{ active: isActive }, errorClass]"></div>
```

### コンポーネントにおいて

> このセクションでは、[Vue のコンポーネント](components.html)の知識を前提としています。いったんスキップして後で戻ってきても構いません。

カスタムコンポーネント上で `class` 属性を使用するとき、これらのクラスはコンポーネントの root 要素 に追加されます。この要素上に存在するクラスは、上書きされません。

例えば、このコンポーネントを宣言して:

``` js
Vue.component('my-component', {
  template: '<p class="foo bar">Hi</p>'
})
```

使用するときにいくつかのクラスを追加したとします:

``` html
<my-component class="baz boo"></my-component>
```

以下の HTML が描画されます:

``` html
<p class="foo bar baz boo">Hi</p>
```

クラスバインディングに対しても同様です:

``` html
<my-component v-bind:class="{ active: isActive }"></my-component>
```

`isActive` が真と評価されるときは、以下の HTML が描画されます:

``` html
<p class="foo bar active">Hi</p>
```

## インラインスタイルのバインディング

### オブジェクト構文

`v-bind:style` 向けのオブジェクト構文は非常に簡単です。JavaScript オブジェクトということを除けば、ほとんど CSS のように見えます。CSS のプロパティ名には、キャメルケース (camelCase) またはケバブケース (kebab-case: クォートとともに使うことになります) のどちらでも使用することができます:

``` html
<div v-bind:style="{ color: activeColor, fontSize: fontSize + 'px' }"></div>
```
``` js
data: {
  activeColor: 'red',
  fontSize: 30
}
```

テンプレートをクリーンにするために、直接 style オブジェクトに束縛するのは、よいアイディアです:

``` html
<div v-bind:style="styleObject"></div>
```
``` js
data: {
  styleObject: {
    color: 'red',
    fontSize: '13px'
  }
}
```

ここでもまた、オブジェクト構文はしばしばオブジェクトを返す算出プロパティと併せて使用されます。

### 配列構文

`v-bind:style` 向けの配列構文は、同じ要素に複数のスタイルオブジェクトを適用することができます:

``` html
<div v-bind:style="[baseStyles, overridingStyles]"></div>
```

### 自動プリフィックス

`v-bind:style` で[ベンダー接頭辞](https://developer.mozilla.org/ja/docs/Glossary/Vendor_Prefix)を要求される CSS プロパティを使用するとき、例えば、`transform` においては、Vue.js は自動的に適切な接頭辞を検出し、適用されるスタイルに追加します。

### 複数の値

> 2.3.0 以降

2.3.0 以降では、 style プロパティに複数の (接頭辞付き) 値の配列を設定できます。例えば次のようになります:

``` html
<div v-bind:style="{ display: ['-webkit-box', '-ms-flexbox', 'flex'] }"></div>
```

これは、配列内でブラウザがサポートしている最後の値だけを描画します。この例では、flexbox の接頭されていないバージョンをサポートしているブラウザでは `display: flex` を描画します。
