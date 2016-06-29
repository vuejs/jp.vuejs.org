---
title: インストール
type: guide
order: 0
vue_version: 1.0.26
dev_size: "266.49"
min_size: "75.01"
gz_size: "26.04"
---

### 互換性の注意

Vue.js は IE8 でシム化できない ECMAScript 5 の機能を使用するため、IE8 とそれ以下のバージョンをサポートして**いません**。しかしながら、[ECMAScript 5 準拠のブラウザ](http://caniuse.com/#feat=es5) は全てサポートしています。

### リリースノート

各バージョンの詳細なリリースノートは、[GitHub](https://github.com/vuejs/vue/releases) で入手できます。

## スタンドアロン

ダウンロードし script タグで読み込んでください。`Vue` はグローバル変数として登録されます。

<div id="downloads">
<a class="button" href="/js/vue.js" download>開発バージョン</a><span class="light info">警告出力とデバッグモードあり</span>

<a class="button" href="/js/vue.min.js" download>プロダクションバージョン</a><span class="light info">警告出力なし、{{gz_size}}kb min+gzip</span>
</div>

### CDN

[jsdelivr](//cdn.jsdelivr.net/vue/{{vue_version}}/vue.min.js) または [cdnjs](//cdnjs.cloudflare.com/ajax/libs/vue/{{vue_version}}/vue.min.js) を利用可能です。 (同期に少し時間がかかるため、最新版ではないかもしれません)。

[npmcdn](https://npmcdn.com/vue/dist/vue.min.js) 上でも利用可能で、npm に公開されるとすぐに最新バージョンが反映されます。[npmcdn.com/vue/](https://npmcdn.com/vue/) では npm パッケージのソースも確認することができます。

### CSP 準拠ビルド

Google Chrome アプリのようなある環境では、Content Security Policy (CSP) を強制し、そして式を評価するために `new Function()` の使用を許可しません。このような場合には、[CSP 準拠ビルド](https://github.com/vuejs/vue/tree/csp/dist)を代わりに使用できます。

## NPM

Vue.js による大規模アプリケーションを構築するときには、NPM を利用したインストールを推奨しています。[Webpack](http://webpack.github.io/) または [Browserify](http://browserify.org/) のような CommonJS モジュールバンドラとうまく組み合わせられます。Vue.js は[単一ファイルコンポーネント](application.html#単一ファイルコンポーネント)を作成するための、付随するツールも提供しています。

``` bash
# 最新の安定版
$ npm install vue
# 最新の安定版 + CSP 準拠
$ npm install vue@csp
```

## CLI

Vue.js は意欲的なシングルページアプリケーションをすぐに足場固めするために、[オフィシャル CLI](https://github.com/vuejs/vue-cli) を提供します。それはモダンなフロントエンドのフレームワークのワークフローに対して、Battery-included なビルド手順を提供します。ホットリローディング、保存時のリント、そして本番可能なビルドを実行して準備するのは、わずか数分です。

``` bash
# インストール vue-cli
$ npm install -g vue-cli
# "webpack" ボイラープレートを使用した新しいプロジェクトを作成する
$ vue init webpack my-project
# 依存関係をインストールしてgo!
$ cd my-project
$ npm install
$ npm run dev
```

## 開発版のビルド

**重要**: NPM に配信された CommonJS バンドル (`vue.common.js`) はリリース時に `master` ブランチにチェックインされたものであるため、`dev` ブランチのファイルは安定リリース版と同じです。Github 上の最新のソースコードから Vue を使用するためには、あなた自身がそれをビルドしなければなりません！

``` bash
git clone https://github.com/vuejs/vue.git node_modules/vue
cd node_modules/vue
npm install
npm run build
```

## Bower

``` bash
# 最新の安定版
$ bower install vue
```

## AMD モジュールローダ

ダウンロードされたスタンドアロン版 Vue.js と Bower 経由でインストールされた Vue.js は UMD でラップされています。そのため、AMD モジュールとして直接利用することができます。

