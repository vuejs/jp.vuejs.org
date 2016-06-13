---
title: 条件付きレンダリング
type: guide
order: 7
---

## v-if

文字列テンプレートでは、例えば Handlebars の例は、このような条件ブロックを記述します:

``` html
<!-- Handlebars の例 -->
{{#if ok}}
  <h1>Yes</h1>
{{/if}}
```

Vue.js では、同じことを達成するために、`v-if` ディレクティブを使用します:

``` html
<h1 v-if="ok">Yes</h1>
```

これは、`v-else` で "else" ブロックを追加することも可能です:

``` html
<h1 v-if="ok">Yes</h1>
<h1 v-else>No</h1>
```

## テンプレートでの v-if

`v-if` はディレクティブであるため、単一の要素にアタッチする必要があります。しかし、1 要素よりも多くの要素と切り替えたい場合はどうでしょうか？このケースでは、非表示ラッパー (wrapper) として提供される、`<template>` 要素で `v-if` を使用できます。最終的にレンダリングされる結果は、`<template>` 要素は含まれません。

``` html
<template v-if="ok">
  <h1>Title</h1>
  <p>Paragraph 1</p>
  <p>Paragraph 2</p>
</template>
```

## v-show

条件的に要素を表示するための別のオプションは `v-show` です。使用方法はほとんど同じです:

``` html
<h1 v-show="ok">Hello!</h1>
```

違いは `v-show` をによる要素は常にレンダリングされて DOM に維持するということです。`v-show` はシンプルに要素の `display` CSS プロパティを切り替えます。

`v-show` は `<template>` 構文をサポートしていないということに注意してください。

## v-else

`v-if` または `v-show` に対して "else block" を示すために、`v-else` ディレクティブを使用できます:

``` html
<div v-if="Math.random() > 0.5">
  Sorry
</div>
<div v-else>
  Not sorry
</div>
```

`v-else` 要素は、`v-if` または `v-show` の直後になければなりません。それ以外の場合は認識されません。

### コンポーネントでの注意事項

コンポーネントで `v-show` を使用するとき、`v-else` はディレクティブの優先度のため正しく適用されません。このため、これをするためには:

```html
<custom-component v-show="condition"></custom-component>
<p v-else>This could be a component too</p>
```

別の `v-show` で `v-else` を置換してください:

```html
<custom-component v-show="condition"></custom-component>
<p v-show="!condition">This could be a component too</p>
```

`v-if` では意図したよう動作しません。

## v-if 対 v-show

`v-if` ブロックが切り替えられる時、Vue.js は `v-if` 内部のテンプレートコンテンツもデータバインディングまたは子コンポーネントを含むことができるため、部分的なコンパイル / teardown 処理を実行する必要があります。`v-if` は、イベントリスナと子コンポーネント内部の条件ブロックが適切に破棄され、そして切り替えられるまでの間再作成されるため、"リアル"な条件レンダリングです。

`v-if` は **lazy** です。初期表示において false の場合、何もしません。部分コンパイルは、条件が最初に true になる(そしてコンパイルがその後にキャッシュされるまで)まで開始されません。

一方で、`v-show` はとてもシンプルです。要素は常にコンパイルされ、シンプルな CSS ベースの切り替えとして保存されます。

一般的に、`v-if` はより高い切り替えコストを持っているのに対して、`v-show` はより高い初期レンダリングコストを持っています。そのため、とても頻繁に何かを切り替える必要があれば `v-show` を選び、条件が実行時に変更することがほとんどない場合は、`v-if` を選びます。
