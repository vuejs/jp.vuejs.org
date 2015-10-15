title: Building Large-Scale Apps
type: guide
order: 18
---

Vue.js コアライブラリは、フォーカスされた柔軟に設計されており、全てのアプリケーションレベルのアーキテクチャと干渉しない view レイヤーのライブラリです。これは既存プロジェクトとの統合のために素晴らしいことができますが、スクラッチからの大規模アプリケーションを構築する場合は、構築経験の少ない開発者にとって悩ましい問題にもなります。

The Vue.js ecosystem provides a set of tools, libraries on how to build large SPAs with Vue. This part is where we start get a bit "framework"-ish, but it's really just an opinionated list of recommendations; you still get to pick what to use for each part of the stack.

## モジュール化

For large projects it's necessary to utilize a modularized build system to better organize your code. The recommended approach of doing so is by writing your source code in CommonJS or ES6 modules and bundle them using [Webpack](http://webpack.github.io/) or [Browserify](http://browserify.org/).

Webpack と Browserify は単にモジュールバンドラ以上のものです。それら両方は、他のプリプロセッサでソースコードを変換することができるソース変換 API を提供します。例えば、[babel-loader](https://github.com/babel/babel-loader) または [babelify](https://github.com/babel/babelify) を使用して、将来サポートされる ES2015/2016 シンタックスでコードを書くことができます。

If you've never used them before, I highly recommend going through a few tutorials to get familiar with the concept of module bundlers, and start writing JavaScript using the latest ECMAScript features.

## 単一ファイルコンポーネント

Vue.js を利用した典型的なプロジェクトでは、たくさんの個別のコンポーネントにコードを分割して、コンポーネントごとに HTML/CSS/JavaScript を配置しておくと便利です。上述したように、Webpack または Browserify を使用するとき、次のようなコンポーネントを適切なソース変換できます:

<img src="/images/vue-component.png">

もし、プリプロセッサに詳しいなら、次のようにも書くことができます：

<img src="/images/vue-component-with-pre-processors.png">

これらの単一ファイル Vue コンポーネントを Webpack + [vue-loader](https://github.com/vuejs/vue-loader) または Browserify + [vueify](https://github.com/vuejs/vueify) でビルドできます。Webpack ローダ API はより良いファイル依存関係追跡/キャッシング、そして Browserify transforms で実行できないいくつかの高度な機能があるため、Webpack をセットアップして使用することをお勧めします。


GitHub のビルドセットアップの例を探すことができます。

- [Webpack + vue-loader](https://github.com/vuejs/vue-loader-example)
- [Browserify + vueify](https://github.com/vuejs/vueify-example)

## ルーティング

シングルページアプリケーション (Single Page Application: SPA) については、現在テクニカルプレビューな[オフィシャル vue-router ライブラリ](https://github.com/vuejs/vue-router)の使用を推奨します。詳細については、どうか vue-router の[ドキュメンテーション](http://vuejs.github.io/vue-router/)を参照してください。

もし、いくつかとてもシンプルなルーティングのロジックを必要としている場合は、ハッシュチェンジへのイベントリスニングと、動的なコンポーネントを利用することでそれを実装することができます。

**例：:**

``` html
<div id="app">
  <component :is="currentView"></component>
</div>
```

``` js
Vue.component('home', { /* ... */ })
Vue.component('page1', { /* ... */ })
var app = new Vue({
  el: '#app',
  data: {
    currentView: 'home'
  }
})
// route ハンドラでページを切り替え
app.currentView = 'page1'
```

このメカニズムでは、[Page.js](https://github.com/visionmedia/page.js) や [Director](https://github.com/flatiron/director) などの、外部ルーティングライブラリを活用すると非常に簡単です。

## サーバーとの通信

すべての Vue インスタンスは、`JSON.stringify()` で直接シリアライズされる生の `$data` を持つことができます。Vue.js コミュニティは [vue-resource](https://github.com/vuejs/vue-resource) プラグインに貢献していて、RESTFul API で動作するため簡単な方法を提供します。例えば jQuery の `$.ajax` または [SuperAgent](https://github.com/visionmedia/superagent) などの好きな Ajax ライブラリも使用できます。Vue.js はバックエンドを持たない Firebase や Parse などのサービスとの連携にも適しています。

## State Management

In large applications, state management often becomes complex due to multiple pieces of state scattered across many components and the interactions between them. It is often overlooked that the source of truth in Vue.js applications is the raw data object - a Vue instances simply proxies access to it. Therefore, if you have a piece of state that should be shared by multiple instances, you should avoid duplicating it and share it by identity:

``` js
var sourceOfTruth = {}

var vmA = new Vue({
  data: sourceOfTruth
})

var vmB = new Vue({
  data: sourceOfTruth
})
```

Now whenever `sourceOfTruth` is mutated, both `vmA` and `vmB` will update their views automatically. Extending this idea further, we would arrive at the **store pattern**:

``` js
var store = {
  state: {
    message: 'Hello!'
  },
  actionA: function () {
    this.state.message = 'action A triggered'
  },
  actionB: function () {
    this.state.message = 'action B triggered'
  }
}

var vmA = new Vue({
  data: {
    privateState: {},
    sharedState: store.state
  }
})

var vmB = new Vue({
  data: {
    privateState: {},
    sharedState: store.state
  }
})
```

Notice we are putting all actions that mutate the store's state inside the store itself. This type of centralized state management makes it easier to understand what type of mutations could happen to the state, and how are they triggered. Each component can still own and manage its private state.

![State Management](/images/state.png)

One thing to take note is that you should never replace the original state object in your actions - the components and the store need to share reference to the same object in order for the mutations to be observed.

If we enforce a convention where components are never allowed to directly mutate state that belongs to a store, but should instead dispatch events that notify the store to perform actions, we've essentially arrived at the [Flux](https://facebook.github.io/flux/) architecture. The benefits of this convention is we can record all state mutations happening to the store, and on top of that we can implement advanced debugging helpers such as mutation logs, snapshots, history re-rolls etc.

The Flux architecture is commonly used in React applications. Turns out the core idea behind Flux can be quite simply achieved in Vue.js, thanks to the unobtrusive reactivity system. Do note what we demonstrated here is just an example to introduce the concept - you may not need it at all for simple scenarios, and you should adapt the pattern to fit the real needs of your application.

## 単体テスト

モジュールベースのビルドシステムと互換性のあるものであれば、お好きなものを選んでください。おすすめは、[Karma](http://karma-runner.github.io/0.12/index.html) テストランナーです。It has a lot of community plugins, including support for [Webpack](https://github.com/webpack/karma-webpack) and [Browserify](https://github.com/Nikku/karma-browserify). For detailed setup, please refer to each project's respective documentation.

In terms of code structure for testing, the best practice is to export raw options / functions in your component modules. Consider this example:

``` js
// my-component.js
module.exports = {
  template: '<span>{{msg}}</span>',
  data: function () {
    return {
      msg: 'hello!'
    }
  },
  created: function () {
    console.log('my-component created!')
  }
}
```

このファイルは、エントリーモジュールで次のように使用できます：

``` js
// main.js
var Vue = require('vue')
var app = new Vue({
  el: '#app',
  data: { /* ... */ },
  components: {
    'my-component': require('./my-component')
  }
})
```

そして、出来たモジュールは次のようにテストできます：

``` js
// Some Jasmine 2.0 tests
describe('my-component', function () {  
  // require source module
  var myComponent = require('../src/my-component')
  it('should have a created hook', function () {
    expect(typeof myComponent.created).toBe('function')
  })
  it('should set correct default data', function () {
    expect(typeof myComponent.data).toBe('function')
    var defaultData = myComponent.data()
    expect(defaultData.message).toBe('hello!')
  })
})
```

<p class="tip">Vue.js のディレクティブは、非同期でデータ更新に反応するので、データ更新後の DOM ステータスに対してアサーションを行うには、`Vue.nextTick` のコールバックを利用する必要があります。</p>

## プロダクション向けのデプロイ

Vue.js の縮小されたスタンドアローンビルド版は、既に小さいファイルサイズにするため全ての警告を取り除いていますが、Vue.js アプリケーションを構築するために Browserify や Webpack のようなツールを使用するとき、これを達成するためにいくつかの追加設定をする必要があります。

### Webpack

警告ブロックが自動的に UglifyJS によって縮小中を削除できるように、プロダクション環境を示すために Webpack の [DefinePlugin](http://webpack.github.io/docs/list-of-plugins.html#defineplugin) を使ってください。設定例:

``` js
var webpack = require('webpack')

module.exports = {
  // ...
  plugins: [
    // ...
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: '"production"'
      }
    }),
    new webpack.optimize.UglifyJsPlugin({
      compress: {
        warnings: false
      }
    })
  ]
}
```

### Browserify

`NODE_ENV` に `"production"` を設定して、あなたのビルドコマンドを実行します。Vue は自動的に [envify](https://github.com/hughsk/envify) transform でそれ自身に適用し、警告ブロックに到達不能になります。例:

``` bash
NODE_ENV=production browserify -e main.js | uglifyjs -c -m > build.js
```

## アプリケーションの例

[Vue.js Hackernews Clone](https://github.com/yyx990803/vue-hackernews) は、Browserify と vue-loader を利用したソースコード管理と、Director.js を利用したルーティングの基本設計、また HackerNews の Firebase API をバックエンドとして利用したサンプルアプリケーションです。決して大きなアプリケーションではないですが、このページで説明する概念の併用を実証しています。
