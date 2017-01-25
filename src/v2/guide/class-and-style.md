---
title: クラスとスタイルのバインディング
type: guide
order: 6
---

データバインディングに対する共通の必要なことは、要素のクラスリストとインラインスタイルを操作していることです。それらは両方属性になるので、それらを `v-bind` を使用して処理することができます。私達の式で最終的に文字列を計算する必要があります。しかしながら、文字列の連結に関わることは、迷惑なエラーが発生しやすいです。この理由のため、Vue は `v-bind` が `class` と `style` と一緒に使われるとき、特別な拡張を提供します。文字列に加えて、式はオブジェクトまたは配列も評価することができます。

## HTML クラスのバインディング

### オブジェクト構文

`v-bind:class` に動的にクラスを切り替えるオブジェクトを渡すことができます:

``` html
<div v-bind:class="{ active: isActive }"></div>
```

上記の構文は `active` クラスが存在するかどうかを、データプロパティの `isActive` が[ true と評価される値か](https://developer.mozilla.org/en-US/docs/Glossary/Truthy)によって決まることを意味します。

オブジェクトに複数の項目を持たせることで、複数のクラスを切り替えることができます。加えて、`v-bind:class` ディレクティブはプレーンな `class` 属性と共存できます。 次のようなテンプレートに:

``` html
<div class="static"
     v-bind:class="{ active: isActive, 'text-danger': hasError }">
</div>
```

次のようなデータを与えます:

``` js
data: {
  isActive: true,
  hasError: false
}
```

これは次のように描画されます:

``` html
<div class="static active"></div>
```

`isActive` と `hasError` が変化するとき、クラスリストはそれに応じて更新されます。例えば、`hasError` が `true` になった場合、クラスリストは `"static active text-danger"` になります。

インラインでオブジェクトを束縛する必要はありません:

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

これは同じ結果を描画します。オブジェクトを返す[算出プロパティ](computed.html)を束縛することもできます。これは一般的で強力なパターンです:

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
      'text-danger': this.error && this.error.type === 'fatal',
    }
  }
}
```

### 配列構文

`v-bind:class` にクラスのリストを適用する配列を渡すことができます:

``` html
<div v-bind:class="[activeClass, errorClass]">
```
``` js
data: {
  activeClass: 'active',
  errorClass: 'text-danger'
}
```

このように描画されます:

``` html
<div class="active text-danger"></div>
```

条件付きリストでクラスを切り替えたい場合、三項演算子式でそれを行うことができます:

``` html
<div v-bind:class="[isActive ? activeClass : '', errorClass]">
```

これは常に `errorClass` が適用されますが、`isActive` が `true` のときにだけ `activeClass` クラスが適用されます。

しかしながら、これは複数条件のクラスがある場合は少し冗長です。なので配列構文内部ではオブジェクト構文も使えます:

``` html
<div v-bind:class="[{ active: isActive }, errorClass]">
```

### コンポーネントにおいて

> このセクションでは、[Vue のコンポーネント](components.html)の知識を前提としています。それをスキップして後で戻っても構いません。

カスタムコンポーネント上で `class` 属性を使用するとき、これらのクラスはコンポーネントの root 要素 に追加されます。この要素上に存在するクラスは、上書きされません。

例えば、このコンポーネントを宣言して:

``` js
Vue.component('my-component', {
  template: '<p class="foo bar">Hi</p>'
})
```

それを使用するときに、いくつかのクラスを追加したとします:

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

`isActive` が真となりうるときは、以下の HTML が描画されます:

``` html
<p class="foo bar active">Hi</p>
```

## インラインスタイルのバインディング

### オブジェクト構文

`v-bind:style`向けのオブジェクト構文は非常に簡単です。それは、JavaScript オブジェクトを除いては、ほとんど CSS のように見えます。CSS プロパティ名に対して、キャメルケース (caml-case) またはケバブケース (kebab-case: クォート`'`された) のどちらでも使用することができます:

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

また、オブジェクト構文はよくオブジェクトを返す算出プロパティと併せて使用されます。

### 配列構文

`v-bind:style` 向けの配列構文は、同じ要素に複数のスタイルオブジェクトを適用することができます:

``` html
<div v-bind:style="[baseStyles, overridingStyles]">
```

### 自動プリフィックス

`v-bind:style` でベンダー接頭辞を要求される CSS プロパティを使用するとき、例えば、`transform` においては、Vue.js は自動的に検出し、適用されるスタイルに適切な接頭辞を追加します。
