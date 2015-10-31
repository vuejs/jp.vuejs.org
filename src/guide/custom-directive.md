---
title: カスタムディレクティブ
type: guide
order: 14
---

## 基本

コアで出荷されたディレクティブのデフォルトセットに加えて、カスタムディレクティブ (custom directive) を登録することができます。カスタムディレクティブは任意の DOM の振舞いへのマッピングデータを変更するためのメカニズムを提供します。

`Vue.directive(id, definition)` メソッドで、**directive id** と **definition object** を続けて渡して、グローバルカスタムディレクティブに登録できます。それをコンポーネントの `directives` オプションによってローカルカスタムディレクティブに登録することもできます。

### フック関数

definition object はいくつかのフック関数(全て任意)を提供します:

- **bind**: ディレクティブが初めて対象の要素にひも付いた時に一度だけ呼ばれます。

- **update**: 初めの一度は bind の直後に初期値とともに呼ばれ、以降、バインディングされている値が変更される度に呼ばれます。引数には新しい値と以前の値が渡されます。

- **unbind**: ディレクティブがひも付いている要素から取り除かれた時に一度だけ呼ばれます。

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

全てのフック関数は実際に **ディレクティブオブジェクト (directive object)** にコピーされます。ディレクティブオブジェクトはフック関数の内側で `this` のコンテキストとしてアクセスすることができます。このディレクティブオブジェクトはいくつかの便利なプロパティを持っています:

- **el**: ディレクティブがひも付く要素
- **vm**: このディレクティブを所有する ViewModel
- **expression**: 引数とフィルタ以外のバインディング式
- **arg**: 引数(もしある場合)
- **name**: 接頭辞 (prefix) 無しのディレクティブの名前
- **modifiers**: もしあれば、修飾子 (modifier) を含んでいるオブジェクト
- **descriptor**: 全体のディレクティブの解析結果を含むオブジェクト
- **params**: params 属性を含んでいるオブジェクト。[以下で説明します](#params)

<p class="tip">これらの全てのプロパティは読み込みのみ (read-only) で変更しないものとして扱わなくてはいけません。カスタムプロパティをディレクティブオブジェクトに追加することができますが、意図せずに既存の内部プロパティを上書きしないように注意が必要です。</p>

いくつかのプロパティを使用したカスタムディレクティブの例:

``` html
<div id="demo" v-demo:hello.a.b="msg"></div>
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
      'modifiers - '  + JSON.stringify(this.modifiers) + '<br>' +
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

<div id="demo" v-demo:hello.a.b="msg"></div>
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
      'modifiers - '  + JSON.stringify(this.modifiers) + '<br>' +
      'value - ' + value
  }
})
var demo = new Vue({
  el: '#demo',
  data: {
    msg: 'hello!'
  }
})
</script>

### オブジェクトリテラル

あなたのディレクティブが複数の値を必要ならば、JavaScript オブジェクトリテラルも渡すことができます。ディレクティブは任意の妥当な JavaScript 式を取ることができるのを覚えておいてください:

``` html
<div v-demo="{ color: 'white', text: 'hello!' }"></div>
```

``` js
Vue.directive('demo', function (value) {
  console.log(value.color) // "white"
  console.log(value.text) // "hello!"
})
```

### リテラル修飾子

ディレクティブがリテラル修飾子 (literal modifier) で使用されるとき、属性の値は、プレーンな文字列として解釈され、そして直接 `update` メソッドに渡されます。`update` メソッドはプレーンな文字列はリアクティブにできないため、一度だけ呼ばれます。

``` html
<div v-demo.literal="foo bar baz">
```
``` js
Vue.directive('demo', function (value) {
  console.log(value) // "foo bar baz"
})
```

### エレメントディレクティブ

いくつのケースでは、属性としてよりむしろカスタム要素の形でディレクティブを使いたい場合があります。これは、Angular の "E" モードディレクティブの概念に非常に似ています。エレメントディレクティブ (element directive) は軽量な代替を本格的なコンポーネントとして提供します(ガイドの後半で説明されています)。カスタム要素をディレクティブのように登録できます:

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

エレメントディレクティブは引数または式を受け付けることはできません。しかし、その振舞いを決定するために要素の属性を読み取ることはできます。

標準のディレクティブとの大きな違いは、エレメントディレクティブは**ターミナル**で、Vue が一度エレメントディレクティブに遭遇したことを意味します。それは、要素とその子を残したまま、エレメントディレクティブそれ自体、要素とその子を操作することができるようになります。

## 高度なオプション

### params

カスタムディレクティブは `params` 配列を提供でき、Vue コンパイラは自動的にディレクティブがバインドされた要素でこれらの属性を抽出します。例:

``` html
<div v-example a="hi"></div>
```
``` js
Vue.directive('example', {
  params: ['a'],
  bind: function () {
    console.log(this.params.a) // -> "hi"
  }
})
```

この API は動的な属性もサポートします。`this.params[key]` の値は自動的に最新に保ちます。加えて、値が変更されたときコールバックも指定できます:

``` html
<div v-example v-bind:a="someValue"></div>
```
``` js
Vue.directive('example', {
  params: ['a'],
  paramWatchers: {
    a: function (val, oldVal) {
      console.log('a changed!')
    }
  }
})
```

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

あなたのディレクティブが Vue インスタンスにデータを書き戻す場合、`twoWay: true` で渡す必要があります。このオプションは、ディレクティブ内部で `this.set(value)` を使用することができます:

``` js
Vue.directive('example', {
  twoWay: true,
  bind: function () {
    this.handler = function () {
      // vm にデータをセットします
      // もしディレクティブが v-example="a.b.c" とひも付いている場合,
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

`acceptStatement: true` を渡すことでカスタムディレクティブが `v-on` が行っているようなインラインステートメントを使用できるようになります: 

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

ディレクティブには任意で優先度の数値 (デフォルトは 1000) を与えることができます。同じ要素上で高い優先度をもつディレクティブは他のディレクティブより早く処理されます。同じ優先度をもつディレクティブは要素上の属性のリストに出現する順番で処理されますが、ブラウザが異なる場合、一貫した順番になることは保証されません。

いくつかのビルトインディレクティブに関する優先度は [API](/api/#Directives) で確認できます。さらに フロー制御するディレクティブ `v-if` と `v-for` は、コンパイル処理の中で常に最も高い優先度を持ちます。
