title: 大規模アプリケーションの構築
type: guide
order: 13
---

Vue.js は、他のアーキテクチャと干渉せず、可能な限り柔軟に対応ができるよう設計されているインターフェイス・ライブラリです。Vue.js は、ラピッドプロトタイピングの手法において非常に扱いやすい一方で、大規模アプリケーションを構築する場合では、構築経験の少ない開発者にとって悩ましい問題にもなります。ここでは、Vue.js を活用して大規模なプロジェクトを整理する方法について、独断的視点から示しています。

## モジュール化

スタンドアロンで動作する Vue.js コードは、グローバルで使用できますが煩雑になりやすいので、モジュールのビルドツールを利用して、コードをより良く整理していくことが望ましいです。実践への導入としては、CommonJS モジュールにコード（Node.js、および Vue.js のソースコードで使用されているフォーマット）を記述して、[Browserify](http://browserify.org/) や [Webpack](http://webpack.github.io/) でバンドルする方法をおすすめします。

下記は、GitHub 上にあるビルドツールの設定例です:

- [Vue + Browserify](https://github.com/vuejs/vue-browserify-example)
- [Vue + Webpack](https://github.com/vuejs/vue-webpack-example)

## 単一ファイルコンポーネント

Vue.js を利用した典型的なプロジェクトでは、たくさんの個別のコンポーネントにコードを分割して、コンポーネントごとに HTML/CSS/JavaScript(Vue.js) を配置しておくと便利です。前述のビルドツールを利用するメリットは、バンドルする前にソースコードを変換するためのメカニズムが提供されていることで、次のようなコンポーネントをわずかな前処理だけで作成できます：

<img src="/images/vueify.png">

もし、プリプロセッサに詳しいなら、次のようにも書くことができます：

<img src="/images/vueify_with_pre.png">

このファイルは、HTML/CSS/JavaScript(Vue.js) のソースコードを Browserify で管理できるよう変換してくれる [Vueify](https://github.com/vuejs/vueify) や、Webpack 用に変換してくれる [Vue-loader](https://github.com/vuejs/vue-loader) を使用することで、作成することができます。

## ルーティング

ハッシュチェンジへのイベントリスニングと、動的な `v-component` を利用することで基本的なルーティングのロジックを実装することができます。

**例：:**

``` html
<div id="app">
  <div v-component="{{currentView}}"></div>
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

このメカニズムでは、[Page.js](https://github.com/visionmedia/page.js) や [Director](https://github.com/flatiron/director) などの、ルーティングライブラリを活用すると非常に簡単です。

## サーバーとの通信

すべての Vue インスタンスは、`JSON.stringify()` で直接シリアライズされる生の `$data` を持つことができます。[SuperAgent](https://github.com/visionmedia/superagent) など、好きな Ajax コンポーネントを使用してください。バックエンドを持たない Firebase などのサービスとの連携にも適しています。

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
  }
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

## 例

[Vue.js Hackernews Clone](https://github.com/yyx990803/vue-hackernews) は、Browserify と vue-loader を利用したソースコード管理と、Director.js を利用したルーティングの基本設計、また HackerNews の Firebase API をバックエンドとして利用したサンプルアプリケーションです。決して大きなアプリケーションではないですが、このページで説明する概念の併用を実証しています。

次: [Vue の拡張](/guide/extending.html)
