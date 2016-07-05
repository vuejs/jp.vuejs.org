---
title: コンポーネント
type: guide
order: 12
---

## コンポーネントとは何か？
コンポーネントは Vue.js の最も強力な機能の1つです。基本的な HTML 要素を拡張して再利用可能なコードのカプセル化を助けます。高度なレベルでは、コンポーネントは Vue.js のコンパイラが指定された振舞いをアタッチするカスタム要素です。場合によっては、特別な `is` 属性で拡張されたネイティブな HTML 要素の姿をとることもあります。

## コンポーネントの使用

### 登録

以前のセクションで `Vue.extend()` を使用してコンポーネントコンストラクタを作成できることを学習しました:

``` js
var MyComponent = Vue.extend({
  // オプション...
})
```

このコンストラクタをコンポーネントとして使用するためには、 `Vue.component(tag, constructor)` で**登録する**必要があります:

``` js
// グローバルに my-component タグでコンポーネントを登録する
Vue.component('my-component', MyComponent)
```

<p class="tip">カスタムタグの名前について [W3C ルール](http://www.w3.org/TR/custom-elements/#concepts) (全て小文字で、ハイフンが含まれている必要がある)にしたがうことは良い取り組みと考えられますが、Vue.js はそれを強制しないことを覚えておいてください。</p>

一度登録すると、コンポーネントはカスタム要素 `<my-component>` として親のインスタンスのテンプレートで使用できます。コンポーネントは root の Vue インスタンスをインスタンス化する**前**に登録しているか確認してください。ここに完全な例を示します:

``` html
<div id="example">
  <my-component></my-component>
</div>
```

``` js
// 定義する
var MyComponent = Vue.extend({
  template: '<div>A custom component!</div>'
})

// 登録する
Vue.component('my-component', MyComponent)

// root インスタンスを作成する
new Vue({
  el: '#example'
})
```

レンダリングされる内容は以下になります:

``` html
<div id="example">
  <div>A custom component!</div>
</div>
```

{% raw %}
<div id="example" class="demo">
  <my-component></my-component>
</div>
<script>
Vue.component('my-component', {
  template: '<div>A custom component!</div>'
})
new Vue({ el: '#example' })
</script>
{% endraw %}

カスタム要素は**マウントポイント**として機能するだけで、コンポーネントのテンプレートはそれに**取って代わる**ことに注意してください。この振舞いは、`replace` インスタンスオプションを使用することで設定できます。

### ローカル登録

グローバルに全てのコンポーネントを登録する必要はありません。別のコンポーネントのインスタンスオプションの `components` に登録することで、そのコンポーネントのスコープ内でのみ利用可能なコンポーネントを作成できます:

``` js
var Child = Vue.extend({ /* ... */ })

var Parent = Vue.extend({
  template: '...',
  components: {
    // <my-component> は親のテンプレートでのみ有効になります
    'my-component': Child
  }
})
```

同じカプセル化は、ディレクティブ、フィルタ、そしてトランジションのようなアセットタイプに対して適用されます。

### 簡単な登録

物事を簡単にするため、実際のコンストラクタの代わりに `Vue.component()` と `component` オプションにオプションオブジェクトで直接渡すことができます。Vue.js は内部で自動的に `Vue.extend()` を呼びます:

``` js
// 1 ステップで extend と登録します
Vue.component('my-component', {
  template: '<div>A custom component!</div>'
})

// ローカル登録に対しても動作します
var Parent = Vue.extend({
  components: {
    'my-component': {
      template: '<div>A custom component!</div>'
    }
  }
})
```

### コンポーネントオプションの注意事項

Vue コンストラクタに渡すことができるほとんどのオプションは、 `Vue.extend()` で使用できます。しかし `data` と `el` の2つの特別なケースは異なります。純粋に `Vue.extend()` へ `data` としてオブジェクトを渡すことを考えてみてください:

``` js
var data = { a: 1 }
var MyComponent = Vue.extend({
  data: data
})
```

これに伴う問題は、同じ `data` オブジェクトは `MyComponent` の全てのインスタンス間で共有されるということです！これは望むところではまずないでしょうから、`data` オプションとして、新たなオブジェクトを返す関数を使用しましょう:

``` js
var MyComponent = Vue.extend({
  data: function () {
    return { a: 1 }
  }
})
```

全く同じ理由で、`el` オプションも `Vue.extend()` で使用した場合、関数の値が必要です。

### テンプレートの構文解析

Vue.js のテンプレートエンジンは DOM ベースで、独自のものではなくブラウザに付属するネイティブの構文解析を使用します。文字列ベースのテンプレートと比べたときこのアプローチは利点がありますが、注意事項もあります。テンプレートは各自妥当な HTML の集まりでなければなりません。 HTML 要素の中には、その内部にどの要素が表示できるかの制限を持つものがあります。これらの制限の代表的なものは:

- `a` は他のインタラクティブな要素に含むことができません (例、ボタンや他のリンク)
- `li` は `ul` また `ol` の直接的な子であるべきで、そして `ul` と `ol` はどちらも `li` だけを含めることができます
- `option` は `select` の直接的な子であるべきで、そして `select` は `option` (そして `optgroup`) だけを含めることができます
- `table` は `thead` 、`tbody` 、`tfoot` そして `tr` だけを含めることができ、さらにこれらの要素は `table` の直接的な子であるべきです
- `tr` は `th` そして `td` だけを含めることができ、そしてこれらの要素は `tr` の直接的な子であるべきです

実行時にこれらの制限が予期せぬ動作を引き起こす可能性があります。単純なケースでは動作するように見えるかもしれませんが、カスタム要素がブラウザによる検証前に展開されることを当てにしてはいけません。例えば、`<my-select><option>...</option></my-select>` は、最終的には `<select>...</select>` に展開されるとしても、妥当なテンプレートではありません。

また、`ul`、`select`、`table` そして他の同様の制限を持つ要素の内部でカスタムタグ(カスタム要素と `<component>`、`<template>` や `<partial>` のような特別なタグを含む)を使用することはできません。カスタム要素は外に押し出され、正しく表示されないでしょう。

カスタム要素の代わりに、特別な属性 `is` を使いましょう:

``` html
<table>
  <tr is="my-component"></tr>
</table>
```

`<table>` 内で `<template>` を使う代わりに、`<tbody>` を使いましょう。テーブルは複数の `tbody` を持つことを許されていますから:

``` html
<table>
  <tbody v-for="item in items">
    <tr>Even row</tr>
    <tr>Odd row</tr>
  </tbody>
</table>
```

## Props

### Props によるデータ伝達

全てのコンポーネントインスタンスは、各自の**隔離されたスコープ (isolated scope)** を持ちます。つまり、子コンポーネントのテンプレートで親データを直接参照できない(そしてすべきでない)ということです。データは **props** を使用して子コンポーネントに伝達できます。

"prop" は、コンポーネントデータ上のフィールドであり、そのコンポーネントデータは親コンポーネントから伝えられることを想定しています。子コンポーネントは、[`props` オプション](/api/#props)を利用して、伝達を想定する props を明示的に宣言する必要があります:

``` js
Vue.component('child', {
  // props を宣言します
  props: ['msg'],
  // prop は内部テンプレートで利用でき、
  // そして `this.msg` として設定されます
  template: '<span>{{ msg }}</span>'
})
```

すると以下のようにプレーン文字列を渡すことができます:

``` html
<child msg="hello!"></child>
```

**結果:**

{% raw %}
<div id="prop-example-1" class="demo">
  <child msg="hello!"></child>
</div>
<script>
new Vue({
  el: '#prop-example-1',
  components: {
    child: {
      props: ['msg'],
      template: '<span>{{ msg }}</span>'
    }
  }
})
</script>
{% endraw %}

### キャメルケース 対 ケバブケース

HTML の属性は大文字と小文字を区別しません。キャメルケースされた prop 名を属性として使用するとき、それらをケバブケース(kebab-case: ハイフンで句切られた)にして使用する必要があります:

``` js
Vue.component('child', {
  // JavaScript ではキャメルケース
  props: ['myMessage'],
  template: '<span>{{ myMessage }}</span>'
})
```

``` html
<!-- HTML ではケバブケース -->
<child my-message="hello!"></child>
```

### 動的な Props

式に通常の属性をバインディングするのと同様に、 `v-bind` を使用して親のデータに props を動的にバインディングすることもできます。親でデータが更新される度に、そのデータが子に流れ落ちます:

``` html
<div>
  <input v-model="parentMsg">
  <br>
  <child v-bind:my-message="parentMsg"></child>
</div>
```

`v-bind` のための省略記法を使用するとよりシンプルです:

``` html
<child :my-message="parentMsg"></child>
```

**結果:**

{% raw %}
<div id="demo-2" class="demo">
  <input v-model="parentMsg">
  <br>
  <child v-bind:my-message="parentMsg"></child>
</div>
<script>
new Vue({
  el: '#demo-2',
  data: {
    parentMsg: 'Message from parent'
  },
  components: {
    child: {
      props: ['myMessage'],
      template: '<span>{{myMessage}}</span>'
    }
  }
})
</script>
{% endraw %}

### リテラル 対 動的

初心者にありがちな誤りは、リテラル構文を使用して数を渡そうとすることです:

``` html
<!-- これは純粋な文字列"1"を渡します -->
<comp some-prop="1"></comp>
```

しかしながら、これはリテラルな prop であるため、その値は実際に数の代わりに純粋な文字列 `"1"` が渡されています。実際に JavaScript の数を渡したい場合は、その値が JavaScript 式として評価されるよう、動的な構文で使用する必要があります:

``` html
<!-- これは実際の数を渡します -->
<comp :some-prop="1"></comp>
```

### Prop バインディングタイプ

デフォルトで、全ての props は子プロパティと親プロパティとの間で **one way down** バインディングを形成します:親プロパティが更新するとそれは子へと流れ落ちますが、その逆はありません。このデフォルトは、子コンポーネントが誤って親の状態を変更しないようにするためであり、さもないとアプリケーションのデータフローが推理しづらくなってしまいます。しかしながら、`.sync` そして `.once` **バインディングタイプ修飾子 (binding type modifier)** による two-way または one-time バインディングを明示的に強いることも可能です:

構文の比較:

``` html
<!-- デフォルトは one-way-down バインディング -->
<child :msg="parentMsg"></child>

<!-- 明示的な two-way バインディング -->
<child :msg.sync="parentMsg"></child>

<!-- 明示的な one-time バインディング -->
<child :msg.once="parentMsg"></child>
```

two-way バインディングは子の `msg` プロパティの変更を親の `parentMsg` プロパティに返して同期します。one-time バインディングは、一度セットアップしたら、その先の変更を親子間で同期しません。

<p class="tip">もし、渡される prop がオブジェクトまたは配列ならば、それは参照渡しであることに注意してください。子の内部でオブジェクトまたは配列そのものを変更することは、使用しているバインディングのタイプに関係なく、親の状態に影響を**与えます**。</p>

### Prop 検証

コンポーネントは受け取る props に対する必要条件を指定することができます。これらの検証要件は実質的にコンポーネントの API を構成し、ユーザーがコンポーネントを正しく使用していることを確実にするので、他の人に使用されることを意図したコンポーネントを作成するときに便利です。文字列の配列として props を定義する代わりに、検証要件を含んだオブジェクトハッシュフォーマットを使用できます:

``` js
Vue.component('example', {
  props: {
    // 基本な型チェック (`null` はどんな型でも受け付ける)
    propA: Number,
    // 複数の受け入れ可能な型 (1.0.21 以降)
    propM: [String, Number],
    // 必須な文字列
    propB: {
      type: String,
      required: true
    },
    // デフォルト値
    propC: {
      type: Number,
      default: 100
    },
    // オブジェクトと配列のデフォルトはファクトリ関数から返すようにします
    propD: {
      type: Object,
      default: function () {
        return { msg: 'hello' }
      }
    },
    // この prop は two-way バインディングを示します
    // バインディングの型がマッチしない場合は警告を投げます
    propE: {
      twoWay: true
    },
    // カスタムバリデータ関数
    propF: {
      validator: function (value) {
        return value > 10
      }
    },
    // 強制関数 (1.0.12 で新しく追加)
    // コンポーネント上で、値を設定する前にそれをキャストします
    propG: {
      coerce: function (val) {
        return val + '' // 値を文字列にキャスト
      }
    },
    propH: {
      coerce: function (val) {
        return JSON.parse(val) // 値をオブジェクトにキャスします
      }
    }
  }
})
```

`type` は次のネイティブなコンストラクタのいずれかになります:

- String
- Number
- Boolean
- Function
- Object
- Array

加えて、`type` はカスタムコンストラクタ関数とすることもでき、アサーションは `instanceof` チェックで作成できるでしょう。

prop 検証が失敗すると、Vue は子コンポーネントへの値のセットを拒否します。そしてもし開発ビルドを使用している場合は警告を出します。

## 親子間の通信

### 親チェーン

子コンポーネントは `this.$parent` として親コンポーネントへのアクセスを保持しています。root な Vue インスタンスは `this.$root` として子孫の全てにおいて利用できます。各親コンポーネントは全ての子コンポーネントを含んだ `this.$children` という配列を持っています。

親チェーンであらゆるインスタンスにアクセスできますが、子コンポーネント内で親データに直接依存するのは避け、props を明示的に使用してデータを渡すようにすべきです。さらに、子コンポーネントから親状態を変化させるのは非常にまずい考えです。なぜなら:

1. 親と子を密結合にしてしまいます。

2. 親単体を見てその状態を推理することをとても困難にします。なぜならその状態が全ての子によって変更される可能性があるからです！理想的には、コンポーネントそれ自身のみに、自身の状態の変更を許すべきです。

### カスタムイベント

全ての Vue インスタンスはコンポーネントツリー内の通信を容易にするカスタムイベントのインタフェースを実装します。このイベントシステムはネイティブの DOM イベントからは独立しており、動作が異なります。

各 Vue インスタンスは Event Emitter であり、以下が可能です:

- `$on()` を使用してイベントをリッスンします。

- `$emit()` を使用して自身にイベントをトリガーします。

- `$dispatch()` を使用して親のチェーンに沿って上方に伝ぱするイベントを送出します。

- `$broadcast()` を使用して全ての子孫に下方に伝ぱするイベントをばらまきます。

<p class="tip">DOM イベントとは異なり、Vue のイベントは、コールバックが明示的に `true` を返さない限り、伝ぱ経路に沿って初めてコールバックをトリガした後、自動的に伝搬を停止します。</p>

シンプルな例:

``` html
<!-- 子向けのテンプレート -->
<template id="child-template">
  <input v-model="msg">
  <button v-on:click="notify">Dispatch Event</button>
</template>

<!-- 親向けのテンプレート -->
<div id="events-example">
  <p>Messages: {{ messages | json }}</p>
  <child></child>
</div>
```

``` js
// 現在のメッセージでイベントを送出する子を登録します
Vue.component('child', {
  template: '#child-template',
  data: function () {
    return { msg: 'hello' }
  },
  methods: {
    notify: function () {
      if (this.msg.trim()) {
        this.$dispatch('child-msg', this.msg)
        this.msg = ''
      }
    }
  }
})

// イベントを受信するとき、配列にメッセージをプッシュする
// ブートストラップな親です
var parent = new Vue({
  el: '#events-example',
  data: {
    messages: []
  },
  // `events` オプションは、インスタンスが作成されるとき、
  // このオプションで指定されたコールバックをイベントリスナとして `$on` を呼んで登録します
  events: {
    'child-msg': function (msg) {
      // イベントのコールバックでの `this` は
      // それが登録されたとき、自動的にインスタンスに結びつけます
      this.messages.push(msg)
    }
  }
})
```

{% raw %}
<script type="x/template" id="child-template">
  <input v-model="msg">
  <button v-on:click="notify">Dispatch Event</button>
</script>

<div id="events-example" class="demo">
  <p>Messages: {{ messages | json }}</p>
  <child></child>
</div>
<script>
Vue.component('child', {
  template: '#child-template',
  data: function () {
    return { msg: 'hello' }
  },
  methods: {
    notify: function () {
      if (this.msg.trim()) {
        this.$dispatch('child-msg', this.msg)
        this.msg = ''
      }
    }
  }
})
var parent = new Vue({
  el: '#events-example',
  data: {
    messages: []
  },
  events: {
    'child-msg': function (msg) {
      this.messages.push(msg)
    }
  }
})
</script>
{% endraw %}

### カスタムイベントに対する v-on

上記の例はかなりいいですが、親コンポーネントのコードを見ている時、`"child-msg"` イベントがどこから来るのかあまりはっきりしません。テンプレートの、ちょうど子コンポーネントが使用されている場所でイベントハンドラを宣言することができれば、なおよいでしょう。これを可能にするために、`v-on` は子コンポーネントで使用されたとき、カスタムイベントをリッスンするために使用することができます:

``` html
<child v-on:child-msg="handleIt"></child>
```

これで非常に明確になります。子が `"child-msg"` イベントをトリガーすると、親の `handleIt` メソッドが呼び出されます。親の状態に影響を与えるあらゆるコードは親メソッドの `handleIt` 内だけに存在し、子コンポーネントはイベントのトリガーにかかわるのみです。

### 子コンポーネントの参照

props やイベントの存在にもかかわらず、時には子コンポーネントに JavaScript で直接アクセスする必要があるかもしれません。それを実現するためには `v-ref` を用いて子コンポーネントに対して参照 ID を割り当てる必要があります。例えば:

``` html
<div id="parent">
  <user-profile v-ref:profile></user-profile>
</div>
```

``` js
var parent = new Vue({ el: '#parent' })
// 子コンポーネントのインスタンスへのアクセス
var child = parent.$refs.profile
```

`v-ref` が `v-for` と共に使用された時は、得られる値はデータソースをミラーリングした子コンポーネントが格納されている配列またはオブジェクトになります。

## スロットによるコンテンツ配信

コンポーネントを使用するとき、それは、しばしばこのようにコンポーネントを構成することが望まれます:

``` html
<app>
  <app-header></app-header>
  <app-footer></app-footer>
</app>
```

ここに言及すべきことが2つあります:

1. `<app>` コンポーネントはどのコンテンツがそのマウント対象内部に存在しているか分かりません。`<app>` を使用している親コンポーネントが何であれ、親コンポーネントが内部コンテンツを決定します。

2. `<app>` コンポーネントはほぼ必ず独自のテンプレートを持っています。

コンポーネントの構造を動作させるためには、親の"コンテンツ"とそのコンポーネント自身のテンプレートを織り交ぜる方法が必要です。これは"コンテンツ配信"(または、Angular に精通している場合は "transclusion")と呼ばれるプロセスです。Vue.js はオリジナルコンテンツに対する配信アウトレットとして機能する特別な `<slot>` 要素を使用して、現行の [Web Components spec draft](https://github.com/w3c/webcomponents/blob/gh-pages/proposals/Slots-Proposal.md) にならったコンテンツ配信 API を実装します。

### コンパイルスコープ

API を掘り下げる前に、はじめにコンテンツがコンパイルされているスコープを明確にしましょう。このようなテンプレートを考えてみてください:

``` html
<child-component>
  {{ msg }}
</child-component>
```

`msg` は親のデータと子のデータのどちらにバインドされるべきでしょうか？答えは親です。コンポーネントスコープに対するシンプルな経験則は:

> 親テンプレート内の全てのものは親のスコープでコンパイルされ、子テンプレート内の全てものは子のスコープでコンパイルされる

よくある間違いは、親テンプレート内の子のプロパティ/メソッドにディレクティブをバインドしようとすることです:

``` html
<!-- 動作しません -->
<child-component v-show="someChildProperty"></child-component>
```

`someChildProperty` は子コンポーネントのプロパティであると仮定すると、上記例は意図したように動作しないでしょう。親のテンプレートは子コンポーネントの状態について認識しているべきではありません。

コンポーネントで子スコープのディレクティブにバインドする必要がある場合、子コンポーネント自身のテンプレートにおいてそうすべきです:

``` js
Vue.component('child-component', {
  // 正しいスコープであるため、これは動作します
  template: '<div v-show="someChildProperty">Child</div>',
  data: function () {
    return {
      someChildProperty: true
    }
  }
})
```

同様に、配信コンテンツは親スコープでコンパイルされます。

### 単一スロット

親コンテンツは子コンポーネントのテンプレートが少なくとも1つの `<slot>` アウトレットを含んでいない限り**破棄されます**。属性なしのスロットが1つだけあるときは、全コンテンツはスロットそのものを置き換え、DOM 内のその位置に挿入されます。

`<slot>` タグ内に元々あった全てのものは、**フォールバックコンテンツ**と見なされます。フォールバックコンテンツは子スコープでコンパイルされ、ホストしている要素が空で挿入されるコンテンツがない場合にのみ、表示されます。

以下のテンプレートによるコンテンツがあるとします:

``` html
<div>
  <h1>私のコンポーネント!</h1>
  <slot>
    ここは、コンテンツが配信されない時だけ表示されます
  </slot>
</div>
```

このコンポーネントを使用した親のマークアップは以下になります:

``` html
<my-component>
  <p>配信コンテンツその１</p>
  <p>配信コンテンツその２</p>
</my-component>
```

レンダリング結果は以下になります:

``` html
<div>
  <h1>私のコンポーネント!</h1>
  <p>配信コンテンツその１</p>
  <p>配信コンテンツその２</p>
</div>
```

### 名前付きスロット

`<slot>` 要素は特別な属性 `name` を持ち、コンテンツを配信する方法をカスタマイズするために使用できます。異なる名前で複数のスロットを持つことができます。名前付きスロットは、コンテンツ内の対応する `slot` 属性を持つ任意の要素にマッチします。

マッチしなかったコンテンツのためのキャッチオールアウトレットの機能を持つ**デフォルトスロット**として、名前無しのスロットを残すことができます。デフォルトスロットがない場合は、マッチしなかったコンテンツは破棄されます。

例として、以下のテンプレートのような、多数のコンポーネント挿入のテンプレートがあると仮定します:

``` html
<div>
  <slot name="one"></slot>
  <slot></slot>
  <slot name="two"></slot>
</div>
```

親のマークアップは以下です:

``` html
<multi-insertion>
  <p slot="one">One</p>
  <p slot="two">Two</p>
  <p>Default A</p>
</multi-insertion>
```

レンダリングされる結果は以下になります:

``` html
<div>
  <p slot="one">One</p>
  <p>Default A</p>
  <p slot="two">Two</p>
</div>
```

コンテンツ配信 API は、組み合わせて使うことを意図したコンポーネントを設計する際に、非常に便利なメカニズムです。

## 動的コンポーネント

予約された `<component>` 要素と、その `is` 属性に動的にバインドすることで、同じマウントポイントで複数のコンポーネントを動的に切り替えることができます:

``` js
new Vue({
  el: 'body',
  data: {
    currentView: 'home'
  },
  components: {
    home: { /* ... */ },
    posts: { /* ... */ },
    archive: { /* ... */ }
  }
})
```

``` html
<component :is="currentView">
  <!-- vm.currentview が変更されると、中身が変更されます! -->
</component>
```
### `keep-alive`

状態を保持したり再レンダリングを避けたりするために、もし切り替えで取り除かれたコンポーネントを生きた状態で保持したい場合は、ディレクティブのパラメータ `keep-alive` を追加することができます:

``` html
<component :is="currentView" keep-alive>
  <!-- 非活性になったコンポーネントをキャッシュします! -->
</component>
```

### `activate` フック

コンポーネントを切り替えるとき、後任のコンポーネントは、前もって何らかの非同期操作を実行する必要があるかもしれません。コンポーネントの交換のタイミングを制御するには、後任のコンポーネントで `activate` フックを実装します:

``` js
Vue.component('activate-example', {
  activate: function (done) {
    var self = this
    loadDataAsync(function (data) {
      self.someData = data
      done()
    })
  }
})
```

`activate` フックが有効なのは動的コンポーネントの切り替えの間、または静的コンポーネントの初回レンダリング時だけということに注意してください。インスタンスメソッドによる手動挿入には作用しません。

### `transition-mode`

`transition-mode` パラメータ属性は、2つの動的コンポーネント間でのトランジションがどう実行されるかを指定できます。

デフォルトでは、入ってくるコンポーネントと出て行くコンポーネントのトランジションが同時に起こります。この属性によって、もう2つのモードを設定することができます:

- `in-out`: 新しいコンポーネントのトランジションが初めに起こり、そのトランジションが完了した後に現在のコンポーネントの出て行くトランジションが開始します。

- `out-in`: 現在のコンポーネントが出て行くトランジションが初めに起こり、そのトランジションが完了した後に新しいコンポーネントのトランジションが開始します。

**例**

``` html
<!-- 先にフェードアウトし, その後フェードインします -->
<component
  :is="view"
  transition="fade"
  transition-mode="out-in">
</component>
```

``` css
.fade-transition {
  transition: opacity .3s ease;
}
.fade-enter, .fade-leave {
  opacity: 0;
}
```

{% raw %}
<div id="transition-mode-demo" class="demo">
  <input v-model="view" type="radio" value="v-a" id="a" name="view"><label for="a">A</label>
  <input v-model="view" type="radio" value="v-b" id="b" name="view"><label for="b">B</label>
  <component
    :is="view"
    transition="fade"
    transition-mode="out-in">
  </component>
</div>
<style>
  .fade-transition {
    transition: opacity .3s ease;
  }
  .fade-enter, .fade-leave {
    opacity: 0;
  }
</style>
<script>
new Vue({
  el: '#transition-mode-demo',
  data: {
    view: 'v-a'
  },
  components: {
    'v-a': {
      template: '<div>Component A</div>'
    },
    'v-b': {
      template: '<div>Component B</div>'
    }
  }
})
</script>
{% endraw %}

## その他

### コンポーネントと v-for

通常の要素のように、カスタムコンポーネントで `v-for` を直接使用することができます:

``` html
<my-component v-for="item in items"></my-component>
```

しかしながら、コンポーネントは各自隔離されたスコープを持っているので、これではコンポーネントにデータが渡りません。コンポーネントに反復されたデータを渡すために、props を使用する必要があります:

``` html
<my-component
  v-for="item in items"
  :item="item"
  :index="$index">
</my-component>
```

コンポーネントに `item` を自動的に注入しない理由は、それをするとコンポーネントが `v-for` の動作に密結合されるからです。データがどこから来たものかを明示することが、コンポーネントを他の状況で再利用可能なものにします。

### 再利用可能なコンポーネントの作成

コンポーネントを作成するとき、このコンポーネントをどこかで再利用するつもりかどうかを心に留めておくとよいでしょう。一度限りのコンポーネントが互いに密結合を持つことはよしとしても、再利用可能なコンポーネントはきれいな公開インタフェースを定義するべきです。

Vue.js コンポーネントのための API は、本質的に、props 、events 、slots の3つの部分からなります:

- **Props** 外部環境がコンポーネントにデータを供給することを可能にします。

- **Events** コンポーネントが外部環境のアクションをトリガーすることを可能にします。

- **Slots** 外部環境がコンポーネントの view 構造にコンテンツを挿入することを可能にします。

`v-bind` と `v-on` 用の省略記法を使うと、意図を明確かつ簡潔にテンプレート内で伝えることができます:

``` html
<my-component
  :foo="baz"
  :bar="qux"
  @event-a="doThis"
  @event-b="doThat">
  <!-- コンテンツ -->
  <img slot="icon" src="...">
  <p slot="main-text">Hello!</p>
</my-component>
```

### 非同期コンポーネント

大規模アプリケーションでは、アプリケーションを小さな塊に分割して、実際に必要になったときにサーバからコンポーネントをロードするだけにする必要があるかもしれません。それを簡単にするために、Vue.js ではコンポーネント定義を非同期的に解決するファクトリ関数としてコンポーネントを定義することができます。Vue.js はコンポーネントが実際に描画が必要になるとファクトリ関数のトリガだけ行い、将来の再描画のために結果をキャッシュします。例えば:

``` js
Vue.component('async-example', function (resolve, reject) {
  setTimeout(function () {
    resolve({
      template: '<div>I am async!</div>'
    })
  }, 1000)
})
```

ファクトリ関数は、サーバからコンポーネント定義を取得した後で呼ばれる `resolve` コールバックを引数に持ちます。ロードが失敗したことを示すために、`reject(reason)` を呼びだすこともできます。ここでの `setTimeout` は単にデモのためのものです。どうやってコンポーネントを取得するかは完全にあなた次第です。推奨されるアプローチの1つは [Webpack のコード分割機能](http://webpack.github.io/docs/code-splitting.html)で非同期コンポーネントを使うことです。

``` js
Vue.component('async-webpack-example', function (resolve) {
  // この特別な require 構文は webpack に対して、
  // ビルドコードを自動的に分割し、
  // ajaxリクエストで自動的にロードされるバンドルに
  // するよう指示します
  require(['./my-async-component'], resolve)
})
```

### アセットの命名規則

コンポーネントやディレクティブのようなあるアセットは、HTML 属性または HTML カスタムタグの形でテンプレートに表示されます。HTML 属性名とタグ名は**大文字と小文字を区別しない (case-insensitive)** ため、しばしばキャメルケースの代わりにケバブケースを使用してアセットに名前をつける必要がありますが、これは少し不便です。

Vue.js は実はキャメルケースまたはパスカルケース (PascalCase) を使用してのアセットの命名をサポートし、それらをテンプレート内ではケバブケースとして自動的に理解します (props の名前変換と似ています):

``` js
// コンポーネント定義します
components: {
  // キャメルケースを使用して登録します
  myComponent: { /*... */ }
}
```

``` html
<!-- テンプレートではダッシュケースを使用します -->
<my-component></my-component>
```

これは [ES6 オブジェクトリテラル省略記法](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Object_initializer#New_notations_in_ECMAScript_6) でうまく動作します:

``` js
// PascalCase
import TextBox from './components/text-box';
import DropdownMenu from './components/dropdown-menu';

export default {
  components: {
    // テンプレートでは <text-box> そして <dropdown-menu> として使用します
    TextBox,
    DropdownMenu
  }
}
```

### 再帰的なコンポーネント

コンポーネントはそのテンプレートで自分自身を再帰的に呼びだすことができます。ただし、それができるのは `name` オプションがあるときだけです:

``` js
var StackOverflow = Vue.extend({
  name: 'stack-overflow',
  template:
    '<div>' +
      // 再帰的に自身を呼び出します
      '<stack-overflow></stack-overflow>' +
    '</div>'
})
```

上記のようなコンポーネントは、"max stack size exceeded" エラーに終わるでしょうから、再帰呼び出しは条件付きであるようにしてください。`Vue.component()` を使用してグローバルなコンポーネントを登録するとき、そのグローバル ID が自動的にコンポーネントの `name` オプションとして設定されます。

### フラグメントインスタンス

`template` オプションを使用するとき、テンプレートのコンテンツは Vue インスタンスがマウントされている要素を置き換えます。それゆえ、テンプレート内に常に単一の ルートレベル要素を持つように推奨されます。

このようなテンプレートの代わりに:

``` html
<div>ルートノード１</div>
<div>ルートノード２</div>
```

こうするようにしてください:

``` html
<div>
  ルートノードは1つ！
  <div>ノード１</div>
  <div>ノード２</div>
</div>
```

Vue インスタンスを**フラグメントインスタンス**に変えるいくつかの状況があります:

1. 複数のトップレベル要素を含むテンプレート
2. プレーンなテキストだけを含むテンプレート
3. 他のコンポーネント(それ自体がフラグメントインスタンスかもしれない)だけを含むテンプレート
4. エレメントディレクティブだけ含むテンプレート、例えば `<partial>` や vue-router の `<router-view>`
5. ルートノードがフロー制御ディレクティブ、例えば `v-if` や `v-for` を持つテンプレート

上記全ては、インスタンスに未知数のトップレベル要素を持たせることになり、フラグメントとして DOM コンテンツを管理しなければならなくなります。フラグメントインスタンスはそれでも正常にコンテンツをレンダリングするでしょう。しかしながら、それは root なノードを持って**おらず**、その `$el` は空のテキストノード(またはデバッグモードではコメントノード)である"アンカーノード"を指すようになります。

しかしさらに重要なのは、**フロー制御しないディレクティブ、prop ではない属性、そしてコンポーネント要素でのトランジションは、無視される**ことで、というのもそれらをバインドする root な要素がないためです:

``` html
<!-- root 要素がないため動作しません -->
<example v-show="ok" transition="fade"></example>

<!-- props は動作します -->
<example :prop="someData"></example>

<!-- フロー制御は動作しますが、トランジションはなしです -->
<example v-if="ok"></example>
```

フラグメントインスタンスに対して有効なユースケースはもちろんありますが、一般的にはコンポーネントテンプレートに単一の root 要素を与えるのが、よい考え方です。それはコンポーネント要素のディレクティブや属性の正しい動作を確保し、わずかなパフォーマンスの向上にもつながります。

### インラインテンプレート

特別な属性 `inline-template` が子コンポーネントに存在するとき、配信コンテンツとして扱うよりむしろ、コンポーネントはそれをテンプレートとして内部コンテンツを使用します。これは、より柔軟なテンプレートを作成可能にします。

``` html
<my-component inline-template>
  <p>These are compiled as the component's own template</p>
  <p>Not parent's transclusion content.</p>
</my-component>
```

しかしながら、`inline-template` はテンプレートのスコープを推理するのが難しくなり、コンポーネントのテンプレートコンパイルがキャッシュできなくなります。ベストプラクティスとして、`template` オプションを使用して、コンポーネント内部でテンプレートを定義するようにしてください。
