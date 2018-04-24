---
title: CMS によるブログの作成
type: cookbook
updated: 2018-03-20
order: 5
---

あなたが Vue.js のウェブサイトを新しく立ち上げたとしましょう。おめでとうございます！いま、あなたは自分のウェブサイトに早くブログを追加したいでしょうが、1つの WordPress のインスタンス（また、さらに言えば DB の動作する CMS）だけをホスティングするためにサーバ全体をスピンアップさせたくはないでしょう。少しの Vue.js のブログのコンポーネントといくつかのルーティングを追加でき、1つの サーバにすべてを適切に持たせられるようにしたいですよね？あなたが探しているのは、Vue.js アプリケーションから直接処理できる API によって完全に制御されたブログです。このチュートリアルは、どうやってそれを適切に行うか、教えます。詳しく見ていきましょう！

私たちは、Vue.js で CMS によるブログを素早くつくっていきます。これには、[ButterCMS](https://buttercms.com/) を使います。これは、ButterCMS ダッシュボードでコンテンツを管理し、コンテンツ API を Vue.js アプリケーションに統合させる API ファーストな CMS です。新しく、または既にある Vue.js のプロジェクトのために、ButterCMS を使えます。
 
![Butter Dashboard](https://user-images.githubusercontent.com/160873/36677285-648798e4-1ad3-11e8-9454-d22fca8280b7.png "Butter Dashboard")

## インストール

コマンドラインで以下を実行してください:

`npm install buttercms --save`

Butter は、CDN からも読み込めます: 

`<script src="https://cdnjs.buttercms.com/buttercms-1.1.0.min.js"></script>`

## クイックスタート

API トークンの設定:

`var butter = require('buttercms')('your_api_token');`

ES6 の使用:

```javascript
import Butter from 'buttercms';
const butter = Butter('your_api_token');
```

CDN の使用: 

```html
<script src="https://cdnjs.buttercms.com/buttercms-1.1.0.min.js"></script>
<script>
  var butter = Butter('your_api_token');
</script>
```
 
このファイルを ButterCMS を使いたいコンポーネントでインポートし、コンソールで以下を実行します:

```javascript
butter.post.list({page: 1, page_size: 10}).then(function(response) {
  console.log(response)
})
```

この API リクエストは、ブログの投稿を取得します。あなたのアカウントには、1つの投稿例が付属していて、レスポンス内で見ることができるでしょう。

## 投稿の表示

投稿を表示するには、アプリケーションで、`/blog` ルーティング (Vue Router を使用) を作成し、Butter API でブログの投稿を取得します。`/blog/:slug` ルーティングが同様に各々の投稿をハンドルします。 

カテゴリ、または著者によるフィルタリングのような追加オプションは、ButterCMS [API リファレンス](https://buttercms.com/docs/api/?javascript#blog-posts) を参照してください。 レスポンスは、ページネーションのために使用するいくつかのメタデータも含みます。

`router/index.js:`

```javascript
import Vue from 'vue'
import Router from 'vue-router'
import BlogHome from '@/components/BlogHome'
import BlogPost from '@/components/BlogPost'

Vue.use(Router)

export default new Router({
  mode: 'history',
  routes: [
    {
      path: '/blog/',
      name: 'blog-home',
      component: BlogHome
    },
    {
      path: '/blog/:slug',
      name: 'blog-post',
      component: BlogPost
    }
  ]
})
```

次に、直近の投稿を並べるブログのホームページを `components/BlogHome.vue` で作成します。 

```html
<script>
  import { butter } from '@/buttercms'
  export default {
    name: 'blog-home',
    data() {
      return {
        page_title: 'Blog',
        posts: []
      }
    },
    methods: {
      getPosts() {
        butter.post.list({
          page: 1,
          page_size: 10
        }).then((res) => {
          this.posts = res.data.data
        })
      }
    },
    created() {
      this.getPosts()
    }
  }
</script>

<template>
  <div id="blog-home">
      <h1>{{ page_title }}</h1>
      <!-- `v-for` の生成、および Vue 用に `key` 属性の適用。ここでは、slug と index の組みを使用します -->
      <div v-for="(post,index) in posts" :key="post.slug + '_' + index">
        <router-link :to="'/blog/' + post.slug">
          <article class="media">
            <figure>
              <!-- `:` による結果のバインディング -->
              <!-- `featured_image` を使うかどうかは、`v-if`/`else` で判定します -->
              <img v-if="post.featured_image" :src="post.featured_image" alt="">
              <img v-else src="http://via.placeholder.com/250x250" alt="">
            </figure>
            <h2>{{ post.title }}</h2>
            <p>{{ post.summary }}</p>
          </article>
        </router-link>
      </div>
  </div>
</template>
```

これは以下のようになります（注釈：速くスタイリングするために、https://bulma.io/ の CSS フレームワークを追加しています）:

![buttercms-bloglist](https://user-images.githubusercontent.com/160873/36868500-1b22e374-1d5e-11e8-82a0-20c8dc312716.png)

以下では、ブログの記事ページを個別投稿のリストにする `components/BlogPost.vue` を生成しています。

```html
<script>
  import { butter } from '@/buttercms'
  export default {
    name: 'blog-post',
    data() {
      return {
        post: {}
      }
    },
    methods: {
      getPost() {
        butter.post.retrieve(this.$route.params.slug)
          .then((res) => {
            this.post = res.data
          }).catch((res) => {
            console.log(res)
          })
      }
    },
    created() {
      this.getPost()
    }
  }
</script>

<template>
  <div id="blog-post">
    <h1>{{ post.data.title }}</h1>
    <h4>{{ post.data.author.first_name }} {{ post.data.author.last_name }}</h4>
    <div v-html="post.data.body"></div>

    <router-link v-if="post.meta.previous_post" :to="/blog/ + post.meta.previous_post.slug" class="button">
      {{ post.meta.previous_post.title }}
    </router-link>
    <router-link v-if="post.meta.next_post" :to="/blog/ + post.meta.next_post.slug" class="button">
      {{ post.meta.next_post.title }}
    </router-link>
  </div>
</template>
```

以下がプレビューです:

![buttercms-blogdetail](https://user-images.githubusercontent.com/160873/36868506-218c86b6-1d5e-11e8-8691-0409d91366d6.png)

いま、アプリケーションはすべてのブログの記事を取得し、各々の投稿ページへ遷移できます。しかし、次/前の投稿へのボタンは動作していません。

ルーティングをパラメータと一緒に使用する際にもう1つ注意すべきなのは、ユーザが `/blog/foo` から `/blog/bar` へ遷移するとき、同じコンポーネントのインスタンスが再利用される点です。各々のルーティングが同じコンポーネントを描画するため、古いインスタンスの破棄と新しいインスタンスの生成をするより、効率的です。

<p class="tip">注意してください。この方法でコンポーネントが使われるということは、コンポーネントのライフサイクルによるフックが呼ばれないことを意味します。より詳しくは、Vue Router のドキュメントを参照してください。
[動的ルートマッチング](https://router.vuejs.org/ja/essentials/dynamic-matching.html)</p>

これを修正するために、私たちは `$route` オブジェクトを監視し、ルーティングが変わるときに、`getPost()` を呼ぶ必要があります。

`components/BlogPost.vue` 内の `<script>` を以下のように更新します:

```html
<script>
  import { butter } from '@/buttercms'
  export default {
    name: 'blog-post',
    data() {
      return {
        post: {}
      }
    },
    methods: {
      getPost() {
        butter.post.retrieve(this.$route.params.slug)
          .then((res) => {
            // console.log(res.data)
            this.post = res.data
          }).catch((res) => {
            console.log(res)
          })
      }
    },
    watch: {
      $route(to, from) {
        this.getPost()
      }
    },
    created() {
      this.getPost()
    }
  }
</script>
```

これで、あなたのアプリケーションは、ButterCMS ダッシュボード内で、簡単に更新できるブログを手に入れました。

## カテゴリー、タグ、および著者

ブログ上で、コンテンツをカテゴリー、タグ、および著者で特徴づける、あるいはフィルタリングするために、Butter の API を使用します。

これらのオブジェクトについて、より情報を得るには、ButterCMS の API リファレンスを参照してください。

* [Categories](https://buttercms.com/docs/api/?ruby#categories)
* [Tags](https://buttercms.com/docs/api/?ruby#tags)
* [Authors](https://buttercms.com/docs/api/?ruby#authors)

以下は、すべてのカテゴリーと、カテゴリーによる投稿を取得する例です。これらの関数は、`created()` のライフサイクルフックで呼び出してください。

```javascript
methods: {
  ...
  getCategories() {
    butter.category.list()
      .then((res) => {
        console.log('List of Categories:')
        console.log(res.data.data)
      })
  },
  getPostsByCategory() {
    butter.category.retrieve('example-category', {
        include: 'recent_posts'
      })
      .then((res) => {
        console.log('Posts with specific category:')
        console.log(res)
      })
  }
},
created() {
  ...
  this.getCategories()
  this.getPostsByCategory()
}
```

## 代替パターン

もし、あなたがマークダウンでのみの記述を好むなら、特に代替パターンとして考えられるのは、[Nuxtent](https://nuxtent.now.sh/guide/writing#async-components) のようなものを使う方法です。Nuxtent は、マークダウン形式のファイルの代わりに、`Vue Component` の利用を提供します。 このアプローチは、マークダウン形式のファイルでブログの投稿が構成される静的サイト（すなわち、Jekyll）のアプローチと類似するでしょう。Nuxtent は、Vue.js の世界で Vue.js とマークダウンの間で生きるための良いインテグレーションを追加します。


## まとめ

以上です！あなたはいま、アプリケーション上で動作する完全な機能を持った CMS によるブログを手に入れました。私たちは、このチュートリアルが役に立ち、Vue.js の開発経験がより一層楽しくなることを願っています。:)
