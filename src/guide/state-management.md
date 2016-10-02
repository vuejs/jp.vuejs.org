---
title: 状態管理
type: guide
order: 21
---

## 公式 Flux ライクな実装

大規模なアプリケーションは、多くの状態が色々なコンポーネントに散らばったり、コンポーネント間の相互作用のために複雑になりがちです。この問題を解消するために、 Vue は [vuex](https://github.com/vuejs/vuex)を提供します。これは Elm にインスパイアされた状態管理ライブラリで、特別なセットアップなしで時間を巻き戻せる [vue-devtools](https://github.com/vuejs/vue-devtools) とも連携します。

### React 開発者への情報

もしあなたが React のエコシステムから来たのなら、最も人気のある Flux 実装の [redux](https://github.com/reactjs/redux) と vuex がどう比較されるか気になっていることでしょう。Redux は実際に view レイヤの知識を持たないので、[シンプルなバインディング](https://github.com/egoist/revue) を通して簡単に Vue とあわせて利用することができます。Vuex は、 自らが Vue のアプリケーション内にいることを**知っている**、という点で異なります。これにより Vue といっそう良く連携することができ、より直感的な API を提供したり、開発体験を向上させることができます。

## シンプルな状態管理をゼロから作る

Vue アプリケーションの妥当性を担保しているのが生の `data` オブジェクトだということは見過ごされがちです。Vue インスタンスは単純に `data` オブジェクトへのアクセスをプロキシします。それゆえに、複数のインスタンスによって共有されうる状態がある場合、シンプルに同一の状態を共有することができます:

``` js
const sourceOfTruth = {}

const vmA = new Vue({
  data: sourceOfTruth
})

const vmB = new Vue({
  data: sourceOfTruth
})
```

こうすれば、`sourceOfTruth` が変化するたびに、`vmA` と `vmB` の両方が自動的にそれぞれの view を更新します。これらのインスタンス内のサブコンポーネントから `this.$root.$data` を通じてアクセスすることもできます。ただ1つの情報源を持つことにはなりましたが、このままだとデバッグは悪夢になるでしょう。どんなデータでも、アプリケーションのどこからでも痕跡を残すことなく変えることができてしまいます。

単純な **store パターン** を適用することで、この問題を解決することができます:

``` js
var store = {
  debug: true,
  state: {
    message: 'Hello!'
  },
  setMessageAction (newValue) {
    this.debug && console.log('setMessageAction triggered with', newValue)
    this.state.message = newValue
  },
  clearMessageAction () {
    this.debug && console.log('clearMessageAction triggered')
    this.state.message = 'action B triggered'
  }
}
```

Store の状態を変える action はすべて store 自身の中にあることに注意してください。このように状態管理を中央集権的にすることで、どういった種類の状態変化が起こりうるか、あるいはそれがどうやってトリガされているか、が分かりやすくなります。これなら何か良くないことが起きても、バグが起きるに至ったまでのログを見ることもできます。

さらに、それぞれのインスタンスやコンポーネントに、プライベートな状態を持たせ管理することも可能です:

``` js
var vmA = new Vue({
  data: {
    privateState: {},
    sharedState: store.state
  }
})

var vmB = new Vue({
  data: {
    privateState: {},
    sharedState: store.state
  }
})
```

![State Management](/images/state.png)

<p class="tip">action によって元の状態を決して置き換えてはいけないことに注意してください。状態変化が監視され続けるためには、コンポーネントと store が同じオブジェクトへの参照を共有している必要があるからです。</p>

コンポーネントが store が持つ状態を直接変えることは許さず、代わりにコンポーネントは store に通知するイベントを送り出しアクションを実行する、という規約を発展させていくに従って、私たちは最後には [Flux](https://facebook.github.io/flux/) アーキテクチャに辿り着きました。この規約によって、store に起こるすべての状態変化を記録することができたり、変更ログやスナップショット、履歴や時間を巻き戻す、といった高度なデバッギングヘルパーの実装などの利点をもたらします。

ここまで来ると一周まわって [vuex](https://github.com/vuejs/vuex) に戻ってきました。ここまで読み進めてきたなら、vuex も試してみましょう！
