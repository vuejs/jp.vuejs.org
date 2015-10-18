---
title: 大規模アプリケーションの構築
type: guide
order: 18
---

Vue.js コアライブラリは、view レイヤーにフォーカスされて柔軟に設計されており、全てのアプリケーションレベルのアーキテクチャと干渉しないライブラリです。これは既存プロジェクトとの統合のために素晴らしいことができますが、スクラッチからの大規模アプリケーションを構築する場合は、構築経験の少ない開発者にとって悩ましい問題にもなります。

Vue.js のエコシステムは、Vue で大規模なシングルページアプリケーション (SPA: single page application) を構築する方法のライブラリのツールセットを提供します。このパートは、私達が少しだけ"フレームワーク"のように感じるようなものを開始しますが、それは本当にごく推奨するリストです。あなたは、今までどおりに積み重ねられた各パートにおいて使用するものを選ぶとよいでしょう。

## モジュール化

大規模なプロジェクトの場合、あなたのコードをよく整理するためにモジュール化ビルドシステムを利用することが必要です。そうすることの推奨するアプローチは、CommonJS または ES6 モジュールにあなたのソースコードを書いて、[Webpack](http://webpack.github.io/) または [Browserify](http://browserify.org/) を使用してそれらをバンドルします。

Webpack と Browserify は単にモジュールバンドラ以上のものです。それら両方は、他のプリプロセッサでソースコードを変換することができるソース変換 API を提供します。例えば、[babel-loader](https://github.com/babel/babel-loader) または [babelify](https://github.com/babel/babelify) を使用して、将来サポートされる ES2015/2016 構文でコードを書くことができます。

あなたがこれまでにそれらを使用したことがない場合は，私は、いくつかのチュートリアルを通って、モジュールバンドラの概念に精通して得て、最新の ECMAScript の機能を使用して書き始めるのを、大いにお勧めします。

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

シングルページアプリケーションについては、現在テクニカルプレビューな[オフィシャル vue-router ライブラリ](https://github.com/vuejs/vue-router)の使用を推奨します。詳細については、どうか vue-router の[ドキュメンテーション](http://vuejs.github.io/vue-router/)を参照してください。

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

## 状態管理

大規模なアプリケーションで、状態管理はしばしば、状態が多くのコンポーネントに散らばって、それらコンポーネントの間に相互作用している複数の部品のために複雑になります。それは、Vue.js アプリケーションにおける本当のソースは生データのオブジェクトであることを、よく見落とされています。Vue インスタンスは単純にそれにプロキシアクセスします。それゆえ、あなたは複数のインスタンスによって共有されるべき状態の部品を持つ場合は、あなたはその重複を避けて、同一性によってそれを共有すべきです:

``` js
var sourceOfTruth = {}

var vmA = new Vue({
  data: sourceOfTruth
})

var vmB = new Vue({
  data: sourceOfTruth
})
```

現在、`sourceOfTruth` が変化されるたびに、`vmA` と `vmB` の両方は、自動的にそれら view を更新します。さらに、この考えた方を拡張して、私達は **store パターン**にたどり着くでしょう:

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

私達は、store 自体の内部に store の状態を変化させる全てのアクションに置いていることに注意してください。集中型の状態管理のこのタイプは、変化のタイプが状態に起こる可能性を、簡単に理解することができ、トリガされる方法があります。各コンポーネントはまだ所有し、そのプライベートな状態を管理することができます。

![State Management](/images/state.png)

注意することの1つは、あなたがあなたのアクションにおいて元の状態オブジェクトを決して置き換えてはいけないということです。コンポーネントと store は、変化が監視されるべきために、同じオブジェクトへの参照を共有する必要があります。

私達は、コンポーネントが直接 store に属する状態を変化させるのはできない規約を強制する場合は、代わりに、アクションを実行するために store に通知するイベントを送り出す必要がありますが、私達は本質的に [Flux](https://facebook.github.io/flux/) アーキテクチャにたどり着きました。この規約の利点は、私達が store に起こっている変化を全ての状態を記録でき、そしてその上で、私達は変化ログ、スナップショット、履歴の再転用などのような、高度なデバッギングヘルパーを実装することができます。

Flux アーキテクチャは React アプリケーションで一般的に使用されています。コアなアイデアの裏からひっくり返して、Flux は Vue.js で非常に単純に達成することができので、地味なリアクティブシステムに感謝します。私達が、コンセプトを導入するための一例にすぎない、ここで実証するものであるということに注意してください。あなたは、すべての単純なシナリオのためにそれを必要としておらず、あなたはあなたのアプリケーションの真のニーズに合わせてパターンを調整する必要があります。

## 単体テスト

モジュールベースのビルドシステムと互換性のあるものであれば、お好きなものを選んでください。おすすめは、[Karma](http://karma-runner.github.io/0.12/index.html) テストランナーです。それは、たくさんのコミュニティプラグインがあり、[Webpack](https://github.com/webpack/karma-webpack) と [Browserify](https://github.com/Nikku/karma-browserify) にサポートを含んでいます。詳細なセットアップについては各プロジェクトのそれぞれのドキュメントを参照してください。

テストのためにコード構造の観点から、ベストプラクティスはあなたのコンポーネントモジュールで生のオプション/機能をエクスポートすることです。この例を考えてみます:

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
// Jasmine 2.0 のテストと同じ
describe('my-component', function () {  
  // ソースモジュールを require
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

警告ブロックが自動的に UglifyJS によって縮小中に削除されるように、プロダクション環境を示すために Webpack の [DefinePlugin](http://webpack.github.io/docs/list-of-plugins.html#defineplugin) を使ってください。設定例:

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

[Vue.js Hackernews Clone](https://github.com/vuejs/vue-hackernews) は、Browserify と vue-loader を利用したソースコード管理と、Director.js を利用したルーティングの基本設計、また HackerNews の Firebase API をバックエンドとして利用したサンプルアプリケーションです。決して大きなアプリケーションではないですが、このページで説明する概念の併用を実証しています。
