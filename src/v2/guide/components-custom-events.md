---
title: カスタムイベント
type: guide
order: 103
---

> ⚠️注意: この内容は原文のままです。現在翻訳中ですのでお待ち下さい。🙏

> このページは [コンポーネントの基本](components.html) を読まれていることが前提になっています。コンポーネントを扱った事のない場合はそちらのページを先に読んでください。

## イベント名

コンポーネントや props とは違い、イベント名の大文字と小文字は自動的に変換されません。その代わり放出されるイベント名とイベントリスナ名は全く同じにする必要があります。例えばキャメルケース(camelCase)のイベント名でイベントを放出した場合:

```js
this.$emit('myEvent')
```

ケバブケース(kebab-case)でリスナ名を作っても何も起こりません：

```html
<my-component v-on:my-event="doSomething"></my-component>
```

コンポーネントや props とは違い、イベント名は Javascript 内で変数やプロパティ名として扱われることはないので、キャメルケース(camelCase)やパスカルケース(PascalCase)を使う理由はありません。さらに DOM テンプレート内の `v-on` イベントリスナは自動的に小文字に変換されます (HTML が大文字と小文字を判別しないため)。このため `v-on:myEvent` は `v-on:myevent` になり `myEvent` にリスナが反応することができなくなります。

こういった理由から ** いつもケバブケース(kebab-case)を使うこと ** をお薦めします。

## `v-model` を使ってコンポーネントのカスタマイズ

> 2.2.0+からの新しい機能

デフォルトではコンポーネントに対する `v-model` は `value` を prop として、`input` をイベントして使いますが、チェックボックスやラジオボタンなどのインプットタイプは `value` 属性を[別の目的](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/checkbox#Value)で使う事があります。`model` オプションを使うことでこういった衝突を回避する事ができます。

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

```js
<base-checkbox v-model="lovingVue"></base-checkbox>
```

`lovingVue` の値が `checked` prop に渡ります。 `<base-checkbox>`　が `change` イベントを新しい値で発火した時に `lovingVue` プロパティが更新されます。

<p class="tip"><code>checked</code> prop をコンポーネント内の <code>props</code> オプションで宣言する必要があるのに注意してください</p>

## コンポーネントにネイティブイベントをバインディングする

コンポーネントの元要素にあるネイティブイベントを購読したい場合もあるかもしれません。こういった場合は `.native` 修飾子を `v-on` に付けてください。

```html
<base-input v-on:focus.native="onFocus"></base-input>
```

このやり方が役に立つこともありますが、`<input>` など特定の要素に購読したい場合はあまりいいやり方ではありません。例えば上にある `<base-input>` コンポーネントがリファクタリングされた場合、元要素は `<label>` 要素になってしまうかもしれません：

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

この問題を解決するために Vue は `$listeners` というリスナオブジェクトの入ったプロパティを提供しています。例えば：

```js
{
  focus: function (event) { /* ... */ }
  input: function (value) { /* ... */ },
}
```

'$listeners' プロパティを使うことで、コンポーネントの全てのイベントリスナを `v-on="$listeners"` を使って特定の子要素に送ることができます、`<input>` の様な要素の場合は `v-model` を使ったほうがいいでしょう。以下の `inputListeners` の様に新しい computed プロパティを作った方が便利なことも多いです。

```js
Vue.component('base-input', {
  inheritAttrs: false,
  props: ['label', 'value'],
  computed: {
    inputListeners: function () {
      var vm = this
      // `Object.assign` merges objects together to form a new object
      return Object.assign({},
        // We add all the listeners from the parent
        this.$listeners,
        // Then we can add custom listeners or override the
        // behavior of some listeners.
        {
          // This ensures that the component works with v-model
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

`<base-input>` コンポーネントが **完全に透明なラッパ** として扱えるようになったため、普通の `<input>` 要素と全く同じように使うことができるようになりました。全ての同じ要素とリスナが動作します。

## `.sync` 修飾子

> 2.3.0+からの新しい機能

"双方向バインディング"が prop に対して必要な場合もあります。変更ポイントの元が子コンポーネントと親コンポーネントに対して明確にならない状態で子コンポーネントが親コンポーネントを変更してしまうことがあるため、残念ながら本当の双方向バインディングを行うとメンテナンスで問題が発生します。

このため代わりに `update:my-prop-name` というパターンでイベントを発火させる事をお薦めします。例えば `title` というコンポーネントがあった場合に新しい値を割り当てる事ができます

```js
this.$emit('update:title', newTitle)
```

Then the parent can listen to that event and update a local data property, if it wants to. For example:

こうする事で親がこのイベントに購読できるようになり、ローカルデータプロパティを更新します。この様な事をした場合例えば：

```html
<text-document
  v-bind:title="doc.title"
  v-on:update:title="doc.title = $event"
></text-document>
```

For convenience, we offer a shorthand for this pattern with the `.sync` modifier:

このパターンを `.sync` 修飾子で短く書くことができます：

```html
<text-document v-bind:title.sync="doc.title"></text-document>
```

The `.sync` modifier can also be used with `v-bind` when using an object to set multiple props at once:

`.sync` 修飾子を `v-bind` に付けることでオブジェクトを使って複数の props を一度にセットする事がでっきます：

```html
<text-document v-bind.sync="doc"></text-document>
```

This passes each property in the `doc` object (e.g. `title`) as an individual prop, then adds `v-on` update listeners for each one.

こうする事で `doc` オブジェクト内の各プロパティ (例えば `title`) がひとつの prop として渡され、`v-on` アップデートリスナがそれぞれに付けられます。

<p class="tip">Using <code>v-bind.sync</code> with a literal object, such as in <code>v-bind.sync="{ title: doc.title }"</code>, because there are simply too many edge cases to consider in parsing a complex expression like this.</p>

<p class="tip"><code>v-bind.sync</code> を<code>v-bind.sync="{ title: doc.title }"</code> などの様に文字列オブジェクトと一緒に使う場合、こういった複雑な表現をパースする際に様々なケースが考えられます。</p>
