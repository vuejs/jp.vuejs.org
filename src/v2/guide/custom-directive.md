---
title: カスタムディレクティブ
updated: 2017-09-03
type: guide
order: 302
---

## 基本

Vue.js 本体で出荷されたディレクティブの標準セットに加えて (`v-model` と `v-show`)、カスタムディレクティブ (custom directive) を登録することができます。Vue 2.0 では、コードの再利用と抽象化における基本の形はコンポーネントです。しかしながら、通常の要素で低レベル DOM にアクセスしなければならないケースがあるかもしれません。こういった場面では、カスタムディレクティブが役立つでしょう。ひとつの例として、以下のような input 要素へのフォーカスが挙げられます:

{% raw %}
<div id="simplest-directive-example" class="demo">
  <input v-focus>
</div>
<script>
Vue.directive('focus', {
  inserted: function (el) {
    el.focus()
  }
})
new Vue({
  el: '#simplest-directive-example'
})
</script>
{% endraw %}

ページを読み込むと、この要素はフォーカスを手に入れます。実際、このページに訪れてから他のところをクリックしていなければ、この input にフォーカス(注意:モバイル Safari では自動でフォーカスしません)が当たっているでしょう。さあ、これを実現させるディレクティブを作りましょう。

``` js
// `v-focus` というグローバルカスタムディレクティブを登録します
Vue.directive('focus', {
  // ひも付いている要素が DOM に挿入される時...
  inserted: function (el) {
    // 要素にフォーカスを当てる
    el.focus()
  }
})
```

代わりにローカルディレクティブに登録したいならば、コンポーネントの `directives` オプションで登録できます:

``` js
directives: {
  focus: {
    // ディレクティブ定義
    inserted: function (el) {
      el.focus()
    }
  }
}
```

これでテンプレートで、以下のような新しい `v-focus` 属性が使えるようになります。

``` html
<input v-focus>
```


### フック関数

directive definition object はいくつかのフック関数(全て任意)を提供します:

- `bind`: ディレクティブが初めて対象の要素にひも付いた時に 1 度だけ呼ばれます。ここで 1 回だけ実行するセットアップ処理を行えます。

- `inserted`: ひも付いている要素が親 Node に挿入された時に呼ばれます(これは、親 Node が存在している時にだけ保証します。必ずしも、ドキュメントにあるとは限りません)。

- `update`: ひも付いた要素を抱合しているコンポーネントの VNode が更新される度に呼ばれます。__しかし、おそらく子コンポーネントが更新される前でしょう。__ ディレクティブの値が変化してもしなくても、バインディングされている値と以前の値との比較によって不要な更新を回避することができます。(フック引数に関しては下記を参照してください)

- `componentUpdated`: 抱合しているコンポーネントの VNode __と子コンポーネントの VNode __が更新された後に呼ばれます。

- `unbind`: ディレクティブがひも付いている要素から取り除かれた時に 1 度だけ呼ばれます。

次のセクションで、これらのフックに渡す引数(すなわち `el`, `binging`, `vnode`, `oldVnode`)を見ていきましょう。

### ディレクティブフック引数

ディレクティブフックには以下の引数が渡せます:

- `el`: ディレクティブがひも付く要素。DOM を直接操作するために使用できます。
- `binding`: 以下のプロパティを含んでいるオブジェクト。
  - `name`: `v-` 接頭辞 (prefix) 無しのディレクティブ名。
  - `value`: ディレクティブに渡される値。例えば `v-my-directive="1 + 1"` では、value は `2` です。
  - `oldValue`: `update` と `componentUpdated` においてのみ利用できる以前の値。値が変化したかどうかに関わらず利用できます。
  - `expression`: 文字列としてのバインディング式。例えば `v-my-directive="1 + 1"` では、式は `"1 + 1"` です。
  - `arg`: もしあれば、ディレクティブに渡される引数。例えば `v-my-directive:foo` では、arg は `"foo"` です。
  - `modifiers`: もしあれば、修飾子 (modifier) を含んでいるオブジェクト。例えば `v-my-directive.foo.bar` では、modifiers オブジェクトは `{ foo: true, bar: true }` です。
- `vnode`: Vue のコンパイラによって生成される仮想ノード。さらに詳しくは [VNode API](../api/#VNodeインターフェイス) を参照してください。
- `oldVnode`: `update` と `componentUpdated` フックにおいてのみ利用できる以前の仮想ノード。

<p class="tip">`el` を除いて、これらの全てのプロパティは読み込みのみ (read-only) で変更しないものとして扱わなくてはいけません。フックを超えてデータを共有する必要がある場合は, 要素の [dataset](https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/dataset) を通じて行うことが推奨されています。</p>

いくつかのプロパティを使用したカスタムディレクティブの例:

``` html
<div id="hook-arguments-example" v-demo:foo.a.b="message"></div>
```

``` js
Vue.directive('demo', {
  bind: function (el, binding, vnode) {
    var s = JSON.stringify
    el.innerHTML =
      'name: '       + s(binding.name) + '<br>' +
      'value: '      + s(binding.value) + '<br>' +
      'expression: ' + s(binding.expression) + '<br>' +
      'argument: '   + s(binding.arg) + '<br>' +
      'modifiers: '  + s(binding.modifiers) + '<br>' +
      'vnode keys: ' + Object.keys(vnode).join(', ')
  }
})

new Vue({
  el: '#hook-arguments-example',
  data: {
    message: 'hello!'
  }
})
```

{% raw %}
<div id="hook-arguments-example" v-demo:foo.a.b="message" class="demo"></div>
<script>
Vue.directive('demo', {
  bind: function (el, binding, vnode) {
    var s = JSON.stringify
    el.innerHTML =
      'name: '       + s(binding.name) + '<br>' +
      'value: '      + s(binding.value) + '<br>' +
      'expression: ' + s(binding.expression) + '<br>' +
      'argument: '   + s(binding.arg) + '<br>' +
      'modifiers: '  + s(binding.modifiers) + '<br>' +
      'vnode keys: ' + Object.keys(vnode).join(', ')
  }
})
new Vue({
  el: '#hook-arguments-example',
  data: {
    message: 'hello!'
  }
})
</script>
{% endraw %}

## 関数による省略記法

多くの場合、`bind` と `update` には同じ振舞いが欲しいでしょうが、その他のフックに関しては気にかけません。例えば:

``` js
Vue.directive('color-swatch', function (el, binding) {
  el.style.backgroundColor = binding.value
})
```

## オブジェクトリテラル

あなたのディレクティブが複数の値を必要ならば、JavaScript オブジェクトリテラルも渡すことができます。ディレクティブは任意の妥当な JavaScript 式を取ることができるのを覚えておいてください:

``` html
<div v-demo="{ color: 'white', text: 'hello!' }"></div>
```

``` js
Vue.directive('demo', function (el, binding) {
  console.log(binding.value.color) // => "white"
  console.log(binding.value.text)  // => "hello!"
})
```
