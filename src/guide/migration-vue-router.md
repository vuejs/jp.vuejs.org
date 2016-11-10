---
title: Vue ルーター 0.7.x からの移行
type: guide
order: 26
---

> Vue ルーター 2 は Vue 2 に対応する唯一のルーターなので、 Vue を更新する場合には Vue ルーター も同様に更新する必要があります。2のドキュメントに移行ガイドが用意されているのもそういう理由からです。新しい Vue Vue ルーター を用いた包括的なドキュメントは [Vue ルーター ドキュメント](http://router.vuejs.org/ja/)を確認してください。

## Router Initialization

### `router.start` <sup>deprecated</sup>

There is no longer a special API to initialize an app with Vue Router. That means instead of:

``` js
router.start({
  template: '<router-view></router-view>'
}, '#app')
```

You'll just pass a router property to a Vue instance:

``` js
new Vue({
  el: '#app',
  router: router,
  template: '<router-view></router-view>'
})
```

Or, if you're using the runtime-only build of Vue:

``` js
new Vue({
  el: '#app',
  router: router,
  render: h => h('router-view')
})
```

{% raw %}
<div class="upgrade-path">
  <h4>Upgrade Path</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of <code>router.start</code> being called.</p>
</div>
{% endraw %}

## ルートの定義

### `router.map` <sup>deprecated</sup>

ルートは [`routes` オプション](http://router.vuejs.org/ja/essentials/getting-started.html#javascript) に配列として定義されるようになりました。例えばこのようなルートの記述は:

``` js
router.map({
  '/foo': {
    component: Foo
  },
  '/bar': {
    component: Bar
  }
})
```

このように記述するようになります:

``` js
var router = new VueRouter({
  routes: [
    { path: '/foo', component: Foo },
    { path: '/bar', component: Bar }
  ]
})
```

オブジェクトの反復走査はキー順序に関するブラウザ毎の一貫性がないため、配列を用いた記法を用いて、より予測可能なルート検出を実現しています。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>コードに対し <a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a> を実行し <code>router.map</code> がコールされる箇所を検出して下さい。</p>
</div>
{% endraw %}

### `router.on` <sup>deprecated</sup>

アプリケーションの開始時に、機械的にルートを生成する必要がある場合、ルートの配列に対し動的に定義を追加することが出来ます。例えば次の様な形です:

``` js
// 通常のルート定義
var routes = [
  // ...
]

// 動的に生成されるルート定義
marketingPages.forEach(function (page) {
  routes.push({
    path: '/marketing/' + page.slug
    component: {
      extends: MarketingComponent
      data: function () {
        return { page: page }
      }
    }
  })
})

var router = new Router({
  routes: routes
})
```

ルーターが初期化された後に新しいルートを追加する必要がある場合、加筆された新しいルート機構で、既存のものを置き換えることができます。

``` js
router.match = createMatcher(
  [{
    path: '/my/new/path',
    component: MyComponent
  }].concat(router.options.routes)
)
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>コードに対し<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a> を実行し <code>router.on</code> がコールされる箇所を検出して下さい。</p>
</div>
{% endraw %}

### `subRoutes` <sup>deprecated</sup>

Vue と他のルーターライブラリとの一貫性のために、[`children`に名前が変更されました。](http://router.vuejs.org/ja/essentials/nested-routes.html) 

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>コードに対し<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a> を実行し <code>subRoutes</code> がコールされる箇所を検出して下さい。</p>
</div>
{% endraw %}

### `router.redirect` <sup>deprecated</sup>

[ルート定義におけるオプション](http://router.vuejs.org/ja/essentials/redirect-and-alias.html) として記述するようになりました。よって、例えば次のような例は:

``` js
router.redirect({
  '/tos': '/terms-of-service'
})
```

`routes` 設定内にて次のように記述します:

``` js
{
  path: '/tos',
  redirect: '/terms-of-service'
}
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>コードに対し<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a> を実行し<code>router.redirect</code> がコールされる箇所を検出して下さい。</p>
</div>
{% endraw %}

### `router.alias` <sup>deprecated</sup>

[ルート定義におけるオプション](http://router.vuejs.org/ja/essentials/redirect-and-alias.html) として記述するようになりました。よって、例えば次のような例は:

``` js
router.alias({
  '/manage': '/admin'
})
```

`routes` 設定内にて次のように記述します:

``` js
{
  path: '/admin',
  component: AdminPanel,
  alias: '/manage'
}
```

複数のエイリアスが必要な場合、配列記法を用いることが出来ます。

``` js
alias: ['/manage', '/administer', '/administrate']
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>コードに対し <a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a> を実行し <code>router.alias</code> がコールされる箇所を検出して下さい。</p>
</div>
{% endraw %}

### Arbitrary Route Properties

Arbitrary route properties must now be scoped under the new meta property, to avoid conflicts with future features. So for example, if you had defined:

``` js
'/admin': {
  component: AdminPanel,
  requiresAuth: true
}
```

Then you would now update it to:

``` js
{
  path: '/admin',
  component: AdminPanel,
  meta: {
    requiresAuth: true
  }
}
```

Then when later accessing this property on a route, you will still go through meta. For example:

``` js
if (route.meta.requiresAuth) {
  // ...
}
```

{% raw %}
<div class="upgrade-path">
  <h4>Upgrade Path</h4>
  <p>Run the <a href="https://github.com/vuejs/vue-migration-helper">migration helper</a> on your codebase to find examples of arbitrary route properties not scoped under meta.</p>
</div>
{% endraw %}

## ルートのマッチング

より柔軟性を高めるために、ルートのマッチングの内部処理には、 [path-to-regexp](https://github.com/pillarjs/path-to-regexp) が利用されるようになりました。

### 1つ以上の名前付きパラメータ

構文に多少の変化があります。例えば `/category/*tags` は `/category/:tags+` に変更する必要があります。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>コードに対し <a href="https://github.com/vuejs/vue-migration-helper">移行ガイド</a> を実行し廃止された文法を利用している箇所を検出して下さい。</p>
</div>
{% endraw %}

## リンク

### `v-link` <sup>deprecated</sup>

Vue 2 におけるコンポーネントの機能の一環として、`v-link` ディレクティブは新しく [`<router-link>` コンポーネント](http://router.vuejs.org/ja/api/router-link.html) に置き換えられました。以下の様な形で記述されたリンクは:

``` html
<a v-link="'/about'">About</a>
```

次のように変更しなければなりません:

``` html
<router-link to="/about">About</router-link>
```

`<router-link>` では `target="_blank"` はサポートされいないことに注意してください。新しいタブでリンクを開く必要がある場合は、`<a>` を代わりに使用しなければなりません。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>コードに対し <a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a> を実行し <code>v-link</code> ディレクティブが使用されている箇所を検出して下さい。</p>
</div>
{% endraw %}

### `v-link-active` <sup>deprecated</sup>

[`<router-link>` コンポーネント](http://router.vuejs.org/ja/api/router-link.html) でタグの指定が可能なため、 `v-link-active` ディレクティブは廃止されました。よって、例えば次のような例は:

``` html
<li v-link-active>
  <a v-link="'/about'">About</a>
</li>
```

このような形になります:

``` html
<router-link tag="li" to="/about">
  <a>About</a>
</router-link>
```

`<a>` が実際のリンクとなり (正しい href をもっています), active クラスは外側の `<li>` に付与されます。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>コード上で <a href="https://github.com/vuejs/vue-migration-helper">移行ガイド</a> を実行し <code>v-link-active</code> ディレクティブが使用されている箇所を検出して下さい。</p>
</div>
{% endraw %}

## 動的なナビゲーション

### `router.go`

For consistency with the [HTML5 History API](https://developer.mozilla.org/en-US/docs/Web/API/History_API), `router.go` is now only used for [back/forward navigation](https://router.vuejs.org/en/essentials/navigation.html#routergon), while [`router.push`](http://router.vuejs.org/en/essentials/navigation.html#routerpushlocation) is used to navigate to a specific page.

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>コードに対し <a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a> を実行し <code>router.push</code> の代わりに使用される <code>router.go</code> がコールされる箇所を検出して下さい。</p>
</div>
{% endraw %}

## Router Options: Modes

### `hashbang: false` <sup>deprecated</sup>

Google にURL をクロールさせるために Hashbangs を用いる必要はもはやなくなりました。よってハッシュの方式としてデフォルトではなくなり、オプションとして利用できなくなりました。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>コードに対し <a href="https://github.com/vuejs/vue-migration-helper"> 移行ヘルパー </a> を実行し <code>hashbang: false</code> オプションが利用されている箇所を検出して下さい。</p>
</div>
{% endraw %}

### `history: true` <sup>deprecated</sup>

ルーティングの動作に関するオプションは [`mode` オプション](http://router.vuejs.org/ja/api/options.html#mode) にまとめられました。このような記述は:

``` js
var router = new VueRouter({
  history: 'true'
})
```

次のように変更しなければなりません:

``` js
var router = new VueRouter({
  mode: 'history'
})
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>コードに対し <a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a> を実行し <code>history: true</code> オプションが使用されている箇所を検出して下さい。</p>
</div>
{% endraw %}

### `abstract: true` <sup>deprecated</sup>

ルーティングの動作に関するオプションは [`mode` オプション](http://router.vuejs.org/ja/api/options.html#mode) にまとめられました。このような記述は:

``` js
var router = new VueRouter({
  abstract: 'true'
})
```

次のように変更しなければなりません:

``` js
var router = new VueRouter({
  mode: 'abstract'
})
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>コードに対し <a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a> を実行し <code>abstract: true</code> オプションが使用されている箇所を検出して下さい。</p>
</div>
{% endraw %}

## その他のルートオプション

### `saveScrollPosition` <sup>deprecated</sup>

関数を受け付ける [`scrollBehavior` オプション](http://router.vuejs.org/ja/advanced/scroll-behavior.html) に変更されました。スクロールの挙動は、ルートごとに完全にカスタマイズ可能になりました。これによってより多くの可能性がひらかれましたが、単に以前の挙動を再現したい場合もあるでしょう。これまで、次の様に記述していた所は:

``` js
saveScrollPosition: true
```

このように変更すれば、同じ動作が保たれます:

``` js
scrollBehavior: function (to, from, savedPosition) {
  return savedPosition || { x: 0, y: 0 }
}
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>コードに対し <a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a> を実行し <code>saveScrollPosition: true</code> オプションを使用している箇所を検出して下さい。</p>
</div>
{% endraw %}

### `root` <sup>deprecated</sup>

[HTML の `<base>` 要素](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/base)と合わせるため `base` に名称変更されました。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>コードに対し <a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a> を実行し <code>root</code> オプションを使用している箇所を検出して下さい。</p>
</div>
{% endraw %}

### `transitionOnLoad` <sup>deprecated</sup>

Vue のトランジション機能に、[`appear` トランジションの制御](transitions.html#Transitions-on-Initial-Render) が実装されたため、このオプションはもはや不要になりました。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>コードに対し <a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a> を実行し <code>transitionOnLoad: true</code> オプションを使用している箇所を検出して下さい。</p>
</div>
{% endraw %}

### `suppressTransitionError` <sup>deprecated</sup>

フックをよりシンプルにするために削除されました。どうしてもトランジションのエラーを抑制しなければならない場合 [`try`...`catch`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/try...catch) 構文を代わりに使用して下さい。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>コードに対し <a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a> を実行し <code>suppressTransitionError: true</code> オプションを使用している箇所を検出して下さい。</p>
</div>
{% endraw %}

## Route Hooks

### `activate` <sup>deprecated</sup>

代わりにコンポーネントにて [`beforeRouteEnter`](http://router.vuejs.org/ja/advanced/navigation-guards.html#incomponent-guards) を使用してください。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>コードに対し <a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a> を実行し <code>beforeRouteEnter</code> フックを使用している箇所を検出して下さい。</p>
</div>
{% endraw %}

### `canActivate` <sup>deprecated</sup>

代わりに、ルート内で [`beforeEnter`](http://router.vuejs.org/ja/advanced/navigation-guards.html#perroute-guard) を使用して下さい。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>コードに対し <a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a> を実行し <code>canActivate</code> フックを使用している箇所を検出して下さい。</p>
</div>
{% endraw %}

### `deactivate` <sup>deprecated</sup>

代わりに、コンポーネントにて [`beforeDestroy`](/api/#beforeDestroy) を使用するか [`destroyed`](/api/#destroyed) フックを使用するようにしてください。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>コードに対し <a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a> を実行し <code>deactivate</code> フックを使用している箇所を検出して下さい。</p>
</div>
{% endraw %}

### `canDeactivate` <sup>deprecated</sup>

代わりに、コンポーネント内で [`beforeRouteLeave`](http://router.vuejs.org/ja/advanced/navigation-guards.html#incomponent-guards) を使用して下さい。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>コードに対し <a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a> を実行し <code>canDeactivate</code> フックを使用している箇所を検出して下さい。</p>
</div>
{% endraw %}

### `canReuse: false` <sup>deprecated</sup>

新しい Vue ルーターではこれを使用する場面は無いでしょう。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>コードに対し <a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a> を実行し <code>canReuse: false</code> option.</p>
</div>
{% endraw %}

### `data` <sup>deprecated</sup>

`$route` プロパティはリアクティブに出来ているため、ルートの変更は次のようにウォッチ機能を利用する事で検出できます:

``` js
watch: {
  '$route': 'fetchData'
},
methods: {
  fetchData: function () {
    // ...
  }
}
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>コードに対し <a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a> を実行し <code>data</code> フックを使用している箇所を検出して下さい。</p>
</div>
{% endraw %}

### `$loadingRouteData` <sup>deprecated</sup>

Define your own property (e.g. `isLoading`), then update the loading state in a watcher on the route. For example, if fetching data with [axios](https://github.com/mzabriskie/axios):
独自のプロパティを定義し (例えば `isLoading`), ルートのウォッチャーでローティングの状態を更新して下さい。例えば [axios](https://github.com/mzabriskie/axios)のデータを取り込む場合、次のような例になります:

``` js
data: function () {
  return {
    posts: [],
    isLoading: false,
    fetchError: null
  }
},
watch: {
  '$route': function () {
    var self = this
    self.isLoading = true
    self.fetchData().then(function () {
      self.isLoading = false
    })
  }
},
methods: {
  fetchData: function () {
    var self = this
    return axios.get('/api/posts')
      .then(function (response) {
        self.posts = response.data.posts
      })
      .catch(function (error) {
        self.fetchError = error
      })
  }
}
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>コードに対し <a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a> を実行し <code>$loadingRouteData</code> メタプロパティが使用されている箇所を検出して下さい。</p>
</div>
{% endraw %}
