---
title: リアクティブの探求
updated: 2019-05-08
type: guide
order: 601
---

さらに深く見ていきましょう！Vue の最大の特徴の1つは、控えめなリアクティブシステムです。モデルは単なるプレーンな JavaScript オブジェクトです。それらを変更するとビューが更新されます。これは状態管理を非常にシンプルかつ直感的にしますが、よくある問題を避けるためにその仕組みを理解することも重要です。このセクションでは、Vue のリアクティブシステムの低レベルの詳細の一部について掘り下げていきます。

<div class="vue-mastery"><a href="https://www.vuemastery.com/courses/advanced-components/build-a-reactivity-system" target="_blank" rel="sponsored noopener" title="Vue Reactivity">Vue Masteryで動画の説明を見る</a></div>

## 変更の追跡方法

プレーンな JavaScript オブジェクトを `data` オプションとして Vue インスタンスに渡すとき、Vue はその全てのプロパティを渡り歩いて、それらを [`Object.defineProperty`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty) を使用して getter/setter に変換します。これは ES5 だけの、シム (shim) ができない機能で、Vue が IE8 以下をサポートしないのはこのためです。

[getter/setter](https://developer.mozilla.org/ja/docs/Web/JavaScript/Guide/Working_with_Objects#Defining_getters_and_setters) はユーザーには見えませんが、内部では、Vue が依存性を追跡したり、プロパティがアクセスまたは変更されたときに変更を通知したりすることを可能にしています。ひとつ注意点を挙げると、変換されたデータオブジェクトをログ出力するとき、各ブラウザコンソールで getter/setter のフォーマットが異なるため、より調査に適したインターフェイスの [vue-devtools](https://github.com/vuejs/vue-devtools) をインストールしたほうがいいかもしれません。

全てのコンポーネントインスタンスは対応する **ウォッチャ (watcher)** インスタンスを持っていて、これはコンポーネントを描画する間に "触れた (touched)" プロパティを全て依存性として記録しています。その後、依存性の setter がトリガされると、ウォッチャに通知してコンポーネントの再描画が起動します。

![Reactivity Cycle](/images/data.png)

## 変更検出の注意事項

JavaScript の制限のため、Vue は、**検出することができない**変更のタイプがあります。しかし、それらを回避しリアクティビティを維持する方法はあります。

### オブジェクトに関して

Vue はプロパティの追加または削除を検出できません。Vue はインスタンスの初期化中に getter/setter の変換を行うため、全てのプロパティは Vue が変換してリアクティブにできるように `data` オブジェクトに存在しなけれ
ばなりません。例えば:


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

Vue では、すでに作成されたインスタンスに対して新しいルートレベルのリアクティブなプロパティを動的に追加することはできません。しかしながら、`Vue.set(object, propertyName, value)` メソッドを使ってネストしたオブジェクトにリアクティブなプロパティを追加することができます:

``` js
Vue.set(vm.someObject, 'b', 2)
```

`vm.$set` インスタンスメソッドを使用することもできます。これはグローバルの `Vue.set` のエイリアスです:

``` js
this.$set(this.someObject, 'b', 2)
```

既存のオブジェクトに複数のプロパティを割り当てたいということがあるかもしれません。例えば、`Object.assign()` や `_.extend()` を使って。しかし、オブジェクトに追加された新しいプロパティは変更をトリガしません。このような場合は、元のオブジェクトとミックスインオブジェクトの両方のプロパティを持つ新たなオブジェクトを作成してください:

``` js
// `Object.assign(this.someObject, { a: 1, b: 2 })` の代わり
this.someObject = Object.assign({}, this.someObject, { a: 1, b: 2 })
```

### 配列に関して

Vue は一つの配列における次の変更は検知できません:

1. インデックスと一緒にアイテムを直接セットする場合、例えば `vm.items[indexOfItem] = newValue`
2. 配列の長さを変更する場合、例えば `vm.items.length = newLength`

例えば:

``` js
var vm = new Vue({
  data: {
    items: ['a', 'b', 'c']
  }
})
vm.items[1] = 'x' // is NOT reactive
vm.items.length = 2 // is NOT reactive
```

注意事項 1 を克服するに、次のいずれも `vm.items[indexOfItem] = newValue` と同様に機能しますが、リアクティビティシステムで状態の更新をトリガーします:

``` js
// Vue.set
Vue.set(vm.items, indexOfItem, newValue)
```
``` js
// Array.prototype.splice
vm.items.splice(indexOfItem, 1, newValue)
```

また、[`vm.$set`](https://vuejs.org/v2/api/#vm-set) インスタンスメソッドを使うこともできます。これはグローバルな `Vue.set` のエイリアスです:

``` js
vm.$set(vm.items, indexOfItem, newValue)
```

注意事項 2 に対応するには、`splice` を使うことができます。

``` js
vm.items.splice(newLength)
```

## リアクティブプロパティの宣言

Vue では新しいルートレベルのリアクティブなプロパティを動的に追加することはできないため、インスタンスの初期化時に前もって全てのルートレベルのリアクティブな data プロパティを宣言する必要があります。空の値でもかまいません:

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

この制限の背後には技術的な理由があります。それは依存性追跡システムにおける一連のエッジケースを排除し、また Vue インスタンスと型チェックシステムとの親和性を高めます。しかしコードの保守性の観点からも重要な事項があります。`data` オブジェクトはコンポーネントの状態のスキーマのようなものです。前もって全てのリアクティブなプロパティを宣言しておくと、後から見直したり別の開発者が読んだりしたときにコンポーネントのコードを簡単に理解することができます。

## 非同期更新キュー

おそらく既にお気づきでしょうが、Vue は **非同期** に DOM 更新を実行します。データ変更が検出されると、Vue はキューをオープンし、同じイベントループで起こる全てのデータ変更をバッファリングします。同じウォッチャが複数回トリガされる場合、キューには一度だけ入ります。この重複除外バッファリングは不要な計算や DOM 操作を回避する上で重要です。そして、次のイベントループ "tick" で、Vue はキューをフラッシュし、実際の(すでに重複が除外された)作業を実行します。内部的には、Vue は非同期キューイング向けにネイティブな `Promise.then` と `MutationObserver`、`setImmediate` が利用可能ならそれを使い、`setTimeout(fn, 0)` にフォールバックします。

例として、`vm.someData = 'new value'` をセットした時、そのコンポーネントはすぐには再描画しません。 次の "tick" でキューがフラッシュされる時に更新します。ほとんどの場合、私達はこれについて気にする必要はありませんが、更新した DOM の状態に依存する何かをしたい時は注意が必要です。Vue.js は一般的に"データ駆動"的な流儀で考え、DOM を直接触るのを避けることを開発者に奨励しますが、時にはその手を汚す必要があるかもしれません。データの変更後に Vue.js の DOM 更新の完了を待つには、データが変更された直後に `Vue.nextTick(callback)` を使用することができます。そのコールバックは DOM が更新された後に呼ばれます。例えば:

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

`vm.$nextTick()` というインスタンスメソッドもあります。これは、グローバルな Vue を必要とせず、コールバックの `this` コンテキストが自動的に現在の Vue インスタンスに束縛されるため、コンポーネント内で特に役立ちます:

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

`$nextTick()` は Promise を返却するため、新しい [ES2017 async/await](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Statements/async_function) 構文を用いて、同じことができます:

``` js
  methods: {
    updateMessage: async function () {
      this.message = 'updated'
      console.log(this.$el.textContent) // => 'not updated'
      await this.$nextTick()
      console.log(this.$el.textContent) // => 'updated'
    }
  }
```
