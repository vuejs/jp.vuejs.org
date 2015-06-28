title: インスタンスメソッド
type: api
order: 4
---

## データ

Vue インスタンスでは、データの変更を監視することができます。すべての watch コールバックは非同期に発火することに注意してください。さらに、値の変更はイベントループの中でバッチ処理されます。これは、ひとつのイベントループの中で値が何度も変更された時に、コールバックは最新の値に対して一度しか発火しないことを意味します。

### vm.$watch( expOrFn, callback, [options] )

- **expOrFn** `String|Function`
- **callback( newValue, oldValue )** `Function`
- **options** `Object` *任意*
  - **deep** `Boolean` *任意*
  - **immediate** `Boolean` *任意*

Vue インスタンス上でのひとつの expression または computed function の変更を監視します。引数 expression には、単一の keypath か、実際の式を入れることができます:

``` js
vm.$watch('a + b', function (newVal, oldVal) {
  // 何かする
})
// または
vm.$watch(
  function () {
    return this.a + this.b
  },
  function (newVal, oldVal) {
    // 何かする
  }
)
```

オブジェクトの中のネストされた値の変更を検出するには、options 引数に `deep: true` を渡す必要があります。Array の値変更に対しては、こうする必要はないことに注意してください。

``` js
vm.$watch('someObject', callback, {
  deep: true
})
vm.someObject.nestedValue = 123
// コールバックが発火する
```

options 引数に `immediate: true` を渡すと、その時の式の値で、コールバックが直ちに実行されます:

``` js
vm.$watch('a', callback, false, {
  immediate: true
})
// その時の `a` の値でコールバックがただちに発火します
```

最後に、`vm.$watch` はコールバックの実行を停止する unwatch 関数を返します。

``` js
var unwatch = vm.$watch('a', cb)
// 後で監視を削除する
unwatch()
```

### vm.$get( expression )

- **expression** `String`

Vue インスタンスから与えられた式の値を抽出します。エラーのある式は、停止され、`undefined` を返します。

### vm.$set( keypath, value )

- **keypath** `String`
- **value** `*`

Vue インスタンスの data の、該当する keypath に値をセットします。もし path がなければ、作成されます。

### vm.$add( keypath, value )

- **keypath** `String`
- **value** `*`

Vue インスタンス（とその `$data` ）に ルートレベルのプロパティを追加します。ECMAScript 5 の制約により、Vue は直接オブジェクトに追加されたり、削除されたりするプロパティを検知することができません。そのため、追加や削除が必要な場合は、このメソッドや `vm.$delete` を使用する必要があります。さらに、すべての監視されたオブジェクトは、同様にこれら2つのメソッドで拡張されます。

### vm.$delete( keypath )

- **keypath** `String`

Vue インスタンス（それと、その `$data`）のルートレベルのプロパティを削除します。

### vm.$eval( expression )

- **expression** `String`

フィルタも含むことができるような式を評価します。

``` js
// vm.msg = 'hello' を仮定
vm.$eval('msg | uppercase') // -> 'HELLO'
```

### vm.$interpolate( templateString )

- **templateString** `String`

中括弧補間をもつテンプレートの文字列のかたまりを評価します。このメソッドは、単に文字列を挿入するだけであるということに気をつけてください。つまり、属性を持ったディレクティブはコンパイルされません。

``` js
// vm.msg = 'hello' を仮定
vm.$interpolate('{{msg}} world!') // -> 'hello world!'
```

### vm.$log( [keypath] )

- **keypath** `String` *任意*

現在のインスタンスを getter や setter よりもコンソールで検査しやすいプレーンオブジェクトとして記録します。オプションのキーも受けつけます。

``` js
vm.$log() // ViewModel のすべてのデータのログをとる
vm.$log('item') // logs vm.item
```

## イベント

> それぞれの vm はイベント発生装置でもあります。複数の入れ子になった ViewModels をもつとき、それら同士で通信をするイベントシステムを使うことができます。

### vm.$dispatch( event, [args...] )

- **event** `String`
- **args...** *任意*

イベントを、現在の vm から `$root` へ向かって全てに伝搬させます。もしコールバックが `false` を返した場合、親のインスタンスでの伝搬を停止します。

### vm.$broadcast( event, [args...] )

- **event** `String`
- **args...** *任意*

現在の vm のすべての子 vm に対してイベントを送り、すべての子に対して隅々まで伝搬させます。もしコールバックが `false` を返したら、その所有インスタンスはそれ以降イベントを広めません。

### vm.$emit( event, [args...] )

- **event** `String`
- **args...** *任意*

現在の vm 上でのみのイベントのきっかけとなります。

### vm.$on( event, callback )

- **event** `String`
- **callback** `Function`

現在の vm 上のイベントを監視します。

### vm.$once( event, callback )

- **event** `String`
- **callback** `Function`

一度きりのイベントリスナを提供します。

### vm.$off( [event, callback] )

- **event** `String` *任意*
- **callback** `Function` *任意*

もし引数が与えられなければ、すべてのイベントの監視を停止します。もしイベントがひとつだけ与えられたら、そのイベントに関するすべてのコールバックを削除します。もしイベントとコールバックの両方が与えられたら、その特定のコールバックのみを削除します。

## DOM

> すべての vm の DOM 生成メソッドは、vm の `$el` で何かしら宣言されている場合に Vue.js のトランジションのきっかけになることを除いては、jQuery と同じような動きをします。トランジションに関して、より詳しくは[トランジションシステム](/guide/transitions.html)を参照してください。

### vm.$appendTo( element|selector, [callback] )

- **element** `HTMLElement` | **selector** `String`
- **callback** `Function` *任意*

vmの `$el` を対象となる要素に付加します。引数は要素もしくは querySelector 文字列を受け入れます。

### vm.$before( element|selector, [callback] )

- **element** `HTMLElement` | **selector** `String`
- **callback** `Function` *任意*

ターゲット要素の前に、vm の `$el` を挿入します。

### vm.$after( element|selector, [callback] )

- **element** `HTMLElement` | **selector** `String`
- **callback** `Function` *任意*

ターゲット要素の後ろに、vm の `$el` を挿入します。

### vm.$remove( [callback] )

- **callback** `Function` *任意*

DOMから、vm の `$el` を削除します。

### vm.$nextTick( callback )

- **callback** `Function`

callback を延期し、DOM の更新サイクル後に実行されます。DOM の更新を待つ待ち受けるためにいくつかのデータを更新した直後に使用してください。これは、callback の `this` コンテキストは自動的にこのメソッドを呼び出すインスタンスにバインドされることを除いて、グローバルな `Vue.nextTick` と同じです。

## ライフサイクル

### vm.$mount( [element|selector] )

- **element** `HTMLElement` | **selector** `String` *任意*

もしインスタンス化の際に、Vue インスタンスが `el` オプションを受け取らなかった場合、マニュアルで `$mount(el)` を呼んでコンパイルフェーズを開始することができます。デフォルトでは、マウントされた要素はインスタンスのテンプレートで置き換えられます。`replace` オプションが `false` に設定される時、テンプレートはテンプレートに `<content>` アウトレットを含んでいるのに限らず、マウントされた要素に挿入、そして任意の存在する内部のコンテンツを置き換えます。

もし引数が何も与えられなかったら、テンプレートはドキュメント外の要素として作成されます。そしてあなた自身によってそれをドキュメントに挿入するために他の DOM インスタンスメソッドを使用しなければなりません。もし、`replace` オプションが `false` に設定される場合は、wrapper 要素として空の `<div>` が自動的に作られます。既に使用可能になった状態のインスタンスで `$mount()` を呼んでも、何も起きません。このメソッドはインスタンスそのものを返しますので、他のインスタンスメソッドをその後につなげることができます。

### vm.$destroy( [remove] )

- **remove** `Boolean` *任意*

vm を完全に破棄します。既存の他の vm との接続を切り、そのすべてのディレクティブとのバインドを解消し、DOMから `$el` を削除します。さらに、すべての `$on` や `$watch` リスナも自動的に削除されます。

### vm.$compile( element )

- **element** `HTMLElement`

DOM（要素や DocumentFragment）の一部を部分的にコンパイルします。メソッドは処理の中で作られたディレクティブを破壊する `decompile` 関数を返します。decompile 関数はDOMを削除しないことに注意してください。このメソッドは主に高度なカスタムディレクティブを書くためにあります。

### vm.$addChild( [options, constructor] )

- **options** `Object` *任意*
- **constructor** `Function` *任意*

現在のインスタンスに子インスタンスを追加します。options オブジェクトはマニュアルでインスタンスを作成したものと同じです。追加で、コンストラクタの中に `Vue.extend()` から作られたコンストラクタを渡せます。

あるインスタンス間の親子関係には、3つの意味合いがあります:

1. 親と子は[イベント](#イベント)を介して通信します。
2. 子はすべての親のアッセットにアクセス可能です（例えば、カスタムディレクティブなど）。
3. 子は、親のスコープを継承した場合は、親のスコープのデータプロパティにアクセスできます。
