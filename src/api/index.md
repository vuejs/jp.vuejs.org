---
type: api
---

## グローバル設定

`Vue.config` は Vue のグローバル設定を含んでいるオブジェクトです。あなたのアプリケーションが読み込まれる前に、下記のプロパティを変更することが出来ます:

### silent

- **型:** `boolean`

- **デフォルト:** `false`

- **使用方法:**

  ``` js
  Vue.config.silent = true
  ```

  すべての Vue のログと警告を抑制します。

### optionMergeStrategies

- **型:** `{ [key: string]: Function }`

- **デフォルト:** `{}`

- **使用方法:**

  ``` js
  Vue.config.optionMergeStrategies._my_option = function (parent, child, vm) {
    return child + 1
  }

  const Profile = Vue.extend({
    _my_option: 1
  })

  // Profile.options._my_option = 2
  ```

  オプションに対してカスタムマージストラテジを定義します。

  マージ戦略を親で定義されたオプションの値と子のインスタンスの値が、それぞれ第1引数、第2引数として受け取ります。Vue インスタンスのコンテキストは第3引数として渡されます。

- **参照**: [カスタムオプションのマージストラテジ](/guide/mixins.html#カスタムオプションのマージストラテジ)

### devtools

- **型:** `boolean`

- **デフォルト:** `true` (プロダクションビルドでは `false`)

- **使用方法:**

  ``` js
  // Vue ローディング直後、この設定が同期されていることを確認してください
  Vue.config.devtools = true
  ```

  [vue-devtools](https://github.com/vuejs/vue-devtools) インスペクションを許可するかどうか設定します。このオプションのデフォルト値は development ビルドでは、`true` で production ビルドでは `false` です。production ビルドで `true` に設定することでインスペクションを有効にできます。

### errorHandler

- **型:** `Function`

- **デフォルト:** エラーが代わりにスローされます

- **使用方法:**

  ``` js
  Vue.config.errorHandler = function (err, vm) {
    // エラー処理
  }
  ```

  コンポーネントのレンダリングとウォッチャいおいて未捕獲のエラーに対してハンドラを割り当てます。ハンドラはエラーと Vue インスタンスが引数に渡されて呼び出されます。

### keyCodes

- **型:** `{ [key: string]: number }`

- **デフォルト:** `{}`

- **使用方法:**

  ``` js
  Vue.config.keyCodes = { esc: 27 }
  ```

  `v-on` 向けにカスタムキーエイリアスを定義します。

## グローバル API

<h3 id="Vue-extend">Vue.extend( options )</h3>

- **引数:**
  - `{Object} options`

- **使用方法:**

  Vue コンストラクタベースの "サブクラス" を作成します。引数はコンポーネントオプションを含むオブジェクトにする必要があります。

  ここでの注意すべき特別なケースは、data` プションは、これらは `Vue.extend()` で使用されるとき、関数にしなければなりません。

  ``` html
  <div id="mount-point"></div>
  ```

  ``` js
  // 再利用可能なコンストラクタを作成
  var Profile = Vue.extend({
    template: '<p>{{firstName}} {{lastName}} aka {{alias}}</p>',
    data: function () {
      return {
        firstName: 'Walter',
        lastName: 'White',
        alias: 'Heisenberg'
      }
    }
  })
  // Profile のインスタンスを作成して、要素上にマウントする
  new Profile().$mount('#mount-point')
  ```

  結果は以下のようになります:

  ``` html
  <p>Walter White aka Heisenberg</p>
  ```

- **参照:** [コンポーネント](/guide/components.html)

<h3 id="Vue-nextTick">Vue.nextTick( callback, [context] )</h3>

- **引数:**
  - `{Function} callback`
  - `{Object} [context]`

- **使用方法:**

  callback を延期し、DOM の更新サイクル後に実行します。DOM 更新を待ち受けるために、いくつかのデータを変更した直後に使用してください。

  ``` js
  // データを変更する
  vm.msg = 'Hello'
  // DOM はまだ更新されていません
  Vue.nextTick(function () {
    // DOM が更新されています
  })
  ```

- **参照:** [非同期更新キュー](/guide/reactivity.html#非同期更新キュー)

<h3 id="Vue-set">Vue.set( object, key, value )</h3>

- **引数:**
  - `{Object} object`
  - `{string} key`
  - `{any} value`

- **戻り値:** 設定した値

- **使用方法:**

  オブジェクトにプロパティを設定します。オブジェクトがリアクティブの場合、プロパティがリアクティブプロパティとして作成されることを保証し、View 更新をトリガします。これは主に Vue がプロパティの追加を検知できないという制約を回避するために使われます。

  **オブジェクトは Vue インスタンス、または Vue インスタンスのルートな data オブジェクトにできないことに注意してください。**

- **参照:** [リアクティブの探求](/guide/reactivity.html)


<h3 id="Vue-delete">Vue.delete( object, key )</h3>

- **引数:**
  - `{Object} object`
  - `{string} key`

- **使用方法:**

  オブジェクトのプロパティを削除します。オブジェクトがリアクティブの場合、削除がトリガし View が更新されることを保証します。これは主に Vue がプロパティの削除を検知できないという制約を回避するために使われますが、使う必要があることはまれです。

  **オブジェクトは Vue インスタンス、または Vue インスタンスのルートな data オブジェクトにできないことに注意してください。**

- **参照:** [リアクティブの探求](/guide/reactivity.html)

<h3 id="Vue-directive">Vue.directive( id, [definition] )</h3>

- **引数:**
  - `{string} id`
  - `{Function | Object} [definition]`

- **使用方法:**

  グローバルディレクティブを登録または取得します。

  ``` js
  // 登録
  Vue.directive('my-directive', {
    bind: function () {},
    inserted: function () {},
    update: function () {},
    componentUpdated: function () {},
    unbind: function () {}
  })

  // 登録 (シンプルな function directive)
  Vue.directive('my-directive', function () {
    / `bind` と `update` として呼ばれる
  })

  // getter、登録されていればディレクティブ定義を返す
  var myDirective = Vue.directive('my-directive')
  ```

- **参照:** [カスタムディレクティブ](/guide/custom-directive.html)

<h3 id="Vue-filter">Vue.filter( id, [definition] )</h3>

- **引数:**
  - `{string} id`
  - `{Function} [definition]`

- **使用方法:**

  グローバルフィルタに登録または取得します。

  ``` js
  // 登録
  Vue.filter('my-filter', function (value) {
    // 処理された値を返す
  })

  // getter、登録されていればフィルタを返す
  var myFilter = Vue.filter('my-filter')
  ```

<h3 id="Vue-component">Vue.component( id, [definition] )</h3>

- **引数:**
  - `{string} id`
  - `{Function | Object} [definition]`

- **使用方法:**

  グローバルコンポーネントに登録または取得します。

  ``` js
  // 拡張されたコンストラクタを登録
  Vue.component('my-component', Vue.extend({ /* ... */ }))

  // オプションオブジェクトを登録 (Vue.extend を自動的に呼ぶ)
  Vue.component('my-component', { /* ... */ })

  // 登録されたコンポーネントを取得 (常にコンストラクタを返す)
  var MyComponent = Vue.component('my-component')
  ```

- **参照:** [コンポーネント](/guide/components.html)

<h3 id="Vue-use">Vue.use( plugin )</h3>

- **引数:**
  - `{Object | Function} plugin`

- **使用方法:**

  Vue.js のプラグインをインストールします。plugin がオブジェクトならば、それは `install` メソッドを実装していなければなりません。それ自身が関数ならば、それは install メソッドとして扱われます。install メソッドは、Vue を引数として呼び出されます。

  このメソッドが同じプラグインで複数呼ばれるとき、プラグインは一度だけインストールされます。

- **参照:** [プラグイン](/guide/plugins.html)

<h3 id="Vue-mixin">Vue.mixin( mixin )</h3>

- **引数:**
  - `{Object} mixin`

- **使用方法:**

  全ての Vue インスタンスが作成された後に影響を及ぼす、ミックスイン (mixin) をグローバルに適用します。これは、コンポーネントにカスタム動作を注入するために、プラグイン作成者によって使用することができます。**アプリケーションコードでの使用は推奨されません。**

- **参照:** [グローバルミックスイン](/guide/mixins.html#グローバルミックスイン)

<h3 id="Vue-compile">Vue.compile( template )</h3>

- **引数:**
  - `{string} template`

- **使用方法:**

  テンプレート文字列を render 関数にコンパイルします。**スタンダアロンビルドだけ利用できます。**

  ``` js
  var res = Vue.compile('<div><span>{{ msg }}</span></div>')

  new Vue({
    data: {
      msg: 'hello'
    },
    render: res.render,
    staticRenderFns: res.staticRenderFns
  })
  ```

- **参照:** [Render 関数](/guide/render-function.html)

## オプション / データ

### data

- **型:** `Object | Function`

- **制約:** コンポーネント定義の中で使用する場合は、`Function` タイプのみを受け付けます。

- **詳細:**

  Vue インスタンスのためのデータオブジェクトです。Vue.js は再帰的にインスタンスのプロパティを getter/setter に変換し、"リアクティブ" にします。**オブジェクトはプレーンなものでなければなりません。** ブラウザの API オブジェクトのようなネイティブオブジェクトやプロトタイププロパティは無視されます。経験則としては、データはデータになるべきです。自身で状態を持つ振舞いによってオブジェクトを監視することは推奨されません。

  一度監視されると、もはやルータなデータオブジェクトに対してリアクティブプロパティを追加することはできません。それゆえ、インスタンスを作成する前に、前もって全てのルートレベルのリアクティブプロパティを宣言することを推奨します。

  インスタンスの作成後、元のデータオブジェクトは `vm.$data` としてアクセスすることができます。Vue インスタンスはデータオブジェクト上に見つかったすべてのプロパティに代理アクセスします。

  Vue の内部的なプロパティや API メソッドと衝突する可能性があるため、`_` または `$` から始まるプロパティは Vue インスタンスにプロキシ**されない**ことに注意してください。それらは `vm.$data._property` としてアクセスできます。

  **コンポーネント**を定義しているとき、同じ定義を使用して作成された多くのインスタンスがあるため、`data` は初期データオブジェクトを返す関数として宣言しなければなりません。まだ、`data` に対してプレーンなオブジェクトを使用している場合、同じオブジェクトが作成された全てのインスタンス全体を横断して**参照によって共有**されます！`data` 関数を提供することによって、新しいインスタンスが作成される度に、単にそれは初期データの新しいコピーを返すための関数として呼びだすことができます。

  必要に応じて、オリジナルなデータオブジェクトの深いコピー (deep clone) は `vm.$data` を渡すことによって `JSON.parse(JSON.stringify(...))` を通して得ることができます。

- **例:**

  ``` js
  var data = { a: 1 }

  // インスタンスを直接生成
  var vm = new Vue({
    data: data
  })
  vm.a // -> 1
  vm.$data === data // -> true

  // Vue.extend() 内では、関数を使わなければいけない
  var Component = Vue.extend({
    data: function () {
      return { a: 1 }
    }
  })
  ```

- **参照:** [リアクティブの探求](/guide/reactivity.html)

### props

- **型:** `Array<string> | Object`

- **詳細:**

  親コンポーネントからデータを受け取るためにエクスポートされた属性のリスト/ハッシュです。シンプルな配列ベースの構文、そして型チェック、カスタム検証そしてデフォルト値などの高度な構成を可能とする配列ベースの代わりとなるオブジェクトベースの構文があります。

- **例:**

  ``` js
  // シンプルな構文
  Vue.component('props-demo-simple', {
    props: ['size', 'myMessage']
  })

  // バリデーション付きのオブジェクト構文
  Vue.component('props-demo-advanced', {
    props: {
      // 単なる型チェック
      height: Number,
      // 型チェックとその他のバリデーション
      age: {
        type: Number,
        default: 0,
        required: true,
        validator: function (value) {
          return value >= 0
        }
      }
    }
  })
  ```

- **参照:** [Props](/guide/components.html#Props)

### propsData

- **型:** `{ [key: string]: any }`

- **制約:** `new` 経由でインスタンス作成のみだけなので注意してください。

- **詳細:**

  インスタン作成中に props に渡します。これは、主に単体テストを簡単にするのを目的としています。

- **例:**

  ``` js
  var Comp = Vue.extend({
    props: ['msg'],
    template: '<div>{{ msg }}</div>'
  })

  var vm = new Comp({
    propsData: {
      msg: 'hello'
    }
  })
  ```

### computed

- **型:** `{ [key: string]: Function | { get: Function, set: Function } }`

- **詳細:**

  Vue インスタンスに組み込まれる算出プロパティ (Computed property) です。すべての getter や setter は、自動的に Vue インスタンスにバインドされた `this` コンテキストを持ちます。

  算出プロパティはキャッシュされ、そしてリアクティブ依存が変更されたときにだけ再算出します。

- **例:**

  ```js
  var vm = new Vue({
    data: { a: 1 },
    computed: {
      // get のみ。必要なのは関数一つだけ
      aDouble: function () {
        return this.a * 2
      },
      // get と set 両方
      aPlus: {
        get: function () {
          return this.a + 1
        },
        set: function (v) {
          this.a = v - 1
        }
      }
    }
  })
  vm.aPlus   // -> 2
  vm.aPlus = 3
  vm.a       // -> 2
  vm.aDouble // -> 4
  ```

- **参照:**
  - [算出プロパティ](/guide/computed.html)

### methods

- **型:** `{ [key: string]: Function }`

- **詳細:**

  Vue インスタンスに組み込まれるメソッドです。VM インスタンスでは、これらのメソッドに直接アクセスでき、ディレクティブの式で使用することもできます。すべてのメソッドは、Vue インスタンスに自動的にバインドされた `this` コンテキストを持ちます。

- **例:**

  ```js
  var vm = new Vue({
    data: { a: 1 },
    methods: {
      plus: function () {
        this.a++
      }
    }
  })
  vm.plus()
  vm.a // 2
  ```

- **参照:** [イベントの購読](/guide/events.html)

### watch

- **型:** `{ [key: string]: string | Function | Object }`

- **詳細:**

  キーが監視する評価式で、値が対応するコールバックをもつオブジェクトです。値はメソッド名の文字列、または追加のオプションが含まれているオブジェクトを取ることができます。Vue インスタンスはインスタンス化の際にオブジェクトの各エントリに対して `$watch()` を呼びます。


- **例:**

  ``` js
  var vm = new Vue({
    data: {
      a: 1
    },
    watch: {
      'a': function (val, oldVal) {
        console.log('new: %s, old: %s', val, oldVal)
      },
      // 文字列メソッド名
      'b': 'someMethod',
      // 深いウオッチャ (watcher)
      'c': {
        handler: function (val, oldVal) { /* ... */ },
        deep: true
      }
    }
  })
  vm.a = 2 // -> new: 2, old: 1
  ```

- **参照:** [インスタンスメソッド - vm.$watch](#vm-watch)

## オプション / DOM

### el

- **型:** `string | HTMLElement`

- **制約:** `new` 経由でインスタンス作成のみだけなので注意してください。

- **詳細:**

  既存の DOM 要素に Vue インスタンスを与えます。CSS セレクタの文字列、実際の HTML 要素をとることができます。

  インスタンスがマウント後、解決された要素は `vm.$el` としてアクセス可能になります。

  インスタンス化の際にオプションが有効ならば、そのインスタンスはただちにコンパイルの段階に入ります。さもなければ、ユーザーがコンパイルを始めるために手作業で明示的に `vm.$mount()` を呼ぶ必要があります。

  <p class="tip">与えられた要素は単にマウントするポイントとして機能します。Vue 1.x とは異なり、マウントされた要素は、全てのケースで Vue によって生成された DOM に置き換えられます。従って、ルートインスタンスを `<html>` または `<body>` にマウントすることは推奨されません。</p>

- **参照:** [ライフサイクルダイアグラム](/guide/instance.html#ライフサイクルダイアグラム)

### template

- **型:** `string`

- **詳細:**

  Vue インスタンスに対してマークアップとして使用するための、文字列のテンプレートです。テンプレートはマウントされた要素として**置換**されます。コンテンツ挿入 slot がテンプレートの中にない限り、マウントされた要素内部のあらゆる既存のマークアップは無視されます。

  `#` による文字列で始まる場合、querySelector として使用され、選択された要素の innerHTML をテンプレート文字列として使用します。これにより、テンプレートを組み込むための共通の `<script type="x-template">` というやり方を使うことができるようになります。

  <p class="tip">セキュリティの観点から、信頼できる Vue のテンプレートだけ使用するべきです。決してユーザーによって生成されたコンテンツをテンプレートとして使用しないでください。</p>

- **参照:**
  - [ライフサイクルダイアグラム](/guide/instance.html#ライフサイクルダイアグラム)
  - [コンテンツ配信](/guide/components.html#スロットによるコンテンツ配信)

### render

- **型:** `Function`

- **詳細:**

  JavaScript による完全なプログラミングパワーを活用するために文字列テンプレートの代替として許可します。render 関数は、`VNode` を作成するために最初の引数として `createElement` メソッドを受け取ります

  コンポーネントが関数型コンポーネントならば、render 関数は、関数型コンポーネントが状態を持たないため、コンテキストなデータにアクセスするために提供する `context` を追加の引数として受け取ります。

- **参照:**
  - [Render 関数](/guide/render-function)

## オプション / ライフサイクルフック

### beforeCreate

- **型:** `Function`

- **詳細:**

  データの監視とイベント/ウォッチャのセットアップより前の、インスタンスが初期化されるときに同期的に呼ばれます。

- **参照:** [ライフサイクルダイアグラム](/guide/instance.html#ライフサイクルダイアグラム)

### created

- **型:** `Function`

- **詳細:**

  インスタンスが作成された後に同期的に呼ばれます。この段階では、インスタンスは、データ監視、算出プロパティ、メソッド、watch/event コールバックらのオプションのセットアップ処理が完了したことを意味します。しかしながら、マウンティングの段階は未開始で、`$el` プロパティはまだ利用できません。

- **参照:** [ライフサイクルダイアグラム](/guide/instance.html#ライフサイクルダイアグラム)

### beforeMount

- **型:** `Function`

- **詳細:**

  `render` 関数が初めて呼び出されようと、マウンティングが開始される直前に呼ばれます。

  **このフックはサーバサイドレンダリングでは呼ばれません。**

- **参照:** [ライフサイクルダイアグラム](/guide/instance.html#ライフサイクルダイアグラム)

### mounted

- **型:** `Function`

- **詳細:**

  インスタンスが `el` は新たに作成された `vm.$el` によって置換されたちょうどマウントされた後に呼ばれます。ルートインスタンスがドキュメントの中の要素にマウントされる場合、`vm.$el` は `mounted` が呼び出されるときにドキュメントに入ります。

  **このフックはサーバサイドレンダリングでは呼ばれません。**

- **参照:** [ライフサイクルダイアグラム](/guide/instance.html#ライフサイクルダイアグラム)

### beforeUpdate

- **型:** `Function`

- **詳細:**

  データが変更されるとき、仮想DOM は再レンダリングそしてパッチを適用する前に呼ばれます。

  このフックでさらに状態を変更することができ、それらは追加で再レンダリングのトリガーになりません。

  **このフックはサーバサイドレンダリングでは呼ばれません。**

- **参照:** [ライフサイクルダイアグラム](/guide/instance.html#ライフサイクルダイアグラム)

### updated

- **型:** `Function`

- **詳細:**

  データが変更後、仮想 DOM が再レンダリングそしてパッチを適用によって呼ばれます。

  このフックが呼び出されるとき、コンポーネントの DOM は更新した状態になり、このフックで DOM に依存する操作を行うことができます。しかしがながら、ほとんどの場合、無限更新ループに陥る可能性があるため、このフックでは状態を変更するのを回避すべきです。

  **このフックはサーバサイドレンダリングでは呼ばれません。**

- **参照:** [ライフサイクルダイアグラム](/guide/instance.html#ライフサイクルダイアグラム)

### activated

- **型:** `Function`

- **詳細:**

  生き続けたコンポーネントが活性化するとき呼ばれます。

  **このフックはサーバサイドレンダリングでは呼ばれません。**

- **参照:**
  - [組み込みコンポーネント - keep-alive](#keep-alive)
  - [動的コンポーネント - keep-alive](/guide/components.html#keep-alive)

### deactivated

- **型:** `Function`

- **詳細:**

  生き続けたコンポーネントが非活性化するとき呼ばれます。

  **このフックはサーバサイドレンダリングでは呼ばれません。**

- **参照:**
  - [組み込みコンポーネント - keep-alive](#keep-alive)
  - [動的コンポーネント - keep-alive](/guide/components.html#keep-alive)

### beforeDestroy

- **型:** `Function`

- **詳細:**

  Vue インスタンスが破棄される直前に呼ばれます。この段階ではインスタンスはまだ完全に機能しています。

  **このフックはサーバサイドレンダリングでは呼ばれません。**

- **参照:** [ライフサイクルダイアグラム](/guide/instance.html#ライフサイクルダイアグラム)

### destroyed

- **型:** `Function`

- **詳細:**

  Vue インスタンスが破棄された後に呼ばれます。このフックが呼ばれるとき、Vue インスタンスの全てのディレクティブはバウンドしておらず、全てのイベントリスナは削除されており、そして全ての子の Vue インスタンスは破棄されています。

  **このフックはサーバサイドレンダリングでは呼ばれません。**

- **参照:** [ライフサイクルダイアグラム](/guide/instance.html#ライフサイクルダイアグラム)

## オプション / アセット

### directives

- **型:** `Object`

- **詳細:**

  Vue インスタンスで利用可能なディレクティブのハッシュです。

- **参照:**
  - [カスタムディレクティブ](/guide/custom-directive.html)
  - [アセットの命名規則](/guide/components.html#アセットの命名規則)

### filters

- **型:** `Object`

- **詳細:**

  Vue インスタンスで利用可能なフィルタのハッシュです。

- **参照:**
  - [カスタムフィルタ](/guide/custom-filter.html)
  - [アセットの命名規則](/guide/components.html#アセットの命名規則)

### components

- **型:** `Object`

- **詳細:**

  Vue インスタンスで利用可能なコンポーネントのハッシュです。

- **参照:**
  - [コンポーネント](/guide/components.html)

## オプション / その他

### parent

- **型:** `Vue instance`

- **詳細:**

  作成されるインスタンスの親インスタンスを指定します。2つのインスタンス間で親子関係を確立します。親は子の `this.$parent` としてアクセス可能となり、子は親の `$children` 配列に追加されます。

  <p class="tip">`$parent` と `$children` の使用は控えてください。これらはどうしても避けられないときに使用します。親子感の通信に対して props と イベントを使用すべきです。</p>

### mixins

- **型:** `Array<Object>`

- **詳細:**

  `mixins` オプションは、ミックスインオブジェクトの配列を受け入れます。ミックスインオブジェクトは、通常のインスタンスオブジェクトのようなインスタンスオプションを含むことができ、`Vue.extend()` における同じオプションを併合するロジックを使った結果のオプションに対して併合されます。例えば、あなたのミックスインが作成されたフックをもち、コンポーネントそのものもそれを持っていた場合、両方の関数が呼ばれます。

  ミックスインのフックはそれらが提供された順に呼び出され、コンポーネント自身のフックの前に呼び出されます。

- **例:**

  ``` js
  var mixin = {
    created: function () { console.log(1) }
  }
  var vm = new Vue({
    created: function () { console.log(2) },
    mixins: [mixin]
  })
  // -> 1
  // -> 2
  ```

- **参照:** [ミックスイン](/guide/mixins.html)

### name

- **型:** `string`

- **制約:** コンポーネントのオプションで使われたときのみ、有効なので注意してください。

- **詳細:**

  テンプレート内でのコンポーネント自身の再帰呼び出しを許可します。コンポーネントは `Vue.component()` でグローバルに登録され、グローバル ID はその名前に自動的に設定される事に注意してください。

  `name` オプションのもう1つの利点は、デバッギングです。名前付きコンポーネントはより便利な警告メッセージが表示されます。また、Vue devtool でアプリケーションを検査するとき、名前付きでないコンポーネントは `<AnonymousComponent>` として表示され、とても有益ではありません。`name` オプションの提供によって、はるかに有益なコンポーネントツリーを取得できるでしょう。

### extends

- **型:** `Object | Function`

- **詳細:**

  `Vue.extend` を使用しなくても、別のコンポーネントを宣言的に拡張できます(純粋なオプションオブジェクトまたはコンストラクタのどちらでも構いません)。これは主に単一ファイルコンポーネントにおいて簡単に拡張するのを目的としています。

  これは `mixins` に似ており、違いは、コンポーネント自身のオプションは、元のコンポーネントが拡張されているものよりも優先するというのが違いです。

- **例:**

  ``` js
  var CompA = { ... }

  // CompA を Vue.extend の呼び出しなしで拡張する
  var CompB = {
    extends: CompA,
    ...
  }
  ```

### delimiters

- **型:** `Array<string>`

- **デフォルト:** `["{{", "}}"]`

- **詳細:**

  プレーンテキスト展開デリミタを変更します。**このオプションはスタンダアロンビルドでのみ利用可能です。**

- **例:**

  ``` js
  new Vue({
    delimiters: ['${', '}']
  })

  // デリミタを ES6 template string のスタイルに変更する
  ```

### functional

- **型:** `boolean`

- **詳細:**

  状態を持たない (`data` なし) そしてインスタンスを持たない (`this` コンテキストなし)コンポーネントにするかどうか設定します。レンダリングするために仮想ノードを遥かに安価に作成しそれらを返す単純な`render` 関数を実装する必要があります。

- **参照:** [関数型コンポーネント](/guide/render-function.html#関数型コンポーネント)

## インスタンスプロパティ

### vm.$data

- **型:** `Object`

- **詳細:**

  TODO:
  Vue インスタンスが監視しているデータオブジェクトです。Vue インスタンスプロキシはデータオブジェクトのプロパティにアクセスします。
  The data object that the Vue instance is observing. You can swap it with a new object. The Vue instance proxies access to the properties on its data object.

- **参照:** [オプション - データ](#data)

### vm.$el

- **型:** `HTMLElement`

- **読み込みのみ**

- **詳細:**

  Vue インスタンスが管理している ルートな DOM 要素。

### vm.$options

- **型:** `Object`

- **読み込みのみ**

- **詳細:**

  現在の Vue インスタンスのためのインストールオプションとして使われます。これはオプションにカスタムプロパティを含めたいとき便利です:

  ``` js
  new Vue({
    customOption: 'foo',
    created: function () {
      console.log(this.$options.customOption) // -> 'foo'
    }
  })
  ```

### vm.$parent

- **型:** `Vue instance`

- **読み込みのみ**

- **詳細:**

  現在のインスタンスが1つ持つ場合は、親のインスタンス。

### vm.$root

- **型:** `Vue instance`

- **読み込みのみ**

- **詳細:**

  現在のコンポーネントツリーのルート Vue インスタンス。現在のインスタンスが親ではない場合、この値はそれ自身でしょう。

### vm.$children

- **型:** `Array<Vue instance>`

- **読み込みのみ**

- **詳細:**

  現在のインスタンスの直接的な子コンポーネント。**`$children` に対して順序の保証がなく、リアクティブでないことに注意してください。**あなた自身、データバインディングに対して `$children` を使用するためにそれを見つけようとする場合、子コンポーネントを生成するために配列と `v-for` を使用することを検討し、正しいソースとして配列を使用してください。

### vm.$slots

- **型:** `Object`

- **読み込みのみ**

- **デフォルト:**

  [slot よる配信された](/guide/components.html#Slotによるコンテンツ配信) コンテンツにアクセスするために使用されます。各[名前付き slot](/guide/components.html#名前付きSlot) は自身に対応するプロパティを持ちます (例: `slot="foo"` のコンテンツは `vm.$slots.foo` で見つかります)。`default` プロパティは名前付き slot に含まれない任意のノードを含みます。

  `vm.$slots` のアクセスは、[render 関数](/guide/render-function.html) によるコンポーネントを書くときに最も便利です。

- **例:**

  ```html
  <blog-post>
    <h1 slot="header">
      About Me
    </h1>

    <p>Here's some page content, which will be included in vm.$slots.default, because it's not inside a named slot.</p>

    <p slot="footer">
      Copyright 2016 Evan You
    </p>

    <p>If I have some content down here, it will also be included in vm.$slots.default.</p>.
  </blog-post>
  ```

  ```js
  Vue.component('blog-post', {
    render: function (createElement) {
      var header = this.$slots.header
      var body   = this.$slots.default
      var footer = this.$slots.footer
      return createElement('div', [
        createElement('header', header)
        createElement('main', body)
        createElement('footer', footer)
      ])
    }
  })
  ```

- **参照:**
  - [`<slot>` コンポーネント](#slot)
  - [Slot によるコンテンツ配信](/guide/components.html#Slotsによるコンテンツ配信)
  - [Render 関数](/guide/render-function.html)

### vm.$refs

- **型:** `Object`

- **読み込みのみ**

- **詳細:**

  `ref` によって登録された子コンポーネントを保持するオブジェクト。

- **参照:**
  - [Child Component Refs](/guide/components.html#Child-Component-Refs)
  - [ref](#ref)

### vm.$isServer

- **型:** `boolean`

- **読み込みのみ**

- **詳細:**

  現在の Vue インスタンスがサーバ上で動作しているかどうか。

- **参照:** [サーバサイドレンダリング](/guide/ssr.html)

## インスタンスメソッド / データ

<h3 id="vm-watch">vm.$watch( expOrFn, callback, [options] )</h3>

- **引数:**
  - `{string | Function} expOrFn`
  - `{Function} callback`
  - `{Object} [options]`
    - `{boolean} deep`
    - `{boolean} immediate`

- **戻り値:** `{Function} unwatch`

- **使用方法:**

  Vue インスタンス上でのひとつの式または算出関数 (computed function) の変更を監視します。コールバックは新しい値と古い値とともに呼びだされます。引数の式には、単一の keypath か、任意の有効なバインディング式を入れることができます。

<p class="tip">オブジェクトまたは配列を変更する(というよりむしろ置換する)とき、それらは同じオブジェクト/配列を参照するため、古い値は新しい値と同じになることに注意してください。Vue は変更前の値のコピーしません。</p>

- **例:**

  ``` js
  // キーパス
  vm.$watch('a.b.c', function (newVal, oldVal) {
    // 何かの処理
  })

  // 式
  vm.$watch('a + b', function (newVal, oldVal) {
    // 何かの処理
  })

  // 関数
  vm.$watch(
    function () {
      return this.a + this.b
    },
    function (newVal, oldVal) {
      // 何かの処理
    }
  )
  ```

  `vm.$watch` はコールバックの実行を停止する unwatch 関数を返します。

  ``` js
  var unwatch = vm.$watch('a', cb)
  // 後で watcher を破棄する
  unwatch()
  ```

- **任意: deep**

  オブジェクトの中のネストされた値の変更を検出するには、options 引数に `deep: true` を渡す必要があります。Array の値の変更は、リッスンする必要はないことに注意してください。

  ``` js
  vm.$watch('someObject', callback, {
    deep: true
  })
  vm.someObject.nestedValue = 123
  // コールバックが発火する
  ```

- **任意: immediate**

  options 引数に `immediate: true` を渡すと、その時の式の値で、コールバックが直ちに実行されます:

  ``` js
  vm.$watch('a', callback, {
    immediate: true
  })
  // その時の `a` の値でコールバックがただちに発火します
  ```

<h3 id="vm-set">vm.$set( object, key, value )</h3>

- **引数:**
  - `{Object} object`
  - `{string} key`
  - `{any} value`

- **戻り値:** 設定した値

- **使用方法:**

  これはグローバルメソッド `Vue.set` の**エイリアス**です。

- **参照:** [Vue.set](#Vue-set)

<h3 id="vm-delete">vm.$delete( object, key )</h3>

- **引数:**
  - `{Object} object`
  - `{string} key`

- **使用方法:**

  これはグローバルメソッド `Vue.delete` の**エイリアス**です。

- **参照:** [Vue.delete](#Vue-delete)

## インスタンスメソッド / イベント

<h3 id="vm-on">vm.$on( event, callback )</h3>

- **引数:**
  - `{string} event`
  - `{Function} callback`

- **使用方法:**

  現在の vm 上のイベントを監視します。イベントは `vm.$emit` によってトリガすることができます。それらのイベントトリガを行うメソッドに渡した追加の引数は、コールバックがすべて受け取ります。

- **例:**

  ``` js
  vm.$on('test', function (msg) {
    console.log(msg)
  })
  vm.$emit('test', 'hi')
  // -> "hi"
  ```

<h3 id="vm-once">vm.$once( event, callback )</h3>

- **引数:**
  - `{string} event`
  - `{Function} callback`

- **使用方法:**

  一度きりのイベントリスナを提供します。リスナは最初にトリガされた時に削除されます。

<h3 id="vm-off">vm.$off( [event, callback] )</h3>

- **引数:**
  - `{string} [event]`
  - `{Function} [callback]`

- **使用方法:**

  イベントリスナを削除します。

  - 引数が与えられなければ、すべてのイベントリスナを削除します。

  - イベントがひとつだけ与えられたら、そのイベントに関するすべてのイベントリスナを削除します。

  - イベントとコールバックの両方が与えられたら、その特定のコールバックに対するイベントリスナのみを削除します。

<h3 id="vm-emit">vm.$emit( event, [...args] )</h3>

- **引数:**
  - `{string} event`
  - `[...args]`

  現在のインスタンス上のイベントをトリガします。追加の引数はリスナのコールバックファンクションに渡されます。

## インスタンスメソッド / ライフサイクル

<h3 id="vm-mount">vm.$mount( [elementOrSelector] )</h3>

- **引数:**
  - `{Element | string} [elementOrSelector]`
  - `{boolean} [hydrating]`

- **戻り値:** `vm` - インスタンス自身

- **使用方法:**

  Vue インスタンスがインスタンス化において `el` オプションを受け取らない場合は、DOM 要素は関連付けなしで、"アンマウント(マウントされていない)" 状態になります。`vm.$mount()` は アンマウントな Vue インスタンスのマウンティングを手動で開始するために使用することができます。

  `elementOrSelector` 引数が提供されない場合、テンプレートはドキュメント要素外でレンダリングされ、あなた自身ドキュメントにそれを挿入するためにネイティブ DOM API を使用しなければなりません。

  メソッドはインスタンス自身返し、その後に他のインスタンスメソッドをチェインすることができます。

- **例:**

  ``` js
  var MyComponent = Vue.extend({
    template: '<div>Hello!</div>'
  })

  // インスタンスを生成し、#app にマウント(#app を置換) します
  new MyComponent().$mount('#app')

  // 上記と同じです:
  new MyComponent({ el: '#app' })

  // また、ドキュメント外でレンダリングし、その後加えます。
  var component = new MyComponent().$mount()
  document.getElementById('app').appendChild(vm.$el)
  ```

- **参照:**
  - [ライフサイクルダイアグラム](/guide/instance.html#ライフサイクルダイアグラム)
  - [サーバサイドレンダリング](/guide/ssr.html)

<h3 id="vm-forceUpdate">vm.$forceUpdate()</h3>

- **Usage:**

  Force the Vue instance to re-render. Note it does not affect all child components, only the instance itself and child components with inserted slot content.

<h3 id="vm-nextTick">vm.$nextTick( callback )</h3>

- **Arguments:**
  - `{Function} callback`

- **Usage:**

  Defer the callback to be executed after the next DOM update cycle. Use it immediately after you've changed some data to wait for the DOM update. This is the same as the global `Vue.nextTick`, except that the callback's `this` context is automatically bound to the instance calling this method.

- **Example:**

  ``` js
  new Vue({
    // ...
    methods: {
      // ...
      example: function () {
        // modify data
        this.message = 'changed'
        // DOM is not updated yet
        this.$nextTick(function () {
          // DOM is now updated
          // `this` is bound to the current instance
          this.doSomethingElse()
        })
      }
    }
  })
  ```

- **See also:**
  - [Vue.nextTick](#Vue-nextTick)
  - [Async Update Queue](/guide/reactivity.html#Async-Update-Queue)

<h3 id="vm-destroy">vm.$destroy()</h3>

- **Usage:**

  Completely destroy a vm. Clean up its connections with other existing vms, unbind all its directives, turn off all event listeners.

  Triggers the `beforeDestroy` and `destroyed` hooks.

  <p class="tip">In normal use cases you shouldn't have to call this method yourself. Prefer controlling the lifecycle of child components in a data-driven fashion using `v-if` and `v-for`.</p>

- **See also:** [Lifecycle Diagram](/guide/instance.html#Lifecycle-Diagram)

## Directives

### v-text

- **Expects:** `string`

- **Details:**

  Updates the element's `textContent`. If you need to update the part of `textContent`, you should use `{% raw %}{{ Mustache }}{% endraw %}` interpolations.

- **Example:**

  ```html
  <span v-text="msg"></span>
  <!-- same as -->
  <span>{{msg}}</span>
  ```

- **See also:** [Data Binding Syntax - interpolations](/guide/syntax.html#Text)

### v-html

- **Expects:** `string`

- **Details:**

  Updates the element's `innerHTML`. **Note that the contents are inserted as plain HTML - they will not be compiled as Vue templates**. If you find yourself trying to compose templates using `v-html`, try to rethink the solution by using components instead.

  <p class="tip">Dynamically rendering arbitrary HTML on your website can be very dangerous because it can easily lead to [XSS attacks](https://en.wikipedia.org/wiki/Cross-site_scripting). Only use `v-html` on trusted content and **never** on user-provided content.</p>

- **Example:**

  ```html
  <div v-html="html"></div>
  ```
- **See also:** [Data Binding Syntax - interpolations](/guide/syntax.html#Raw-HTML)

### v-if

- **Expects:** `any`

- **Usage:**

  Conditionally render the element based on the truthy-ness of the expression value. The element and its contained directives / components are destroyed and re-constructed during toggles. If the element is a `<template>` element, its content will be extracted as the conditional block.

  This directive triggers transitions when its condition changes.

- **See also:** [Conditional Rendering - v-if](/guide/conditional.html)

### v-show

- **Expects:** `any`

- **Usage:**

  Toggle's the element's `display` CSS property based on the truthy-ness of the expression value.

  This directive triggers transitions when its condition changes.

- **See also:** [Conditional Rendering - v-show](/guide/conditional.html#v-show)

### v-else

- **Does not expect expression**

- **Restriction:** previous sibling element must have `v-if`.

- **Usage:**

  Denote the "else block" for `v-if`.

  ```html
  <div v-if="Math.random() > 0.5">
    Now you see me
  </div>
  <div v-else>
    Now you don't
  </div>
  ```

- **See also:**
  - [Conditional Rendering - v-else](/guide/conditional.html#v-else)

### v-for

- **Expects:** `Array | Object | number | string`

- **Usage:**

  Render the element or template block multiple times based on the source data. The directive's value must use the special syntax `alias in expression` to provide an alias for the current element being iterated on:

  ``` html
  <div v-for="item in items">
    {{ item.text }}
  </div>
  ```

  Alternatively, you can also specify an alias for the index (or the key if used on an Object):

  ``` html
  <div v-for="(item, index) in items"></div>
  <div v-for="(key, val) in object"></div>
  <div v-for="(key, val, index) in object"></div>
  ```

  The default behavior of `v-for` will try to patch the elements in-place without moving them. To force it to reorder elements, you need to provide an ordering hint with the `key` special attribute:

  ``` html
  <div v-for="item in items" :key="item.id">
    {{ item.text }}
  </div>
  ```

  The detailed usage for `v-for` is explained in the guide section linked below.

- **See also:**
  - [List Rendering](/guide/list.html)
  - [key](/guide/list.html#key)

### v-on

- **Shorthand:** `@`

- **Expects:** `Function | Inline Statement`

- **Argument:** `event (required)`

- **Modifiers:**
  - `.stop` - call `event.stopPropagation()`.
  - `.prevent` - call `event.preventDefault()`.
  - `.capture` - add event listener in capture mode.
  - `.self` - only trigger handler if event was dispatched from this element.
  - `.{keyCode | keyAlias}` - only trigger handler on certain keys.
  - `.native` - listen for a native event on the root element of component.

- **Usage:**

  Attaches an event listener to the element. The event type is denoted by the argument. The expression can either be a method name or an inline statement, or simply omitted when there are modifiers present.

  When used on a normal element, it listens to **native DOM events** only. When used on a custom element component, it also listens to **custom events** emitted on that child component.

  When listening to native DOM events, the method receives the native event as the only argument. If using inline statement, the statement has access to the special `$event` property: `v-on:click="handle('ok', $event)"`.

- **Example:**

  ```html
  <!-- method handler -->
  <button v-on:click="doThis"></button>

  <!-- inline statement -->
  <button v-on:click="doThat('hello', $event)"></button>

  <!-- shorthand -->
  <button @click="doThis"></button>

  <!-- stop propagation -->
  <button @click.stop="doThis"></button>

  <!-- prevent default -->
  <button @click.prevent="doThis"></button>

  <!-- prevent default without expression -->
  <form @submit.prevent></form>

  <!-- chain modifiers -->
  <button @click.stop.prevent="doThis"></button>

  <!-- key modifier using keyAlias -->
  <input @keyup.enter="onEnter">

  <!-- key modifier using keyCode -->
  <input @keyup.13="onEnter">
  ```

  Listening to custom events on a child component (the handler is called when "my-event" is emitted on the child):

  ```html
  <my-component @my-event="handleThis"></my-component>

  <!-- inline statement -->
  <my-component @my-event="handleThis(123, $event)"></my-component>

  <!-- native event on component -->
  <my-component @click.native="onClick"></my-component>
  ```

- **See also:**
  - [Methods and Event Handling](/guide/events.html)
  - [Components - Custom Events](/guide/components.html#Custom-Events)

### v-bind

- **Shorthand:** `:`

- **Expects:** `any (with argument) | Object (without argument)`

- **Argument:** `attrOrProp (optional)`

- **Modifiers:**
  - `.prop` - Used for binding DOM attributes.

- **Usage:**

  Dynamically bind one or more attributes, or a component prop to an expression.

  When used to bind the `class` or `style` attribute, it supports additional value types such as Array or Objects. See linked guide section below for more details.

  When used for prop binding, the prop must be properly declared in the child component.

  When used without an argument, can be used to bind an object containing attribute name-value pairs. Note in this mode `class` and `style` does not support Array or Objects.

- **Example:**

  ```html
  <!-- bind an attribute -->
  <img v-bind:src="imageSrc">

  <!-- shorthand -->
  <img :src="imageSrc">

  <!-- class binding -->
  <div :class="{ red: isRed }"></div>
  <div :class="[classA, classB]"></div>
  <div :class="[classA, { classB: isB, classC: isC }]">

  <!-- style binding -->
  <div :style="{ fontSize: size + 'px' }"></div>
  <div :style="[styleObjectA, styleObjectB]"></div>

  <!-- binding an object of attributes -->
  <div v-bind="{ id: someProp, 'other-attr': otherProp }"></div>

  <!-- DOM attribute binding with prop modifier -->
  <div v-bind:text-content.prop="text"></div>

  <!-- prop binding. "prop" must be declared in my-component. -->
  <my-component :prop="someThing"></my-component>

  <!-- XLink -->
  <svg><a :xlink:special="foo"></a></svg>
  ```

- **See also:**
  - [Class and Style Bindings](/guide/class-and-style.html)
  - [Components - Component Props](/guide/components.html#Props)

### v-model

- **Expects:** varies based on value of form inputs element or output of components

- **Limited to:**
  - `<input>`
  - `<select>`
  - `<textarea>`
  - components

- **Modifiers:**
  - [`.lazy`](/guide/forms.html#lazy) - listen to `change` events instead of `input`
  - [`.number`](/guide/forms.html#number) - cast input string to numbers
  - [`.trim`](/guild/forms.html#trim) - trim input

- **Usage:**

  Create a two-way binding on a form input element or a component. For detailed usage, see guide section linked below.

- **See also:**
  - [Form Input Bindings](/guide/forms.html)
  - [Components - Form Input Components using Custom Events](/guide/components.html#Form-Input-Components-using-Custom-Events)

### v-pre

- **Does not expect expression**

- **Usage**

  Skip compilation for this element and all its children. You can use this for displaying raw mustache tags. Skipping large numbers of nodes with no directives on them can also speed up compilation.

- **Example:**

  ```html
  <span v-pre>{{ this will not be compiled }}</span>
   ```

### v-cloak

- **Does not expect expression**

- **Usage:**

  This directive will remain on the element until the associated Vue instance finishes compilation. Combined with CSS rules such as `[v-cloak] { display: none }`, this directive can be used to hide un-compiled mustache bindings until the Vue instance is ready.

- **Example:**

  ```css
  [v-cloak] {
    display: none;
  }
  ```

  ```html
  <div v-cloak>
    {{ message }}
  </div>
  ```

  The `<div>` will not be visible until the compilation is done.

### v-once

- **Does not expect expression**

- **Details:**

  Render the element and component **once** only. On subsequent re-renders, the element/component and all its children will be treated as static content and skipped. This can be used to optimize update performance.

  ```html
  <!-- single element -->
  <span v-once>This will never change: {{msg}}</span>
  <!-- the element have children -->
  <div v-once>
    <h1>comment</h1>
    <p>{{msg}}</p>
  </div>
  <!-- component -->
  <my-component v-once :comment="msg"></my-component>
  <!-- v-for directive -->
  <ul>
    <li v-for="i in list" v-once>{{i}}</li>
  </ul>
  ```

- **See also:**
  - [Data Binding Syntax - interpolations](/guide/syntax.html#Text)
  - [Components - Cheap Static Components with v-once](/guide/components.html#Cheap-Static-Components-with-v-once)

## Special Attributes

### key

- **Expects:** `string`

  The `key` special attribute is primarily used as a hint for Vue's virtual DOM algorithm to identify VNodes when diffing the new list of nodes against the old list. Without keys, Vue uses an algorithm that minimizes element movement and tries to patch/reuse elements of the same type in-place as much as possible. With keys, it will reorder elements based on the order change of keys, and elements with keys that are no longer present will always be removed/destroyed.

  Children of the same common parent must have **unique keys**. Duplicate keys will cause render errors.

  The most common use case is combined with `v-for`:

  ``` html
  <ul>
    <li v-for="item in items" :key="item.id">...</li>
  </ul>
  ```

  It can also be used to force replacement of an element/component instead of reusing it. This can be useful when you want to:

  - Properly trigger lifecycle hooks of a component
  - Trigger transitions

  For example:

  ``` html
  <transition>
    <span :key="text">{{ text }}</span>
  </transition>
  ```

  When `text` changes, the `<span>` will always be replaced instead of patched, so a transition will be triggered.

### ref

- **Expects:** `string`

  `ref` is used to register a reference to an element or a child component. The reference will be registered under the parent component's `$refs` object. If used on a plain DOM element, the reference will be that element; if used on a child component, the reference will be component instance:

  ``` html
  <!-- vm.$refs.p will the DOM node -->
  <p ref="p">hello</p>

  <!-- vm.$refs.child will be the child comp instance -->
  <child-comp ref="child"></child-comp>
  ```

  When used on elements/components with `v-for`, the registered reference will be an Array containing DOM nodes or component instances.

  An important note about the ref registration timing: because the refs themselves are created as a result of the render function, you cannot access them on the initial render - they don't exist yet! `$refs` is also non-reactive, therefore you should not attempt to use it in templates for data-binding.

- **See also:** [Child Component Refs](/guide/components.html#Child-Component-Refs)

### slot

- **Expects:** `string`

  Used on content inserted into child components to indicate which named slot the content belongs to.

  For detailed usage, see the guide section linked below.

- **See also:** [Named Slots](/guide/components.html#Named-Slots)

## Built-In Components

### component

- **Props:**
  - `is` - string | ComponentDefinition | ComponentConstructor
  - `inline-template` - boolean

- **Usage:**

  A "meta component" for rendering dynamic components. The actual component to render is determined by the `is` prop:

  ```html
  <!-- a dynamic component controlled by -->
  <!-- the `componentId` property on the vm -->
  <component :is="componentId"></component>

  <!-- can also render registered component or component passed as prop -->
  <component :is="$options.components.child"></component>
  ```

- **See also:** [Dynamic Components](/guide/components.html#Dynamic-Components)

### transition

- **Props:**
  - `name` - string, Used to automatically generate transition CSS class names. e.g. `name: 'fade'` will auto expand to `.fade-enter`, `.fade-enter-active`, etc. Defaults to `"v"`.
  - `appear` - boolean, Whether to apply transition on initial render. Defaults to `false`.
  - `css` - boolean, Whether to apply CSS transition classes. Defaults to `true`. If set to `false`, will only trigger JavaScript hooks registered via component events.
  - `type` - string, Specify the type of transition events to wait for to determine transition end timing. Available values are `"transition"` and `"animation"`. By default, it will automatically detect the type that has a longer duration.
  - `mode` - string, Controls the timing sequence of leaving/entering transitions. Available modes are `"out-in"` and `"in-out"`; defaults to simultaneous.
  - `enter-class` - string
  - `leave-class` - string
  - `enter-active-class` - string
  - `leave-active-class` - string
  - `appear-class` - string
  - `appear-active-class` - string

- **Events:**
  - `before-enter`
  - `enter`
  - `after-enter`
  - `before-leave`
  - `leave`
  - `after-leave`
  - `before-appear`
  - `appear`
  - `after-appear`

- **Usage:**

  `<transition>` serve as transition effects for **single** element/component. The `<transition>` does not render an extra DOM element, nor does it show up in the inspected component hierarchy. It simply applies the transition behavior to the wrapped content inside.

  ```html
  <!-- simple element -->
  <transition>
    <div v-if="ok">toggled content</div>
  </transition>

  <!-- dynamic component -->
  <transition name="fade" mode="out-in" appear>
    <component :is="view"></component>
  </transition>

  <!-- event hooking -->
  <div id="transition-demo">
    <transition @after-enter="transitionComplete">
      <div v-show="ok">toggled content</div>
    </transition>
  </div>
  ```

  ``` js
  new Vue({
    ...
    methods: {
      transitionComplete: function (el) {
        // for passed 'el' that DOM element as the argument, something ...
      }
    }
    ...
  }).$mount('#transition-demo')
  ```

- **See also:** [Transitions: Entering, Leaving, and Lists](/guide/transitions.html)

### transition-group

- **Props:**
  - `tag` - string, defaults to `span`.
  - `move-class` - overwrite CSS class applied during moving transition.
  - exposes the same props as `<transition>` except `mode`.

- **Events:**
  - exposes the same events as `<transition>`.

- **Usage:**

  `<transition-group>` serve as transition effects for **multiple** elements/components. The `<transition-group>` renders a real DOM element. By default it renders a `<span>`, and you can configure what element is should render via the `tag` attribute.

  Note every child in a `<transition-group>` must be **uniquely keyed** for the animations to work properly.

  `<transition-group>` supports moving transitions via CSS transform. When a child's position on screen has changed after an updated, it will get applied a moving CSS class (auto generated from the `name` attribute or configured with the `move-class` attribute). If the CSS `transform` property is "transition-able" when the moving class is applied, the element will be smoothly animated to its destination using the [FLIP technique](https://aerotwist.com/blog/flip-your-animations/).

  ```html
  <transition-group tag="ul" name="slide">
    <li v-for="item in items" :key="item.id">
      {{ item.text }}
    </li>
  </transition-group>
  ```

- **See also:** [Transitions: Entering, Leaving, and Lists](/guide/transitions.html)

### keep-alive

- **Usage:**

  When wrapped around a dynamic component, `<keep-alive>` caches the inactive component instances without destroying them. Similar to `<transition>`, `<keep-alive>` is an abstract component: it doesn't render a DOM element itself, and doesn't show up in the component parent chain.

  When a component is toggled inside `<keep-alive>`, its `activated` and `deactivated` lifecycle hooks will be invoked accordingly.

  Primarily used with preserve component state or avoid re-rendering.

  ```html
  <!-- basic -->
  <keep-alive>
    <component :is="view"></component>
  </keep-alive>

  <!-- multiple conditional children -->
  <keep-alive>
    <comp-a v-if="a > 1"></comp-a>
    <comp-b v-else></comp-b>
  </keep-alive>

  <!-- used together with <transition> -->
  <transition>
    <keep-alive>
      <component :is="view"></component>
    </keep-alive>
  </transition>
  ```

  <p class="tip">`<keep-alive>` does not work with functional components because they do not have instances to be cached.</p>

- **See also:** [Dynamic Components - keep-alive](/guide/components.html#keep-alive)

### slot

- **Props:**
  - `name` - string, Used for named slot.

- **Usage:**

  `<slot>` serve as content distribution outlets in component templates. `<slot>` itself will be replaced.

  For detailed usage, see the guide section linked below.

- **See also:** [Content Distribution with Slots](/guide/components.html#Content-Distribution-with-Slots)

## VNode Interface

- Please refer to the [VNode class declaration](https://github.com/vuejs/vue/blob/dev/src/core/vdom/vnode.js).

## Server-Side Rendering

- Please refer to the [vue-server-renderer package documentation](https://github.com/vuejs/vue/tree/dev/packages/vue-server-renderer).
