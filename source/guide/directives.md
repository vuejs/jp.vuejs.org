title: ディレクティブ
type: guide
order: 3
---

## 概要

もし AngularJS を以前使ったことがないのであれば、あなたはおそらくディレクティブ( Directive )とは何であるか知らないでしょう。ディレクティブとは、 DOM 要素に対して何かを実行することをライブラリに伝達する、マークアップ中の特別なトークンです。Angular のものと比べ、 Vue.js でのディレクティブのコンセプトは徹底的にシンプルです。Vue.js のディレクティブは、下記のフォーマットのように、接頭辞のついた HTML 属性の形でのみ表されます。

``` html
<element
  prefix-directiveId="[argument:] expression [| filters...]">
</element>
```

## シンプルな例

``` html
<div v-text="message"></div>
```

このように、接頭辞はデフォルトで `v` です。このディレクティブ ID は `text` で、expression は `message` です。Vue インスタンス上の `message` プロパティが変更される時は常に、このディレクティブは Vue.js にdivの `textContent` を更新させます。

## インライン Expressions

``` html
<div v-text="'hello ' + user.firstName + ' ' + user.lastName"></div>
```

このように、私達は単一のプロパティキーの代わりに、 computed expression を使用します。Vue.js は expression が依存しているプロパティを自動的に監視し、変更があったときは常にディレクティブを更新します。非同期なバッチ更新のおかげで、もし複数の依存関係に変更があったとしても、 expression はイベントループ毎に一度だけ更新されます。

特に副作用（イベントリスナ expression を除く）のあるステートメント (statement) の場合には、テンプレート内でロジックが過多になるのを避けるため、 expression を賢く利用してください。テンプレート内でロジックの使いすぎを防止するため、 Vue.js でのインライン expression は **1ステートメントのみ** に制限されています。更に複雑な操作を要するバインディングには、代わりに　[Computed Properties](/guide/computed.html) を利用してください。

<p class="tip">セキュリティ上の理由のため、インライン expression では、現在のコンテキストの Vue インスタンスおよび、親のプロパティとメソッドにのみアクセスできます。</p>

## 引数

``` html
<div v-on="click : clickHandler"></div>
```

いくつかのディレクティブでは、keypath または expression の前に引数が必要です。この例での `click` 引数は、`v-on` ディレクティブによって click イベントを監視し、そして ViewModel インスタンスの `clickHandler` メソッドを呼び出すことを表します。

## フィルタ

DOM の更新前に値をさらに加工するために、フィルタを directive keypath もしくは expression に追加することができます。フィルタは、シェルスクリプトに見られるようなパイプ(`|`)で表されます。詳しくは [フィルタ](/guide/filters.html) を参照してください。

## 複数の節
カンマで区切ることで、一つの属性内の同じディレクティブ内に、複数のバインディングを定義することができます。これらは、内部では複数のディレクティブインスタンスにバインドされます。

``` html
<div v-on="
  click   : onClick,
  keyup   : onKeyup,
  keydown : onKeydown
">
</div>
```

## リテラルディレクティブ

いくつかのディレクティブはデータバインディングを生成せず、単に文字列リテラルを属性値として取ります。例えば、`v-ref` ディレクティブでは下記のようになります。

``` html
<my-component v-ref="some-string-id"></my-component>
```

このように、`"some-string-id"` はリアクティブな expression ではなく、Vue.js はコンポーネントデータでそれをルックアップしようとしません。対応するコンポーネントコンストラクタの検索に利用される文字列IDです。

いくつかのケースでは、リテラルディレクティブは、反応性にするために Mustache 構文を使用することができます:

``` html
<div v-show="showMsg" v-transition="{{dynamicTransitionId}}"></div>
```

しかしながら、この機能を持つディレクティブは `v-transition` だけということに注意してください。他のリテラルディレクティブ（例：`v-ref`）内の Mustache expression は、 **一度だけ** 評価されます。ディレクティブのコンパイル実行後、値の変化に反応することはありません。

リテラルディレクティブの全リストは [API リファレンス](/api/directives.html#リテラルディレクティブ) 内にあります。

## エンプティディレクティブ

いくつかのディレクティブは、属性値すら期待せず、単純にその要素に何かを一度きり行います。例えば `v-pre` ディレクティブでは下記のようになります。

``` html
<div v-pre>
  <!-- この内部のマークアップはコンパイルされません -->
</div>
```

エンプティディレクティブの全リストは[API リファレンス](/api/directives.html#エンプティディレクティブ) 内にあります。

## 非同期更新の理解

ディレクティブは、データの状態を DOM の状態へのマッピングとしてみなすことができます。しかしながら、それは Vue.js では理解するために重要です。ディレクティブ更新の工程はデフォルトで非同期です。例として、`vm.someData = 'new value'` をセットしたとき、DOM はすぐには更新しません。Vue.js は同じイベントループで変更の生じた全てのデータをバッファし、そして、次の "tick" で任意に必要な DOM 更新を非同期に実行します。内部的には、もし `MutationObserver` が利用可能ならそれを使い、そうでなければ `setTimeout(fn, 0)` にフォールバックします。これは、重複更新のトリガーからデータの同じ部分への複数の変更を防ぎます。

この振舞いは、更新した DOM の状態に依存する何かをしたいとき、注意が必要です。Vue.js は一般的に"データ駆動"的な方法で考えることを開発者に奨励していますが、時々、いつも使用してきた便利な jQuery プラグインをまさに使用したいときは、DOM を直接触れないようにしてください。Vue.js でデータの変更後に、DOM の更新が完了するまでに待つためには、データが変更された直後に `Vue.nexttick(callback)` を使用することができます。 -  コールバックが呼ばれたとき、DOM は更新されていたであろう。例:

``` html
<div id="example">{{msg}}</div>
```

``` js
var vm = new Vue({
  el: '#example',
  data: {
    msg: '123'
  }
})
vm.msg = 'new message' // 変更データ
vm.$el.textContent === 'new message' // false
Vue.nextTick(function () {
  vm.$el.textContent === 'new message' // true
})
```

別な方法として、`Vue.config.async = false` の設定で、非同期更新を止めることができます。しかしながら、同期モードでウォッチャとディレクティブがトリガされる順番が異なってしまう場合がありますので、正確に同じ動作を保証しませんので注意してください。

では次に、[フィルタ](/guide/filters.html)について説明しましょう。
