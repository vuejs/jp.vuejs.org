---
title: vue-cli を発表
date: 2015-12-28 00:00:00
---

最近、React プロジェクトを開始するとき、[ツールの障害を中心に議論](https://medium.com/@ericclemmons/javascript-fatigue-48d4011b6fc4#.chg95e5p6) が多くありました。幸いにも Vue.js で、迅速なプロトタイプを開始するために必要な全てのものは、`<script>` タグを介して CDN から含まれているため、カバーされている部分があります。しかしながら、それは、実際のアプリケーションを構築したいかではありません。実際のアプリケーションでは、必然的に私たちにモジュール化、トランスパイラ、プリプロセッサ、ホットリロード、リント、そしてテストを得るために一定量のツールが必要になります。これらのツールは大規模プロジェクトの長期的な保守性と生産性のために必要ではありますが、初期のセットアップは大きな痛みをともないます。これが [vue-cli](https://github.com/vuejs/vue-cli) を発表する理由で、シンプルな CLI ツールは独断で電池が付属されたビルドセットアップによって、Vue.js プロジェクトの足場をすぐ整えるのに役立ちます。

<!-- more -->

### 適切な足場 (Scaffolding)

使用方法は次のようになります:

``` bash
npm install -g vue-cli
vue init webpack my-project
# プロンプトへ回答
cd my-project
npm install
npm run dev # ドジャーン!
```

全ての CLI は、GitHub 上の [vuejs-templates](https://github.com/vuejs-templates) organization から引っ張っています。依存は、NPM 経由でハンドルされ、そしてビルドスクリプトは単純に NPM scripts です。

### 公式テンプレート

ユーザーができるだけ速く実際のアプリケーションコードを始めることができるように、公式 Vue プロジェクトテンプレートの目的は、電池を内蔵した開発ツールのセットアップを、独断で提供しています。しかしながら、これらのテンプレートは、あなたのアプリケーションコードを構造化する方法の観点では独断ではない、Vue.js に加えてあなたが使用するライブラリも加えることができます。

全ての公式プロジェクトテンプレートは [vuejs-templates organization](https://github.com/vuejs-templates) のレポジトリにあります。新しいテンプレートが organization に追加されたとき、そのテンプレートを使用するために `vue init <template-name> <project-name>` を動作させることができます。全ての利用可能な公式テンプレートを確認するために、`vue list` も動作させることができます。

現在利用可能なテンプレートは以下を含んでいます:

- [browserify](https://github.com/vuejs-templates/browserify) - フル装備された Browserify + vueify でホットリロード、リント、単体テストをセットアップ

- [browserify-simple](https://github.com/vuejs-templates/browserify-simple) - シンプルな Browserify + vueify で迅速なプロトタイピングをセットアップ

- [webpack](https://github.com/vuejs-templates/webpack) - フル装備された Webpack + vue-loader ホットリロード、リント、テスト、そして css 抽出

- [webpack-simple](https://github.com/vuejs-templates/webpack-simple) - シンプルな Webpack + vue-loader で迅速なプロトタイピングをセットアップ

### あなた自身のセットアップへの導き

公式テンプレートで嬉しくないなら、これらのテンプレートを fork することができ、それらを特定にニーズに合わせて変更 (またスクラッチからあなた自身の作成すら)でき、そして `vue-cli` は GitHub レポジトリ上で直接動作できるため、`vue-cli` 経由でそれらを使用できます:

``` bash
vue init username/repo my-project
```

### どこでも Vue コンポーネント

異なる目的のため、異なるテンプレートがあります。迅速なプロトタイピング向けのシンプルなセットアップ、そして野心的なアプリケーション向けへのフル装備されたセットアップ。これらのテンプレート間での共通の特徴は、それらは全て単一ファイルコンポーネント `*.vue` をサポートしていることです。これの意味は、確かな `*.vue` ファイルとして書かれた任意のサードパーティ Vue コンポーネントはこれらをセットアップしてプロジェクト間で共有して使用することができ、そしてシンプルに NPM 上に配信させることができます。より再利用可能なコンポーネントを作成しましょう！
