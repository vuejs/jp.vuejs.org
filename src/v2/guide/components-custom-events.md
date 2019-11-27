---
title: カスタムイベント
updated: 2018-10-24
type: guide
order: 103
---

> このページは [コンポーネントの基本](components.html) を読まれていることが前提になっています。コンポーネントを扱った事のない場合はこちらのページを先に読んでください。

<div class="vueschool"><a href="https://vueschool.io/lessons/communication-between-components?friend=vuejs" target="_blank" rel="sponsored noopener" title="Learn how to work with custom events on Vue School">Learn how to work with custom events in a free Vue School lesson</a></div>

## イベント名

コンポーネントやプロパティとは違い、イベント名の大文字と小文字は自動的に変換されません。その代わり発火されるイベント名とイベントリスナ名は全く同じにする必要があります。例えばキャメルケース(camelCase)のイベント名でイベントを発火した場合:

```js
this.$emit('myEvent')
```

ケバブケース(kebab-case)でリスナ名を作っても何も起こりません：

```html
<!-- 動作しません -->
<my-component v-on:my-event="doSomething"></my-component>
```

コンポーネントやプロパティとは違い、イベント名は JavaScript 内で変数やプロパティ名として扱われることはないので、キャメルケース(camelCase)やパスカルケース(PascalCase)を使う理由はありません。さらに DOM テンプレート内の `v-on` イベントリスナは自動的に小文字に変換されます (HTML が大文字と小文字を判別しないため)。このため `v-on:myEvent` は `v-on:myevent` になり `myEvent` にリスナが反応することができなくなります。

こういった理由から **いつもケバブケース(kebab-case)を使うこと** をお薦めします。

## `v-model` を使ったコンポーネントのカスタマイズ

> 2.2.0から新規追加

デフォルトではコンポーネントにある `v-model` は `value` をプロパティとして、`input` をイベントして使いますが、チェックボックスやラジオボタンなどのインプットタイプは `value` 属性を[別の目的](
https://developer.mozilla.org/ja/docs/Web/HTML/Element/input/checkbox#Value)で使う事があります。`model` オプションを使うことでこういった衝突を回避する事ができます。

```js
Vue.component('base-checkbox', {
  model: {
    prop: 'checked',
    event: 'change'
  },
  props: {
    checked: Boolean
  },
  template: `
    <input
      type="checkbox"
      v-bind:checked="checked"
      v-on:change="$emit('change', $event.target.checked)"
    >
  `
})
```

このコンポーネントで `v-model` を使う場合：

```html
<base-checkbox v-model="lovingVue"></base-checkbox>
```

`lovingVue` の値が `checked` プロパティに渡ります。 `<base-checkbox>` が `change` イベントを新しい値で発火した時に `lovingVue` プロパティが更新されます。

<p class="tip"><code>checked</code>プロパティをコンポーネント内の <code>プロパティ</code> オプション内でも宣言する必要がある事を注意してください。</p>

## コンポーネントにネイティブイベントをバインディング

コンポーネントのルート要素にあるネイティブイベントを購読したい場合もあるかもしれません。こういった場合は `.native` 修飾子を `v-on` に付けてください。

```html
<base-input v-on:focus.native="onFocus"></base-input>
```

このやり方が役に立つこともありますが、`<input>` など特定の要素を購読したい場合はあまりいいやり方ではありません。例えば上にある `<base-input>` コンポーネントがリファクタリングされた場合、元要素は `<label>` 要素になってしまうかもしれません：

```html
<label>
  {{ label }}
  <input
    v-bind="$attrs"
    v-bind:value="value"
    v-on:input="$emit('input', $event.target.value)"
  >
</label>
```

このような場合は親にある `.native` リスナは静かに動作しなくなります。エラーは何も出力されませんが、`onFocus` ハンドラが呼ばれるはずの時に呼ばれなくなります。

この問題を解決するために Vue は `$listeners` というコンポーネントで使えるリスナオブジェクトの入ったプロパティを提供しています。例えば：

```js
{
  focus: function (event) { /* ... */ }
  input: function (value) { /* ... */ },
}
```

`$listeners` プロパティを使うことで、コンポーネントの全てのイベントリスナを `v-on="$listeners"` を使って特定の子要素に送ることができます、`<input>` の様な要素の場合は `v-model` を使って動作させたいでしょう。以下の `inputListeners` の様に新しい算出プロパティを作った方が便利なことも多いです。

```js
Vue.component('base-input', {
  inheritAttrs: false,
  props: ['label', 'value'],
  computed: {
    inputListeners: function () {
      var vm = this
      // `Object.assign` が複数のオブジェクトを一つの新しいオブジェクトにマージします
      return Object.assign({},
        // 親からの全てのリスナを追加します
        this.$listeners,
        // そしてカスタムリスナを追加したり
        // すでに存在するリスナの振る舞いを変えることができます
        {
          // こうすることでコンポーネントが v-model と動作します
          input: function (event) {
            vm.$emit('input', event.target.value)
          }
        }
      )
    }
  },
  template: `
    <label>
      {{ label }}
      <input
        v-bind="$attrs"
        v-bind:value="value"
        v-on="inputListeners"
      >
    </label>
  `
})
```

`<base-input>` コンポーネントが **完全に透過的なラッパ** として扱えるようになったため、普通の `<input>` 要素と全く同じように使うことができるようになりました。`.native` 修飾子なしで全ての同じ要素とリスナが動作します。

## `.sync` 修飾子

> 2.3.0から新規追加

"双方向バインディング"がプロパティに対して必要な場合もあります。残念ながら、本当の双方向バインディングはメンテナンスの問題を引き起こす可能性があります。子コンポーネントは親でも子でもその変更元が明らかでなくても親を変更させることができるからです。

このため代わりに `update:myPropName` というパターンでイベントを発火させる事をお薦めします。例えば `title` というプロパティを持つ仮のコンポーネントがあった場合、意図的に新しい値を割り当てる事ができます

```js
this.$emit('update:title', newTitle)
```

こうする事で、必要な場合、親がこのイベントを購読し、ローカルデータプロパティを更新することができます。例えば:

```html
<text-document
  v-bind:title="doc.title"
  v-on:update:title="doc.title = $event"
></text-document>
```

このパターンを `.sync` 修飾子で短く書くことができます：

```html
<text-document v-bind:title.sync="doc.title"></text-document>
```

<p class="tip"><code>v-bind</code> に <code>.sync</code> 修飾子をつける場合は式を指定しても<strong>動作しない</strong>ことに注意してください (例: <code>v-bind:title.sync="doc.title + '!'"</code> は無効です)。そうではなく、 <code>v-model</code> と同様にバインドしたいプロパティ名のみを指定してください。</p>

`.sync` 修飾子を `v-bind` に付けることでオブジェクトを使って複数のプロパティを一度にセットする事ができます：

```html
<text-document v-bind.sync="doc"></text-document>
```

こうする事で `doc` オブジェクト内の各プロパティ (例えば `title`) がひとつのプロパティとして渡され、`v-on` アップデートリスナがそれぞれに付けられます。

<p class="tip"><code>v-bind.sync</code> を<code>v-bind.sync="{ title: doc.title }"</code> などの様に文字列オブジェクトと一緒に使う場合、こういった複雑な表現をパースする際に様々なケースが考えられるのでうまく動作しません。</p>
