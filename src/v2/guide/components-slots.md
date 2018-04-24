---
title: スロット
type: guide
order: 104
---


> このページは[コンポーネントの基本](components.html)を読んでいることを前提に書かれています。もしコンポーネントに習熟していない場合は、まずはそちらを読むことをお勧めします。

## スロットコンテンツ

Vue は現在の[Web Components spec draft](https://github.com/w3c/webcomponents/blob/gh-pages/proposals/Slots-Proposal.md)にならったコンテンツ配信APIが実装されており、 `<slot>` 要素をコンテンツ配信の受け渡し口として利用します。

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

コンポーネントが描画される時、 `<slot>` 要素は "Your Profile" に置換されるでしょう。スロットには HTML を含む任意のテンプレートを入れることが出来ます:

``` html
<navigation-link url="/profile">
  <!-- Font Awesome のアイコンを追加 -->
  <span class="fa fa-user"></span>
  Your Profile
</navigation-link>
```

または、他のコンポーネントも入れることも出来ます:

``` html
<navigation-link url="/profile">
  <!-- コンポーネントを使ってアイコンを追加 -->
  <font-awesome-icon name="user"></font-awesome-icon>
  Your Profile
</navigation-link>
```

もし `<navigation-link>` が `<slot>` 要素を含んでい**ない**場合、どんなコンテンツが渡されてもただ無視されるでしょう。

## 名前付きスロット

複数のスロットがあると便利なときもあります。例えば、仮に `base-layout` コンポーネントが下記のようなテンプレートであるとしましょう:

``` html
<div class="container">
  <header>
    <!-- ヘッダコンテンツをここに挿入したい -->
  </header>
  <main>
    <!-- メインコンテンツをここに挿入したい -->
  </main>
  <footer>
    <!-- フッターコンテンツをここに挿入したい -->
  </footer>
</div>
```

こういった場合のために、 `<slot>` 要素は `name` という特別な属性を持っていて、追加でスロットを定義できます。

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

名前付きスロットにコンテンツを渡すために、 `slot` 属性を含んだ `template` 要素を利用することが出来ます。

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

もしくは、要素に直接 `slot` 属性を指定することもできます:

``` html
<base-layout>
  <h1 slot="header">Here might be a page title</h1>

  <p>A paragraph for the main content.</p>
  <p>And another one.</p>

  <p slot="footer">Here's some contact info</p>
</base-layout>
```

その上で名前無しのスロットを引き続き使うこともでき、**デフォルトスロット**として、マッチしなかった全ての要素を受け取る受け渡し口となります。上記の例はどちらも以下のようなHTMLにレンダリングされるでしょう:

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

## デフォルトスロットコンテンツ

デフォルトのコンテンツを持ったスロットがあると便利な場合もあります。例えば `<submit-button>` コンポーネントはデフォルトでは "Submit" ボタンの文言にすると良いでしょう。しかし、ユーザが "Save" や "Upload" など他の文言に上書き出来るのもまた良いでしょう。

これを実現するためには、`slot` タグの中にデフォルトコンテンツを記述してください。

```html
<button type="submit">
  <slot>Submit</slot>
</button>
```

もし親からコンテンツが提供されていた場合、デフォルトコンテンツを置き換えます。

## コンパイルスコープ

スロットの中でデータを取り扱いたい場合はこうします:

``` html
<navigation-link url="/profile">
  Logged in as {{ user.name }}
</navigation-link>
```

そのスロットはテンプレートの残りの部分と同じインスタンスプロパティ(つまり同じ"スコープ")にアクセスできます。 `<navigation-link>` のスコープにアクセスすることは**できません**。例えば、 `url` へのアクセスは動作しないでしょう。ルールとして以下を覚えてください:

> 親テンプレート内の全てのものは親のスコープでコンパイルされ、子テンプレート内の全てものは子のスコープでコンパイルされる

## スコープ付きスロット

> 2.1.0から新規追加

ときどき子コンポーネントからデータにアクセスできる再利用可能なスロットを提供したいでしょう。例えば、シンプルな `<todo-list>` コンポーネントはそのテンプレートで以下のようにしたいかもしれません。

```html
<ul>
  <li
    v-for="todo in todos"
    v-bind:key="todo.id"
  >
    {{ todo.text }}
  </li>
</ul>
```

しかしアプリケーションのいくつかの部分では、それぞれの todo アイテムがただの `todo.text` とは違うものをレンダリングすることを求めます。そういった場合がスコープ付きスロットの出番です。

この機能を実現するために行わなければならないことは、todo アイテムのコンテンツを `<slot>` 要素で囲うことで、スロットに対してコンテキストに関連した全てのデータを渡すことです: この場合は `todo` オブジェクトです:


```html
<ul>
  <li
    v-for="todo in todos"
    v-bind:key="todo.id"
  >
    <!-- それぞれの todo に対してスロットがあり、 `todo` オブジェクトを -->
    <!-- スロットのプロパティとして渡している                           -->
    <slot v-bind:todo="todo">
      <!-- フォールバックコンテンツ -->
      {{ todo.text }}
    </slot>
  </li>
</ul>
```

この `<todo-list>` コンポーネントを利用する時、`slot-scope` 属性を使うことで、子からデータにアクセスすること無しに todo アイテムに代替となる `<template>` を定義することができます

```html
<todo-list v-bind:todos="todos">
  <!-- スロットスコープの名前として `slotProps` を定義してください。 -->
  <template slot-scope="slotProps">
    <!-- todo アイテムに対してカスタムテンプレートを定義して、`slotProps` を -->
    <!-- 使ってそれぞれの todo をカスタマイズしてください。                   -->
    <span v-if="slotProps.todo.isComplete">✓</span>
    {{ slotProps.todo.text }}
  </template>
</todo-list>
```

> 2.5.0 以降では、`slot-scope` はもはや `<template>` に限定されず、どの要素やコンポーネントでも使用できます。

### `slot-scope` の分割代入

`slot-scope` の値は実際には関数定義の引数位置に表示できる有効な JavaScript式を受け入れます。これはサポートされている環境 ([単一ファイルコンポーネント](single-file-components.html) または [モダンブラウザ](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment#Browser_compatibility)) では[ES2015 分割代入](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment#Object_destructuring)を式の中で下記のように利用できることを意味します:

```html
<todo-list v-bind:todos="todos">
  <template slot-scope="{ todo }">
    <span v-if="todo.isComplete">✓</span>
    {{ todo.text }}
  </template>
</todo-list>
```

これはスコープ付きスロットを少しだけきれいにする素晴らしい方法です。
