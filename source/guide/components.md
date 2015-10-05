title: コンポーネントシステム
type: guide
order: 11
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

### Props による伝達

デフォルトでは、コンポーネントは**隔離されたスコープ (isolated scope) **を持ちます。これが意味するところは、子コンポーネントのテンプレートの中で親データの参照ができないということです。データを隔離されたスコープで子コンポーネントに渡すためには、`props` を利用する必要があります。

"prop" は、親コンポーネントから受信されることを期待されるコンポーネントデータ上のフィールドです。子コンポーネントは、[`props` オプション](/api/options.html#props)を利用して受信することを期待するために、明示的に宣言する必要があります:

``` js
Vue.component('child', {
  // props を宣言
  props: ['msg'],
  // prop は内部テンプレートで利用でき、
  // そして `this.msg` として設定される
  template: '<span>{{msg}}</span>'
})
```

そのとき、以下のようにデータを渡すことができます:

``` html
<child msg="hello!"></child>
```

**結果:**

<div id="prop-example-1" class="demo"><child msg="hello!"></child></div>
<script>
new Vue({
  el: '#prop-example-1',
  components: {
    child: {
      props: ['msg'],
      template: '<span>{&#123;msg&#125;}</span>'
    }
  }
})
</script>

### キャメルケース vs ハイフン付き

HTML の属性は大文字と小文字を区別しません。キャメルケースされた prop 名を属性として使用するとき、それらハイフン付き相当語句として使用する必要があります:

``` js
Vue.component('child', {
  props: ['myMessage'],
  template: '<span>{{myMessage}}</span>'
})
```

``` html
<!-- 重要: ハイフン付きの名前を使用! -->
<child my-message="hello!"></child>
```

### 動的な Props

親から動的なデータを受け取ることができます。例えば:

``` html
<div>
  <input v-model="parentMsg">
  <br>
  <child my-message="{{parentMsg}}"></child>
</div>
```

**結果:**

<div id="demo-2" class="demo"><input v-model="parentMsg"><br><child msg="{&#123;parentMsg&#125;}"></child></div>
<script>
new Vue({
  el: '#demo-2',
  data: {
    parentMsg: 'Inherited message'
  },
  components: {
    child: {
      props: ['msg'],
      template: '<span>{&#123;msg&#125;}</span>'
    }
  }
})
</script>

<p class="tip">It is also possible to expose `$data` as a prop. The passed in value must be an Object and will replace the component's default `$data`.</p>

### Prop Binding Types

シンタックスの比較:

``` html
<!-- デフォルトは one-way-down バインディング -->
<child msg="{{parentMsg}}"></child>
<!-- 明示的な two-way バインディング -->
<child msg="{{@ parentMsg}}"></child>
<!-- 明示的な one-time バインディング -->
<child msg="{{* parentMsg}}"></child>
```

two-way バインディングは子の `msg` プロパティの変更を親の `parentMsg` プロパティに戻して同期します。one-time バインディングは、一度セットアップし、親と子との間では、先の変更は同期しません。

<p class="tip">もし、渡される prop がオブジェクトまたは配列ならば、それは参照で渡されることに注意してください。オブジェクトの変更または配列は、使用しているバインディングのタイプに関係なく、子の内部それ自身は、親の状態に影響を与えます。</p>

### Prop Validation

コンポーネントは受け取る props に対する必要条件を指定することができます。これは他の人に使用されるために目的とされたコンポーネントを編集するときに便利で、これらの prop 検証要件は本質的にはコンポーネントの API を構成するものとして、ユーザーがコンポーネントを正しく使用しているということを保証します。文字列として定義している props の代わりに、検証要件を含んだオブジェクトを使用できます:

``` js
Vue.component('example', {
  props: {
    // 基本な型チェック (`null` はどんな型でも受け付ける)
    onSomeEvent: Function,
    // 存在チェック
    requiredProp: {
      type: String,
      required: true
    },
    // デフォルト値
    propWithDefault: {
      type: Number,
      default: 100
    },
    // オブジェクト/配列のデフォルトはファクトリ関数から返されるべきです
    propWithObjectDefault: {
      type: Object,
      default: function () {
        return { msg: 'hello' }
      }
    },
    // two-way prop は、もしバインディングの型が一致しない場合は警告を投げます
    twoWayProp: {
      twoWay: true
    },
    // カスタムバリデータ関数
    greaterThanTen: {
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

### Custom Events

Although you can directly access a Vue instance's children and parent, it is more convenient to use the built-in event system for cross-component communication. It also makes your code less coupled and easier to maintain. Once a parent-child relationship is established, you can dispatch and trigger events using each component's [event instance methods](/api/instance-methods.html#Events).

``` js
var parent = new Vue({
  template: '<div><child></child></div>',
  created: function () {
    this.$on('child-created', function (child) {
      console.log('new child created: ')
      console.log(child)
    })
  },
  components: {
    child: {
      created: function () {
        this.$dispatch('child-created', this)
      }
    }
  }
}).$mount()
```

<script>
var parent = new Vue({
  template: '<div><child></child></div>',
  created: function () {
    this.$on('child-created', function (child) {
      console.log('new child created: ')
      console.log(child)
    })
  },
  components: {
    child: {
      created: function () {
        this.$dispatch('child-created', this)
      }
    }
  }
}).$mount()
</script>

### Child Component Refs

Sometimes you might need to access nested child components in JavaScript. To enable that you have to assign a reference ID to the child component using `v-ref`. For example:

``` html
<div id="parent">
  <user-profile v-ref="profile"></user-profile>
</div>
```

``` js
var parent = new Vue({ el: '#parent' })
// access child component
var child = parent.$.profile
```

When `v-ref` is used together with `v-repeat`, the value you get will be an Array containing the child components mirroring the data Array.

## Content Distribution with Slots

When creating reusable components, we often need to access and reuse the original content in the hosting element, which are not part of the component (similar to the Angular concept of "transclusion".) Vue.js implements a content insertion mechanism that is compatible with the current Web Components spec draft, using the special `<content>` element to serve as insertion points for the original content.

### Compilation Scope

Every Vue.js component is a separate Vue instance with its own scope. It's important to understand how scopes work when using components. The rule of thumb is:

> If something appears in the parent template, it will be compiled in parent scope; if it appears in child template, it will be compiled in child scope.

A common mistake is trying to bind a directive to a child property/method in the parent template:

``` html
<div id="demo">
  <!-- does NOT work -->
  <child-component v-on="click: childMethod"></child-component>
</div>
```

If you need to bind child-scope directives on a component root node, you should do so in the child component's own template:

``` js
Vue.component('child-component', {
  // this does work, because we are in the right scope
  template: '<div v-on="click: childMethod">Child</div>',
  methods: {
    childMethod: function () {
      console.log('child method invoked!')
    }
  }
})
```

Similarly, HTML content inside a component container are considered "transclusion content". They will not be inserted anywhere unless the child template contains at least one `<content></content>` outlet. The inserted contents are also compiled in parent scope:

``` html
<div>
  <child-component>
    <!-- compiled in parent scope -->
    <p>{{msg}}</p>
  </child-component>
</div>
```

You can use the `inline-template` attribute to indicate you want the content to be compiled in the child scope as the child's template:

``` html
<div>
  <child-component inline-template>
    <!-- compiled in child scope -->
    <p>{{msg}}</p>
  </child-component>
</div>
```

### Single Slot

When there is only one `<content>` tag with no attributes, the entire original content will be inserted at its position in the DOM and replaces it. Anything originally inside the `<content>` tags is considered **fallback content**. Fallback content will only be displayed if the hosting element is empty and has no content to be inserted. For example:

Template for `my-component`:

``` html
<div>
  <h1>This is my component!</h1>
  <content>This will only be displayed if no content is inserted</content>
</div>
```

Parent markup that uses the component:

``` html
<my-component>
  <p>This is some original content</p>
  <p>This is some more original content</p>
</my-component>
```

The rendered result will be:

``` html
<div>
  <h1>This is my component!</h1>
  <p>This is some original content</p>
  <p>This is some more original content</p>
</div>
```

### Multiple Slots

`<content>` elements have a special attribute, `select`, which expects a CSS selector. You can have multiple `<content>` insertion points with different `select` attributes, and each of them will be replaced by the elements matching that selector from the original content.

<p class="tip">Starting in 0.11.6, `<content>` selectors can only match top-level children of the host node. This keeps the behavior consistent with the Shadow DOM spec and avoids accidentally selecting unwanted nodes in nested transclusions.</p>

For example, suppose we have a `multi-insertion` component with the following template:

``` html
<div>
  <content select="p:nth-child(3)"></content>
  <content select="p:nth-child(2)"></content>
  <content select="p:nth-child(1)"></content>
</div>
```

Parent markup:

``` html
<multi-insertion>
  <p>One</p>
  <p>Two</p>
  <p>Three</p>
</multi-insertion>
```

The rendered result will be:

``` html
<div>
  <p>Three</p>
  <p>Two</p>
  <p>One</p>
</div>
```

The content insertion mechanism provides fine control over how original content should be manipulated or displayed, making components extremely flexible and composable.

## 動的コンポーネント

予約された `component` 要素を使って、"ページをスワップ" を成し遂げるためにコンポーネントを動的に切り替える仕組みがあります:

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
<component is="{{currentView}}">
  <!-- vm.currentview が変更されると、中身が変更されます! -->
</component>
```

状態を保持したりや再レンダリングを避けたりするために、もし切り替えられたコンポーネントを活性化された状態で保持したい場合は、ディレクティブのパラメータ `keep-alive` を追加することができます:

``` html
<component is="{{currentView}}" keep-alive>
  <!-- 非活性になったコンポーネントをキャッシュします! -->
</component>
```

### `activate` Hook

DOM と切り替えられる前に、挿入される子コンポーネントを待つためのイベント名です。トランジションの開始そして空のコンテンツ表示を回避する前に非同期なデータのロードを待つことが可能になります。

この属性は、静的そして動的コンポーネント上の両方で使用できます。動的コンポーネントでは、全てのコンポーネントが潜在的に待機イベントを `$emit` する必要があるためにレンダリングされ、それ以外の場合は、それらは挿入されることはないことに注意してください。

**例:**

``` html
<!-- 静的 -->
<my-component wait-for="data-loaded"></my-component>

<!-- 動的 -->
<component is="{{view}}" wait-for="data-loaded"></component>
```

``` js
// コンポーネントの定義
{
  // compiled フックの中で非同期にデータを取得してイベントを発火します。
  // 例として jQuery を使っています。
  compiled: function () {
    var self = this
    $.ajax({
      // ...
      success: function (data) {
        self.$data = data
        self.$emit('data-loaded')
      }
    })
  }
}
```

### `transition-mode`

`transition-mode` パラメータ属性はどうやって2つの動的コンポーネント間でトランジションが実行されるべきかどうか指定できます。

デフォルトでは、入ってくるコンポーネントと出て行くコンポーネントのトランジションが同時に起こります。この属性によって、2つの他のモードを設定することができます:

- `in-out`: 新しいコンポーネントのトランジションが初めに起こり、そのトランジションが完了した後に現在のコンポーネントの出て行くトランジションが開始します。
- `out-in`: 現在のコンポーネントが出て行くトランジションが初めに起こり、そのトランジションが完了した後に新しいコンポーネントのトランジションが開始します。

**例**

``` html
<!-- 先にフェードアウトし, その後フェードインします -->
<component is="{{view}}"
  v-transition="fade"
  transition-mode="out-in">
</component>
```

## Misc

### Async Components

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

### Fragment Instance

When you use the `template` option, the content of the template will replace the element the Vue instance is mounted on. It is therefore recommended to always include a single root-level element in templates.

There are a few conditions that will turn a Vue instance into a **fragment instance**:

1. Template contains only another component.
2. Template contains multiple top-level elements.
3. Template contains only plain text.
4. Template contains only a `<partial>`.
5. Template root node has `v-if` or `v-for`.

The reason is that all of the above cause the instance to have an unknown number of top-level elements, so it has to manage its DOM content as a fragment. A fragment instance will still render the content correctly. However, it will **not** have a root node, and its `$el` will point to an "anchor node", which is an empty Text node (or a Comment node in debug mode).

What's more important though, is that **non-terminal directives, transitions and attributes (except for props) on the component element will be ignored**, because there is no root element to bind them to:

``` html
<!-- doesn't work due to no root element -->
<example v-show="ok" transition="fade"></example>

<!-- props work -->
<example :prop="someData"></example>

<!-- v-if and v-for work as well, but without transitions -->
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

Next: [Applying Transition Effects](/guide/transitions.html).
