title: 特別な要素
type: api
order: 8
is_new: true
---

> 次は、Vue.js のテンプレートで特別な用途で役に立つ抽象要素のリストです。

### component

コンポーネントを起動するための代替シンタックスです。主に、動的コンポーネント向けに `is` 属性で使用されます:

``` html
<!-- 動的コンポーネントは vm で `componentid` プロパティによってコントロールされます -->
<component is="{{componentId}}"></component>
```

### content

`<content>` タグはコンポーネントテンプレートでコンテンツ挿入アウトレットとして役に立ちます。`<content>` 要素それ自身、置き換えられます。必要に応じて、挿入されたコンテンツの一部を表示させるのを一致するために使用される CSS セレクタを有効にする `select` 属性を受け入れます。

``` html
<!-- 挿入されたコンテンツに <li> だけ表示する -->
<content select="li"></content>
```

select 属性は mustache expression も含むことができます。詳細については、[コンテンツ挿入](/guide/components.html#コンテンツ挿入)を参照してください。

### partial

`<partial>` タグは登録された partial 向けのアウトレットとして役に立ちます。partial なコンテンツは挿入された時、Vue によってコンパイルもされます。`<partial>` 要素それ自身、置き換えられます。提供されるためには、`name` 属性が必要です。例えば:

``` js
// partila の登録
Vue.partial('my-partial', '<p>This is a partial! {{msg}}</p>')
```

``` html
<!-- 静的な partial -->
<partial name="my-partial"></partial>

<!-- 動的な partial -->
<partial name="{{partialId}}"></partial>
```
