title: インスタンスメソッド
type: api
order: 4
---

## データ

> Vueインスタンスでは、データの変更を監視することができます。すべてのwatchコールバックは非同期に発火することに注意してください。さらに、値の変更はイベントループの中でバッチ処理されます。これは、ひとつのイベントループの中で値が何度も変更された時に、コールバックは最新の値に対して一度しか発火しないことを意味します。

### vm.$watch( expression, callback, [deep, immediate] )

- **expression** `String`
- **callback( newValue, oldValue )** `Function`
- **deep** `Boolean` *optional*
- **immdediate** `Boolean` *optional*

Vueインスタンス上でのひとつの式の変更を監視します。引数 expression には、単一の keypath か、実際の式を入れることができます:

``` js
vm.$watch('a + b', function (newVal, oldVal) {
  // do something
})
```

オブジェクトの中のネストされた値の変更を検出するには、3つめの引数 `deep` に `true` を渡す必要があります。Array の値変更に対しては、こうする必要はないことに注意してください。

``` js
vm.$watch('someObject', callback, true)
vm.someObject.nestedValue = 123
// callback is fired
```

4つめの引数 `immediate` に `true` を渡すと、その時の式の値で、コールバックがただちに実行されます:

``` js
vm.$watch('a', callback, false, true)
// その時の `a` の値でコールバックがただちに発火します
```

最後に、`vm.$watch` はコールバックの実行を停止する unwatch 関数を返します。

``` js
var unwatch = vm.$watch('a', cb)
// later, teardown the watcher
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

Vue インスタンス（とその `$data` ）に root レベルのプロパティを追加します。ES5の制約により、Vue はオブジェクトから追加されたり削除されたりしたプロパティを直接特定することができません。そのため、追加や削除が必要な場合は、このメソッドや `vm.$delete` を使用する必要があります。さらに、すべての監視されたオブジェクトも、これら2つのメソッドと同じように増加していきます。

### vm.$delete( keypath )

- **keypath** `String`

Vue インスタンス（それと、その `$data`）のルートレベルのプロパティを削除します。

### vm.$eval( expression )

- **expression** `String`

フィルタも含むことができるような式を評価します。

``` js
// assuming vm.msg = 'hello'
vm.$eval('msg | uppercase') // -> 'HELLO'
```

### vm.$interpolate( templateString )

- **templateString** `String`

中括弧補間をもつテンプレートの文字列のかたまりを評価します。このメソッドは、単に文字列を挿入するだけであるということに気をつけてください。つまり、属性ディレクティブはコンパイルされません。

``` js
// assuming vm.msg = 'hello'
vm.$interpolate('{{msg}} world!') // -> 'hello world!'
```

### vm.$log( [keypath] )

- **keypath** `String` *optional*

現在のインスタンスを getter や setter よりもコンソールで検査しやすいプレーンオブジェクトとして記録します。オプションのキーも受けつけます。

``` js
vm.$log() // logs entire ViewModel data
vm.$log('item') // logs vm.item
```

## Events

> それぞれの vm はイベント発生装置でもあります。複数の入れ子になった ViewModels をもつとき、それら同士で通信をするイベントシステムを使うことができます。

### vm.$dispatch( event, [args...] )

- **event** `String`
- **args...** *optional*

イベントを、現在のvmから `$root` へ向かって全てに伝搬させます。もしコールバックが `false` を返した場合、親のインスタンスでの伝搬を停止します。

### vm.$broadcast( event, [args...] )

- **event** `String`
- **args...** *optional*

現在の vm のすべての子vmに対してイベントを送り、すべての子に対して隅々まで伝搬させます。もしコールバックが `false` を返したら、その所有インスタンスはそれ以降イベントを広めません。

### vm.$emit( event, [args...] )

- **event** `String`
- **args...** *optional*

現在の vm 上でのみのイベントのきっかけとなります。

### vm.$on( event, callback )

- **event** `String`
- **callback** `Function`

現在の vm 上のイベントを監視します。

### vm.$once( event, callback )

- **event** `String`
- **callback** `Function`

一度きりのイベントリスナーを提供します。

### vm.$off( [event, callback] )

- **event** `String` *optional*
- **callback** `Function` *optional*

もし引数が与えられなければ、すべてのイベントの監視を停止します。もしイベントがひとつだけ与えられたら、そのイベントに関するすべてのコールバックを削除します。もしイベントとコールバックの両方が与えられたら、その特定のコールバックのみを削除します。

## DOM

> すべての vm の DOM 生成メソッドは、vm の `$el` で何かしら宣言されている場合に Vue.js の表示変換のきっかけになることを除いては、jQuery と同じような動きをします。表示変換に関して、より詳しくは[表示変換のエフェクトを追加する](/guide/transitions.html)を参照していただきたい。

### vm.$appendTo( element|selector, [callback] )

- **element** `HTMLElement` | **selector** `String`
- **callback** `Function` *optional*

vmの `$el` を対象となる要素に付加します。引数は要素もしくは querySelector 文字列を受け入れます。

### vm.$before( element|selector, [callback] )

- **element** `HTMLElement` | **selector** `String`
- **callback** `Function` *optional*

ターゲット要素の前に、vmの `$el` を挿入します。

### vm.$after( element|selector, [callback] )

- **element** `HTMLElement` | **selector** `String`
- **callback** `Function` *optional*

ターゲット要素の後ろに、vmの `$el` を挿入します。

### vm.$remove( [callback] )

- **callback** `Function` *optional*

DOMから、vmの `$el` を削除します。

## Lifecycle

### vm.$mount( [element|selector] )

- **element** `HTMLElement` | **selector** `String` *optional*

もしインスタンス化の際に、Vue インスタンスが `el` オプションを受け取らなかった場合、マニュアルで `$mount()` を読んである要素をそこに割り当て、コンパイルを開始することができます。もし引数が何も与えられなかったら、空の `<div>` が自動的に作られます。既に使用可能になった状態のインスタンスで `$mount()` を呼んでも、何も起きません。このメソッドはインスタンスそのものを返しますので、他のインスタンスメソッドをその後につなげることができます。

### vm.$destroy( [remove] )

- **remove** `Boolean` *optional*

vm を完全に破棄します。既存の他の vm との接続を切り、そのすべてのディレクティブとのバインドを解消し、DOMから `$el` を削除します。さらに、すべての `$on` や `$watch` リスナーも自動的に削除されます。

### vm.$compile( element )

- **element** `HTMLElement`

DOM（要素や DocumentFragment）の一部を部分的にコンパイルします。メソッドは処理の中で作られたディレクティブを破壊する `decompile` 関数を返します。decompile 関数はDOMを削除しないことに注意してください。このメソッドは主に高度なカスタムディレクティブを書くためにあります。

### vm.$addChild( [options, constructor] )

- **options** `Object` *optional*
- **constructor** `Function` *optional*

現在のインスタンスに子インスタンスを追加します。options オブジェクトはマニュアルでインスタンスを作成したものと同じです。追加で、コンストラクタの中に `Vue.extend()` から作られたコンストラクタを渡せます。

あるインスタンス間の親子関係には、3つの意味合いがあります:

1. 親と子は[イベントシステム](#Events)を介して通信します。
2. 子はすべての親の資産にアクセス可能です（例えば、カスタムディレクティブなど）。
3. 子は、親のスコープを継承した場合は、親のスコープのデータプロパティにアクセスできます。