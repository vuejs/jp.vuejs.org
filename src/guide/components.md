---
title: コンポーネント
type: guide
order: 12
---

## コンポーネントとは何ですか？
コンポーネントは Vue.js の最も強力な機能の1つです。それらは、基本的な HTML 要素を再利用可能なコードをカプセル化するために拡張するのを助けます。高度なレベルでは、コンポーネントは Vue.js のコンパイラが指定された振舞いをアタッチするカスタム要素です。いくつかのケースでは、それらは特別な `is` 属性で拡張されたネイティブな HTML 要素として表示されることもあります。

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

<p class="tip">Vue.js はカスタムタグ(全て小文字、ハイフンが含まれている必要ある)に対して [W3C ルール](http://www.w3.org/TR/custom-elements/#concepts) にしたがってもよいですが、この規則を強制する必要はないことに注意してください。</p>

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

コンポーネントのテンプレートは、**マウントポイント** として機能するだけのカスタム要素を**置き換える**ことに注意してください。この振舞いは、`replace` インスタンスオプションを使用することで設定できます。

### ローカル登録

グローバルに全てのコンポーネントを登録する必要はありません。インスタンスオプションの `components` でコンポーネントを登録することで、他のコンポーネントのスコープ内でのみコンポーネントを利用できます:

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

同じカプセル化は、ディレクティブ、フィルタ、そしてトランジションのようなアセットのタイプに対して適用されます。

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

これに伴う問題は、同じ `data` オブジェクトは `MyComponent` の全てのインスタンス間で共有されるということです！これは最も望んでいないものの可能性があるので、`data` オプションとして新たなオブジェクトを返す関数を使用すべきです:

``` js
var MyComponent = Vue.extend({
  data: function () {
    return { a: 1 }
  }
})
```

全く同じ理由で、`el` オプションも `Vue.extend()` で使用した場合、関数の値が必要です。

### テンプレートの構文解析

Vue.js のテンプレートエンジンは DOM ベースでカスタムなものを提供する代わりにブラウザに付属するネイティブの構文解析を使用します。文字列ベースのテンプレートと比べたときこのアプローチは利点がありますが、注意事項もあります。テンプレートは HTML の個々の妥当な部品でなければなりません。 HTML 要素の中には、どの要素がそれら内部に表示できるものと表示できないものの制限があるものがあります。これらの制限の多くの共通的なものは:

- `a` は他のインタラクティブな要素に含むことができません (例、ボタンと他のリンク)
- `li` は `ul` また `ol` の直接的な子であるべきで、そして `ul` と `ol` 両方は `li` だけを含めることができます
- `option` は `select` の直接的な子であるべきで、そして `select` は `option` (そして `optgroup`) だけを含めることができます
- `table` は `thead` だけを含めることができ、`tbody` 、`tfoot` そして `tr`、さらにこれらの要素は `table` の直接子を含めることができます
- `tr` は `th` そして `td` だけを含めることができ、そしてこれらの要素は直接 `tr` の子を含めることができます

実際問題では、これらの制限は、予期しない動作を引き起こす可能性があります。簡単な例では、それが動作するように見えるかもしれませんが、カスタム要素に依存することはできませんが、ブラウザの検証前に展開されています。例えば、`<my-select><option>...</option></my-select>` は、最終的には `<select>...</select>` のために展開しても、妥当なテンプレートではありません。

同様の制限で、`ul`、`select`、`table` そして他の要素の内部でカスタムタグ(カスタム要素と `<component>`、`<template>` そして `<partial>` のような特別なタグを含む)を使用することができないです。カスタム要素押し上げられて、それがゆえに正しく表示されません。

``` html
<table>
  <tr is="my-component"></tr>
</table>
```

In case of a `<template>` inside of a `<table>` you should use `<tbody>`, as tables are allowed to have multiple `tbody`:

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

全てのコンポーネントインスタンスは、自身で**隔離されたスコープ (isolated scope)** を持ちます。つまり、子コンポーネントのテンプレートで親データを直接参照できない(そしてすべきでない)ということです。データは **props** を使用して子コンポーネントに伝達できます。

"prop" は、コンポーネントデータ上のフィールドであり、そのコンポーネントデータは親コンポーネントから伝えられることを想定しています。子コンポーネントは、[`props` オプション](/api/#props)を利用して受信することを期待するために、明示的に宣言する必要があります:

``` js
Vue.component('child', {
  // props を宣言します
  props: ['msg'],
  // prop は内部テンプレートで利用でき、
  // そして `this.msg` として設定されます
  template: '<span>{{ msg }}</span>'
})
```

そのとき、以下のようにプレーン文字列を渡すことができます:

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

HTML の属性は大文字と小文字を区別しません。キャメルケースされた prop 名を属性として使用するとき、それらをケバブケース(kebab-case: ハイフンで句切られた)として使用する必要があります:

``` js
Vue.component('child', {
  // JavaScript でのキャメルケース
  props: ['myMessage'],
  template: '<span>{{ myMessage }}</span>'
})
```

``` html
<!-- HTML でのケバブケース -->
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

これは `v-bind` では、省略記法構文を使用した方がしばしば簡単です:

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

初心者がよく間違えることは、リテラル構文を使用して数を渡そうとすることです:

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

デフォルトで、全ての props は子プロパティと親プロパティとの間で **one way down** バインディングです。親プロパティが更新するとき子と同期されますが、その逆はありません。このデフォルトは、子コンポーネントが誤って親の状態を変更しないようにするためであり、さもないとアプリケーションのデータフローが推理しづらくなってしまいます。しかしながら、明示的に two-way または `.sync` そして `.once` **バインディングタイプ修飾子 (binding type modifier)** による one-time バインディングを強いることも可能です:

構文の比較:

``` html
<!-- デフォルトは one-way-down バインディング -->
<child :msg="parentMsg"></child>

<!-- 明示的な two-way バインディング -->
<child :msg.sync="parentMsg"></child>

<!-- 明示的な one-time バインディング -->
<child :msg.once="parentMsg"></child>
```

two-way バインディングは子の `msg` プロパティの変更を親の `parentMsg` プロパティに戻して同期します。one-time バインディングは、一度セットアップし、親と子との間では、先の変更は同期しません。

<p class="tip">もし、渡される prop がオブジェクトまたは配列ならば、それは参照で渡されることに注意してください。オブジェクトの変更または配列は、使用しているバインディングのタイプに関係なく、子の内部それ自身は、親の状態に影響を**与えます**。</p>

### Prop 検証

コンポーネントは受け取る props に対する必要条件を指定することができます。これは他の人に使用されるための目的とされたコンポーネントを編集するときに便利で、これらの prop 検証要件は本質的にはコンポーネントの API を構成するものとして、ユーザーがコンポーネントを正しく使用しているということを保証します。文字列の配列として props を定義する代わりに、検証要件を含んだオブジェクトハッシュフォーマットを使用できます:

``` js
Vue.component('example', {
  props: {
    // 基本な型チェック (`null` はどんな型でも受け付ける)
    propA: Number,
    // 複数の可能な型 (1.0.21 以降)
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
    // オブジェクト/配列のデフォルトはファクトリ関数から返されるべきです
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

加えて、`type` はカスタムコンストラクタ、そして assertion は `instanceof` チェック もできます。

prop 検証が失敗するとき、Vue は値を子コンポーネントへのセットを拒否します。そしてもし開発ビルドを使用している場合は警告を出します。

## 親子間の通信

### 親のチェーン

子コンポーネントは `this.$parent` として親コンポーネントへのアクセスを保持しています。root な Vue インスタンスは `this.$root` として子孫の全てにおいて利用できます。各親コンポーネントは全ての子コンポーネントを含んだ `this.$children` という配列を持っています。

親のチェーンで任意のインスタンスにアクセスは可能ですが、子コンポーネントに親データに直接依存するのは避け、むしろ props を明示的に使用して親からデータを渡すことを選択すべきです。さらに、子コンポーネントから親状態を変化させるのは非常に悪いアイディアです。なぜなら:

1. 親と子は密結合になります。

2. 親の状態を単独で見るときに推論することをとても困難にします。なぜならその状態が全ての子によって変更される可能性があるからです！理想的には、コンポーネントそれ自体だけは、自身の状態を変更できるべきです。

### カスタムイベント

全ての Vue インスタンスはコンポーネントツリー内の通信を容易にカスタムイベントのインタフェースを実装します。このイベントシステムはネイティブの DOM イベントからは独立しており、動作が異なります。

各 Vue インスタンスは Event Emitter としてイベントを発することができます:

- `$on()` を使用してイベントをリッスンします。

- `$emit()` を使用して自身にイベントをトリガーします。

- `$dispatch()` を使用して親のチェーンに沿って上方に伝ぱするイベントを送出します。

- `$broadcast()` を使用して全ての子孫に下方に伝ぱするイベントをばらまきます。

<p class="tip">DOM イベントとは異なり、Vue のイベントは、コールバックが明示的に `true` を返さない限り、伝ぱパスに沿って初めてコールバックをトリガした後、自動的に伝搬を停止します。</p>

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

上記の例はかなりいいですが、親コンポーネントのコードを見ている時、`"child-msg"` イベントがどこから来るのかはそれほど明確ではありません。テンプレートでイベントハンドラが宣言することができれば、正しく子コンポーネントが使用されるとよいでしょう。これを可能にするために、`v-on` は子コンポーネントで使用されたとき、カスタムイベントをリッスンするために使用することができます:

``` html
<child v-on:child-msg="handleIt"></child>
```

これは非常に物事が明確になります。その子が`"child-msg"` イベントをトリガーするとき、親の `handleIt` メソッドは呼び出されます。親の状態に影響を与える任意のコードは親メソッドの `handleIt` 内だけに存在し、子コンポーネントはイベントのトリガーにかかわるのみです。

### 子コンポーネントの参照

props やイベントの存在にもかかわらず、時どき JavaScript でネストした子コンポーネントへのアクセスが必要になる場合があります。それを実現するためには `v-ref` を用いて子コンポーネントに対して参照 ID を割り当てる必要があります。例えば:

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

`v-ref` が `v-for` と共に使用された時は、得られる値はそのデータの配列またはオブジェクトをミラーリングした子コンポーネントが格納されているデータソースになります。

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

2. `<app>` コンポーネントは非常に可能性がある独自のテンプレートを持っています。

コンポーネントの構造を動作させるためには、親の"コンテンツ"とそのコンポーネント自身のテンプレートを織り交ぜる方法が必要です。これは"コンテンツ配信"(または、Angular に精通している場合は "transclusion")と呼ばれるプロセスです。Vue.js は現在 [Web Components spec draft](https://github.com/w3c/webcomponents/blob/gh-pages/proposals/Slots-Proposal.md) の後を追ってモデル化された、オリジナルコンテンツに対する配信アウトレットとして機能する特別な `<slot>` 要素を使用して、コンテンツ配信 API を実装します。

### コンパイルスコープ

API を掘り下げる前に、はじめにコンテンツがコンパイルされているスコープを明確にしましょう。このようなテンプレートを考えてみてください:

``` html
<child>
  {{ msg }}
</child>
```

`msg` は親のデータまたは子のデータでバインドされるべきですか？答えは親です。コンポーネントスコープ対する親指の簡単なルールは単純です:

> 親テンプレート内の全てのものは親のスコープでコンパイルされます。子テンプレート内の全てものは子のスコープでコンパイルされます。

よくある間違いは、親テンプレート内の子のプロパティ/メソッドにディレクティブをバインドしようとすることです:

``` html
<!-- 動作しません -->
<child v-show="someChildProperty"></child>
```

`someChildProperty` は子コンポーネントのプロパティであると仮定すると、上記例は意図したように動作しないでしょう。親のテンプレートは子コンポーネントの状態の認識すべきではありません。

コンポーネントで子スコープのディレクティブにバインドする必要がある場合、子コンポーネント自身のテンプレートにおいてそうすべきではありません:

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

同様に、配信されたコンテンツは親スコープでコンパイルされます。

### 単一スロット

親コンテンツは子コンポーネントのテンプレートが少なくとも1つの `<slot>` アウトレットを含んでいない限り**破棄されます**。属性なしで1つのスロットだけあるときは、コンテンツ全体のフラグメントは、スロット自身置き換え、DOM にその位置に挿入されます。

`<slot>` タグ内での全ての元は、**フォールバックコンテンツ**と見なされます。フォールバックコンテツは子スコープでコンパイルされ、ホストしている要素が空で挿入されるコンテンツがない場合にのみ、表示されます。

以下のテンプレートによるコンテンツがあるとします:

``` html
<div>
  <h1>This is my component!</h1>
  <slot>
    This will only be displayed if there is no content
    to be distributed.
  </slot>
</div>
```

このコンポーネントを使用した親のマークアップは以下になります:

``` html
<my-component>
  <p>This is some original content</p>
  <p>This is some more original content</p>
</my-component>
```

レンダリング結果は以下になります:

``` html
<div>
  <h1>This is my component!</h1>
  <p>This is some original content</p>
  <p>This is some more original content</p>
</div>
```

### 名前付きスロット

`<slot>` 要素は、コンテンツを配信する方法をカスタマイズするために使用することができる特別な属性、`name` を持ちます。異なる名前で複数のスロットを持つことができます。名前付きスロットはコンテンツフラグメントに対応する `slot` 属性を持つ任意の要素にマッチします。

任意のマッチしないコンテンツに対して全てを捕らえるアウトレットとして機能する**デフォルトスロット**である名前解決できないスロットを、まだ1つ存在させることができます。デフォルトスロットがない場合は、マッチしないコンテンツとして破棄されます。

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

コンテンツ配信 API は、一緒に構成されることを意図されているコンポーネントを設計する際に、非常に便利なメカニズムです。

## 動的コンポーネント

同じマウントポイント、そして予約された `<component>` 要素と動的にバインドする `is` 属性を使って複数のコンポーネントを動的に切り替えることができます:

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

状態を保持したりや再レンダリングを避けたりするために、もし切り替えられたコンポーネントを活性化された状態で保持したい場合は、ディレクティブのパラメータ `keep-alive` を追加することができます:

``` html
<component :is="currentView" keep-alive>
  <!-- 非活性になったコンポーネントをキャッシュします! -->
</component>
```

### `activate` フック

コンポーネントを切り替えるとき、次に切り替わるコンポーネントは、交換される前に、いくつかの非同期操作を実行する必要があります。コンポーネントの交換のタイミングを制御するために、`activate` フックは次の切り替わるコンポーネントで実装します:

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

`activate` フックは動的コンポーネントの交換の間、または静的コンポーネントへの初期レンダリングだけ考慮されていることに注意してください。それは、インスタンスメソッドによる手動挿入には影響は与えません。

### `transition-mode`

`transition-mode` パラメータ属性はどうやって2つの動的コンポーネント間でトランジションが実行されるべきかどうか指定できます。

デフォルトでは、入ってくるコンポーネントと出て行くコンポーネントのトランジションが同時に起こります。この属性によって、2つの他のモードを設定することができます:

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

しかしながら、コンポーネントはそれら独自の隔離されたスコープを持っているので、これはコンポーネントにデータを渡しません。コンポーネントに反復されたデータを渡すために、props を使用する必要があります:

``` html
<my-component
  v-for="item in items"
  :item="item"
  :index="$index">
</my-component>
```

コンポーネントに自動的に `item` が注入していない理由は、コンポーネントは `v-for` が動作すると密結合されるからです。他の状況では、データはコンポーネントの再利用可能なものからなのか明確しています。

### 再利用可能なコンポーネントの著作

コンポーネントを著作するとき、後でどこかにこのコンポーネントを再利用する予定があるかどうか心に留めておくとよいでしょう。一度限りのコンポーネントが互いにいくつか密結合を持つことについてよいですが、再利用可能なコンポーネントはきれいな公開インタフェースを定義する必要があります。

Vue.js コンポーネント向けの API は、本質的に、props 、events 、slots の3つの部分からなります:

- **Props** コンポーネントにデータを供給するために外部環境を可能にします。

- **Events** 外部環境でアクションをトリガーするためにコンポーネントを可能にします。

- **Slots** コンポーネントの view 構造でのコンテンツを挿入するために外部環境を可能にします。

`v-bind` と `v-on` に対して省略記法構文を使用すると、意図を明確にすることができ、そしてテンプレートに簡潔に伝えることができます:

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

大規模アプリケーションでは、実際に必要になったとき、サーバからコンポーネントをロードするだけの、アプリケーションを小さい塊に分割する必要があるかもしれません。それを簡単にするために、Vue.js はコンポーネント定義を非同期的に解決するファクトリ関数としてコンポーネントを定義することができます。Vue.js はコンポーネントが実際に描画が必要になったときファクトリ関数のみトリガし、そして将来の再描画のために結果をキャッシュします。例えば:

``` js
Vue.component('async-example', function (resolve, reject) {
  setTimeout(function () {
    resolve({
      template: '<div>I am async!</div>'
    })
  }, 1000)
})
```

ファクトリ関数は `resolve` コールバックを受け取り、その引数はサーバからコンポーネント定義を取り戻すときに呼ばれるべきです。ロードが失敗したことを示すために、`reject(reason)` も呼びだすことができます。ここでは `setTimeout` はデモとしてシンプルです。どうやってコンポーネントを取得するかどうかは完全にあなた次第です。1つ推奨されるアプローチは [Webpack のコード分割機能](http://webpack.github.io/docs/code-splitting.html)で非同期コンポーネントを使うことです。

``` js
Vue.component('async-webpack-example', function (resolve) {
  // この特別な require 構文は、
  // 自動的に ajax リクエストでロードされているバンドルで、
  // ビルドコードを自動的に分割するために
  // webpack で指示しています
  require(['./my-async-component'], resolve)
})
```

### アセットの命名規則

コンポーネントやディレクティブのようなあるアセットは、HTML 属性または HTML カスタムタグの形でテンプレートに表示されます。HTML 属性名とタグ名は**大文字と小文字を区別しない (case-insensitive)** ため、しばしばキャメルケースの代わりにケバブケースを使用してアセットに名前をつける必要がありますが、これは少し不便です。

Vue.js は実際にキャメルケースまたはパスカルケース (PascalCase) を使用してアセットを命名するのをサポートし、自動的にそれらをテンプレートでケバブケースとして解決します (props の命名と似ています):

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

これは [ES6 object literal shorthand](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Object_initializer#New_notations_in_ECMAScript_6) でうまく動作します:

``` js
// PascalCase
import TextBox from './components/text-box';
import DropdownMenu from './components/dropdown-menu';

export default {
  components: {
    // <text-box> そして <dropdown-menu> としてテンプレートで使用します
    TextBox,
    DropdownMenu
  }
}
```

### 再帰的なコンポーネント

コンポーネントは再帰的に独自のテンプレートで自分自身を呼びだすことができます。しかしながら、それは `name` オプションがあるときだけそのようなことができます:

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

上記のようなコンポーネントは、"max stack size exceeded" エラーのような結果になり、再帰呼び出しは条件付きであるようにしてください。`Vue.component()` を使用してグローバルなコンポーネントを要録するとき、グローバル ID が自動的にコンポーネントの `name` オプションとして設定されます。

### フラグメントインスタンス

`template` オプションを使用するとき、テンプレートのコンテンツは Vue インスタンスがマウントされている要素に置き換えます。それゆえ、常にテンプレートで単一の root レベルの純粋な要素を持つように推奨されます。

このようなテンプレートの代わりとして:

``` html
<div>root node 1</div>
<div>root node 2</div>
```

これを選びます:

``` html
<div>
  I have a single root node!
  <div>node 1</div>
  <div>node 2</div>
</div>
```

Vue インスタンスが **フラグメントインスタンス**に変わるいくつかの条件があります:

1. テンプレートが複数のトップレベル要素を含む場合
2. テンプレートがプレーンなテキストだけ含む場合
3. テンプレートが他のコンポーネントだけ含む場合 (潜在的にフラグメントインスタンスそれ自身可能)
4. テンプレートがエレメントディレクティブだけ含む場合。例: `<partial>` または vue-router の `<router-view>`
5. テンプレートの root なノードがフロー制御ディレクティブを持つ場合。例: `v-if` または `v-for`

その理由としては、上記全ては、それがフラグメントとして DOM コンテンツを管理しなければならないので、インスタンスはトップレベルの要素の未知数を持たせます。フラグメントインスタンスは正常にコンテンツをレンダリングします。しかしながら、それは root なノードを持って**おらず**、その `$el` は空のテキストノード(またはデバッグモードではコメントノード)である"アンカーノード"を指すようになります。

しかし何より重要なのは、**フロー制御しないディレクティブ、prop ではない属性、そしてコンポーネント要素でのトランジションは、無視される**ということで、それらをバインドする root な要素がないためです:

``` html
<!-- root 要素がないため動作しません -->
<example v-show="ok" transition="fade"></example>

<!-- props は動作します -->
<example :prop="someData"></example>

<!-- フロー制御は動作しますが、トランジションはなしです -->
<example v-if="ok"></example>
```

フラグメントインスタンスに対して有効なユースケースはもちろんありますが、それはコンポーネントテンプレートにプレーンな root な要素を単一で与えるために、一般的によいアイディアです。それは、ディレクティブを確保して、コンポーネント要素に属性を適切に移させると、わずかにパフォーマンスが良い結果になります。

### インラインテンプレート

特別な属性 `inline-template` が子コンポーネントに存在するとき、配信コンテンツとして扱うよりむしろ、コンポーネントはそれをテンプレートとして内部コンテンツを使用します。これは、より柔軟なテンプレートを著作可能になります。

``` html
<my-component inline-template>
  <p>These are compiled as the component's own template</p>
  <p>Not parent's transclusion content.</p>
</my-component>
```

しかしながら、`inline-template` はテンプレートのスコープを推論するのが難しくなり、コンポーネントのテンプレートコンパイルがキャッシュできなくなります。ベストプラクティスとして、`template` オプションを使用して、コンポーネント内部でテンプレートを定義する方がむしろよいです。
