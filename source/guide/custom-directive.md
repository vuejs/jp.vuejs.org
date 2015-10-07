title: カスタムディレクティブ
type: guide
order: 14
---

## Basics

In addition to the default set of directives shipped in core, Vue.js also allows you to register custom directives. Custom directives provide a mechanism for mapping data changes to arbitrary DOM behavior.

You can register a global custom directive with the `Vue.directive(id, definition)` method, passing in a **directive id** followed by a **definition object**. You can also register a local custom directive by including it in a component's `directives` option.

### Hook Functions

A definition object can provide several hook functions (all optional):

- **bind**: called only once, when the directive is first bound to the element.

- **update**: called for the first time immediately after `bind` with the initial value, then again whenever the binding value changes. The new value and the previous value are provided as the argument.

- **unbind**: called only once, when the directive is unbound from the element.

**例**

``` js
Vue.directive('my-directive', {
  bind: function () {
    // 準備のための作業をします
    // e.g. イベントリスナを追加したり、一回だけ実行が必要なコストのかかる処理を行う
  },
  update: function (newValue, oldValue) {
    // 更新された値に何か処理をします
    // この部分は初期値に対しても呼ばれます
  },
  unbind: function () {
    // クリーンアップのための処理を行います
    // e.g. bind()の中で追加されたイベントリスナの削除
  }
})
```

Once registered, you can use it in Vue.js templates like this (remember to add the `v-` prefix):

``` html
<div v-my-directive="someValue"></div>
```

`update` 関数のみが必要な場合は、definition object の代わりに関数を1つ渡すこともできます:


``` js
Vue.directive('my-directive', function (value) {
  // この関数は update() として使用される
})
```

### Directive Instance Properties

All the hook functions will be copied into the actual **directive object**, which you can access inside these functions as their `this` context. The directive object exposes some useful properties:

- **el**: the element the directive is bound to.
- **vm**: the context ViewModel that owns this directive.
- **expression**: the expression of the binding, excluding arguments and filters.
- **arg**: the argument, if present.
- **name**: the name of the directive, without the prefix.
- **descriptor**: an object that contains the parsing result of the entire directive.

<p class="tip">You should treat all these properties as read-only and never modify them. You can attach custom properties to the directive object too, but be careful not to accidentally overwrite existing internal ones.</p>

いくつかのプロパティを使用したカスタムディレクティブの例:

``` html
<div id="demo" v-demo:hello="msg"></div>
```

``` js
Vue.directive('demo', {
  bind: function () {
    this.el.style.color = '#fff'
    this.el.style.backgroundColor = this.arg
  },
  update: function (value) {
    this.el.innerHTML =
      'name - '       + this.name + '<br>' +
      'expression - ' + this.expression + '<br>' +
      'argument - '   + this.arg + '<br>' +
      'value - '      + value
  }
})
var demo = new Vue({
  el: '#demo',
  data: {
    msg: 'hello!'
  }
})
```

**結果**

<div id="demo" v-demo:hello="msg"></div>
<script>
Vue.directive('demo', {
  bind: function () {
    console.log('demo bound!')
  },
  update: function (value) {
    this.el.innerHTML =
      'name - ' + this.name + '<br>' +
      'expression - ' + this.expression + '<br>' +
      'argument - ' + this.arg + '<br>' +
      'value - ' + value
  }
})
var demo = new Vue({
  el: '#demo',
  data: {
    msg: 'world!'
  }
})
</script>

### Object Literals

If your directive needs multiple values, you can also pass in a JavaScript object literal. Remember, directives can take any valid JavaScript expression:

``` html
<div v-demo="{ color: 'white', text: 'hello!' }"></div>
```

``` js
Vue.directive('demo', function (value) {
  console.log(value.color) // "white"
  console.log(value.text) // "hello!"
})
```

### Literal Modifier

When a directive is used with the literal modifer, its attribute value will be interpreted as a plain string and passed directly into the `update` method. The `update` method will also be called only once, because a plain string cannot be reactive.

``` html
<div v-demo.literal="foo bar baz">
```
``` js
Vue.directive('demo', function (value) {
  console.log(value) // "foo bar baz"
})
```

## Advanced Options

### deep

If your custom directive is expected to be used on an Object, and it needs to trigger `update` when a nested property inside the object changes, you need to pass in `deep: true` in your directive definition.

``` html
<div v-my-directive="obj"></div>
```

``` js
Vue.directive('my-directive', {
  deep: true,
  update: function (obj) {
    // will be called when nested properties in `obj`
    // changes.
  }
})
```

### twoWay


``` js
Vue.directive('example', {
  twoWay: true,
  bind: function () {
    this.handler = function () {
      // vm にデータをセットします
      // もしディレクティブが v-example="a.b.c" と紐付いている場合,
      // 与えられた値を `vm.a.b.c` に
      // セットしようと試みます
      this.set(this.el.value)
    }.bind(this)
    this.el.addEventListener('input', this.handler)
  },
  unbind: function () {
    this.el.removeEventListener('input', this.handler)
  }
})
```

### acceptStatement

 `acceptStatement:true` を渡すことでカスタムディレクティブが `v-on` が行っているようなインラインステートメントを使用できるようになります: 

``` html
<div v-my-directive="a++"></div>
```

``` js
Vue.directive('my-directive', {
  acceptStatement: true,
  update: function (fn) {
    // 呼び出される際に渡される値は function です
    // function は "a++" ステートメントを
    // 所有者の vm　のスコープで実行します
  }
})
```

ただし、テンプレート内のサイドエフェクトを避けるためにも、賢く使いましょう。

### priority

ディレクティブには任意で優先度の数値 (デフォルトは0) を与えることができます。同じ要素上で高い優先度をもつディレクティブは他のディレクティブより早く処理されます。同じ優先度をもつディレクティブは要素上の属性のリストに出現する順番で処理されますが、ブラウザが異なる場合、一貫した順番になることは保証されません。

You can checkout the priorities for some built-in directives in the [API reference](/api/directives.html). Additionally, flow control directives `v-if` and `v-for` always have the highest priority in the compilation process.

## エレメントディレクティブ

いくつのケースでは、属性としてよりむしろカスタム要素の形でディレクティブを使いたい場合があります。これは、Angular の "E" モードディレクティブの概念に非常に似ています。エレメントディレクティブは軽量な代替を本格的なコンポーネントとして提供します(ガイドの後半で説明されています)。カスタム要素をディレクティブのように登録できます:

``` js
Vue.elementDirective('my-directive', {
  // 標準のディレクティブのような同じ API
  bind: function () {
    // this.el を操作 ...
  }
})
```

この時、以下の代わりに:

``` html
<div v-my-directive></div>
```

以下のように書くことができます:

``` html
<my-directive></my-directive>
```

エレメントディレクティブは引数または expressions を受け付けることはできません。しかし、その振舞いを決定するために要素の属性を読み取ることはできます。

A big difference from normal directives is that element directives are **terminal**, which means once Vue encounters an element directive, it will leave that element and all its children alone - only the element directive itself will be able to manipulate that element and its children. 
