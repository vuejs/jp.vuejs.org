---
title: リアクティブの探求
type: guide
order: 12
---

私達は基本のほとんどをカバーしてきました。これからは深いダイビングをするための時間です！Vue の最も明確な特徴の1つは、控えめなリアクティブシステムです。モデルは単なるプレーンな JavaScript オブジェクトです。それらを変更する時、View を更新します。状態管理を非常にシンプルかつ直感的にしますが、いくつかの一般的な落とし穴を避けるためにそれがどのように動作するか理解することも重要です。このセクションで、Vue のリアクティブシステムの低レベルの詳細の一部について掘り下げていきます。

## 変更の追跡方法

プレーンな JavaScript オブジェクトを `data` オプションとして Vue インスタンスに渡すとき、Vue.js はその全てのプロパティを渡り歩いて、それらを [Object.defineProperty](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty) を使用して、getter/setter に変換します。これは ES5 だけのシム (shim) ができない機能で、Vue.js が IE8 以下をサポートしない理由です。

getter/setter はユーザーには見えませんが、内部ではそれらは Vue.js で依存関係の追跡を実行したり、プロパティがアクセスされたまたは変更されたときは、変更通知します。注意事項の1つは、データオブジェクトが記録されたとき、getter/setter のブラウザコンソールのフォーマットが異なるので、よりフレンドリな閲覧インターフェイスのため、[vue-devtools](https://github.com/vuejs/vue-devtools) をインストールするといいでしょう。

全てのコンポーネントインターフェイスは対応している **ウオッチャ (watcher)** インターフェイスを持っていて、そのインターフェイスは "触れた (touched)" 全てのプロパティをコンポーネントの依存関係として描画されている間、記録します。その後、依存する setter がトリガされる時、ウォッチャに通知され、コンポーネントが再描画する結果につながります。

![Reactivity Cycle](/images/data.png)

## 変更検出の注意事項

モダンな JavaScript の制限(そして `Object.observe` の断念)のため、Vue.js は**プロパティの追加または削除を検出できません**。Vue.js はインスタンスの初期化中に、getter/setter 変換処理を実行するため、プロパティは、Vue がそれを変換しそしてそれをリアクティブにするために、`data` オブジェクトに存在しなければなりません。例えば:

``` js
var vm = new Vue({
  data: {
    a: 1
  }
})
// `vm.a` は今リアクティブです

vm.b = 2
// `vm.b` はリアクティブでは"ありません"
```

Vue はすでに作成されたインスタンスに対して動的に新しいルートレベルのリアクティブなプロパティを追加することはできません。しかしながら `Vue.set(object, key, value)` メソッドを使うことで、ネストしたオブジェクトにリアクティブなプロパティを追加することができます:

``` js
Vue.set(vm.someObject, 'b', 2)
```

グローバル `Vue.set` の単なるエイリアスとなっている `vm.$set` インスタンスメソッドを使用することもできます:

``` js
this.$set(this.someObject, 'b', 2)
```

既存のオブジェクトに複数のプロパティを割り当てたいということがあるかもしれません。例えば、`Object.assign()` または `_.extend()` を使用しながら。しかしながら、新しいプロパティをオブジェクトに追加したとき、トリガーは変更しません。このような場合、元のオブジェクトとミックスインオブジェクトの両方のプロパティを持つ新たなオブジェクトを作成します:

``` js
// `Object.assign(this.someObject, { a: 1, b: 2 })` の代わり
this.someObject = Object.assign({}, this.someObject, { a: 1, b: 2 })
```

[以前に リストレンダリング のセクションで議論した](list.html#注意事項) いくつかの配列に関連した注意事項があります。

## リアクティブプロパティの宣言

Vue は動的に新しいルートレベルのリアクティブなプロパティを追加することはできませんので、前もってインスタンス全てのルートレベルのリアクティブな data を宣言して初期化する必要があります。空の値でもかまいません:

``` js
var vm = new Vue({
  data: {
    // 空の値として message を宣言する
    message: ''
  },
  template: '<div>{{ message }}</div>'
})
// 後で、`message` を追加する
vm.message = 'Hello!'
```

data オプションで `message` を宣言していないと、Vue は render ファンクションが存在しないプロパティにアクセスしようとしていることを警告します。

この制限の背後には技術的な理由があります。それは依存性追跡システムにおけるエッジケースのクラスを排除し、 また Vue インスタンスと型チェックシステムとの親和性を高めます。しかし重要な考慮事項はコードの保守性にあります。`data` オブジェクトはコンポーネント状態のスキーマのようなものです。前もって全てのリアクティブなプロパティを宣言することで、後から見直したり別の開発者が読んだりしたときにコンポーネントのコードを簡単に理解することができます。

## 非同期更新キュー

もしあなたがまだ気づいていない場合、Vue は **非同期** に DOM 更新を実行します。データ変更が監視されている限り、Vue はキューをオープンし、同じイベントループで起こる全てのデータ変更をバッファリングします。同じウオッチャが複数回トリガされる場合、一度だけキューに押し込まれます。この重複除外バッファリングは不要な計算や DOM 操作を回避する上で重要です。そして、次のイベントループの "tick" で、Vue はキューをフラッシュし、実際の(すでに重複が除外された)作業を実行します。内部的には、Vue はもし非同期キューイング向けにネイティブな `Promise.then` そして `MutationObserver` が利用可能ならそれを使い、`setTimeout(fn, 0)` にフォールバックします。

例として、`vm.someData = 'new value'` をセットした時、そのコンポーネントはすぐに再描画しません。 キューがフラッシュされた時、次の "tick" で更新します。ほとんどの場合、私達はこれについて気にする必要はありませんが、更新した DOM の状態に依存する何かをしたい時、注意が必要です。Vue.js は一般的に"データ駆動"的な流儀で考えることを開発者に奨励していますが、時どき、それはあなたの手を汚す必要があるかもしれません。Vue.js でデータの変更後に、DOM の更新が完了するまでに待つためには、データが変更された直後に `Vue.nextTick(callback)` を使用することができます。コールバックが呼ばれた時、DOM は更新されているでしょう。例えば:

``` html
<div id="example">{{ message }}</div>
```

``` js
var vm = new Vue({
  el: '#example',
  data: {
    message: '123'
  }
})
vm.message = 'new message' // データを変更する
vm.$el.textContent === 'new message' // false
Vue.nextTick(function () {
  vm.$el.textContent === 'new message' // true
})
```

特に便利な内部コンポーネントのインスタンスメソッド `vm.$nextTick()` もあります。なぜなら、それはグローバルな `Vue` とそのコールバックの `this` コンテキストは自動的に現在の Vue インスタンスに束縛されるからです:

``` js
Vue.component('example', {
  template: '<span>{{ message }}</span>',
  data: function () {
    return {
      message: 'not updated'
    }
  },
  methods: {
    updateMessage: function () {
      this.message = 'updated'
      console.log(this.$el.textContent) // => 'not updated'
      this.$nextTick(function () {
        console.log(this.$el.textContent) // => 'updated'
      })
    }
  }
})
```
