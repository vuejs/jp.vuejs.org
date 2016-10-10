---
title: サーバサイドレンダリング
type: guide
order: 23
---

## SSR が必要ですか ?

SSR について知る前に、それが一体何をするもので、どのようなケースにおいて必要になるのか考えてみましょう。

### SEO

Google や Bing は、同期的な JavaScript のアプリケーションを上手にインデックスしてくれます。 _同期的な_ というのが重要で、もしあなたのアプリケーションが、ローディングのスピナーから始まり、 Ajax 経由でコンテンツを取得しようとするならば、クローラはローディングの完了を待ってくれないでしょう。

非同期に取得されるページ上のコンテンツが SEO 上で重要な意味をもつ場合、 SSR が必要になるでしょう。

### 低速なインターネット環境

あなたのサイトを訪れるユーザの中には、低速なインターネット回線を利用する人や、不安定なモバイル回線を利用している人がいるかもしれません。このようなケースでは、基本的なコンテンツを見せるために必要なリクエストを、数、量共に減らしたいと考えるでしょう。

[ Webpack のコード分割](https://webpack.github.io/docs/code-splitting.html) を利用して、ユーザが単一のページを閲覧するためにアプリケーションの全体をダウンロードしなければならないという事情を解消することも出来ます。が、サーバサイドで事前に描画された HTML ファイルのダウンロードはそれよりももっと大きなパフォーマンスを導くことが出来ます。

### 古い JavaScript 環境、または JavaScript の利用できない環境

一部の人々やとある地域では、 1998 年から稼働するコンピュータを用いてインターネットにアクセスする、という様なケースも考えられるでしょう。　Vue は IE9+ 以上の環境でのみ動作しますが、それよりも古いブラウザ環境にコンテンツを配信したいケースや、ターミナルで [Lynx](http://lynx.browser.org/) を利用するような、最先端の技術者にコンテンツを配信したいケースなども考えられます。

### SSR vs プリレンダリング

もしあなたが 一部の商用ページ(例えば `/`, `/about`, `/contact`, など)の SEO を改善するために、 SSR を調べようとしているなら、 おそらく __プリレンダリング__ が代わりに役立つでしょう。 レスポンス発行前に HTML をコンパイルするためにWeb サーバを利用するのに比べ、プリレンダリングは単にビルド時に特定のルートで静的な HTML を生成するだけです。プリレンダリングの利便性は、準備がシンプルな点とフロントエンドを完全に静的な構成で保つことが出来るという点にあります。

もし Webpack を使用しているなら、 [prerender-spa-plugin](https://github.com/chrisvfritz/prerender-spa-plugin) を用いてプリレンダリングの構成を整えることが出来ます。 Vue アプリでの動作も広くテストされていて - 実際のところ、 Vue のコアチームのメンバーが、 prerender-spa-plugin の制作を行っていたりします。

## Hello World

ようやく SSR を始める準備が出来ました。複雑に聞こえるかもしれませんが、デモで使用する基本的な node のスクリプトはたった3つのステップでできています:

``` js
// Step 1: Vue インスタンスの生成
var Vue = require('vue')
var app = new Vue({
  render: function (h) {
    return h('p', 'hello world')
  }
})

// Step 2: renderer の生成
var renderer = require('vue-server-renderer').createRenderer()

// Step 3: Vue instance を描画し HTML に変換
renderer.renderToString(app, function (error, html) {
  if (error) throw error
  console.log(html)
  // => <p server-rendered="true">hello world</p>
})
```

どうです？怖くないでしょう？もちろんこの例は大半のアプリケーションより随分とシンプルなものです。まだこの段階では、次のような事は考えなくても良いでしょう:

- Web サーバについて 
- Response ストリーミング
- コンポーネントのキャッシュ
- ビルドの仕組みについて
- ルーティング
- Vuex State とのハイドレーション(Hydration)

このガイドの残りの節で、これらの機能をどのように実装していくかを解説していきます。基本が理解できた所で、より詳しい解説へと応用的な例へと進み、特殊なケースへの対応を理解していきましょう。

## Express を利用したシンプルなサーバサイドレンダリング

Web サーバもなしにサーバサイドレンダリングというのはおかしな気もするので、まずはそこから解決していきましょう。特別なビルドの手続も Vue のプラグインも使わず ES5 のスクリプトのみで書かれたシンプルな SSR のアプリケーションを構築していきます。

まずは、ページに滞在している秒数を知らせてくれるだけのアプリケーションから考えてみます。

``` js
new Vue({
  template: '<div>You have been here for {{ counter }} seconds.</div>',
  data: {
    counter: 0
  },
  created: function () {
    var vm = this
    setInterval(function () {
      vm.counter += 1
    }, 1000)
  }
})
```

これを SSR に適用する場合、ブラウザと node の両方で動作させられるよう、少しの修正が必要になります。

- ブラウザでは、操作可能なようにアプリケーションをグローバルのコンテキスト(例えば `window` )に配置したりします。
- node では、各リクエスト毎に新しいアプリケーションのインスタンスを作成するよう、ファクトリ関数をエクスポートします。

このような実装のために次のような例が必要になります:

``` js
// assets/app.js
(function () { 'use strict'
  var createApp = function () {
    // ---------------------
    // 通常のアプリケーションコード
    // ---------------------

    // クライアントサイドのコードが読み込み後にそれを引き継げるよう、
    // id "app"をルートノードにもつメインの Vue インスタンスが
    // 返却されなければなりません。
    return new Vue({
      template: '<div id="app">You have been here for {{ counter }} seconds.</div>',
      data: {
        counter: 0
      },
      created: function () {
        var vm = this
        setInterval(function () {
          vm.counter += 1
        }, 1000)
      }
    })

    // -------------------
    // 通常のアプリケーションコード 終わり
    // -------------------
  }
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = createApp
  } else {
    this.app = createApp()
  }
}).call(this)
```

アプリケーションのコードが出来たので、 `index.html` ファイルを確認してみましょう:

``` html
<!-- index.html -->
<!DOCTYPE html>
<html>
<head>
  <title>My Vue App</title>
  <script src="/assets/vue.js"></script>
</head>
<body>
  <div id="app"></div>
  <script src="/assets/app.js"></script>
  <script>app.$mount('#app')</script>
</body>
</html>
```

先程作成した `app.js` や Vue の本体となる `vue.js` を含む `assets` ディレクトリを参照しているため、シングルページアプリケーションとして動作させることが可能です。

サーバサイドレンダリングとして動かすには、あと一歩、Web サーバ側に次のような工夫が必要です:

``` js
// server.js
'use strict'

var fs = require('fs')
var path = require('path')

// サーバサイドで利用するため、グローバル変数に Vue を定義する
global.Vue = require('vue')

// HTML を取得する
var layout = fs.readFileSync('./index.html', 'utf8')

// レンダラを生成する
var renderer = require('vue-server-renderer').createRenderer()

// express サーバを生成する
var express = require('express')
var server = express()

// assets ディレクトリは静的にファイルを転送する。
server.use('/assets', express.static(
  path.resolve(__dirname, 'assets')
))

// GET リクエストをハンドル
server.get('*', function (request, response) {
  // Vue アプリケーションを文字列に変換
  renderer.renderToString(
    // アプリケーションインスタンスを生成
    require('./assets/app')(),
    // 描画結果を取得
    function (error, html) {
      // 描画中にエラーが起きたら...
      if (error) {
        // コンソールにエラーを書き込み
        console.error(error)
        // クライアントにエラーを通知する
        return response
          .status(500)
          .send('Server Error')
      }
      // アプリケーションの HTML とともにレイアウトを送信する
      response.send(layout.replace('<div id="app"></div>', html))
    }
  )
})

// 5000番ポートで待機
server.listen(5000, function (error) {
  if (error) throw error
  console.log('Server is running at localhost:5000')
})
```

これで以上です！ [アプリケーションの全体](https://github.com/chrisvfritz/vue-ssr-demo-simple) はここから確認でき、クローンして、色々試してみる事が出来ます。ローカル環境でアプリケーションを実行して、右クリックメニューの "ページのソースを表示" (もしくはそれに近い何か)を選択することで、サーバサイドレンダリングが実際に動いている事を確認できるでしょう。 body には次のような記述が確認できるでしょう:

``` html
<div id="app" server-rendered="true">You have been here for 0 seconds&period;</div>
```

サーバサイドレンダリングなしでは次のように見えるはずです:

``` html
<div id="app"></div>
```

## レスポンスのストリーミング

Vue は __ストリーム (stream)__ への出力もまたサポートしており、ストリーミングをサポートする Web サーバではこちらの方が好まれるかもしれません。ストリーミングを用いることで、描画が完全に終わってからまとめてレスポンスの出力を行うのではなく、 _描画の進捗に応じて_ 出力を行えるようになります。結果として特段のデメリット無く、レスポンス速度を向上させる事が出来ます。

上に挙げた例をストリーミングに対応させる場合、 `server.get('*', ...)` ブロックの中身を単純に次の用に書き換えてやれば OK です:

``` js
// レイアウトを2つのHTMLに分割する
var layoutSections = layout.split('<div id="app"></div>')
var preAppHTML = layoutSections[0]
var postAppHTML = layoutSections[1]

// Get リクエストをハンドル
server.get('*', function (request, response) {
  // ストリームに Vue アプリケーションを書き込む
  var stream = renderer.renderToStream(require('./assets/app')())

  // アプリケーションによって出力される HTML より前の HTML 内容をレスポンスに書き込む
  response.write(preAppHTML)

  // 新しい chunk がアプリケーションによって HTML が描画されたら...
  stream.on('data', function (chunk) {
    // その chunk をレスポンスに書き込む
    response.write(chunk)
  })

  // 全ての chunks がアプリケーションによって生成されたら...
  stream.on('end', function () {
    // アプリケーションによって出力される HTML より後の HTML 内容をレスポンスに書き込む
    response.end(postAppHTML)
  })

  // 書き込み中にエラーが発生したら...
  stream.on('error', function (error) {
    // コンソールにエラーを書き込み
    console.error(error)
    // クライアントにエラーを通知する
    return response
      .status(500)
      .send('Server Error')
  })
})
```

このように、ストリームという新しい概念に触れる場合でも、前の例と比べてもそんなに複雑になるということはありません。私達がすることといえば次の5つです:

1. ストリームを利用する準備
2. アプリケーションによって出力される HTML より前の HTML 内容をレスポンスに書き込む
3. アプリケーションで描画される HTML を利用可能なものとして書き込む
4. アプリケーションによって出力される HTML より後の HTML 内容をレスポンスに書き込み、終了する
5. 任意のエラーをハンドリングする。

## コンポーネントのキャッシュ

Vue はデフォルトで高速に動作しますが、コンポーネントの描画結果をキャッシュすることで、さらにパフォーマンスを向上させることができます。キャッシュはより便利な機能なのですが、間違ったコンポーネントのキャッシュ ( や正しいコンポーネントでもキーが違う場合 ) は、アプリケーションでの描画バグを招きます。とりわけ次の様なケースでは注意が必要です: 

<p class="tip"> グローバルの状態( vuex の store など )に依存するコンポーネントを子として有するコンポーネントをキャッシュすべきではありません。このようなケースでは子コンポーネントも含めて(正確に言えば子コンポーネントからなるサブツリー全体が)親コンポーネントとともにキャッシュされてしましまいます。子コンポーネントやスロットを受け付けるコンポーネントでは十分に注意して下さい。 </p>

### 導入の準備

注意点はこれくらいにして、キャッシュの利用方法について確認していきます。

まずは、[キャッシュオブジェクト](https://www.npmjs.com/package/vue-server-renderer#cache) によるレンダラを準備する必要があります。 [lru-cache](https://github.com/isaacs/node-lru-cache) を用いたシンプルな例を確認してみましょう:

``` js
var createRenderer = require('vue-server-renderer').createRenderer
var lru = require('lru-cache')

var renderer = createRenderer({
  cache: lru(1000)
})
```

この例ではユニークな描画結果を最大 1000 個キャッシュしてくれます。 メモリの使用量に合わせた細かな設定などは、 [lru-cache options](https://github.com/isaacs/node-lru-cache#options) を確認してください。

コンポーネントをキャッシュするために、次の要素をコンポーネントに含める必要があります。

- ユニークな `name`
- コンポーネント間でユニークなキーを返す `serverCacheKey` 関数

例を見てみましょう:

``` js
Vue.component({
  name: 'list-item',
  template: '<li>{{ item.name }}</li>',
  props: ['item'],
  serverCacheKey: function (props) {
    return props.item.type + '::' + props.item.id
  }
})
```

### キャッシュするための理想的なコンポーネント 

"ピュア(pure)"コンポーネントは、同じ props に対して必ず同じ HTML を生成することを保証しているコンポーネントで 、安全にキャッシュすることができます。よくある例としては次のようなものがあります:

- 静的なコンポーネント (例えば、常に同じ HTML を生成するもので `serverCacheKey` 関数がただ `true` を返すのみで良いケース)
- リストアイテムのコンポーネント (巨大なリストにおいて、それらをキャッシュすることはパフォーマンスを大きく向上させます)
- 一般的な UI コンポーネント (例えば、ボタンや、アラートなどで、コンテンツを slot や子コンポーネントからではなく、 props から受け取るもの)

## ビルド、ルーティング、そして Vuex の状態ハイドレーション

ここまでで、サーバサイドレンダリングの基本的な概念は理解できたでしょう。しかし、ビルドの仕組みやルーティング、Vuex などに手をつけ始めると、また個別に考えなければならない問題が現れて来るでしょう。

複雑なアプリケーションにおけるサーバにサイドレンダリングを完全にこなすには、これらのリソースにしっかり目を通しておくのがおすすめです。

- [vue-server-renderer ドキュメント](https://www.npmjs.com/package/vue-server-renderer#api): ここで触れた内容に関するより詳しい解説に加え、[複数リクエストによる汚染防止](https://www.npmjs.com/package/vue-server-renderer#why-use-bundlerenderer) や [サーバ向けのビルド手順](https://www.npmjs.com/package/vue-server-renderer#creating-the-server-bundle)といった応用的なトピックを紹介しています。
- [vue-hackernews-2.0](https://github.com/vuejs/vue-hackernews-2.0): Vue のメジャーなライブラリと概念を1つのアプリケーションにまとめた信頼できるサンプルです。
