---
title: VS Code と Chrome によるデバッグ
type: cookbook
updated: 2018-04-25
order: 8
---

すべてのアプリケーションは、小規模から大規模の障害を理解する必要があるところまできました。このレシピでは、テストのために Chrome を使っている VS Code ユーザーのためにいくつかのワークフローを説明します。

このレシピでは、[Vue CLI](https://github.com/vuejs/vue-cli) によって生成された Vue.js アプリケーションをデバックするために VS Code の拡張機能の [Debugger for Chrome](https://github.com/Microsoft/VSCode-chrome-debug) を使用する方法を示します。

## 前提条件

Chrome と VS Code がインストールされている必要があります。VS Code にインストールされている [Debugger for Chrome](https://marketplace.visualstudio.com/items?itemName=msjsdiag.debugger-for-chrome) の最新版を入手してください。

[vue-cli](https://github.com/vuejs/vue-cli) を使ってプロジェクトをインストールして作成します。インストールの手順はプロジェクトの readme に記載されています。新しく作成したアプリケーションディレクトリに移動し、VS Code を開いてください。

### Chrome Devtools でソースコードを表示する

VS Code から Vue コンポーネントをデバックする前に、ソースマップを構築するために生成された Webpack のコンフィグを更新する必要があります。デバッガには圧縮ファイル内のコードを元のファイル内の位置にマップするための方法があります。これにより、Webpack によってアセットが最適化された後でもアプリケーションをデバックすることができます。

`config/index.js` に行き、`devtool` プロパティを見つけてください。それを更新してください:

```json
devtool: 'source-map',
```

Vue CLI 3 を利用している場合は `vue.config.js` 内にプロパティ `devtool` を定義する必要が有ります。

```js
module.exports = {
  configureWebpack: {
    devtool: 'source-map'
  }
}
```

### VS Code からアプリケーションを起動する

Activity Bar の Debugging アイコン をクリックして Debug ビューを表示し、歯車アイコンをクリックして launch.json ファイルを設定し、環境に **Chrome** を選択してください。生成された launch.json の内容を次の 2 つの構成に置き換えます:

![Add Chrome Configuration](/images/config_add.png)

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "chrome",
      "request": "launch",
      "name": "vuejs: chrome",
      "url": "http://localhost:8080",
      "webRoot": "${workspaceFolder}/src",
      "breakOnLoad": true,
      "sourceMapPathOverrides": {
        "webpack:///src/*": "${webRoot}/*"
      }
    }
  ]
}
```

## ブレイクポイントを設定する

1. `data` 関数が文字列を返す `90 行目` の **src/components/HelloWorld.vue** にブレイクポイントを設定してください。

  ![Breakpoint Renderer](/images/breakpoint_set.png)

2. ルートフォルダであなたのお気に入りのターミナルを開き、Vue CLI を使用してアプリを提供してください:

  ```
  npm start
  ```

3. Debug ビューに移動し、**'vuejs: chrome'** 設定を選択し、F5 キーを押すか緑の再生ボタンをクリックしてください。

4. Chrome の新しいインスタンスが `http://localhost:8080` を開くと、ブレイクポイントがヒットするはずです。



  ![Breakpoint Hit](/images/breakpoint_hit.png)

## 代替パターン

### Vue Devtools

他にもデバッグの方法がありますが、複雑さは異なります。最も人気がありシンプルなのは、優れた [vue-devtools](https://chrome.google.com/webstore/detail/vuejs-devtools/nhdogjmejiglipccpnnnanhbledajbpd) を使用することです。devtools を使用する利点の 1 つは、データプロパティをライブ編集でき、変更がすぐに反映されることを確認できることです。もう 1 つの大きな利点は、Vuex のタイムトラベルデバッグを行うことができることです。

![Devtools Timetravel Debugger](/images/devtools-timetravel.gif)

<p class="tip">そのページが Vue.js の production/minified ビルドを使用している場合、devtools インスペクションはデフォルトで無効になっているため Vue ペインには表示されないことに注意してください。unminified のバージョンに切り替えると、ページを表示するためにハードリフレッシュする必要があるかもしれません。</p>

### Vuetron

[Vuetron](http://vuetron.io/) は、vue-devtools が行った作業のいくつかを拡張した素晴らしいプロジェクトです。通常の devtools ワークフローに加えて、次のことが可能です:

* API リクエスト/レスポンスをすばやく表示: リクエストにフェッチ API を使用している場合、送信されたリクエストに対してこのイベントが表示されます。拡張カードには、要求データも応答データも表示されます。
* より素早いデバッグのためにアプリケーションの状態の特定部分を購読します。
* コンポーネント階層を可視化し、アニメーションを使用して特定の階層ビューのツリーを折りたたんだり展開することができます。

![Vuetron Heirarchy](/images/vuetron-heirarchy.gif)

### 単純なデバッグステートメント

上記の例は素晴らしいワークフローを持っています。しかしながら、[native debugger statement](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Statements/debugger) をあなたのコード内に直接使用できる代替オプションがあります。この方法を用いることを選択する場合、完了した時にそのステートメントを削除することを覚えておくことが重要です。

```js
<script>
export default {
  data() {
    return {
      message: ''
    }
  },
  mounted() {
    const hello = 'Hello World!'
    debugger
    this.message = hello
  }
};
</script>
```

## 謝辞

このレシピは、[Kenneth Auchenberg](https://twitter.com/auchenberg) の寄稿に基づいています。[ここから利用可能](https://github.com/Microsoft/VSCode-recipes/tree/master/vuejs-cli)です。