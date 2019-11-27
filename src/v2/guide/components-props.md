---
title: プロパティ
updated: 2019-02-24
type: guide
order: 102
---

> このページは、[コンポーネントの基本](components.html)を読んでいることを前提としています。はじめてコンポーネントについて読む場合は、まずはそちらをお読みください。

<div class="vueschool"><a href="https://vueschool.io/lessons/reusable-components-with-props?friend=vuejs" target="_blank" rel="sponsored noopener" title="Learn how component props work with Vue School">Learn how component props work with a free lesson on Vue School</a></div>

## プロパティの形式 (キャメルケース vs ケバブケース)

HTML の属性名は大文字小文字を区別せず、ブラウザは全ての大文字を小文字として解釈します。つまりは、 DOM(HTML) のテンプレート内においては、キャメルケースのプロパティはケバブケース(ハイフンで区切ったもの)を使用する必要があります。

``` js
Vue.component('blog-post', {
  // JavaScript 内ではキャメルケース
  props: ['postTitle'],
  template: '<h3>{{ postTitle }}</h3>'
})
```

``` html
<!-- HTML 内ではケバブケース -->
<blog-post post-title="hello!"></blog-post>
```

文字列テンプレートを利用している場合も、この制限は適用されません。

## プロパティの型

ここまででは、プロパティを、プロパティ名の文字列として列挙してきました。

```js
props: ['title', 'likes', 'isPublished', 'commentIds', 'author']
```

しかしながら、通常は全てのプロパティの属性を、特定の型の値にしたいと考えることでしょう。そのような場合、プロパティーのキーと値に、それぞれのプロパティ名と型を設定したオブジェクトの配列として、プロパティを列挙することができます:

```js
props: {
  title: String,
  likes: Number,
  isPublished: Boolean,
  commentIds: Array,
  author: Object,
  callback: Function,
  contactsPromise: Promise // or any other constructor
}
```

これは、コンポーネントへのドキュメンテーションだけでなく、間違った型を渡した場合に、ブラウザの JavaScript コンソールにて警告をします。詳しくはこのページの下にある[type checks and other prop validations](#プロパティのバリデーション) にて説明します。

## 静的あるいは動的なプロパティの受け渡し

これまでは、このような形でプロパティが静的な値を渡しているところも見てきましたが:

```html
<blog-post title="My journey with Vue"></blog-post>
```

次のような `v-bind` で動的に割り当てられたプロパティも見てきました:

```html
<!-- 変数の値を動的に割り当てます -->
<blog-post v-bind:title="post.title"></blog-post>

<!-- 複数の変数を合成した値を動的に割り当てます -->
<blog-post
  v-bind:title="post.title + ' by ' + post.author.name"
></blog-post>
```

上の 2 つの例では、文字列の値を渡していますが、プロパティには __任意の__ 型の値を渡すことが可能です。

### 数値の受け渡し

```html
<!-- `42` が静的な値であっても、 Vue へとそれを伝えるには v-bind が必要です。 -->
<!-- これは文字列ではなく、 JavaScript の式となります。                    -->
<blog-post v-bind:likes="42"></blog-post>

<!-- 変数の値を動的に割り当てています。 -->
<blog-post v-bind:likes="post.likes"></blog-post>
```

### 真偽値の受け渡し

```html
<!-- 値のないプロパティは、 `true` を意味することとなります。 -->
<blog-post is-published></blog-post>

<!-- `false` が静的な値であっても、 Vue へとそれを伝えるには v-bind が必要です。 -->
<!-- これもまた、文字列ではなく JavaScript の式となります。                        -->
<blog-post v-bind:is-published="false"></blog-post>

<!-- 変数の値を動的に割り当てています。 -->
<blog-post v-bind:is-published="post.isPublished"></blog-post>
```

### 配列の受け渡し

```html
<!-- 配列が静的な値であっても、 Vue へとそれを伝えるには v-bind が必要です。 -->
<!-- これもまた、文字列ではなく JavaScript の式となります。               -->
<blog-post v-bind:comment-ids="[234, 266, 273]"></blog-post>

<!-- 変数の値を動的に割り当てています。 -->
<blog-post v-bind:comment-ids="post.commentIds"></blog-post>
```

### オブジェクトの受け渡し

```html
<!-- オブジェクトが静的な値であっても、 Vue へとそれを伝えるには v-bind が必要です。 -->
<!-- これもまた、文字列ではなく JavaScript の式となります。                      -->
<blog-post
  v-bind:author="{
    name: 'Veronica',
    company: 'Veridian Dynamics'
  }"
></blog-post>

<!-- 変数の値を動的に割り当てています。 -->
<blog-post v-bind:author="post.author"></blog-post>
```

### オブジェクトのプロパティの受け渡し

オブジェクトの全てのプロパティをコンポーネントのプロパティ(props)として渡したい場合は、`v-bind` を引数無しで使うことができます(`v-bind:prop-name` の代わりに `v-bind` を使用). 例えば、 `post` オブジェクトの場合:

``` js
post: {
  id: 1,
  title: 'My Journey with Vue'
}
```

次のテンプレートは:

``` html
<blog-post v-bind="post"></blog-post>
```

以下と同等となります:

``` html
<blog-post
  v-bind:id="post.id"
  v-bind:title="post.title"
></blog-post>
```

## 単方向のデータフロー

全てのプロパティは、子プロパティと親プロパティの間に、 **単方向のバインディング** を形成します: 親のプロパティが更新されると、子へと流れ落ちていきますが、それ以外の方法でデータが流れることはありません。これによって、子コンポーネントが誤って親の状態を変更することがなく、これによって、アプリのデータフローを **理解しづらい** 可能性のある子コンポーネントによる誤った親の状態変更から、防ぎます。

また、親コンポーネントが更新されるたびに、子コンポーネント内の全てのプロパティが最新の値へと更新されます。これは、子コンポーネント内において、プロパティを **変化させない** ことを意味しています。それを行った場合、 Vue は コンソールにて警告します。

多くの場合、プロパティの値を変化させたい場合には、 2 つのケースがあります:

1. **プロパティを初期値として受け渡し、子コンポーネントにてローカルのデータとして後で利用したいと考える場合** この場合、プロパティの値をローカルの data の初期値として定義することを推奨します:

  ``` js
  props: ['initialCounter'],
  data: function () {
    return {
      counter: this.initialCounter
    }
  }
  ```

2. **プロパティを未加工の値として渡す場合** この場合、プロパティの値を使用した算出プロパティを別途定義することを推奨します:

  ``` js
  props: ['size'],
  computed: {
    normalizedSize: function () {
      return this.size.trim().toLowerCase()
    }
  }
  ```

<p class="tip">JavaScript のオブジェクトと配列は、参照渡しされることに注意してください。参照として渡されるため、子コンポーネント内で配列やオブジェクトを変更すると、 **親の状態へと影響します。**</p>

## プロパティのバリデーション

コンポーネントは、プロパティに対して既存の型などの要件を指定することができます。もし指定した要件が満たされない場合、 Vue はブラウザの JavaScript コンソールにて警告します。これは、他の人が利用することを意図したコンポーネントを開発する場合に、特に便利です。

プロパティへのバリデーションは、文字列の配列の代わりに、 `props` の値へとバリデーションの条件をもったオブジェクトを渡すことで指定できます。 例えば以下のようなものです:

``` js
Vue.component('my-component', {
  props: {
    // 基本的な型の検査 (`null` と `undefined` は全てのバリデーションにパスします)
    propA: Number,
    // 複数の型の許容
    propB: [String, Number],
    // 文字列型を必須で要求する
    propC: {
      type: String,
      required: true
    },
    // デフォルト値つきの数値型
    propD: {
      type: Number,
      default: 100
    },
    // デフォルト値つきのオブジェクト型
    propE: {
      type: Object,
      // オブジェクトもしくは配列のデフォルト値は
      // 必ずそれを生み出すための関数を返す必要があります。
      default: function () {
        return { message: 'hello' }
      }
    },
    // カスタマイズしたバリデーション関数
    propF: {
      validator: function (value) {
        // プロパティの値は、必ずいずれかの文字列でなければならない
        return ['success', 'warning', 'danger'].indexOf(value) !== -1
      }
    }
  }
})
```

プロパティのバリデーションが失敗した場合、 Vue はコンソールにて警告します (開発用ビルドを利用しているとき)。

<p class="tip">プロパティのバリデーションはコンポーネントのインスタンスが生成される **前** に行われるため、インスタンスのプロパティ (例えば `data`, `computed` など) を `dafault` および `validator` 関数の中で利用することはできません。</p>

### 型の検査

`type` は、次のネイティブコンストラクタのいずれかです:

- String
- Number
- Boolean
- Array
- Object
- Date
- Function
- Symbol

さらに、 `type` はカスタムコンストラクタ関数でもあり、 `instanceof` によるアサーションを行います。例えば、以下のコンストラクタ関数が存在すると仮定したとき:

```js
function Person (firstName, lastName) {
  this.firstName = firstName
  this.lastName = lastName
}
```

このように利用することができます:

```js
Vue.component('blog-post', {
  props: {
    author: Person
  }
})
```

`author` プロパティの値が、 `new Person` によって作成されたものと検証できました。

## プロパティでない属性

プロパティでない属性は、属性としてコンポーネントに受け渡されますが、対応するプロパティは定義されていません。

子コンポーネントへと情報を渡す場合には、明示的に定義されたプロパティが好まれますが、コンポーネントライブラリの作成者には、コンポーネントが使用されうるコンテキストを必ずしも把握できるわけではありません。そのため、コンポーネントは、そのルートに対して追加される任意の属性を受け入れます。

例えば、サードパーティの `bootstrap-date-input` コンポーネントを用いて `data-date-picker` 属性を要求する Bootstrap プラグインを使っているとします。その場合、その属性をコンポーネントのインスタンスに追加できます:

``` html
<bootstrap-date-input data-date-picker="activated"></bootstrap-date-input>
```

また、 `data-date-picker="activated"` 属性は、自動的に `bootstrap-date-input` のルート属性へと追加されます。

### 既存の属性への置換とマージ

これが `bootstrap-date-input` 側のテンプレートとします:

``` html
<input type="date" class="form-control">
```

この日付プラグインのテーマを指定するには、以下のような特定のクラスを追加する必要があります:

``` html
<bootstrap-date-input
  data-date-picker="activated"
  class="date-picker-theme-dark"
></bootstrap-date-input>
```

こういった場合、異なる2つのクラスが定義されています:

- `form-control` はコンポーネント自身のテンプレート内で定義されています
- `date-picker-theme-dark` は、親コンポーネントによって受け渡されます

ほとんどの属性においては、コンポーネント側の値が、コンポーネントに受け渡された値へと置換されます。たとえば、 `type="text"` を渡すと、 `type="date"` は置き換えられ、そして壊れてしまうでしょう！幸運なことに、 `class` および `style` 属性は少しスマートに作られていますので、両方の値がマージされ、最終的な値は `form-control date-picker-theme-dark` となります。

### 属性の継承の無効化

コンポーネントのルート要素に対して、属性を継承させたく **ない** 場合は、コンポーネントのオプション内にて `inheritAttrs: false` を設定できます。例:

```js
Vue.component('my-component', {
  inheritAttrs: false,
  // ...
})
```

これは、 コンポーネントの `$attrs` インスタンスプロパティと組み合わせる時に特に便利です。 `$attrs` は、コンポーネントに渡される属性名およびその値が含まれています :

```js
{
  required: true,
  placeholder: 'Enter your username'
}
```

`inheritAttrs: false` と `$attrs` を併用すると、どの要素に属性を送るかを手動で決定することができます。これは、 [基底コンポーネント](../style-guide/#基底コンポーネントの名前-強く推奨) の利用においてはしばしば望ましいことがあります:

```js
Vue.component('base-input', {
  inheritAttrs: false,
  props: ['label', 'value'],
  template: `
    <label>
      {{ label }}
      <input
        v-bind="$attrs"
        v-bind:value="value"
        v-on:input="$emit('input', $event.target.value)"
      >
    </label>
  `
})
```

<p class="tip">`inheritAttrs: false` オプションは、`style` および `class` 属性のバインディングには影響 **しない** ことに注意してください。</p>

このパターンを使用すると、ルート上にある要素を気にすることなく、生の HTML 要素のように基底コンポーネントを利用できます。

```html
<base-input
  v-model="username"
  required
  placeholder="Enter your username"
></base-input>
```
