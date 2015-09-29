title: 大規模アプリケーションの構築
type: guide
order: 15
---

Vue.js は、他のアーキテクチャと干渉せず、可能な限り柔軟に対応ができるよう設計されているインターフェイス・ライブラリです。Vue.js は、ラピッドプロトタイピングの手法において非常に扱いやすい一方で、大規模アプリケーションを構築する場合では、構築経験の少ない開発者にとって悩ましい問題にもなります。ここでは、Vue.js を活用して大規模なプロジェクトを整理する方法について、独断的視点から示しています。

## モジュール化

スタンドアロンで動作する Vue.js コードは、グローバルで使用できますが煩雑になりやすいので、モジュールのビルドツールを利用して、コードをより良く整理していくことが望ましいです。実践への導入としては、CommonJS モジュールにコード（Node.js、および Vue.js のソースコードで使用されているフォーマット）を記述して、[Webpack](http://webpack.github.io/) や [Browserify](http://browserify.org/) でバンドルする方法をおすすめします。

Webpack と Browserify は単にモジュールバンドラ以上のものです。それら両方は、他のプリプロセッサでソースコードを変換することができるソース変換 API を提供します。例えば、[babel-loader](https://github.com/babel/babel-loader) または [babelify](https://github.com/babel/babelify) を使用して、将来サポートされる ES6/7 シンタックスでコードを書くことができます。

## 単一ファイルコンポーネント

Vue.js を利用した典型的なプロジェクトでは、たくさんの個別のコンポーネントにコードを分割して、コンポーネントごとに HTML/CSS/JavaScript(Vue.js) を配置しておくと便利です。上述したように、Webpack または Browserify を使用するとき、次のようなコンポーネントを適切なソース変換できます:

<img src="/images/vue-component.png">

もし、プリプロセッサに詳しいなら、次のようにも書くことができます：

<img src="/images/vue-component-with-pre-processors.png">

これらの単一ファイル Vue コンポーネントを Webpack + [vue-loader](https://github.com/vuejs/vue-loader) または Browserify + [vueify](https://github.com/vuejs/vueify) でビルドできます。もしプリプロセッサを使用している場合、Webpack ローダ API はより良いファイル依存関係追跡とキャッシングが可能であるため、Webpack をセットアップして使用することをお勧めします。

GitHub のビルドセットアップの例を探すことができます。

- [Webpack + vue-loader](https://github.com/vuejs/vue-loader-example)
- [Browserify + vueify](https://github.com/vuejs/vueify-example)

## ルーティング

シングルページアプリケーション (Single Page Application: SPA) については、現在テクニカルプレビューな[オフィシャル vue-router ライブラリ](https://github.com/vuejs/vue-router)の使用を推奨します。詳細については、どうか vue-router の[ドキュメンテーション](http://vuejs.github.io/vue-router/)を参照してください。

もし、いくつかとてもシンプルなルーティングのロジックを必要としている場合は、ハッシュチェンジへのイベントリスニングと、動的なコンポーネントを利用することでそれを実装することができます。

**例：:**

``` html
<div id="app">
  <component is="{{currentView}}"></component>
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

すべての Vue インスタンスは、`JSON.stringify()` で直接シリアライズされる生の `$data` を持つことができます。Vue.js コミュニティは [vue-resource](https://github.com/vuejs/vue-resource) プラグインを貢献していて、RESTFul API で動作するため簡単な方法を提供します。例えば jQuery の `$.ajax` または [SuperAgent](https://github.com/visionmedia/superagent) などの好きな Ajax ライブラリも使用できます。Vue.js はバックエンドを持たない Firebase や Parse などのサービスとの連携にも適しています。

## 単体テスト

CommonJS ベースのビルドシステムと互換性のあるものであれば、お好きなものを選んでください。おすすめは、[Karma](http://karma-runner.github.io/0.12/index.html) と、そのプラグインの [CommonJS pre-processor](https://github.com/karma-runner/karma-commonjs) を使用して、テストを実行する方法です。

最良の実践は、モジュール内のオプションや関数をエクスポートします。次の例を考えてみます：

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

Vue.js の縮小されたスタンドアローンビルド版は、既に小さいファイルサイズにするため全ての警告を取り除いていますが、Vue.js アプリケーションを構築するために Browserify や Webpack のようなツールを使用するとき、そのやり方はあまり明白ではないです。

0.12.8 以降では、警告を取り除くためのツールを設定するのは非常に簡単です:

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

## 例

[Vue.js Hackernews Clone](https://github.com/yyx990803/vue-hackernews) は、Browserify と vue-loader を利用したソースコード管理と、Director.js を利用したルーティングの基本設計、また HackerNews の Firebase API をバックエンドとして利用したサンプルアプリケーションです。決して大きなアプリケーションではないですが、このページで説明する概念の併用を実証しています。

次: [Vue の拡張](/guide/extending.html)
