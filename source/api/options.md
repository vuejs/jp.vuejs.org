title: コンポーネントオプション
type: api
order: 2
---

## データ

### data

- **型:** `Object | Function`
- **制約:** `Vue.extend()` の中で使用するときは、`Function` のみを受け入れます。

Vue インスタンスのためのデータオブジェクトです。`vm.$data` としてアクセスできます。

```js
var data = { a: 1 }
var vm = new Vue({
  data: data
})
vm.$data === data // -> true
```

Vue インスタンスはすべてのプロパティに代理アクセスします。したがって、Vue インスタンス上のプロパティを操作することが可能であり、その変更は実際のデータオブジェクトと同期されます:

```js
vm.a   // -> 1
vm.a = 2
data.a // -> 2
data.a = 3
vm.a   // -> 3
```

このオブジェクトは JSON の仕様に準拠する必要があります（循環参照はありません）。普通のオブジェクトと同じように使うことができ、`JSON.stringify` でシリアライズしたときと全く同じになります。複数の Vue インスタンス間で共有することも可能です。

`Vue.extend()` 内の `data` オプションを使うときは特別です。ネストされたオブジェクトが、すべての継承されたコンストラクタから作られたインスタンスによって共有されないようにするため、デフォルトのデータの最新のコピーを返す関数を提供する必要があります。

``` js
var MyComponent = Vue.extend({
  data: function () {
    return {
      message: 'some default data.',
      object: {
        fresh: true
      }
    }
  }
})
```

<p class="tip">内部実装的には、Vue.js は隠しプロパティ `__ob__` を備えており、依存関係の修正を可能にするために、オブジェクトの数えられるプロパティを getter と setter に再帰的に変換します。`$` や `_` で始まるキーをもつプロパティは、スキップされます。</p>

### props

- **型:** `Array`

引数の名前の配列が、Vue インスタンス上で初期値として設定されます。データをコンポーネントに渡すときに便利です。

**例:**

``` js
Vue.component('param-demo', {
  props: ['size', 'message'],
  compiled: function () {
    console.log(this.size)    // -> 100
    console.log(this.message) // -> 'hello!'
  }
})
```

``` html
<param-demo size="100" message="hello!"></param-demo>
```

データのコンポーネントへの渡し方の詳細については以下を参照してください:

- [Props のバインディングタイプ](/guide/components.html#Props_のバインディングタイプ)
- [Props としてのコールバックの伝達](/guide/components.html#Props_としてのコールバックの伝達)

文字列として定義している props の代わりに、検証要件を含んだオブジェクトを使用できます:

``` js
Vue.component('prop-validation-demo', {
  props: [
    {
      name: 'size',
      type: Number
    },
    {
      name: 'message',
      type: String,
      required: true
    }
  ]
})
```

prop 検証の詳細については [Prop 検証](/guide/components.html#Prop_検証) を参照してください。

#### ハイフンでつながれた引数についての注意

HTML の引数名は、小文字や大文字の違いを無視するので、通常はキャメルケースの代わりにハイフンでつながれた引数を使用します。ハイフンを含んだ属性をもつ `props` を使用する特殊な場合もあります:

1. もし引数が data 引数出会った場合、`data-` 接頭辞は自動的に削除されます。

2. もし引数が依然ダッシュ (-) を含んでいた場合、キャメルケースに変換されます。これは、テンプレートの中にダッシュを含む最上位のプロパティにアクセスするときに不便だからです。`my-param` という表記は、不恰好に `this['my-param']` という書き方をしない限りマイナスの表記としてパースされてしまいます。

これは、パラメータの引数 `data-hello` はvm上で `vm.hello` と設定され、`my-param` は `vm.myParam` と設定されることを意味します。

### methods

- **型:** `Object`

Vue インスタンスに組み込まれるメソッドです。VM インスタンスでは、これらのメソッドに直接アクセスでき、ディレクティブ表現で使用することもできます。すべてのメソッドは、Vue インスタンスに自動的にバウンドされた `this` コンテキストをもちます。

**例:**

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

### computed

- **型:** `Object`

Vue インスタンスに組み込まれる Computed properties です。すべての getter や setter は、自動的に Vue インスタンスにバウンドされた `this` コンテキストをもちます。

**例:**

```js
var vm = new Vue({
  data: { a: 1 },
  computed: {
    // get のみ、関数が一つ必要なだけ
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

## DOM

### el

- **型:** `String | HTMLElement | Function`
- **制約:** `Vue.extend()` の中で使用する場合は、`Function` タイプのみを受け付けます。

既存の DOM 要素に Vue インスタンスを与えます。CSS セレクタの文字列、実際の HTML 要素、または、HTML 要素を返す関数をとることができます。解決された要素は、`vm.$el` としてアクセス可能になります。

`Vue.extend` の中で使用されているとき、それぞれのインスタンスが独立に要素を作るような関数が与えられる必要があります。

もしインスタンス化の際にオプションが有効であれば、そのインスタンスはただちにコンパイルの段階に入ります。さもなければ、ユーザーがコンパイルを始めるために手作業で明示的に `vm.$mount()` を呼ぶ必要があります。

### template

- **型:** `String`

`vm.$el` に Vue インスタンスに対してマークアップとして使用するための、文字列のテンプレートです。デフォルトで、テンプレートはマウントされた要素として**置換**されます。`replace` オプションが `false` に設定されるときは、反対にマウントされた要素に挿入されます。両方の場合において、[単独なコンテンツ挿入位置](/guide/components.html#コンテンツ挿入) がテンプレートの中になければ、マウントされた要素内部のあらゆる既存のマークアップは無視されます。もし **relace** オプションが `true` であれば、テンプレートは `vm.$el` を完全に書き換えます。

もし `#` による文字列で始まる場合、querySelector として使用され、選択された要素の innerHTML とテンプレート文字列を使用します。これにより、テンプレートを組み込むための共通の `<script type="x-template">` というやり方を使うことができるようになります。

<p class="tip">Vue.js は DOM ベースのテンプレートです。コンパイラは DOM 要素を処理して、ディレクティブを探し、データバインディングを作成します。これは、すべての Vue.js テンプレートはブラウザによって実際の DOM に変換可能な、パース可能な HTML であることを意味しています。Vue.js はテンプレートの文字列を DOM の断片に変換され、追加で Vue インスタンスを作成するときにクローンされます。もしテンプレートを正しい HTML にしたければ、`data-` から始めるようにディレクティブの接頭辞を設定することができます。</p>

### replace

- **型:** `Boolean`
- **初期値:** `true`
- **制約:** **template** オプションが存在する場合にのみ重視されます。

マウントされている要素を template で置き換えるかどうかを意味します。もし `false` を設定する場合は、template はコンテンツ内部の要素を要素自身で置き換えずに上書きします。

**例**:

``` html
<div id="replace"></div>
```

``` js
new Vue({
  el: '#replace',
  template: '<p>replaced</p>'
})
```

結果:

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

結果:

``` html
<div id="insert">
  <p>inserted</p>
</div>
```

## ライフサイクル

すべてのライフサイクルのフックは、それらが所属する Vue インスタンスにバインドされた `this` のコンテキストを持ちます。Vue インスタンスは `"hook:<hookName>"` の形式のそれぞれのフックに対応するイベントを発火します。例えば、`created` では、 `"hook:created"` イベントが発火されます。

### created

- **型:** `Function`

インスタンスが作成された後に、同期的に呼ばれます。この段階では、インスタンスは次の設定されたオプションの処理を終了しています: data の監視、computed properties、methods、watch / event コールバック
しかしながら、DOM のコンパイルは開始されておらず、`$el` プロパティはまだ有効ではありません。

### beforeCompile

- **型:** `Function`

コンパイルが開始される寸前に呼ばれます。

### compiled

- **型:** `Function`

コンパイルが終了した後に呼ばれます。この段階では、すべてのディレクティブはリンクされているため、データの変更は DOM の更新のトリガになります。しかし、'$el' がドキュメントに挿入されていることは保証されません。

### ready

- **型:** `Function`

コンパイルが終了した後に呼ばれます。**そして**、`$el` が**ドキュメントの中に初めて挿入されます** (すなわち、最初の `attached` フックの直後)。この挿入は `ready` フックのトリガになるように（`vm.$appendTo()` のようなメソッドやディレクティブの更新の結果をもった） Vue 経由で実行されなくてはならないことに注意してください。

### attached

- **型:** `Function`

`vm.$el` がディレクティブもしくは VM インスタンスもしくは`$appendTo()` のような VM インスタンスのメソッドによって DOM に追加されたときに呼ばれます。`vm.$el` の直接の操作はこのフックのトリガに**なりません**。

### detached

- **型:** `Function`

ディレクティブか VM インスタンスのメソッドによって DOM から `vm.$el` が削除されたときに呼ばれます。ディレクティブの `vm.$el` の操作はこのフックのトリガに**なりません**。

### beforeDestroy

- **型:** `Function`

Vue インスタンスが破棄される寸前に呼ばれます。この段階では、インスタンスはまだ完全に使用可能ではありません。

### destroyed

- **型:** `Function`

Vue インスタンスが破棄された後に呼ばれます。このフックが呼ばれたとき、Vue インスタンスのすべてのバインディングとディレクティブはバインドを解かれ、すべての子 Vue インスタンスも破棄されます。

もし残された切り替えがあった場合、`destroyed` フックは切り替えが終了した**後に**呼ばれます。

## アセット

コンパイル中の Vue インスタンスとその子インスタンスでのみで有効なプライベートなアセットがあります。

### directives

- **型:** `Object`

Vue インスタンスで使用できるような、ディレクティブのハッシュです。カスタムディレクティブの書き方について、より詳しくは[カスタムディレクティブ](/guide/custom-directive.html)を参照してください。

### elementDirectives

- **型:** `Object`

Vue インスタンス使用できるような、エレメントディレクティブのハッシュです。エレメントディレクティブの書き方は、[エレメントディレクティブ](/guide/custom-directive.html#エレメントディレクティブ)を参照してください。

### filters

- **型:** `Object`

Vue インスタンスで使用できるようなフィルタのハッシュです。カスタムフィルタの書き方は、[カスタムフィルタ](/guide/custom-filter.html)を参照してください。

### components

- **型:** `Object`

Vue インスタンスで使用できるようなコンポーネントのハッシュです。Vue インスタンスの継承や構成の仕方の詳細は、[コンポーネントシステム](/guide/components.html)を参照してください。

### transitions

- **型:** `Object`

Vue インスタンスで使用できるようなトランジションのハッシュです。詳しくは、[トランジション](/guide/transitions.html)にあるガイドを参照してください。

## その他

### inherit

- **型:** `Boolean`
- **初期値:** `false`

親のスコープのデータを継承するか否かを表します。もし親のスコープを継承したコンポーネントを作りたい場合は、`true` に設定してください。`inherit` が `true` に設定されたときは、以下のことができます:

1. コンポーネント内で親のスコープのプロパティにバインドする。
2. 原型的なインターフェイスを介して、コンポーネントのインスタンスそのものの親のプロパティに直接アクセスする。

`inherit: true` を使用する際に知っておくべき重要なことは、すべての Vue インスタンスのデータプロパティは、getterやsetterであるため、**子も親のプロパティを設定できる**ことです。

**例:**

``` js
var parent = new Vue({
  data: { a: 1 }
})
var child = parent.$addChild({
  inherit: true,
  data: { b: 2 }
})
child.a  // -> 1
child.b  // -> 2
// 子に新しいプロパティを作成する代わりに、
// 次の行で parent.a を修正する:
child.a = 2
parent.a // -> 2
```

### events

キーが監視するべきイベントで、値が対応するコールバックのオブジェクトです。DOM のイベントというよりはむしろVue のイベントです。値はメソッド名の文字列をとることもできます。Vue インスタンスはインスタンス化の際にオブジェクトの各エントリに対して `$on()` を呼びます。

**例:**

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

### watch

- **タイプ**: `Object`

キーが監視する評価式で、値が対応するコールバックをもつオブジェクトです。値はメソッド名の文字列をとることもできます。Vue インスタンスはインスタンス化の際にオブジェクトの各エントリに対して `$watch()` を呼びます。

**例:**

``` js
var vm = new Vue({
  data: {
    a: 1
  },
  watch: {
    'a': function (val, oldVal) {
      console.log('new: %s, old: %s', val, oldVal)
    }
  }
})
vm.a = 2 // -> new: 2, old: 1
```

### mixins

- **タイプ**: `Array`

`mixins` オプションは、ミックスインオブジェクトの配列を受け入れます。ミックスインオブジェクトは、通常のインスタンスオブジェクトのようなインスタンスオプションを含むことができ、`Vue.extend()` における同じオプションを併合するロジックを使った結果のオプションに対して併合されます。例えば、もしあなたのミックスインが作成されたフックをもち、コンポーネントそのものもそれを持っていた場合、両方の関数が呼ばれます。

**例:**

``` js
var mixin = {
  created: function () { console.log(2) }
}
var vm = new Vue({
  created: function () { console.log(1) },
  mixins: [mixin]
})
// -> 1
// -> 2
```

### name

- **タイプ**: `String`
- **制約:** `Vue.extend()` の中で使用されるときのみ重視されます。

コンソール上で拡張された Vue コンポーネントを調べる際、コンストラクタの名前の初期値は情報価値を持たない、`VueComponent` です。追加の `name` オプションを `Vue.extend()` に渡すことで、どちらのコンポーネントをあなたが見ているのかを知ることができるようなよりわかりやすい出力を得ることができます。この文字列はキャメルケース (camel case) になり、コンポーネントのコンストラクタの名前として使用されます。

**例:**

``` js
var Ctor = Vue.extend({
  name: 'cool-stuff'
})
var vm = new Ctor()
console.log(vm) // -> CoolStuff {$el: null, ...}
```
