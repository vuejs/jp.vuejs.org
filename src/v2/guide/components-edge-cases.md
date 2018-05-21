---
title: 特別な問題に対処する
type: guide
order: 106
---

> ⚠️注意: この内容は原文のままです。現在翻訳中ですのでお待ち下さい。🙏

> このページはすでに[コンポーネントの基本](components.html)を読んでいることを前提に書いています。もしまだ読んでいないのなら、先に読みましょう。

<p class="tip">特別な問題、つまり珍しい状況に対処するためのこのページの全ての機能は、時にVueのルールを多少なりとも曲げることになります。しかしながら注意して欲しいのが、それらは全てデメリットや危険な状況をもたらし得るということです。これらのマイナス的な面はそれぞれのケースで注意されているので、このページで紹介されるそれぞれの機能を使用すると決めた時は心に止めておいてください。</p>

## 要素 & コンポーネントへのアクセス

ほとんどのケースで、他のコンポーネントインスタンスへのアクセスやDOM要素を手動操作することを避けるのがベストです。しかし、それが適切な場合もあります。

### ルートインスタンスへのアクセス

`new Vue`インスタンスの全てのサブコンポーネントから、`$root`プロパティを用いてルートインスタンスへアクセスできます。例えば、以下のルートインスタンスでは...

```js
// The root Vue instance
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

全てのサブコンポーネントはこのインスタンスにアクセスすることができ、グローバルストアとして使うことができます。

```js
// Get root data
this.$root.foo

// Set root data
this.$root.foo = 2

// Access root computed properties
this.$root.bar

// Call root methods
this.$root.baz()
```

<p class="tip">これはデモや一握りのコンポーネントで構成された非常に小さいアプリケーションとしては便利かもしれませんが、中〜大規模のアプリケーションにスケールさせづらいです。なので我々はほとんどのケースでステートを管理するために<a href="https://github.com/vuejs/vuex">Vuex</a>の使用を強くおすすめしています。</p>

### 親コンポーネントインスタンスへのアクセス

`$root`と似たように、`$parent`プロパティは子から親インスタンスへアクセスするために使われます。これはpropsでデータを渡すことへの怠惰な代替手段として魅力あることでしょう。

<p class="tip">ほとんどのケースで、親へのアクセスはアプリケーションのデバッグや理解をより難しくします。特に、あなたが親のデータを変化させる場合はなおさらです。後々になってそのコンポーネントを扱う時、その変化がどこから来たものなのかを理解することはとても難しいことでしょう。</p>

しかしながらとりわけ共有コンポーネントライブラリの場合は、これが適切で_あるかもしれない_場合があります。例えば、仮想的なGoogle Mapコンポーネントのような、HTMLを描画する代わりにJavaScriptのAPIを扱う抽象コンポーネントの場合は...

```html
<google-map>
  <google-map-markers v-bind:places="iceCreamShops"></google-map-markers>
</google-map>
```

`<google-map>`コンポーネントは全てのサブコンポーネントがアクセスする必要がある`map`プロパティを定義しています。この場合、`<google-map-markers>`は地図上にマーカーを設定するため`this.$parent.getMap`のような何かでmapプロパティにアクセスしたいことでしょう。[ここから](https://jsfiddle.net/chrisvfritz/ttzutdxh/)このパターンをみることができます。

しかしながら、このパターンで作成されたコンポーネントはやはり本質的に壊れやすくなるということを覚えておいてください。例えば、`<google-map-region>`という新しいコンポーネントを追加することをイメージしてください。そして、`<google-map-markers>`が`<google-map-region>`内に現れる時、その領域内のマーカーのみ描画すべきです。

```html
<google-map>
  <google-map-region v-bind:shape="cityBoundaries">
    <google-map-markers v-bind:places="iceCreamShops"></google-map-markers>
  </google-map-region>
</google-map>
```

Then inside `<google-map-markers>` you might find yourself reaching for a hack like this:
そのとき`<google-map-markers>`の内部で、あなたはこのようなハックに行き着くかもしれない...

```js
var map = this.$parent.map || this.$parent.$parent.map
```

このハックはすぐに手に負えなくなります。コンテキストの情報を子孫のコンポーネントに専ら深く提供するからです。私たちは代わりに[依存性の注入](#Dependency-Injection)を勧めます。

### 子コンポーネントインスタンスと子要素へのアクセス

propsとイベントが存在するにも関わらず、ときどきJavaScriptで直接子コンポーネントにアクセスする必要があるかもしれません。このために`ref`属性を使い、子コンポーネントにリファレンスIDを割り当てることができます。例えば...

```html
<base-input ref="usernameInput"></base-input>
```

今この`ref`を定義したコンポーネントでこのように...

```js
this.$refs.usernameInput
```

`<base-input>`インスタンスにアクセスすることができるようになります。例えば、あなたがプログラムによって、親コンポーネントからこのインプットフォームにフォーカスしたいときに役立ちます。この場合、`<base-input>`コンポーネントは内部の特定要素へのアクセスを提供するため、親と同様に`ref`を使うかもしれません。このように...


```html
<input ref="input">
```

親にも使用されるメソッドを定義して...

```js
methods: {
  // Used to focus the input from the parent
  focus: function () {
    this.$refs.input.focus()
  }
}
```

このようなコードで、親コンポーネントに`<base-input>`内部のinput要素にフォーカスさせます。

```js
this.$refs.usernameInput.focus()
```

`ref`が`v-for`と共に使用されるとき、あなたが得る参照はデータソースをミラーリングした子コンポーネントの配列であるでしょう。

<p class="tip"><code>$refs</code>はコンポーネントの描画後に生きるだけで、リアクティブではありません。それは子コンポーネントへの直接操作(テンプレート内または算出プロパティから<code>$refs</code>にアクセスするのは避けるべきです)のための、退避用ハッチのような意味合いです。</p>

### 依存性の注入

先ほど、[親コンポーネントインスタンスへのアクセス](#Accessing-the-Parent-Component-Instance)を説明したとき、以下のような例を出しました。

```html
<google-map>
  <google-map-region v-bind:shape="cityBoundaries">
    <google-map-markers v-bind:places="iceCreamShops"></google-map-markers>
  </google-map-region>
</google-map>
```

このコンポーネントで、`<google-map>`の全ての子孫は地図のどの部分に作用させるのかを知るために`getMap`へアクセスすることを必要としていました。不幸にも`$parent`プロパティの使用は、より深くネストされたコンポーネントに適合できませんでした。それこそが、二つの新しいインスタンスオプション、`provide`と`inject`の使用により、依存性の注入が役立つところです。

`provide`オプションは子孫のコンポーネントに**提供**したいデータやメソッドを特定させます。この場合、それは`<google-map>`内にある`getMap`です。

```js
provide: function () {
  return {
    getMap: this.getMap
  }
}
```

このとき全ての子孫で、私達はインスタンスに追加したい特定のプロパティを受け取るため`inject`オプションを使うことができます。

```js
inject: ['getMap']
```

以上の[完例はここから](https://jsfiddle.net/chrisvfritz/tdv8dt3s/)確認できます。`$parent`を使う以上の利点は`<google-map>`インスタンス全体を晒すことなく、どの子孫コンポーネントからでも`getMap`にアクセスできることです。これは子コンポーネントが依存する何かを変更や削除するかもしれないという恐怖を無くし、より安全にコンポーネントを開発できるようにします。これらのコンポーネント間のインターフェースは、ちょうど`props`を用いるように明確に定義されます。

事実、いわば"広範囲のprops"のようなものと、依存性の注入について考えることができます。# TODO: expectはどう訳せばいいのだろう?

* 祖先のコンポーネントはどの子孫が自分が提供するプロパティを使っているのかを知る必要がありません。
* 子孫のコンポーネントは注入されたプロパティがどこからきているのかを知る必要がありません。

<p class="tip">しかしながら、依存性の注入には不都合な点があります。 依存性の注入はアプリケーションのコンポーネントを現在の状態につなぎ合わせさせ、リファクタリングを難しくさせます。そして提供されるプロパティはリアクティブではありません。これは設計上の理由によるものです。中央データストアを作るために依存性の注入を使うことは、同じ目的のために<a href="#Accessing-the-Root-Instance"><code>$root</code>を使うこと</a>と同じくらいアプリケーションのスケールを難しくします。もしアプリケーションに特定のプロパティをシェアしたいのなら、もしくはもし先祖に提供したデータを更新したいのなら、組み込みの機能よりむしろ、代わりに<a href="https://github.com/vuejs/vuex">Vuex</a>のような本物の状態管理ソリューションを必要とするいい兆候です。</p>

依存性の注入についてより学びたいのなら、[このAPIドキュメント](https://vuejs.org/v2/api/#provide-inject)を参照してください。

## プログラマティックなイベントリスナー

今のところ、`v-on`により発火される`$emit`の使用法を見てきました。しかしVueインスタンスは以下のような、他のイベントインターフェースのメソッドも提供しています。

- 特定のイベントを監視する`$on(eventName, eventHandler)`
- 一度のイベントしか監視しない`$once(eventName, eventHandler)`
- イベントの監視をやめる`$off(eventName, eventHandler)`

通常これらを使用する必要はありませんが、手動でコンポーネントインスタンスを監視する必要があるときに用いることができます。それらはコードの統合ツールとしても役立ちます。例えば、時々サードパーティライブラリーを使用するためにこのようなパターンに遭遇するかもしれません。

```js
// Attach the datepicker to an input once
// it's mounted to the DOM.
mounted: function () {
  // Pikaday is a 3rd-party datepicker library
  this.picker = new Pikaday({
    field: this.$refs.input,
    format: 'YYYY-MM-DD'
  })
},
// Right before the component is destroyed,
// also destroy the datepicker.
beforeDestroy: function () {
  this.picker.destroy()
}
```

これには2つの潜在的な問題があります。

- ライフサイクルフックが`picker`オブジェクトにアクセスする必要がある可能性がある時、コンポーネントインスタンスにそれを保存する必要があります。酷くはないですが、煩雑に感じられるかもしれません。
- セットアップコードが削除コードから分離している状態は、セットアップしたものをプログラムでクリーンアップすることをより難しくします。 # TODO: 上手く翻訳できない

プログラマティックリスナー使用することで両方の問題を解決することができます。

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

この戦略を使用することで、私達はいくつかのインプット要素を持つPikadayさえ使うことができます。そしてそれぞれの新しいインスタンスは自動的にクリーンアップされます。 # TODO: after itselfが訳せない

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

全てのコードが乗っている[このfiddle](https://jsfiddle.net/chrisvfritz/1Leb7up8/)を見てください。しかしながら注意して欲しいのが、もし一つのコンポーネント内で多くのセットアップやクリーンアップをしなければならない場合、ベストな解決策はたいていより細分化したコンポーネントを作ることです。このケースでは、再利用可能な`<input-datepicker>`コンポーネントを作ることをおすすめします。

よりプログラマティックリスナーの詳細を学ぶなら、[インスタンスメソッドイベント](https://vuejs.org/v2/api/#Instance-Methods-Events)のAPIをチェックしてください。

<p class="tip">Vueのイベントシステムは<a href="https://developer.mozilla.org/en-US/docs/Web/API/EventTarget">ブラウザのイベントターゲットAPI</a>とは異なっていることに注意してください。それらは<code>$emit</code>, <code>$on</code>, <code>$off</code>と似たように動作しますが、<code>dispatchEvent</code>, <code>addEventListener</code>, <code>removeEventListener</code>のエイリアスでは<strong>ありません</strong>。</p>

## 循環参照

### 再帰的コンポーネント

コンポーネントは自身テンプレートで再帰的に呼び出すことができます。しかし、`name`オプションのみでしかそうすることはできません。

``` js
name: 'unique-name-of-my-component'
```

`Vue.component`を用いてグローバルにコンポーネントを登録する時、グローバルIDは自動的に、コンポーネントの`name`オプションとしてセットされます。

``` js
Vue.component('unique-name-of-my-component', {
  // ...
})
```

注意しないと、再帰的なコンポーネントも無限ループに繋がる可能性があります。

``` js
name: 'stack-overflow',
template: '<div><stack-overflow></stack-overflow></div>'
```

上記のようなコンポーネントは"max stack size exceeded"エラーに終わるでしょう。なので必ず再帰的な呼び出しは条件付きにしましょう(例えば最終的に`false`になる`v-if`を使用するように)。

### コンポーネント間の循環参照

あなたはFinderやファイルエクスプローラのようなファイルディレクトリツリーを構築しているとしましょう。このテンプレートのような`tree-folder`コンポーネントを持つかもしれません。

``` html
<p>
  <span>{{ folder.name }}</span>
  <tree-folder-contents :children="folder.children"/>
</p>
```

`tree-folder-contents`は以下のようなテンプレートです。

``` html
<ul>
  <li v-for="child in children">
    <tree-folder v-if="child.children" :folder="child"/>
    <span v-else>{{ child.name }}</span>
  </li>
</ul>
```

よく見てみると、これらのコンポーネントは実際に、それぞれ他のレンダリングツリーの子孫_と_祖先であることがわかります。逆説的です! `Vue.component`でグローバルにコンポーネントを登録する時、この逆説は自動的に解決されます。もしそれがあなたなら、ここで読むことをやめることもできます。 # TODO: if that's you が訳せない

しかしながらもしあなたが、例えばWebpackやBrowserify経由で、__モジュールシステム__を使用するコンポーネントをrequire/importするならば、以下のようなエラーに遭遇するでしょう。

```
Failed to mount component: template or render function not defined.
```

何が起こったかを説明するために、コンポーネントAとBを呼び出して見ましょう。モジュールシステムはコンポーネントAを必要とすると認識します。しかしコンポーネントAはコンポーネントBを必要とします。しかしコンポーネントBはコンポーネントAを必要とします。しかしコンポーネントAはコンポーネントBを必要とします...。最初に他のものを解決することなく、いずれかのコンポーネントを完全に解決する方法がわからずにループで詰まってしまっています。これを直すために、私達はモジュールシステムに「コンポーネントAは最終的にコンポーネントBを必要としますが、Bを最初に解決する必要はありません。」ということを教える必要があります。

今回は、そのことを`tree-folder`コンポーネントに教えてみましょう。私達はその逆説を生み出す子が、`tree-folder-contents`コンポーネントだということを知っています。なので、`beforeCreate`ライフサイクルフックが`tree-folder-contents`コンポーネントを登録するまで待ってみましょう。

``` js
beforeCreate: function () {
  this.$options.components.TreeFolderContents = require('./tree-folder-contents.vue').default
}
```

もしくは別の方法として、コンポーネントをローカルに登録するときにWebpackの非同期`import`を使用することができます。

``` js
components: {
  TreeFolderContents: () => import('./tree-folder-contents.vue')
}
```

これで問題が解決されました!

## 代替テンプレート定義

### インラインテンプレート

`inline-template`属性が子コンポーネント上に存在するとき、分散コンテントして扱うよりむしろ、そのコンポーネントは自身のテンプレートとしてその内部コンテントを使用します。これはよりテンプレート作成をフレキシブルにします。# TODO: 上手く訳せない...

``` html
<my-component inline-template>
  <div>
    <p>These are compiled as the component's own template.</p>
    <p>Not parent's transclusion content.</p>
  </div>
</my-component>
```

<p class="tip">しかしながら、<code>inline-template</code>はテンプレートのスコープの推論を難しくします。ベストプラクティスとして、<code>template</code>オプションを使用してコンポーネント内部でテンプレート定義するようにしなさい。または<code>.vue</code>ファイルの<code>&lt;template&gt;</code>要素で定義するのもいいでしょう。</p>

### X-テンプレート

テンプレートを定義する別の方法は、type属性`text/x-template`を用いたスクリプト要素の内部で定義することです。そのとき、idによってテンプレートを参照する必要があります。例えば以下のように。

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

<p class="tip">これらは大規模なテンプレートを必要とするデモや非常に小さなアプリケーションで役立ちます。しかし一方で避けられるべきでもあります。なぜなら、それらはコンポーネント定義からテンプレートを分離させるからです。</p>

## 更新をコントロールする

Vueのリアクティブシステムのおかげで、いつもいつ更新するかを知ることができます(もしあなたが正確に使っているなら)。しかしながら、リアクティブデータが変更されていないにも関わらず更新を強制したい時など、特別なケースがあります。

### 強制更新

<p class="tip">もしVueで強制更新をする必要な場面に遭遇場合、99.99%のケースであなたは何かを間違えています。</p>

あなたは[配列](https://vuejs.org/v2/guide/list.html#Caveats)や[オブジェクト](https://vuejs.org/v2/guide/list.html#Object-Change-Detection-Caveats)や`data`で用いられるような、Vueのリアクティブシステムに追跡されていない状態に依存しているかもしれないと言う変更検出の警告を考慮していないかもしれません。 # TODO: 上手く訳せない

しかしながら、もし上記の可能性を排除し、この手動で強制更新をする非常に稀な状況と認識しているならば、`$forceUpdate`を用いることで強制更新をすることができます。

### `v-once`を使用するチープスタティックコンポーネント

プレーンなHTML要素をレンダリングすることはVueにおいてとても高速です。しかしときどき**多くの**静的な内容を含むコンポーネントを持ちたい場合もあるかもしれません。これらのケースでは、このようにルート要素に`v-once`ディレクティブを加えることによって一度だけ評価され、そしてキャッシュされることを保証することができます。

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

<p class="tip">再度注意しますが、このパターンを多様しないようにしてください。多くの静的な内容を描画しなければならないとき、これらのレアケースは便利である一方、あなたが実際に遅いレンダリングに気付かない限りは絶対に必要ではありません。さらにそれは後に多くの混乱の原因になり得るでしょう。例えば、<code>v-once</code>に精通していない開発者や、単純にテンプレート内にそれを見逃した開発者を想像してみてください。それらはなぜテンプレートが正確に更新されないのかの原因究明に時間を費やすことになるかもしれません。</p>
