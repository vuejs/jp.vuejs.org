---
title: コンポーネントの基本
updated: 2019-07-22
type: guide
order: 11
---

<div class="vueschool"><a href="https://vueschool.io/courses/vuejs-components-fundamentals?friend=vuejs" target="_blank" rel="sponsored noopener" title="Free Vue.js Components Fundamentals Course">Vue School で無料の動画レッスンを見る</a></div>

## 基本例

Vue コンポーネントの例を次に示します:

``` js
// button-counter と呼ばれる新しいコンポーネントを定義します
Vue.component('button-counter', {
  data: function () {
    return {
      count: 0
    }
  },
  template: '<button v-on:click="count++">You clicked me {{ count }} times.</button>'
})
```

コンポーネントは名前付きの再利用可能な Vue インスタンスです。この例の場合、`<button-counter>`です。このコンポーネントを `new Vue` で作成されたルート Vue インスタンス内でカスタム要素として使用することができます。

```html
<div id="components-demo">
  <button-counter></button-counter>
</div>
```

{% codeblock lang:js %}
new Vue({ el: '#components-demo' })
{% endcodeblock %}

{% raw %}
<div id="components-demo" class="demo">
  <button-counter></button-counter>
</div>
<script>
Vue.component('button-counter', {
  data: function () {
    return {
      count: 0
    }
  },
  template: '<button v-on:click="count += 1">You clicked me {{ count }} times.</button>'
})
new Vue({ el: '#components-demo' })
</script>
{% endraw %}

コンポーネントは再利用可能な Vue インスタンスなので、`data`、`computed`、`watch`、`methods`、ライフサイクルフックなどの `new Vue` と同じオプションを受け入れます。唯一の例外は `el` のようなルート固有のオプションです。

## コンポーネントの再利用

コンポーネントは必要なだけ何度でも再利用できます:

```html
<div id="components-demo">
  <button-counter></button-counter>
  <button-counter></button-counter>
  <button-counter></button-counter>
</div>
```

{% raw %}
<div id="components-demo2" class="demo">
  <button-counter></button-counter>
  <button-counter></button-counter>
  <button-counter></button-counter>
</div>
<script>
new Vue({ el: '#components-demo2' })
</script>
{% endraw %}

ボタンをクリックすると、それぞれが独自の `count` を保持することに注意してください。これはコンポーネントを使用するたびに、新しい**インスタンス**が作成されるためです。

### `data` は関数でなければなりません

`<button-counter>`コンポーネントを定義したとき、`data` が直接オブジェクトとして提供されていなかったことに気づいたかもしれません:

```js
data: {
  count: 0
}
```

代わりに、**コンポーネントの `data` オプションは関数でなければなりません**。各インスタンスが返されるデータオブジェクトの独立したコピーを保持できるためです:

```js
data: function () {
  return {
    count: 0
  }
}
```

Vue にこのルールがない場合、ボタンを1つクリックすると、以下のように_すべての他のインスタンスの_データに影響します:

{% raw %}
<div id="components-demo3" class="demo">
  <button-counter2></button-counter2>
  <button-counter2></button-counter2>
  <button-counter2></button-counter2>
</div>
<script>
var buttonCounter2Data = {
  count: 0
}
Vue.component('button-counter2', {
  data: function () {
    return buttonCounter2Data
  },
  template: '<button v-on:click="count++">You clicked me {{ count }} times.</button>'
})
new Vue({ el: '#components-demo3' })
</script>
{% endraw %}

## コンポーネントの編成

アプリケーションがネストされたコンポーネントのツリーに編成されるのは一般的です:

![Component Tree](/images/components.png)

例えば、ヘッダー、サイドバー、およびコンテンツ領域のコンポーネントがあり、それぞれには一般的にナビゲーションリンク、ブログ投稿などの他のコンポーネントが含まれています。

これらのコンポーネントをテンプレートで使用するには、Vue がそれらを認識できるように登録する必要があります。コンポーネント登録には、**グローバル**と**ローカル**の2種類があります。これまでは、`Vue.component` を使用してコンポーネントをグローバルに登録していただけです:

```js
Vue.component('my-component-name', {
  // ... オプション ...
})
```

グローバルに登録されたコンポーネントは、その後に作成されたルート Vue インスタンス(`new Vue`)のテンプレートで使用できます。さらに、その Vue インスタンスのコンポーネントツリーのすべてのサブコンポーネント内でも使用できます。

今のところコンポーネント登録について知っておくべきことはこれですべてですが、このページを読んで内容が分かり次第、[コンポーネント登録](components-registration.html)の全ガイドを読むことをお勧めします。

## プロパティを使用した子コンポーネントへのデータの受け渡し

先程、ブログ投稿用のコンポーネントの作成についてふれました。問題は、表示する特定の投稿のタイトルやコンテンツなどのデータをコンポーネントに渡すことができない限り、そのコンポーネントは役に立たないということです。プロパティはここで役立ちます。

プロパティはコンポーネントに登録できるカスタム属性です。値がプロパティ属性に渡されると、そのコンポーネントインスタンスのプロパティになります。ブログ投稿コンポーネントにタイトルを渡すには、`props` オプションを使用して、このコンポーネントが受け入れるプロパティのリストにそれを含めることができます:

```js
Vue.component('blog-post', {
  props: ['title'],
  template: '<h3>{{ title }}</h3>'
})
```

コンポーネントは必要に応じて多くのプロパティを持つことができます。デフォルトでは、任意の値を任意のプロパティに渡すことができます。上記のテンプレートでは、`data` と同様に、コンポーネントインスタンスでこの値にアクセスできることがわかります。

プロパティが登録されると、次のようにそれをカスタム属性としてデータを渡すことができます:

```html
<blog-post title="My journey with Vue"></blog-post>
<blog-post title="Blogging with Vue"></blog-post>
<blog-post title="Why Vue is so fun"></blog-post>
```

{% raw %}
<div id="blog-post-demo" class="demo">
  <blog-post1 title="My journey with Vue"></blog-post1>
  <blog-post1 title="Blogging with Vue"></blog-post1>
  <blog-post1 title="Why Vue is so fun"></blog-post1>
</div>
<script>
Vue.component('blog-post1', {
  props: ['title'],
  template: '<h3>{{ title }}</h3>'
})
new Vue({ el: '#blog-post-demo' })
</script>
{% endraw %}

しかしながら、普通のアプリケーションでは、おそらく `data` に投稿の配列があります:

```js
new Vue({
  el: '#blog-post-demo',
  data: {
    posts: [
      { id: 1, title: 'My journey with Vue' },
      { id: 2, title: 'Blogging with Vue' },
      { id: 3, title: 'Why Vue is so fun' }
    ]
  }
})
```

それぞれの投稿ごとにコンポーネントを描画します:

```html
<blog-post
  v-for="post in posts"
  v-bind:key="post.id"
  v-bind:title="post.title"
></blog-post>
```

上記では、`v-bind` を使って動的にプロパティを渡すことができることがわかります。これは、[API から投稿を取得する](https://jsfiddle.net/chrisvfritz/sbLgr0ad)ときのように、前もって描画する正確なコンテンツがわからない場合に特に便利です。

これがプロパティについて今のところ知っておくべきことですが、このページを読んで内容が分かり次第、後で[プロパティ](components-props.html)の全ガイドを読むことをお勧めします。

## 単一のルート要素

`<blog-post>`コンポーネントを構築するとき、テンプレートには最終的にタイトル以上のものが含まれます:

```html
<h3>{{ title }}</h3>
```

最低でも、投稿の内容を含めたいでしょう:

```html
<h3>{{ title }}</h3>
<div v-html="content"></div>
```

テンプレートで試してみると、Vue は**すべてのコンポーネントに単一のルート要素**が必要ということを示すエラーを表示します。このエラーは、次のようにテンプレートを親要素でラップすることで修正できます:

```html
<div class="blog-post">
  <h3>{{ title }}</h3>
  <div v-html="content"></div>
</div>
```

コンポーネントが大きくなると、タイトルや投稿内容だけでなく、公開日やコメントなども必要になってくるかもしれません。しかし、それぞれの情報ごとにプロパティを定義してしまうと、とてもうるさいものになります:

```html
<blog-post
  v-for="post in posts"
  v-bind:key="post.id"
  v-bind:title="post.title"
  v-bind:content="post.content"
  v-bind:publishedAt="post.publishedAt"
  v-bind:comments="post.comments"
></blog-post>
```

そうなったら、`<blog-post>` コンポーネントをリファクタする好機かもしれません。代わりに、単一の `post` プロパティを受け入れる形にするのです:

```html
<blog-post
  v-for="post in posts"
  v-bind:key="post.id"
  v-bind:post="post"
></blog-post>
```

```js
Vue.component('blog-post', {
  props: ['post'],
  template: `
    <div class="blog-post">
      <h3>{{ post.title }}</h3>
      <div v-html="post.content"></div>
    </div>
  `
})
```

<p class="tip">上記の例や後に出てくる例では、JavaScript の[テンプレート文字列](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/template_strings)を使用して、複数行にわたるテンプレートをより読みやすくします。これらはインターネットエクスプローラー(IE)ではサポートされていないので、IE をサポートして、かつトランスパイル(例: Babel もしくは TypeScript を使用した)を行わない場合、代わりに[改行エスケープ](https://css-tricks.com/snippets/javascript/multiline-string-variables-in-javascript/)を使用してください。</p>

これで、新しいプロパティが `post` オブジェクトに追加される際にはいつでも、`<blog-post>` 内で自動的に利用可能になるのです。

## 子コンポーネントのイベントを購読する

`<blog-post>` コンポーネントを開発する際、親コンポーネントとやり取りする機能が必要になるかもしれません。例えば、ブログの投稿のテキストを拡大するためのアクセシビリティ機能を追加し、他のページのデフォルトのサイズにすることができます。

親コンポーネントでは、`postFontSize` データプロパティを追加することでこの機能をサポートすることができます:

```js
new Vue({
  el: '#blog-posts-events-demo',
  data: {
    posts: [/* ... */],
    postFontSize: 1
  }
})
```

すべてのブログ投稿のフォントサイズを制御するためにテンプレート内で使用できます:

```html
<div id="blog-posts-events-demo">
  <div :style="{ fontSize: postFontSize + 'em' }">
    <blog-post
      v-for="post in posts"
      v-bind:key="post.id"
      v-bind:post="post"
    ></blog-post>
  </div>
</div>
```

それでは、すべての投稿の内容の前にテキストを拡大するボタンを追加します:

```js
Vue.component('blog-post', {
  props: ['post'],
  template: `
    <div class="blog-post">
      <h3>{{ post.title }}</h3>
      <button>
        Enlarge text
      </button>
      <div v-html="post.content"></div>
    </div>
  `
})
```

問題は、このボタンがなにもしないことです:

```html
<button>
  Enlarge text
</button>
```

ボタンをクリックすると、すべての投稿のテキストを拡大する必要があることを親コンポーネントに伝える必要があります。幸いにも、Vue インスタンスはこの問題を解決するカスタムイベントシステムを提供しています。親コンポーネントは、ネイティブの DOM イベントと同じように、`v-on` を使って子コンポーネントで起きた任意のイベントを購読することができます:

```html
<blog-post
  ...
  v-on:enlarge-text="postFontSize += 0.1"
></blog-post>
```

そして、子コンポーネントでは、ビルトインの [**`$emit`** メソッド](../api/#インスタンスメソッド-イベント) にイベントの名前を渡して呼び出すことで、イベントを送出することができます:

```html
<button v-on:click="$emit('enlarge-text')">
  Enlarge text
</button>
```

親コンポーネントは、`v-on:enlarge-text="postFontSize += 0.1"` リスナのおかげで、このイベントを受け取って `postFontSize` の値を更新することができます。

{% raw %}
<div id="blog-posts-events-demo" class="demo">
  <div :style="{ fontSize: postFontSize + 'em' }">
    <blog-post
      v-for="post in posts"
      v-bind:key="post.id"
      v-bind:post="post"
      v-on:enlarge-text="postFontSize += 0.1"
    ></blog-post>
  </div>
</div>
<script>
Vue.component('blog-post', {
  props: ['post'],
  template: '\
    <div class="blog-post">\
      <h3>{{ post.title }}</h3>\
      <button v-on:click="$emit(\'enlarge-text\')">\
        Enlarge text\
      </button>\
      <div v-html="post.content"></div>\
    </div>\
  '
})
new Vue({
  el: '#blog-posts-events-demo',
  data: {
    posts: [
      { id: 1, title: 'My journey with Vue', content: '...content...' },
      { id: 2, title: 'Blogging with Vue', content: '...content...' },
      { id: 3, title: 'Why Vue is so fun', content: '...content...' }
    ],
    postFontSize: 1
  }
})
</script>
{% endraw %}

### イベントと値を送出する

イベントを特定の値付きで送出すると便利なことがあります。例えば、`<blog-post>` コンポーネントにテキストをどれだけ拡大するかを責務とさせたいかもしれません。そのような場合、`$emit` の2番目のパラメータを使ってこの値を提供することができます:

```html
<button v-on:click="$emit('enlarge-text', 0.1)">
  Enlarge text
</button>
```

親コンポーネントでイベントをリッスンすると、送出されたイベントの値に `$event` でアクセスできます:

```html
<blog-post
  ...
  v-on:enlarge-text="postFontSize += $event"
></blog-post>
```

または、イベントハンドラがメソッドの場合:

```html
<blog-post
  ...
  v-on:enlarge-text="onEnlargeText"
></blog-post>
```

値は、そのメソッドの最初のパラメータとして渡されます:

```js
methods: {
  onEnlargeText: function (enlargeAmount) {
    this.postFontSize += enlargeAmount
  }
}
```

### コンポーネントで `v-model` を使う

カスタムイベントは `v-model` で動作するカスタム入力を作成することもできます。このことを覚えておいてください:

```html
<input v-model="searchText">
```

これは以下と同じことです:

```html
<input
  v-bind:value="searchText"
  v-on:input="searchText = $event.target.value"
>
```

コンポーネントで使用する場合、`v-model` は代わりにこれを行います:

``` html
<custom-input
  v-bind:value="searchText"
  v-on:input="searchText = $event"
></custom-input>
```

これを実際に動作させるためには、コンポーネント内の `<input>` は以下でなければなりません:

- `value` 属性を `value` プロパティにバインドする
- `input` では、新しい値で独自のカスタム `input` イベントを送出します

こうなります:

```js
Vue.component('custom-input', {
  props: ['value'],
  template: `
    <input
      v-bind:value="value"
      v-on:input="$emit('input', $event.target.value)"
    >
  `
})
```

`v-model` はこのコンポーネントで完璧に動作するはずです:

```html
<custom-input v-model="searchText"></custom-input>
```

これがカスタムコンポーネントについて今のところ知っておくべきことですが、このページを読んで内容が分かり次第、後で[カスタムイベント](components-custom-events.html)の全ガイドを読むことをお勧めします。

## スロットによるコンテンツ配信

HTML 要素と同様に、コンポーネントにコンテンツを渡すことができると便利なことがよくあります。例えば以下です:

``` html
<alert-box>
  Something bad happened.
</alert-box>
```

これは以下のように描画されるでしょう:

{% raw %}
<div id="slots-demo" class="demo">
  <alert-box>
    Something bad happened.
  </alert-box>
</div>
<script>
Vue.component('alert-box', {
  template: '\
    <div class="demo-alert-box">\
      <strong>Error!</strong>\
      <slot></slot>\
    </div>\
  '
})
new Vue({ el: '#slots-demo' })
</script>
<style>
.demo-alert-box {
  padding: 10px 20px;
  background: #f3beb8;
  border: 1px solid #f09898;
}
</style>
{% endraw %}

幸いにも、この作業は Vue のカスタム `<slot>` 要素によって非常に簡単になります:

```js
Vue.component('alert-box', {
  template: `
    <div class="demo-alert-box">
      <strong>Error!</strong>
      <slot></slot>
    </div>
  `
})
```

上で見たように、ただ渡したいところにスロットを追加するだけです。それだけです。終わりです！

これがスロットについて今のところ知っておくべきことですが、このページを読んで内容が分かり次第、後で[スロット](components-slots.html)の全ガイドを読むことをお勧めします。

## 動的なコンポーネント

タブ付きのインターフェイスのように、コンポーネント間を動的に切り替えると便利なことがあります:

{% raw %}
<div id="dynamic-component-demo" class="demo">
  <button
    v-for="tab in tabs"
    v-bind:key="tab"
    class="dynamic-component-demo-tab-button"
    v-bind:class="{ 'dynamic-component-demo-tab-button-active': tab === currentTab }"
    v-on:click="currentTab = tab"
  >
    {{ tab }}
  </button>
  <component
    v-bind:is="currentTabComponent"
    class="dynamic-component-demo-tab"
  ></component>
</div>
<script>
Vue.component('tab-home', { template: '<div>Home component</div>' })
Vue.component('tab-posts', { template: '<div>Posts component</div>' })
Vue.component('tab-archive', { template: '<div>Archive component</div>' })
new Vue({
  el: '#dynamic-component-demo',
  data: {
    currentTab: 'Home',
    tabs: ['Home', 'Posts', 'Archive']
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
.dynamic-component-demo-tab-button-active {
  background: #e0e0e0;
}
.dynamic-component-demo-tab {
  border: 1px solid #ccc;
  padding: 10px;
}
</style>
{% endraw %}

上記は、Vue の `<component>` 要素と 特別な属性の `is` で可能になりました:

```html
<!-- currentTabComponent が変更されたとき、コンポーネントを変更します -->
<component v-bind:is="currentTabComponent"></component>
```

上記の例では、`currentTabComponent` は次のいずれかを含むことができます:

- 登録されたコンポーネントの名前、もしくは
- コンポーネントのオプションオブジェクト

完全なコードを試してみるには[この fiddle](https://jsfiddle.net/chrisvfritz/o3nycadu/)、もしくは登録された名前の代わりにコンポーネントのオプションオブジェクトをバインディングしている例となる[このバージョン](https://jsfiddle.net/chrisvfritz/b2qj69o1/)を参照してください。

Keep in mind that this attribute can be used with regular HTML elements, however they will be treated as components, which means all attributes **will be bound as DOM attributes**. For some properties such as `value` to work as you would expect, you will need to bind them using the [`.prop` modifier](../api/#v-bind).

これが動的なコンポーネントについて今のところ知っておくべきことですが、このページを読んで内容が分かり次第、後で [動的 & 非同期コンポーネント](components-dynamic-async.html)の全ガイドを読むことをお勧めします。

## DOM テンプレートパース時の警告

`<ul>`、`<ol>`、`<table>`、`<select>`のようないくつかの HTML 要素には、それらの要素の中でどの要素が現れるかに制限があり、 `<li>`、`<tr>`、`<option>` は他の特定の要素の中にしか現れません。

このような制限がある要素を持つコンポーネントを使用すると、問題が発生することがあります。例:

``` html
<table>
  <blog-post-row></blog-post-row>
</table>
```

カスタムコンポーネント `<blog-post-row>` は無効なコンテンツとしてつまみ出され、最終的に描画された出力にエラーが発生します。幸いにも、特別な属性の `is` は回避策を提供します:

``` html
<table>
  <tr is="blog-post-row"></tr>
</table>
```

**次のソースのいずれかの文字列テンプレートを使用している場合、この制限は適用され<em>ない</em>**ことに注意してください:

- 文字列テンプレート(例: `template： '...'`)
- [単一ファイル(`.vue`)コンポーネント](single-file-components.html)
- [`<script type="text/x-template">`](components-edge-cases.html#X-テンプレート)

これがDOM テンプレートパース時の警告について今のところ知っておくべきことです。そして、実際には Vue の <em>本質</em> の最後となります。おめでとうございます！まだまだ学ぶことはありますが、最初に Vue を自身で遊ぶために休憩をとり、何か面白いものを作ってみることをお勧めします。

理解したばかりの知識に慣れたら、[動的 & 非同期コンポーネント](components-dynamic-async.html)の全ガイドとサイドバーにある他のコンポーネントの詳細セクションを読むことをお勧めします。
