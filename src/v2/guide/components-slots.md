---
title: スロット
type: guide
updated: 2019-02-20
order: 104
---


> このページは [コンポーネントの基本](components.html) を読まれていることが前提になっています。コンポーネントを扱った事のない場合はこちらのページを先に読んでください。

> バージョン 2.6.0 で、名前付きスロットとスコープ付きスロットに対する新しい統一構文 (`v-slot` ディレクティブ) が導入されました。`slot` および `slot-scope` 属性は非推奨となり置き換えられますが、まだ削除は _されず_ 、ドキュメントも [ここ](#非推奨の構文) にあります。新しい構文を導入する理由は、この [RFC](https://github.com/vuejs/rfcs/blob/master/active-rfcs/0001-new-slot-syntax.md) に記述されています。


## スロットコンテンツ

Vue には [Web Components spec draft](https://github.com/w3c/webcomponents/blob/gh-pages/proposals/Slots-Proposal.md) にヒントを得たコンテンツ配信 API が実装されており、 `<slot>` 要素をコンテンツ配信の受け渡し口として利用します。

これを使うことで次のようなコンポーネントを作成することが出来ます:

``` html
<navigation-link url="/profile">
  Your Profile
</navigation-link>
```

そして、 `<navigation-link>` のテンプレートはこうなります:

``` html
<a
  v-bind:href="url"
  class="nav-link"
>
  <slot></slot>
</a>
```

コンポーネントを描画する時、 `<slot></slot>` は「Your Profile」に置換されるでしょう。スロットには HTML を含む任意のテンプレートを入れることが出来ます:

``` html
<navigation-link url="/profile">
  <!-- Font Awesome のアイコンを追加 -->
  <span class="fa fa-user"></span>
  Your Profile
</navigation-link>
```

または、他のコンポーネントを入れることも出来ます:

``` html
<navigation-link url="/profile">
  <!-- コンポーネントを使ってアイコンを追加 -->
  <font-awesome-icon name="user"></font-awesome-icon>
  Your Profile
</navigation-link>
```

もしも `<navigation-link>` のテンプレートが `<slot>` 要素を含ま **ない** 場合、開始タグと終了タグの間にある任意のコンテンツは破棄されます。

## コンパイルスコープ

スロットの中でデータを扱いたい場合はこうします:

``` html
<navigation-link url="/profile">
  Logged in as {{ user.name }}
</navigation-link>
```

このスロットは、テンプレートの残りの部分と同じインスタンスプロパティ (つまり、同じ "スコープ") にアクセスできます。`<navigation-link>` のスコープにアクセスすることは **できません**。例えば、`url` へのアクセスは動作しないでしょう:

``` html
<navigation-link url="/profile">
  Clicking here will send you to: {{ url }}
  <!--
  `url` は undefined になります。というのも、このコンテンツは
  <navigation-link> コンポーネント _の中で_ 定義されるのではなく、
  <navigation-link> コンポーネント _に_ 渡されるからです。
  -->
</navigation-link>
```

ルールとしては、以下を覚えておいてください:

> 親テンプレート内の全てのものは親のスコープでコンパイルされ、子テンプレート内の全てのものは子のスコープでコンパイルされる。

## フォールバックコンテンツ

スロットに対して、コンテンツがない場合にだけ描画されるフォールバック (つまり、デフォルトの) コンテンツを指定すると便利な場合があります。例えば、`<submit-button>` コンポーネントにおいて:

```html
<button type="submit">
  <slot></slot>
</button>
```

ほとんどの場合には `<button>` の中に「Submit」という文字を描画したいかもしれません。「Submit」をフォールバックコンテンツにするには、`<slot>` タグの中に記述します。

```html
<button type="submit">
  <slot>Submit</slot>
</button>
```

そして、親コンポーネントからスロットのコンテンツを指定せずに `<submit-button>` を使うと:

```html
<submit-button></submit-button>
```

フォールバックコンテンツの「Submit」が描画されます:

```html
<button type="submit">
  Submit
</button>
```

しかし、もしコンテンツを指定すると:

```html
<submit-button>
  Save
</submit-button>
```

指定されたコンテンツが代わりに描画されます:

```html
<button type="submit">
  Save
</button>
```

## 名前付きスロット

> 2.6.0 から更新。`slot` 属性を使った非推奨の構文については、[こちらを参照](#非推奨の構文)

複数のスロットがあると便利なときもあります。例えば、`<base-layout>` コンポーネントが下記のようなテンプレートだとしましょう:

``` html
<div class="container">
  <header>
    <!-- ここにヘッダコンテンツ -->
  </header>
  <main>
    <!-- ここにメインコンテンツ -->
  </main>
  <footer>
    <!-- ここにフッターコンテンツ -->
  </footer>
</div>
```

こういった場合のために、 `<slot>` 要素は `name` という特別な属性を持っていて、追加のスロットを定義できます:

``` html
<div class="container">
  <header>
    <slot name="header"></slot>
  </header>
  <main>
    <slot></slot>
  </main>
  <footer>
    <slot name="footer"></slot>
  </footer>
</div>
```

`name` のない `<slot>` 要素は、暗黙的に「default」という名前を持ちます。

名前付きスロットにコンテンツを指定するには、`<template>` に対して `v-slot` ディレクティブを使って、スロット名を引数として与えます:

```html
<base-layout>
  <template v-slot:header>
    <h1>Here might be a page title</h1>
  </template>

  <p>A paragraph for the main content.</p>
  <p>And another one.</p>

  <template v-slot:footer>
    <p>Here's some contact info</p>
  </template>
</base-layout>
```

これにより、`<template>` 要素の中身はすべて対応するスロットに渡されます。`v-slot` を使った `<template>` で囲まれていないコンテンツは、デフォルトスロットに対するものだとみなされます。

しかし、明示的に指定したいなら、デフォルトスロットのコンテンツを `<template>` で囲むこともできます:

```html
<base-layout>
  <template v-slot:header>
    <h1>Here might be a page title</h1>
  </template>

  <template v-slot:default>
    <p>A paragraph for the main content.</p>
    <p>And another one.</p>
  </template>

  <template v-slot:footer>
    <p>Here's some contact info</p>
  </template>
</base-layout>
```

いずれにせよ、描画される HTML は次のようになります:

``` html
<div class="container">
  <header>
    <h1>Here might be a page title</h1>
  </header>
  <main>
    <p>A paragraph for the main content.</p>
    <p>And another one.</p>
  </main>
  <footer>
    <p>Here's some contact info</p>
  </footer>
</div>
```

非推奨になった [`slot` 属性](#非推奨の構文) とは異なり、**`v-slot` は `<template>` だけに追加できる** ([1つだけ例外](#デフォルトスロットしかない場合の省略記法) あり) 点に注意してください。

## スコープ付きスロット

> 2.6.0 から更新。`slot-scope` 属性を使った非推奨の構文については、[こちらを参照](#非推奨の構文)

スロットコンテンツから、子コンポーネントの中だけで利用可能なデータにアクセスできると便利なことがあります。例えば、以下のようなテンプレートの `<current-user>` コンポーネントを考えてみてください:

```html
<span>
  <slot>{{ user.lastName }}</slot>
</span>
```

ここで、ユーザーの名字の代わりに名前を表示するよう、このフォールバックコンテンツを置き換えたいと思うかもしれません:

``` html
<current-user>
  {{ user.firstName }}
</current-user>
```

しかし、これは動作しません。というのも、`user` にアクセスすることができるのは `<current-user>` コンポーネントだけですが、ここで指定しているコンテンツは親コンポーネントで描画されるからです。

親コンポーネント内でスロットコンテンツとして `user` を使えるようにするためには、`<slot>` 要素の属性として `user` をバインドします:

``` html
<span>
  <slot v-bind:user="user">
    {{ user.lastName }}
  </slot>
</span>
```

`<slot>` 要素にバインドされた属性は、**スロットプロパティ** と呼ばれます。親スコープ内で `v-slot` の値として名前を指定することで、スロットプロパティを受け取ることができます:

``` html
<current-user>
  <template v-slot:default="slotProps">
    {{ slotProps.user.firstName }}
  </template>
</current-user>
```

この例では、すべてのスロットプロパティを保持するオブジェクトの名前を `slotProps` にしましたが、あなたの好きな名前を使うことができます。

### デフォルトスロットしかない場合の省略記法

上の例のようにデフォルトスロット _だけの_ 場合は、コンポーネントのタグをスロットのテンプレートとして使うことができます。つまり、コンポーネントに対して `v-slot` を直接使えます。

``` html
<current-user v-slot:default="slotProps">
  {{ slotProps.user.firstName }}
</current-user>
```

さらに短くすることもできます。未指定のコンテンツがデフォルトスロットのものとみなされるのと同様に、引数のない `v-slot` もデフォルトコンテンツを参照しているとみなされます:

``` html
<current-user v-slot="slotProps">
  {{ slotProps.user.firstName }}
</current-user>
```

デフォルトスロットに対する省略記法は、名前付きスロットと混在させることが **できない** 点に注意してください。スコープの曖昧さにつながるためです:

``` html
<!-- 不正。警告が出る -->
<current-user v-slot="slotProps">
  {{ slotProps.user.firstName }}
  <template v-slot:other="otherSlotProps">
    slotProps is NOT available here
  </template>
</current-user>
```

複数のスロットがある場合は常に _すべての_ スロットに対して `<template>` ベースの構文を使用してください:

``` html
<current-user>
  <template v-slot:default="slotProps">
    {{ slotProps.user.firstName }}
  </template>

  <template v-slot:other="otherSlotProps">
    ...
  </template>
</current-user>
```

### スロットプロパティの分割代入

内部的には、スコープ付きスロットはスロットコンテンツを単一引数の関数で囲むことで動作させています。

```js
function (slotProps) {
  // ... slot content ...
}
```

これは、`v-slot` の値が関数定義の引数部分で有効な任意の JavaScript 式を受け付けることを意味します。そのため、サポートされている環境 ([単一ファイルコンポーネント](single-file-components.html) または [モダンブラウザ](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment#%E3%83%96%E3%83%A9%E3%82%A6%E3%82%B6%E3%83%BC%E5%AE%9F%E8%A3%85%E7%8A%B6%E6%B3%81)) では、特定のスロットプロパティを取得するために [ES2015 の分割代入](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment#object_destructuring) を使うこともできます:

``` html
<current-user v-slot="{ user }">
  {{ user.firstName }}
</current-user>
```

こうするとテンプレートはよりきれいになります。特に、スロットが多くのプロパティを提供している場合はそうです。また、プロパティをリネームする (例えば、`user` から `person`) など別の可能性も開けます:

``` html
<current-user v-slot="{ user: person }">
  {{ person.firstName }}
</current-user>
```

スロットプロパティが未定義だった場合のフォールバックを定義することさえできます:

``` html
<current-user v-slot="{ user = { firstName: 'Guest' } }">
  {{ user.firstName }}
</current-user>
```

## 動的なスロット名

> 2.6.0 で新規追加

[ディレクティブの動的引数](syntax.html#動的引数) は `v-slot` でも動作し、動的なスロット名の定義が可能です:

``` html
<base-layout>
  <template v-slot:[dynamicSlotName]>
    ...
  </template>
</base-layout>
```

## 名前付きスロットの省略記法

> 2.6.0 で新規追加

`v-on` や `v-bind` と同様に `v-slot` にも省略記法があり、引数の前のすべての部分 (`v-slot:`) を特別な記号 `#` で置き換えます。例えば、`v-slot:header` は `#header` に書き換えることができます:

```html
<base-layout>
  <template #header>
    <h1>Here might be a page title</h1>
  </template>

  <p>A paragraph for the main content.</p>
  <p>And another one.</p>

  <template #footer>
    <p>Here's some contact info</p>
  </template>
</base-layout>
```

しかし、ほかのディレクティブと同様に、省略記法は引数がある場合にのみ利用できます。これは、次のような構文が不正ということを意味します:

``` html
<!-- これは警告を引き起こす -->
<current-user #="{ user }">
  {{ user.firstName }}
</current-user>
```

代わりに、省略記法を使いたい場合には、常にスロット名を指定する必要があります:

``` html
<current-user #default="{ user }">
  {{ user.firstName }}
</current-user>
```

## その他の例

**スロットプロパティを使えば、入力プロパティに応じて異なるコンテンツを描画する再利用可能なテンプレートにスロットを変えることができます。** これは、データロジックをカプセル化する一方で親コンポーネントによるレイアウトのカスタマイズを許すような、再利用可能なコンポーネントを設計しているときに特に便利です。

例えば、リストのレイアウトと絞り込みロジックを含む `<todo-list>` コンポーネントを実装しているとします:

```html
<ul>
  <li
    v-for="todo in filteredTodos"
    v-bind:key="todo.id"
  >
    {{ todo.text }}
  </li>
</ul>
```

それぞれの todo に対するコンテンツをハードコーディングする代わりに、todo ごとにスロットを作成し、スロットプロパティとして `todo` をバインドすることで、親コンポーネントから制御できるようにします:

```html
<ul>
  <li
    v-for="todo in filteredTodos"
    v-bind:key="todo.id"
  >
    <!--
    それぞれの todo のためのスロットがあり、 `todo` オブジェクトを
    スロットのプロパティとして渡している
    -->
    <slot name="todo" v-bind:todo="todo">
      <!-- フォールバックコンテンツ -->
      {{ todo.text }}
    </slot>
  </li>
</ul>
```

この `<todo-list>` コンポーネントを利用する時、子からのデータにはアクセスしながらも、todo アイテムに対して代わりの `<template>` を定義することができます:

```html
<todo-list v-bind:todos="todos">
  <template v-slot:todo="{ todo }">
    <span v-if="todo.isComplete">✓</span>
    {{ todo.text }}
  </template>
</todo-list>
```

しかし、これでもスコープ付きスロットが可能にすることの表面を走り書きした程度にすぎません。実世界の強力な利用例については、[Vue Virtual Scroller](https://github.com/Akryum/vue-virtual-scroller) や [Vue Promised](https://github.com/posva/vue-promised), [Portal Vue](https://github.com/LinusBorg/portal-vue) といったライブラリを見てみることをおすすめします。

## 非推奨の構文

> Vue 2.6.0 で `v-slot` ディレクティブが導入され、まだサポートされているものの `slot` および `slot-scope` 属性に代わる改善された API を提供しています。`v-slot` を導入する理由は、この [RFC](https://github.com/vuejs/rfcs/blob/master/active-rfcs/0001-new-slot-syntax.md) に完全に記述されています。`slot` および `slot-scope` 属性は今後の 2.x リリースで引き続きサポートされますが、公式に非推奨となり、Vue 3 では削除されるでしょう。

### `slot` 属性による名前付きスロット

> 2.6.0 以降では <abbr title="すべての Vue 2.x バージョンでは引き続きサポートされますが、推奨されていません。">非推奨</abbr>。推奨される新しい構文については、[こちら](#名前付きスロット) を参照。

親から名前付きスロットにコンテンツを渡すには、`<template>` に対して特別な `slot` 属性を使います (例として、[ここ](#名前付きスロット) で説明した `<base-layout>` コンポーネントを使用):

```html
<base-layout>
  <template slot="header">
    <h1>Here might be a page title</h1>
  </template>

  <p>A paragraph for the main content.</p>
  <p>And another one.</p>

  <template slot="footer">
    <p>Here's some contact info</p>
  </template>
</base-layout>
```

あるいは、`slot` 属性を通常の要素に直接指定することもできます:

``` html
<base-layout>
  <h1 slot="header">Here might be a page title</h1>

  <p>A paragraph for the main content.</p>
  <p>And another one.</p>

  <p slot="footer">Here's some contact info</p>
</base-layout>
```

名前のないスロットは **デフォルトスロット** となり、スロットの指定がないコンテンツをすべて受け取ります。上のどちらの例も、描画される HTML は次のようになります:

``` html
<div class="container">
  <header>
    <h1>Here might be a page title</h1>
  </header>
  <main>
    <p>A paragraph for the main content.</p>
    <p>And another one.</p>
  </main>
  <footer>
    <p>Here's some contact info</p>
  </footer>
</div>
```

### `slot-scope` 属性によるスコープ付きスロット

> 2.6.0 以降では <abbr title="すべての Vue 2.x バージョンでは引き続きサポートされますが、推奨されていません。">非推奨</abbr>。推奨される新しい構文については、[こちら](#スコープ付きスロット) を参照。

スロットに渡されたプロパティを受け取るには、親コンポーネントは `<template>` に対して `slot-scope` 属性を使えます (例として、[ここ](#スコープ付きスロット) で説明した `<slot-example>` を使用):

``` html
<slot-example>
  <template slot="default" slot-scope="slotProps">
    {{ slotProps.msg }}
  </template>
</slot-example>
```

ここで、`slot-scope` はプロパティを受け取るオブジェクトを `slotProps` 変数として宣言し、`<template>` の中で利用できるようにしています。JavaScript の関数引数の名前と同じように、`slotProps` の代わりに好きな名前を使うことができます。

`slot="default"` は省略することもできます:

``` html
<slot-example>
  <template slot-scope="slotProps">
    {{ slotProps.msg }}
  </template>
</slot-example>
```

`slot-scope` 属性は、`<template>` 要素以外 (コンポーネントも含む) に対して直接指定することもできます:

``` html
<slot-example>
  <span slot-scope="slotProps">
    {{ slotProps.msg }}
  </span>
</slot-example>
```

`slot-scope` の値は、関数定義の引数部分で有効な任意の JavaScript 式を受け付けることができます。これは、サポートされている環境 ([単一ファイルコンポーネント](single-file-components.html) または [モダンブラウザ](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment#%E3%83%96%E3%83%A9%E3%82%A6%E3%82%B6%E3%83%BC%E5%AE%9F%E8%A3%85%E7%8A%B6%E6%B3%81)) では、式に [ES2015 の分割代入](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment#object_destructuring) が使えることを意味します:

``` html
<slot-example>
  <span slot-scope="{ msg }">
    {{ msg }}
  </span>
</slot-example>
```

[ここ](#その他の例) で説明した `<todo-list>` を例にすると、`slot-scope` で同等のことをするには次のようにします:

``` html
<todo-list v-bind:todos="todos">
  <template slot="todo" slot-scope="{ todo }">
    <span v-if="todo.isComplete">✓</span>
    {{ todo.text }}
  </template>
</todo-list>
```
