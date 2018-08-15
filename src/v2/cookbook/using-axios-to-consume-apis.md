---
title: axios を利用した API の使用
type: cookbook
updated: 2018-03-20
order: 9
---


## 基本的な例

ウェブアプリケーションを構築するとき、 API からデータを取得して表示することがよくあります。これを行うにはいくつかの方法があり、一般的なアプローチは Promise ベースの HTTP クライアントの [axios](https://github.com/axios/axios) を使うことです。

この例題では、 [CoinDesk API](https://www.coindesk.com/api/) を利用して Bitcoin の価格を表示し、毎分更新します。最初に、 npm か yarn もしくは CDN リンクのいずれかを利用して axios をインストールします。

API から情報を取得する方法はいくつかありますが、表示する内容を知るために、まずデータ形式がどうなっているかを調べることをオススメします。 API エンドポイントを呼び出して出力をすることでデータ形式がどうなっているか調べられます。 CoinDesk API ドキュメントをみると、 https://api.coindesk.com/v1/bpi/currentprice.json を呼べばいいことがわかります。まず初めに、 data プロパティを作成し、 `mounted` ライフサイクルフックを使用し、データを取得し最終的に情報を格納します。

```js
new Vue({
  el: '#app',
  data () {
    return {
      info: null
    }
  },
  mounted () {
    axios
      .get('https://api.coindesk.com/v1/bpi/currentprice.json')
      .then(response => (this.info = response))
  }
})
```

```html
<div id="app">
  {{ info }}
</div>
```

これが得られます。

<p data-height="350" data-theme-id="32763" data-slug-hash="80043dfdb7b90f138f5585ade1a5286f" data-default-tab="result" data-user="Vue" data-embed-version="2" data-pen-title="First Step Axios and Vue" class="codepen">See the Pen <a href="https://codepen.io/team/Vue/pen/80043dfdb7b90f138f5585ade1a5286f/">First Step Axios and Vue</a> by Vue (<a href="https://codepen.io/Vue">@Vue</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

素晴らしい！私たちは様々なデータを持っています。しかし、今は乱雑だと思われるので、適切に表示して、期待通りに動作しない場合や、情報を取得するのに時間がかかる場合に備えて、エラー処理を追加してみましょう。

## 実例: データの操作

### API から取得したデータを表示

典型的には私たちが必要とする情報はレスポンスの中にあり、適切にアクセスするには今取得したレスポンスを辿る必要があります。このケースでは、求めている価格情報が `response.data.bpi` にあることがわかります。代わりにこれを使用すると、出力は次のようになります。

```js
axios
  .get('https://api.coindesk.com/v1/bpi/currentprice.json')
  .then(response => (this.info = response.data.bpi))
```

<p data-height="200" data-theme-id="32763" data-slug-hash="6100b10f1b4ac2961208643560ba7d11" data-default-tab="result" data-user="Vue" data-embed-version="2" data-pen-title="Second Step Axios and Vue" class="codepen">See the Pen <a href="https://codepen.io/team/Vue/pen/6100b10f1b4ac2961208643560ba7d11/">Second Step Axios and Vue</a> by Vue (<a href="https://codepen.io/Vue">@Vue</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

表示するのがはるかに簡単になったので、受信したデータから必要な情報だけを表示するように HTML を更新できるようになりました。[filter](../api/#Vue-filter) を使用して小数点が適切な場所にあるかどうか確かめます。

```html
<div id="app">
  <h1>Bitcoin Price Index</h1>
  <div
    v-for="currency in info"
    class="currency"
  >
    {{ currency.description }}:
    <span class="lighten">
      <span v-html="currency.symbol"></span>{{ currency.rate_float | currencydecimal }}
    </span>
  </div>
</div>
```

```js
filters: {
  currencydecimal (value) {
    return value.toFixed(2)
  }
},
```

<p data-height="300" data-theme-id="32763" data-slug-hash="9d59319c09eaccfaf35d9e9f11990f0f" data-default-tab="result" data-user="Vue" data-embed-version="2" data-pen-title="Third Step Axios and Vue" class="codepen">See the Pen <a href="https://codepen.io/team/Vue/pen/9d59319c09eaccfaf35d9e9f11990f0f/">Third Step Axios and Vue</a> by Vue (<a href="https://codepen.io/Vue">@Vue</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

### エラー処理

API から必要なデータを取得できないことがあります。 axios のコールが失敗する理由がいくつかあり、次のものがありますが全てではありません。

* API がダウンしている。
* リクエストが間違っている。
* API は予期した形式で情報を渡さなかった。

API リクエストをする際は、そのような状況を確認し、全てのケースで情報を渡す必要があります。それにより問題の取扱い方が分かります。 axios コールでは、 `catch` を使用して呼び出します。

```js
axios
  .get('https://api.coindesk.com/v1/bpi/currentprice.json')
  .then(response => (this.info = response.data.bpi))
  .catch(error => console.log(error))
```

これにより API リクエスト中に何かが失敗した場合知ることができますが、データが壊れた場合や API がダウンしている場合どうしますか？いまのところユーザーにはなにも表示されません。このケースのローダーを作成し、データを取得できない場合はユーザーに伝えるとよいでしょう。

```js
new Vue({
  el: '#app',
  data () {
    return {
      info: null,
      loading: true,
      errored: false
    }
  },
  filters: {
    currencydecimal (value) {
      return value.toFixed(2)
    }
  },
  mounted () {
    axios
      .get('https://api.coindesk.com/v1/bpi/currentprice.json')
      .then(response => {
        this.info = response.data.bpi
      })
      .catch(error => {
        console.log(error)
        this.errored = true
      })
      .finally(() => this.loading = false)
  }
})
```

```html
<div id="app">
  <h1>Bitcoin Price Index</h1>

  <section v-if="errored">
    <p>We're sorry, we're not able to retrieve this information at the moment, please try back later</p>
  </section>

  <section v-else>
    <div v-if="loading">Loading...</div>

    <div
      v-else
      v-for="currency in info"
      class="currency"
    >
      {{ currency.description }}:
      <span class="lighten">
        <span v-html="currency.symbol"></span>{{ currency.rate_float | currencydecimal }}
      </span>
    </div>

  </section>
</div>
```

この pen の rerun ボタンを押すと API からデータを取得している間に簡単にローディングステータスを確認できます。

<p data-height="300" data-theme-id="32763" data-slug-hash="6c01922c9af3883890fd7393e8147ec4" data-default-tab="result" data-user="Vue" data-embed-version="2" data-pen-title="Fourth Step Axios and Vue" class="codepen">See the Pen <a href="https://codepen.io/team/Vue/pen/6c01922c9af3883890fd7393e8147ec4/">Fourth Step Axios and Vue</a> by Vue (<a href="https://codepen.io/Vue">@Vue</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

これは使用している API とアプリケーションの複雑さに依存しますが、異なる区分のコンポーネントの使用とより明確なエラー報告によってさらに改善することが可能です。

## 代替パターン

### Fetch API

この [Fetch API](https://developers.google.com/web/updates/2015/03/introduction-to-fetch) はこれらのタイプの要求のための強力なネイティブ API です。ご存知かもしれませんが、Fetch API の1つの利点は、これを使用するために外部リソースを読み込む必要がないことです。ただし、まだ完全にサポートされていないので、 polyfill を使用する必要があります。この API を使用するにはいくつか問題があり、そういった理由で多くの人が今のところ axios を使用することを好んでいます。しかし将来的には非常に変化するかもしれません。

もし Fetch API を使用することに興味があるなら、使用方法を説明してくれる [とてもいい記事](https://scotch.io/@bedakb/lets-build-type-ahead-component-with-vuejs-2-and-fetch-api) があります。

## 結論

API を使用して表示するだけでなく Vue や axios で作業する方法はたくさんあります。さらに、サーバレス関数と通信したり、書き込み権限を持っているAPI から post/edit/delete したり、他にも多くのメリットがあります。これら2つのライブラリを組み合わせるのは難しくないため、 HTTP クライアントの統合をワークフローに必要とする開発者にとって非常に一般的な選択です。
