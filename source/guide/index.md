title: Getting Started
type: guide
order: 2
---

## Introduction

Vue.js はインタラクティブなウェブインターフェースを作るためのライブラリーです。

技術的に、Vue.js はMVVM pattern の [ViewModel](#ViewModel) layer に注目しています。[ViewModel](#ViewModel) layer は双方向バインディングによって [View](#View) と [Model](#Model) を接続します。実際の DOM 操作と出力の形式は[Directives](#Directives) と [Filters](#Filters)によって抽象化されています。

Vue.js の哲学的なゴールは、可能な限り簡単なAPIを通じて、反応性の良いデータバインディングの利点と構成可能なviewのコンポーネントを提供することです。Vue.jsは万能なフレームワークではありません。 Vue.jsは単純かつ自由自在なview layerになるようにデザインされています。Vue.jsを単体でラピッドプロトタイピングができます。特別な front-end stack 用のライブラリー達と一緒に使ったり組み合わせたりもできます。Vue.jsは Firebase のようなノーバックエンドサービスとも合性が良いです。

Vue.js の API は [AngularJS]、[KnockoutJS]、[Ractive.js]、 [Rivets.js]に強く影響を受けています。それらと似てはいますが、単純さと機能性のちょうど良いスィートスポットを見つけることによって、Vue.jsはそれらのライブラリーに対して価値ある代変手段になりうると私は信じています。

貴方は、その他のライブラリーの表現に既に慣れているかもしれませんが、それらの表現の記法がVue.js のコンテキストにおいて意味するところとは違っているかもしれませんので、以下に示すコンセプトの全体像に目を通してみてください。

## Concepts Overview

### ViewModel

Model と Viewを同期するオブジェクト。 Vue.js において, 全ての Vue インスタンスはViewModelです。 それらは `Vue` コンストラクターかそのサブクラスでインスタンス化されます:

```js
var vm = new Vue({ /* options */ })
```

これは貴方がVue.jsをつかって開発するときに初めて出会うオブジェクトです。詳細は [The Vue Constructor](/api/) を参照。

### View

Vue インスタンスによって管理される実際の DOM.

```js
vm.$el // The View
```

Vue.js は DOM ベースのテンプレーティングを使います。各々のVue インスタンスはassociated with a 対応する DOM 要素と関連づいています。Vue インスタンスが作られると、必要なデータバインディングを設定している間、Vue インスタンスはその親要素の全ての子ノードを再帰的に巡回します。

Vue.jsを使っているときに、貴方が貴方自身でDOM に触れることはcustom directives (後述)を除いて殆どありません。 View の更新はデータが変わったときに自動的に行われます。これらのView の更新は、textNodeに至る精度を持った高い粒度（？）で行われます。 これらは高性能化のために、バッチ化されて非同期実行されてもいます。

### Model

若干修正されたプレーンな JavaScript オブジェクト。

```js
vm.$data // The Model
```

Vue.jsにおいて、Model は単純にプレーンな JavaScript オブジェクトか**data objects**です。貴方はそれらのプロパティと、それらが変更されるかを観察しているVue インスタンスを操作できます。Vue.js はdata objectsのプロパティをES5 getter/settersに変換することによって、透過的な応答（？）を実現します。 ダーティーチェックは必要ありませんし、Viewを更新するために、明示的なシグナルを Vue に送る必要もありません。 データが変更されたときはいつでも、次のフレームでViewは更新されます。

Vue インスタンスは、それらが観察している data objects の全てのプロパティをプロキシしています。 そのため、一度オブジェクト `{ a: 1 }` が観察されれば、 `vm.$data.a` と`vm.a` の両方が同じ値を返します。また、`vm.a = 2` に設定すると `vm.$data` が変わります.

data objectsは適当な位置で変化します。そのため、参照によってそれらを変更することは、`vm.$data` を変更することと同じ効果を持っています. この事が、複数の Vue インスタンスがデータの同じ部分を観察することを可能にしています。より広い応用としては、 Vue インスタンスは純粋なviewとして使われること、and externalize the data 操作のロジックをより離散的なstore layerに具体化すること（？）、も推奨されます。

ここでの問題は、一度観察が始まったら、Vue.js はプロパティの新規追加と削除を検出できないことです。
この問題を避けるために、観察されたオブジェクトは`$add` と `$delete` メソッドで追加削除されます。
### Directives

Vue.js が DOM 要素についての何かをすることを伝えている プレフィックスのついた HTML 属性

```html
<div v-text="message"></div>
```

ここでHere the div 要素は valueが `message` `v-text` directiveを持っています。 これはVue.js が、divの textContent がVue インスタンスの`message` プロパティと同期していることを、保っていることを伝えています。

Directive は任意の DOM 操作をカプセル化できます。例えば、`v-attr` は要素の属性を操作しますし、`v-repeat` はアレイに基づいて要素をクローンしますし、, `v-on` はイベントリスナーを随行します。これらは後にまとめます。

### Mustache Bindings

貴方はテキストと属性の両方においてmustache-style バインディングを使うこともできます。それらは内部で、`v-text`ディレクティブ と `v-attr` directive に翻訳されます。例えば:

```html
<div id="person-{{id}}">Hello {{name}}!</div>
```

この書き方は便利ですが、いくつか注意しなければならないことがあります:

<p class="tip"> `<image>` 要素の `src` 属性は、値が設定されたときにHTTP リクエストを作成します。そのため、テンプレートが初めに解析されたときに、404の結果が返ってきます. この場合は、`v-attr` を使うのが良いです。 </p>

<p class="tip">Internet Explorer は、HTMLを解析しているときに、`style`属性の無効なインラインを削除します。 そのためIEをサポートしたい場合、 インラインCSS をバインディングするときにはいつも`v-style`を使ってください。</p>

エスケープされていない（？）HTMLに対して3重のmustacheを使うことができ、それは内部で`v-html` に翻訳されます:

``` html
{{{ safeHTMLString }}}
```

しかしながら、これは潜在的なXSS 攻撃の窓を開けてしまいます。それゆえ、データソースのセキュリティーが絶対に確かなときか、信頼できないHTMLを削除するカスタムフィルターを通じてパイプしたときのみ、3重のmustachesを使うことがよいでしょう。


最後に、一度だけの挿入を示すために、mustache バインディングに`*` を追加することもできます。これはデータ変更には反応しません:

``` html
{{* onlyOnce }}
```

### Filters

Filters はViewを更新する前の生の値を処理するために使われる関数です。これらは、 directive か バインディングの中の"pipe"によって示されます:

```html
<div>{{message | capitalize}}</div>
```

divの textContent が更新されたときに、`message` の値は`capitalize` 関数を通じて初めて解析されます。. 詳細は[Filters in Depth](/guide/filters.html) を参照。

### Components

Vue.jsでは、 全ての要素は単にVue インスタンスです。コンポーネントは、貴方のアプリケーションインターフェースを表現するネストされたツリー様の階層構造を形作ります。これらは`Vue.extend` から返ってきたカスタムコンストラクターによって初期化されます。しかし、より宣言的なアプローチはそれらを`Vue.component(id, constructor)` で登録することです。 一度登録されれば、`v-component` directive（？、をもった）他のVue インスタンスのテンプレートに宣言的にネストされます:

``` html
<div v-component="my-component">
  <!-- internals handled by my-component -->
</div>
```

この簡単な機構は、宣言の再利用と[Web Components](http://www.w3.org/TR/components-intro/)と似た方法でのVue インスタンスの構成を可能にします。最新ブラウザーや重いpolyfillsは必要ありません。アプリケーションをより小さなコンポーネントに分割することにより、結果は高度に分離され、メンテナンスしやすいコードベースになります。 詳細は[Component System](/guide/components.html)を参照.

## A Quick Example

``` html
<div id="demo">
  <h1>{{title | uppercase}}</h1>
  <ul>
    <li
      v-repeat="todos"
      v-on="click: done = !done"
      class="{{done ? 'done' : ''}}">
      {{content}}
    </li>
  </ul>
</div>
```

``` js
var demo = new Vue({
  el: '#demo',
  data: {
    title: 'todos',
    todos: [
      {
        done: true,
        content: 'Learn JavaScript'
      },
      {
        done: false,
        content: 'Learn Vue.js'
      }
    ]
  }
})
```

**Result**

<div id="demo"><h1>&#123;&#123;title | uppercase&#125;&#125;</h1><ul><li v-repeat="todos" v-on="click: done = !done" class="&#123;&#123;done ? 'done' : ''&#125;&#125;">&#123;&#123;content&#125;&#125;</li></ul></div>
<script>
var demo = new Vue({
  el: '#demo',
  data: {
    title: 'todos',
    todos: [
      {
        done: true,
        content: 'Learn JavaScript'
      },
      {
        done: false,
        content: 'Learn Vue.js'
      }
    ]
  }
})
</script>

[jsfiddle](http://jsfiddle.net/yyx990803/yMv7y/)も利用できます.

todo をクリックして toggle したり、 ブラウザのコンソールを開いて`demo` object で
遊んでみることも可能です。例えば、`demo.title`を変更して、 `demo.todos`に新しいobjectを追加したり、 todoの`done` 状態をトグルしてみたりしてみて下さい。

貴方は今多分、いくつかの疑問が心に浮かんできたでしょう。– だけど心配ありません。我々はそれらの疑問をすぐに解決します。[Directives in Depth](/guide/directives.html)に進んでください。

[AngularJS]: http://angularjs.org
[KnockoutJS]: http://knockoutjs.com
[Ractive.js]: http://ractivejs.org
[Rivets.js]: http://www.rivetsjs.com
