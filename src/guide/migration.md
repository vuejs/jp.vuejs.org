---
title: Vue 1.xからの移行
type: guide
order: 24
---

## FAQ

> わお、このページは非常に長いですね！ということは、バージョン 2.0 は従来と全く異なっていて、私は全てを基礎からもう一度学ぶ必要があるのでしょう。その上で、移行は不可能ということでしょうか？

よくぞ聞いてくれました！その答えは No です。 API のおおよそ 90% が同じで、かつ基本となるコンセプトは変わっていません。 このセクションは、非常に詳しい説明と、多くの例を提供したいため、非常に長いです。 ですが、安心してください、 __このセクションは、上から下まで全て読むようなものではありません！__

> どこから移行をはじめるべきですか？

1. 現在のプロジェクト上で、[マイグレーションヘルパ](https://github.com/vuejs/vue-migration-helper)を実行します。
[ ] We've carefully minified and compressed a senior Vue dev into a simple command line interface.
そしてそれは、非推奨のパターンを認識するたびに、移行をサジェストし、そして詳しい情報へのリンクを提供します。

2. その後、このページのサイドバーの目次より、あなたが影響を受ける可能性のあるトピックを参照してください。移行ヘルパーが何もキャッチしていない場合、それは素晴らしいことです。

3. もし、テストがある場合は、それらを実行し、失敗したものを参照してください。テストがない場合は、ブラウザ上でアプリケーションを開き、警告やエラーに対して、あなた自身の目を光らせてください。

4. そろそろ、あなたのアプリケーションは完全に移行されるべきでしょう。もし、あなたがよりいっそう飢えている場合は、このページを残りの部分を読む、もしくは新しく、かつ改良されたガイドに [the beginning](index.html) から飛び込むこともできます。あなたは既に基本となるコンセプトに精通しているので、多くの場合、拾い読みすることとなります。

> Vue 1.x のアプリケーションを 2.0 に移行するにはどのくらいの時間がかかりますか？

移行期間は、いくつかの要因に依存します:

- アプリケーションの規模（小〜中規模アプリケーションの場合、おそらく1日未満となります）

- How many times you get distracted and start playing with a cool new feature. 😉 &nbsp;Not judging, it also happened to us while building 2.0!

- Which deprecated features you're using. Most can be upgraded with find-and-replace, but others might take a few minutes. If you're not currently following best practices, Vue 2.0 will also try harder to force you to. This is a good thing in the long run, but could also mean a significant (though possibly overdue) refactor.

> もし Vue 2 へアップグレードする場合、 Vuex および Vue-Router もアップグレードする必要がありますか？

Vue-Router 2 は、 Vue 2 のみに互換性があるため、その答えは yes です、同様に、 [migration path for Vue-Router](migration-vue-router.html) に従う必要があります。
幸いなことに、ほとんどのアプリケーションは、ルーターに関するコードが多くないため、この作業が1時間以上かかることはおそらくありません。
Only Vue-Router 2 is compatible with Vue 2, so yes, you'll have to follow the [migration path for Vue-Router](migration-vue-router.html) as well. Fortunately, most applications don't have a lot of router code, so this likely won't take more than an hour.

Vuex については、バージョン 0.8 は Vue 2 との互換性があるため、アップグレードは強制ではありません。
[ ] The only reason you may want to upgrade immediately is to take advantage of the new features in Vuex 2, such as modules and reduced boilerplate.

## テンプレート

### フラグメントインスタンス <sup>非推奨</sup>

すべてのコンポーネントは、1つのルート要素を持っている必要があります。フラグメントインスタンスは、もはや許されません。もし、あなたが以下のようなテンプレートを使用している場合:

``` html
<p>foo</p>
<p>bar</p>
```

単に全体を新しい要素で囲うことを推奨します。  
例えばそれは、このような形となります:

``` html
<div>
  <p>foo</p>
  <p>bar</p>
</div>
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>アップグレード後に end-to-end のテストスイートやアプリケーションを実行し、テンプレート内の複数のルート要素に対してのコンソールの警告を探します。</p>
</div>
{% endraw %}

## ライフサイクルフック

### `beforeCompile` <sup>非推奨</sup>

代わりに、 `created` フックを使用します。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">マイグレーションヘルパ</a>を実行し、このフックを全て見つけます。</p>
</div>
{% endraw %}

### `compiled` <sup>非推奨</sup>

代わりに、新たに `mounted` フックを使用します。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">マイグレーションヘルパ</a>を実行し、このフックを全て見つけます。</p>
</div>
{% endraw %}

### `attached` <sup>非推奨</sup>

他のフックで DOM チェックをカスタムして使用します。 例えば、以下の場合:

``` js
attached: function () {
  doSomething()
}
```

このように置き換えます:

``` js
mounted: function () {
  this.$nextTick(function () {
    doSomething()
  })
}
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">マイグレーションヘルパ</a>を実行し、このフックを全て見つけます。</p>
</div>
{% endraw %}

### `detached` <sup>非推奨</sup>

他のフックで DOM チェックをカスタムして使用します。 例えば、以下の場合:

``` js
detached: function () {
  doSomething()
}
```

このように置き換えます:

``` js
destroyed: function () {
  this.$nextTick(function () {
    doSomething()
  })
}
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">マイグレーションヘルパ</a>を実行し、このフックを全て見つけます。</p>
</div>
{% endraw %}

### `init` <sup>非推奨</sup>

代わりに新しい `beforeCreate` フックを使用します。これは本質的には同じものです。これは、他のライフサイクルメソッドとの整合性のために改名されました。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">マイグレーションヘルパ</a>を実行し、このフックを全て見つけます。</p>
</div>
{% endraw %}

### `ready` <sup>非推奨</sup>

代わりに、新しい `mounted` を使用します。
Use the new `mounted` hook instead. It should be noted though that with `mounted`, there's no guarantee to be in-document. For that, also include `Vue.nextTick`/`vm.$nextTick`. For example:

``` js
mounted: function () {
  this.$nextTick(function () {
    // code that assumes this.$el is in-document
  })
}
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">マイグレーションヘルパ</a>を実行し、このフックを全て見つけます。</p>
</div>
{% endraw %}

## `v-for`

### 配列においての `v-for` の引数の順序

`index` を含む場合、引数を `(index, value)` の順序で使用していました。それは今は、 `(value, index)` となり、 JavaScript ネイティブの `forEach` や `map` と一致するようになりました。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of the deprecated argument order. Note that if you name your index arguments something unusual like <code>position</code> or <code>num</code>, the helper will not flag them.</p>
</div>
{% endraw %}

### オブジェクトにおいての `v-for` の引数の順序

`key` を含む場合、引数を `(key, value)` の順序で使用していました。それは今は、 `(value, key)` となり、 lodash などの一般的なオブジェクトのイテレータと一致するようになりました。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of the deprecated argument order. Note that if you name your key arguments something like <code>name</code> or <code>property</code>, the helper will not flag them.</p>
</div>
{% endraw %}

### `$index` および `$key` <sup>非推奨</sup>

暗黙的に割り当てられていた `$index` および `$key` 変数が、 `v-for` にて明示的にそれらを定義するために廃止されました。
これは、 Vue の経験が浅い開発者がネストされたループを扱う場合に、より明確に動作が発生するコードを読むことが容易になります。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of these deprecated variables. If you miss any, you should also see <strong>console errors</strong> such as: <code>Uncaught ReferenceError: $index is not defined</code></p>
</div>
{% endraw %}

### `track-by` <sup>非推奨</sup>

`track-by` は `key` に置き換えられました。

[x] `track-by` has been replaced with `key`,
[ ] which works like any other attribute: without the `v-bind:` or `:` prefix, it is treated as a literal string.
[ ] In most cases, you'd want to use a dynamic binding which expects a full expression instead of a key. For example, in place of:

``` html
<div v-for="item in items" track-by="id">
```

今はこう書きます:

``` html
<div v-for="item in items" v-bind:key="item.id">
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">マイグレーションヘルパ</a>を実行し、 <code>track-by</code> を見つけます。
</div>
{% endraw %}

### `v-for` Range Values

以前は、 `v-for="number in 10"` がもつ `number` は0ではじまり、9で終わっていましたが、1ではじまり10で終わるようになりました。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Search your codebase for the regex <code>/\w+ in \d+/</code>. Wherever it appears in a <code>v-for</code>, check to see if you may be affected.</p>
</div>
{% endraw %}

## Props

### `coerce` Prop オプション <sup>非推奨</sup>

If you want to coerce a prop, setup a local computed value based on it instead. For example, instead of:

``` js
props: {
  username: {
    type: String,
    coerce: function (value) {
      return value
        .toLowerCase()
        .replace(/\s+/, '-')
    }
  }
}
```

このように書きます:

``` js
props: {
  username: String,
},
computed: {
  normalizedUsername: function () {
    return this.username
      .toLowerCase()
      .replace(/\s+/, '-')
  }
}
```

これには、いくつかの利点があります:

- You still have access to the original value of the prop.
- You are forced to be more explicit, by giving your coerced value a name that differentiates it from the value passed in the prop.

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of the <code>coerce</code> option.</p>
</div>
{% endraw %}

### `twoWay` Prop オプション <sup>非推奨</sup>

Props are now always one-way down. To produce side effects in the parent scope, a component needs to explicitly emit an event instead of relying on implicit binding. For more information, see:

- [Custom component events](components.html#Custom-Events)
- [Custom input components](components.html#Form-Input-Components-using-Custom-Events) (using component events)
- [Global state managment](state-management.html)

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of the <code>twoWay</code> option.</p>
</div>
{% endraw %}

### `v-bind` への `.once` と `.sync` 修飾子 <sup>非推奨</sup>

Props are now always one-way down. To produce side effects in the parent scope, a component needs to explicitly emit an event instead of relying on implicit binding. For more information, see:

- [Custom component events](components.html#Custom-Events)
- [Custom input components](components.html#Form-Input-Components-using-Custom-Events) (using component events)
- [Global state managment](state-management.html)

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of the <code>.once</code> and <code>.sync</code> modifiers.</p>
</div>
{% endraw %}

### Prop Mutation <sup>非推奨</sup>

Mutating a prop locally is now considered an anti-pattern, e.g. declaring a prop and then setting `this.myProp = 'someOtherValue'` in the component. Due to the new rendering mechanism, whenever the parent component re-renders, the child component's local changes will be overwritten.

Most use cases of mutating a prop can be replaced by one of these options:

- a data property, with the prop used to set its default value
- a computed property

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run your end-to-end test suite or app after upgrading and look for <strong>console warnings</strong> about prop mutations.</p>
</div>
{% endraw %}

### Props on a Root Instance <sup>非推奨</sup>

On root Vue instances (i.e. instances created with `new Vue({ ... })`), you must use `propsData` instead instead of `props`.

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run your end-to-end test suite, if you have one. The <strong>failed tests</strong> should alert to you to the fact that props passed to root instances are no longer working.</p>
</div>
{% endraw %}

## Built-In Directives

### Truthiness/Falsiness with `v-bind`

When used with `v-bind`, the only falsy values are now: `null`, `undefined`, and `false`. This means `0` and empty strings will render as truthy. So for example, `v-bind:draggable="''"` will render as `draggable="true"`.

For enumerated attributes, in addition to the falsy values above, the string `"false"` will also render as `attr="false"`.

<p class="tip">Note that for other directives (e.g. `v-if` and `v-show`), JavaScript's normal truthiness still applies.</p>

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run your end-to-end test suite, if you have one. The <strong>failed tests</strong> should alert to you to any parts of your app that may be affected by this change.</p>
</div>
{% endraw %}

### Listening for Native Events on Components with `v-on`

When used on a component, `v-on` now only listens to custom events `$emit`ted by that component. To listen for a native DOM event on the root element, you can use the `.native` modifier. For example:

``` html
<my-component v-on:click.native="doSomething"></my-component>
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run your end-to-end test suite, if you have one. The <strong>failed tests</strong> should alert to you to any parts of your app that may be affected by this change.</p>
</div>
{% endraw %}

### `v-model` と `debounce` <sup>非推奨</sup>

Debouncing is used to limit how often we execute Ajax requests and other expensive operations. Vue's `debounce` attribute parameter for `v-model` made this easy for very simple cases, but it actually debounced __state updates__ rather than the expensive operations themselves. It's a subtle difference, but it comes with limitations as an application grows.

These limitations become apparent when designing a search indicator, like this one for example:

{% raw %}
<script src="https://cdn.jsdelivr.net/lodash/4.13.1/lodash.js"></script>
<div id="debounce-search-demo" class="demo">
  <input v-model="searchQuery" placeholder="Type something">
  <strong>{{ searchIndicator }}</strong>
</div>
<script>
new Vue({
  el: '#debounce-search-demo',
  data: {
    searchQuery: '',
    searchQueryIsDirty: false,
    isCalculating: false
  },
  computed: {
    searchIndicator: function () {
      if (this.isCalculating) {
        return '⟳ Fetching new results'
      } else if (this.searchQueryIsDirty) {
        return '... Typing'
      } else {
        return '✓ Done'
      }
    }
  },
  watch: {
    searchQuery: function () {
      this.searchQueryIsDirty = true
      this.expensiveOperation()
    }
  },
  methods: {
    expensiveOperation: _.debounce(function () {
      this.isCalculating = true
      setTimeout(function () {
        this.isCalculating = false
        this.searchQueryIsDirty = false
      }.bind(this), 1000)
    }, 500)
  }
})
</script>
{% endraw %}

Using the `debounce` attribute, there'd be no way to detect the "Typing" state, because we lose access to the input's real-time state. By decoupling the debounce function from Vue however, we're able to debounce only the operation we want to limit, removing the limits on features we can develop:

``` html
<!--
By using the debounce function from lodash or another dedicated
utility library, we know the specific debounce implementation we
use will be best-in-class - and we can use it ANYWHERE. Not just
in our template.
-->
<script src="https://cdn.jsdelivr.net/lodash/4.13.1/lodash.js"></script>
<div id="debounce-search-demo">
  <input v-model="searchQuery" placeholder="Type something">
  <strong>{{ searchIndicator }}</strong>
</div>
```

``` js
new Vue({
  el: '#debounce-search-demo',
  data: {
    searchQuery: '',
    searchQueryIsDirty: false,
    isCalculating: false
  },
  computed: {
    searchIndicator: function () {
      if (this.isCalculating) {
        return '⟳ Fetching new results'
      } else if (this.searchQueryIsDirty) {
        return '... Typing'
      } else {
        return '✓ Done'
      }
    }
  },
  watch: {
    searchQuery: function () {
      this.searchQueryIsDirty = true
      this.expensiveOperation()
    }
  },
  methods: {
    // This is where the debounce actually belongs.
    expensiveOperation: _.debounce(function () {
      this.isCalculating = true
      setTimeout(function () {
        this.isCalculating = false
        this.searchQueryIsDirty = false
      }.bind(this), 1000)
    }, 500)
  }
})
```

Another advantage of this approach is there will be times when debouncing isn't quite the right wrapper function. For example, when hitting an API for search suggestions, waiting to offer suggestions until after the user has stopped typing for a period of time isn't an ideal experience. What you probably want instead is a __throttling__ function. Now since you're already using a utility library like lodash, refactoring to use its `throttle` function instead takes only a few seconds.

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of the <code>debounce</code> attribute.</p>
</div>
{% endraw %}

### `v-model` への `lazy` or `number` Param Attributes <sup>非推奨</sup>

The `lazy` and `number` param attributes are now modifiers, to make it more clear what That means instead of:

``` html
<input v-model="name" lazy>
<input v-model="age" type="number" number>
```

このように使用します:

``` html
<input v-model.lazy="name">
<input v-model.number="age" type="number">
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of the these deprecated param attributes.</p>
</div>
{% endraw %}

### `v-model` with Inline `value` <sup>非推奨</sup>

`v-model` はもはや、 インラインの `value` 属性を尊重しません。予測可能性のため、それは代わりに、常に Vue インスタンスをデータをソースとして扱います。

これは、以下のような要素を意味します:

``` html
<input v-model="text" value="foo">
```

backed by this data:

``` js
data: {
  text: 'bar'
}
```

will render with a value of "bar" instead of "foo". The same goes for a `<textarea>` with existing content. Instead of:

``` html
<textarea v-model="text">
  hello world
</textarea>
```

You should ensure your initial value for `text` is "hello world".

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run your end-to-end test suite or app after upgrading and look for <strong>console warnings</strong> about inline value attributes with <code>v-model</code>.</p>
</div>
{% endraw %}

### `v-model` への `v-for` Iterated Primitive Values <sup>非推奨</sup>

Cases like this no longer work:

``` html
<input v-for="str in strings" v-model="str">
```

The reason is this is the equivalent JavaScript that the `<input>` would compile to:

``` js
strings.map(function (str) {
  return createElement('input', ...)
})
```

As you can see, `v-model`'s two-way binding doesn't make sense here. Setting `str` to another value in the iterator function will do nothing because it's just a local variable in the function scope.

Instead, you should use an array of __objects__ so that `v-model` can update the field on the object. For example:

``` html
<input v-for="obj in objects" v-model="obj.str">
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run your test suite, if you have one. The <strong>failed tests</strong> should alert to you to any parts of your app that may be affected by this change.</p>
</div>
{% endraw %}

### `v-bind:style` with Object Syntax and `!important` <sup>非推奨</sup>

これはもはや、動かなくなります:

``` html
<p v-bind:style="{ color: myColor + ' !important' }">hello</p>
```

If you really need to override another `!important`, you must use the string syntax:

``` html
<p v-bind:style="'color: ' + myColor + ' !important'">hello</p>
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of style bindings with <code>!important</code> in objects.</p>
</div>
{% endraw %}

### `v-el` と `v-ref` <sup>非推奨</sup>

For simplicity, `v-el` and `v-ref` have been merged into the `ref` attribute, accessible on a component instance via `$refs`. That means `v-el:my-element` would become `ref="myElement"` and `v-ref:my-component` would become `ref="myComponent"`. When used on a normal element, the `ref` will be the DOM element, and when used on a component, the `ref` will be the component instance.

Since `v-ref` is no longer a directive, but a special attribute, it can also be dynamically defined. This is especially useful in combination with `v-for`. For example:

``` html
<p v-for="item in items" v-bind:ref="'item' + item.id"></p>
```

Previously, `v-el`/`v-ref` combined with `v-for` would produce an array of elements/components, because there was no way to give each item a unique name. You can still achieve this behavior by given each item the same `ref`:

``` html
<p v-for="item in items" ref="items"></p>
```

Unlike in 1.x, these `$refs` are not reactive, because they're registered/updated during the render process itself. Making them reactive would require duplicate renders for every change.

On the other hand, `$refs` are designed primarily for programmatic access in JavaScript - it is not recommended to rely on them in templates, because that would mean referring to state that does not belong to the instance itself. This would violate Vue's data-driven view model.

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">マイグレーションヘルパ</a>を実行し、 <code>v-el</code> and <code>v-ref</code> を見つけます。
</div>
{% endraw %}

### `v-else` への `v-show` <sup>非推奨</sup>

`v-else` はもはや、 `v-show` では動作しません。代わりに、 `v-if` の否定式を使用してください。例えば、このような場合代わりに:

``` html
<p v-if="foo">Foo</p>
<p v-else v-show="bar">Not foo, but bar</p>
```

このように使用します:

``` html
<p v-if="foo">Foo</p>
<p v-if="!foo && bar">Not foo, but bar</p>
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of the <code>v-else</code> with <code>v-show</code>.</p>
</div>
{% endraw %}

## Custom Directives

Directives have a greatly reduced scope of responsibility: they are now only used for applying low-level direct DOM manipulations. In most cases, you should prefer using components as the main code-reuse abstraction.

Some of the most notable differences include:

- Directives no longer have instances. This means there's no more `this` inside directive hooks. Instead, they receive everything they might need as arguments. If you really must persist state across hooks, you can do so on `el`.
- Options such as `acceptStatement`, `deep`, `priority`, etc are all deprecated.
- Some of the current hooks have different behavior and there are also a couple new hooks.

Fortunately, since the new directives are much simpler, you can master them more easily. Read the new [Custom Directives guide](custom-directive.html) to learn more.

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of defined directives. The helper will flag all of them, as it's likely in most cases that you'll want to refactor to a component.</p>
</div>
{% endraw %}

## Transitions

### `transition` Attribute <sup>非推奨</sup>

Vue's transition system has changed quite drastically and now uses `<transition>` and `<transition-group>` wrapper elements, rather than the `transition` attribute. It's recommended to read the new [Transitions guide](transitions.html) to learn more.

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of the <code>transition</code> attribute.</p>
</div>
{% endraw %}

### `Vue.transition` for Reusable Transitions <sup>非推奨</sup>

With the new transition system, you can now just [use components for reusable transitions](http://rc.vuejs.org/guide/transitions.html#Reusable-Transitions).

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">マイグレーションヘルパ</a>を実行し、 <code>Vue.transition</code> を見つけます。
</div>
{% endraw %}

### Transition `stagger` Attribute <sup>非推奨</sup>

If you need to stagger list transitions, you can control timing by setting and accessing a `data-index` (or similar attribute) on an element. See [an example here](transitions.html#Staggering-List-Transitions).

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of the <code>transition</code> attribute. During your update, you can transition (pun very much intended) to the new staggering strategy as well.</p>
</div>
{% endraw %}

## イベント

### `Vue.directive('on').keyCodes` <sup>非推奨</sup>

The new, more concise way to configure `keyCodes` is through`Vue.config.keyCodes`. For example:

``` js
// enable v-on:keyup.f1
Vue.config.keyCodes.f1 = 112
```
{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of the the old <code>keyCode</code> configuration syntax.</p>
</div>
{% endraw %}

### `$dispatch` および `$broadcast` <sup>非推奨</sup>

`$dispatch` and `$broadcast` are being deprecated in favor of more explicitly cross-component communication and more maintainable state management solutions, such as [Vuex](https://github.com/vuejs/vuex).

The problem is event flows that depend on a component's tree structure can be hard to reason about and very brittle when the tree becomes large. It simply doesn't scale well and we don't want to set you up for pain later. `$dispatch` and `$broadcast` also do not solve communication between sibling components.

For the simplest possible upgrade from `$dispatch` and `$broadcast`, you can use a centralized event hub that allows components to communicate no matter where they are in the component tree. Because Vue instances implement an event emitter interface, you can actually use an empty Vue instance for this purpose.

For example, let's say we have a todo app structured like this:

```
Todos
|-- NewTodoInput
|-- Todo
    |-- DeleteTodoButton
```

We could manage communication between components with this single event hub:

``` js
// This is the event hub we'll use in every
// component to communicate between them.
var eventHub = new Vue()
```

Then in our components, we can use `$emit`, `$on`, `$off` to emit events, listen for events, and clean up event listeners, respectively:

``` js
// NewTodoInput
// ...
methods: {
  addTodo: function () {
    eventHub.$emit('add-todo', { text: this.newTodoText })
    this.newTodoText = ''
  }
}
```

``` js
// DeleteTodoButton
// ...
methods: {
  deleteTodo: function (id) {
    eventHub.$emit('delete-todo', id)
  }
}
```

``` js
// Todos
// ...
created: function () {
  eventHub.$on('add-todo', this.addTodo)
  eventHub.$on('delete-todo', this.deleteTodo)
},
// It's good to clean up event listeners before
// a component is destroyed.
beforeDestroy: function () {
  eventHub.$off('add-todo', this.addTodo)
  eventHub.$off('delete-todo', this.deleteTodo)
},
methods: {
  addTodo: function (newTodo) {
    this.todos.push(newTodo)
  },
  deleteTodo: function (todoId) {
    this.todos = this.todos.filter(function (todo) {
      return todo.id !== todoId
    })
  }
}
```

This pattern can serve as a replacement for `$dispatch` and `$broadcast` in simple scenarios, but for more complex cases, it's recommended to use a dedicated state management layer such as [Vuex](https://github.com/vuejs/vuex).

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">マイグレーションヘルパ</a>を実行し、 <code>$dispatch</code> and <code>$broadcast</code> を見つけます。
</div>
{% endraw %}

## フィルタ

### Filters Outside Text Interpolations <sup>非推奨</sup>

Filters can now only be used inside text interpolations (`{% raw %}{{ }}{% endraw %}` tags). In the past we've found using filters within directives such as `v-model`, `v-on`, etc led to more complexity than convenience. For list filtering on `v-for`, it's also better to move that logic into JavaScript as computed properties, so that it can be reused throughout your component.

In general, whenever something can be achieved in plain JavaScript, we want to avoid introducing a special syntax like filters to take care of the same concern. Here's how you can replace Vue's built-in directive filters:

#### `debounce` フィルタの置き換え

Instead of:

``` html
<input v-on:keyup="doStuff | debounce 500">
```

``` js
methods: {
  doStuff: function () {
    // ...
  }
}
```

Use [lodash's `debounce`](https://lodash.com/docs/4.15.0#debounce) (or possibly [`throttle`](https://lodash.com/docs/4.15.0#throttle)) to directly limit calling the expensive method. You can achieve the same as above like this:

``` html
<input v-on:keyup="doStuff">
```

``` js
methods: {
  doStuff: _.debounce(function () {
    // ...
  }, 500)
}
```

For more on the advantages of this strategy, see [the example here with `v-model`](#v-model-with-debounce-deprecated).

#### `limitBy` フィルタの置き換え

Instead of:

``` html
<p v-for="item in items | limitBy 10">{{ item }}</p>
```

Use JavaScript's built-in [`.slice` method](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/slice#Examples) in a computed property:

``` html
<p v-for="item in filteredItems">{{ item }}</p>
```

``` js
computed: {
  filteredItems: function () {
    return this.items.slice(0, 10)
  }
}
```

#### `filterBy` フィルタの置き換え

Instead of:

``` html
<p v-for="user in users | filterBy searchQuery in 'name'">{{ user.name }}</p>
```

Use JavaScript's built-in [`.filter` method](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/filter#Examples) in a computed property:

``` html
<p v-for="user in filteredUsers">{{ user.name }}</p>
```

``` js
computed: {
  filteredUsers: function () {
    return this.users.filter(function (user) {
      return user.name.indexOf(this.searchQuery)
    })
  }
}
```

JavaScript's native `.filter` can also manage much more complex filtering operations, because you have access to the full power of JavaScript within computed properties. For example, if you wanted to find all active users and case-insensitively match against both their name and email:

``` js
this.users.filter(function (user) {
  var searchRegex = new RegExp(this.searchQuery, 'i')
  return user.isActive && (
    searchRegex.test(user.name) ||
    searchRegex.test(user.email)
  )
})
```

#### `orderBy` フィルタの置き換え

Instead of:

``` html
<p v-for="user in users | orderBy 'name'">{{ user.name }}</p>
```

Use [lodash's `orderBy`](https://lodash.com/docs/4.15.0#orderBy) (or possibly [`sortBy`](https://lodash.com/docs/4.15.0#sortBy)) in a computed property:

``` html
<p v-for="user in orderedUsers">{{ user.name }}</p>
```

``` js
computed: {
  orderedUsers: function () {
    return _.orderBy(this.users, 'name')
  }
}
```

You can even order by multiple columns:

``` js
_.orderBy(this.users, ['name', 'last_login'], ['asc', 'desc'])
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of filters being used inside directives. If you miss any, you should also see <strong>console errors</strong>.</p>
</div>
{% endraw %}

### フィルタ引数の構文

Filters' syntax for arguments now better aligns with JavaScript function invocation. So instead of taking space-delimited arguments:

``` html
<p>{{ date | formatDate 'YY-MM-DD' timeZone }}</p>
```

We surround the arguments with parentheses and delimit the arguments with commas:

``` html
<p>{{ date | formatDate('YY-MM-DD', timeZone) }}</p>
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of the old filter syntax. If you miss any, you should also see <strong>console errors</strong>.</p>
</div>
{% endraw %}

### 内臓フィルタ <sup>非推奨</sup>

Although filters within text interpolations are still allowed, all of the filters have been removed. Instead, it's recommended to use more specialized libraries for solving problems in each domain (e.g. [`date-fns`](https://date-fns.org/) to format dates and [`accounting`](http://openexchangerates.github.io/accounting.js/) for currencies).

For each of Vue's built-in text filters, we go through how you can replace them below. The example code could exist in custom helper functions, methods, or computed properties.

#### `json` フィルタの置き換え

You actually don't need to for debugging anymore, as Vue will nicely format output for you automatically, whether it's a string, number, array, or plain object. If you want the exact same functionality as JavaScript's `JSON.stringify` though, then you can use that in a method or computed property.

#### `capitalize` フィルタの置き換え

``` js
text[0].toUpperCase() + text.slice(1)
```

#### `uppercase` フィルタの置き換え

``` js
text.toUpperCase()
```

#### `lowercase` フィルタの置き換え

``` js
text.toLowerCase()
```

#### `pluralize` フィルタの置き換え

The [pluralize](https://www.npmjs.com/package/pluralize) package on NPM serves this purpose nicely, but if you only want to pluralize a specific word or want to have special output for cases like `0`, then you can also easily define your own pluralize functions. For example:

``` js
function pluralizeKnife (count) {
  if (count === 0) {
    return 'no knives'
  } else if (count === 1) {
    return '1 knife'
  } else {
    return count + 'knives'
  }
}
```

#### `currency` フィルタの置き換え

For a very naive implementation, you could just do something like this:

``` js
'$' + price.toFixed(2)
```

In many cases though, you'll still run into strange behavior (e.g. `0.035.toFixed(2)` rounds up to `0.4`, but `0.045` rounds down to `0.4`). To work around these issues, you can use the [`accounting`](http://openexchangerates.github.io/accounting.js/) library to more reliably format currencies.

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of the deprecated text filters. If you miss any, you should also see <strong>console errors</strong>.</p>
</div>
{% endraw %}

## スロット

### 重複したスロット <sup>非推奨</sup>

もはや、同じテンプレート内に、同名のスロットを持つことはサポートされません。
スロットがレンダリングされるとき、そのスロットは「使い果たされ」、同じレンダリングツリーの中で再度レンダリングすることはできません。
もし、複数の場所で同一の内容をレンダリングする必要がある場合は、 prop としてそのコンテンツを渡します。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run your end-to-end test suite or app after upgrading and look for <strong>console warnings</strong> about duplicate slots <code>v-model</code>.</p>
</div>
{% endraw %}

### `slot` 属性のスタイリング <sup>非推奨</sup>

名前付きスロットを経由して挿入されたコンテンツは、もはや `slot` 属性を保持しません。

Content inserted via named `<slot>` no longer preserves the `slot` attribute. Use a wrapper element to style them, or for advanced use cases, modify the inserted content programmatically using [render functions](render-function.html).

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find CSS selectors targeting named slots (e.g. <code>[slot="my-slot-name"]</code>).</p>
</div>
{% endraw %}

## 特別な属性

### `keep-alive` 属性 <sup>非推奨</sup>

`keep-alive` はもはや、特別な属性ではなく、 `<transition>` と同様に、コンポーネントのラッパーではありません。例えば:

``` html
<keep-alive>
  <component v-bind:is="view"></component>
</keep-alive>
```

This makes it possible to use `<keep-alive>` on multiple conditional children:

``` html
<keep-alive>
  <todo-list v-if="todos.length > 0"></todo-list>
  <no-todos-gif v-else></no-todos-gif>
</keep-alive>
```

<p class="tip">When `<keep-alive>` has multiple children, they should eventually evaluate to a single child. Any child other than the first one will simply be ignored.</p>

When used together with `<transition>`, make sure to nest it inside:

``` html
<transition>
  <keep-alive>
    <component v-bind:is="view"></component>
  </keep-alive>
</transition>
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find <code>keep-alive</code> attributes.</p>
</div>
{% endraw %}

## Interpolation

### Interpolation within Attributes <sup>非推奨</sup>

Interpolation within attributes is no longer valid. For example:

``` html
<button v-bind:class="btn btn-{{ size }}"></button>
```

Should either be updated to use an inline expression:

``` html
<button v-bind:class="'btn btn-' + size"></button>
```

Or a data/computed property:

``` html
<button v-bind:class="buttonClasses"></button>
```

``` js
computed: {
  buttonClasses: function () {
    return 'btn btn-' + size
  }
}
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of interpolation used within attributes.</p>
</div>
{% endraw %}

### HTML Interpolation <sup>非推奨</sup>

HTML interpolations (`{% raw %}{{{ foo }}}{% endraw %}`) have been deprecated in favor of the [`v-html` directive](/api/#v-html).

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find HTML interpolations.</p>
</div>
{% endraw %}

### One-Time Bindings <sup>非推奨</sup>

One time bindings (`{% raw %}{{* foo }}{% endraw %}`) have been deprecated in favor of the new [`v-once` directive](/api/#v-once).

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find one-time bindings.</p>
</div>
{% endraw %}

## Reactivity

### `vm.$watch`

Watchers created via `vm.$watch` are now fired before the associated component rerenders. This gives you the chance to further update state before the component rerender, thus avoiding unnecessary updates. For example, you can watch a component prop and update the component's own data when the prop changes.

If you were previously relying on `vm.$watch` to do something with the DOM after a component updates, you can instead do so in the `updated` lifecycle hook.

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run your end-to-end test suite, if you have one. The <strong>failed tests</strong> should alert to you to the fact that a watcher was relying on the old behavior.</p>
</div>
{% endraw %}

### `vm.$set`

The former `vm.$set` behavior has been deprecated and it is now just an alias for [`Vue.set`](/api/#Vue-set).

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of the deprecated usage.</p>
</div>
{% endraw %}

### `vm.$delete`

The former `vm.$delete` behavior has been deprecated and it is now just an alias for [`Vue.delete`](/api/#Vue-delete)

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of the deprecated usage.</p>
</div>
{% endraw %}

### `Array.prototype.$set`  <sup>非推奨</sup>

代わりに、 Vue.set を使用します。

(console error, migration helper)

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of <code>.$set</code> on an array. If you miss any, you should see <strong>console errors</strong> from the missing method.</p>
</div>
{% endraw %}

### `Array.prototype.$remove` <sup>非推奨</sup>

例えば、代わりに `Array.prototype.splice` を使用します:

``` js
methods: {
  removeTodo: function (todo) {
    var index = this.todos.indexOf(todo)
    this.todos.splice(index, 1)
  }
}
```

いっそのこと、削除メソッドに index を渡す方法も良いでしょう:

``` js
methods: {
  removeTodo: function (index) {
    this.todos.splice(index, 1)
  }
}
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of <code>.$remove</code> on an array. If you miss any, you should see <strong>console errors</strong> from the missing method.</p>
</div>
{% endraw %}

### Vue インスタンス上での `Vue.set` および `Vue.delete` <sup>非推奨</sup>

Vue.set および Vue.delete はもはや、 Vue インスタンス上で動作することはできません。

[x] Vue.set and Vue.delete can no longer work on Vue instances.
[ ] It is now mandatory to properly declare all top-level reactive properties in the data option.
[ ] If you'd like to delete properties on a Vue instance or its `$data`, just set it to null.

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of <code>Vue.set</code> or <code>Vue.delete</code> on a Vue instance. If you miss any, they'll trigger <strong>console warnings</strong>.</p>
</div>
{% endraw %}

### Replacing `vm.$data` <sup>非推奨</sup>

It is now prohibited to replace a component instance's root $data. This prevents some edge cases in the reactivity system and makes the component state more predictable (especially with type-checking systems).

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of overwriting <code>vm.$data</code>. If you miss any, <strong>console warnings</strong> will be emitted.</p>
</div>
{% endraw %}

### `vm.$get` <sup>非推奨</sup>

Just retrieve reactive data directly.

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of <code>vm.$get</code>. If you miss any, you'll see <strong>console errors</strong>.</p>
</div>
{% endraw %}

## DOM-Focused Instance Methods

### `vm.$appendTo` <sup>非推奨</sup>

ネイティブの DOM API を使用します:

``` js
myElement.appendChild(vm.$el)
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of <code>vm.$appendTo</code>. If you miss any, you'll see <strong>console errors</strong>.</p>
</div>
{% endraw %}

### `vm.$before` <sup>非推奨</sup>

ネイティブの DOM API を使用します:

``` js
myElement.parentNode.insertBefore(vm.$el, myElement)
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of <code>vm.$before</code>. If you miss any, you'll see <strong>console errors</strong>.</p>
</div>
{% endraw %}

### `vm.$after` <sup>非推奨</sup>

ネイティブの DOM API を使用します:

``` js
myElement.parentNode.insertBefore(vm.$el, myElement.nextSibling)
```

また、もし `myElement` が最後の要素の場合:

``` js
myElement.parentNode.appendChild(vm.$el)
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of <code>vm.$after</code>. If you miss any, you'll see <strong>console errors</strong>.</p>
</div>
{% endraw %}

### `vm.$remove` <sup>非推奨</sup>

ネイティブの DOM API を使用します:

``` js
vm.$el.remove()
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of <code>vm.$remove</code>. If you miss any, you'll see <strong>console errors</strong>.</p>
</div>
{% endraw %}

## Meta Instance Methods

### `vm.$eval` <sup>非推奨</sup>

No real use. If you do happen to rely on this feature somehow and aren't sure how to work around it, post on [the forum](http://forum.vuejs.org/) for ideas.

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of <code>vm.$eval</code>. If you miss any, you'll see <strong>console errors</strong>.</p>
</div>
{% endraw %}

### `vm.$interpolate` <sup>非推奨</sup>

No real use. If you do happen to rely on this feature somehow and aren't sure how to work around it, post on [the forum](http://forum.vuejs.org/) for ideas.

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of <code>vm.$interpolate</code>. If you miss any, you'll see <strong>console errors</strong>.</p>
</div>
{% endraw %}

### `vm.$log` <sup>非推奨</sup>

Use the [Vue Devtools](https://github.com/vuejs/vue-devtools) for the optimal debugging experience.

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of <code>vm.$log</code>. If you miss any, you'll see <strong>console errors</strong>.</p>
</div>
{% endraw %}

## インスタンス DOM オプション

### `replace: false` <sup>非推奨</sup>

Components now always replace the element they're bound to. To simulate the behavior of `replace: false`, you can wrap your root component with an element similar to the one you're replacing. For example:

``` js
new Vue({
  el: '#app',
  template: '<div id="app"> ... </div>'
})
```

Or with a render function:

``` js
new Vue({
  el: '#app',
  render: function (h) {
    h('div', {
      attrs: {
        id: 'app',
      }
    }, /* ... */)
  }
})
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">マイグレーションヘルパ</a>を実行し、 <code>replace: false</code> を見つけます。
</div>
{% endraw %}

## グローバル設定

### `Vue.config.debug` <sup>非推奨</sup>

もはや、警告に対して、必要に応じてデフォルトでスタックトレースが付随しています。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">マイグレーションヘルパ</a>を実行し、 <code>Vue.config.debug</code> を見つけます。
</div>
{% endraw %}

### `Vue.config.async` <sup>非推奨</sup>

非同期処理は現在、レンダリングパフォーマンスのために必要とされます。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">マイグレーションヘルパ</a>を実行し、 <code>Vue.config.async</code> を見つけます。
</div>
{% endraw %}

### `Vue.config.delimiters` <sup>非推奨</sup>

[component-level option](/api/#delimiters) として作り直されました。
これは、サードパーティのコンポーネントを壊すことなく、アプリケーション内で代替のデリミタを使用することができます。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">マイグレーションヘルパ</a>を実行し、 <code>Vue.config.delimiters</code> を見つけます。
</div>
{% endraw %}

### `Vue.config.unsafeDelimiters` <sup>非推奨</sup>

HTML interpolation has been [deprecated in favor of `v-html`](#HTML-Interpolation-deprecated).

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of <code>Vue.config.unsafeDelimiters</code>. After this, the helper will also find instances of HTML interpolation so that you can replace them with `v-html`.</p>
</div>
{% endraw %}

## グローバル API

### `Vue.extend` への `el` <sup>非推奨</sup>

el オプションは、もはや `Vue.extend` で使用することはできません。これは、インスタンスの作成オプションとしてのみ有効です。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>アップグレード後に end-to-end のテストスイートやアプリケーションを実行し、 <code>Vue.extend</code> への <code>el</code> に対してのコンソールの警告を探します。</p>
</div>
{% endraw %}

### `Vue.elementDirective` <sup>非推奨</sup>

代わりに components を使用します。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">マイグレーションヘルパ</a>を実行し、 <code>Vue.elementDirective</code> を見つけます。
</div>
{% endraw %}

### `Vue.partial` <sup>非推奨</sup>

代わりに、[関数型コンポーネント](render-function.html#関数型コンポーネント)を使用します。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">マイグレーションヘルパ</a>を実行し、 <code>Vue.partial</code> を見つけます。
</div>
{% endraw %}
