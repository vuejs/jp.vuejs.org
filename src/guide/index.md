---
title: Introduction
type: guide
order: 2
---

## Vue.js とは？

Vue (発音は / v j u ː / 、 **view** と同様）はユーザーインターフェイスを構築するための**プログレッシブフレームワーク**です。他のモノリシックなフレームワークとは異なり、Vue は初めから少しづつ適用していけるように設計されています。コアとなるライブラリは view レイヤだけに焦点を当てているため、Vue.js を使い始めたり、他のライブラリや既存のプロジェクトに統合することはとても簡単です。一方、[モダンなツール](application.html)や[サポートライブラリ](https://github.com/vuejs/awesome-vue#libraries--plugins)と併せて利用することで、洗練されたシングルページアプリケーションを開発することも可能です。

あなたが経験豊富なフロントエンド開発者で、 Vue.js と他のライブラリ/フレームワークを比較したい場合、[他のフレームワークとの比較](comparison.html)をチェックしてください。

## はじめに

Vue.js を試すには、[JSFiddle Hello World example](https://jsfiddle.net/chrisvfritz/4tpzm3e1/) が最も簡単です。自由に他のタブを開いて、基本的な例を試してみましょう。もしパッケージマネージャからダウンロード/インストールする方を好むなら、[インストール](/guide/installation.html)のページをチェックしてください。

## 宣言的レンダリング

Vue.js のコアは、単純なテンプレート構文を使って宣言的にデータを DOM にレンダリングすることを可能にするシステムです:

``` html
<div id="app">
  {{ message }}
</div>
```
``` js
var app = new Vue({
  el: '#app',
  data: {
    message: 'Hello Vue!'
  }
})
```
{% raw %}
<div id="app" class="demo">
  {{ message }}
</div>
<script>
var app = new Vue({
  el: '#app',
  data: {
    message: 'Hello Vue!'
  }
})
</script>
{% endraw %}

これで初めての Vue アプリケーションが作成できました！一見するとただテンプレートをレンダリングしているように見えますが、Vue.js は内部で多くの作業を行っています。データと DOM はリンクされ、そして全てが**リアクティブ**になっています。しかし、どうしてそれが分かるのでしょうか？ブラウザの JavaScript コンソールを開いて、`app.message` の値を変えてみましょう。レンダリングされたサンプルが、上記に応じて更新されるのが確認できるでしょう。

文字列の展開に加えて、このように要素の属性をバインドすることもできます:

``` html
<div id="app-2">
  <span v-bind:id="id">Inspect me</span>
</div>
```
``` js
var app2 = new Vue({
  el: '#app-2',
  data: {
    id: 'inspect-me'
  }
})
```
{% raw %}
<div id="app-2" class="demo">
  <span v-bind:id="id">Inspect me</span>
</div>
<script>
var app2 = new Vue({
  el: '#app-2',
  data: {
    id: 'inspect-me'
  }
})
</script>
{% endraw %}

ここには、何か新しいものがあります。`v-bind` 属性はディレクティブと呼ばれています。ディレクティブは Vue.js によって提供された特別な属性を示すために `v-` が接頭辞がついており、あなたが推測したように、レンダリングされた DOM に特定のリアクティブな振舞いを与えます。ここで宣言されているのは、「この要素の `id` 属性を Vue インスタンスの `id` プロパティにバインドする」ということになります。

ブラウザの開発者ツールを使って上の要素を調べてみましょう。`inspect-me` という id を持っているのが見えるはずです。そして、コンソールから `app2.id` を変更すれば更新されるでしょう。

## 条件分岐とループ

要素の有無を切り替えることも非常にシンプルにできます:

``` html
<div id="app-3">
  <p v-if="seen">Now you see me</p>
</div>
```

``` js
var app3 = new Vue({
  el: '#app-3',
  data: {
    seen: true
  }
})
```

{% raw %}
<div id="app-3" class="demo">
  <span v-if="seen">Now you see me</span>
</div>
<script>
var app3 = new Vue({
  el: '#app-3',
  data: {
    seen: true
  }
})
</script>
{% endraw %}

コンソールから `app3.seen = false` を入力してみましょう。メッセージが消えるはずです。

この例は、テキストをデータにバインドできるだけではなく、 DOM の**構造**にデータをバインドできることを示しています。さらに Vue は、要素が Vue によって挿入/更新/削除されたとき、自動的に[トランジションエフェクト(遷移効果)](transitions.html)を適用できる強力なトランジションエフェクトシステムも提供します。

Vue.js にはかなりの数のディレクティブがあり、それぞれ独自に特別な機能を持っています。例えば、`v-for` ディレクティブを使えばアイテムのリストを配列内のデータを使って表示することができます:

``` html
<div id="app-4">
  <ol>
    <li v-for="todo in todos">
      {{ todo.text }}
    </li>
  </ol>
</div>
```
``` js
var app4 = new Vue({
  el: '#app-4',
  data: {
    todos: [
      { text: 'Learn JavaScript' },
      { text: 'Learn Vue' },
      { text: 'Build something awesome' }
    ]
  }
})
```
{% raw %}
<div id="app-4" class="demo">
  <ol>
    <li v-for="todo in todos">
      {{ todo.text }}
    </li>
  </ol>
</div>
<script>
var app4 = new Vue({
  el: '#app-4',
  data: {
    todos: [
      { text: 'Learn JavaScript' },
      { text: 'Learn Vue' },
      { text: 'Build something awesome' }
    ]
  }
})
</script>
{% endraw %}

コンソールで `app4.todos.push({ text: 'New item' })` と入力してみましょう。リストに新しいアイテムが追加されたはずです。

## ユーザー入力の制御

あなたのアプリケーション上でユーザーにインタラクションをとってもらうために、`v-on` ディレクティブを使ってイベントリスナを加え、Vue インスタンスのメソッドを呼び出すことができます:

``` html
<div id="app-5">
  <p>{{ message }}</p>
  <button v-on:click="reverseMessage">Reverse Message</button>
</div>
```
``` js
var app5 = new Vue({
  el: '#app-5',
  data: {
    message: 'Hello Vue.js!'
  },
  methods: {
    reverseMessage: function () {
      this.message = this.message.split('').reverse().join('')
    }
  }
})
```
{% raw %}
<div id="app-5" class="demo">
  <p>{{ message }}</p>
  <button v-on:click="reverseMessage">Reverse Message</button>
</div>
<script>
var app5 = new Vue({
  el: '#app-5',
  data: {
    message: 'Hello Vue.js!'
  },
  methods: {
    reverseMessage: function () {
      this.message = this.message.split('').reverse().join('')
    }
  }
})
</script>
{% endraw %}

メソッドの中では DOM に触ることなくアプリケーションの状態を更新しているだけなことに注意してください。すべての DOM 操作は Vue によって処理され、あなたが書くコードはその後ろにあるロジックに集中できます。

Vue は入力とアプリケーションの状態の双方向バインディングが簡単に行える `v-model` ディレクティブも提供します:

``` html
<div id="app-6">
  <p>{{ message }}</p>
  <input v-model="message">
</div>
```
``` js
var app6 = new Vue({
  el: '#app-6',
  data: {
    message: 'Hello Vue!'
  }
})
```
{% raw %}
<div id="app-6" class="demo">
  <p>{{ message }}</p>
  <input v-model="message">
</div>
<script>
var app6 = new Vue({
  el: '#app-6',
  data: {
    message: 'Hello Vue!'
  }
})
</script>
{% endraw %}

## コンポーネントによる構成

コンポーネントシステムは Vue.js におけるもうひとつの重要な概念です。なぜならコンポーネントシステムは、小さく、自己完結的で、多くの場合再利用可能なコンポーネントで構成される大規模アプリケーションの構築を可能にする抽象概念だからです。アプリケーションのインターフェイスについて考えてみると、ほぼすべてのタイプのインターフェイスはコンポーネントツリーとして抽象化することができます:

![Component Tree](/images/components.png)

Vue においては、コンポーネントは本質的にはあらかじめ定義されたオプションを持つ Vue インスタンスです。Vue を使ってコンポーネントを登録するのはいたって簡単です:

``` js
// todo-item と呼ばれる新しいコンポーネントを定義
Vue.component('todo-item', {
  template: '<li>This is a todo</li>'
})
```

これで他のコンポーネントのテンプレートからこのコンポーネントを利用することができるようになります:

``` html
<ul>
  <!-- todos 配列にある各 todo に対して todo-item コンポーネントのインスタンス作成する -->
  <todo-item v-for="todo in todos"></todo-item>
</ul>
```

しかし、これだと全ての todo で同じテキストがレンダリングされてしまうだけで、あまり面白くありません。親のスコープから子コンポーネントへとデータを渡せるようにすべきです。[prop](/guide/components.html#Props) を受け取れるようにコンポーネントの定義を変えてみましょう:

``` js
Vue.component('todo-item', {
  // todo-item コンポーネントはカスタム属性のような "prop" で受け取ります。
  // この prop は todo と呼ばれます。
  props: ['todo'],
  template: '<li>{{ todo.text }}</li>'
})
```

こうすることで、繰り返されるコンポーネントそれぞれに `v-bind` を使って todo を渡すことができます:

``` html
<div id="app-7">
  <ol>
    <!-- todo オブジェクトによって各 todo-item を提供します。それは、内容を動的にできるように、表すします。-->
    <todo-item v-for="todo in todos" v-bind:todo="todo"></todo-item>
  </ol>
</div>
```
``` js
var app7 = new Vue({
  el: '#app-7',
  data: {
    todos: [/* ... */]
  }
})
```
{% raw %}
<div id="app-7" class="demo">
  <ol>
    <todo-item v-for="todo in todos" v-bind:todo="todo"></todo-item>
  </ol>
</div>
<script>
Vue.component('todo-item', {
  props: ['todo'],
  template: '<li>{{ todo.text }}</li>'
})
var app7 = new Vue({
  el: '#app-7',
  data: {
    todos: [
      { text: 'Learn JavaScript' },
      { text: 'Learn Vue' },
      { text: 'Build something awesome' }
    ]
  }
})
</script>
{% endraw %}

このサンプルは不自然ではありますが、アプリケーションをより小さな単位に分割することに成功し、また props のインターフェイスによって子コンポーネントは適切に疎結合な状態になりました。ここからさらに `<todo-item>` コンポーネントを、より複雑なテンプレートやロジックを使って、親コンポーネントに影響を与えることなく改良することができます。

大規模なアプリケーションでは、開発を行いやすくするために、アプリケーション全体をコンポーネントに分割することが必要です。コンポーネントについては[ガイドの後半](/guide/components.html)でより詳しく話しますが、コンポーネントを駆使した(架空の)アプリケーションのテンプレートがどういうものになるかをここに載せておきます:

``` html
<div id="app">
  <app-nav></app-nav>
  <app-view>
    <app-sidebar></app-sidebar>
    <app-content></app-content>
  </app-view>
</div>
```

### カスタム要素との関係

Vue のコンポーネントが [Web Components Spec](http://www.w3.org/wiki/WebComponents/) の一部のカスタム要素 (Custom Element) にとても似ていることに気付いたかもしれません。なぜなら、Vue のコンポーネント構文は仕様に沿って緩くモデル化されているからです。。例えば、Vue コンポーネントは [Slot API](https://github.com/w3c/webcomponents/blob/gh-pages/proposals/Slots-Proposal.md) と `is` という特別な属性を実装しています。しかしながら、いくつか重要な違いがあります:

1. Web Components の仕様はまだ草案の状態で、全てのブラウザにネイティブ実装されているわけではありません。一方、Vue コンポーネントはどんなポリフィル (polyfill) も必要とせず、サポートされる全てのブラウザ (IE9 とそれ以上) で同じ動作をします。必要に応じて、Vue コンポーネントはネイティブなカスタム要素内でラップ (wrap) することができます。

2. Vue コンポーネントは、クロスコンポーネントデータフローをはじめ、カスタムイベント通信やビルドツールとの統合など、プレーンなカスタム要素内では利用できないいくつかの重要な機能を提供します。

## 準備完了？

Vue.js のコアの基本的な機能について手短に紹介しましたが、このガイドの残りでは、基本的な機能だけでなく他の高度な機能についてももっと詳しく扱うので、全てに目を通すようにしてください！
