---
title: 動的 & 非同期コンポーネント
updated: 2020-02-25
type: guide
order: 105
---

> このページは既に[コンポーネントの基本](components.html)を読んでいる事を前提としています。 コンポーネントを初めて使う方はそちらを先にお読みください。

## 動的コンポーネントにおける `keep-alive` の利用

まず、`is` 属性を利用してタブインタフェースのコンポーネントを切り替えることができます:

{% codeblock lang:html %}
<component v-bind:is="currentTabComponent"></component>
{% endcodeblock %}

しかし、コンポーネントを切り替える時、コンポーネントの状態を保持したり、パフォーマンスの理由から再レンダリングを避けたいときもあるでしょう。例えば、タブインターフェースを少し拡張した場合:

{% raw %}
<div id="dynamic-component-demo" class="demo">
  <button
    v-for="tab in tabs"
    v-bind:key="tab"
    v-bind:class="['dynamic-component-demo-tab-button', { 'dynamic-component-demo-active': currentTab === tab }]"
    v-on:click="currentTab = tab"
  >{{ tab }}</button>
  <component
    v-bind:is="currentTabComponent"
    class="dynamic-component-demo-tab"
  ></component>
</div>
<script>
Vue.component('tab-posts', {
  data: function () {
    return {
      posts: [
        {
          id: 1,
          title: 'Cat Ipsum',
          content: '<p>Dont wait for the storm to pass, dance in the rain kick up litter decide to want nothing to do with my owner today demand to be let outside at once, and expect owner to wait for me as i think about it cat cat moo moo lick ears lick paws so make meme, make cute face but lick the other cats. Kitty poochy chase imaginary bugs, but stand in front of the computer screen. Sweet beast cat dog hate mouse eat string barf pillow no baths hate everything stare at guinea pigs. My left donut is missing, as is my right loved it, hated it, loved it, hated it scoot butt on the rug cat not kitten around</p>'
        },
        {
          id: 2,
          title: 'Hipster Ipsum',
          content: '<p>Bushwick blue bottle scenester helvetica ugh, meh four loko. Put a bird on it lumbersexual franzen shabby chic, street art knausgaard trust fund shaman scenester live-edge mixtape taxidermy viral yuccie succulents. Keytar poke bicycle rights, crucifix street art neutra air plant PBR&B hoodie plaid venmo. Tilde swag art party fanny pack vinyl letterpress venmo jean shorts offal mumblecore. Vice blog gentrify mlkshk tattooed occupy snackwave, hoodie craft beer next level migas 8-bit chartreuse. Trust fund food truck drinking vinegar gochujang.</p>'
        },
        {
          id: 3,
          title: 'Cupcake Ipsum',
          content: '<p>Icing dessert soufflé lollipop chocolate bar sweet tart cake chupa chups. Soufflé marzipan jelly beans croissant toffee marzipan cupcake icing fruitcake. Muffin cake pudding soufflé wafer jelly bear claw sesame snaps marshmallow. Marzipan soufflé croissant lemon drops gingerbread sugar plum lemon drops apple pie gummies. Sweet roll donut oat cake toffee cake. Liquorice candy macaroon toffee cookie marzipan.</p>'
        }
      ],
      selectedPost: null
    }
  },
  template: '\
    <div class="dynamic-component-demo-posts-tab">\
      <ul class="dynamic-component-demo-posts-sidebar">\
        <li\
          v-for="post in posts"\
          v-bind:key="post.id"\
          v-bind:class="{ \'dynamic-component-demo-active\': post === selectedPost }"\
          v-on:click="selectedPost = post"\
        >\
          {{ post.title }}\
        </li>\
      </ul>\
      <div class="dynamic-component-demo-post-container">\
        <div \
          v-if="selectedPost"\
          class="dynamic-component-demo-post"\
        >\
          <h3>{{ selectedPost.title }}</h3>\
          <div v-html="selectedPost.content"></div>\
        </div>\
        <strong v-else>\
          Click on a blog title to the left to view it.\
        </strong>\
      </div>\
    </div>\
  '
})
Vue.component('tab-archive', {
  template: '<div>Archive component</div>'
})
new Vue({
  el: '#dynamic-component-demo',
  data: {
    currentTab: 'Posts',
    tabs: ['Posts', 'Archive']
  },
  computed: {
    currentTabComponent: function () {
      return 'tab-' + this.currentTab.toLowerCase()
    }
  }
})
</script>
<style>
.dynamic-component-demo-tab-button {
  padding: 6px 10px;
  border-top-left-radius: 3px;
  border-top-right-radius: 3px;
  border: 1px solid #ccc;
  cursor: pointer;
  background: #f0f0f0;
  margin-bottom: -1px;
  margin-right: -1px;
}
.dynamic-component-demo-tab-button:hover {
  background: #e0e0e0;
}
.dynamic-component-demo-tab-button.dynamic-component-demo-active {
  background: #e0e0e0;
}
.dynamic-component-demo-tab {
  border: 1px solid #ccc;
  padding: 10px;
}
.dynamic-component-demo-posts-tab {
  display: flex;
}
.dynamic-component-demo-posts-sidebar {
  max-width: 40vw;
  margin: 0 !important;
  padding: 0 10px 0 0 !important;
  list-style-type: none;
  border-right: 1px solid #ccc;
}
.dynamic-component-demo-posts-sidebar li {
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
  cursor: pointer;
}
.dynamic-component-demo-posts-sidebar li:hover {
  background: #eee;
}
.dynamic-component-demo-posts-sidebar li.dynamic-component-demo-active {
  background: lightblue;
}
.dynamic-component-demo-post-container {
  padding-left: 10px;
}
.dynamic-component-demo-post > :first-child {
  margin-top: 0 !important;
  padding-top: 0 !important;
}
</style>
{% endraw %}

投稿を選択し、 _Archive_ タブに切り替えてから _Posts_ に戻ると、選択していた投稿は表示されなくなります。 これは、新しいタブに切り替えるたびに、Vue が `currentTabComponent` の新しいインスタンスを作成するからです。

動的コンポーネントの再生成は通常は便利な挙動です。しかし、このケースでは最初に作成されたタブコンポーネントのインスタンスがキャッシュされるのが好ましいでしょう。この解決策として、動的コンポーネントを `<keep-alive>` 要素でラップすることができます:

``` html
<!-- インアクティブなコンポーネントはキャッシュされます! -->
<keep-alive>
  <component v-bind:is="currentTabComponent"></component>
</keep-alive>
```

以下のようになります:

{% raw %}
<div id="dynamic-component-keep-alive-demo" class="demo">
  <button
    v-for="tab in tabs"
    v-bind:key="tab"
    v-bind:class="['dynamic-component-demo-tab-button', { 'dynamic-component-demo-active': currentTab === tab }]"
    v-on:click="currentTab = tab"
  >{{ tab }}</button>
  <keep-alive>
    <component
      v-bind:is="currentTabComponent"
      class="dynamic-component-demo-tab"
    ></component>
  </keep-alive>
</div>
<script>
new Vue({
  el: '#dynamic-component-keep-alive-demo',
  data: {
    currentTab: 'Posts',
    tabs: ['Posts', 'Archive']
  },
  computed: {
    currentTabComponent: function () {
      return 'tab-' + this.currentTab.toLowerCase()
    }
  }
})
</script>
{% endraw %}

このように _Posts_ タブがレンダリングされていなくても、自身の状態(選択された投稿)を保持するようになります。完全なコードは [この例](https://codesandbox.io/s/github/vuejs/vuejs.org/tree/master/src/v2/examples/vue-20-keep-alive-with-dynamic-components) を参照してください。

<p class="tip">`<keep-alive>` にラップされるコンポーネントは、全て `name` を持つ必要があります。 コンポーネントの `name` オプションを使うか、ローカル/グローバル登録を使用してください。</p>

`<keep-alive>` の詳細な情報については [API リファレンス](../api/#keep-alive) を参照してください。

## 非同期コンポーネント

<div class="vueschool"><a href="https://vueschool.io/lessons/dynamically-load-components?friend=vuejs" target="_blank" rel="sponsored noopener" title="Free Vue.js Async Components lesson">Vue School で無料の動画レッスンを見る</a></div>

大規模なアプリケーションでは、アプリケーションを小さなまとまりに分割し、必要なコンポーネントだけサーバからロードしたい場合があるでしょう。Vue では、コンポーネント定義を非同期で解決するファクトリ関数としてコンポーネントを定義することができます。Vue は、コンポーネントをレンダリングする必要がある場合にのみファクトリ関数をトリガし、将来の再レンダリングのために結果をキャッシュします。例えば:

``` js
Vue.component('async-example', function (resolve, reject) {
  setTimeout(function () {
    // resolve コールバックにコンポーネント定義を渡します
    resolve({
      template: '<div>I am async!</div>'
    })
  }, 1000)
})
```

見ての通り、ファクトリ関数は、コンポーネント定義をサーバから取得したときに呼び出す必要がある `resolve` コールバックを受け取ります。 ここでの `setTimeout` はデモのためです。 コンポーネントの取得方法はあなた次第です。1つの推奨される方法は、 非同期コンポーネントと [Webpack の code-splitting の機能](https://webpack.js.org/guides/code-splitting/) を使用することです:

``` js
Vue.component('async-webpack-example', function (resolve) {
  // この特別な require 構文は、ビルドされたコードを
  // 自動的に Ajax リクエストを介してロードされるバンドルに分割するよう Webpack に指示します
  require(['./my-async-component'], resolve)
})
```

ファクトリ関数で `Promise` を返すこともできるので、Webpack 2 と ES2015 の構文では以下のように書けます:

``` js
Vue.component(
  'async-webpack-example',
  // `import` 関数は Promise を返します。
  () => import('./my-async-component')
)
```


[ローカル登録](components-registration.html#ローカル登録) を使っている場合、`Promise` を返す関数を直接与えることもできます:

``` js
new Vue({
  // ...
  components: {
    'my-component': () => import('./my-async-component')
  }
})
```

<p class="tip">もしあなたが <strong>Browserify</strong> ユーザで非同期コンポーネントを利用したいとしても、残念なことに作者は「非同期読み込みはBrowserifyがサポートするものではない」ことを[明らかにしました](https://github.com/substack/node-browserify/issues/58#issuecomment-21978224)、少なくとも公式では。Browserify のコミュニティーは既存の複雑なアプリケーションの役に立ちうる [回避策](https://github.com/vuejs/vuejs.org/issues/620) を見つけました。その他の全ての場合、私たちはビルトインでファーストクラスの非同期サポートを理由に Webpack の利用を推奨します。</p>

### ロード状態のハンドリング

> 2.3.0 から新規

非同期コンポーネントのファクトリ関数は以下のような形のオブジェクトを返すこともできます:

``` js
const AsyncComponent = () => ({
  // ロードすべきコンポーネント (Promiseであるべき)
  component: import('./MyComponent.vue'),
  // 非同期コンポーネントのロード中に使うコンポーネント
  loading: LoadingComponent,
  // ロード失敗時に使うコンポーネント
  error: ErrorComponent,
  // loading コンポーネントが表示されるまでの遅延時間。 デフォルト: 200ms
  delay: 200,
  // timeout が設定され経過すると、error コンポーネントが表示されます。
  // デフォルト: Infinity
  timeout: 3000
})
```

> 上記の記法をルートコンポーネントに使用する場合、2.4.0 以上の [Vue Router](https://github.com/vuejs/vue-router) を使用しなければならないことに注意してください。
