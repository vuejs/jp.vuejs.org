---
title: インスタンスプロパティの追加
type: cookbook
updated: 2019-11-13
order: 2
---

## 基本的な例

多くのコンポーネントで使用したいデータ/ユーティリティがあるかもしれませんが、[グローバルスコープを汚染したくはありません](https://github.com/getify/You-Dont-Know-JS/blob/2nd-ed/scope-closures/ch3.md)。この場合は、プロトタイプに追加すれば全ての Vue インスタンスで使用できます：

```js
Vue.prototype.$appName = 'My App'
```

今 `$appName` は、作成前でも全ての Vue インスタンスで使用可能です。 実行した場合：
```js
new Vue({
  beforeCreate: function() {
    console.log(this.$appName)
  }
})
```

`"My App"` はコンソールに記録されます。

## スコープインスタンスプロパティの重要性

あなたは疑問に思うかもしれません：

> "`appName` はなぜ `$` で始まるのですか？ それは重要なのですか？"

ここでは特別な事は一切起きていません。Vue は全てのインスタンスが利用できるプロパティに対して接頭辞に `$` をつけるよう規約を設けています。この規約により、定義したデータ、算出プロパティ、またはメソッドとの衝突を回避できます。

> "衝突？ それはどういう意味ですか？"

とても良い質問です！もしこのように設定した場合：

```js
Vue.prototype.appName = 'My App'
```

以下にどのようなログが記録されると思いますか？

```js
new Vue({
  data: {
    // しまった！ appName は私たちが今定義した
    // インスタンスのプロパティと *また* 同じ名前です！
    appName: 'The name of some other app'
  },
  beforeCreate: function() {
    console.log(this.appName)
  },
  created: function() {
    console.log(this.appName)
  }
})
```

この場合、まずは `"My App"` が記録され、それから `"The name of some other app"` が記録されます。なぜなら `this.appName` はインスタンスが作成されるときに `data` によって上書き([並び替え](https://github.com/getify/You-Dont-Know-JS/blob/2nd-ed/objects-classes/ch5.md))されるからです。これを避けるために、インスタンスプロパティを `$` でスコープする規約を利用します。`$_appName` や `ΩappName` のような独自の規約を使うことにより、プラグインや、将来の機能との衝突を防ぐこともできます。

## 実例： Vue のリソースを Axios に置き換える
それでは[使われなくなった Vue Resource を置き換えるとしましょう](https://medium.com/the-vue-point/retiring-vue-resource-871a82880af4)。あなたは `this.$http` を通してリクエストメソッドにアクセスすることを凄く楽しんでいましたが、代わりに Axios で同じことをしたいと思います。

ただ、プロジェクトに axios を含めるだけです:

```html
<script src="https://cdnjs.cloudflare.com/ajax/libs/axios/0.15.2/axios.js"></script>

<div id="app">
  <ul>
    <li v-for="user in users">{{ user.name }}</li>
  </ul>
</div>
```

`Vue.prototype.$http` に `axios` を代入し、alias とします：

```js
Vue.prototype.$http = axios
```

そうすれば、全ての Vue インスタンスで `this.$http.get` のようにメソッドを使うことができます：

```js
new Vue({
  el: '#app',
  data: {
    users: []
  },
  created() {
    var vm = this
    this.$http
      .get('https://jsonplaceholder.typicode.com/users')
      .then(function(response) {
        vm.users = response.data
      })
  }
})
```

## プロトタイプメソッドのコンテキスト
気付いてないかもしれませんが、JavaScript のプロトタイプに追加されたメソッドはインスタンスのコンテキストを取得します。 つまり、インスタンスに定義されたデータ、算出プロパティ、メソッド、その他のものにアクセスするために this を使用できます。

this を `$reverseText`メソッドで利用してみましょう：

```js
Vue.prototype.$reverseText = function(propertyName) {
  this[propertyName] = this[propertyName]
    .split('')
    .reverse()
    .join('')
}

new Vue({
  data: {
    message: 'Hello'
  },
  created: function() {
    console.log(this.message) // => "Hello"
    this.$reverseText('message')
    console.log(this.message) // => "olleH"
  }
})
```

コンテキストバインディングは、ES6/2015のアロー演算子を使用している場合は、親スコープに暗黙的にバインドされるため、**機能しません**。次はアロー関数のパターン：

```js
Vue.prototype.$reverseText = propertyName => {
  this[propertyName] = this[propertyName]
    .split('')
    .reverse()
    .join('')
}
```

これはエラーが発生します:

```log
Uncaught TypeError: Cannot read property 'split' of undefined
```

## このパターンを避ける時
プロトタイプのプロパティのスコープを慎重にしている限り、このパターンを使用するのは非常に安全です（バグを生成する可能性は低いです）。

ただし、他の開発者との間で混乱を引き起こすことがあります。例えば、`this.$http` を見て、「ああ、私はこの Vue の機能について知らなかった！」と思うかもしれません。 その後、彼らは別のプロジェクトに移り、`this.$http` が定義されていなかった場合は混乱します。 あるいは、Google で `this.$http` で何かできないか調べたいかもしれませんが、実際は Axios を別名で使用していることを認識していないため、何も見つけることはできません。

**この利便性は明確さとのトレードオフです**。コンポーネントを見たとき、`$http` がどこから来たのかを知ることは不可能です。Vue 本体ですか？プラグインですか？それとも同僚ですか？

では、良い代替パターンは何でしょう？

## 代替パターン

### モジュールシステムを使用していない場合
モジュールシステム（Webpack や Browserify など）が**ない**アプリケーションでは、JavaScript で拡張したフロントエンドでよく使われるパターンがあります：それはグローバル `App` オブジェクトです。

追加したいものが Vue とは特に関係がない場合、これは届けるための良い選択肢かもしれません。ここに例があります：


```js
var App = Object.freeze({
  name: 'My App',
  version: '2.1.4',
  helpers: {
    // これは前に見た $reverseText メソッドの
    // 純粋関数バージョンです
    reverseText: function(text) {
      return text
        .split('')
        .reverse()
        .join('')
    }
  }
})
```

<p class="tip">`Object.freeze` で眉を釣り上げましたか？これはオブジェクトのプロパティを固定するメソッドです。これは基本的にすべてのプロパティを固定し、将来、 state バグからあなたを守ります。</p>

これらの共有プロパティのソースははるかに明白です。アプリケーションのどこかに定義された `App` オブジェクトがあります。これを見つけるためには、開発者はプロジェクト全体の検索を実行するだけです。

もう1つの利点は、Vue 関連だろうとなかろうと、あなたのコードでは `App` が _anywhere_ で使用できるようになりました。これでインスタンスに直接オプションを追加する必要がなくなり、関数で `this` からプロパティにアクセスする必要がなくなりました。

```js
new Vue({
  data: {
    appVersion: App.version
  },
  methods: {
    reverseText: App.helpers.reverseText
  }
})
```

### モジュールシステムを使用する場合

モジュールシステムにアクセスができると、共有されたコードをモジュールへ簡単に統合できます。必要な場所で`require`/`import` を行なってください。
これはとてもわかりやすく、各ファイルで依存関係のリストが正確に得られます。それにより、あなたはそれぞれのコードがどこからのコードかを正確に知ることができます。

冗長ですが、このアプローチは、他の開発者と働いたり、大規模なアプリケーションを開発する際に、最も保守性が高いです。
