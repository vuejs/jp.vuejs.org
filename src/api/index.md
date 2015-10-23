---
type: api
---

## Global Config

`Vue.config` は Vue のグローバル設定を含んでいるオブジェクトです。あなたのアプリケーションが読み込まれる前に、下記のプロパティを変更することが出来ます:

### debug

- **型:** `Boolean`

- **デフォルト:** `false`

- **利用方法:**

  ``` js
  Vue.config.debug = true
  ```

  デバッグモードでは、 Vue は下記の動作を実行します:

  1. 全て警告としてスタックトレースを出力します。

  2. 全てのアンカーノードは DOM でコメントノードとして表示します。これはレンダリングされた結果の構造を詳しく調べるために容易になります。

  <p class="tip">デバッグモードは、 production ビルドのみ有効です。</p>

### delimiters

- **型:** `Array<String>`

- **デフォルト:** `{% raw %}["{{", "}}"]{% endraw %}`

- **利用方法:**

  ``` js
  // ES6 テンプレート文字列スタイル
  Vue.config.delimiters = ['${', '}']
  ```

  プレーンテキスト展開デリミタを変更します。

### unsafeDelimiters

- **型:** `Array<String>`

- **デフォルト:** `{% raw %}["{{{", "}}}"]{% endraw %}`

- **利用方法:**

  ``` js
  // より危険に見えるようにします
  Vue.config.delimiters = ['{!!', '!!}']
  ```

  Raw HTML 展開デリミタを変更します。

### silent

- **型:** `Boolean`

- **デフォルト:** `false`

- **利用方法:**

  ``` js
  Vue.config.silent = true
  ```

  Vue.js のすべてのログと警告を抑制します。

### async

- **型:** `Boolean`

- **デフォルト:** `true`

- **利用方法:**

  ``` js
  Vue.config.async = false
  ```

  非同期モードがオフの場合、Vue はデータ変更を検知した時に、すべての DOM 更新を同期的に実行します。これは幾つかのシナリオでのデバッグに役立つかもしれませんが、パフォーマンスの悪化や watch のコールバックが呼ばれる順序に影響を及ぼす可能性があります。 ** `async: false` は本番環境での利用は非推奨です。 **

## Global API

### Vue.extend( options )

- **引数:**
  - `{Object} options`

- **利用方法:**

  Vue コンストラクタベースの "サブクラス" を作成します。引数はコンポーネントオプションを含むオブジェクトである必要があります。

  ここでの注意すべき特別なケースは、`el` と `data` で、このケースでは関数にしなければなりません。

  ``` html
  <div id="mount-point"></div>
  ```

  ``` js
  // 再利用可能なコンストラクタを作成
  var Profile = Vue.extend({
    template: '<p>{{firstName}} {{lastName}} aka {{alias}}</p>'
  })
  // Profile のインスタンスを作成
  var profile = new Profile({
    data: {
      firstName: 'Walter',
      lastName: 'White',
      alias: 'Heisenberg'
    }  
  })
  // 要素上にマウントする
  profile.$mount('#mount-point')
  ```

  結果は以下のようになります:

  ``` html
  <p>Walter White aka Heisenberg</p>
  ```

- **参考:** [Components](/guide/components.html)

### Vue.nextTick( callback )

- **引数:**
  - `{Functon} callback`

- **利用方法:**

  callback を延期し、DOM の更新サイクル後に実行します。DOM 更新を待ち受けるために、いくつかのデータを変更した直後に使用してください。

  ``` js
  // データの編集
  vm.msg = 'Hello'
  // DOM はまだ更新されていない
  Vue.nextTick(function () {
    // DOM が更新されている
  })
  ```

- **参考:** [Async Update Queue](/guide/reactivity.html#Async_Update_Queue)

### Vue.set( object, key, value )

- **引数:**
  - `{Object} object`
  - `{String} key`
  - `{*} value`

- **利用方法:**

  オブジェクトにプロパティを設定します。オブジェクトが reactive の場合、プロパティが reactive プロパティとして作成されることを保証し、ビュー更新をトリガします。これは主に Vue がプロパティの追加を検知できないという制約を回避する為に使われます。

- **参考:** [Reactivity in Depth](/guide/reactivity.html)

### Vue.delete( object, key )

- **引数:**
  - `{Object} object`
  - `{String} key`

- **利用方法:**

  オブジェクトにプロパティを設定します。オブジェクトが reactive の場合、ビュー更新をトリガされることを保証します。これは主に Vue がプロパティの削除を検知できないという制約を回避する為に使われますが、使う必要があることはまれです。

- **参考:** [Reactivity in Depth](/guide/reactivity.html)

### Vue.directive( id, [definition] )

- **引数:**
  - `{String} id`
  - `{Function | Object} [definition]`

- **利用方法:**
  
  グローバルディレクティブを登録または取得します。

  ``` js
  // 登録
  Vue.directive('my-directive', {
    bind: function () {},
    update: function () {},
    unbind: function () {}
  })

  // 登録 (シンプルな function directive)
  Vue.directive('my-directive', function () {
    // `update` として呼ばれる
  })

  // ゲッター。もし登録されていればディレクティブ定義を返す。
  var myDirective = Vue.directive('my-directive')
  ```

- **参考:** [Custom Directives](/guide/custom-directive.html)

### Vue.elementDirective( id, [definition] )

- **引数:**
  - `{String} id`
  - `{Object} [definition]`

- **利用方法:**

  グローバルエレメントディレクティブに登録または取得します。

  ``` js
  // 登録
  Vue.elementDirective('my-element', {
    bind: function () {},
    // エレメントディレクティブは `update` を利用しない
    unbind: function () {}
  })

  // ゲッター。もし登録されていればディレクティブ定義を返す
  var myDirective = Vue.elementDirective('my-element')
  ```

- **参考:** [Element Directives](/guide/custom-directive.html#Element_Directives)

### Vue.filter( id, [definition] )

- **引数:**
  - `{String} id`
  - `{Function | Object} [definition]`

- **利用方法:**

  Register or retrieve a global filter.

  ``` js
  // 登録
  Vue.filter('my-filter', function (value) {
    // 処理された値を返す
  })

  // 双方向フィルタ
  Vue.filter('my-filter', {
    read: function () {},
    write: function () {}
  })

  // ゲッター。登録されていればフィルタを返す
  var myFilter = Vue.filter('my-filter')
  ```

- **参考:** [Custom Filter](/guide/custom-filter.html)

### Vue.component( id, [definition] )

- **引数:**
  - `{String} id`
  - `{Function | Object} [definition]`

- **利用方法:**

  グローバルコンポーネントに登録または取得します。

  ``` js
  // 拡張コンストラクタを登録
  Vue.component('my-component', Vue.extend({ /* ... */}))

  // オプションオブジェクトを登録 (Vue.extend を自動的に呼ぶ)
  Vue.component('my-component', { /* ... */ })

  // 登録されたコンポーネントを取得 (常にコンストラクタを返す)
  var MyComponent = Vue.component('my-component')
  ```

- **参考:** [Components](/guide/components.html).

### Vue.transition( id, [hooks] )

- **引数:**
  - `{String} id`
  - `{Object} [hooks]`

- **利用方法:**

  グローバルトランジションフックオブジェクトに登録または取得する。

  ``` js
  // 登録
  Vue.transition('fade', {
    enter: function () {},
    leave: function () {}
  })

  // 登録されたフックを返す
  var fadeTransition = Vue.transition('fade')
  ```

- **参考:** [Transitions](/guide/transitions.html).

### Vue.partial( id, [partial] )

- **引数:**
  - `{String} id`
  - `{String} [partial]`

- **利用方法:**

  グローバルテンプレートパーシャル文字列に登録または取得する。

  ``` js
  // 登録
  Vue.partial('my-partial', '<div>Hi</div>')

  // 登録されたパーシャルを返す
  var myPartial = Vue.partial('my-partial')
  ```

- **参考:** [Special Elements - &lt;partial&gt;](#partial).

### Vue.use( plugin, [options] )

- **引数:**
  - `{Object | Function} plugin`
  - `{Object} [options]`

- **利用方法:**

  Vue.js のプラグインをインストールします。もし plugin がオブジェクトなら、それは `install` メソッドを実装していなければなりません。もし、それ自身が関数ならば、それは install メソッドとして扱われます。install メソッドは、Vue を引数として呼び出されます。

- **参考:** [Plugins](/guide/plugins.html).

### Vue.mixin( mixin )

- **引数:**
  - `{Object} mixin`

- **利用方法:**

  全ての Vue インスタンスが作成された後に影響を及ぼす、ミックスイン (mixin) をグローバルに適用します。これは、コンポーネントにカスタム動作を注入するために、プラグイン作成者によって使用することができます。**アプリケーションコードでの使用は推奨されません。**

- **参考:** [Global Mixins](/guide/mixins.html#Global_Mixin)

## Options / Data

### data

- **型:** `Object | Function`

- **制約:** `Vue.extend()` の中で使用する場合は、`Function` タイプのみを受け付けます。

- **詳細:**

  Vue インスタンスのためのデータオブジェクトです。Vue.js は再帰的にインスタンスのプロパティを getter/setter に変換し、"reactive" にします。**オブジェクトはプレーンなネイティブオブジェクトである必要があります**。既存の getter/setter 及びプロトタイププロパティは無視されます。複雑なオブジェクトを監視することは推奨されません。

  一度インスタンスが生成されると、オリジナルのデータオブジェクトは `vm.$data` としてアクセス出来ます。Vue インスタンスはデータオブジェクト上に見つかったすべてのプロパティに代理アクセスします。

  Vue の内部的なプロパティや API メソッドと衝突する可能性があるため、`_` または `$` から始まるプロパティは Vue インスタンスにプロキシ**されない**ことに注意してください。それらは `vm.$data._property` としてアクセスできます。

- **例:**

  ``` js
  var data = { a: 1 }

  // インスタンスの直接生成
  var vm = new Vue({
    data: data
  })
  vm.a // -> 1
  vm.$data === data // -> true

  // Vue.extend() 内では、ファンクションを使わなければいけない
  var Component = Vue.extend({
    data: function () {
      return { a: 1 }
    }
  })
  ```

- **参考:** [Reactivity in Depth](/guide/reactivity.html).

### props

- **型:** `Array | Object`

- **詳細:**

  親コンポーネントからデータを受け取るためにエクスポートされた属性のリスト/ハッシュです。シンプルな配列ベースのシンタックス、そして型チェック、カスタム検証そしてデフォルト値などの高度な構成を可能とする配列ベースの代わりとなるオブジェクトベースのシンタックスがあります。

- **例:**

  ``` js
  // シンプルシンタックス
  Vue.component('props-demo-simple', {
    props: ['size', 'myMessage']
  })

  // バリデーション付きのオブジェクトシンタックス
  Vue.component('props-demo-advanced', {
    props: {
      // 単なる型チェック
      size: Number,
      // 型チェックとその他のバリデーション
      name: {
        type: String,
        required: true
      }
    }
  })
  ```

- **参考:** [Props](/guide/components.html#Props)

### computed

- **型:** `Object`

- **詳細:**

  Vue インスタンスに組み込まれる Computed properties です。すべての getter や setter は、自動的に Vue インスタンスにバインドされた `this` コンテキストをもちます。

- **例:**

  ```js
  var vm = new Vue({
    data: { a: 1 },
    computed: {
      // get のみ。必要なのはファンクション一つだけ
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

- **参考:**
  - [Computed Properties](/guide/computed.html)
  - [Reactivity in Depth: Inside Computed Properties](/guide/reactivity.html#Inside_Computed_Properties)

### methods

- **型:** `Object`

- **詳細:**

  Vue インスタンスに組み込まれるメソッドです。VM インスタンスでは、これらのメソッドに直接アクセスでき、ディレクティブ表現で使用することもできます。すべてのメソッドは、Vue インスタンスに自動的にバインドされた `this` コンテキストをもちます。

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

- **参考:** [Methods and Event Handling](/guide/events.html)

### watch

- **型:** `Object`

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
      // 深い watcher
      'c': {
        handler: function (val, oldVal) { /* ... */ },
        deep: true
      }
    }
  })
  vm.a = 2 // -> new: 2, old: 1
  ```

- **参考:** [Instance Methods - vm.$watch](#vm-watch)

## Options / DOM

### el

- **型:** `String | HTMLElement | Function`

- **制約:** `Vue.extend()` の中で使用する場合は、`Function` タイプのみを受け付けます。

- **詳細:**

  既存の DOM 要素に Vue インスタンスを与えます。CSS セレクタの文字列、実際の HTML 要素、または、HTML 要素を返す関数をとることができます。単にマウンティングポイントとして役に立つ要素が提供されていることに注意してください。`replace` が false に設定されていない限り、テンプレートが提供される場合は置き換えられます。解決された要素は、`vm.$el` としてアクセス可能になります。

  `Vue.extend` の中で使用されているとき、それぞれのインスタンスが独立に要素を作るような関数が与えられる必要があります。

  もしインスタンス化の際にオプションが有効であれば、そのインスタンスはただちにコンパイルの段階に入ります。さもなければ、ユーザーがコンパイルを始めるために手作業で明示的に `vm.$mount()` を呼ぶ必要があります。

- **参考:** [Lifecycle Diagram](/guide/instance.html#Lifecycle_Diagram)

### template

- **型:** `String`

- **詳細:**

  Vue インスタンスに対してマークアップとして使用するための、文字列のテンプレートです。デフォルトで、テンプレートはマウントされた要素として**置換**されます。`replace` オプションが `false` に設定されるときは、反対にマウントされた要素に挿入されます。両方の場合において、コンテンツ挿入位置がテンプレートの中にない限り、マウントされた要素内部のあらゆる既存のマークアップは無視されます。

  もし `#` による文字列で始まる場合、querySelector として使用され、選択された要素の innerHTML をテンプレート文字列として使用します。これにより、テンプレートを組み込むための共通の `<script type="x-template">` というやり方を使うことができるようになります。

  もしテンプレートが 1 トップレベル以上ノードを含む場合は、インスタンスはフラグメントインスタンスになることに注意してください。すなわち、それは単一ノードではなくむしろノードのリストを管理します。フラグメントインスタンスのマウント位置上にある非 flow-control ディレクティブは無視されます。

- **参考:**
  - [Lifecycle Diagram](/guide/instance.html#Lifecycle_Diagram)
  - [Content Distribution](/guide/components.html#Content_Distribution_with_Slots)
  - [Fragment Instance](/guide/components.html#Fragment_Instance)

### replace

- **型:** `Boolean`  

- **デフォルト:** `true`

- **制約:** **template** オプションが存在する時のみ有効なので注意してください。

- **詳細:**

  マウントされている要素を template で置き換えるかどうかを意味します。もし `false` を設定する場合は、template はコンテンツ内部の要素を要素自身で置き換えずに上書きします。

- **例**:

  ``` html
  <div id="replace"></div>
  ```

  ``` js
  new Vue({
    el: '#replace',
    template: '<p>replaced</p>'
  })
  ```

  結果は以下の通り:

  ``` html
  <p>replaced</p>
  ```

  `replace` が `false` に設定される時との比較:

  ``` html
  <div id="insert"></div>
  ```

  ``` js
  new Vue({
    el: '#insert',
    replace: false,
    template: '<p>inserted</p>'
  })
  ```

  結果は以下の通り:

  ``` html
  <div id="insert">
    <p>inserted</p>
  </div>
  ```

## Options / Lifecycle Hooks

### created

- **型:** `Function`

- **詳細:**
  
  インスタンスが作成された後に、同期的に呼ばれます。この段階では、インスタンスは次の設定されたオプションの処理を終了しています: data の監視、computed properties、methods、watch / event コールバック。 しかしながら、DOM のコンパイルは開始されておらず、`$el` プロパティはまだ有効ではありません。

- **参考:** [Lifecycle Diagram](/guide/instance.html#Lifecycle_Diagram)

### beforeCompile

- **型:** `Function`

- **詳細:**
  
  コンパイルが開始される寸前に呼ばれます。

- **参考:** [Lifecycle Diagram](/guide/instance.html#Lifecycle_Diagram)

### compiled

- **型:** `Function`

- **詳細:**

  コンパイルが終了した後に呼ばれます。この段階では、すべてのディレクティブはリンクされているため、データの変更は DOM の更新のトリガになります。しかし、`$el` がドキュメントに挿入されていることは保証されません。

- **参考:** [Lifecycle Diagram](/guide/instance.html#Lifecycle_Diagram)

### ready

- **型:** `Function`

- **詳細:**

  コンパイルが終了した後に呼ばれます。**そして**、`$el` が**ドキュメントの中に初めて挿入されます** (すなわち、最初の `attached` フックの直後)。この挿入は `ready` フックのトリガになるように（`vm.$appendTo()` のようなメソッドやディレクティブの更新の結果をもった） Vue 経由で実行されなくてはならないことに注意してください。

- **参考:** [Lifecycle Diagram](/guide/instance.html#Lifecycle_Diagram)

### attached

- **型:** `Function`

- **詳細:**
  
  `vm.$el` がディレクティブもしくは VM インスタンスもしくは`$appendTo()` のような VM インスタンスのメソッドによって DOM に追加されたときに呼ばれます。`vm.$el` の直接の操作はこのフックのトリガに**なりません**。

### detached

- **型:** `Function`

- **詳細:**
  
  ディレクティブか VM インスタンスのメソッドによって DOM から `vm.$el` が削除されたときに呼ばれます。ディレクティブの `vm.$el` の操作はこのフックのトリガに**なりません**。

### beforeDestroy

- **型:** `Function`

- **詳細:**
  
  Vue インスタンスが破棄される寸前に呼ばれます。この段階では、インスタンスはまだ完全に使用可能ではありません。

- **参考:** [Lifecycle Diagram](/guide/instance.html#Lifecycle_Diagram)

### destroyed

- **型:** `Function`

- **詳細:**

  Vue インスタンスが破棄された後に呼ばれます。このフックが呼ばれたとき、Vue インスタンスのすべてのバインディングとディレクティブはバインドを解かれ、すべての子 Vue インスタンスも破棄されます。

  もし leave トランジションが存在する場合、`destroyed` フックはトランジションが終了した**後に**呼ばれます。

- **参考:** [Lifecycle Diagram](/guide/instance.html#Lifecycle_Diagram)

## Options / Assets

### directives

- **型:** `Object`

- **詳細:**

  Vue インスタンスで使用できるような、ディレクティブのハッシュです。

- **参考:**
  - [Custom Directives](/guide/custom-directive.html)
  - [Assets Naming Convention](/guide/components.html#Assets_Naming_Convention)

### elementDirectives

- **型:** `Object`

- **詳細:**

  Vue インスタンスで使用できるような、エレメントディレクティブのハッシュです。

- **参考:**
  - [Element Directives](/guide/custom-directive.html#Element_Directives)
  - [Assets Naming Convention](/guide/components.html#Assets_Naming_Convention)

### filters

- **型:** `Object`

- **詳細:**

  Vue インスタンスで使用できるようなフィルタのハッシュです。

- **参考:**
  - [Custom Filters](/guide/custom-filter.html)
  - [Assets Naming Convention](/guide/components.html#Assets_Naming_Convention)

### components

- **型:** `Object`

- **詳細:**

  Vue インスタンスで使用できるようなコンポーネントのハッシュです。

- **参考:**
  - [Components](/guide/components.html)

### transitions

- **型:** `Object`

- **詳細:**

  Vue インスタンスで使用できるようなトランジションのハッシュです。

- **参考:**
  - [Transitions](/guide/transitions.html)

### partials

- **型:** `Object`

- **詳細:**

  Vue インスタンスで使用できるような partial 文字列のハッシュです。

- **参考:**
  - [Special Elements - partial](#partial)

## Options / Misc

### parent

- **型:** `Vue instance`

- **詳細:**

  作成されるインスタンスの親インスタンスを指定します。二つのインスタンス間で親子関係を確立します。親は子の `this.$parent` としてアクセス可能となり、子は親の `$children` 配列に追加されます。

- **参考:** [Parent-Child Communication](/guide/components.html#Parent-Child_Communication)

### events

- **型:** `Object`

- **詳細:**

  キーが監視するべきイベントで、値が対応するコールバックのオブジェクトです。DOM のイベントというよりはむしろ Vue のイベントです。値はメソッド名の文字列をとることもできます。Vue インスタンスはインスタンス化の際にオブジェクトの各エントリに対して `$on()` を呼びます。

- **例:**

  ``` js
  var vm = new Vue({
    events: {
      'hook:created': function () {
        console.log('created!')
      },
      greeting: function (msg) {
        console.log(msg)
      },
      // メソッド名の文字列も使用可能
      bye: 'sayGoodbye'
    },
    methods: {
      sayGoodbye: function () {
        console.log('goodbye!')
      }
    }
  }) // -> 作られた!
  vm.$emit('greeting', 'hi!') // -> hi!
  vm.$emit('bye')             // -> goodbye!
  ```

- **参考:**
  - [Instance Methods - Events](#Instance_Methods_/_Events)
  - [Parent-Child Communication](/guide/components.html#Parent-Child_Communication)

### mixins

- **型:** `Array`

- **詳細:**

  `mixins` オプションは、ミックスインオブジェクトの配列を受け入れます。ミックスインオブジェクトは、通常のインスタンスオブジェクトのようなインスタンスオプションを含むことができ、`Vue.extend()` における同じオプションを併合するロジックを使った結果のオプションに対して併合されます。例えば、もしあなたのミックスインが作成されたフックをもち、コンポーネントそのものもそれを持っていた場合、両方の関数が呼ばれます。

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

- **参考:** [Mixins](/guide/mixins.html)

### name

- **型:** `String`

- **制約:** `Vue.extend()` 内で使われた時のみ有効なので注意してください。

- **詳細:**

  テンプレート内でのコンポーネント自身の再帰呼び出しを許可します。コンポーネントは `Vue.component()` でグローバルに登録され、グローバル ID はその名前に自動的に設定される事に注意してください。

  `name` オプションのもう一つの利点は、コンソールインスペクションです。拡張された Vue コンポーネントをコンソールのインスペクタで見る時、デフォルトコンストラクタ名は `VueComponent` です。これは十分に説明的ではありません。`name` オプションを `Vue.extend()` に渡すことで、より良いインスペクタ出力を得られ、今見ているコンポーネントを知る事ができます。文字列はキャメルケース化されてコンストラクタ名に使われます。

- **例:**

  ``` js
  var Ctor = Vue.extend({
    name: 'stack-overflow',
    template:
      '<div>' +
        // 自分自身の再帰呼び出し
        '<stack-overflow></stack-overflow>' +
      '</div>'
  })

  // これは実際のところ、スタックの最大サイズ超過エラーとなります。
  // しかし動くと仮定してみましょう...
  var vm = new Ctor()

  console.log(vm) // -> StackOverflow {$el: null, ...}
  ```

## Instance Properties

### vm.$data

- **型:** `Object`

- **詳細:**

  Vue インスタンスが監視しているデータオブジェクト。新しいオブジェクトでスワップできます。Vue インスタンスプロキシはデータオブジェクトのプロパティにアクセスします。

### vm.$el

- **型:** `HTMLElement`

- **リードオンリー**

- **詳細:**

  Vue インスタンスが管理している DOM 要素。これは[フラグメントインスタンス](/guide/components.html#Fragment_Instance)向けであることに注意が必要で、`vm.$el` はフラグメントの開始位置を示すアンカーノードを返します。

### vm.$options

- **型:** `Object`

- **リードオンリー**

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

- **リードオンリー**

- **詳細:**

  もし現在のインスタンスが1つ持つ場合は親のインスタンス。

### vm.$root

- **型:** `Vue instance`

- **リードオンリー**

- **詳細:**

  現在のコンポーネントツリーのルート Vue インスタンス。もし現在のインスタンスが親ではない場合、この値はそれ自身でしょう。

### vm.$children

- **型:** `Array<Vue instance>`

- **リードオンリー**

- **詳細:**

  現在のインスタンスの直接的な子コンポーネント。

### vm.$refs

- **型:** `Object`

- **リードオンリー**

- **詳細:**

  `v-ref` で登録した子コンポーネントを保持するオブジェクト。

- **参考:**
  - [Child Component Refs](/guide/components.html#Child_Component_Refs)
  - [v-ref](#v-ref).

### vm.$els

- **型:** `Object`

- **リードオンリー**

- **詳細:**

  `v-el` で登録した DOM 要素を保持するオブジェクト。

- **参考:** [v-el](#v-el).

## Instance Methods / Data

### vm.$watch( expOrFn, callback, [options] )

- **引数:**
  - `{String|Function} expOrFn`
  - `{Function} callback`
  - `{Object} [options]`
    - `{Boolean} deep`
    - `{Boolean} immediate`

- **戻り値:** `{Function} unwatch`

- **利用方法:**

  Vue インスタンス上でのひとつの式または computed function の変更を監視します。コールバックは新しい値と古い値とともに呼びだされます。引数の式には、単一の keypath か、任意の有効なバインディング式を入れることができます。

- **例:**

  ``` js
  // キーパス
  vm.$watch('a.b.c', function (newVal, oldVal) {
    // 何かする
  })

  // 式
  vm.$watch('a + b', function (newVal, oldVal) {
    // 何かする
  })

  // ファンクション
  vm.$watch(
    function () {
      return this.a + this.b
    },
    function (newVal, oldVal) {
      // 何かする
    }
  )
  ```

  `vm.$watch` はコールバックの実行を停止する unwatch 関数を返します。

  ``` js
  var unwatch = vm.$watch('a', cb)
  // 後で watcher を破壊する
  unwatch()
  ```

- **Option: deep**

  オブジェクトの中のネストされた値の変更を検出するには、options 引数に `deep: true` を渡す必要があります。Array の値変更に対しては、こうする必要はないことに注意してください。

  ``` js
  vm.$watch('someObject', callback, {
    deep: true
  })
  vm.someObject.nestedValue = 123
  // コールバックが発火する
  ```

- **Option: immediate**

  options 引数に `immediate: true` を渡すと、その時の式の値で、コールバックが直ちに実行されます:

  ``` js
  vm.$watch('a', callback, {
    immediate: true
  })
  // その時の `a` の値でコールバックがただちに発火します
  ```

### vm.$get( expression )

- **引数:**
  - `{String} expression`

- **利用方法:**

  式を与えられた Vue インスタンスから値を取得します。エラーが発生する式は抑制され、`undefined` を返します。

- **例:**

  ``` js
  var vm = new Vue({
    data: {
      a: {
        b: 1
      }
    }
  })
  vm.$get('a.b') // -> 1
  vm.$get('a.b + 1') // -> 2
  ```

### vm.$set( keypath, value )

- **引数:**
  - `{String} keypath`
  - `{*} value`

- **利用方法:**

  Vue インスタンスの data の、該当する keypath に値をセットします。ほとんどのケースでプレーンオブジェクト文法（例 : `vm.a.b = 123`）を用いてプロパティを設定するほうがいいでしょう。このメソッドは二つのシナリオでのみ必要になります。

  1. キーパス文字列があって、キーパスを用いて動的に値を設定したい場合。

  2. 存在しないプロパティを設定したい場合。

  もしパスが存在しない場合、再帰的に生成されリアクティブになります。もし新しいルートレベルのリアクティブプロパティが `$set` コールによって生成された場合、Vue インスタンスは  すべての watcher が再評価される "digest cycle" を強制されます。

- **例:**

  ``` js
  var vm = new Vue({
    data: {
      a: {
        b: 1
      }
    }
  })
  
  // 存在するパスを設定
  vm.$set('a.b', 2)
  vm.a.b // -> 2

  // 存在しないパスを設定し、 digest を強制
  vm.$set('c', 3)
  vm.c // ->
  ```

- **参考:** [Reactivity in Depth](/guide/reactivity.html)

### vm.$delete( key )

- **引数:**
  - `{String} key`

- **利用方法:**

  Vue インスタンス（それと、その `$data`）のルートレベルのプロパティを削除します。 digest cycle を強制します。非推奨です。

### vm.$eval( expression )

- **引数:**
  - `{String} expression`

- **利用方法:**

  現在のインスタンス上の有効なバインディング式を評価します。式はフィルタを含むことができます。

- **例:**

  ``` js
  // vm.msg = 'hello' とみなす
  vm.$eval('msg | uppercase') // -> 'HELLO'
  ```

### vm.$interpolate( templateString )

- **引数:**
  - `{String} templateString`

- **利用方法:**

  mustache 挿入をもつテンプレートの文字列のかたまりを評価します。このメソッドは、単に文字列を挿入するだけであるということに気をつけてください。つまり、属性を持ったディレクティブはコンパイルされません。

- **例:**

  ``` js
  // vm.msg = 'hello' とみなす
  vm.$interpolate('{{msg}} world!') // -> 'hello world!'
  ```

### vm.$log( [keypath] )

- **引数:**
  - `{String} [keypath]`

- **利用方法:**

  現在のインスタンスを getter や setter よりもコンソールで検査しやすいプレーンオブジェクトとして記録します。オプションのキーも受けつけます。

  ``` js
  vm.$log() // ViewModel のすべてのデータのログをとる
  vm.$log('item') // vm.item のログをとる
  ```

## Instance Methods / Events

### vm.$on( event, callback )

- **引数:**
  - `{String} event`
  - `{Function} callback`

- **利用方法:**

  現在の vm 上のイベントを監視します。イベントは `vm.$emit`、`vm.$dispatch` または `vm.$broadcast` からトリガすることができます。それらのイベントトリガを行うメソッドに渡した追加の引数は、コールバックがすべて受け取ります。

- **例:**

  ``` js
  vm.$on('test', function (msg) {
    console.log(msg)
  })
  vm.$emit('test', 'hi')
  // -> "hi"
  ```

### vm.$once( event, callback )

- **引数:**
  - `{String} event`
  - `{Function} callback`

- **利用方法:**

  一度きりのイベントリスナを提供します。リスナは最初にトリガされた時に削除されます。

### vm.$off( [event, callback] )

- **引数:**
  - `{String} [event]`
  - `{Function} [callback]`

- **利用方法:**

  一つまたは複数のイベントリスナを削除します。

  - もし引数が与えられなければ、すべてのイベントリスナを削除します。

  - もしイベントがひとつだけ与えられたら、そのイベントに関するすべてのイベントリスナを削除します。

  - もしイベントとコールバックの両方が与えられたら、その特定のコールバックに対するイベントリスナのみを削除します。

### vm.$emit( event, [...args] )

- **引数:**
  - `{String} event`
  - `[...args]`

  現在のインスタンス上のイベントをトリガします。追加の引数はリスナのコールバックファンクションに渡されます。

### vm.$dispatch( event, [...args] )

- **引数:**
  - `{String} event`
  - `[...args]`

- **利用方法:**

  イベントをディスパッチします。まずそれ自身のインスタンス上のイベントをトリガし、それから parent chain の上方向にイベントを伝えます。イベント伝播は親イベントリスナが `true` を返さない限り、親のイベントリスナのトリガ時に停止します。追加の引数はリスナのコールバックファンクションに渡されます。

- **例:**

  ``` js
  // parent chain を作成
  var parent = new Vue()
  var child1 = new Vue({ parent: parent })
  var child2 = new Vue({ parent: child1 })

  parent.$on('test', function () {
    console.log('parent notified')
  })
  child1.$on('test', function () {
    console.log('child1 notified')
  })
  child2.$on('test', function () {
    console.log('child2 notified')
  })

  child2.$dispatch('test')
  // -> "child2 notified"
  // -> "child1 notified"
  // child1 のコールバックが true を返していないため、親には通知されません。
  ```

- **参考:** [Parent-Child Communication](/guide/components.html#Parent-Child_Communication)

### vm.$broadcast( event, [...args] )

- **引数:**
  - `{String} event`
  - `[...args]`

- **利用方法:**

  ブロードキャストは現在のインスタンスの子孫すべてにイベントを下方向に伝播させます。子孫が複数のサブツリーに展開されるため、イベント伝播はたくさんの異なる "パス" を辿ります。各パスのイベント伝播は、リスナのコールバックが `true` を返さない限り、イベントリスナがパス沿いに発火した時に停止します。

- **例:**

  ``` js
  var parent = new Vue()
  // child1 と child2 は兄弟です
  var child1 = new Vue({ parent: parent })
  var child2 = new Vue({ parent: parent })
  // child3 は child2 下にネストされています
  var child3 = new Vue({ parent: child2 })

  child1.$on('test', function () {
    console.log('child1 notified')
  })
  child2.$on('test', function () {
    console.log('child2 notified')
  })
  child3.$on('test', function () {
    console.log('child3 notified')
  })

  parent.$broadcast('test')
  // -> "child1 notified"
  // -> "child2 notified"
  // child2 のコールバックが true を返していないため、child3 には通知されません。
  ```

## Instance Methods / DOM

### vm.$appendTo( elementOrSelector, [callback] )

- **引数:**
  - `{Element|String} elementOrSelector`
  - `{Function} [callback]`

- **戻り値:** `vm` - インスタンス自身

- **利用方法:**

  Vue インスタンスの DOM 要素またはフラグメントを対象要素に追加します。対象には、要素またはクエリセレクタ文字列が指定できます。このメソッドは表示されている場合にトランジションをトリガします。トランジションが終了した後に（またはトランジションがトリガされなかった時は即座に）コールバックが発火します。

### vm.$before( elementOrSelector, [callback] )

- **引数:**
  - `{Element|String} elementOrSelector`
  - `{Function} [callback]`

- **戻り値:** `vm` - インスタンス自身

- **利用方法:**

  Vue インスタンスの DOM 要素またはフラグメントを対象要素に挿入します。対象には、要素またはクエリセレクタ文字列が指定できます。このメソッドは表示されている場合にトランジションをトリガします。トランジションが終了した後に（またはトランジションがトリガされなかった時は即座に）コールバックが発火します。

### vm.$after( elementOrSelector, [callback] )

- **引数:**
  - `{Element|String} elementOrSelector`
  - `{Function} [callback]`

- **戻り値:** `vm` - インスタンス自身

- **利用方法:**

  Vue インスタンスの DOM 要素またはフラグメントを対象要素の後に挿入します。対象には、要素またはクエリセレクタ文字列が指定できます。このメソッドは表示されている場合にトランジションをトリガします。トランジションが終了した後に（またはトランジションがトリガされなかった時は即座に）コールバックが発火します。

### vm.$remove( [callback] )

- **引数:**
  - `{Function} [callback]`

- **戻り値:** `vm` - インスタンス自身

- **利用方法:**
  
  Vue インスタンスの DOM 要素またはフラグメントを DOM から削除します。このメソッドは表示されている場合にトランジションをトリガします。トランジションが終了した後に（またはトランジションがトリガされなかった時は即座に）コールバックが発火します。

### vm.$nextTick( callback )

- **引数:**
  - `{Function} [callback]`

- **利用方法:**

  callback を延期し、DOM の更新サイクル後に実行します。DOM の更新を待ち受けるためにいくつかのデータを更新した直後に使用してください。callback の `this` コンテキストは自動的にこのメソッドを呼び出すインスタンスにバインドされることを除いて、グローバルな `Vue.nextTick` と同じです。

- **例:**

  ``` js
  new Vue({
    // ...
    methods: {
      // ...
      example: function () {
        // データを編集
        this.message = 'changed'
        // DOM はまだ更新されない
        this.$nextTick(function () {
          // DOM が更新された
          // `this` は現在のインスタンスにバインドされる
          this.doSomethingElse()
        })
      }
    }
  })
  ```

- **参考:**
  - [Vue.nextTick](#Vue-nextTick)
  - [Async Update Queue](/guide/reactivity.html#Async_Update_Queue)

## Instance Methods / Lifecycle

### vm.$mount( [elementOrSelector] )

- **引数:**
  - `{Element|String} [elementOrSelector]`

- **戻り値:** `vm` - インスタンス自身

- **利用方法:**

  もしインスタンス化の際に、Vue インスタンスが `el` オプションを受け取らなかった場合、DOM 要素またはフラグメントと関連のない "unmounted" 状態となります。`vm.$mount()` を使うことで、このような Vue インスタンスのコンパイルフェーズをマニュアルで開始することができます。

  もし引数が何も与えられなかったら、テンプレートはドキュメント外のフラグメントとして作成されます。そしてあなた自身によってそれをドキュメントに挿入するために他の DOM インスタンスメソッドを使用しなければなりません。もし、`replace` オプションが `false` に設定される場合は、wrapper 要素として空の `<div>` が自動的に作られます。

  既にマウントされた状態のインスタンスで `$mount()` を呼んでも、何も起きません。このメソッドはインスタンスそのものを返しますので、他のインスタンスメソッドをその後につなげることができます。

- **例:**

  ``` js
  var MyComponent = Vue.extend({
    template: '<div>Hello!</div>'
  })
  
  // 生成して #app にマウント (#app で置換されます)
  new MyComponent().$mount('#app')

  // 上記はこれと同じ:
  new MyComponent({ el: '#app' })

  // または、ドキュメントと分離状態でコンパイルして、あとで追加する:
  new MyComponent().$mount().$appendTo('#container')
  ```

- **参考:** [Lifecycle Diagram](/guide/instance.html#Lifecycle_Diagram)

### vm.$destroy( [remove] )

- **引数:**
  - `{Boolean} [remove] - default: false`

- **利用方法:**

  vm を完全に破棄します。既存の他の vm との接続を切り、そのすべてのディレクティブとのバインドを解消し、すべてのイベントリスナを開放し、また `remove` 引数が true の場合、vm と関連した DOM 要素または DOM からのフラグメントを削除します。

  `beforeDestroy` 及び `destroyed` をトリガします。

- **参考:** [Lifecycle Diagram](/guide/instance.html#Lifecycle_Diagram)

## Directives

### v-text

- **要求事項:** `String`

- **詳細:**

  ある要素の`textContent`を更新します。

  内部的には、 `{% raw %}{{ Mustache }}{% endraw %}` 挿入も textNode 上の `v-text` ディレクティブとしてコンパイルされます。このディレクティブ形式はラッパー要素が必要ですが、パフォーマンスが若干改善し、FOUC (まだコンパイルされていないコンテンツのちらつき)を回避します。

- **例:**

  ``` html
  <span v-text="msg"></span>
  <!-- 以下と同じ -->
  <span>{{msg}}</span>
  ```

### v-html

- **要求事項:** `String`

- **詳細:**

  ある要素の `innerHTML` を更新します。コンテンツはプレーン HTML として挿入され、データバインディングは無視されます。もしテンプレート片を再利用する必要があるならば、[partials](#partial) を使って下さい。

  内部的には、`{% raw %}{{{ Mustache }}}{% endraw %}` 展開はアンカーノードを利用して `v-html` ディレクティブとしてもコンパイルされます。ディレクティブ形式はラッパー要素を必要としますが、パフォーマンスが若干改善し、FOUC (まだコンパイルされていないコンテンツのちらつき)を回避します。

  <p class="tip">任意の HTML をあなたの Web サイト上で動的にレンダリングすることは、 [XSS 攻撃](https://en.wikipedia.org/wiki/Cross-site_scripting)を招くため大変危険です。`v-html` は信頼済みコンテンツのみに利用し、 **絶対に** ユーザの提供するコンテンツには使わないで下さい。</p>

- **例:**

  ``` html
  <div v-html="html"></div>
  <!-- 以下と同じ -->
  <div>{{html}}</div>
  ```

### v-if

- **要求事項:** `*`

- **利用方法:**

  バインディングの値の真偽値に基いて要素のレンダリングを行います。要素及び、データバインディングまたはコンポーネントを含むコンテンツは、トグルしている間に破壊され再構築されます。もし要素が `<template>` 要素であれば、その内容は状態ブロックとして抽出されます。

- **参考:** [Conditional Rendering](/guide/conditional.html)

### v-show

- **要求事項:** `*`

- **利用方法:**

  エクスプレッション値の真偽に応じて、要素の CSS プロパティ `display` をトグルします。表示時にトランジションをトリガします。

- **参考:** [Conditional Rendering](/guide/conditional.html#v-show)

### v-else

- **式を受け付けません**

- **制約:** 直前の兄弟要素は `v-if` または `v-show` を持つ必要があります。

- **利用方法:**

  `v-if` と `v-show` に対応する "else block" であることを示します。

  ``` html
  <div v-if="Math.random() > 0.5">
    Sorry
  </div>
  <div v-else>
    Not sorry
  </div>
  ```

- **参考:** [Conditional Rendering](/guide/conditional.html#v-show)

### v-for

- **要求事項:** `Array | Object | Number | String`

- **パラメータ属性:**
  - [`track-by`](/guide/list.html#track-by)
  - [`stagger`](/guide/transitions.html#Staggering_Transitions)
  - [`enter-stagger`](/guide/transitions.html#Staggering_Transitions)
  - [`leave-stagger`](/guide/transitions.html#Staggering_Transitions)

- **利用方法:**

  ソースデータに基づき、要素またはテンプレートブロックを複数回レンダリングします。式には、繰り返される要素へのエイリアスを提供する為に、特別な文法を使う必要があります:

  ``` html
  <div v-for="item in items">
    {{ item.text }}
  </div>
  ```

  あるいは、インデックス(またはオブジェクトで使用されている場合、キー)に対してエイリアスを指定することもできます:

  ``` html
  <div v-for="(index, item) in items"></div>
  <div v-for="(key, val) in object"></div>
  ```

  `v-for` の詳細な利用方法は下記にリンクしたガイドセクション内で説明しています。

- **参考:** [List Rendering](/guide/list.html).

### v-on

- **省略記法:** `@`

- **要求事項:** `Function | Inline Statement`

- **引数:** `event (必須)`

- **修飾子:**
  - `.stop` - `event.stopPropagation()` を呼び出します。
  - `.prevent` - `event.preventDefault()` を呼び出します。
  - `.{keyCode | keyAlias}` - 指定したキーが押された時のみトリガされるハンドラです。

- **利用方法:**

  要素にイベントリスナをアタッチします。イベント種別は引数で示されます。式はメソッド名またはインラインステートメントのいずれかを指定することができ、または修飾子 (modifire) が存在するときは、単純に省略されます。

  通常の要素上で利用した場合、**ネイティブ DOM イベント** を監視します。カスタム要素コンポーネント上で利用した場合、子コンポーネント上での **カスタムイベント** の発行も監視します。

- **例:**

  ``` html
  <!-- メソッドハンドラ -->
  <button v-on:click="doThis"></button>

  <!-- インラインステートメント -->
  <button v-on:click="doThat('hello')"></button>

  <!-- 省略記法 -->
  <button @click="doThis"></button>

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
  ```

  子コンポーネント上のカスタムイベントを監視する (ハンドラは "my-event" が子コンポーネント上で発行された時に呼ばれる):

  ``` html
  <my-component @my-event="handleThis"></my-component>
  ```

- **参考:** [Methods and Event Handling](/guide/events.html)

### v-bind

- **省略記法:** `:`

- **要求事項:** `*`

- **引数:** `attrOrProp (必須)`

- **修飾子:**
  - `.sync` - バインディングを双方向にします。prop バインディングにのみ有効なので注意してください。
  - `.once` - バインディングを一度きり実行されるようにします。prop バインディングにのみ有効なので注意してください。

- **利用方法:**

  属性またはコンポーネント prop と式を動的にバインドします。

  `class` または `style` 属性とバインドする場合、配列やオブジェクトのような追加の値タイプをサポートします。詳細は下記にリンクしたガイドセクションを参照してください。

  prop バインディングに使う場合、prop は子コンポーネント内で適切に宣言される必要があります。prop バインディングには修飾子の一つを用いることで異なるバインディングタイプを指定することができます。

- **例:**

  ``` html
  <!-- 属性をバインド -->
  <img v-bind:src="imageSrc">

  <!-- 省略記法 -->
  <img :src="imageSrc">

  <!-- クラスバインディング -->
  <div :class="{ red: isRed }"></div>
  <div :class="[classA, classB]"></div>

  <!-- スタイルバインディング -->
  <div :style="{ fontSize: size + 'px' }"></div>
  <div :style="[styleObjectA, styleObjectB]"></div>

  <!-- prop バインディング。"prop" は my-component 内で宣言される必要があります。 -->
  <my-component :prop="someThing"></my-component>

  <!-- 双方向 prop バインディング -->
  <my-component :prop.sync="someThing"></my-component>

  <!-- 一度きりの prop バインディング -->
  <my-component :prop.once="someThing"></my-component>
  ```

- **参考:**
  - [Class and Style Bindings](/guide/class-and-style.html)
  - [Component Props](/guide/components.html#Props)
  
### v-model

- **要求事項:** input type に応じて変化します。

- **適用対象制限:**
  - `<input>`
  - `<select>`
  - `<textarea>`

- **パラメータ属性:**
  - [`lazy`](/guide/forms.html#lazy)
  - [`number`](/guide/forms.html#number)
  - [`debounce`](/guide/forms.html#debounce)

- **利用方法:**

  form input 要素上に双方向バインディングを作成します。詳細は下にリンクしたガイドセクションを参照してください。

- **参考:** [Form Input Bindings](/guide/forms.html)

### v-ref

- **式を受け付けません**

- **適用対象制限:** 子コンポーネント

- **引数:** `id (必須)`

- **利用方法:**

  直接アクセスの為に親から子コンポーネントへの参照を登録します。式を受け付けません。登録する id として引数が必要です。コンポーネントインスタンスは親の `$refs` オブジェクトから参照可能になります。

  `v-for` と共に使用するとき、値はそれにバインドしている配列に対応するすべての子コンポーネントインスタンスを含む配列になります。もし `v-for` のデータソースがオブジェクトの場合、登録された値はソースオブジェクトとミラーリングされた各キーとインスタンスを含むオブジェクトになります。

- **例:**

  ``` html
  <comp v-ref:child></comp>
  ```

  ``` js
  // 親からアクセス:
  this.$refs.child
  ```

  `v-for`と共に利用:

  ``` html
  <comp v-ref:list v-for="item in list"></comp>
  ```

  ``` js
  // これは親の中の配列になる
  this.$refs.list
  ```

- **参考:** [Child Component Refs](/guide/components.html#Child_Component_Refs)

### v-el

- **式を受け付けません**

- **引数:** `id (必須)`

- **利用方法:**
  
  簡単にアクセス可能にするために、所有者の Vue インスタンスの `$els` オブジェクト上に DOM 要素へのリファレンスを登録します。

- **例:**

  ``` html
  <span v-el:msg>hello</span>
  ```
  ``` js
  this.$els.msg.textContent // -> "hello"
  ```

### v-pre

- **式を受け付けません**

- **利用方法:**

  この要素とすべての子要素のコンパイルをスキップします。生の mustache タグを表示するためにも使うことができます。ディレクティブのない大量のノードをスキップすることで、コンパイルのスピードを上げます。

- **例:**

  ``` html
  <span v-pre>{{ this will not be compiled }}</span>
  ```

### v-cloak

- **式を受け付けません**

- **利用方法:**

  このディレクティブは関連付けられた Vue インスタンスのコンパイルが終了するまでの間残存します。`[v-cloak] { display: none }` のような CSS のルールと組み合わせて、このディレクティブは Vue インスタンス が用意されるまでの間、コンパイルされていない Mustache バインディングを隠すのに使うことができます。

- **例:**

  ``` css
  [v-cloak] {
    display: none;
  }
  ```

  ``` html
  <div v-cloak>
    {{ message }}
  </div>
  ```

  `<div>` はコンパイルが終了するまでは不可視となります。

## Special Elements

### component

- **属性:**
  - `is`

- **利用方法:**

  コンポーネントを起動するための代替シンタックスです。主に、動的コンポーネント向けに `is` 属性で使用されます:

  ``` html
  <!-- 動的コンポーネントは vm で `componentId` プロパティによってコントロールされます -->
  <component :is="componentId"></component>
  ```

- **参考:** [Dynamic Components](/guide/components.html#Dynamic_Components)

### slot

- **属性:**
  - `name`

- **利用方法:**

  `<slot>` 要素はコンポーネントテンプレートでコンテンツ挿入アウトレットとして役に立ちます。slot 要素はそれ自身が置き換えられます。

  `name` 属性を指定したスロットは名前付きスロットと呼ばれます。名前付きスロットは名前と一致した `slot` 属性と共にコンテンツを配信します。

  詳細な利用方法は、下記にリンクしたガイドセクションを参照してください。

- **参考:** [Content Distribution with Slots](/guide/components.html#Content_Distribution_with_Slots)

### partial

- **属性:**
  - `name`

- **利用方法:**

  `<partial>` 要素は登録された template partial 向けのアウトレットとして役に立ちます。partial なコンテンツが挿入された時、Vue によってコンパイルされます。`<partial>` 要素はそれ自身が置き換えられます。partial のコンテンツを解決するために `name` 属性が必要です。

- **例:**

  ``` js
  // partial の登録
  Vue.partial('my-partial', '<p>This is a partial! {{msg}}</p>')
  ```

  ``` html
  <!-- 静的な partial -->
  <partial name="my-partial"></partial>

  <!-- 動的な partial -->
  <!-- id === vm.partialId で partial をレンダリング -->
  <partial v-bind:name="partialId"></partial>

  <!-- v-bind 省略記法を使った動的 partial -->
  <partial :name="partialId"></partial>
  ```

## Filters

### capitalize

- **例:**

  ``` html
  {{ msg | capitalize }}
  ```

  *'abc' => 'Abc'*

### uppercase

- **例:**

  ``` html
  {{ msg | uppercase }}
  ```

  *'abc' => 'ABC'*

### lowercase

- **例:**

  ``` html
  {{ msg | lowercase }}
  ```

  *'ABC' => 'abc'*

### currency

- **引数:**
  - `{String} [symbol] - default: '$'`

- **例:**

  ``` html
  {{ amount | currency }}
  ```

  *12345 => $12,345.00*

  違う記号を使います:

  ``` html
  {{ amount | currency '£' }}
  ```

  *12345 => £12,345.00*

### pluralize

- **引数:**
  - `{String} single, [double, triple, ...]`

- **利用方法:**

  フィルタされた値に基づいた引数を複数形にします。ちょうど1つの引数が指定されているとき、単純にその引数の終わりに "s" を追加します。よりもっと多くの引数が指定されているとき、それらの引数は single、double、triple というような、複数形化される言葉の形式に対応する文字列の配列として利用されます。複数形化される数が引数の長さを上回るとき、それは配列の最後のエントリを利用します。

- **例:**

  ``` html
  {{count}} {{count | pluralize 'item'}}
  ```

  *1 => '1 item'*  
  *2 => '2 items'*

  ``` html
  {{date}}{{date | pluralize 'st' 'nd' 'rd' 'th'}}
  ```

  結果は以下の通り:

  *1 => '1st'*  
  *2 => '2nd'*
  *3 => '3rd'*
  *4 => '4th'*
  *5 => '5th'*

### json

- **引数:**
  - `{Number} [indent] - default: 2`

- **利用方法:**
  
  文字列表現(いわゆる `[object Object]`)を出力するというより、むしろ入ってくる値を JSON.stringify() を実行するフィルタです。

- **例:**

  ４スペースインデントでオブジェクトを出力します:

  ``` html
  <pre>{{ nestedObject | json 4 }}</pre>
  ```

### debounce

- **適用対象制限:** `Function` 値を要求するディレクティブ。例えば `v-on` 。

- **引数:**
  - `{Number} [wait] - default: 300`

- **利用方法:**

  X が引数であるとすると、X ミリ秒の間デバウンスするために、指定されたハンドラを Wrap します。デフォルトでは 300ms です。デバウンスされたハンドラは、少なくとも呼び出された瞬間から X ミリ秒経過するまで遅延されます。遅延期間が終わる前に再びハンドラが呼ばれた場合、遅延期間は X ミリ秒にリセットされます。

- **例:**

  ``` html
  <input @keyup="onKeyup | debounce 500">
  ```

### filterBy

- **適用対象制限:** `Array` 値を要求するディレクティブ。例えば `v-for`。

- **引数:**
  - `{String | Function} targetStringOrFunction`
  - `"in" (optional delimiter)`
  - `{String} [...searchKeys]`

- **利用方法:**

  元の配列のフィルタされたバージョンを返します。最初の引数は文字列またはファンクションです。

  最初の引数が文字列の場合、配列内の各要素に対しての検索対象文字列となります:

  ``` html
  <div v-for="item in items | filterBy 'hello'">
  ```

  上の例の中では、対象文字列 `"hello"` を含む items のみが表示されます。

  もし item がオブジェクトなら、フィルタはそのオブジェクトのネストしたプロパティをすべて再帰的に対象文字列で検索します。検索スコープを狭めるためには、追加の検索キーを指定することができます:

  ``` html
  <div v-for="user in users | filterBy 'Jack' in 'name'">
  ```

  上の例の中では、フィルタは各 user オブジェクトの `name` フィールドから `"Jack"` のみを検索します。**パフォーマンス向上のために、常に検索スコープを制限するのはいいアイデアです。**

  以上の例は静的な引数を使っていますが、もちろん、動的な引数を対象文字列もしくは検索キーとして使うこともできます。`v-model` と組み合わせると入力中のフィルタリングも簡単に実装することができます。

  ``` html
  <div id="filter-by-example">
    <input v-model="name">
    <ul>
      <li v-for="user in users | filterBy name in 'name'">
        {{ user.name }}
      </li>
    </ul>
  </div>
  ```

  ``` js
  new Vue({
    el: '#filter-by-example',
    data: {
      name: '',
      users: [
        { name: 'Bruce' },
        { name: 'Chuck' },
        { name: 'Jackie' }
      ]
    }
  })
  ```

  {% raw %}
  <div id="filter-by-example" class="demo">
    <input v-model="name">
    <ul>
      <li v-for="user in users | filterBy name in 'name'">
        {{ user.name }}
      </li>
    </ul>
  </div>
  <script>
  new Vue({
    el: '#filter-by-example',
    data: {
      name: '',
      users: [{ name: 'Bruce' }, { name: 'Chuck' }, { name: 'Jackie' }]
    }
  })
  </script>
  {% endraw %}

- **追加サンプル:**

  複数の検索キー:

  ``` html
  <li v-for="user in users | filterBy searchText in 'name' 'phone'"></li>
  ```

  動的な配列引数による複数の検索キー:

  ``` html
  <!-- fields = ['fieldA', 'fieldB'] -->
  <div v-for="user in users | filterBy searchText in fields">
  ```

  カスタムフィルタファンクションの利用:

  ``` html
  <div v-for="user in users | filterBy myCustomFilterFunction">
  ```

### orderBy

- **適用対象制限:** `Array` 値を要求するディレクティブ。例えば `v-for`。

- **引数:**
  - `{String} sortKey`
  - `{String} [order] - default: 1`

- **利用方法:**

  入力された配列のソートされたバージョンを返します。`sortKey` 引数はソートに利用されるキーです。オプションの `order` 引数は、結果を昇順 (`order >= 0`) または降順 (`order < 0`) のどちらで返すかを指定します。

  プリミティブ値の配列では、`sortKey` には truthy (真偽値に変換すると true になる値のこと) な値なら何でも指定できます。


- **例:**

  ユーザを名前でソート:

  ``` html
  <ul>
    <li v-for="user in users | orderBy 'name'">
      {{ user.name }}
    </li>
  </ul>
  ```

  降順ではこのようにします:

  ``` html
  <ul>
    <li v-for="user in users | orderBy 'name' -1">
      {{ user.name }}
    </li>
  </ul>
  ```

  プリミティブ値のソート:

  ``` html
  <ul>
    <li v-for="n in numbers | orderBy true">
      {{ n }}
    </li>
  </ul>
  ```

  動的ソート順:

  ``` html
  <div id="orderby-example">
    <button @click="order = order * -1">ソート順の反転</button>
    <ul>
      <li v-for="user in users | orderBy 'name' order">
        {{ user.name }}
      </li>
    </ul>
  </div>
  ```

  ``` js
  new Vue({
    el: '#orderby-example',
    data: {
      order: 1,
      users: [{ name: 'Bruce' }, { name: 'Chuck' }, { name: 'Jackie' }]
    }
  })
  ```

  {% raw %}
  <div id="orderby-example" class="demo">
    <button @click="order = order * -1">ソート順の反転</button>
    <ul>
      <li v-for="user in users | orderBy 'name' order">
        {{ user.name }}
      </li>
    </ul>
  </div>
  <script>
  new Vue({
    el: '#orderby-example',
    data: {
      order: 1,
      users: [{ name: 'Bruce' }, { name: 'Chuck' }, { name: 'Jackie' }]
    }
  })
  </script>
  {% endraw %}
  
