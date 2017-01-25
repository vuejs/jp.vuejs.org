---
title: コンポーネント
type: guide
order: 11
---

## コンポーネントとは何ですか？

コンポーネントは Vue.js の最も強力な機能の 1 つです。基本的な HTML 要素を拡張して再利用可能なコードのカプセル化を助けます。ハイレベルには、コンポーネントは Vue.js のコンパイラが指定された振舞いを加えるカスタム要素です。場合によっては、特別な `is` 属性で拡張されたネイティブな HTML 要素の姿をとることもあります。

## コンポーネントの使用

### 登録

以前のセクションで、以下のように Vue インスタンスを作成できることを学習しました:

``` js
new Vue({
  el: '#some-element',
  // オプション
})
```

グローバルなコンポーネントを登録するためには、 `Vue.component(tagName, options)` を使うことができます。例:

``` js
Vue.component('my-component', {
  // オプション
})
```

<p class="tip">カスタムタグの名前について [W3C ルール](http://www.w3.org/TR/custom-elements/#concepts) (全て小文字で、ハイフンが含まれている必要がある)にしたがうことは良い取り組みと考えられますが、 Vue はそれを強制しないことを覚えておいてください。</p>

一度登録すると、コンポーネントはカスタム要素 `<my-component>` として親のインスタンスのテンプレートで使用できます。コンポーネントが root の Vue インスタンスをインスタンス化する**前**に登録されているか確認してください。ここに完全な例を示します:

``` html
<div id="example">
  <my-component></my-component>
</div>
```

``` js
// 登録する
Vue.component('my-component', {
  template: '<div>A custom component!</div>'
})

// root インスタンスを作成する
new Vue({
  el: '#example'
})
```

描画される内容は以下になります:

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

### ローカル登録

グローバルに全てのコンポーネントを登録する必要はありません。別のコンポーネントのインスタンスオプションの `components` に登録することで、そのコンポーネントのスコープ内でのみ利用可能なコンポーネントを作成できます:

``` js
var Child = {
  template: '<div>A custom component!</div>'
}

new Vue({
  // ...
  components: {
    // <my-component> は親テンプレートでのみ有効になります
    'my-component': Child
  }
})
```

同じカプセル化は、ディレクティブのようなアセットタイプに対して適用されます。

### DOM テンプレート解析の注意事項

DOM をテンプレートとして使うとき(例、ある要素をすでに存在する要素にマウントするために `el` オプションを使うとき)、あなたは HTML がどのように動くかに内在する幾つかの制約の影響を受けます。なぜなら、 Vue はブラウザがテンプレートを解析して正規化した **後** にのみテンプレートの内容を検索することができるからです。特に、 `<ul>`, `<ol>`, `<table>`, `<select>` のようないくつかの要素は、その要素の内部にどの要素を表示させることができるかの制約を持ち、 `<option>` のようないくつかの要素は、ある特定の要素の内部でのみ表示されます。

このことは、いくつかの制約をもつ要素と共にカスタムコンポーネントを使うときに問題に繋がるかもしれません。例:

``` html
<table>
  <my-row>...</my-row>
</table>
```

カスタムコンポーネントの `<my-row>` は無効なコンテンツとして巻き上げられます。それゆえ、後に描画されたアウトプットの中でエラーを引き起こします。回避策は `is` という特殊な属性を使うことです:

``` html
<table>
  <tr is="my-row"></tr>
</table>
```
**注目すべきは、もしあなたが以下のソースのどれかから文字列テンプレートを使う場合には、これらの制約は適用されないということです。**

- `<script type="text/x-template">`
- JavaScript のインラインテンプレート文字列
- `.vue` コンポーネント

そのため、可能なときはいつでも文字列テンプレートの使用が好まれます。

### `data` は関数でなければならない

Vue コンストラクタに渡すことのできるほとんどのオプションは、コンポーネントの中で使用できます。しかし、1 つだけ特別なケースがあります: `data` は関数でなければいけません。実際、以下を試すと:

``` js
Vue.component('my-component', {
  template: '<span>{{ message }}</span>',
  data: {
    message: 'hello'
  }
})
```

その後 Vue の処理は止まり、コンポーネントインスタンスでは `data` は関数でなければならないと伝える警告をコンソールに出力します。しかしながら、どうしてそのルールが存在するかを理解するのはいいことでしょうから、ちょっとズルをしてみましょう。

``` html
<div id="example-2">
  <simple-counter></simple-counter>
  <simple-counter></simple-counter>
  <simple-counter></simple-counter>
</div>
```

``` js
var data = { counter: 0 }

Vue.component('simple-counter', {
  template: '<button v-on:click="counter += 1">{{ counter }}</button>',
  // data は技術的には関数なので、Vue は警告を出しません。
  // しかし、各コンポーネントのインスタンスは
  // 同じオブジェクトの参照を返します。
  data: function () {
    return data
  }
})

new Vue({
  el: '#example-2'
})
```

{% raw %}
<div id="example-2" class="demo">
  <simple-counter></simple-counter>
  <simple-counter></simple-counter>
  <simple-counter></simple-counter>
</div>
<script>
var data = { counter: 0 }
Vue.component('simple-counter', {
  template: '<button v-on:click="counter += 1">{{ counter }}</button>',
  data: function () {
    return data
  }
})
new Vue({
  el: '#example-2'
})
</script>
{% endraw %}

3 つのコンポーネントはすべて同じ `data` オブジェクトを共有しているので、ひとつのカウンタをインクリメントするとすべてのカウンタをインクリメントします！代わりに未使用の `data` オブジェクトを返すことにより、これを修正しましょう:

``` js
data: function () {
  return {
    counter: 0
  }
}
```

これで、すべてのカウンタはそれぞれカウンタ自身の内部状態を持ちます:

{% raw %}
<div id="example-2-5" class="demo">
  <my-component></my-component>
  <my-component></my-component>
  <my-component></my-component>
</div>
<script>
Vue.component('my-component', {
  template: '<button v-on:click="counter += 1">{{ counter }}</button>',
  data: function () {
    return {
      counter: 0
    }
  }
})
new Vue({
  el: '#example-2-5'
})
</script>
{% endraw %}

### コンポーネントの構成

コンポーネントは、一緒に使われることを意図されています。もっとも一般的なのは、親子関係です: コンポーネント A は自分自身のテンプレートとして、コンポーネント B を使用します。それらは必ずお互いに通信する必要があります。親は子にデータを伝える必要があるかもしれませんし、子は子で何が起こったかを、親に伝える必要があるかもしれません。しかし、はっきりと定義されたインタフェースを経由して、親と子を可能な限り分離されたものとしておくこともまた、とても大切です。これにより、各々のコンポーネントのコードは比較的独立した状態で書かれ判断されることが保証されます。それゆえ、コンポーネントを、よりメンテナンス可能で潜在的に再利用可能にできます。

Vue.js では、親子のコンポーネントの関係は、**props down, events up** というように要約することができます。親は、 **プロパティ**を経由して、データを子に伝え、子は**イベント**を経由して、親にメッセージを送ります。以下でどのように動くか見てみましょう。

<p style="text-align: center">
  <img style="width:300px" src="/images/props-events.png" alt="props down, events up">
</p>

## プロパティ

### プロパティによるデータの伝達

全てのコンポーネントインスタンスは、各自の**隔離されたスコープ (isolated scope)** を持ちます。つまり、子コンポーネントのテンプレートで親データを直接参照できない(そしてすべきでない)ということです。データは**プロパティ**を使用して子コンポーネントに伝達できます。

プロパティは親コンポーネントからの情報を伝えるためのカスタム属性です。子コンポーネントは、[`props` オプション](../api/#props)を利用して、伝達を想定するプロパティを明示的に宣言する必要があります:

``` js
Vue.component('child', {
  // プロパティを宣言します。
  props: ['message'],
  // 単なるデータのように、プロパティは内部テンプレートで使用することができ、
  // そして this.messageとして、vm の中で利用可能になります。
  template: '<span>{{ message }}</span>'
})
```

すると以下のようにプレーン文字列を渡すことができます:

``` html
<child message="hello!"></child>
```

結果:

{% raw %}
<div id="prop-example-1" class="demo">
  <child message="hello!"></child>
</div>
<script>
new Vue({
  el: '#prop-example-1',
  components: {
    child: {
      props: ['message'],
      template: '<span>{{ message }}</span>'
    }
  }
})
</script>
{% endraw %}

### キャメルケース vs ケバブケース

HTML の属性は大文字と小文字を区別しません。そのため、非文字列テンプレートを使用する場合、キャメルケースのプロパティ名を属性として使用するときは、それらをケバブケース (kebab-case: ハイフンで句切られた) にする必要があります:

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

繰り返しになりますが、もし文字列テンプレートを使用する場合は、この制限は適用されません。

### 動的なプロパティ

式に通常の属性をバインディングするのと同様に、 `v-bind` を使用して親のデータにプロパティを動的にバインディングすることもできます。親でデータが更新される度に、そのデータが子に流れ落ちます:

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

結果:

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

### リテラル vs 動的

初心者にありがちな誤りは、リテラル構文を使用して数を渡そうとすることです:

``` html
<!-- これは純粋な文字列"1"を渡します -->
<comp some-prop="1"></comp>
```

しかしながら、これはリテラルなプロパティなので、その値は実際に数の代わりに純粋な文字列 `"1"`が渡されています。実際に JavaScript の数を渡したい場合は、その値が JavaScript の式として評価されるよう、`v-bind` を使う必要があります:

``` html
<!-- これは実際の数を渡します -->
<comp v-bind:some-prop="1"></comp>
```

### 単方向データフロー

すべてのプロパティは、子プロパティと親プロパティの間の**単方向 (one-way-down)** バインディングを形成します: 親プロパティが更新したとき、それは子プロパティに伝わり、その反対はありません。これは、あなたのアプリケーションのデータフローの説明を難しくしてしまうような、子コンポーネントが偶然親の状態を変化させることを防ぎます。

それに加えて、親コンポーネントが更新されるたびに、子コンポーネント内のすべてのプロパティが最新の値に再読込されます。これは、子コンポーネント内部のプロパティを変更しようとするべきでないことを意味しています。もし変更しようとすると、 Vue はコンソール内で警告します。

プロパティを変更したくなる 2 つのケースがあります。

1. プロパティは初期値を渡すためにのみ使われ、子コンポーネントは単にその値をローカルデータプロパティとして使用したい場合

2. プロパティは変換が必要な生の値として渡されます。

これらのユースケースの適切な答えは:

1. プロパティの初期値をその初期値とするようなローカルデータプロパティを定義します。

  ``` js
  props: ['initialCounter'],
  data: function () {
    return { counter: this.initialCounter }
  }
  ```

2. プロパティの値から計算される算出プロパティ (computed property) を定義します。

  ``` js
  props: ['size'],
  computed: {
    normalizedSize: function () {
      return this.size.trim().toLowerCase()
    }
  }
  ```

<p class="tip"> JavaScript のオブジェクトや配列は参照渡しのため、もしプロパティが配列やオブジェクトなら、子内部のオブジェクトまたは配列自身の変更は、親の状態に影響を**与えます**。</p>

### プロパティ検証

コンポーネントは受け取るプロパティに対する必要条件を指定することができます。もし必要条件が満たされていない場合は、 Vue は警告を出します。これは、特に他人が使用する可能性のあるコンポーネントを作るときに便利です。

文字列の配列としてプロパティを定義する代わりに、検証要件を含んだオブジェクトハッシュフォーマットを使用できます:

``` js
Vue.component('example', {
  props: {
    // 基本な型チェック (`null` はどんな型でも受け付ける)
    propA: Number,
    // 複数の受け入れ可能な型
    propB: [String, Number],
    // 必須な文字列
    propC: {
      type: String,
      required: true
    },
    // デフォルト値
    propD: {
      type: Number,
      default: 100
    },
    // オブジェクトと配列のデフォルトはファクトリ関数から返すようにしています
    propE: {
      type: Object,
      default: function () {
        return { message: 'hello' }
      }
    },
    // カスタムバリデータ関数
    propF: {
      validator: function (value) {
        return value > 10
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

プロパティ検証が失敗すると、Vue は(開発ビルドを使用している場合)コンソールへの警告を提示します。

## カスタムイベント

親が子にプロパティを使用してデータを伝達できることを学んできました。しかし、何かが起こったとき、どのように親へ通信するのでしょうか？そこで Vue のカスタムイベントの出番です。

### カスタムイベントとの `v-on` の使用

すべての Vue インスタンスは [イベントインターフェイス](../api/#インスタンスメソッド-イベント) を実装しています。これは以下をできることを意味します:

- `$on(eventName)`を使用してイベントを購読します。
- `$emit(eventName)`を使用して自身にイベントをトリガーします。

<p class="tip">Vue のカスタムイベントはブラウザの [EventTarget API](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget) とは別ものであることに注意してください。同等に動作しますが、`$on` と `$emit` は `addEventListener` と `dispatchEvent` に対するエイリアスでは__ありません__。</p>

それに加えて、親コンポーネントは、子コンポーネントが使われているテンプレート内で直接 `v-on` を使用することで、子コンポーネントからのイベントを購読することができます。

<p class="tip">子で発行されたイベントを購読するために `$on` を使用することはできません。以下の例のように、テンプレートでは直接 `v-on` を使用しなければなりません。</p>

以下が例です:

``` html
<div id="counter-event-example">
  <p>{{ total }}</p>
  <button-counter v-on:increment="incrementTotal"></button-counter>
  <button-counter v-on:increment="incrementTotal"></button-counter>
</div>
```

``` js
Vue.component('button-counter', {
  template: '<button v-on:click="increment">{{ counter }}</button>',
  data: function () {
    return {
      counter: 0
    }
  },
  methods: {
    increment: function () {
      this.counter += 1
      this.$emit('increment')
    }
  },
})

new Vue({
  el: '#counter-event-example',
  data: {
    total: 0
  },
  methods: {
    incrementTotal: function () {
      this.total += 1
    }
  }
})
```

{% raw %}
<div id="counter-event-example" class="demo">
  <p>{{ total }}</p>
  <button-counter v-on:increment="incrementTotal"></button-counter>
  <button-counter v-on:increment="incrementTotal"></button-counter>
</div>
<script>
Vue.component('button-counter', {
  template: '<button v-on:click="increment">{{ counter }}</button>',
  data: function () {
    return {
      counter: 0
    }
  },
  methods: {
    increment: function () {
      this.counter += 1
      this.$emit('increment')
    }
  },
})
new Vue({
  el: '#counter-event-example',
  data: {
    total: 0
  },
  methods: {
    incrementTotal: function () {
      this.total += 1
    }
  }
})
</script>
{% endraw %}

この例では、子コンポーネントはその外で起こったこととはまだ完全に分離しているということに注目することが大切です。子コンポーネントが唯一行っていることは、親コンポーネントが監視している場合に備えて、自分自身の活動に関する情報を報告することです。

#### ネイティブイベントとコンポーネントのバインディング

コンポーネントの root 要素でのネイティブイベントを購読したいときがあるかもしれません。このような場合、`v-on` に `.native` 修飾子を使用することができます。例:

``` html
<my-component v-on:click.native="doTheThing"></my-component>
```

### カスタムイベントを使用したフォーム入力コンポーネント

カスタムイベントは、`v-model`とともに動く、カスタムフォーム入力を作成するためにも使用されます。以下を思い出しましょう:

``` html
<input v-model="something">
```

は、以下の糖衣構文です:

``` html
<input v-bind:value="something" v-on:input="something = $event.target.value">
```

コンポーネントと共に使用されるとき、これは簡単にできます:

``` html
<custom-input v-bind:value="something" v-on:input="something = arguments[0]"></custom-input>
```

そのため、コンポーネントを `v-model` と共に動かすためには、以下が必要です:

- `value` プロパティを受け入れる
- 新しい値と共に `input` イベントを送出する

とても簡単な通貨入力で、実行して見てみましょう:

``` html
<currency-input v-model="price"></currency-input>
```

``` js
Vue.component('currency-input', {
  template: '\
    <span>\
      $\
      <input\
        ref="input"\
        v-bind:value="value"\
        v-on:input="updateValue($event.target.value)"\
      >\
    </span>\
  ',
  props: ['value'],
  methods: {
    // 値を直接的に更新する代わりに、このメソッドを使用して input の
    // 値の整形と値に対する制約が行われる
    updateValue: function (value) {
      var formattedValue = value
        // 両端のスペースを削除
        .trim()
        // 小数点2桁以下まで短縮
        .slice(0, value.indexOf('.') + 3)
      // 値が既に正規化されていないならば、
      // 手動で適合するように上書き
      if (formattedValue !== value) {
        this.$refs.input.value = formattedValue
      }
      // input イベントを通して数値を発行する
      this.$emit('input', Number(formattedValue))
    }
  }
})
```

{% raw %}
<div id="currency-input-example" class="demo">
  <currency-input v-model="price"></currency-input>
</div>
<script>
Vue.component('currency-input', {
  template: '\
    <span>\
      $\
      <input\
        ref="input"\
        v-bind:value="value"\
        v-on:input="updateValue($event.target.value)"\
      >\
    </span>\
  ',
  props: ['value'],
  methods: {
    updateValue: function (value) {
      var formattedValue = value
        .trim()
        .slice(0, value.indexOf('.') + 3)
      if (formattedValue !== value) {
        this.$refs.input.value = formattedValue
      }
      this.$emit('input', Number(formattedValue))
    }
  }
})
new Vue({
  el: '#currency-input-example',
  data: { price: '' }
})
</script>
{% endraw %}

上記の実装は、かなり素朴です。例えば、複数のピリオドや文字を入力することができます。うわっ！そこで、自明でない例を見たい人は、より堅固な通貨フィルタが以下にあります:

<iframe width="100%" height="300" src="https://jsfiddle.net/chrisvfritz/1oqjojjx/embedded/result,html,js" allowfullscreen="allowfullscreen" frameborder="0"></iframe>

イベントインターフェイスは、より特殊な入力フィールドを作成するために使用することもできます。例えば、次のような可能性を想像してみてください:

``` html
<voice-recognizer v-model="question"></voice-recognizer>
<webcam-gesture-reader v-model="gesture"></webcam-gesture-reader>
<webcam-retinal-scanner v-model="retinalImage"></webcam-retinal-scanner>
```

### 親子間以外の通信

ときどき、互いに親子関係ではない2つのコンポーネントが互いに通信する必要があるかもしれません。簡単なシナリオとして、空の Vue インスタンスを中心のイベントバスとして使用することができます:

``` js
var bus = new Vue()
```
``` js
// コンポーネント A のメソッドの中で
bus.$emit('id-selected', 1)
```
``` js
// コンポーネント B の created フックで
bus.$on('id-selected', function (id) {
  // ...
})
```

より複雑なケースでは、専用の [状態管理パターン](state-management.html) 採用することを考えるべきです。

## スロットによるコンテンツ配信

複数のコンポーネントを使用するとき、しばしばそれらをこのように構成したくなります:

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
  {{ message }}
</child-component>
```

`message` は親のデータと子のデータのどちらに束縛されるべきでしょうか？答えは親です。コンポーネントスコープに対するシンプルな経験則:

> 親テンプレート内の全てのものは親のスコープでコンパイルされ、子テンプレート内の全てものは子のスコープでコンパイルされる

よくある間違いは、親テンプレート内の子のプロパティ/メソッドにディレクティブを束縛しようとすることです:

``` html
<!-- 動作しません -->
<child-component v-show="someChildProperty"></child-component>
```

`someChildProperty` は子コンポーネントのプロパティと仮定すると、上記の例は動作しないでしょう。親のテンプレートは子コンポーネントの状態について認識していません。

コンポーネントで子スコープのディレクティブに束縛する必要がある場合、子コンポーネント自身のテンプレートにおいてそうすべきです:

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

親コンテンツは子コンポーネントのテンプレートが少なくとも 1 つの `<slot>` アウトレットを含んでいない限り**破棄されます**。属性なしのスロットが 1 つだけあるときは、全コンテンツはスロットそのものを置き換え、DOM 内のその位置に挿入されます。

`<slot>` タグ内に元々あった全てのものは、**フォールバックコンテンツ**と見なされます。フォールバックコンテンツは子スコープでコンパイルされ、ホストしている要素が空で挿入されるコンテンツがない場合にのみ、表示されます。

`my-component` と呼ばれる以下のテンプレートによるコンポーネントがあるとします。

``` html
<div>
  <h2>I'm the child title</h2>
  <slot>
    This will only be displayed if there is no content
    to be distributed.
  </slot>
</div>
```

コンポーネントを使用した親は以下になります:

``` html
<div>
  <h1>I'm the parent title</h1>
  <my-component>
    <p>This is some original content</p>
    <p>This is some more original content</p>
  </my-component>
</div>
```

描画された結果は以下になります:

``` html
<div>
  <h1>I'm the parent title</h1>
  <div>
    <h2>I'm the child title</h2>
    <p>This is some original content</p>
    <p>This is some more original content</p>
  </div>
</div>
```

### 名前付きスロット

`<slot>` 要素は特別な属性 `name` を持ち、コンテンツを配信する方法をカスタマイズするために使用できます。異なる名前で複数のスロットを持つことができます。名前付きスロットは、コンテンツ内の対応する `slot` 属性を持つ任意の要素にマッチします。

マッチしなかったコンテンツのためのキャッチオールアウトレットの機能を持つ**デフォルトスロット**として、名前無しのスロットを残すことができます。デフォルトスロットがない場合は、マッチしなかったコンテンツは破棄されます。

例として、以下のテンプレートのような、`app-layout` コンポーネントがあると仮定します:

``` html
<div class="container">
  <header>
    <slot name="header"></slot>
  </header>
  <main>
    <slot></slot>
  </main>
  <footer>
    <slot name="footer"></slot>
  </footer>
</div>
```

親のマークアップは以下です:

``` html
<app-layout>
  <h1 slot="header">Here might be a page title</h1>

  <p>A paragraph for the main content.</p>
  <p>And another one.</p>

  <p slot="footer">Here's some contact info</p>
</app-layout>
```

描画された結果は以下になります:

``` html
<div class="container">
  <header>
    <h1>Here might be a page title</h1>
  </header>
  <main>
    <p>A paragraph for the main content.</p>
    <p>And another one.</p>
  </main>
  <footer>
    <p>Here's some contact info</p>
  </footer>
</div>
```

コンテンツ配信 API は、組み合わせて使うことを意図したコンポーネントを設計する際に、非常に便利なメカニズムです。

### スコープ付きスロット

> New in 2.1.0

スコープ付きスロット (scoped slot) は、既に描画された要素の代わりに再利用可能なテンプレート(データを渡すことができる)として機能する特殊なタイプのスロットです。

子コンポーネントでは、コンポーネントにプロパティを渡すかのように、単純にデータをスロットに渡します:

``` html
<div class="child">
  <slot text="hello from child"></slot>
</div>
```

親においては、特別な属性 `scope` を持つ `<template>` 要素はスコープ付きスロット用のテンプレートを示します。`scope` の値は、子から渡された props オブジェクトを保持する一時変数の名前です:

``` html
<div class="parent">
  <child>
    <template scope="props">
      <span>hello from parent</span>
      <span>{{ props.text }}</span>
    </template>
  </child>
</div>
```

上記のように描画すると、出力は次のようになります:

``` html
<div class="parent">
  <div class="child">
    <span>hello from parent</span>
    <span>hello from child</span>
  </div>
</div>
```

スコープ付きスロットのより一般的なユースケースは、コンポーネント利用者がリスト内の各アイテムの描画方法をカスタマイズできるようにする、リストコンポーネントでしょう:

``` html
<my-awesome-list :items="items">
  <!-- scoped slot can be named too -->
  <template slot="item" scope="props">
    <li class="my-fancy-item">{{ props.text }}</li>
  </template>
</my-awesome-list>
```

リストコンポーネントのテンプレートでは次のようになります:

``` html
<ul>
  <slot name="item"
    v-for="item in items"
    :text="item.text">
    <!-- フォールバックコンテンツはここへ -->
  </slot>
</ul>
```

## 動的コンポーネント

予約された `<component>` 要素と、その `is` 属性に動的に束縛することで、同じマウントポイントで複数のコンポーネントを動的に切り替えることができます:

``` js
var vm = new Vue({
  el: '#example',
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
<component v-bind:is="currentView">
  <!-- vm.currentview が変更されると、中身が変更されます! -->
</component>
```

もしお好みならば、コンポーネントオブジェクトを直接束縛することもできます:

``` js
var Home = {
  template: '<p>Welcome home!</p>'
}

var vm = new Vue({
  el: '#example',
  data: {
    currentView: Home
  }
})
```

### `keep-alive`

状態を保持したり再描画を避けたりするために、もし切り替えで取り除かれたコンポーネントを生きた状態で保持したい場合は、`<keep-alive>` 要素のなかで動的コンポーネントを抱合(wrap)することができます。

``` html
<keep-alive>
  <component :is="currentView">
      <!-- 非活性になったコンポーネントをキャッシュします! -->
  </component>
</keep-alive>
```

`<keep-alive>` のさらなる詳細については、[API リファレンス](../api/#keep-alive) を確認してください。

## その他

### 再利用可能なコンポーネントの作成

コンポーネントを作成するとき、あとでこのコンポーネントをどこかほかの箇所で再利用するつもりかどうかを心に留めておくとよいでしょう。一度限りのコンポーネントが密に結びつくことは良いとしても、再利用可能なコンポーネントはきれいな公開インタフェースを定義し、どの中で使われるかに関してはなにも仮定しないようにするべきです。

Vue コンポーネントのための API は、本質的に、プロパティ、イベント、スロットの3つの部分から成ります:

- **プロパティ** 外部環境がコンポーネントにデータを渡すことを可能にします。

- **イベント** コンポーネントが外部環境の副作用をトリガーすることを可能にします。

- **スロット** 外部によって追加されるコンテンツとともにコンポーネントを構成することを可能にします。

`v-bind` と `v-on` 用の省略記法を使うと、意図を明確かつ簡潔にテンプレート内で伝えることができます:

``` html
<my-component
  :foo="baz"
  :bar="qux"
  @event-a="doThis"
  @event-b="doThat"
>
  <img slot="icon" src="...">
  <p slot="main-text">Hello!</p>
</my-component>
```

### 子コンポーネントの参照

プロパティやイベントの存在にもかかわらず、時には子コンポーネントに JavaScript で直接アクセスする必要があるかもしれません。それを実現するためには `ref` を用いて子コンポーネントに対して参照 ID を割り当てる必要があります。例えば:

``` html
<div id="parent">
  <user-profile ref="profile"></user-profile>
</div>
```

``` js
var parent = new Vue({ el: '#parent' })
// 子コンポーネントのインスタンスへのアクセス
var child = parent.$refs.profile
```

`ref` が `v-for` と共に使用された時は、得られる値はデータソースをミラーリングした子コンポーネントが格納されている配列またはオブジェクトになります。

<p class="tip">`$refs` はコンポーネントが描画された後にのみ追加されます。そしてそれはリアクティブではありません。直接子コンポーネントを操作するための最終手段としての意味しかありません。テンプレートまたは算出プロパティの中での `$refs` の使用は避けるべきです。</p>

### 非同期コンポーネント

大規模アプリケーションでは、アプリケーションを小さな塊に分割して、実際に必要になったときにサーバからコンポーネントをロードするだけにする必要があるかもしれません。それを簡単にするために、Vue.js ではコンポーネント定義を非同期的に解決するファクトリ関数としてコンポーネントを定義することができます。Vue はコンポーネントが実際に描画が必要になるとファクトリ関数のトリガだけ行い、将来の再描画のために結果をキャッシュします。例えば:

``` js
Vue.component('async-example', function (resolve, reject) {
  // コンポーネント定義を resolve コールバックで渡す
  setTimeout(function () {
    resolve({
      template: '<div>I am async!</div>'
    })
  }, 1000)
})
```

ファクトリ関数は、サーバからコンポーネント定義を取得した後で呼ばれる `resolve` コールバックを引数に持ちます。ロードが失敗したことを示すために、`reject(reason)` を呼びだすこともできます。ここでの `setTimeout` は単にデモのためのものです。どうやってコンポーネントを取得するかは完全にあなた次第です。推奨されるアプローチの 1 つは [Webpack のコード分割機能](http://webpack.github.io/docs/code-splitting.html)で非同期コンポーネントを使うことです。

``` js
Vue.component('async-webpack-example', function (resolve) {
  // この特別な require 構文は webpack に対して
  // ビルドコードを自動的に分割し、
  // ajaxリクエストでロードされるバンドルに
  // するよう指示します
  require(['./my-async-component'], resolve)
})
```

ファクトリ関数は `Promise` を返すこともできます。Webpack 2 + ES2015 構文を使うと以下のようにできます:

``` js
Vue.component(
  'async-webpack-example',
  () => System.import('./my-async-component')
)
```

<p class="tip">もしあなたが <strong>Browserify</strong> のユーザで非同期コンポーネントを使いたいとしたら、残念なことに開発者が[はっきりと](https://github.com/substack/node-browserify/issues/58#issuecomment-21978224)非同期読み込みは Browserify では今後もサポートしない"と述べています。少なくとも公式には。 Browserify コミュニティは、既存のアプリケーションや複雑なアプリケーションに役立つ[いくつかの回避策](https://github.com/vuejs/vuejs.org/issues/620)があります。他のすべてのシナリオでは、ファーストクラスとして非同期サポートを組み込みで提供する Webpack を使用することをお勧めします。</p>

### コンポーネントの命名の慣習

コンポーネント(またはプロパティ)を登録する時、ケバスケース、キャメルケース、タイトルケースを使うことができます。Vue は気にしません。

``` js
//コンポーネント内での定義
components: {
  // ケバブケースを使った登録
  'kebab-cased-component': { /* ... */ },
  // キャメルケースを使った登録
  'camelCasedComponent': { /* ... */ },
  // タイトルケースを使った登録
  'TitleCasedComponent': { /* ... */ }
}
```

しかし、HTML テンプレートの中では、ケバブケースを使用する必要があります。

``` html
<!-- alway use kebab-case in HTML templates -->
<!-- HTMLテンプレートの中では、常にケバブケースを使用する -->
<kebab-cased-component></kebab-cased-component>
<camel-cased-component></camel-cased-component>
<title-cased-component></title-cased-component>
```

しかし _文字列_ テンプレートを使用するときは、大文字と小文字を区別しない HTML の制約に縛られません。このことは、テンプレートの中でも、キャメルケース、タイトルケースまたは、ケバブケースを使用してコンポーネントとプロパティを参照できるということを意味します。

``` html
<!-- 文字列テンプレートの中では使用したいケースをなんでも使用できます！ -->
<my-component></my-component>
<myComponent></myComponent>
<MyComponent></MyComponent>
```

もしコンポーネントが `slot` を介してコンテンツを伝えない場合は、名前のあとに `/` をつけることによって自己終了( self-closing )タグにすることもできます。


``` html
<my-component/>
```

自己終了カスタム要素は有効な HMTL でなく、あなたのブラウザのネイティブパーサーはそれらを理解しないため、これは文字列テンプレートの中で_のみ_動作します。


### 再帰的なコンポーネント

コンポーネントはそのテンプレートで自分自身を再帰的に呼びだすことができます。ただし、それができるのは `name` オプションがあるときだけです:

``` js
name: 'unique-name-of-my-component'
```

`Vue.component()` を使用してグローバルなコンポーネントを登録するとき、そのグローバル ID が自動的にコンポーネントの `name` オプションとして設定されます。

```js
Vue.component('unique-name-of-my-component', {
  // ...
})
```

注意しないと、再帰的なコンポーネントは無限ループにつながる可能性があります:

``` js
name: 'stack-overflow',
template: '<div><stack-overflow></stack-overflow></div>'
```

上記のようなコンポーネントは、"max stack size exceeded" エラーに想定されるため、再帰呼び出しは条件付きになるようにしてください。(i.e. 最終的に `false` となる `v-if` を使用します)

### コンポーネント間の循環参照

Finder  や File Explorer のようなファイルディレクトリツリーを構築しているとしましょう。以下のようなテンプレートを持つ `tree-folder` コンポーネントがあるかもしれません：

``` html
<p>
  <span>{{ folder.name }}</span>
  <tree-folder-contents :children="folder.children"/>
</p>
```

次に、以下のようなテンプレートを持つ `tree-folder-contents` コンポーネントがあるとき:

``` html
<ul>
  <li v-for="child in children">
    <tree-folder v-if="child.children" :folder="child"/>
    <span v-else>{{ child.name }}</span>
  </li>
</ul>
```
よく見ると、これらのコンポーネントは実際にお互いの子孫となり、_かつ_レンダリングツリーの祖先ということがわかります。ああ、パラドックスですね！`Vue.component` でコンポーネントをグローバルに登録すると、このパラドックスは自動的に解決されます。あなたの問題がそれで解決されたなら、ここで読むことをやめることができます。

しかしながら、__モジュールシステム__ を使用してコンポーネントを読み込む場合、例えば、Webpack または Browserify 経由では以下のようなエラーになるでしょう:

```
Failed to mount component: template or render function not defined.
```

何が起こっているのかを説明するために、あるコンポーネント A とコンポーネント B があるとします。モジュールシステムには、A が必要ですが、最初の A は B を必要としますが、B は A を必要とし、A は B を必要とする場合は、最初に他のものを解決せずにいずれかのコンポーネントを完全に解決する方法を知らないためループになってしまいます。これを修正するには、モジュールシステムに "A は B が必要になるが、最終的には B を最初に解決する必要はない" と言うことができるポイントを与える必要があります。

先程のケースでは、`tree-folder` コンポーネントをポイントにします。パラドックスを作成する子は、`tree-folder-contents` コンポーネントとなるため、`beforeCreate` ライフサイクルフックが登録されるまで待ちます:

``` js
beforeCreate: function () {
  this.$options.components.TreeFolderContents = require('./tree-folder-contents.vue')
}
```

これで問題を解決できます！

### インラインテンプレート

特別な属性 `inline-template` が子コンポーネントに存在するとき、配信コンテンツとして扱うよりむしろ、コンポーネントはそれをテンプレートとして内部コンテンツを使用します。これは、より柔軟なテンプレートを作成可能にします。

``` html
<my-component inline-template>
  <div>
    <p>These are compiled as the component's own template.</p>
    <p>Not parent's transclusion content.</p>
  </div>  
</my-component>
```

しかしながら、`inline-template` はテンプレートのスコープを推理するのが難しくなります。ベストプラクティスとして、`template` オプションを使用して、コンポーネント内部でテンプレートを定義するようにするか、`.vue` ファイルの `template` 要素の中で定義します。

### x-template

テンプテートを定義するもうひとつの方法は、`text/x-template` タイプとともに script 要素の中で定義するというものです。そのあと、id によってテンプレートを参照します。例:

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

これらは大きなテンプレートを使ったデモまたは、極めて小さなアプリケーションに便利です。しかし、それ以外では避けるべきです。なぜなら、コンポーネントの定義の残りからテンプレートを分離するからです。

### `v-once` を使用した安価な静的コンポーネント

Vue では、素の HTML 要素を描画するのはとても高速です。しかし、時どき、静的なコンテンツを **大量に** 含むコンポーネントがあるかもしれません。このような場合、以下のように root 要素で `v-once` ディレクティブを追加することによって、コンポーネントを一度のみ評価しキャッシュしておくことを保証することができます。

``` js
Vue.component('terms-of-service', {
  template: '\
    <div v-once>\
      <h1>Terms of Service</h1>\
      ... a lot of static content ...\
    </div>\
  '
})
```
