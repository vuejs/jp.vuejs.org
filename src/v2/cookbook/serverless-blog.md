---
title: CMS による Blog の作成
type: cookbook
updated: 2018-03-20
order: 5
---

> ⚠️注意: この内容は原文のままです。現在翻訳中ですのでお待ち下さい。🙏

あなたが Vue.js のウェブサイトをちょうど立ち上げたばかりならば、おめでとうございます！いま、あなたは自分のウェブサイトに早くブログを追加したいが、１つの Wordpress のインスタンス（また、さらに言えば DB の動作する CMS）だけをホスティングするためにサーバ全体をスピンアップさせたくはないでしょう。あなたは、少しの Vue.js のブログ構成要素といくつかのルーティングを追加でき、１つの サーバにすべてを適切に持たせられるようにしたいですよね？あなたが探しているのは、あなたの Vue.js アプリケーションから直接処理できる API によって完全に制御されたブログです。このチュートリアルは、あなたにどうやってそれを適切に行うか、教えるでしょう。飛び込みましょう！

私たちは、Vue.js で CMS によるブログを素早くつくるつもりです。これに、[ButterCMS](https://buttercms.com/) を使います。これは、あなたに、ButterCMS ダッシュボードでコンテンツを管理させ、 コンテンツをあなたの Vue.js アプリケーションに API で統合させる API first な CMS です。あなたは、新しく、またはすでにある Vue.js のプロジェクトのために、ButterCMS を使えます。
 
![Butter Dashboard](https://user-images.githubusercontent.com/160873/36677285-648798e4-1ad3-11e8-9454-d22fca8280b7.png "Butter Dashboard")

## インストール

コマンドラインで以下を実行してください。:

`npm install buttercms --save`

Butter は、CDN からも読み込めます。: 

`<script src="https://cdnjs.buttercms.com/buttercms-1.1.0.min.js"></script>`

## クイックスタート

あなたの API token を設定します。:

`var butter = require('buttercms')('your_api_token');`

ES6 を使用する場合:

```javascript
import Butter from 'buttercms';
const butter = Butter('your_api_token');
```

CDN を使用する場合: 

```html
<script src="https://cdnjs.buttercms.com/buttercms-1.1.0.min.js"></script>
<script>
  var butter = Butter('your_api_token');
</script>
```
 
このファイルを ButterCMS を使いたいコンポネントでインポートし、コンソールで以下を実行します。:

```javascript
butter.post.list({page: 1, page_size: 10}).then(function(response) {
  console.log(response)
})
```

この API リクエストは、あなたのブログの投稿をフェッチします。あなたのアカウントは、レスポンスから１つの投稿例とセットで取得します。

## 投稿の表示

投稿を表示するには、アプリケーションで、`/blog` ルーティングを (Vue Router を使用) 作成し、Butter API でブログの投稿をフェッチします。`/blog/:slug` ルーティングが同様に各々の投稿をハンドルします。 

See the ButterCMS [API reference](https://buttercms.com/docs/api/?javascript#blog-posts) for additional options such as filtering by category or author. The response also includes some metadata we'll use for pagination.

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

それから、あなたの最も最近の投稿を並べるブログのホームページを `components/BlogHome.vue` で作成します。 

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
      <!-- Create `v-for` and apply a `key` for Vue. Here we are using a combination of the slug and index. -->
      <div v-for="(post,index) in posts" :key="post.slug + '_' + index">
        <router-link :to="'/blog/' + post.slug">
          <article class="media">
            <figure>
              <!-- Bind results using a `:` -->
              <!-- Use a `v-if`/`else` if their is a `featured_image` -->
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

Here's what it looks like (note we added CSS from https://bulma.io/ for quick styling):

![buttercms-bloglist](https://user-images.githubusercontent.com/160873/36868500-1b22e374-1d5e-11e8-82a0-20c8dc312716.png)

Now create `components/BlogPost.vue` which will be your Blog Post page to list a single post.

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

Here's a preview:

![buttercms-blogdetail](https://user-images.githubusercontent.com/160873/36868506-218c86b6-1d5e-11e8-8691-0409d91366d6.png)

Now our app is pulling all blog posts and we can navigate to individual posts. However, our next/previous post buttons are not working.

One thing to note when using routes with params is that when the user navigates from `/blog/foo` to `/blog/bar`, the same component instance will be reused. Since both routes render the same component, this is more efficient than destroying the old instance and then creating a new one. 

<p class="tip">Be aware, that using the component this way will mean that the lifecycle hooks of the component will not be called. Visit the Vue Router's docs to learn more about [Dynamic Route Matching](https://router.vuejs.org/en/essentials/dynamic-matching.html)</p>

To fix this we need to watch the `$route` object and call `getPost()` when the route changes.

Updated `<script>` section in `components/BlogPost.vue`:

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

Now your app has a working blog that can be updated easily in the ButterCMS dashboard.

## Categories, Tags, and Authors

Use Butter's APIs for categories, tags, and authors to feature and filter content on your blog.

See the ButterCMS API reference for more information about these objects:

* [Categories](https://buttercms.com/docs/api/?ruby#categories)
* [Tags](https://buttercms.com/docs/api/?ruby#tags)
* [Authors](https://buttercms.com/docs/api/?ruby#authors)

Here's an example of listing all categories and getting posts by category. Call these methods on the `created()` lifecycle hook:

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

## Alternative Patterns

An alternative pattern to consider, especially if you prefer writing only in Markdown, is using something like [Nuxtent](https://nuxtent.now.sh/guide/writing#async-components). Nuxtent allows you to use `Vue Component` inside of Markdown files. This approach would be akin to a static site approach (i.e. Jekyll) where you compose your blog posts in Markdown files. Nuxtent adds a nice integration between Vue.js and Markdown allowing you to live in a 100% Vue.js world.

## Wrap up

That's it! You now have a fully functional CMS-powered blog running in your app. We hope this tutorial was helpful and made your development experience with Vue.js even more enjoyable :)
