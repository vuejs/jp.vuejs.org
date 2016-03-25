---
title: クラスとスタイルのバインディング
type: guide
order: 6
---

データバインディングに対する共通の必要なことは、要素のクラスリストとインラインスタイルを操作していることです。それらは両方属性であるため、私達はそれらを `v-bind` を使用して処理することができます。私達は私達の式で最終的に文字列を計算する必要があります。しかしながら、文字列の連結に私達が関わることは、迷惑なエラーが発生しやすいです。この理由のため、Vue.js は `v-bind` が `class` と `style` に対して使用されるとき、特別な拡張を提供します。文字列に加えて、式はオブジェクトまたは配列も評価することができます。

## バインディング HTML クラス

<p class="tip">`{% raw %}class="{{ className }}"{% endraw %}` のようなクラスをバインドするために、mustache 展開を使用することができますが、`v-bind:class` でスタイルで混合させることは推奨されません。1 つまたは他を使用してください。</p>

### オブジェクト構文

私達は、`v-bind:class` に動的にクラスを切り替えるオブジェクトを渡すことが出来ます。`v-bind:class` ディレクティブはプレーンな `class` 属性と共存できることに注意してください:

``` html
<div class="static" v-bind:class="{ 'class-a': isA, 'class-b': isB }"></div>
```
``` js
data: {
  isA: true,
  isB: false
}
```

このようにレンダリングされます:

``` html
<div class="static class-a"></div>
```

`isA` と `isB` が変化するとき、クラスリストはそれに応じて更新されます。例えば、`isB` が `true` になった場合、クラスリストは `"static class-a class-b"` になります。

そして、データと同様に、直接オブジェクトにバインドすることができます:

``` html
<div v-bind:class="classObject"></div>
```
``` js
data: {
  classObject: {
    'class-a': true,
    'class-b': false
  }
}
```

これは同じ結果をレンダリングします。気づいているかもしれませんが、私達がオブジェクトを返す[算出プロパティ](computed.html)にバインドもすることもできます。これは一般的で強力なパターンです。

### 配列構文

私達は、`v-bind:class` にクラスのリストを適用する配列を渡すことができます:

``` html
<div v-bind:class="[classA, classB]">
```
``` js
data: {
  classA: 'class-a',
  classB: 'class-b'
}
```

このようにレンダリングされます:

``` html
<div class="class-a class-b"></div>
```

条件付きリストでクラスを切り替えたい場合、三項演算子式でそれを行うことができます:

``` html
<div v-bind:class="[classA, isB ? classB : '']">
```

これは常に `classA` が適用されますが、`isB` が `true` のとき、`classB` だけ適用されます。

However, this can be a bit verbose if you have multiple conditional classes. In version 1.0.19+, it's also possible to use the Object syntax inside Array syntax:

``` html
<div v-bind:class="[classA, { classB: isB, classC: isC }]">
```

## バインディングインラインスタイル

### オブジェクト構文

`v-bind:style`向けのオブジェクト構文は非常に簡単です。それは、JavaScript オブジェクトを除いては、ほとんど CSS のように見えます。CSS プロパティ名に対して、キャメルケース (caml-case) またはケバブケース (kebab-case)のどちらでも使用することができます:

``` html
<div v-bind:style="{ color: activeColor, fontSize: fontSize + 'px' }"></div>
```
``` js
data: {
  activeColor: 'red',
  fontSize: 30
}
```

テンプレートがクリーンになれるようにするために、直接 style オブジェクトにバインドするのは、よいアイディアです:

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

また、オブジェクト構文はよくオブジェクトを返す算出プロパティと併せて使用されます:

### 配列構文

`v-bind:style` 向けの配列構文は、同じ要素に複数のスタイルオブジェクトを適用することができます:

``` html
<div v-bind:style="[styleObjectA, styleObjectB]">
```

### 自動プリフィックス

`v-bind:style` でベンダー接頭辞を要求される CSS プロパティを使用するとき、例えば、`transform` においては、Vue.js は自動的に検出し、適用されるスタイルに適切な接頭辞をを追加します。
