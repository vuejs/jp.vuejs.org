---
title: Components
type: guide
order: 12
---

## コンポーネントの使用

### Registration

We've learned in the previous sections that we can create a component constructor using `Vue.extend()`:

``` js
var MyComponent = Vue.extend({
  // options...
})
```

To use this constructor as a component, you need to **register** it with `Vue.component(tag, constructor)`:

``` js
// Globally register the component with tag: my-component
Vue.component('my-component', MyComponent)
```

Once registered, the component can now be used in a parent instance's template as a custom element, `<my-component>`. Make sure the component is registered **before** you instantiate your root Vue instance. Here's the full example:

``` html
<div id="example">
  <my-component></my-component>
</div>
```

``` js
// define
var MyComponent = Vue.extend({
  template: '<div>A custom component!</div>'
})

// register
Vue.component('my-component', MyComponent)

// create a root instance
new Vue({
  el: '#example'
})
```

レンダリング内容:

``` html
<div id="example">
  <div>A custom component!</div>
</div>
```

{% raw %}
<div id="example" class="demo">
  <my-component></my-component>
</div>
<script>
Vue.component('my-component', {
  template: '<div>A custom component!</div>'
})
new Vue({ el: '#example' })
</script>
{% endraw %}

Note the component's template **replaces** the custom element, which only serves as a **mounting point**. This behavior can be configured using the `replace` instance option.

### Local Registration

You don't have to register every component globally. You can make a component available only in the scope of another component by registering it with the `components` instance option:

``` js
var Child = Vue.extend({ /* ... */ })

var Parent = Vue.extend({
  template: '...',
  components: {
    // <my-component> will only be available in Parent's template
    'my-component': Child
  }
})
```

The same encapsulation applies for other assets types such as directives, filters and transitions.

### Registration Sugar

To make things easier, you can directly pass in the options object instead of an actual constructor to `Vue.component()` and the `component` option. Vue.js will automatically call `Vue.extend()` for you under the hood:

``` js
// extend and register in one step
Vue.component('my-component', {
  template: '<div>A custom component!</div>'
})

// also works for local registration
var Parent = Vue.extend({
  components: {
    'my-component': {
      template: '<div>A custom component!</div>'
    }
  }
})
```

### Component Option Caveats

Most of the options that can be passed into the Vue constructor can be used in `Vue.extend()`, with two special cases: `data` and `el`. Imagine we simply pass an object as `data` to `Vue.extend()`:

``` js
var data = { a: 1 }
var MyComponent = Vue.extend({
  data: data
})
```

The problem with this is that the same `data` object will be shared across all instances of `MyComponent`! This is most likely not what we want, so we should use a function that returns a fresh object as the `data` option:

``` js
var MyComponent = Vue.extend({
  data: function () {
    return { a: 1 }
  }
})
```

The `el` option also requires a function value when used in `Vue.extend()`, for exactly the same reason.

### `is` attribute

Some HTML elements, for example `<table>`, has restrictions on what elements can appear inside it. Custom elements that are not in the whitelist will be hoisted out and thus not render properly. In such cases you should use the `is` special attribute to indicate a custom element:

``` html
<table>
  <tr is="my-component"></tr>
</table>
```

## Props

### Props によるデータ伝達

全てのコンポーネントインスタンスは、自身で**隔離されたスコープ (isolated scope)** を持ちます。これが意味するところは、子コンポーネントのテンプレートで親データの参照が直接できない(そしてすべきでない)ということです。データは **props** を使用して子コンポーネントに伝達できます。

"prop" は、親コンポーネントから受信されることを期待されるコンポーネントデータ上のフィールドです。子コンポーネントは、[`props` オプション](/api/options.html#props)を利用して受信することを期待するために、明示的に宣言する必要があります:

``` js
Vue.component('child', {
  // props を宣言
  props: ['msg'],
  // prop は内部テンプレートで利用でき、
  // そして `this.msg` として設定される
  template: '<span>{{ msg }}</span>'
})
```

そのとき、以下のようにプレーン文字列を渡すことができます:

``` html
<child msg="hello!"></child>
```

**結果:**

{% raw %}
<div id="prop-example-1" class="demo">
  <child msg="hello!"></child>
</div>
<script>
new Vue({
  el: '#prop-example-1',
  components: {
    child: {
      props: ['msg'],
      template: '<span>{{ msg }}</span>'
    }
  }
})
</script>
{% endraw %}

### キャメルケース 対 ケバブケース

HTML の属性は大文字と小文字を区別しません。キャメルケースされた prop 名を属性として使用するとき、それらをケバブケース(ハイフンで句切られた)として使用する必要があります:

``` js
Vue.component('child', {
  // camelCase in JavaScript
  props: ['myMessage'],
  template: '<span>{{ myMessage }}</span>'
})
```

``` html
<!-- kebab-case in HTML -->
<child my-message="hello!"></child>
```

### 動的な Props

Similar to binding a normal attribute to an expression, we can also use `v-bind` for dynamically binding props to data on the parent. Whenever the data is updated in the parent, it will also flow down to the child:

``` html
<div>
  <input v-model="parentMsg">
  <br>
  <child v-bind:my-message="parentMsg"></child>
</div>
```

It is often simpler to use the shorthand syntax for `v-bind`:

``` html
<child :my-message="parentMsg"></child>
```

**Result:**

{% raw %}
<div id="demo-2" class="demo">
  <input v-model="parentMsg">
  <br>
  <child v-bind:my-message="parentMsg"></child>
</div>
<script>
new Vue({
  el: '#demo-2',
  data: {
    parentMsg: 'Message from parent'
  },
  components: {
    child: {
      props: ['myMessage'],
      template: '<span>{{myMessage}}</span>'
    }
  }
})
</script>
{% endraw %}

### Prop バインディングタイプ

デフォルトで、全ての props は子プロパティと親プロパティとの間で **one way down** バインディングです。親プロパティが更新するとき子と同期されますが、その逆はありません。このデフォルトは、子コンポーネントが誤ってアプリのデータフローが推理しづらい親の状態の変更しないように防ぐためです。しかしながら、明示的に two-way または `.sync` そして `.once` **バインディングタイプモディファイア (binding type modifiers)** による one-time バインディングを強いることも可能です:

シンタックスの比較:

``` html
<!-- デフォルトは one-way-down バインディング -->
<child :msg="parentMsg"></child>

<!-- 明示的な two-way バインディング -->
<child :msg.sync="parentMsg"></child>

<!-- 明示的な one-time バインディング -->
<child :msg.once="parentMsg"></child>
```

two-way バインディングは子の `msg` プロパティの変更を親の `parentMsg` プロパティに戻して同期します。one-time バインディングは、一度セットアップし、親と子との間では、先の変更は同期しません。

<p class="tip">もし、渡される prop がオブジェクトまたは配列ならば、それは参照で渡されることに注意してください。オブジェクトの変更または配列は、使用しているバインディングのタイプに関係なく、子の内部それ自身は、親の状態に影響を**与えます**。</p>

### Prop 検証

コンポーネントは受け取る props に対する必要条件を指定することができます。これは他の人に使用されるために目的とされたコンポーネントを編集するときに便利で、これらの prop 検証要件は本質的にはコンポーネントの API を構成するものとして、ユーザーがコンポーネントを正しく使用しているということを保証します。文字列の配列として定義している props の代わりに、検証要件を含んだオブジェクトハッシュフォーマットを使用できます:

``` js
Vue.component('example', {
  props: {
    // 基本な型チェック (`null` はどんな型でも受け付ける)
    propA: Number,
    // a required string
    propB: {
      type: String,
      required: true
    },
    // a number with default value
    propC: {
      type: Number,
      default: 100
    },
    // オブジェクト/配列のデフォルトはファクトリ関数から返されるべきです
    propD: {
      type: Object,
      default: function () {
        return { msg: 'hello' }
      }
    },
    // indicate this prop expects a two-way binding. will
    // raise a warning if binding type does not match.
    propE: {
      twoWay: true
    },
    // カスタムバリデータ関数
    propF: {
      validator: function (value) {
        return value > 10
      }
    }
  }
})
```

`type` は次のネイティブなコンストラクタのいずれかになります:

- String
- Number
- Boolean
- Function
- Object
- Array

加えて、`type` はカスタムコンストラクタ、そして assertion は `instanceof` チェック もできます。

prop 検証が失敗するとき、Vue は値を子コンポーネントへのセットを拒否し、そしてもし開発ビルドを使用している場合は警告します。

## Parent-Child Communication

### Parent Chain

A child component holds access to its parent component as `this.$parent`. A root Vue instance will be available to all of its descendants as `this.$root`. Each parent component has an array, `this.$children`, which contains all its child components.

Although it's possible to access any instance the parent chain, you should avoid directly relying on parent data in a child component and prefer passing data down explicitly using props. In addition, it is a very bad idea to mutate parent state from a child component, because:

1. It makes the parent and child tightly coupled;

2. It makes the parent state much harder to reason about when looking at it alone, because its state may be modified by any child! Ideally, only a component itself should be allowed to modify its own state.

### Custom Events

All Vue instances implement a custom event interface that facilitates communication within a component tree. This event system is independent from the native DOM events and works differently.

Each Vue instance is an event emitter that can:

- Listen to events using `$on()`;

- Trigger events on self using `$emit()`;

- Dispatch an event that propagates upward along the parent chain using `$dispatch()`;

- Broadcast an event that propagates downward to all descendants using `$broadcast()`.

<p class="tip">Unlike DOM events, Vue events will automatically stop propagation after triggering callbacks for the first time along a propagation path, unless the callback explicitly returns `true`.</p>

A simple example:

``` html
<!-- template for child -->
<template id="child-template">
  <input v-model="msg">
  <button v-on:click="notify">Dispatch Event</button>
</template>

<!-- template for parent -->
<div id="events-example">
  <p>Messages: {{ messages | json }}</p>
  <child></child>
</div>
```

``` js
// register child, which dispatches an event with
// the current message
Vue.component('child', {
  template: '#child-template',
  data: function () {
    return { msg: 'hello' }
  },
  methods: {
    notify: function () {
      if (this.msg.trim()) {
        this.$dispatch('child-msg', this.msg)
        this.msg = ''
      }
    }
  }
})

// bootstrap parent, which pushes message into an array
// when receiving the event
var parent = new Vue({
  el: '#events-example',
  data: {
    messages: []
  },
  // the `events` option simply calls `$on` for you
  // when the instance is created
  events: {
    'child-msg': function (msg) {
      // `this` in event callbacks are automatically bound
      // to the instance that registered it
      this.messages.push(msg)
    })
  }
})
```

{% raw %}
<template id="child-template">
  <input v-model="msg">
  <button v-on:click="notify">Dispatch Event</button>
</template>

<div id="events-example" class="demo">
  <p>Messages: {{ messages | json }}</p>
  <child></child>
</div>
<script>
Vue.component('child', {
  template: '#child-template',
  data: function () {
    return { msg: 'hello' }
  },
  methods: {
    notify: function () {
      if (this.msg.trim()) {
        this.$dispatch('child-msg', this.msg)
        this.msg = ''
      }
    }
  }
})

var parent = new Vue({
  el: '#events-example',
  data: {
    messages: []
  },
  events: {
    'child-msg': function (msg) {
      this.messages.push(msg)
    }
  }
})
</script>
{% endraw %}

### v-on for Custom Events

The example above is pretty nice, but when we are looking at the parent's code, it's not so obvious where the `"child-msg"` event comes from. It would be better if we can declare the event handler in the template, right where the child component is used. To make this possible, `v-on` can be used to listen for custom events when used on a child component:

``` html
<child v-on:child-msg="handleIt"></child>
```

This makes things very clear: when the child triggers the `"child-msg"` event, the parent's `handleIt` method will be called. Any code that affects the parent's state will be inside the `handleIt` parent method; the child is only concerned with triggering the event.

### 子コンポーネントの参照

props やイベントの存在にもかかわらず、時々 JavaScript でネストした子コンポーネントへのアクセスが必要になる場合があります。それを実現するためには `v-ref` を用いて子コンポーネントに対して参照 ID を割り当てる必要があります。例えば:

``` html
<div id="parent">
  <user-profile v-ref:profile></user-profile>
</div>
```

``` js
var parent = new Vue({ el: '#parent' })
// 子コンポーネントのインスタンスへのアクセス
var child = parent.$.profile
```

`v-ref` が `v-for` と共に使用された時は、得られる値はそのデータの配列またはオブジェクトをミラーリングした子コンポーネントが格納されているデータソースになります。

## Content Distribution with Slots

When using components, it is often desired to compose them like this:

``` html
<app>
  <app-header></app-header>
  <app-footer></app-footer>
</app>
```

There are two things to note here:

1. The `<app>` component do not know what content may be present inside its mount target. It is decided by whatever parent component that is using `<app>`.

2. The `<app>` component very likely has its own template.

To make the composition work, we need a way to interweave the parent "content" and the component's own template. This is a process called **content distribution** (or "transclusion" if you are familiar with Angular). Vue.js implements a content distribution API that is modeled after with the current [Web Components spec draft](https://github.com/w3c/webcomponents/blob/gh-pages/proposals/Slots-Proposal.md), using the special `<slot>` element to serve as distribution outlets for the original content.

### Compilation Scope

Before we dig into the API, let's first clarify which scope the contents are compiled in. Imagine a template like this:

``` html
<child>
  {{ msg }}
</child>
```

Should the `msg` be bound to the parent's data or the child data? The answer is parent. A simple rule of thumb for component scope is:

> Everything in the parent template is compiled in parent scope; everything in the child template is compiled in child scope.

A common mistake is trying to bind a directive to a child property/method in the parent template:

``` html
<!-- does NOT work -->
<child v-show="someChildProperty"></child>
```

Assuming `someChildProperty` is a property on the child component, the example above would not work as intended. The parent's template should not be aware of the state of a child component.

If you need to bind child-scope directives on a component root node, you should do so in the child component's own template:

``` js
Vue.component('child-component', {
  // this does work, because we are in the right scope
  template: '<div v-show="someChildProperty">Child</div>',
  data: function () {
    return {
      someChildProperty: true
    }
  }
})
```

Similarly, distributed content will be compiled in the parent scope.

### Single Slot

Parent content will be **discarded** unless the child component template contains at least one `<slot>` outlet. When there is only one slot with no attributes, the entire content fragment will be inserted at its position in the DOM, replacing the slot itself.

Anything originally inside the `<slot>` tags is considered **fallback content**. Fallback content is compiled in the child scope and will only be displayed if the hosting element is empty and has no content to be inserted.

Suppose we have a component with the following template:

``` html
<div>
  <h1>This is my component!</h1>
  <slot>
    This will only be displayed if there is no content
    to be distributed.
  </slot>
</div>
```

このコンポーネントを使用した親のマークアップ:

``` html
<my-component>
  <p>This is some original content</p>
  <p>This is some more original content</p>
</my-component>
```

レンダリング結果:

``` html
<div>
  <h1>This is my component!</h1>
  <p>This is some original content</p>
  <p>This is some more original content</p>
</div>
```

### Named Slots

`<slot>` elements have a special attribute, `name`, which can be used to further customize how content should be distributed. You can have multiple slots with different names. A named slot will match any element that has a corresponding `slot` attribute in the content fragment.

There can still be one unnamed slot, which is the **default slot** that serves as a catch-all outlet for any unmatched content. If there is no default slot, unmatched content will be discarded.

例として、以下のテンプレートのような、多数のコンポーネント挿入のテンプレートを持っていると仮定:

``` html
<div>
  <slot name="one"></slot>
  <slot></slot>
  <slot name="two"></slot>
</div>
```

親のマークアップ:

``` html
<multi-insertion>
  <p slot="one">One</p>
  <p slot="two">Two</p>
  <p>Default A</p>
</multi-insertion>
```

レンダリングされる結果:

``` html
<div>
  <p slot="one">One</p>
  <p>Default A</p>
  <p slot="two">Two</p>
</div>
```

The content distribution API is a very useful mechanism when designing components that are meant to be composed together.

## 動的コンポーネント

同じマウントポイント、そして予約された `<component>` 要素と動的にバインドする `is` 属性を使って複数のコンポーネントを動的に切り替えることができます:

``` js
new Vue({
  el: 'body',
  data: {
    currentView: 'home'
  },
  components: {
    home: { /* ... */ },
    posts: { /* ... */ },
    archive: { /* ... */ }
  }
})
```

``` html
<component :is="currentView">
  <!-- vm.currentview が変更されると、中身が変更されます! -->
</component>
```

状態を保持したりや再レンダリングを避けたりするために、もし切り替えられたコンポーネントを活性化された状態で保持したい場合は、ディレクティブのパラメータ `keep-alive` を追加することができます:

``` html
<component :is="currentView" keep-alive>
  <!-- 非活性になったコンポーネントをキャッシュします! -->
</component>
```

### `activate` Hook

When switching components, the incoming component might need to perform some asynchronous operation before it should be swapped in. To control the timing of component swapping, implement the `activate` hook on the incoming component:

``` js
Vue.component('activate-example', {
  activate: function (done) {
    var self = this
    loadDataAsync(function (data) {
      self.someData = data
      done()
    })
  }
})
```

Note the `activate` hook is only used for dynamic component swapping - it does not affect static components and manual insertions with instance methods.

### `transition-mode`

`transition-mode` パラメータ属性はどうやって2つの動的コンポーネント間でトランジションが実行されるべきかどうか指定できます。

デフォルトでは、入ってくるコンポーネントと出て行くコンポーネントのトランジションが同時に起こります。この属性によって、2つの他のモードを設定することができます:

- `in-out`: 新しいコンポーネントのトランジションが初めに起こり、そのトランジションが完了した後に現在のコンポーネントの出て行くトランジションが開始します。

- `out-in`: 現在のコンポーネントが出て行くトランジションが初めに起こり、そのトランジションが完了した後に新しいコンポーネントのトランジションが開始します。

**例**

``` html
<!-- 先にフェードアウトし, その後フェードインします -->
<component
  :is="view"
  transition="fade"
  transition-mode="out-in">
</component>
```

``` css
.fade-transition {
  transition: opacity .3s ease;
}
.fade-enter, .fade-leave {
  opacity: 0;
}
```

{% raw %}
<div id="transition-mode-demo" class="demo">
  <input v-model="view" type="radio" value="v-a" id="a" name="view"><label for="a">A</label>
  <input v-model="view" type="radio" value="v-b" id="b" name="view"><label for="b">B</label>
  <component
    :is="view"
    transition="fade"
    transition-mode="out-in">
  </component>
</div>
<style>
  .fade-transition {
    transition: opacity .3s ease;
  }
  .fade-enter, .fade-leave {
    opacity: 0;
  }
</style>
<script>
new Vue({
  el: '#transition-mode-demo',
  data: {
    view: 'v-a'
  },
  components: {
    'v-a': {
      template: '<div>Component A</div>'
    },
    'v-b': {
      template: '<div>Component B</div>'
    }
  }
})
</script>
{% endraw %}

## Misc

### Authoring Reusable Components

When authoring components, it is good to keep in mind whether you intend to reuse this component somewhere else later. It is OK for one-off components to have some tight coupling with each other, but reusable components should define a clean public interface.

The API for a Vue.js component essentially comes in three parts - props, events and slots:

- **Props** allow the external environment to feed data to the component;

- **Events** allow the component to trigger actions in the external environment;

- **Slots** allow the external environment to insert content into the component's view structure.

With the dedicate shorthand syntax for `v-bind` and `v-on`, the intents can be clearly and succinctly conveyed in the template:

``` html
<my-component
  :foo="baz"
  :bar="qux"
  @event-a="doThis"
  @event-b="doThat">
  <!-- content -->
  <img slot="icon" src="...">
  <p slot="main-text">Hello!</p>
</my-component>
```

### 非同期コンポーネント

大規模アプリケーションでは、実際に必要になったとき、サーバからコンポーネントをロードするだけの、アプリケーションを小さい塊に分割する必要があるかもしれません。それを簡単にするために、Vue.js はコンポーネント定義を非同期的に解決するファクトリ関数としてあなたのコンポーネントを定義することができます。Vue.js はコンポーネントが実際に描画が必要になったときファクトリ関数のみトリガし、そして将来の再描画のために結果をキャッシュします。例えば:

``` js
Vue.component('async-example', function (resolve, reject) {
  setTimeout(function () {
    resolve({
      template: '<div>I am async!</div>'
    })
  }, 1000)
})
```

ファクトリ関数は `resolve` コールバックを受け取り、その引数はサーバからあなたのコンポーネント定義を取り戻すときに呼ばれるべきです。ロードが失敗したことを示すために、`reject(reason)` も呼び出すことができます。ここでは `setTimeout` はデモとしてシンプルです。どうやってコンポーネントを取得するかどうかは完全にあなた次第です。1つ推奨されるアプローチは [Webpack のコード分割機能](http://webpack.github.io/docs/code-splitting.html)で非同期コンポーネントを使うことです。

``` js
Vue.component('async-webpack-example', function (resolve) {
  // この特別な require シンタックスは、
  // 自動的に ajax リクエストでロードされているバンドルで、
  // あなたのビルドコードを自動的に分割するために
  // webpack で指示しています。
  require(['./my-async-component'], resolve)
})
```

### アセットの命名規則

コンポーネントやディレクティブのようなあるアセットは、HTML 属性または HTML カスタムタグの形でテンプレートに表示されます。HTML 属性名とタグ名は**大文字と小文字を区別しない (case-insensitive)** ため、私達はしばしばキャメルケースの代わりにケバブケースを使用して私達のアセットに名前をつける必要がありますが、これは少し不便です。

Vue.js は実際にキャメルケースまたはパスカルケース (PascalCase) を使用してアセットを命名するのをサポートし、自動的にそれらをテンプレートでケバブケースとして解決します (props の命名と似ています):

``` js
// コンポーネント定義
components: {
  // キャメルケースを使用して登録
  myComponent: { /*... */ }
}
```

``` html
<!-- テンプレートではダッシュケースを使用 -->
<my-component></my-component>
```

これは [ES6 object literal shorthand](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Object_initializer#New_notations_in_ECMAScript_6) でうまく動作します:

``` js
// PascalCase
import TextBox from './components/text-box';
import DropdownMenu from './components/dropdown-menu';

export default {
  components: {
    // <text-box> そして <dropdown-menu> としてテンプレートで使用
    TextBox,
    DropdownMenu
  }
}
```

### Recursive Component

Components can recursively invoke itself in its own template, however, it can only do so when it has the `name` option:

``` js
var StackOverflow = Vue.extend({
  name: 'stack-overflow',
  template:
    '<div>' +
      // recursively invoke self
      '<stack-overflow></stack-overflow>' +
    '</div>'
})
```

A component like the above will result in a "max stack size exceeded" error, so make sure recursive invocation is conditional. When you register a component globally using `Vue.component()`, the global ID is automatically set as the component's `name` option.

### Fragment Instance

When you use the `template` option, the content of the template will replace the element the Vue instance is mounted on. It is therefore recommended to always include a single root-level element in templates.

There are a few conditions that will turn a Vue instance into a **fragment instance**:

1. Template contains multiple top-level elements.
2. Template contains only plain text.
3. Template contains only another component.
4. Template contains only an element directive, e.g. `<partial>` or vue-router's `<router-view>`.
5. Template root node has a flow-control directive, e.g. `v-if` or `v-for`.

The reason is that all of the above cause the instance to have an unknown number of top-level elements, so it has to manage its DOM content as a fragment. A fragment instance will still render the content correctly. However, it will **not** have a root node, and its `$el` will point to an "anchor node", which is an empty Text node (or a Comment node in debug mode).

What's more important though, is that **non-flow-control directives, non-prop attributes and transitions on the component element will be ignored**, because there is no root element to bind them to:

``` html
<!-- doesn't work due to no root element -->
<example v-show="ok" transition="fade"></example>

<!-- props work -->
<example :prop="someData"></example>

<!-- flow control works, but without transitions -->
<example v-if="ok"></example>
```

There are, of course, valid use cases for fragment instances, but it is in general a good idea to give your component template a single, plain root element. It ensures directives and attributes on the component element to be properly transferred, and also results in slightly better performance.

### Inline Template

When the `inline-template` special attribute is present on a child component, the component will use its inner content as its template, rather than treating it as distributed content. This allows more flexible template-authoring.

``` html
<my-component inline-template>
  <p>These are compiled as the component's own template</p>
  <p>Not parent's transclusion content.</p>
</my-component>
```

However, `inline-template` makes the scope of your templates harder to reason about, and makes the component's template compilation un-cachable. As a best practice, prefer defining templates inside the component using the `template` option.
