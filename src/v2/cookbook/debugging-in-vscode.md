---
title: VS Code によるデバッグ
type: cookbook
updated: 2019-03-29
order: 8
---

すべてのアプリケーションは、小規模から大規模の障害を理解する必要があるところまできました。このレシピでは、ブラウザでアプリケーションのデバッグをしたいと考えている VS Code ユーザーのためにいくつかのワークフローを説明します。

このレシピでは、ブラウザで実行している [Vue CLI](https://github.com/vuejs/vue-cli) アプリケーションをデバッグする方法を示します。

<p class="tip">注意: このレシピは Chrome と Firefox を含みます。もしあなたが他のブラウザで VS Code のデバッグを設定する方法を知っている場合、あなたの知見を共有することを検討してください (ページの下部を参照してください)。</p>

## 前提条件

VS Code とあなたが選択したブラウザがインストールされていることと、ブラウザに対応するデバッガの拡張機能がインストールされ有効化されていることを確認してください:

* [Debugger for Chrome](https://marketplace.visualstudio.com/items?itemName=msjsdiag.debugger-for-chrome)
* [Debugger for Firefox](https://marketplace.visualstudio.com/items?itemName=hbenl.vscode-firefox-debug)

[Vue CLI Guide](https://cli.vuejs.org/) 内の手順に従い、[vue-cli](https://github.com/vuejs/vue-cli) を使ってプロジェクトをインストールして作成します。新しく作成したアプリケーションディレクトリに移動し、VS Code を開いてください。

### ブラウザでソースコードを表示する

VS Code から Vue コンポーネントをデバックする前に、ソースマップを構築するために生成された Webpack のコンフィグを更新する必要があります。デバッガには圧縮ファイル内のコードを元のファイル内の位置にマップするための方法があります。これにより、Webpack によってアセットが最適化された後でもアプリケーションをデバックすることができます。

Vue CLI 2 を使っている場合、`config/index.js` 内の `devtool` プロパティを設定もしくは更新してください:

```json
devtool: 'source-map',
```

Vue CLI 3 を使っている場合、`vue.config.js` 内の `devtool` プロパティを設定もしくは更新してください:

```js
module.exports = {
  configureWebpack: {
    devtool: 'source-map'
  }
}
```

### VS Code からアプリケーションを起動する

<p class="tip">ここではポートが `8080` 番であることを想定しています。もしそうでない（例えば、`8080` 番が使われていて、Vue CLI が自動的に別のポートを選択した）場合、それに合わせて設定を修正してください。</p>

Activity Bar の Debugging アイコン をクリックして Debug ビューを表示し、歯車アイコンをクリックして launch.json ファイルを設定し、環境として **Chrome/Firefox: Launch** を選択してください。生成された launch.json の内容を対応する構成に置き換えます:

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
    },
    {
      "type": "firefox",
      "request": "launch",
      "name": "vuejs: firefox",
      "url": "http://localhost:8080",
      "webRoot": "${workspaceFolder}/src",
      "pathMappings": [{ "url": "webpack:///src/", "path": "${webRoot}/" }]
    }
  ]
}
```

## ブレイクポイントを設定する

1. `data` 関数が文字列を返す `90 行目` の **src/components/HelloWorld.vue** にブレイクポイントを設定してください。

  ![Breakpoint Renderer](/images/breakpoint_set.png)

2. ルートフォルダであなたのお気に入りのターミナルを開き、Vue CLI を使用してアプリを提供してください:

  ```
  npm run serve
  ```

3. Debug ビューに移動し、**'vuejs: chrome/firefox'** 設定を選択し、F5 キーを押すか緑の再生ボタンをクリックしてください。

4. ブラウザの新しいインスタンスが `http://localhost:8080` を開くと、ブレイクポイントがヒットするはずです。



  ![Breakpoint Hit](/images/breakpoint_hit.png)

## 代替パターン

### Vue Devtools

他にもデバッグの方法がありますが、複雑さは異なります。最も人気がありシンプルなのは、[Chrome 向け](https://chrome.google.com/webstore/detail/vuejs-devtools/nhdogjmejiglipccpnnnanhbledajbpd) および [Firefox 向け](https://addons.mozilla.org/en-US/firefox/addon/vue-js-devtools/) の優れた Vue.js devtools を使用することです。devtools を使用する利点の 1 つは、データプロパティをライブ編集でき、変更がすぐに反映されることを確認できることです。もう 1 つの大きな利点は、Vuex のタイムトラベルデバッグを行うことができることです。

![Devtools Timetravel Debugger](/images/devtools-timetravel.gif)

<p class="tip">そのページが Vue.js の production/minified ビルドを使用している場合、devtools インスペクションはデフォルトで無効になっているため Vue ペインには表示されないことに注意してください。unminified のバージョンに切り替えると、ページを表示するためにハードリフレッシュする必要があるかもしれません。</p>


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
