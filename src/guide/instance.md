---
title: Vue インスタンス
type: guide
order: 3
---

## コンストラクタ

全ての Vue vm は、`Vue` コンストラクタ関数で**ルート Vue インスタンス(root Vue instance)**を作成することによって起動されます:

``` js
var vm = new Vue({
  // オプション
})
```

厳密な定義とは異なりますが、Vue のデザインは、[MVVM パターン](https://en.wikipedia.org/wiki/Model_View_ViewModel)の影響を確かに受けています。
慣例として、よく `vm` (ViewModel の略) を Vue インスタンスの変数名として、よく利用します。

Vue インスタンスを生成するには、**オプションオブジェクト**を渡す必要があります。これには、データ、テンプレート、マウントさせる要素、メソッド、ライフサイクルコールバックなどをオプションとして指定することができます。全てのオプションの一覧は[API リファレンス](/api)で参照できます。

`Vue` コンストラクタは、あらかじめ定義されたオプションを伴った再利用可能な**コンポーネントコンストラクタ**を生成するために拡張できます:

``` js
var MyComponent = Vue.extend({
  // 拡張オプション
})

// `MyComponent` から生成された全てのインスタンスは、あらかじめ定義された拡張オプションを利用して生成されます
var myComponentInstance = new MyComponent()
```

プログラムから命令的に拡張されたインスタンスを生成できますが、ほとんどの場合は、カスタムエレメントとしてテンプレートに宣言的に組み立てることをおすすめします。後ほど [コンポーネントシステム](components.html) で詳細を説明します。
いまは、全ての Vue コンポーネントは、本質的に Vue インスタンスを拡張したと理解しておけば十分です。

## プロパティとメソッド

Vue インスタンスは、自身の `data` オブジェクトの全てのプロパティを**プロキシ**します:

``` js
var data = { a: 1 }
var vm = new Vue({
  data: data
})

vm.a === data.a // -> true

// プロパティへの代入は、元のデータにも反映されます
vm.a = 2
data.a // -> 2

// ... そして、その逆もまたしかりです
data.a = 3
vm.a // -> 3
```

これらのプロキシされたプロパティだけが**リアクティブ**なことに注意しましょう。もし、インスタンスを生成した後にインスタンスに新しいプロパティを追加した場合には、ビューの更新は起こりません。後ほど、リアクティブシステムの章で詳細を説明します。

data プロパティに加えて、Vue インスタンスは、いくつかの便利なプロパティとメソッドを持っています。

``` js
var data = { a: 1 }
var vm = new Vue({
  el: '#example',
  data: data
})

vm.$data === data // -> true
vm.$el === document.getElementById('example') // -> true

// $watch はインスタンスメソッドです
vm.$watch('a', function (newVal, oldVal) {
  // このコールバックは `vm.a` の値が変わる時に呼ばれます
})
```

<p class="tip">Note that __you should not use arrow functions on an instance property or callback__ (e.g. `vm.$watch('a', newVal => this.myMethod())`). The reason is arrow functions bind the parent context, so `this` will not be the Vue instance as you expect and `this.myMethod` will be undefined.</p>

インスタンスの全てのプロパティとメソッドのリストは、 [API referene](/api) を参照してください。

## インスタンスライフサイクルフック

各 Vue インスタンスは、生成時に一連の初期化を行います。例えば、データの監視のセットアップやテンプレートのコンパイル、DOM へのインスタンスのマウント、データが変化したときの DOM の更新などがあります。
その初期化の過程で、カスタムロジックの実行を可能にする、いくつかの **ライフサイクルフック(lifecycle hooks)** を呼び出します。
例えば、`created` フックはインスタンスが生成された後に呼ばれます。

``` js
var vm = new Vue({
  data: {
    a: 1
  },
  created: function () {
    // `this` は vm インスタンスを指します
    console.log('a is: ' + this.a)
  }
})
// -> "a is: 1"
```

この他にもインスタンスのライフサイクルの様々な段階で呼ばれるフックがあります。例えば、`mounted`, `updated`, `destroyed` があります。
全てのライフサイクル フックは、`this` が Vue インスタンスを指す形で実行さます。
Vue の世界における "コントローラ" の概念について知りたい方もいるかもしれません。その答えとしては「コントローラはない」です。
コンポーネントのためのカスタムロジックは、これらのライフサイクルフックの中に分割されることになります。

## ライフサイクルダイアグラム

以下は、インスタンスライフサイクルのダイアグラムです。
今はこのダイアグラムを完全に理解する必要はありませんが、将来役に立つことでしょう。

![Lifecycle](/images/lifecycle.png)
