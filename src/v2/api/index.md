---
title: API
type: api
updated: 2019-07-08
---

## グローバル設定

`Vue.config` は Vue のグローバル設定を含んでいるオブジェクトです。あなたのアプリケーションが読み込まれる前に、下記のプロパティを変更することができます:

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

- **参照:** [カスタムオプションのマージストラテジ](../guide/mixins.html#カスタムオプションのマージストラテジ)

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

- **デフォルト:** `undefined`

- **使用方法:**

  ``` js
  Vue.config.errorHandler = function (err, vm, info) {
    // エラー処理
    // `info` は Vue 固有のエラー情報です（例： どのライフサイクルフックでエラーが起きたかなど）。
    // 2.2.0 以降で使用できます。
  }
  ```

  コンポーネントの描画関数とウォッチャにおいて未捕獲のエラーに対してハンドラを割り当てます。ハンドラはエラーと Vue インスタンスが引数に渡されて呼び出されます。

  > 2.2.0 以降では、このフックは、コンポーネントのライフサイクルフック中のエラーも捉えます。また、このフックが `undefined` の場合、捕捉されたエラーは、アプリケーションをクラッシュさせずに、代わりに `console.error` を用いて記録されます。

  > 2.4.0 以降では、このフックは Vue のカスタムイベントハンドラ内部で投げられたエラーもキャプチャします。

  > 2.6.0 以降では、このフックは `v-on` DOM リスナ内で投げられたエラーもキャプチャします。加えて、フックやハンドラが Promise チェーン (例えば、async 関数) を返す場合、その Promise チェーンからのエラーもハンドリングされます。

  > エラー追跡サービスの [Sentry](https://sentry.io/for/vue/) と [Bugsnag](https://docs.bugsnag.com/platforms/browsers/vue/) はこのオプションを使用して公式の統合を提供しています。

### warnHandler

> 2.4.0 から新規

- **型:** `Function`

- **デフォルト:** `undefined`

- **使用方法:**

  ``` js
  Vue.config.warnHandler = function (msg, vm, trace) {
    // `トレース`はコンポーネント階層のトレースです
  }
  ```

  Vue 実行時の警告に対してカスタムハンドラを割り当てます。これは、開発中のみ動作し、プロダクションでは無視されるので注意してください。

### ignoredElements

- **型:** `Array<string | RegExp>`

- **デフォルト:** `[]`

- **使用方法:**

  ``` js
  Vue.config.ignoredElements = [
    'my-custom-web-component',
    'another-web-component',
    // "ion-" で始まる全ての要素を無視するために `RegExp` を使用する
    // 2.5 以降だけ
    /^ion-/
  ]
  ```

  Vue の外部に定義されたカスタム要素を無視するようにします(例: Web Components の API を使用)。それ以外の場合は、グローバルコンポーネントを登録することを忘れたまたはコンポーネント名のスペルミスしたと仮定すると、`不明なカスタム要素`に関する警告がスローされます。

### keyCodes

- **型:** `{ [key: string]: number | Array<number> }`

- **デフォルト:** `{}`

- **使用方法:**

  ``` js
  Vue.config.keyCodes = {
    v: 86,
    f1: 112,
    // キャメルケースは動作しません
    mediaPlayPause: 179,
    // 代わりに、二重引用符でケバブケースを使用することができます
    "media-play-pause": 179,
    up: [38, 87]
  }
  ```

  ```html
  <input type="text" @keyup.media-play-pause="method">
  ```

  `v-on` 向けにカスタムキーエイリアスを定義します。

### performance

> 2.2.0 から新規

- **型:** `boolean`

- **デフォルト:** `false (2.2.3 から)`

- **使用方法**:

  これを `true` に設定することで、ブラウザの開発者ツールのパフォーマンス/タイムライン機能で、コンポーネントの初期化やコンパイル、描画、パッチのパフォーマンス追跡することが可能になります。 この機能は、開発者モードおよび [performance.mark](https://developer.mozilla.org/en-US/docs/Web/API/Performance/mark) API をサポートするブラウザでのみ動作します。

### productionTip

> 2.2.0 から新規

- **型:** `boolean`

- **デフォルト:** `true`

- **使用方法**:

  これを `false` に設定すると、 Vue の起動時のプロダクションのヒントが表示されなくなります。

## グローバル API

### Vue.extend( options )

- **引数:**
  - `{Object} options`

- **使用方法:**

  Vue コンストラクタベースの "サブクラス" を作成します。引数はコンポーネントオプションを含むオブジェクトにする必要があります。

  ここでの注意すべき特別なケースは、`data` オプションは、これらは `Vue.extend()` で使用されるとき、関数にしなければなりません。

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

- **参照:** [コンポーネント](../guide/components.html)

### Vue.nextTick( [callback, context] )

- **引数:**
  - `{Function} [callback]`
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

  // promise での使用法 (2.1.0 以上、下記の注記を参照してください)
  Vue.nextTick()
    .then(function () {
      // DOM updated
    })
  ```

  > 2.1.0 から新規: コールバックが提供されず、実行環境で Promise がサポートされている場合は Promise を返します。Vue には Promise ポリフィルが付属していないため、Promise をネイティブにサポートしていないブラウザ (IE かどうか確認して) をターゲットにしている場合は、自分でポリフィルを提供する必要があるという点に注意してください。

- **参照:** [非同期更新キュー](../guide/reactivity.html#非同期更新キュー)

### Vue.set( target, propertyName/index, value )

- **引数:**
  - `{Object | Array} target`
  - `{string | number} propertyName/index`
  - `{any} value`

- **戻り値:** 設定した値

- **使用方法:**

  リアクティブオブジェクトにプロパティを追加し、新しいプロパティもリアクティブになることを保証し、View 更新をトリガします。これは、通常、Vue がプロパティの追加 (例: `this.myObject.newProperty = 'hi'`) を検出できないため、リアクティブオブジェクトに新しいプロパティを追加するために使用する必要があります。

  <p class="tip">オブジェクトは Vue インスタンス、または Vue インスタンスのルートな data オブジェクトにできません。</p>

- **参照:** [リアクティブの探求](../guide/reactivity.html)


### Vue.delete( target, propertyName/index )

- **引数:**
  - `{Object | Array} target`
  - `{string | number} propertyName/index`

  > 2.2.0 以降では、 配列とそのインデックスでも動作します。

- **使用方法:**

  オブジェクトのプロパティを削除します。オブジェクトがリアクティブの場合、削除がトリガし View が更新されることを保証します。これは主に Vue がプロパティの削除を検知できないという制約を回避するために使われますが、使う必要があることはまれです。

  <p class="tip">Vue インスタンスや Vue インスタンスのルートデータオブジェクトを対象とすることはできません。</p>

- **参照:** [リアクティブの探求](../guide/reactivity.html)

### Vue.directive( id, [definition] )

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

- **参照:** [カスタムディレクティブ](../guide/custom-directive.html)

### Vue.filter( id, [definition] )

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

- **参照:** [フィルタ](../guide/filters.html)

### Vue.component( id, [definition] )

- **引数:**
  - `{string} id`
  - `{Function | Object} [definition]`

- **使用方法:**

  グローバルコンポーネントに登録または取得します。また登録は、与えられた `id` によって自動的にコンポーネントの `name` に設定されます。

  ``` js
  // 拡張されたコンストラクタを登録
  Vue.component('my-component', Vue.extend({ /* ... */ }))

  // オプションオブジェクトを登録 (Vue.extend を自動的に呼ぶ)
  Vue.component('my-component', { /* ... */ })

  // 登録されたコンポーネントを取得 (常にコンストラクタを返す)
  var MyComponent = Vue.component('my-component')
  ```

- **参照:** [コンポーネント](../guide/components.html)

### Vue.use( plugin )

- **引数:**
  - `{Object | Function} plugin`

- **使用方法:**

  Vue.js のプラグインをインストールします。plugin がオブジェクトならば、それは `install` メソッドを実装していなければなりません。それ自身が関数ならば、それは install メソッドとして扱われます。install メソッドは、Vue を引数として呼び出されます。

  このメソッドは `new Vue()` を呼び出す前に呼び出される必要があります。

  このメソッドが同じプラグインで複数呼ばれるとき、プラグインは一度だけインストールされます。

- **参照:** [プラグイン](../guide/plugins.html)

### Vue.mixin( mixin )

- **引数:**
  - `{Object} mixin`

- **使用方法:**

  全ての Vue インスタンスが作成された後に影響を及ぼす、ミックスイン (mixin) をグローバルに適用します。これは、コンポーネントにカスタム動作を注入するために、プラグイン作成者によって使用することができます。**アプリケーションコードでの使用は推奨されません。**

- **参照:** [グローバルミックスイン](../guide/mixins.html#グローバルミックスイン)

### Vue.compile( template )

- **引数:**
  - `{string} template`

- **使用方法:**

  テンプレート文字列を描画関数にコンパイルします。**完全ビルドだけ利用できます。**

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

- **参照:** [描画関数](../guide/render-function.html)

### Vue.observable( object )

> 2.6.0 から新規

- **引数:**
  - `{Object} object`

- **使用方法:**

  オブジェクトをリアクティブにします。内部的には、Vue は `data` 関数から返されたオブジェクトに対してこれを使っています。

  戻り値のオブジェクトは、[描画関数](../guide/render-function.html) や [算出プロパティ](../guide/computed.html) の中で直接使え、値が変更されたときには適切な更新をトリガーします。単純なシナリオでは、コンポーネントをまたぐ最小の state ストアとして使用することもできます:

  ``` js
  const state = Vue.observable({ count: 0 })

  const Demo = {
    render(h) {
      return h('button', {
        on: { click: () => { state.count++ }}
      }, `count is: ${state.count}`)
    }
  }
  ```

  <p class="tip">Vue 2.x では、`Vue.observable` は渡されたオブジェクトを直接操作するため、[ここでデモされる](../guide/instance.html#データとメソッド) ように戻り値のオブジェクトと等しくなります。Vue 3.x では、代わりにリアクティブプロキシを返し、元のオブジェクトを直接変更してもリアクティブにならないようにします。そのため、将来の互換性を考えると、`Vue.observable` に渡したオブジェクトではなく、返されたオブジェクトを使うことを推奨します。</p>

- **参照:** [リアクティブの探求](../guide/reactivity.html)

### Vue.version

- **詳細:** インストールされている Vue のバージョンを文字列として提供します。これはコミュニティのプラグインやコンポーネントで特に役立ち、異なるバージョンで違う戦略を使うことができます。

- **使用方法:**

  ```js
  var version = Number(Vue.version.split('.')[0])

  if (version === 2) {
    // Vue v2.x.x
  } else if (version === 1) {
    // Vue v1.x.x
  } else {
    // サポートしていないバージョンの Vue
  }
  ```

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
  vm.a // => 1
  vm.$data === data // => true

  // Vue.extend() 内では、関数を使わなければいけない
  var Component = Vue.extend({
    data: function () {
      return { a: 1 }
    }
  })
  ```

  `data` プロパティでアロー関数を使用する場合は、`this` はコンポーネントインスタンスになりませんが、それでも関数の第 1 引数としてアクセスすることができます:

  ``` js
  data: vm => ({ a: vm.myProp })
  ```

- **参照:** [リアクティブの探求](../guide/reactivity.html)

### props

- **型:** `Array<string> | Object`

- **詳細:**

  親コンポーネントからデータを受け取るためにエクスポートされた属性のリスト/ハッシュです。シンプルな配列ベースの構文、そして型チェック、カスタム検証そしてデフォルト値などの高度な構成を可能とする配列ベースの代わりとなるオブジェクトベースの構文があります。

  オブジェクトベースの構文では、次のオプションを使えます:
    - `type`: 次のネイティブコンストラクタのいずれかです: `String`, `Number`, `Boolean`, `Array`, `Object`, `Date`, `Function`, `Symbol`, カスタムコンストラクタ関数、またはそれらの配列。プロパティが指定された型かチェックし、そうでなければ警告を出します。プロパティの型に関する [詳細](../guide/components-props.html#プロパティの型)。
    - `default`: `any`
    プロパティのデフォルト値を指定します。プロパティが渡されない場合は、この値が代わりに使われます。オブジェクトまたは配列のデフォルト値は、ファクトリ関数で返す必要があります。
    - `required`: `Boolean`
    プロパティが必須かどうかを指定します。プロダクション環境以外では、この値が真なのにプロパティが渡されないとコンソールに警告が出されます。
    - `validator`: `Function`
    プロパティの値を唯一の引数として受け取る、カスタムのバリデーション関数です。プロダクション環境以外では、この関数が偽を返す (つまり、バリデーションが失敗する) とコンソールに警告が出されます。プロパティのバリデーションについては、 [ここ](../guide/components-props.html#プロパティのバリデーション) を読んでください。

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

- **参照:** [プロパティ](../guide/components-props.html)

### propsData

- **型:** `{ [key: string]: any }`

- **制約:** `new` 経由でインスタンス作成のみだけなので注意してください。

- **詳細:**

  インスタンス作成中にプロパティに値を渡します。これは、主に単体テストを簡単にするのを目的としています。

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

  Vue インスタンスに組み込まれる算出プロパティ (Computed property) です。すべての getter や setter は、自動的に Vue インスタンスに束縛された `this` コンテキストを持ちます。

  算出プロパティでアロー関数を使用する場合は、`this` はコンポーネントインスタンスになりませんが、それでも関数の第 1 引数としてアクセスすることができます:

  ```js
  computed: {
    aDouble: vm => vm.a * 2
  }
  ```

  算出プロパティはキャッシュされ、そしてリアクティブ依存が変更されたときにだけ再算出します。ある依存関係がインスタンスのスコープ外の(つまりリアクティブではない)場合、算出プロパティは更新され**ない**ことに注意してください。

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
  vm.aPlus   // => 2
  vm.aPlus = 3
  vm.a       // => 2
  vm.aDouble // => 4
  ```

- **参照:** [算出プロパティ](../guide/computed.html)

### methods

- **型:** `{ [key: string]: Function }`

- **詳細:**

  Vue インスタンスに組み込まれるメソッドです。VM インスタンスでは、これらのメソッドに直接アクセスでき、ディレクティブの式で使用することもできます。すべてのメソッドは、Vue インスタンスに自動的に束縛された `this` コンテキストを持ちます。

  <p class="tip">__メソッド(例 `plus: () => this.a++`) を定義するためにアロー関数を使用すべきではないこと__に注意してください。アロー関数は、`this` が期待する Vue インスタンスではなく、`this.a` が undefined になるため、親コンテキストに束縛できないことが理由です。</p>

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

- **参照:** [イベントの購読](../guide/events.html)

### watch

- **型:** `{ [key: string]: string | Function | Object | Array}`

- **詳細:**

  キーが監視する評価式で、値が対応するコールバックをもつオブジェクトです。値はメソッド名の文字列、または追加のオプションが含まれているオブジェクトを取ることができます。Vue インスタンスはインスタンス化の際にオブジェクトの各エントリに対して `$watch()` を呼びます。


- **例:**

  ``` js
  var vm = new Vue({
    data: {
      a: 1,
      b: 2,
      c: 3,
      d: 4,
      e: {
        f: {
          g: 5
        }
      }
    },
    watch: {
      a: function (val, oldVal) {
        console.log('new: %s, old: %s', val, oldVal)
      },
      // 文字列メソッド名
      b: 'someMethod',
      // コールバックは監視しているオブジェクトのプロパティが（そのネストの深さに関係なく）変更されると呼ばれる
      c: {
        handler: function (val, oldVal) { /* ... */ },
        deep: true
      },
      // コールバックは監視の開始後、直ちに呼ばれる
      d: {
        handler: 'someMethod',
        immediate: true
      },
      // you can pass array of callbacks, they will be called one-by-one
      e: [
        'handle1',
        function handle2 (val, oldVal) { /* ... */ },
        {
          handler: function handle3 (val, oldVal) { /* ... */ },
          /* ... */
        }
      ],
      // vm.e.f の値を監視する: {g: 5}
      'e.f': function (val, oldVal) { /* ... */ }
    }
  })
  vm.a = 2 // => new: 2, old: 1
  ```

  <p class="tip">__ウォッチャ(例 `searchQuery: newValue => this.updateAutocomplete(newValue)`) を定義するためにアロー関数を使用すべきではないこと__に注意してください。アロー関数は、`this` が期待する Vue インスタンスではなく、`this.updateAutocomplete` が undefined になるため、親コンテキストに束縛できないことが理由です。</p>

- **参照:** [インスタンスメソッド / データ - vm.$watch](#vm-watch)

## オプション / DOM

### el

- **型:** `string | Element`

- **制約:** `new` 経由でインスタンス作成のみだけなので注意してください。

- **詳細:**

  既存の DOM 要素に Vue インスタンスを与えます。CSS セレクタの文字列、実際の HTML 要素をとることができます。

  インスタンスがマウント後、解決された要素は `vm.$el` としてアクセス可能になります。

  インスタンス化の際にオプションが有効ならば、そのインスタンスはただちにコンパイルの段階に入ります。さもなければ、ユーザーがコンパイルを始めるために手作業で明示的に `vm.$mount()` を呼ぶ必要があります。

  <p class="tip">与えられた要素は単にマウントするポイントとして機能します。Vue 1.x とは異なり、マウントされた要素は、全てのケースで Vue によって生成された DOM に置き換えられます。従って、ルートインスタンスを `<html>` または `<body>` にマウントすることは推奨されません。</p>

  <p class="tip">`render` 関数または `template` オプションも存在しない場合、マウントしている DOM 要素にある HTML がテンプレートとして抽出されます。この場合、Vue のランタイムとコンパイラが同包された完全ビルドを使用する必要があります。</p>

- **参照:**
  - [ライフサイクルダイアグラム](../guide/instance.html#ライフサイクルダイアグラム)
  - [ランタイム + コンパイラとランタイム限定の違い](../guide/installation.html#ランタイム-コンパイラとランタイム限定の違い)

### template

- **型:** `string`

- **詳細:**

  Vue インスタンスに対してマークアップとして使用するための、文字列のテンプレートです。テンプレートはマウントされた要素として**置換**されます。コンテンツ挿入 slot がテンプレートの中にない限り、マウントされた要素内部のあらゆる既存のマークアップは無視されます。

  `#` による文字列で始まる場合、querySelector として使用され、選択された要素の innerHTML をテンプレート文字列として使用します。これにより、テンプレートを組み込むための共通の `<script type="x-template">` というやり方を使うことができるようになります。

  <p class="tip">セキュリティの観点から、信頼できる Vue のテンプレートだけ使用するべきです。決してユーザーによって生成されたコンテンツをテンプレートとして使用しないでください。</p>

  <p class="tip">Vue オプションに `render` 関数がある場合、テンプレートは無視されます。</p>

- **参照:**
  - [ライフサイクルダイアグラム](../guide/instance.html#ライフサイクルダイアグラム)
  - [スロットによるコンテンツ配信](../guide/components.html#スロットによるコンテンツ配信)

### render

- **型:** `(createElement: () => VNode) => VNode`

- **詳細:**

  JavaScript による完全なプログラミングパワーを活用するために文字列テンプレートの代替として許可します。render 関数は、`VNode` を作成するために最初の引数として `createElement` メソッドを受け取ります

  コンポーネントが関数型コンポーネントならば、render 関数は、関数型コンポーネントが状態を持たないため、コンテキストなデータにアクセスするために提供する `context` を追加の引数として受け取ります。

  <p class="tip">`render` 関数は、`el` オプションで指定されたマウント要素の `template` オプションまたは DOM にある HTML テンプレートからコンパイルされた描画関数より優先されます。</p>

- **参照:** [描画関数](../guide/render-function.html)

### renderError

> 2.2.0 から新規

- **型:** `(createElement: () => VNode, error: Error) => VNode`

- **詳細:**

  **development モードでのみ動作します。**

  デフォルトの `render` 関数にてエラーが発生した際に、代替となる描画結果を提供します。この際、エラーは `renderError` へ、第二引数として渡されます。この機能は、特にホットリロードなどと併用する場合に重宝します。

- **例:**

  ``` js
  new Vue({
    render (h) {
      throw new Error('oops')
    },
    renderError (h, err) {
      return h('pre', { style: { color: 'red' }}, err.stack)
    }
  }).$mount('#app')
  ```

- **参照:** [描画関数](../guide/render-function.html)

## オプション / ライフサイクルフック

<p class="tip">全てのライフサイクルフックは、データ、算出プロパティ、およびメソッドにアクセスできるようにするために、自動的にインスタンスに束縛する `this` コンテキストを持っています。これは、__ライフサイクルメソッド(例 `created: () => this.fetchTodos()`) を定義するためにアロー関数を使用すべきではないこと__を意味します。アロー関数は、`this` が期待する Vue インスタンスではなく、`this.fetchTodos` が undefined になるため、親コンテキストに束縛できないことが理由です。</p>

### beforeCreate

- **型:** `Function`

- **詳細:**

  データの監視とイベント/ウォッチャのセットアップより前の、インスタンスが初期化されるときに同期的に呼ばれます。

- **参照:** [ライフサイクルダイアグラム](../guide/instance.html#ライフサイクルダイアグラム)

### created

- **型:** `Function`

- **詳細:**

  インスタンスが作成された後に同期的に呼ばれます。この段階では、インスタンスは、データ監視、算出プロパティ、メソッド、watch/event コールバックらのオプションのセットアップ処理が完了したことを意味します。しかしながら、マウンティングの段階は未開始で、`$el` プロパティはまだ利用できません。

- **参照:** [ライフサイクルダイアグラム](../guide/instance.html#ライフサイクルダイアグラム)

### beforeMount

- **型:** `Function`

- **詳細:**

  `render` 関数が初めて呼び出されようと、マウンティングが開始される直前に呼ばれます。

  **このフックはサーバサイドレンダリングでは呼ばれません。**

- **参照:** [ライフサイクルダイアグラム](../guide/instance.html#ライフサイクルダイアグラム)

### mounted

- **型:** `Function`

- **詳細:**

  新たに作成される `vm.$el` によって置き換えられる `el` に対して、インスタンスがマウントされたちょうど後に呼ばれます。ルートインスタンスがドキュメントの中の要素にマウントされる場合、`vm.$el` も `mounted` が呼び出されるときにドキュメントの中に入ります。

  `mounted` は 全ての子コンポーネントもマウントされていることを保証**しない**ことに注意してください。ビュー全体がレンダリングされるまで待つ場合は、 `mounted` の代わりに [vm.$nextTick](#vm-nextTick) を使うことができます。

  ``` js
  mounted: function () {
    this.$nextTick(function () {
      // ビュー全体がレンダリングされた後にのみ実行されるコード
    })
  }
  ```

  **このフックはサーバサイドレンダリングでは呼ばれません。**

- **参照:** [ライフサイクルダイアグラム](../guide/instance.html#ライフサイクルダイアグラム)

### beforeUpdate

- **型:** `Function`

- **詳細:**

  データが変更されるとき、DOM が適用される前に呼ばれます。これは、更新前に既存の DOM にアクセスするのに適しています。例: 手動で追加されたイベントリスナを削除する

  **このフックはサーバサイドレンダリングでは呼ばれません。サーバサイドでは初期描画のみ実行されるためです。**

- **参照:** [ライフサイクルダイアグラム](../guide/instance.html#ライフサイクルダイアグラム)

### updated

- **型:** `Function`

- **詳細:**

  データが変更後、仮想 DOM が再描画そしてパッチを適用によって呼ばれます。

  このフックが呼び出されるとき、コンポーネントの DOM は更新した状態になり、このフックで DOM に依存する操作を行うことができます。しかしがながら、ほとんどの場合、無限更新ループに陥る可能性があるため、このフックでは状態を変更するのを回避すべきです。

  `updated` は 全ての子コンポーネントも再レンダリングされていることを保証**しない**ことに注意してください。ビュー全体が再レンダリングされるまで待つ場合は、 `updated` の代わりに [vm.$nextTick](#vm-nextTick) を使うことができます。

  ``` js
  updated: function () {
    this.$nextTick(function () {
      // ビュー全体が再レンダリングされた後にのみ実行されるコード
    })
  }
  ```

  **このフックはサーバサイドレンダリングでは呼ばれません。**

- **参照:** [ライフサイクルダイアグラム](../guide/instance.html#ライフサイクルダイアグラム)

### activated

- **型:** `Function`

- **詳細:**

  生き続けたコンポーネントが活性化するとき呼ばれます。

  **このフックはサーバサイドレンダリングでは呼ばれません。**

- **参照:**
  - [組み込みコンポーネント - keep-alive](#keep-alive)
  - [動的コンポーネント - keep-alive](../guide/components.html#keep-alive)

### deactivated

- **型:** `Function`

- **詳細:**

  生存し続けたコンポーネントが非活性化されるとき呼ばれます。

  **このフックはサーバサイドレンダリングでは呼ばれません。**

- **参照:**
  - [組み込みコンポーネント - keep-alive](#keep-alive)
  - [動的コンポーネント - keep-alive](../guide/components.html#keep-alive)

### beforeDestroy

- **型:** `Function`

- **詳細:**

  Vue インスタンスが破棄される直前に呼ばれます。この段階ではインスタンスはまだ完全に機能しています。

  **このフックはサーバサイドレンダリングでは呼ばれません。**

- **参照:** [ライフサイクルダイアグラム](../guide/instance.html#ライフサイクルダイアグラム)

### destroyed

- **型:** `Function`

- **詳細:**

  Vue インスタンスが破棄された後に呼ばれます。このフックが呼ばれるとき、Vue インスタンスの全てのディレクティブはバウンドしておらず、全てのイベントリスナは削除されており、そして全ての子の Vue インスタンスは破棄されています。

  **このフックはサーバサイドレンダリングでは呼ばれません。**

- **参照:** [ライフサイクルダイアグラム](../guide/instance.html#ライフサイクルダイアグラム)

### errorCaptured

> 2.5.0 から新規

- **型:** `(err: Error, vm: Component, info: string) => ?boolean`

- **詳細:**

  任意の子孫コンポーネントからエラーが捕捉されるときに呼び出されます。フックは、エラー、エラーをトリガするコンポーネントインスタンス、そしてどこでエラーが捕捉されたかの文字列情報、これら 3 つの引数を受け取ります。フックはエラーがさらにもっと伝播するのを防ぐために、`false` を返すことができます。

  <p class="tip">このフックでコンポーネントの状態を変更できます。ただし、エラーが捕捉されたときに他のコンテンツを手短に迂回させる、テンプレートにおける条件または描画関数を含めるのが重要です。それ以外の場合、コンポーネントは無限描画ループに投げられます。</p>

  **エラー伝播ルール**

  - 標準で、これらのエラーは 1 箇所で分析サービスにレポートすることができるため、全てのエラーはグローバルな `config.errorHandler` (それが定義されている場合)に送信されます。

  - 複数の `errorCaptured` フックがコンポーネントの継承チェーンまたは親チェーンに存在する場合は、それらの全ては、同じエラーで呼び出されます。

  - `errorCaptured` フック自身がエラーを投げる場合、このエラーと元の捕捉されたエラー両方は、グローバルな `config.errorHandler` に送られます。

  - `errorCaptured` フックはエラーがさらに伝播するのを防ぐために `false` を返すことができます。これは本質的に「このエラーは処理されてかつ無視する必要がある」と言っているに等しいです。任意に追加する `errorCaptured` フックまたはグローバルな `config.errorHandler` がこのエラーのために呼び出されないように防ぐ必要があります。

## オプション / アセット

### directives

- **型:** `Object`

- **詳細:**

  Vue インスタンスで利用可能なディレクティブのハッシュです。

- **参照:** [カスタムディレクティブ](../guide/custom-directive.html)

### filters

- **型:** `Object`

- **詳細:**

  Vue インスタンスで利用可能なフィルタのハッシュです。

- **参照:** [`Vue.filter`](#Vue-filter)

### components

- **型:** `Object`

- **詳細:**

  Vue インスタンスで利用可能なコンポーネントのハッシュです。

- **参照:** [コンポーネント](../guide/components.html)

## オプション / 構成

### parent

- **型:** `Vue instance`

- **詳細:**

  作成されるインスタンスの親インスタンスを指定します。2つのインスタンス間で親子関係を確立します。親は子の `this.$parent` としてアクセス可能となり、子は親の `$children` 配列に追加されます。

  <p class="tip">`$parent` と `$children` の使用は控えてください。これらはどうしても避けられないときに使用します。親子間の通信に対してプロパティとイベントを使用すべきです。</p>

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
  // => 1
  // => 2
  ```

- **参照:** [ミックスイン](../guide/mixins.html)

### extends

- **型:** `Object | Function`

- **詳細:**

  `Vue.extend` を使用しなくても、別のコンポーネントを宣言的に拡張できます(純粋なオプションオブジェクトまたはコンストラクタのどちらでも構いません)。これは主に単一ファイルコンポーネントにおいて簡単に拡張するのを目的としています。

  これは `mixins` に似ています。

- **例:**

  ``` js
  var CompA = { ... }

  // CompA を `Vue.extend` の呼び出しなしで拡張する
  var CompB = {
    extends: CompA,
    ...
  }
  ```

### provide / inject

> 2.2.0 から新規

- **型:**
  - **provide:** `Object | () => Object`
  - **inject:** `Array<string> | { [key: string]: string | Symbol | Object }`

- **詳細:**

  <p class="tip">`provide` および `inject` は、主に高度なプラグインやコンポーネントのライブラリのために提供されています。一般的なアプリケーションのコードで利用することは推奨されません。</p>

  この 1 組のオプションは、コンポーネントの階層がどれほど深いかにかかわらず、それらが同じ親チェーン内にある限り、祖先コンポーネントが、自身の子孫コンポーネント全てに対する依存オブジェクトの注入役を務めることができるようにするために利用されます。React に精通している人は、 React のコンテキストの特徴と非常によく似ていると捉えると良いでしょう。

  `provide` オプションの値は、オブジェクトもしくはオブジェクトを返す関数でなくてはなりません。このオブジェクトは自身の子孫に注入可能なプロパティを含みます。また、このオブジェクトのキーとして、 ES2015 の Symbol を利用することが可能ですが、ネイティブに `Symbol` と `Reflect.ownKeys` をサポートしている環境でのみ有効です。

  `inject` オプションの値は、以下のいずれかでなければなりません:
  - 文字列の配列、もしくは
  - キーがローカルのバインディング名かつバリューが以下のいずれか:
    - 利用可能な注入オブジェクトを探すときのキー (文字列または Symbol)、または
    - オブジェクト:
      - `from` プロパティが利用可能な注入オブジェクトを探すときのキー (文字列または Symbol)、そして
      - `default` プロパティはフォールバックの値として使われます

  プロバイダコンポーネントは、提供されたプロパティを注入するコンポーネントの親チェーン内(註釈:構成されたコンポーネントツリーにおいてプロバイダコンポーネントへ辿れる状態)にある必要があります。

- **例:**

  ``` js
  // 'foo' を提供している親コンポーネント
  var Provider = {
    provide: {
      foo: 'bar'
    },
    // ...
  }

  // 'foo' を注入している子コンポーネント
  var Child = {
    inject: ['foo'],
    created () {
      console.log(this.foo) // => "bar"
    }
    // ...
  }
  ```

  ES2015 のシンボルとともに `provide` 関数と `inject` オブジェクトを利用する場合:

  ``` js
  const s = Symbol()

  const Provider = {
    provide () {
      return {
        [s]: 'foo'
      }
    }
  }

  const Child = {
    inject: { s },
    // ...
  }
  ```

  > 次の 2 つの例は、Vue の 2.2.1 以降のみだけ動作します。以下のバージョンでは、注入された値は、`props` と `data` による初期化後に解決されます。

  以下は、prop のデフォルト値として、注入された値を使用します:
  ```js
  const Child = {
    inject: ['foo'],
    props: {
      bar: {
        default () {
          return this.foo
        }
      }
    }
  }
  ```

  以下は、注入された値をデータのエントリとして使用します:
  ```js
  const Child = {
    inject: ['foo'],
    data () {
      return {
        bar: this.foo
      }
    }
  }
  ```

  > 2.5.0 以降では、注入はデフォルト値で任意にできます:

  ``` js
  const Child = {
    inject: {
      foo: { default: 'foo' }
    }
  }
  ```

  別の名前のプロパティから注入する必要がある場合は、`from` を使用して元のプロパティを指定します:

  ``` js
  const Child = {
    inject: {
      foo: {
        from: 'bar',
        default: 'foo'
      }
    }
  }
  ```

  プロパティのデフォルトと同様に、プリミティブ値以外に対してはファクトリ関数を使用する必要があります:

  ``` js
  const Child = {
    inject: {
      foo: {
        from: 'bar',
        default: () => [1, 2, 3]
      }
    }
  }
  ```

## オプション / その他

### name

- **型:** `string`

- **制約:** コンポーネントのオプションで使われたときのみ、有効なので注意してください。

- **詳細:**

  テンプレート内でのコンポーネント自身の再帰呼び出しを許可します。コンポーネントは `Vue.component()` でグローバルに登録され、グローバル ID はその名前に自動的に設定される事に注意してください。

  `name` オプションのもう1つの利点は、デバッギングです。名前付きコンポーネントはより便利な警告メッセージが表示されます。また、[vue-devtools](https://github.com/vuejs/vue-devtools) でアプリケーションを検査するとき、名前付きでないコンポーネントは `<AnonymousComponent>` として表示され、とても有益ではありません。`name` オプションの提供によって、はるかに有益なコンポーネントツリーを取得できるでしょう。

### delimiters

- **型:** `Array<string>`

- **デフォルト:** `{% raw %}["{{", "}}"]{% endraw %}`

- **制限事項:** このオプションは完全ビルドでのみ利用可能で、ブラウザ内でのコンパイルが可能です。

- **詳細:**

  プレーンテキスト展開デリミタを変更します。

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

  状態を持たない (`data` なし) そしてインスタンスを持たない (`this` コンテキストなし)コンポーネントにするかどうか設定します。描画するために仮想ノードを遥かに安価に作成しそれらを返す単純な`render` 関数を実装する必要があります。

- **参照:** [関数型コンポーネント](../guide/render-function.html#関数型コンポーネント)

### model

> 2.2.0 からの新機能

- **型:** `{ prop?: string, event?: string }`

- **詳細:**

  `v-model` が指定されたとき、カスタムコンポーネントがプロパティおよびイベントをカスタマイズすることを許可します。デフォルトでは、コンポーネントにおける `v-model` は、 `value` をプロパティとして、 `input` をイベントして用います。しかし、チェックボックスやラジオボタンなどの入力タイプは、`value` プロパティを他の目的で利用したいことがあるかもしれません。その際、 `model` オプションを利用することで、競合を避けることが可能です。

- **例:**

  ``` js
  Vue.component('my-checkbox', {
    model: {
      prop: 'checked',
      event: 'change'
    },
    props: {
      // これによって、 `value` プロパティを別の目的で利用することを許可します
      value: String,
      // `value` の代わりとなるプロパティとして `checked` を使います
      checked: {
        type: Number,
        default: 0
      }
    },
    // ...
  })
  ```

  ``` html
  <my-checkbox v-model="foo" value="some value"></my-checkbox>
  ```

  上記の例の場合は、下記のようになります:

  ``` html
  <my-checkbox
    :checked="foo"
    @change="val => { foo = val }"
    value="some value">
  </my-checkbox>
  ```

### inheritAttrs

> 2.4.0 から新規

- **型:** `boolean`

- **デフォルト:** `true`

- **詳細:**

  デフォルトでは、親スコープのバインディングはプロパティとして認識されず"フォールスロー"され、子コンポーネントのルート要素に通常の HTML 属性として適用されます。ターゲット要素または別のコンポーネントをラップ (wrap) するコンポーネントを著作する場合は、これは常に望ましい動作ではないかもしれません。`inheritAttrs` に `false` を設定することで、このデフォルトの動作を無効にできます。属性は、`$attrs` インスタンスプロパティ (2.4 での新規) を介して利用でき、`v-bind` を使用してルートではない要素に明示的にバインドできます。

  注意: このオプションは `class` と `style` のバインディングには効果が**ありません**。

### comments

> 2.4.0 から新規

- **型:** `boolean`

- **デフォルト:** `false`

- **制限事項:** このオプションは完全ビルドでのみ利用可能で、ブラウザ内でのコンパイルが可能です。

- **詳細:**

  `true` に設定すると、テンプレートにある HTML コメントが維持され描画されます。デフォルトの動作はそれらを破棄します。

## インスタンスプロパティ

### vm.$data

- **型:** `Object`

- **詳細:**

  Vue インスタンスが監視しているデータオブジェクトです。Vue インスタンスプロキシはデータオブジェクトのプロパティにアクセスします。

- **参照:** [オプション / データ - data](#data)

### vm.$props

> 2.2.0 の新機能

- **型** `Object`

- **詳細**

  コンポーネントが受け取った現在のプロパティを表すオブジェクトです。Vue インスタンスプロキシは props オブジェクトのプロパティにアクセスします。

### vm.$el

- **型:** `Element`

- **読み込みのみ**

- **詳細:**

  Vue インスタンスが管理している ルートな DOM 要素です。

### vm.$options

- **型:** `Object`

- **読み込みのみ**

- **詳細:**

  現在の Vue インスタンスのためのインストールオプションとして使われます。これはオプションにカスタムプロパティを含めたいとき便利です:

  ``` js
  new Vue({
    customOption: 'foo',
    created: function () {
      console.log(this.$options.customOption) // => 'foo'
    }
  })
  ```

### vm.$parent

- **型:** `Vue instance`

- **読み込みのみ**

- **詳細:**

  現在のインスタンスが1つ持つ場合は、親のインスタンスです。

### vm.$root

- **型:** `Vue instance`

- **読み込みのみ**

- **詳細:**

  現在のコンポーネントツリーのルート Vue インスタンスです。現在のインスタンスが親を持たない場合、この値はそれ自身でしょう。

### vm.$children

- **型:** `Array<Vue instance>`

- **読み込みのみ**

- **詳細:**

  現在のインスタンスの直接的な子コンポーネントです。**`$children` に対して順序の保証がなく、リアクティブでないことに注意してください。**あなた自身、データバインディングに対して `$children` を使用するためにそれを見つけようとする場合、子コンポーネントを生成するために配列と `v-for` を使用することを検討し、正しいソースとして配列を使用してください。

### vm.$slots

- **型:** `{ [name: string]: ?Array<VNode> }`

- **読み込みのみ**

- **デフォルト:**

  プログラム的に[スロットにより配信された](/guide/components.html#スロットによるコンテンツ配信)コンテンツにアクセスするために使用されます。各[名前付きスロット](../guide/components-slots.html#名前付きスロット) は自身に対応するプロパティを持ちます (例: `v-slot:foo` のコンテンツは `vm.$slots.foo` で見つかります)。`default` プロパティは、名前付きスロットに含まれない任意のノード、または `v-slot:default` のコンテンツを含みます。

  **注意:** `v-slot:foo` は 2.6 以降でサポートされます。古いバージョンでは、[非推奨の構文](../guide/components-slots.html#非推奨の構文) を利用できます。

  `vm.$slots` のアクセスは、[描画関数](/guide/render-function.html) によるコンポーネントを書くときに最も便利です。

- **例:**

  ```html
  <blog-post>
    <template v-slot:header>
      <h1>About Me</h1>
    </template>

    <p>Here's some page content, which will be included in vm.$slots.default, because it's not inside a named slot.</p>

    <template v-slot:footer>
      <p>Copyright 2016 Evan You</p>
    </template>

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
        createElement('header', header),
        createElement('main', body),
        createElement('footer', footer)
      ])
    }
  })
  ```

- **参照:**
  - [`<slot>` コンポーネント](#slot)
  - [スロットによるコンテンツ配信](../guide/components.html#スロットによるコンテンツ配信)
  - [描画関数 - スロット](../guide/render-function.html#スロット)

### vm.$scopedSlots

> 2.1.0 から新規

- **型:** `{ [name: string]: props => Array<VNode> | undefined }`

- **読み込みのみ**

- **詳細:**

  [スコープ付きスロット](../guide/components-slots.html#スコープ付きスロット) にプログラムでアクセスするために使用されます。`default` を含む各スロットに対して、オブジェクトには VNode を返す対応する関数が含まれています。

  `vm.$scopedSlots` にアクセスする際に、[描画関数](../guide/render-function.html) でコンポーネントを書くときに最も便利です。

  **注意:** 2.6.0 以降では、このプロパティに特筆すべき変更が 2 つあります:

  1. スコープ付きスロット関数は、戻り値が不正でない限り (この場合は `undefined` を返す) VNode の配列を返すことが保証されるようになりました。

  2. すべての `$slots` は `$scopedSlots` にも関数として公開されるようになりました。描画関数を使う場合、今後はスコープ付きを使うかどうかに関係なく、常に `$scopedSlots` 経由でスロットにアクセスすることを推奨します。これは、将来スコープを追加するリファクタリングをシンプルにするだけでなく、すべてのスロットが関数になる Vue 3 への移行を簡単にします。

- **参照:**
  - [`<slot>` コンポーネント](#slot)
  - [スコープ付きスロット](../guide/components-slots.html#スコープ付きスロット)
  - [描画関数 - スロット](../guide/render-function.html#スロット)

### vm.$refs

- **型:** `Object`

- **読み込みのみ**

- **詳細:**

  [`ref` 属性](#ref)によって登録されたDOM 要素のオブジェクトとコンポーネントインスタンスです。

- **参照:**
  - [子コンポーネントの参照](../guide/components.html#子コンポーネントの参照)
  - [特別な属性 - ref](#ref)

### vm.$isServer

- **型:** `boolean`

- **読み込みのみ**

- **詳細:**

  現在の Vue インスタンスがサーバ上で動作しているかどうかを表します。

- **参照:** [サーバサイドレンダリング](../guide/ssr.html)

### vm.$attrs

> 2.4.0 から新規

- **型:** `{ [key: string]: string }`

- **読み込みのみ**

- **詳細:**

  プロパティとして認識(および抽出)されない親スコープの属性バインディング(`class` と `style` 以外の)が含まれています。コンポーネントに宣言されたプロパティがない場合、(`class` と `style` 以外の)全ての親スコープのバインディングが基本的に含まれ、`v-bind="$attrs"` 経由で内部コンポーネントに渡すことができます。高次 (higher-order) コンポーネントを作成するときに便利です。

### vm.$listeners

> 2.4.0 から新規

- **型:** `{ [key: string]: Function | Array<Function> }`

- **読み込みのみ**

- **詳細:**

  親スコープの (`.native` 修飾子なしの) `v-on` イベントリスナーを含みます。これは、`v-on="$listeners"` を介して内部コンポーネントに渡すことができます。透過的なラッパーコンポーネントを作成するときに便利です。

## インスタンスメソッド / データ

### vm.$watch( expOrFn, callback, [options] )

- **引数:**
  - `{string | Function} expOrFn`
  - `{Function | Object} callback`
  - `{Object} [options]`
    - `{boolean} deep`
    - `{boolean} immediate`

- **戻り値:** `{Function} unwatch`

- **使用方法:**

  Vue インスタンス上でのひとつの式または算出関数 (computed function) の変更を監視します。コールバックは新しい値と古い値とともに呼びだされます。引数の式には、単純なドット区切りのパスのみを入れることができます。より複雑な表現の場合は、代わりに関数を使用します。

<p class="tip">オブジェクトまたは配列を変更する(というよりむしろ置換する)とき、それらは同じオブジェクト/配列を参照するため、古い値は新しい値と同じになることに注意してください。Vue は変更前の値のコピーしません。</p>

- **例:**

  ``` js
  // キーパス
  vm.$watch('a.b.c', function (newVal, oldVal) {
    // 何かの処理
  })

  // 関数
  vm.$watch(
    function () {
      // 式 `this.a + this.b` が異なる結果を返すたびに、ハンドラが呼び出されます。
      // これは、算出プロパティを定義することなしに、その算出プロパティを監視している
      // ようなものです。
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
  // その時の `a` の値で`コールバック`がただちに発火します
  ```

  `immediate` オプションを使う場合、最初のコールバック呼び出し時には該当プロパティの監視を解除できないことに注意してください。

  ``` js
  // エラーになります
  var unwatch = vm.$watch(
    'value',
    function () {
      doSomething()
      unwatch()
    },
    { immediate: true }
  )
  ```

  コールバックの中でどうしても unwatch 関数を呼び出したい場合は、先に実行可能かをチェックする必要があります:

  ``` js
  var unwatch = vm.$watch(
    'value',
    function () {
      doSomething()
      if (unwatch) {
        unwatch()
      }
    },
    { immediate: true }
  )
  ```

### vm.$set( target, propertyName/index, value )

- **引数:**
  - `{Object | Array} target`
  - `{string | number} propertyName/index`
  - `{any} value`

- **戻り値:** 設定した値

- **使用方法:**

  これはグローバルメソッド `Vue.set` の**エイリアス**です。

- **参照:** [Vue.set](#Vue-set)

### vm.$delete( target, propertyName/index )

- **引数:**
  - `{Object | Array} target`
  - `{string | number} propertyName/index`

- **使用方法:**

  これはグローバルメソッド `Vue.delete` の**エイリアス**です。

- **参照:** [Vue.delete](#Vue-delete)

## インスタンスメソッド / イベント

### vm.$on( event, callback )

- **引数:**
  - `{string | Array<string>} event` (Array は 2.2.0 以降でのみサポートされます)
  - `{Function} callback`

- **使用方法:**

  現在の vm 上のカスタムイベントを監視します。イベントは `vm.$emit` によってトリガすることができます。それらのイベントトリガを行うメソッドに渡した追加の引数は、コールバックがすべて受け取ります。

- **例:**

  ``` js
  vm.$on('test', function (msg) {
    console.log(msg)
  })
  vm.$emit('test', 'hi')
  // => "hi"
  ```

### vm.$once( event, callback )

- **引数:**
  - `{string} event`
  - `{Function} callback`

- **使用方法:**

  一度きりだけ、カスタムイベントのリスナを提供します。リスナは最初にトリガされた時に削除されます。

### vm.$off( [event, callback] )

- **引数:**
  - `{string | Array<string>} [event]` (Array は 2.2.2 以降でのみサポートされます)
  - `{Function} [callback]`

- **使用方法:**

  カスタムイベントのリスナを削除します。

  - 引数が与えられなければ、すべてのイベントリスナを削除します。

  - イベントがひとつだけ与えられたら、そのイベントに関するすべてのイベントリスナを削除します。

  - イベントとコールバックの両方が与えられたら、その特定のコールバックに対するイベントリスナのみを削除します。

### vm.$emit( eventName, [...args] )

- **引数:**
  - `{string} eventName`
  - `[...args]`

  現在のインスタンス上のイベントをトリガします。追加の引数はリスナのコールバックファンクションに渡されます。

- **例:**

  `$emit` をイベント名のみと共に使う場合:

  ```js
  Vue.component('welcome-button', {
    template: `
      <button v-on:click="$emit('welcome')">
        Click me to be welcomed
      </button>
    `
  })
  ```
  ```html
  <div id="emit-example-simple">
    <welcome-button v-on:welcome="sayHi"></welcome-button>
  </div>
  ```
  ```js
  new Vue({
    el: '#emit-example-simple',
    methods: {
      sayHi: function () {
        alert('Hi!')
      }
    }
  })
  ```
  {% raw %}
  <div id="emit-example-simple" class="demo">
    <welcome-button v-on:welcome="sayHi"></welcome-button>
  </div>
  <script>
    Vue.component('welcome-button', {
      template: `
        <button v-on:click="$emit('welcome')">
          Click me to be welcomed
        </button>
      `
    })
    new Vue({
      el: '#emit-example-simple',
      methods: {
        sayHi: function () {
          alert('Hi!')
        }
      }
    })
  </script>
  {% endraw %}

  `$emit` を追加の引数と共に使う場合:

  ```js
  Vue.component('magic-eight-ball', {
    data: function () {
      return {
        possibleAdvice: ['Yes', 'No', 'Maybe']
      }
    },
    methods: {
      giveAdvice: function () {
        var randomAdviceIndex = Math.floor(Math.random() * this.possibleAdvice.length)
        this.$emit('give-advice', this.possibleAdvice[randomAdviceIndex])
      }
    },
    template: `
      <button v-on:click="giveAdvice">
        Click me for advice
      </button>
    `
  })
  ```

  ```html
  <div id="emit-example-argument">
    <magic-eight-ball v-on:give-advice="showAdvice"></magic-eight-ball>
  </div>
  ```

  ```js
  new Vue({
    el: '#emit-example-argument',
    methods: {
      showAdvice: function (advice) {
        alert(advice)
      }
    }
  })
  ```

  {% raw %}
  <div id="emit-example-argument" class="demo">
    <magic-eight-ball v-on:give-advice="showAdvice"></magic-eight-ball>
  </div>
  <script>
    Vue.component('magic-eight-ball', {
      data: function () {
        return {
          possibleAdvice: ['Yes', 'No', 'Maybe']
        }
      },
      methods: {
        giveAdvice: function () {
          var randomAdviceIndex = Math.floor(Math.random() * this.possibleAdvice.length)
          this.$emit('give-advice', this.possibleAdvice[randomAdviceIndex])
        }
      },
      template: `
        <button v-on:click="giveAdvice">
          Click me for advice
        </button>
      `
    })
    new Vue({
      el: '#emit-example-argument',
      methods: {
        showAdvice: function (advice) {
          alert(advice)
        }
      }
    })
  </script>
  {% endraw %}

## インスタンスメソッド / ライフサイクル

### vm.$mount( [elementOrSelector] )

- **引数:**
  - `{Element | string} [elementOrSelector]`
  - `{boolean} [hydrating]`

- **戻り値:** `vm` - インスタンス自身

- **使用方法:**

  Vue インスタンスがインスタンス化において `el` オプションを受け取らない場合は、DOM 要素は関連付けなしで、"アンマウント(マウントされていない)" 状態になります。`vm.$mount()` は アンマウントな Vue インスタンスのマウンティングを手動で開始するために使用することができます。

  `elementOrSelector` 引数が提供されない場合、テンプレートはドキュメント要素外で描画され、ドキュメントにそれを挿入するためにあなた自身でネイティブ DOM API を使用しなければなりません。

  メソッドはインスタンス自身返し、その後に他のインスタンスメソッドを繋ぎ合わすことができます。

- **例:**

  ``` js
  var MyComponent = Vue.extend({
    template: '<div>Hello!</div>'
  })

  // インスタンスを生成し、#app にマウント(#app を置換)
  new MyComponent().$mount('#app')

  // 上記と同じです:
  new MyComponent({ el: '#app' })

  // また、ドキュメント外で描画し、その後加える
  var component = new MyComponent().$mount()
  document.getElementById('app').appendChild(component.$el)
  ```

- **参照:**
  - [ライフサイクルダイアグラム](../guide/instance.html#ライフサイクルダイアグラム)
  - [サーバサイドレンダリング](../guide/ssr.html)

### vm.$forceUpdate()

- **使用方法:**

  Vue インスタンスに再描画を強制します。インスタンス自身と slot コンテンツに挿入された子コンポーネントだけで、全ての子コンポーネントに影響しないことに注意してください。

### vm.$nextTick( [callback] )

- **引数:**
  - `{Function} [callback]`

- **使用方法:**

  callback の実行を遅延し、DOM の更新サイクル後に実行します。DOM の更新を待ち受けるためにいくつかのデータを更新した直後に使用してください。callback の `this` コンテキストは自動的にこのメソッドを呼びだすインスタンスに束縛されることを除いて、グローバルな `Vue.nextTick` と同じです。

  > 2.1.0 から新規: コールバックが提供されず、実行環境で Promise がサポートされている場合は Promise を返します。Vue には Promise ポリフィルが付属していないため、Promise をネイティブにサポートしていないブラウザ (IE かどうか確認して) をターゲットにしている場合は、自分でポリフィルを提供する必要があるという点に注意してください。

- **例:**

  ``` js
  new Vue({
    // ...
    methods: {
      // ...
      example: function () {
        // データを変更
        this.message = 'changed'
        // DOM はまだ更新されない
        this.$nextTick(function () {
          // DOM が更新された
          // `this` は現在のインスタンスに束縛される
          this.doSomethingElse()
        })
      }
    }
  })
  ```

- **参照:**
  - [Vue.nextTick](#Vue-nextTick)
  - [非同期更新キュー](../guide/reactivity.html#非同期更新キュー)

### vm.$destroy()

- **使用方法:**

  vm を完全に破棄します。既存の他の vm との接続を切り、そのすべてのディレクティブとの束縛を解消し、すべてのイベントリスナを開放します。

  `beforeDestroy` と `destroyed` フックをトリガします。

  <p class="tip">通常のケースでは、このメソッドはあなた自身で呼ぶべきではありません。`v-if` と `v-for` を使用してデータ駆動による方法で子コンポーネントのライフサイクルを制御することを推奨します。</p>

- **参照:** [ライフサイクルダイアグラム](../guide/instance.html#ライフサイクルダイアグラム)

## ディレクティブ

### v-text

- **要求事項:** `string`

- **詳細:**

  要素の`textContent`を更新します。`textContent` の一部を更新する必要がある場合は、`{% raw %}{{ Mustache }}{% endraw %}` 展開を使用すべきです。

- **例:**

  ```html
  <span v-text="msg"></span>
  <!-- 同じ -->
  <span>{{msg}}</span>
  ```

- **参照:** [テンプレート構文 - 展開](../guide/syntax.html#テキスト)

### v-html

- **要求事項:** `string`

- **詳細:**

  要素の `innerHTML` を更新します。**コンテンツはプレーンな HTML として挿入されることに注意してください。Vue テンプレートとしてコンパイルされません。** もし `v-html` を使ってテンプレートを構成しようとしているなら、代わりにコンポーネントを使って解決するように考え直してみてください。

  <p class="tip">任意の HTML をあなたの Web サイト上で動的に描画することは、 [XSS 攻撃](https://en.wikipedia.org/wiki/Cross-site_scripting)を招くため大変危険です。`v-html` は信頼済みコンテンツのみに利用し、 **絶対に** ユーザの提供するコンテンツには使わないでください。</p>

  <p class="tip">[単一ファイルコンポーネント](../guide/single-file-components.html)では、`scoped` スタイルは `v-html` 内のコンテンツには適用されません。なぜなら、その HTML は Vue のテンプレートコンパイラによって処理されないからです。スコープ付き CSS を使用した `v-html` のコンテンツを対象とする場合、代わりに [CSS モジュール](https://vue-loader.vuejs.org/ja/features/css-modules.html)やグローバルな `<style>` 要素を BEM などの手動スコープ戦略を用いて使用することができます。</p>

- **例:**

  ```html
  <div v-html="html"></div>
  ```

- **参照:** [テンプレート構文 - 展開](../guide/syntax.html#生の-HTML)

### v-show

- **要求事項:** `any`

- **使用方法:**

  式の値の真偽に応じて、要素の CSS プロパティ `display` をトグルします。

  このディレクティブは条件が変更されたとき、トランジションをトリガします。

- **参照:** [条件付きレンダリング - v-show](../guide/conditional.html#v-show)

### v-if

- **要求事項:** `any`

- **使用方法:**

  バインディングの値の真偽値に基いて要素の描画を行います。要素および、ディレクティブまたはコンポーネントを含むコンテンツは、トグルしている間に破壊され再構築されます。要素が `<template>` 要素ならば、その内容は状態ブロックとして抽出されます。

  このディレクティブは条件が変更されたとき、トランジションをトリガします。

  <p class="tip">`v-if` といっしょに使用されるとき、`v-for` は `v-if` より優先度が高くなります。詳細については<a href="../guide/list.html#v-for-と-v-if">リストレンダリングのガイド</a>を参照してください。</p>

- **参照:** [条件付きレンダリング - v-if](../guide/conditional.html)

### v-else

- **式を受け付けません**

- **制約:** 直前の兄弟要素は `v-if` または `v-else-if` を持つ必要があります。

- **使用方法:**

  `v-if` に対応する "else block" ということを示します。

  ```html
  <div v-if="Math.random() > 0.5">
    Now you see me
  </div>
  <div v-else>
    Now you don't
  </div>
  ```

- **参照:** [条件付きレンダリング - v-else](../guide/conditional.html#v-else)

### v-else-if

> 2.1.0 から新規

- **要求事項:** `any`

- **制約:** 直前の兄弟要素は、`v-if` or `v-else-if` を持たなければなりません。

- **使用方法:**

  `v-if` に対応する "else if block" ということを示します。条件を連結できます。

  ```html
  <div v-if="type === 'A'">
    A
  </div>
  <div v-else-if="type === 'B'">
    B
  </div>
  <div v-else-if="type === 'C'">
    C
  </div>
  <div v-else>
    Not A/B/C
  </div>
  ```

- **参照:** [条件付きレンダリング - v-else-if](../guide/conditional.html#v-else-if)

### v-for

- **要求事項:** `Array | Object | number | string | Iterable (2.6 以降)`

- **使用方法:**

  ソースデータに基づき、要素またはテンプレートブロックを複数回描画します。ディレクティブの値は、繰り返される要素へのエイリアスを提供する為に、特別な文法 (in|of) 式を使う必要があります:

  ``` html
  <div v-for="item in items">
    {{ item.text }}
  </div>
  ```

  あるいは、インデックス(またはオブジェクトで使用されている場合はキー)に対してエイリアスを指定することもできます:

  ``` html
  <div v-for="(item, index) in items"></div>
  <div v-for="(val, key) in object"></div>
  <div v-for="(val, name, index) in object"></div>
  ```

  `v-for` のデフォルトの振舞いは、それらを移動しないで所定の位置の要素にパッチを適用しようとします。要素の順序を変更するのを強制するためには、`key` という特別な属性によって順序のヒントを提供する必要があります:

  ``` html
  <div v-for="item in items" :key="item.id">
    {{ item.text }}
  </div>
  ```

  2.6 以降では、`v-for` はネイティブの `Map` や `Set`を含む、[Iterable プロトコル](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Iteration_protocols#The_iterable_protocol) を実装した値でも動作できるようになりました。ただし、Vue 2.x は今のところ `Map` 値や `Set` 値をリアクティブにはできず、変更を自動的に検知できない点は注意しておく必要があります。

  <p class="tip">`v-if` といっしょに使用されるとき、`v-for` は `v-if` より優先度が高くなります。詳細については<a href="../guide/list.html#v-for-と-v-if">リストレンダリングのガイド</a>を参照してください。</p>

  `v-for` の詳細な使用方法は下記にリンクしたガイドセクション内で説明しています。

- **参照:**
  - [リストレンダリング](../guide/list.html)
  - [key](/guide/list.html#key)

### v-on

- **省略記法:** `@`

- **要求事項:** `Function | Inline Statement | Object`

- **引数:** `event`

- **修飾子:**
  - `.stop` - `event.stopPropagation()` を呼びます。
  - `.prevent` - `event.preventDefault()` を呼びます。
  - `.capture` - キャプチャモードでイベントリスナを追加します。
  - `.self` - イベントがこの要素からディスパッチされたときだけハンドラをトリガします。
  - `.{keyCode | keyAlias}` - 指定したキーが押された時のみトリガされるハンドラです。
  - `.native` - コンポーネントのルート要素上のネイティブイベントに対して購読します。
  - `.once` - 最大 1 回、ハンドラをトリガします。
  - `.left` -（2.2.0 以降）マウスの左ボタンが押された時のみトリガされるハンドラです。
  - `.right` -（2.2.0 以降）マウスの右ボタンが押された時のみトリガされるハンドラです。
  - `.middle` -（2.2.0 以降）マウスの中央ボタンが押された時のみトリガされるハンドラです。
  - `.passive` - (2.3.0 以降) `{ passive: true }` で DOM イベントをアタッチします。

- **使用方法:**

  要素にイベントリスナをアタッチします。イベント種別は引数で示されます。式はメソッド名またはインラインステートメントのいずれかを指定することができ、または修飾子 (modifier) が存在するときは、単純に省略されます。

  通常の要素上で利用した場合、[**ネイティブ DOM イベント**](https://developer.mozilla.org/ja/docs/Web/Reference/Events) だけ購読します。カスタム要素コンポーネント上で利用した場合、子コンポーネント上での **カスタムイベント** の発行を購読します。

  ネイティブな DOM イベントを購読しているとき、メソッドはネイティブなイベントを引数としてだけ受信します。インラインステートメントで使用する場合、ステートメントでは特別な `$event` プロパティに `v-on:click="handle('ok', $event)"` のようにしてアクセスすることができます。

  `2.4.0` からは、`v-on` は引数なしでイベント/リスナーのペアのオブジェクトへのバインディングもサポートしています。オブジェクト構文を使用する場合は修飾子はサポートされません。

- **例:**

  ```html
  <!-- メソッドハンドラ -->
  <button v-on:click="doThis"></button>

  <!-- 動的イベント (2.6.0 以降) -->
  <button v-on:[event]="doThis"></button>

  <!-- インラインステートメント -->
  <button v-on:click="doThat('hello', $event)"></button>

  <!-- 省略記法 -->
  <button @click="doThis"></button>

  <!-- 動的イベントの省略記法 (2.6.0 以降) -->
  <button @[event]="doThis"></button>

  <!-- イベント伝播の停止 -->
  <button @click.stop="doThis"></button>

  <!-- デフォルト挙動を防ぐ -->
  <button @click.prevent="doThis"></button>

  <!-- 式なしでデフォルト挙動を防ぐ -->
  <form @submit.prevent></form>

  <!-- 修飾子の繋ぎ合わせ -->
  <button @click.stop.prevent="doThis"></button>

  <!-- キーエイリアスを使ったキー修飾子 -->
  <input @keyup.enter="onEnter">

  <!-- キーコードを使ったキー修飾子 -->
  <input @keyup.13="onEnter">

  <!-- 最大1回、クリックイベントはトリガされます -->
  <button v-on:click.once="doThis"></button>

  <!-- オブジェクト構文 (2.4.0+) -->
  <button v-on="{ mousedown: doThis, mouseup: doThat }"></button>

  ```

  子コンポーネント上のカスタムイベントを購読できます (ハンドラは "my-event" が子コンポーネント上で発行された時に呼ばれる):

  ```html
  <my-component @my-event="handleThis"></my-component>

  <!-- インラインステートメント -->
  <my-component @my-event="handleThis(123, $event)"></my-component>

  <!-- コンポーネント上のネイティブイベント -->
  <my-component @click.native="onClick"></my-component>
  ```

- **参照:**
  - [イベントハンドリング](../guide/events.html)
  - [コンポーネント - カスタムイベント](../guide/components.html#カスタムイベント)

### v-bind

- **省略記法:** `:`

- **要求事項:** `any (引数あり) | Object (引数なし)`

- **引数:** `attrOrProp (任意)`

- **修飾子:**
  - `.prop` - 属性の代わりに DOM プロパティとして束縛します([違いは何？](https://stackoverflow.com/questions/6003819/properties-and-attributes-in-html#answer-6004028))。もしタグがコンポーネントの場合、`.prop`  はコンポーネントの `$el` にプロパティを設定します。
  - `.camel` - (2.1.0 以降) ケバブケースの属性名をキャメルケースに変換します。
  - `.sync` - (2.3.0 以降) 束縛された値を更新するための、 `v-on` ハンドラに展開する糖衣構文。

- **使用方法:**

  1つ以上の属性またはコンポーネントのプロパティと式を動的に束縛します。

  `class` または `style` 属性と束縛する場合、配列やオブジェクトのような追加の値タイプをサポートします。詳細は下記にリンクしたガイドセクションを参照してください。

  プロパティバインディングに使う場合、プロパティは子コンポーネント内で適切に宣言される必要があります。

  引数なしで使用した場合、名前-値のペアの属性を含むオブジェクトを束縛するため使用することができます。このモードでは、`class` と `style` では配列とオブジェクトをサポートしないことに注意してください。

- **例:**

  ```html
  <!-- 属性を束縛 -->
  <img v-bind:src="imageSrc">

  <!-- 動的な属性名 (2.6.0 以降) -->
  <button v-bind:[key]="value"></button>

  <!-- 省略記法 -->
  <img :src="imageSrc">

  <!-- 動的な属性名の省略記法 (2.6.0 以降) -->
  <button :[key]="value"></button>

  <!-- インライン文字列連結 -->
  <img :src="'/path/to/images/' + fileName">

  <!-- クラスバインディング -->
  <div :class="{ red: isRed }"></div>
  <div :class="[classA, classB]"></div>
  <div :class="[classA, { classB: isB, classC: isC }]">

  <!-- スタイルバインディング -->
  <div :style="{ fontSize: size + 'px' }"></div>
  <div :style="[styleObjectA, styleObjectB]"></div>

  <!-- 属性のオブジェクトのバインディング -->
  <div v-bind="{ id: someProp, 'other-attr': otherProp }"></div>

  <!-- prop 修飾子による DOM 属性バインディング -->
  <div v-bind:text-content.prop="text"></div>

  <!-- prop バインディング。"prop" は my-component 内で宣言される必要があります -->
  <my-component :prop="someThing"></my-component>

  <!-- 親のプロパティの子コンポーネントに渡す --->
  <child-component v-bind="$props"></child-component>

  <!-- XLink -->
  <svg><a :xlink:special="foo"></a></svg>
  ```

  `.camel` 修飾子はDOM 内のテンプレートを使用するときに、`v-bind` 属性名をキャメル化することを可能にします。e.g. SVG の `viewBox` 属性:

  ``` html
    <svg :view-box.camel="viewBox"></svg>
  ```

  文字列テンプレートを使用している場合や、`vue-loader` / `vueify` でコンパイルしている場合は `.camel` は必要ありません。

- **参照:**
  - [クラスとスタイルバインディング](../guide/class-and-style.html)
  - [コンポーネント - プロパティ](../guide/components.html#プロパティ)
  - [コンポーネント - `.sync` 修飾子](../guide/components.html#sync-修飾子)

### v-model

- **要求事項:** コンポーネントの出力、または input 要素 からの値に応じて変化します

- **適用対象制限:**
  - `<input>`
  - `<select>`
  - `<textarea>`
  - コンポーネント

- **修飾子:**
  - [`.lazy`](../guide/forms.html#lazy) - `input` の代わりに `change` イベントを購読します
  - [`.number`](../guide/forms.html#number) - 有効な input の文字列を数値にキャストします
  - [`.trim`](../guide/forms.html#trim) - input をトリムします

- **使用方法:**

  form の input 要素またはコンポーネント上に双方向バインディングを作成します。使い方と注意事項の詳細は、下にリンクしたガイドセクションを参照してください。

- **See also:**
  - [フォーム入力バインディング](../guide/forms.html)
  - [コンポーネント - カスタムイベントを使用してフォーム入力コンポーネント](../guide/components.html#カスタムイベントを使用したフォーム入力コンポーネント)

### v-slot

- **省略記法:** `#`

- **要求事項:** 関数定義の引数部分で有効な JavaScript 式 ([サポートされている環境](../guide/components-slots.html#スロットプロパティの分割代入) では分割代入も使用可能)。省略可 - プロパティがスロットに渡される場合のみ必要。

- **引数:** スロット名 (省略可。デフォルト値 `default`)

- **適用対象制限:**
  - `<template>`
  - [コンポーネント](../guide/components-slots.html#デフォルトスロットしかない場合の省略記法) (デフォルトスロットしかない場合)

- **使用方法:**

  名前付きスロットあるいはプロパティを受け取るスロットとなることを示します。

- **例:**

  ```html
  <!-- 名前付きスロット -->
  <base-layout>
    <template v-slot:header>
      Header content
    </template>

    Default slot content

    <template v-slot:footer>
      Footer content
    </template>
  </base-layout>

  <!-- プロパティを受け取る名前付きスロット -->
  <infinite-scroll>
    <template v-slot:item="slotProps">
      <div class="item">
        {{ slotProps.item.text }}
      </div>
    </template>
  </infinite-scroll>

  <!-- 分割代入でプロパティを受け取るデフォルトスロット -->
  <mouse-position v-slot="{ x, y }">
    Mouse position: {{ x }}, {{ y }}
  </mouse-position>
  ```

  詳細は、以下のリンクを参照してください。

- **参照:**
  - [スロット](../guide/components-slots.html)
  - [RFC-0001](https://github.com/vuejs/rfcs/blob/master/active-rfcs/0001-new-slot-syntax.md)

### v-pre

- **式を受け付けません**

- **使用方法:**

  この要素とすべての子要素のコンパイルをスキップします。生の mustache タグを表示するためにも使うことができます。ディレクティブのない大量のノードをスキップすることで、コンパイルのスピードを上げます。

- **例:**

  ```html
  <span v-pre>{{ this will not be compiled }}</span>
   ```

### v-cloak

- **式を受け付けません**

- **使用方法:**

  このディレクティブは関連付けられた Vue インスタンスのコンパイルが終了するまでの間残存します。`[v-cloak] { display: none }` のような CSS のルールと組み合わせて、このディレクティブは Vue インスタンス が用意されるまでの間、コンパイルされていない Mustache バインディングを隠すのに使うことができます。

- **例:**

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

  `<div>` はコンパイルが終了するまでは不可視となります。

### v-once

- **式を受け付けません**

- **詳細:**

  要素とコンポーネントを**一度**だけ描画します。その後再描画は、要素 / コンポーネントと全てのその子は、静的コンテンツとして扱われスキップされます。これは、更新性能を最適化するために使用することができます。

  ```html
  <!-- 単一要素 -->
  <span v-once>This will never change: {{msg}}</span>
  <!-- 子を持つ要素 -->
  <div v-once>
    <h1>comment</h1>
    <p>{{msg}}</p>
  </div>
  <!-- コンポーネント -->
  <my-component v-once :comment="msg"></my-component>
  <!-- `v-for` ディレクティブ -->
  <ul>
    <li v-for="i in list" v-once>{{i}}</li>
  </ul>
  ```

- **参照:**
  - [テンプレート構文 - 展開](../guide/syntax.html#テキスト)
  - [コンポーネント - `v-once` による安価な静的コンポーネント](../guide/components.html#v-once-を使用した安価な静的コンポーネント)

## 特別な属性

### key

- **要求事項:** `number | string`

  `key` 特別属性は、主に古いリストの代わりにノードの新しいリストを差分算出する VNode を識別するために Vue の仮想 DOM アルゴリズムに対するヒントとして使用されます。キーがない場合、Vue は要素の移動を最小限に抑えるアルゴリズムを使用し、可能な限りその場で同じタイプの要素にパッチ適用/再利用しようとします。キーがある場合は、キーの順序の変化に基づいて要素を並べ替え、そして、もはや存在しないキーを持つ要素は常に削除/破棄されます。

  同じ共通の親を持つ子は、**一意なキー**を持っていなければなりません。重複するキーはエラーを描画する原因になります。

  最も一般的なユースケースは、`v-for` によって組合せられます:

  ``` html
  <ul>
    <li v-for="item in items" :key="item.id">...</li>
  </ul>
  ```

  また、それを再利用するのではなく要素/コンポーネントの置換を強制するために使用することができます。これはあなたが以下のようなことをしたい場合は便利です:

  - 適切にコンポーネントのライフサイクルフックをトリガ
  - トランジションのトリガ

  例:

  ``` html
  <transition>
    <span :key="text">{{ text }}</span>
  </transition>
  ```

  `text` を変更するとき、`<span>` は常にパッチ適用の代わりに置換され、トランジションはトリガされるでしょう。

### ref

- **要求事項:** `string`

  `ref` は要素または子コンポーネントに参照を登録するために使用されます。参照は親コンポーネントの `$refs` オブジェクトのもとに登録されます。プレーンな DOM 要素に使用する場合は、参照はその要素になります。子コンポーネントに使用する場合は、参照はコンポーネントインスタンスになります:

  ``` html
  <!-- vm.$refs.p は DOM ノード -->
  <p ref="p">hello</p>

  <!-- vm.$refs.child は child-component のインスタンス -->
  <child-component ref="child"></child-component>
  ```

  `v-for` で要素/コンポーネントに対して使用されるとき、登録された参照は DOM ノードまたはコンポーネントインスタンスを含んでいる配列になります。

  ref の登録タイミングに関する重要な注意事項として、参照自体は、render 関数の結果として作成されているため、最初の描画においてそれらにアクセスすることができません。それらはまだ存在しておらず、`$refs` はリアクティブではなく、従ってデータバインディングのためにテンプレートでそれを使用すべきではありません。

- **参照:** [子コンポーネントの参照](../guide/components.html#子コンポーネントの参照)

### is

- **要求事項:** `string | Object (コンポーネントオプションのオブジェクト)`

  [動的コンポーネント](../guide/components.html#動的コンポーネント)と [DOM テンプレートの制限](../guide/components.html#DOM-テンプレート解析の注意事項)を回避するために使用します。

  例:

  ``` html
  <!-- currentView が変化するとコンポーネントも変化する -->
  <component v-bind:is="currentView"></component>

  <!-- `<my-row>` は `<table>` 要素内では無効なため必要で、それゆえ巻き上げられます -->
  <table>
    <tr is="my-row"></tr>
  </table>
  ```

  詳しい使用方法については、上記のリンクを参照してください。

- **参照:**
  - [動的コンポーネント](../guide/components.html#動的コンポーネント)
  - [DOM-テンプレート解析の注意事項](../guide/components.html#DOM-テンプレート解析の注意事項)

### slot <sup style="color:#c92222">非推奨</sup>

**2.6.0 以降では [v-slot](#v-slot) を使うこと**

- **要求事項:** `string`

  子コンポーネントに挿入されるコンテンツに対して、どの名前付きスロットのコンテンツになるかを示すために使われます。

- **参照:** [`slot` 属性による名前付きスロット](../guide/components-slots.html#slot-属性による名前付きスロット)

### slot-scope <sup style="color:#c92222">非推奨</sup>

**2.6.0 以降では [v-slot](#v-slot) を使うこと**

- **要求事項:** `function argument expression`

- **使用方法:**

  要素またはコンポーネントがスコープ付きスロットとなることを示すために使われます。属性の値は、関数シグネチャの引数部分で有効な JavaScript 式となる必要があります。これは、サポートされている環境では式に ES2015 の分割代入が使えることを意味します。2.5.0 以降では、[`scope`](#scope-削除) を置き換えます。

  この属性は、動的なバインディングはサポートしません。

- **参照:** [`slot-scope` 属性によるスコープ付きスロット](../guide/components-slots.html#slot-scope-属性によるスコープ付きスロット)

### scope <sup style="color:#c92222">削除</sup>

**2.5.0 以降では [slot-scope](#slot-scope-非推奨) で置き換え。2.6.0 以降では [v-slot](#v-slot) を使うこと**

`<template>` 要素がスコープ付きスロットとなることを示すために使われます。

- **使用方法:**

  [`slot-scope`](#slot-scope-非推奨) と同じですが、`scope` は `<template>` 要素に対してのみ使用できます。

## 組み込みコンポーネント

### component

- **プロパティ:**
  - `is` - string | ComponentDefinition | ComponentConstructor
  - `inline-template` - boolean

- **使用方法:**

  動的コンポーネントの描画に対する"メタコンポーネント"。描画する実際のコンポーネントは `is` プロパティによって決定されます:

  ```html
  <!-- 動的コンポーネントは、vm 上の `componentId` プロパティ によって制御される -->
  <component :is="componentId"></component>

  <!-- また登録されたコンポーネントまたはプロパティとして渡されるコンポーネントを描画できる -->>
  <component :is="$options.components.child"></component>
  ```

- **参照:** [動的コンポーネント](../guide/components.html#動的コンポーネント)

### transition

- **プロパティ:**
  - `name` - string、自動的に生成されるトランジション CSS クラス名に使用します。例: `name: 'fade'` は `.fade-enter`、`.fade-enter-active` などに自動で展開します。デフォルトは `"v"` です。
  - `appear` - boolean、初期描画でのトランジションを適用するかどうか。デフォルトは `false` です。
  - `css` - boolean、CSS トランジションクラスを提供するかどうか。デフォルトは `true`。`false` に設定する場合、コンポーネントイベント経由登録された JavaScript フックだけトリガします。
  - `type` - string、トランジションの終了タイミングを決定するためにトランジションイベントのタイプを指定します。利用可能な値は `"transition"` と `"animation"` です。デフォルトでは自動的により長い時間を持つタイプを検出します。
  - `mode` - string、leaving/entering トランジションのタイミングシーケンスを制御します。利用可能なモードは、`"out-in"` と `"in-out"` です。デフォルトは同時になります。
  - `duration` - number | { `enter`: number, `leave`: number } トランジションの期間を指定します。デフォルトでは、Vue はルートのトランジション要素の最初の `transitionend` または `animationend` イベントを待ちます。
  - `enter-class` - string
  - `leave-class` - string
  - `appear-class` - string
  - `enter-to-class` - string
  - `leave-to-class` - string
  - `appear-to-class` - string
  - `enter-active-class` - string
  - `leave-active-class` - string
  - `appear-active-class` - string

- **イベント:**
  - `before-enter`
  - `before-leave`
  - `before-appear`
  - `enter`
  - `leave`
  - `appear`
  - `after-enter`
  - `after-leave`
  - `after-appear`
  - `enter-cancelled`
  - `leave-cancelled` (`v-show` only)
  - `appear-cancelled`

- **使用方法:**

  `<transition>` は**単一**要素/コンポーネントに対してトランジション効果を提供します。`<transition>` は余計な DOM 要素を描画しません。またコンポーネント階層をインスペクトにおいて表示しません。単純にトランジションの振舞いをラップされたコンテンツ内部に適用します。

  ```html
  <!-- 単一要素 -->
  <transition>
    <div v-if="ok">toggled content</div>
  </transition>

  <!-- 動的コンポーネント -->
  <transition name="fade" mode="out-in" appear>
    <component :is="view"></component>
  </transition>

  <!-- イベントのフック -->
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
        // 引数として DOM 要素を `el` で渡され、何かを処理を...
      }
    }
    ...
  }).$mount('#transition-demo')
  ```

- **参照:** [トランジション効果](../guide/transitions.html)

### transition-group

- **プロパティ:**
  - `tag` - string、デフォルトは `span`
  - `move-class` - トランジションの移動中に提供される CSS クラスを上書きします
  - `mode` を除いて、`<transition>` と同じプロパティも公開します

- **イベント:**
  - `<transition>` と同じイベントも公開します。

- **使用方法:**

  `<transition-group>` は**複数の要素/コンポーネント**に対してトランジション効果を提供します。`<transition-group>` はあるがままに DOM 要素を描画します。デフォルトでは `<span>` で描画し、`tag` 属性経由で要素を描画するよう設定できます。

  `<transition-group>` での全ての子は、アニメーションを正しく動作させるために**一意なキーで割り振れられて**なければならないことに注意してください。

  `<transition-group>` は CSS transform 経由によるトランジション移動をサポートします。更新後、スクリーン上の子の位置が変更されたとき、CSS クラス (`name` 属性または `move-class` による設定か自動的に生成された) の移動を適用します。もし、クラスの移動が適用されるとき、CSS `transform` プロパティが"トランジション可能"な場合、要素は [FLIP 技術](https://aerotwist.com/blog/flip-your-animations/)を使用して宛先に滑らかにアニメーション化されます。

  ```html
  <transition-group tag="ul" name="slide">
    <li v-for="item in items" :key="item.id">
      {{ item.text }}
    </li>
  </transition-group>
  ```

- **参照:** [トランジション効果](../guide/transitions.html)

### keep-alive

- **プロパティ:**
  - `include` - 文字列または正規表現または配列。これと一致するコンポーネントだけがキャッシュされます。
  - `exclude` - 文字列または正規表現または配列。これと一致するコンポーネントはキャッシュされません。
  - `max` - 数値。キャッシュするコンポーネントインスタンスの最大数。

- **使用方法:**

  動的コンポーネント周りでラップされるとき、`<keep-alive>` はそれらを破棄しないで非アクティブなコンポーネントのインスタンスをキャッシュします。`<trasition>` に似ていて、`<keep-alive>` はそれ自身 DOM 要素で描画されない抽象型コンポーネントです。`activated` と `deactivated` ライフサイクルフックはそれに応じて呼び出されます。

  コンポーネントが `<keep-alive>` 内部でトグルされるとき、`activated` と `deactivated` ライフサイクルフックはそれに応じて呼び出されます。

  > 2.2.0 以降では、`<keep-alive> `ツリーの中の全てのネストされたコンポーネントに対して、 `activated` および `deactivated` を発行します。

  主に、コンポーネント状態を保存したり、再描画を避けるために使用されます。

  ```html
  <!-- 基本 -->
  <keep-alive>
    <component :is="view"></component>
  </keep-alive>

  <!-- children の複数条件 -->
  <keep-alive>
    <comp-a v-if="a > 1"></comp-a>
    <comp-b v-else></comp-b>
  </keep-alive>

  <!-- `<transition>` といっしょに使用する -->
  <transition>
    <keep-alive>
      <component :is="view"></component>
    </keep-alive>
  </transition>
  ```

  `<keep-alive>` は、直接 1 つの子コンポーネントがトグルされているケースに対して設計されていることに注意してください。それが、 `v-for` 内部にある場合は動作しません。上記のように複数の条件付きで子がある場合は、`<keep-alive>` では一度に 1 つの子だけ描画されます。

- **`include` と `exclude`**

  > 2.1.0 から新規

  `include` と `exclude` プロパティは、コンポーネントが条件付きでキャッシュされることを可能にします。両方のプロパティはコンマ区切りの文字列、正規表現または配列のいずれかです:

  ``` html
  <!-- コンマで区切れた文字列 -->
  <keep-alive include="a,b">
    <component :is="view"></component>
  </keep-alive>

  <!-- 正規表現 (`v-bind` を使用する) -->
  <keep-alive :include="/a|b/">
    <component :is="view"></component>
  </keep-alive>

  <!-- Array (`v-bind` を使用する) -->
  <keep-alive :include="['a', 'b']">
    <component :is="view"></component>
  </keep-alive>
  ```

  一致は、まず `name` オプションが利用できない場合、コンポーネント自身の `name` オプションでローカル登録名（親の `components` オプションのキー）をチェックします。匿名のコンポーネントは照合できません。

- **`max`**

  > 2.5.0 から新規

  キャッシュするコンポーネントインスタンスの最大数。この数に達すると、新しいインスタンスを作成する前に、キャッシュされたコンポーネントインスタンスのうち最も最近アクセスされていないものが破棄されます。

  ``` html
  <keep-alive :max="10">
    <component :is="view"></component>
  </keep-alive>
  ```

  <p class="tip">`<keep-alive>` はキャッシュされるインスタンスを持っていないため、関数型コンポーネントで動作しません。</p>

- **参照:** [動的コンポーネント - keep-alive](../guide/components.html#keep-alive)

### slot

- **プロパティ:**
  - `name` - string、名前付き slot に対して使用されます

- **使用方法:**

  `<slot>` はコンポーネントのテンプレートにおいてコンテンツ配信のアウトレットとして提供します。`<slot>` 自身置き換えられます。

  詳しい使い方については、以下のリンク先のガイドを参照してください。

- **参照:** [スロットによるコンテンツ配信](../guide/components.html#スロットによるコンテンツ配信)

## VNode インターフェイス

- [VNode クラスの宣言](https://github.com/vuejs/vue/blob/dev/src/core/vdom/vnode.js)を参照してください。

## サーバサイドレンダリング

- [vue-server-renderer パッケージのドキュメント](https://github.com/vuejs/vue/tree/dev/packages/vue-server-renderer)を参照してください。
