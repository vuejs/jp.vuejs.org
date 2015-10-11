title: カスタムディレクティブ
type: guide
order: 14
---

## Basics

In addition to the default set of directives shipped in core, Vue.js also allows you to register custom directives. Custom directives provide a mechanism for mapping data changes to arbitrary DOM behavior.

You can register a global custom directive with the `Vue.directive(id, definition)` method, passing in a **directive id** followed by a **definition object**. You can also register a local custom directive by including it in a component's `directives` option.

### フック関数

definition object はいくつかの hook 関数(全て任意)を提供します:

- **bind**: ディレクティブが初めて対象のエレメントに紐付いた時に一度だけ呼ばれます。

- **update**: 初めの一度は bind の直後に初期値とともに呼ばれ、以降、バインディングされている値が変更される度に呼ばれます。引数には新しい値と以前の値が渡されます。

- **unbind**: ディレクティブが紐付いているエレメントから取り除かれた時に一度だけ呼ばれます。

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

一度登録された後は、以下のように Vue.js のテンプレート内で使用することができます (`v-` の接頭辞を追加するのを忘れないでください):

``` html
<div v-my-directive="someValue"></div>
```

`update` 関数のみが必要な場合は、definition object の代わりに関数を1つ渡すこともできます:


``` js
Vue.directive('my-directive', function (value) {
  // この関数は update() として使用される
})
```

### ディレクティブインスタンスのプロパティ

全ての hook 関数は実際に **directive object** にコピーされます。directive object は hook 関数の内側で `this` のコンテキストとしてアクセスすることができます。この directive object はいくつかの便利なプロパティを持っています:

- **el**: ディレクティブが紐づく要素
- **vm**: このディレクティブを所有する ViewModel
- **expression**: 引数とフィルタ以外のバインディングの expression
- **arg**: 引数(もしある場合)
- **name**: prefix 無しのディレクティブの名前
- **descriptor**: 全体のディレクティブの解析結果を含むオブジェクト。

<p class="tip">これらの全てのプロパティは read-only で変更しないものとして扱わなくてはいけません。カスタムプロパティを directive object に追加することができますが、意図せずに既存の内部プロパティを上書きしないように注意が必要です。</p>

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

## 高度なオプション

### deep

もしカスタムディレクティブでオブジェクトを扱いたい場合で、オブジェクトの内側のネストされたプロパティが変更された時に `update` をトリガしたい場合は、ディレクティブの定義に `deep: true` を渡す必要があります。

``` html
<div v-my-directive="obj"></div>
```

``` js
Vue.directive('my-directive', {
  deep: true,
  update: function (obj) {
    // `obj` の中のネストされたプロパティが
    // 変更された時に呼ばれる
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

いくつかのビルトインディレクティブに関する優先度は [API リファレンス](/api/directives.html) で確認できます。さらに フロー制御するディレクティブ `v-if` と `v-for` は、コンパイル処理の中で常に最も高い優先度を持ちます。

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

標準のディレクティブとの大きな違いは、エレメントディレクティブは**ターミナル**で、Vue が一度エレメントディレクティブに遭遇したことを意味します。それは、要素とその子を残したまま、エレメントディレクティブそれ自体、要素とその子を操作することができるようになります。
