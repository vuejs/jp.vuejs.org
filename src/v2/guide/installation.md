---
title: インストール
type: guide
order: 1
vue_version: 2.0.5
dev_size: "194.65"
min_size: "64.28"
gz_size: "23.55"
ro_gz_size: "16.39"
---

### 互換性の注意

Vue.js は IE8 でシム化できない ECMAScript 5 の機能を使用するため、IE8 とそれ以下のバージョンをサポートして**いません**。しかしながら、[ECMAScript 5 準拠のブラウザ](http://caniuse.com/#feat=es5) は全てサポートしています。

### リリースノート

各バージョンの詳細なリリースノートは、[GitHub](https://github.com/vuejs/vue/releases) で入手できます。

## スタンドアロン

ダウンロードし script タグで読み込んでください。`Vue` はグローバル変数として登録されます。

<p class="tip">開発中はプロダクションバージョンを使用しないでください。 警告や一般的な間違いを見逃す可能性があります!</p>

<div id="downloads">
<a class="button" href="/js/vue.js" download>開発バージョン</a><span class="light info">警告出力とデバッグモードあり </span>

<a class="button" href="/js/vue.min.js" download>プロダクションバージョン</a><span class="light info">警告出力なし、 {{gz_size}}kb min+gzip</span>
</div>

### CDN

推奨: [unpkg](https://unpkg.com/vue/dist/vue.min.js) は、npm に公開されるとすぐに最新バージョンが反映されます。[unpkg.com/vue/](https://unpkg.com/vue/) では npm パッケージのソースも確認することができます。

[jsdelivr](https://cdn.jsdelivr.net/vue/{{vue_version}}/vue.min.js) または [cdnjs](https://cdnjs.cloudflare.com/ajax/libs/vue/{{vue_version}}/vue.min.js) 上でも利用可能です。(同期に少し時間がかかるため、最新版ではない可能性があります)。

## NPM

Vue.js による大規模アプリケーションを構築するときには、NPM を利用したインストールを推奨しています。 [Webpack](http://webpack.github.io/) または [Browserify](http://browserify.org/) のようモジュールハンドラとうまく組み合わせられます。 Vue は[単一ファイルコンポーネント](single-file-components.html)を作成するための、付随するツールも提供しています。

``` bash
# 最新の安定版
$ npm install vue
```

### スタンドアロン vs. ランタイム限定ビルド

スタンドアロンビルドとランタイム限定ビルドの2つのビルドが使用可能です。

- スタンドアロンビルドはコンパイラを内蔵しており、 `template` オプションをサポートしています。 **ブラウザの API に依存しているため、サーバサイドレンダリングに使用することはできません。**

- ランタイム限定ビルドは、テンプレートコンパイラを内蔵しておらず、 `template` オプションはサポートされていません。ランタイム限定ビルドを使用している場合は `render` オプションのみ使用することが可能ですが、単一ファイルコンポーネントのテンプレートはビルド時に `render` 関数をプリコンパイルされるので使用可能です。ランタイム限定ビルドは {{ro_gz_size}} kb min+gzip であり、スタンドアロンビルドよりも30%軽量です。

NPM パッケージはデフォルトで**ランタイム限定**ビルドを出力します。スタンドアロンビルドを使用する場合は、webpack のコンフィグに下記のエイリアスを追加します。

``` js
resolve: {
  alias: {
    'vue$': 'vue/dist/vue.js'
  }
}
```

Browserify に関しては、 [aliasify](https://github.com/benbria/aliasify) を使うことで同じ効果を発揮します。

<p class="tip">`import Vue from 'vue/dist/vue'` をしないでください - いくつかのツールまたはサードパーティのライブラリもインポートしている可能性があります。これはアプリが同時にランタイムとスタンドアロンビルドをロードするとエラーを引き起こす恐れがあります。</p>

### CSP 環境

Google Chrome アプリのようなある環境では、Content Security Policy (CSP) を強制し、そして式を評価するために `new Function()` の使用を禁止しています。テンプレートのコンパイルは、スタンドアロンビルドに依存するため、これらの環境では使用できません。

一方では、ランタイム限定ビルドでは CSP に準拠しています。 [Webpack + vue-loader](https://github.com/vuejs-templates/webpack-simple) または [Browserify + vueify](https://github.com/vuejs-templates/browserify-simple) でランタイム限定ビルドを使用する場合は、テンプレートは CSP 環境でも完璧に動作する `render` 関数にプリコンパイルされます。

## CLI

Vue.js は意欲的なシングルページアプリケーションをすぐに足場固めするために、[オフィシャル CLI](https://github.com/vuejs/vue-cli) を提供します。それはモダンなフロントエンドのフレームワークのワークフローに対して、Battery-included なビルド手順を提供します。ホットリローディング、保存時のリント、そして本番可能なビルドを実行して準備するのは、わずか数分です。

``` bash
# vue-cli をインストール
$ npm install --global vue-cli
# "webpack" ボイラープレートを使用した新しいプロジェクトを作成する
$ vue init webpack my-project
# 依存関係をインストールしてgo!
$ cd my-project
$ npm install
$ npm run dev
```

<p class="tip">CLI は Node.js および関連するビルドツールに関する事前知識を前提としています。Vue またはフロントエンドビルドツールを初めて使用している場合、CLI を使用する前に、ビルドツールなしで[ガイド](./)を参照することを強くお勧めします。</p>

## 開発版のビルド

**重要** GitHub 上の `/dist` フォルダに存在するビルドされたファイルは、リリース時にのみチェックインされます。 GitHub 上の最新のソースコードから Vue を使用するためには、あなた自身がそれをビルドしなければなりません！

``` bash
git clone https://github.com/vuejs/vue.git node_modules/vue
cd node_modules/vue
npm install
npm run build
```

## Bower

``` bash
# 最新の安定板
$ bower install vue
```

## AMD モジュールローダ

ダウンロードされたスタンドアロン版 Vue.js と Bower 経由でインストールされた Vue.js は UMD でラップされています。そのため、AMD モジュールとして直接利用することができます。
