---
title: メモリリークを回避する
type: cookbook
updated: 2018-05-14
order: 10
---

## はじめに

もしあなたが Vue でアプリケーションを構築しているとき、メモリリークに注意する必要があります。 この Issue はシングルページアプリケーション( SPA )を設計する際には特に重要で、SPA を使っているときユーザはブラウザをリフレッシュする必要はなく、コンポーネントをクリーンアップすることとガベージコレクションが期待通りに動作することを確認することは JavaScript アプリケーションの責務です。    

Vue アプリケーションのメモリリークは一般的に Vue 自体からは起こらず、むしろ他のライブラリをアプリケーションに組み込む際発生する可能性があります。

## かんたんな例

次の例のメモリリークは Vue コンポーネント上で [Choices.js](https://github.com/jshjohnson/Choices) ライブラリが原因で引き起こされていて正しく解放されません。それでは、どのようにして Choices.js のフットプリントを取り除くかメモリリークを回避するかを示します。

以下の例では、たくさんのオプションを持つ select をロードしてから [v-if](/v2/guide/conditional.html) ディレクティブを使用して show/hide ボタンを使って追加したり仮想 DOM から削除しています。この例での問題は `v-if` ディレクティブが DOM から親要素を取り除きますが、 Choices.js で生成された追加 DOM 部分をクリーンアップできずに、メモリリークを引き起こします。

```html
<link rel='stylesheet prefetch' href='https://joshuajohnson.co.uk/Choices/assets/styles/css/choices.min.css?version=3.0.3'>
<script src='https://joshuajohnson.co.uk/Choices/assets/scripts/dist/choices.min.js?version=3.0.3'></script>

<div id="app">
  <button
    v-if="showChoices"
    @click="hide"
  >Hide</button>
  <button
    v-if="!showChoices"
    @click="show"
  >Show</button>
  <div v-if="showChoices">
    <select id="choices-single-default"></select>
  </div>
</div>
```

```js
new Vue({
  el: "#app",
  data: function () {
    return {
      showChoices: true
    }
  },
  mounted: function () {
    this.initializeChoices()
  },
  methods: {
    initializeChoices: function () {
      let list = []
      // たくさんの choices を select へロードします
      // そのためたくさんのメモリを使用します
      for (let i = 0; i < 1000; i++) {
        list.push({
          label: "Item " + i,
          value: i
        })
      }
      new Choices("#choices-single-default", {
        searchEnabled: true,
        removeItemButton: true,
        choices: list
      })
    },
    show: function () {
      this.showChoices = true
      this.$nextTick(() => {
        this.initializeChoices()
      })
    },
    hide: function () {
      this.showChoices = false
    }
  }
})
```

このメモリリークを確認するためには、この [CodePen の例](https://codepen.io/freeman-g/pen/qobpxo) を Chrome で開き、そして Chrome タスクマネージャー を開きます。Chrome タスクマネージャーを Mac で開くためには、Chrome トップナビゲーション > ウィンドウ > タスクマネージャーを選択するか、 Windows の場合 Shift + ESC ショートカットを使用します。そして、 show/hide ボタンを50回またはそれ以上クリックしてください。Chrome タスクマネージャー上でメモリ使用量が増え、再利用されないことが確認できます。

![Memory Leak Example](/images/memory-leak-example.png)

## メモリリークを解決する

上記の例では、DOM から select を削除する前に、`hide()` メソッドを使っていくつかのクリーンアップとメモリリークの解決ができます。これを実現するためには、 Vue インスタンスのデータオブジェクトにプロパティを保持し、 [Choices API](https://github.com/jshjohnson/Choices)  の `destroy()` メソッドを使用してクリーンアップを実行します。

[この更新された CodePen の例](https://codepen.io/freeman-g/pen/mxWMor) でメモリ使用量を再び確認してください。

```js
new Vue({
  el: "#app",
  data: function () {
    return {
      showChoices: true,
      choicesSelect: null
    }
  },
  mounted: function () {
    this.initializeChoices()
  },
  methods: {
    initializeChoices: function () {
      let list = []
      for (let i = 0; i < 1000; i++) {
        list.push({
          label: "Item " + i,
          value: i
        })
      }
      // Vue インスタンスのデータオブジェクトの choicesSelect への参照を渡す
      this.choicesSelect = new Choices("#choices-single-default", {
        searchEnabled: true,
        removeItemButton: true,
        choices: list
      })
    },
    show: function () {
      this.showChoices = true
      this.$nextTick(() => {
        this.initializeChoices()
      })
    },
    hide: function () {
      // ここでクリーンアップを実行するために Choices のリファレンスを使用できます
      // DOM から要素を削除する前に
      this.choicesSelect.destroy()
      this.showChoices = false
    }
  }
})
```

## 価値の詳細

メモリ管理とパフォーマンステストはアプリケーションを素早くリリースする興奮のためかんたんに無視できますが、小さなメモリフットプリントを維持することは全体のユーザーエクスペリエンスにとって依然として重要です。

ユーザーが使用している可能性があるデバイスの種類と通常のフローを検討します。ユーザーはメモリが制約を受けたラップトップまたはモバイルデバイスを使用していますか？ユーザーは通常アプリケーション内をたくさん回遊していますか？これらのいずれかが当てはまる場合、良いメモリ管理方法はユーザーのブラウザをクラッシュさせる最悪のシナリオを回避させるのに役立つはずです。これらのいずれかにも当てはまらない場合でも、注意を払わなければあなたのアプリケーションの長時間の使用でパフォーマンスが低下する可能性があります。

## 実例

上記の例では、`v-if` ディレクティブを使用してメモリリークを説明しましたが、シングルページアプリケーションのコンポーネントに [vue-router](https://router.vuejs.org/ja/) を使用してルーティングする場合、より一般的で現実的なシナリオが発生します。

`v-if` ディレクティブのように、`vue-router` は仮想 DOM から要素を削除しユーザーがアプリケーションを回遊するときにそれらを新しい要素で置き換えます。Vue `beforeDestroy()` [ライフサイクルフック](/v2/guide/instance.html#Lifecycle-Diagram)は `vue-router` ベースで構築されているアプリケーションの同じ種類の課題を解決することに適しています。

このように `beforeDestroy()` フックにクリーンアップを移すことができます:

```js
beforeDestroy: function () {
    this.choicesSelect.destroy()
}
```

## 代替パターン

要素を削除するときにメモリ管理について説明しましたが、意図的に状態を保存しつつメモリ内の要素を保持したい場合はどうすればよいでしょうか？　このケースでは、[keep-alive](/v2/api/#keep-alive) をコンポーネントへ組み込むことで実現できます。

`keep-alive` でコンポーネントをラップすると、その状態は保持され、それによってメモリも保持されます。

```html
<button @click="show = false">Hide</button>
<keep-alive>
  <!-- my-component は意図的に削除されてもメモリに保持されます -->
  <my-component v-if="show"></my-component>
</keep-alive>
```
このテクニックはユーザーエクスペリエンスを改善するのに役立ちます。たとえば、ユーザーがテキスト入力欄にコメントを入力したあと回遊することを決めたとします。もしそのユーザーが戻ってきたときも、そのコメントは保持されたままです。

keep-alive を使用すると、2つのライフサイクルフックにアクセスすることができます: `activated` と `deactivated` です。 keep-alive コンポーネントが削除されたときデータをクリーンアップまたは変更する場合は、`deactivated` フックで行えます。

```js
deactivated: function () {
  // 保持したくない任意のデータを削除する
}
```

## おわりに

Vue では驚くほどかんたんにリアクティブな JavaScript アプリケーションが開発できますが、メモリリークについては注意を払う必要があります。これらのメモリリークは Vue 以外の DOM を扱う追加されたサードパーティーライブラリを使用するときよく発生します。アプリケーションでメモリリークが発生していないかテストし、必要に応じてコンポーネントをクリーンアップするための適切な処置を実行してください。
