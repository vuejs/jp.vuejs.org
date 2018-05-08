---
title: 特別な問題に対処する
type: guide
order: 106
---

> ⚠️注意: この内容は原文のままです。現在翻訳中ですのでお待ち下さい。🙏

> このページはすでに[コンポーネントの基本](components.html)を読んでいることを前提に書いています。もしまだ読んでいないのなら、先に読みましょう。

<p class="tip">特別な問題、つまり珍しい状況に対処するためのこのページの全ての機能は、時にVueのルールを多少なりとも曲げることになります。しかしながら注意して欲しいのが、それらは全てデメリットや危険な状況をもたらし得るということです。これらのマイナス的な面はそれぞれのケースで注意されているので、このページで紹介されるそれぞれの機能を使用すると決めた時は心に止めておいてください。</p>

## 要素 & コンポーネントへのアクセス

ほとんどのケースで、他のコンポーネントインスタンスへのアクセスやDOM要素を手動操作することを避けるのがベストです。しかし、それが適切な場合もあります。

### ルートインスタンスへのアクセス

`new Vue`インスタンスの全てのサブコンポーネントから、`$root`プロパティを用いてルートインスタンスへアクセスできます。例えば、以下のルートインスタンスでは...

```js
// The root Vue instance
new Vue({
  data: {
    foo: 1
  },
  computed: {
    bar: function () { /* ... */ }
  },
  methods: {
    baz: function () { /* ... */ }
  }
})
```

全てのサブコンポーネントはこのインスタンスにアクセスすることができ、グローバルストアとして使うことができます。

```js
// Get root data
this.$root.foo

// Set root data
this.$root.foo = 2

// Access root computed properties
this.$root.bar

// Call root methods
this.$root.baz()
```

<p class="tip">これはデモや一握りのコンポーネントで構成された非常に小さいアプリケーションとしては便利かもしれませんが、中〜大規模のアプリケーションにスケールさせづらいです。なので我々はほとんどのケースでステートを管理するために<a href="https://github.com/vuejs/vuex">Vuex</a>の使用を強くおすすめしています。</p>

### 親コンポーネントインスタンスへのアクセス

`$root`と似たように、`$parent`プロパティは子から親インスタンスへアクセスするために使われます。これはpropsでデータを渡すことへの怠惰な代替手段として魅力あることでしょう。

<p class="tip">ほとんどのケースで、親へのアクセスはアプリケーションのデバッグや理解をより難しくします。特に、あなたが親のデータを変化させる場合はなおさらです。後々になってそのコンポーネントを扱う時、その変化がどこから来たものなのかを理解することはとても難しいことでしょう。</p>

しかしながらとりわけ共有コンポーネントライブラリの場合は、これが適切で_あるかもしれない_場合があります。例えば、仮想的なGoogle Mapコンポーネントのような、HTMLを描画する代わりにJavaScriptのAPIを扱う抽象コンポーネントの場合は...

```html
<google-map>
  <google-map-markers v-bind:places="iceCreamShops"></google-map-markers>
</google-map>
```

`<google-map>`コンポーネントは全てのサブコンポーネントがアクセスする必要がある`map`プロパティを定義しています。この場合、`<google-map-markers>`は地図上にマーカーを設定するため`this.$parent.getMap`のような何かでmapプロパティにアクセスしたいことでしょう。[ここから](https://jsfiddle.net/chrisvfritz/ttzutdxh/)このパターンをみることができます。

Keep in mind, however, that components built with this pattern are still inherently fragile. For example, imagine we add a new `<google-map-region>` component and when `<google-map-markers>` appears within that, it should only render markers that fall within that region:

しかしながら、このパターンで作成されたコンポーネントはやはり本質的に壊れやすくなるということを覚えておいてください。例えば、`<google-map-region>`という新しいコンポーネントを追加することをイメージしてください。そして、`<google-map-markers>`が`<google-map-region>`内に現れる時、その領域内のマーカーのみ描画すべきです。

```html
<google-map>
  <google-map-region v-bind:shape="cityBoundaries">
    <google-map-markers v-bind:places="iceCreamShops"></google-map-markers>
  </google-map-region>
</google-map>
```

Then inside `<google-map-markers>` you might find yourself reaching for a hack like this:
そのとき`<google-map-markers>`の内部で、あなたはこのようなハックに行き着くかもしれない...

```js
var map = this.$parent.map || this.$parent.$parent.map
```

このハックはすぐに手に負えなくなります。コンテキストの情報を子孫のコンポーネントに専ら深く提供するからです。私たちは代わりに[依存性の注入](#Dependency-Injection)を勧めます。

### 子コンポーネントインスタンスと子要素へのアクセス

propsとイベントが存在するにも関わらず、ときどきJavaScriptで直接子コンポーネントにアクセスする必要があるかもしれません。このために`ref`属性を使い、子コンポーネントにリファレンスIDを割り当てることができます。例えば...

```html
<base-input ref="usernameInput"></base-input>
```

今この`ref`を定義したコンポーネントでこのように...

```js
this.$refs.usernameInput
```

`<base-input>`インスタンスにアクセスすることができるようになります。例えば、あなたがプログラムによって、親コンポーネントからこのインプットフォームにフォーカスしたいときに役立ちます。この場合、`<base-input>`コンポーネントは内部の特定要素へのアクセスを提供するため、親と同様に`ref`を使うかもしれません。このように...


```html
<input ref="input">
```

親にも使用されるメソッドを定義して...

```js
methods: {
  // Used to focus the input from the parent
  focus: function () {
    this.$refs.input.focus()
  }
}
```

このようなコードで、親コンポーネントに`<base-input>`内部のinput要素にフォーカスさせます。

```js
this.$refs.usernameInput.focus()
```

`ref`が`v-for`と共に使用されるとき、あなたが得る参照はデータソースをミラーリングした子コンポーネントの配列であるでしょう。

<p class="tip"><code>$refs</code>はコンポーネントの描画後に生きるだけで、リアクティブではありません。それは子コンポーネントへの直接操作(テンプレート内または算出プロパティから<code>$refs</code>にアクセスするのは避けるべきです)のための、退避用ハッチのような意味合いです。</p>

### 依存性の注入

先ほど、[親コンポーネントインスタンスへのアクセス](#Accessing-the-Parent-Component-Instance)を説明したとき、以下のような例を出しました。

```html
<google-map>
  <google-map-region v-bind:shape="cityBoundaries">
    <google-map-markers v-bind:places="iceCreamShops"></google-map-markers>
  </google-map-region>
</google-map>
```

In this component, all descendants of `<google-map>` needed access to a `getMap` method, in order to know which map to interact with. Unfortunately, using the `$parent` property didn't scale well to more deeply nested components. That's where dependency injection can be useful, using two new instance options: `provide` and `inject`.

The `provide` options allows us to specify the data/methods we want to **provide** to descendent components. In this case, that's the `getMap` method inside `<google-map>`:

```js
provide: function () {
  return {
    getMap: this.getMap
  }
}
```

Then in any descendants, we can use the `inject` option to receive specific properties we'd like to add to that instance:

```js
inject: ['getMap']
```

You can see the [full example here](https://jsfiddle.net/chrisvfritz/tdv8dt3s/). The advantage over using `$parent` is that we can access `getMap` in _any_ descendant component, without exposing the entire instance of `<google-map>`. This allows us to more safely keep developing that component, without fear that we might change/remove something that a child component is relying on. The interface between these components remains clearly defined, just as with `props`.

In fact, you can think of dependency injection as sort of "long-range props", except:

* ancestor components don't need to know which descendants use the properties it provides
* descendant components don't know need to know where injected properties are coming from

<p class="tip">However, there are downsides to dependency injection. It couples components in your application to the way they're currently organized, making refactoring more difficult. Provided properties are also not reactive. This is by design, because using them to create a central data store scales just as poorly as <a href="#Accessing-the-Root-Instance">using <code>$root</code></a> for the same purpose. If the properties you want to share are specific to your app, rather than generic, or if you ever want to update provided data inside ancestors, then that's a good sign that you probably need a real state management solution like <a href="https://github.com/vuejs/vuex">Vuex</a> instead.</p>

Learn more about dependency injection in [the API doc](https://vuejs.org/v2/api/#provide-inject).

## Programmatic Event Listeners

So far, you've seen uses of `$emit`, listened to with `v-on`, but Vue instances also offer other methods in its events interface. We can:

- Listen for an event with `$on(eventName, eventHandler)`
- Listen for an event only once with `$once(eventName, eventHandler)`
- Stop listening for an event with `$off(eventName, eventHandler)`

You normally won't have to use these, but they're available for cases when you need to manually listen for events on a component instance. They can also be useful as a code organization tool. For example, you may often see this pattern for integrating a 3rd-party library:

```js
// Attach the datepicker to an input once
// it's mounted to the DOM.
mounted: function () {
  // Pikaday is a 3rd-party datepicker library
  this.picker = new Pikaday({
    field: this.$refs.input,
    format: 'YYYY-MM-DD'
  })
},
// Right before the component is destroyed,
// also destroy the datepicker.
beforeDestroy: function () {
  this.picker.destroy()
}
```

This has two potential issues:

- It requires saving the `picker` to the component instance, when it's possible that only lifecycle hooks need access to it. This isn't terrible, but it could be considered clutter.
- Our setup code is kept separate from our cleanup code, making it more difficult to programmatically clean up anything we set up.

You could resolve both issues with a programmatic listener:

```js
mounted: function () {
  var picker = new Pikaday({
    field: this.$refs.input,
    format: 'YYYY-MM-DD'
  })

  this.$once('hook:beforeDestroy', function () {
    picker.destroy()
  })
}
```

Using this strategy, we could even use Pikaday with several input elements, with each new instance automatically cleaning up after itself:

```js
mounted: function () {
  this.attachDatepicker('startDateInput')
  this.attachDatepicker('endDateInput')
},
methods: {
  attachDatepicker: function (refName) {
    var picker = new Pikaday({
      field: this.$refs[refName],
      format: 'YYYY-MM-DD'
    })

    this.$once('hook:beforeDestroy', function () {
      picker.destroy()
    })
  }
}
```

See [this fiddle](https://jsfiddle.net/chrisvfritz/1Leb7up8/) for the full code. Note, however, that if you find yourself having to do a lot of setup and cleanup within a single component, the best solution will usually be to create more modular components. In this case, we'd recommend creating a reusable `<input-datepicker>` component.

To learn more about programmatic listeners, check out the API for [Events Instance Methods](https://vuejs.org/v2/api/#Instance-Methods-Events).

<p class="tip">Note that Vue's event system is different from the browser's <a href="https://developer.mozilla.org/en-US/docs/Web/API/EventTarget">EventTarget API</a>. Though they work similarly, <code>$emit</code>, <code>$on</code>, and <code>$off</code> are <strong>not</strong> aliases for <code>dispatchEvent</code>, <code>addEventListener</code>, and <code>removeEventListener</code>.</p>

## Circular References

### Recursive Components

Components can recursively invoke themselves in their own template. However, they can only do so with the `name` option:

``` js
name: 'unique-name-of-my-component'
```

When you register a component globally using `Vue.component`, the global ID is automatically set as the component's `name` option.

``` js
Vue.component('unique-name-of-my-component', {
  // ...
})
```

If you're not careful, recursive components can also lead to infinite loops:

``` js
name: 'stack-overflow',
template: '<div><stack-overflow></stack-overflow></div>'
```

A component like the above will result in a "max stack size exceeded" error, so make sure recursive invocation is conditional (i.e. uses a `v-if` that will eventually be `false`).

### Circular References Between Components

Let's say you're building a file directory tree, like in Finder or File Explorer. You might have a `tree-folder` component with this template:

``` html
<p>
  <span>{{ folder.name }}</span>
  <tree-folder-contents :children="folder.children"/>
</p>
```

Then a `tree-folder-contents` component with this template:

``` html
<ul>
  <li v-for="child in children">
    <tree-folder v-if="child.children" :folder="child"/>
    <span v-else>{{ child.name }}</span>
  </li>
</ul>
```

When you look closely, you'll see that these components will actually be each other's descendent _and_ ancestor in the render tree - a paradox! When registering components globally with `Vue.component`, this paradox is resolved for you automatically. If that's you, you can stop reading here.

However, if you're requiring/importing components using a __module system__, e.g. via Webpack or Browserify, you'll get an error:

```
Failed to mount component: template or render function not defined.
```

To explain what's happening, let's call our components A and B. The module system sees that it needs A, but first A needs B, but B needs A, but A needs B, etc. It's stuck in a loop, not knowing how to fully resolve either component without first resolving the other. To fix this, we need to give the module system a point at which it can say, "A needs B _eventually_, but there's no need to resolve B first."

In our case, let's make that point the `tree-folder` component. We know the child that creates the paradox is the `tree-folder-contents` component, so we'll wait until the `beforeCreate` lifecycle hook to register it:

``` js
beforeCreate: function () {
  this.$options.components.TreeFolderContents = require('./tree-folder-contents.vue').default
}
```

Or alternatively, you could use Webpack's asynchronous `import` when you register the component locally:

``` js
components: {
  TreeFolderContents: () => import('./tree-folder-contents.vue')
}
```

Problem solved!

## Alternate Template Definitions

### Inline Templates

When the `inline-template` special attribute is present on a child component, the component will use its inner content as its template, rather than treating it as distributed content. This allows more flexible template-authoring.

``` html
<my-component inline-template>
  <div>
    <p>These are compiled as the component's own template.</p>
    <p>Not parent's transclusion content.</p>
  </div>
</my-component>
```

<p class="tip">However, <code>inline-template</code> makes the scope of your templates harder to reason about. As a best practice, prefer defining templates inside the component using the <code>template</code> option or in a <code>&lt;template&gt;</code> element in a <code>.vue</code> file.</p>

### X-Templates

Another way to define templates is inside of a script element with the type `text/x-template`, then referencing the template by an id. For example:

``` html
<script type="text/x-template" id="hello-world-template">
  <p>Hello hello hello</p>
</script>
```

``` js
Vue.component('hello-world', {
  template: '#hello-world-template'
})
```

<p class="tip">These can be useful for demos with large templates or in extremely small applications, but should otherwise be avoided, because they separate templates from the rest of the component definition.</p>

## Controlling Updates

Thanks to Vue's Reactivity system, it always knows when to update (if you use it correctly). There are edge cases, however, when you might want to force an update, despite the fact that no reactive data has changed. Then there are other cases when you might want to prevent unnecessary updates.

### Forcing an Update

<p class="tip">If you find yourself needing to force an update in Vue, in 99.99% of cases, you've made a mistake somewhere.</p>

You may not have accounted for change detection caveats [with arrays](https://vuejs.org/v2/guide/list.html#Caveats) or [objects](https://vuejs.org/v2/guide/list.html#Object-Change-Detection-Caveats), or you may be relying on state that isn't tracked by Vue's reactivity system, e.g. with `data`.

However, if you've ruled out the above and find yourself in this extremely rare situation of having to manually force an update, you can do so with [`$forceUpdate`](../api/#vm-forceUpdate).

### Cheap Static Components with `v-once`

Rendering plain HTML elements is very fast in Vue, but sometimes you might have a component that contains **a lot** of static content. In these cases, you can ensure that it's only evaluated once and then cached by adding the `v-once` directive to the root element, like this:

``` js
Vue.component('terms-of-service', {
  template: `
    <div v-once>
      <h1>Terms of Service</h1>
      ... a lot of static content ...
    </div>
  `
})
```

<p class="tip">Once again, try not to overuse this pattern. While convenient in those rare cases when you have to render a lot of static content, it's simply not necessary unless you actually notice slow rendering -- plus, it could cause a lot of confusion later. For example, imagine another developer who's not familiar with <code>v-once</code> or simply misses it in the template. They might spend hours trying to figure out why the template isn't updating correctly.</p>
