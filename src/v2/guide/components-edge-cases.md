---
title: 特別な問題に対処する
updated: 2020-02-25
type: guide
order: 106
---

> このページはすでに[コンポーネントの基本](components.html)を読んでいることを前提に書いています。もしまだ読んでいないのなら、先に読みましょう。

<p class="tip">特別な問題、つまり珍しい状況に対処するためのこのページの全ての機能は、時に Vue のルールを多少なりとも曲げることになります。しかし注意して欲しいのが、それらは全てデメリットや危険な状況をもたらし得るということです。これらのマイナス的な面はそれぞれのケースで注意されているので、このページで紹介されるそれぞれの機能を使用すると決めたときは心に止めておいてください。</p>

## 要素 & コンポーネントへのアクセス

ほとんどのケースで、他のコンポーネントインスタンスへのアクセスや DOM 要素を手動操作することを避けるのがベストです。しかし、それが適切な場合もあります。

### ルートインスタンスへのアクセス

`new Vue` インスタンスの全てのサブコンポーネントから、`$root` プロパティを用いてルートインスタンスへアクセスできます。例えば、このルートインスタンスを見てください:

```js
// ルート Vue インスタンス
new Vue({
  data: {
    foo: 1
  },
  computed: {
    bar: function () { /* ... */ }
  },
  methods: {
    baz: function () { /* ... */ }
  }
})
```

全てのサブコンポーネントはこのインスタンスにアクセスすることができ、グローバルストアとして使うことができます:

```js
// ルートデータの取得
this.$root.foo

// ルートデータの設定
this.$root.foo = 2

// ルート算出プロパティへのアクセス
this.$root.bar

// ルートメソッドの呼び出し
this.$root.baz()
```

<p class="tip">これはデモや一握りのコンポーネントで構成された非常に小さいアプリケーションとしては便利かもしれませんが、中〜大規模のアプリケーションにスケールさせづらいです。なので私達はほとんどのケースでステートを管理するために<a href="https://github.com/vuejs/vuex">Vuex</a>の使用を強くおすすめしています。</p>

### 親コンポーネントインスタンスへのアクセス

`$root` と似たように、`$parent` プロパティは子から親インスタンスへアクセスするために使われます。これはプロパティでデータを渡すことへの怠惰な代替手段として魅力あることでしょう。

<p class="tip">ほとんどのケースで、親へのアクセスはアプリケーションのデバッグや理解をより難しくします。特に、あなたが親のデータを変化させる場合はなおさらです。後々になってそのコンポーネントを扱うとき、その変化がどこから生じたものなのかを理解することはとても難しいことでしょう。</p>

しかしとりわけ共有コンポーネントライブラリの場合は、これが適切で_あるかもしれない_場合があります。例えば、仮想的な Google Map コンポーネントのように、HTML を描画する代わりに JavaScript の API を扱う抽象コンポーネントで:

```html
<google-map>
  <google-map-markers v-bind:places="iceCreamShops"></google-map-markers>
</google-map>
```

`<google-map>` コンポーネントは全てのサブコンポーネントがアクセスする必要がある `map`プロパティを定義しています。この場合、`<google-map-markers>` は地図上にマーカーを設定するため  `this.$parent.getMap` のような方法で map プロパティにアクセスしたいことでしょう。[ここから](https://codesandbox.io/s/github/vuejs/vuejs.org/tree/master/src/v2/examples/vue-20-accessing-parent-component-instance)このパターンをみることができます。

しかし、このパターンで作成されたコンポーネントはやはり本質的に壊れやすくなるということを覚えておいてください。例えば、`<google-map-region>` という新しいコンポーネントを追加することをイメージしてください。そして、`<google-map-markers>` が `<google-map-region>` 内に現れるとき、その領域内のマーカーのみ描画すべきです:

```html
<google-map>
  <google-map-region v-bind:shape="cityBoundaries">
    <google-map-markers v-bind:places="iceCreamShops"></google-map-markers>
  </google-map-region>
</google-map>
```

そのとき `<google-map-markers>` の内部で、あなたはこのようなハックに行き着くかもしれません:

```js
var map = this.$parent.map || this.$parent.$parent.map
```

このハックはすぐに手に負えなくなります。コンテキストの情報を子孫のコンポーネントに深く提供するからです。私達は代わりに[依存性の注入](#依存性の注入)を勧めます。

### 子コンポーネントインスタンスと子要素へのアクセス

プロパティとイベントが存在するにも関わらず、ときどき JavaScript で直接子コンポーネントにアクセスする必要があるかもしれません。このために `ref` 属性を使い、子コンポーネントにリファレンス ID を割り当てることができます。例えば:

```html
<base-input ref="usernameInput"></base-input>
```

今この `ref` を定義したコンポーネントで、このように:

```js
this.$refs.usernameInput
```

`<base-input>` インスタンスにアクセスすることができるようになります。例えばあなたがプログラムによって、親コンポーネントからこのインプットフォームにフォーカスしたいときに役立ちます。この場合、`<base-input>` コンポーネントは内部の特定要素へのアクセスを提供するため、親と同様に次のように `ref` を使うかもしれません:


```html
<input ref="input">
```

そして親によって使用されるメソッドを定義して:

```js
methods: {
  // 親からインプット要素をフォーカスするために使われる
  focus: function () {
    this.$refs.input.focus()
  }
}
```

このようなコードで、親コンポーネントに `<base-input>` 内部の input 要素にフォーカスさせます:

```js
this.$refs.usernameInput.focus()
```

`ref` が `v-for` と共に使用されるとき、あなたが得る参照はデータソースをミラーリングした子コンポーネントの配列でしょう。

<p class="tip"><code>$refs</code>はコンポーネントの描画後にデータが反映されるだけで、リアクティブではありません。子コンポーネントへの直接操作のための、退避用ハッチのような意味合いです(テンプレート内または算出プロパティから<code>$refs</code>にアクセスするのは避けるべきです)。</p>

### 依存性の注入

先ほど、[親コンポーネントインスタンスへのアクセス](#親コンポーネントインスタンスへのアクセス)を説明したとき、以下のような例を出しました:

```html
<google-map>
  <google-map-region v-bind:shape="cityBoundaries">
    <google-map-markers v-bind:places="iceCreamShops"></google-map-markers>
  </google-map-region>
</google-map>
```

このコンポーネントで、`<google-map>` の全ての子孫は地図のどの部分に作用させるのかを知るために `getMap` へアクセスすることを必要としていました。不幸にも `$parent` プロパティの使用は、より深くネストされたコンポーネントに適合できませんでした。この点こそが、2つの新しいインスタンスオプション、`provide` と `inject` の使用により、依存性の注入が役立つところです。

`provide` オプションは子孫のコンポーネントに**提供**したいデータやメソッドを特定させます。この場合、それは `<google-map>` 内にある `getMap` です:

```js
provide: function () {
  return {
    getMap: this.getMap
  }
}
```

このとき全ての子孫で、私達はインスタンスに追加したい特定のプロパティを受け取るため `inject` オプションを使うことができます:

```js
inject: ['getMap']
```

以上の[完例はここから](https://codesandbox.io/s/github/vuejs/vuejs.org/tree/master/src/v2/examples/vue-20-dependency-injection)確認できます。`$parent` を使う以上の利点は `<google-map>` インスタンス全体を晒すことなく、どの子孫コンポーネントからでも `getMap` にアクセスできることです。これは子コンポーネントが依存する何かを変更や削除するかもしれないという恐怖を無くし、より安全にコンポーネントを開発できるようにします。これらのコンポーネント間のインターフェースは、ちょうど`プロパティ`を用いるように明確に定義されます。

実際、以下を除けば、いわば"広範囲のプロパティ"のようなものとした依存性の注入と考えることができます:

* 祖先のコンポーネントはどの子孫が自分が提供するプロパティを使っているのかを知る必要がありません。
* 子孫のコンポーネントは注入されたプロパティがどこからきているのかを知る必要がありません。

<p class="tip">しかし、依存性の注入には不都合な点があります。 依存性の注入はアプリケーションのコンポーネントを現在の状態に密結合させ、リファクタリングを難しくさせます。そして提供されるプロパティはリアクティブではありません。これは設計上の理由によるものです。中央データストアを作るために依存性の注入を使うことは、同じ目的のために<a href="#ルートインスタンスへのアクセス"><code>$root</code>を使うこと</a>と同じくらいアプリケーションのスケールを難しくします。もしアプリケーションに特定のプロパティをシェアしたいのなら、もしくはもし先祖に提供したデータを更新したいのなら、そのときは組み込みの機能よりむしろ、<a href="https://github.com/vuejs/vuex">Vuex</a>のような本物の状態管理ソリューションを必要とするいい兆候です。</p>

依存性の注入についてより学びたいのなら、[この API ドキュメント](https://jp.vuejs.org/v2/api/#provide-inject)を参照してください。

## プログラム的なイベントリスナー

今のところ、`v-on` により発火される `$emit` の使用法を見てきました。しかし Vue インスタンスは以下のような、他のイベントインターフェースのメソッドも提供しています。

- 特定のイベントを監視する`$on(eventName, eventHandler)`
- 一度のイベントしか監視しない`$once(eventName, eventHandler)`
- イベントの監視をやめる`$off(eventName, eventHandler)`

通常これらを使用する必要はありませんが、手動でコンポーネントインスタンスを監視する必要があるときに用いることができます。それらはコードの統合ツールとしても役立ちます。例えば、時々サードパーティライブラリを使用するためにこのようなパターンに遭遇するかもしれません:

```js
// 一旦DOMにマウントされたとき、
// datepicker をインプット要素に紐付ける
mounted: function () {
  // Pikaday はサードパーティの日付選択のライブラリです
  this.picker = new Pikaday({
    field: this.$refs.input,
    format: 'YYYY-MM-DD'
  })
},
// コンポーネントが破棄させる直前に、
// datepicker も破棄されます
beforeDestroy: function () {
  this.picker.destroy()
}
```

これには2つの潜在的な問題があります:

- ライフサイクルフックが `picker` オブジェクトにアクセスする必要がある可能性があるとき、コンポーネントインスタンスにそれを保存する必要があります。酷くはないですが、煩雑に感じられるかもしれません。
- セットアップコードが、クリーンアップコードとは別に保たれており、それは、セットアップしたものをプログラムでクリーンアップすることをより困難にしています。

プログラム的なリスナーを使用することで両方の問題を解決することができます:

```js
mounted: function () {
  var picker = new Pikaday({
    field: this.$refs.input,
    format: 'YYYY-MM-DD'
  })

  this.$once('hook:beforeDestroy', function () {
    picker.destroy()
  })
}
```

この戦略を使用することによって、いくつかのインプット要素で Pikaday を使用することができ、そのライフサイクル自身のコードで、各新しいインスタンスは自動的にクリーンアップできます。

```js
mounted: function () {
  this.attachDatepicker('startDateInput')
  this.attachDatepicker('endDateInput')
},
methods: {
  attachDatepicker: function (refName) {
    var picker = new Pikaday({
      field: this.$refs[refName],
      format: 'YYYY-MM-DD'
    })

    this.$once('hook:beforeDestroy', function () {
      picker.destroy()
    })
  }
}
```

全てのコードが載っている[この例](https://codesandbox.io/s/github/vuejs/vuejs.org/tree/master/src/v2/examples/vue-20-programmatic-event-listeners)を見てください。しかし注意して欲しいのが、もし1つのコンポーネント内で多くのセットアップやクリーンアップをしなければならない場合、ベストな解決策はたいていより細分化したコンポーネントを作ることです。このケースでは、再利用可能な `<input-datepicker>` コンポーネントを作ることをおすすめします。

よりプログラム的なリスナーの詳細を学ぶなら、[インスタンスメソッドイベント](https://jp.vuejs.org/v2/api/#%E3%82%A4%E3%83%B3%E3%82%B9%E3%82%BF%E3%83%B3%E3%82%B9%E3%83%A1%E3%82%BD%E3%83%83%E3%83%89-%E3%82%A4%E3%83%99%E3%83%B3%E3%83%88)の API をチェックしてください。

<p class="tip">Vue のイベントシステムは<a href="https://developer.mozilla.org/en-US/docs/Web/API/EventTarget">ブラウザのイベントターゲット API </a>とは異なっていることに注意してください。それらは<code>$emit</code>, <code>$on</code>, <code>$off</code>と似たように動作しますが、<code>dispatchEvent</code>, <code>addEventListener</code>, <code>removeEventListener</code>のエイリアスでは<strong>ありません</strong>。</p>

## 循環参照

### 再帰的コンポーネント

コンポーネントは自身をテンプレートで再帰的に呼び出すことができます。`name`オプションを使用することによって、それは可能です:

``` js
name: 'unique-name-of-my-component'
```

`Vue.component` を用いてグローバルにコンポーネントを登録するとき、グローバル ID は自動的に、コンポーネントの `name` オプションとしてセットされます。

``` js
Vue.component('unique-name-of-my-component', {
  // ...
})
```

注意しないと、再帰的なコンポーネントも無限ループに繋がる可能性があります:

``` js
name: 'stack-overflow',
template: '<div><stack-overflow></stack-overflow></div>'
```

上記のようなコンポーネントは"max stack size exceeded"エラーに終わるでしょう。なので必ず再帰的な呼び出しは条件付きにしましょう(例えば最終的に `false` になる `v-if` を使用するように)。

### コンポーネント間の循環参照

あなたは Finder やファイルエクスプローラのようなファイルディレクトリツリーを構築しているとしましょう。このテンプレートのような `tree-folder` コンポーネントを持つかもしれません:

``` html
<p>
  <span>{{ folder.name }}</span>
  <tree-folder-contents :children="folder.children"/>
</p>
```

`tree-folder-contents` は以下のようなテンプレートです:

``` html
<ul>
  <li v-for="child in children">
    <tree-folder v-if="child.children" :folder="child"/>
    <span v-else>{{ child.name }}</span>
  </li>
</ul>
```

よく見ると、これらのコンポーネントが実際にそれぞれ他のレンダリングツリーの子孫_と_祖先になっていますね。矛盾してますね！`Vue.component` でグローバルにコンポーネントを登録するとき、この矛盾は自動的に解決されます。何を言っているのか分からないなら、これ以降読むのやめることができます。

しかしもしあなたが、例えば Webpack や Browserify 経由で、__モジュールシステム__を使用するコンポーネントを require/import するならば、以下のようなエラーに遭遇するでしょう:

```
Failed to mount component: template or render function not defined.
```

何が起こったかを説明するために、コンポーネント A と B を呼び出してみましょう。モジュールシステムはコンポーネント A を必要とすると認識します。しかしコンポーネント A はコンポーネント B を必要とします。しかしコンポーネント B はコンポーネント A を必要とします。しかしコンポーネント A はコンポーネント B を必要とします(以下略)。最初に他のものを解決することなく、いずれかのコンポーネントを完全に解決する方法がわからずにループで詰まってしまっています。これを直すため、モジュールシステムに「コンポーネント A は最終的にコンポーネント B を必要としますが、B を最初に解決する必要はありません」ということを教える必要があります。

今回は、そのことを `tree-folder` コンポーネントに教えてみましょう。私達はその矛盾を生み出す子が、`tree-folder-contents` コンポーネントだということを知っています。なので、`beforeCreate` ライフサイクルフックが `tree-folder-contents` コンポーネントを登録するまで待ってみましょう:

``` js
beforeCreate: function () {
  this.$options.components.TreeFolderContents = require('./tree-folder-contents.vue').default
}
```

もしくは別の方法として、コンポーネントをローカルに登録するときに Webpack の非同期 `import` を使用することができます:

``` js
components: {
  TreeFolderContents: () => import('./tree-folder-contents.vue')
}
```

これで問題が解決されました！

## 代替テンプレート定義

### インラインテンプレート

`inline-template` 属性が子コンポーネントの上に存在するとき、子コンポーネントを別のコンテントして扱うよりむしろ、自身のテンプレートとしてそれを使用します。これはよりテンプレート作成をフレキシブルにします。

``` html
<my-component inline-template>
  <div>
    <p>These are compiled as the component's own template.</p>
    <p>Not parent's transclusion content.</p>
  </div>
</my-component>
```

インラインテンプレートは、Vue がアタッチされた DOM 要素の内側で定義する必要があります。

<p class="tip">しかし、<code>inline-template</code>はテンプレートのスコープの推論を難しくします。ベストプラクティスとして、<code>template</code>オプションを使用してコンポーネント内部でテンプレート定義するようにしてください。または<code>.vue</code>ファイルの<code>&lt;template&gt;</code>要素で定義するのもいいでしょう。</p>

### X- テンプレート

テンプレートを定義する別の方法は、type 属性`text/x-template`を用いたスクリプト要素の内部で定義することです。そのとき、id によってテンプレートを参照する必要があります。例えば:

``` html
<script type="text/x-template" id="hello-world-template">
  <p>Hello hello hello</p>
</script>
```

``` js
Vue.component('hello-world', {
  template: '#hello-world-template'
})
```

x-template は、Vue がアタッチされた DOM 要素の外側で定義する必要があります。

<p class="tip">これらは大規模なテンプレートを必要とするデモや非常に小さなアプリケーションで役立ちます。しかし一方で避けられるべきでもあります。なぜなら、それらはコンポーネント定義からテンプレートを分離させるからです。</p>

## 更新をコントロールする

Vue のリアクティブシステムのおかげで、いつもいつ更新するかを知ることができます(もしあなたが正確に使っているなら)。しかし、リアクティブデータが変更されていないにも関わらず更新を強制したいときなど、特別なケースがあります。

### 強制更新

<p class="tip">もし Vue で強制更新をする必要な場面に遭遇する場合、99.99% のケースであなたは何かを間違えています。</p>

[配列](https://jp.vuejs.org/v2/guide/list.html#%E6%B3%A8%E6%84%8F%E4%BA%8B%E9%A0%85)、または[オブジェクト](https://jp.vuejs.org/v2/guide/list.html#%E3%82%AA%E3%83%96%E3%82%B8%E3%82%A7%E3%82%AF%E3%83%88%E3%81%AE%E5%A4%89%E6%9B%B4%E6%A4%9C%E5%87%BA%E3%81%AE%E6%B3%A8%E6%84%8F) 、または例として`data`のようなリアクティブシステムによって追跡されていない状態に依存しているように、変更検出の警告を考慮していないかもしれません。

しかし、もし上記の可能性を排除し、手動で強制更新をする非常に稀な状況と認識しているならば、`$forceUpdate` を用いることで強制更新をすることができます。

### `v-once` を使用するチープスタティックコンポーネント

プレーンな HTML 要素をレンダリングすることは Vue においてとても高速です。しかしときどき**多くの**静的なコンテントを含むコンポーネントを持ちたい場合もあるかもしれません。これらのケースでは、このようにルート要素に `v-once` ディレクティブを加えることによって一度だけ評価され、そしてキャッシュされることを保証することができます:

``` js
Vue.component('terms-of-service', {
  template: `
    <div v-once>
      <h1>Terms of Service</h1>
      ... a lot of static content ...
    </div>
  `
})
```

<p class="tip">再度注意しますが、このパターンを多用しないようにしてください。多くの静的な内容を描画しなければならないとき、これらのレアケースは便利である一方、あなたが実際に遅いレンダリングに気付かない限りは絶対に必要ではありません。さらにそれは後に多くの混乱の原因になり得るでしょう。例えば、<code>v-once</code>に精通していない開発者や、単純にテンプレート内にそれを見逃した開発者を想像してみてください。それらはなぜテンプレートが正確に更新されないのかの原因究明に時間を費やすことになるかもしれません。</p>
