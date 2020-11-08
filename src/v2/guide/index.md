---
title: はじめに
updated: 2020-11-07
type: guide
order: 2
---

## Vue.js とは？

Vue (発音は / v j u ː / 、 **view** と同様）はユーザーインターフェイスを構築するための**プログレッシブフレームワーク**です。他の一枚板(モノリシック: monolithic)なフレームワークとは異なり、Vue は少しずつ適用していけるように設計されています。中核となるライブラリは view 層だけに焦点を当てています。そのため、使い始めるのも、他のライブラリや既存のプロジェクトに統合するのも、とても簡単です。また、[モダンなツール](single-file-components.html)や[サポートライブラリ](https://github.com/vuejs/awesome-vue#components--libraries)と併用することで、洗練されたシングルページアプリケーションの開発も可能です。

あなたが Vue についてもっと深く学ぶ前に概要を知りたいのなら、中核となる原則とサンプルプロジェクトを元に説明する<a id="modal-player"  href="#">ビデオ</a>を作成しているので、それを見るとよいでしょう。

あなたが経験豊富なフロントエンド開発者で、 Vue.js と他のライブラリ/フレームワークを比較したい場合、[他のフレームワークとの比較](comparison.html)を確認してください。

<div class="vue-mastery"><a href="https://www.vuemastery.com/courses/intro-to-vue-js/vue-instance/" target="_blank" rel="sponsored noopener" title="Free Vue.js Course">Vue Masteryで無料の動画コースを見る</a></div>

## はじめに

<a class="button" href="installation.html">インストール</a>

<p class="tip">公式ガイドは、HTML、CSS そして JavaScript の中レベルのフロントエンドの知識を前提にしています。フロントエンドの開発が初めてであるならば、最初のステップとして、フレームワークに直接入門するのは良いアイデアではないかもしれません。基礎を学んで戻ってきましょう！他のフレームワークでの以前の経験は役に立ちますが、必須ではありません。</p>

Vue.js を試すには、[Hello World example](https://codesandbox.io/s/github/vuejs/vuejs.org/tree/master/src/v2/examples/vue-20-hello-world) が最も簡単です。気軽に他のタブを開いて、基本的な例を試してみましょう。もしくは、単純に <a href="https://github.com/vuejs/vuejs.org/blob/master/src/v2/examples/vue-20-hello-world/index.html" target="_blank" download="index.html" rel="noopener noreferrer"><code>index.html</code> を作成し </a> 、以下のコードで Vue を導入することができます:

``` html
<!-- 開発バージョン、便利なコンソールの警告が含まれています -->
<script src="https://cdn.jsdelivr.net/npm/vue@2/dist/vue.js"></script>
```

or:

``` html
<!-- 本番バージョン、サイズと速度のために最適化されています -->
<script src="https://cdn.jsdelivr.net/npm/vue@2"></script>
```

Vue の他のインストール方法について、[インストール](../guide/installation.html) ページで紹介しています。注意点として、初心者が `vue-cli` で始めることは推奨**しません**（特に、Node.js ベースのツールについてまだ詳しくない場合）。

よりインタラクティブに学びたい場合、スクリーンキャストといつでも一時停止してコードを試せる環境を組み合わせた、 [Scrimba の一連のチュートリアル](https://scrimba.com/g/gvuedocs) を利用可能です。

## 宣言的レンダリング

<div class="scrimba"><a href="https://scrimba.com/p/pXKqta/cQ3QVcr" target="_blank" rel="noopener noreferrer">Scrimba のレッスンを試す</a></div>

Vue.js のコアは、単純なテンプレート構文を使って宣言的にデータを DOM に描画することを可能にするシステムです:

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

これで初めての Vue アプリケーションが作成できました！一見するとただテンプレートを描画しているように見えますが、Vue.js は内部で多くの作業を行っています。データと DOM は関連付けられ、そして全てが**リアクティブ**になっています。どのようにしてそれが分かるのでしょうか？ブラウザの JavaScript コンソールを開いて、`app.message` の値を変えてみましょう。描画されたサンプルが、上記に応じて更新されるのが確認できるでしょう。

これでもう HTML を直接操作する必要がないことに注意してください。Vue アプリケーションは、自身を単一の DOM 要素 (上の例では `#app` 要素) にアタッチし、完全に制御します。HTML はエントリポイントにはなりますが、ほかのすべてのことは新しく作られた Vue インスタンスの中で起こります。

文字列の展開に加えて、以下のように要素の属性を束縛（バインディング）することもできます:

``` html
<div id="app-2">
  <span v-bind:title="message">
    Hover your mouse over me for a few seconds
    to see my dynamically bound title!
  </span>
</div>
```
``` js
var app2 = new Vue({
  el: '#app-2',
  data: {
    message: 'You loaded this page on ' + new Date().toLocaleString()
  }
})
```
{% raw %}
<div id="app-2" class="demo">
  <span v-bind:title="message">
    Hover your mouse over me for a few seconds to see my dynamically bound title!
  </span>
</div>
<script>
var app2 = new Vue({
  el: '#app-2',
  data: {
    message: 'You loaded this page on ' + new Date().toLocaleString()
  }
})
</script>
{% endraw %}

ここで新しい属性が出てきました。`v-bind` 属性はディレクティブと呼ばれています。ディレクティブは Vue.js によって提供された特別な属性を示すために `v-` 接頭辞がついています。これはあなたの推測通り、描画された DOM に特定のリアクティブな振舞いを与えます。ここで宣言されているのは、「この要素の `title` 属性を Vue インスタンスの `message` プロパティによって更新して保存する」ということになります。

再び JavaScript コンソールを開いて、`app2.message = 'some new message'` を打ち込むと、もう一度束縛されたHTML（このケースでは `title` 属性）が更新されるのが確認できるでしょう。

## 条件分岐とループ

<div class="scrimba"><a href="https://scrimba.com/p/pXKqta/cEQe4SJ" target="_blank" rel="noopener noreferrer">Scrimba でレッスンを試す</a></div>

要素の有無を切り替えることも非常にシンプルにできます:

``` html
<div id="app-3">
  <span v-if="seen">Now you see me</span>
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

この例は、テキストをデータに束縛できるだけではなく、 DOM の**構造**にデータを束縛できることを示しています。さらに Vue は、要素が Vue によって挿入/更新/削除されたとき、自動的に[トランジションエフェクト(遷移効果)](transitions.html)を適用できる強力なトランジション効果システムも提供します。

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

<div class="scrimba"><a href="https://scrimba.com/p/pXKqta/czPNaUr" target="_blank" rel="noopener noreferrer">Scrimba のレッスンを試す</a></div>

ユーザーがあなたのアプリケーションと対話できるように、`v-on` ディレクティブを使ってイベントリスナを加え、Vue インスタンスのメソッドを呼び出すことができます:

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

`reverseMessage` メソッドの中では DOM 操作を行っていません。アプリケーションの状態のみを更新していることに注意してください。すべての DOM 操作を Vue に任せられるので、背後のロジックを書くことに集中することができます。

Vue は入力とアプリケーションの状態の「双方向バインディング」が簡単に行える `v-model` ディレクティブも提供します:

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

<div class="scrimba"><a href="https://scrimba.com/p/pXKqta/cEQVkA3" target="_blank" rel="noopener noreferrer">Scrimba のレッスンを試す</a></div>

コンポーネントシステムは Vue.js におけるもうひとつの重要な抽象概念です。「小さく、自己完結的で、（多くの場合）再利用可能なコンポーネント」を組み合わせることで、大規模アプリケーションを構築することが可能になります。アプリケーションのインターフェイスについて考えてみると、ほぼすべてのタイプのインターフェイスはコンポーネントツリーとして抽象化することができます:

![Component Tree](/images/components.png)

Vue においては、「コンポーネント」は本質的にはあらかじめ定義されたオプションを持つ Vue インスタンスです。Vue を使ってコンポーネントを登録するのはいたって簡単です:

``` js
// todo-item と呼ばれる新しいコンポーネントを定義
Vue.component('todo-item', {
  template: '<li>This is a todo</li>'
})

var app = new Vue(...)
```

これで他のコンポーネントのテンプレートからこのコンポーネントを利用できるようになります:

``` html
<ol>
  <!-- todos 配列にある各 todo に対して todo-item コンポーネントのインスタンスを作成する -->
  <todo-item></todo-item>
</ol>
```

しかし、これでは全ての todo で同じテキストが描画されてしまうだけで、あまり面白くありません。親のスコープから子コンポーネントへとデータを渡せるようにすべきです。[プロパティ](../guide/components.html#プロパティ)を受け取れるようにコンポーネントの定義を変えてみましょう:

``` js
Vue.component('todo-item', {
  // todo-item コンポーネントはカスタム属性のような "プロパティ" で受け取ります。
  // このプロパティは todo と呼ばれます。
  props: ['todo'],
  template: '<li>{{ todo.text }}</li>'
})
```

こうすることで、繰り返されるコンポーネントそれぞれに `v-bind` を使って todo を渡すことができます:

``` html
<div id="app-7">
  <ol>
    <!--
      各 todo-item の内容を表す todo オブジェクトを与えます。
      これにより内容は動的に変化します。
      また後述する "key" を各コンポーネントに提供する必要があります。
    -->
    <todo-item
      v-for="item in groceryList"
      v-bind:todo="item"
      v-bind:key="item.id"
    ></todo-item>
  </ol>
</div>
```
``` js
Vue.component('todo-item', {
  props: ['todo'],
  template: '<li>{{ todo.text }}</li>'
})

var app7 = new Vue({
  el: '#app-7',
  data: {
    groceryList: [
      { id: 0, text: 'Vegetables' },
      { id: 1, text: 'Cheese' },
      { id: 2, text: 'Whatever else humans are supposed to eat' }
    ]
  }
})
```
{% raw %}
<div id="app-7" class="demo">
  <ol>
    <todo-item v-for="item in groceryList" v-bind:todo="item" :key="item.id"></todo-item>
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
    groceryList: [
      { id: 0, text: 'Vegetables' },
      { id: 1, text: 'Cheese' },
      { id: 2, text: 'Whatever else humans are supposed to eat' }
    ]
  }
})
</script>
{% endraw %}

このサンプルは不自然ではありますが、アプリケーションをより小さな単位に分割することに成功し、またプロパティのインターフェイスによって子コンポーネントは適切に疎結合な状態になりました。ここからさらに `<todo-item>` コンポーネントを、より複雑なテンプレートやロジックを使って、親コンポーネントに影響を与えることなく改良することができます。

大規模なアプリケーションでは、開発を行いやすくするために、アプリケーション全体をコンポーネントに分割することが必要です。コンポーネントについては[ガイドの後半](components.html)でより詳しく話しますが、コンポーネントを駆使した(架空の)アプリケーションのテンプレートがどういうものになるかをここに載せておきます:

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

Vue のコンポーネントが [Web Components Spec](https://www.w3.org/wiki/WebComponents/) の一部の「カスタム要素 (Custom Element)」によく似ていることに気付いたかもしれません。これは Vue のコンポーネント構文は Web Components を手本にしているためです。例えば、Vue コンポーネントは [Slot API](https://github.com/w3c/webcomponents/blob/gh-pages/proposals/Slots-Proposal.md) と `is` という特別な属性を実装しています。しかしながら、いくつか重要な違いがあります:

1. Web Components の仕様は確定しましたが、全てのブラウザにネイティブ実装されているわけではありません。Safari 10.1 以上、Chrome 54 以上、Firefox 63 以上が Web Components をネイティブでサポートしています。一方、Vue コンポーネントはどんなポリフィル (polyfill) も必要とせず、サポートされる全てのブラウザ (IE9 とそれ以上) で同じ動作をします。必要に応じて、Vue コンポーネントはネイティブなカスタム要素内で抱合 (wrap) することができます。

2. Vue コンポーネントは、クロスコンポーネントデータフローをはじめ、カスタムイベント通信やビルドツールとの統合など、プレーンなカスタム要素内では利用できないいくつかの重要な機能を提供します。

Vue は内部的にはカスタム要素を使っていませんが、カスタム要素として使用または配布する場合には、[優れた相互運用性](https://custom-elements-everywhere.com/#vue) があります。Vue CLI は、自分自身をネイティブのカスタム要素として登録するような Vue コンポーネントの構築もサポートしています。

## 準備ができましたか？

Vue.js のコアの基本的な機能について簡単に紹介しましたが、このガイドの残りの部分では、基本的な機能だけでなく他の高度な機能についてもっと詳しく扱うので、全てに目を通すようにしてください！

<div id="video-modal" class="modal"><div class="video-space" style="padding: 56.25% 0 0 0; position: relative;"><iframe src="https://player.vimeo.com/video/247494684?dnt=1" style="height: 100%; left: 0; position: absolute; top: 0; width: 100%; margin: 0" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe></div><script src="https://player.vimeo.com/api/player.js"></script><p class="modal-text">Video by <a href="https://www.vuemastery.com" target="_blank" rel="sponsored noopener" title="Vue.js Courses on Vue Mastery">Vue Mastery</a>. Watch Vue Mastery’s free <a href="https://www.vuemastery.com/courses/intro-to-vue-js/vue-instance/" target="_blank" rel="sponsored noopener" title="Vue.js Courses on Vue Mastery">Intro to Vue course</a>.</div>
