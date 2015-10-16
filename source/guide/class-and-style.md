---
title: クラスとスタイルのバインディング
type: guide
order: 6
---

データバインディングに対する共通の必要なことは、要素のクラスリストとインラインスタイルを操作していることです。それらは両方属性であるため、私達はそれらを `v-bind` を使用して処理することができます。私達は私達の式で最終的に文字列を計算する必要があります。しかしながら、文字列の連結に私達が関わることは、迷惑なエラーが発生しやすいです。この理由のため、Vue.js は `v-bind` が `class` と `style` に対して使用されるとき、特別な拡張を提供します。文字列に加えて、式はオブジェクトまたは配列も評価することができます。

## バインディング HTML クラス

### オブジェクトシンタックス

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

`isA` と `isB` が変化するとき、クラスリストはそれに応じて更新されます。例えば、`isB` が `true` になった場合、クラスリストは `"class-a class-b"` になります。

そして、あなたはデータと同様に、直接オブジェクトにバインドすることができます:

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

これは同じ結果をレンダリングします。あなたは気づいているかもしれませんが、私達がオブジェクトを返す [computed property](computed.html) にバインドもすることもできます。これは一般的で強力なパターンです。

### 配列シンタックス

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

あなたが条件付きリストでクラスを切り替えたい場合、あなたは三項演算子式でそれを行うことができます:

``` html
<div v-bind:class="[classA, isB ? classB : '']">
```

これは常に `classA` が適用されますが、`isB` が `true` のとき、`classB` だけ適用されます。

## バインディングインラインスタイル

### オブジェクトシンタックス

`v-bind:style`向けのオブジェクトシンタックスは非常に簡単です。それは、JavaScript オブジェクトを除いては、ほとんど CSS のように見えます。あなたは、CSS プロパティ名に対して、キャメルケース (caml-case) またはケバブケース (kebab-case)のどちらでも使用することができます:

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

また、オブジェクトシンタックスはよくオブジェクトを返す computed property と併せて使用されます:

### 配列シンタックス

`v-bind:style` 向けの配列シンタックスは、あなたは同じ要素に複数のスタイルオブジェクトを適用することができます:

``` html
<div v-bind:style="[styleObjectA, styleObjectB]">
```

### 自動プレフィックス

あなたが `v-bind:style` でベンダー接頭辞を要求される CSS プロパティを使用するとき、例えば、`transform` においては、Vue.js は自動的に検出し、適用されるスタイルに適切な接頭辞をを追加します。
