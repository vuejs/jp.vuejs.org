---
title: ルーティング
type: guide
order: 21
---

## 公式ルータ

ほとんどのシングルページアプリケーション (SPA: single page application) を作成する場合、公式にサポートされている [vue-router ライブラリ](https://github.com/vuejs/vue-router) を使うことをお勧めします。さらに詳しい内容は vue-router の[ドキュメント](http://router.vuejs.org/)を参照してください。

## スクラッチからの単純なルーティング

とてもシンプルなルーティングを必要としていて、フル機能のルータライブラリを使用したくない場合は、このようにページレベルのコンポーネントで動的に描画することができます。

``` js
const NotFound = { template: '<p>Page not found</p>' }
const Home = { template: '<p>home page</p>' }
const About = { template: '<p>about page</p>' }

const routes = {
  '/': Home,
  '/about': About
}

new Vue({
  el: '#app',
  data: {
    currentRoute: window.location.pathname
  },
  computed: {
    ViewComponent () {
      return routes[this.currentRoute] || NotFound
    }
  },
  render (h) { return h(this.ViewComponent) }
})
```

HTML5の History API と組み合わせることで、とても基本ですが、完全に機能するクライアント側のルータを構築することができます。実際に確認するには [サンプル](https://github.com/chrisvfritz/vue-2.0-simple-routing-example) を取得してください。

## サードパーティのルータとの統合

もし、[Page.js](https://github.com/visionmedia/page.js) や [Director](https://github.com/flatiron/director) の様なサードパーティのルータを使いたい場合、統合するのは [非常に簡単](https://github.com/chrisvfritz/vue-2.0-simple-routing-example/compare/master...pagejs) です。ここに Page.js を使った [サンプル](https://github.com/chrisvfritz/vue-2.0-simple-routing-example/tree/pagejs) があります。
