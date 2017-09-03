---
title: 単一ファイルコンポーネント
updated: 2017-06-26 00:00:00
type: guide
order: 19
---

## 前書き

多くの Vue プロジェクトでは、グローバルコンポーネントは、`new Vue({ el: '#container '})` の後に各ページの body においてコンテナ要素をターゲットにすることに続いて、`Vue.component` を使用して定義されています。

これは view を拡張するだけに利用された小さな中規模プロジェクトにおいてはとても有効です。 あなたのフロントエンドで JavaScript 全体を操作するようなもっと複雑なプロジェクトでは、これらの点において不利益になることは明白です。:

- **グローバル宣言**は全てのコンポーネントに一意な名前を強制すること
- シンタックスハイライトの無い**文字列テンプレート**と複数行 HTML の時に醜いスラッシュが強要されること
- **CSS サポート無し**だと、 HTML と JavaScript がコンポーネントにモジュール化されている間、これ見よがしに無視されること
- **ビルド処理がない**と Pug (前 Jade) や Babel のようなプリプロセッサよりむしろ、 HTML や ES5 JavaScript を制限されること

これら全ては Webpack や Browserify のビルドツールにより実現された `.vue` 拡張子の **単一ファイルコンポーネント** で解決します。

こちらが `Hello.vue` と呼ばれたファイルの単純な例です:

<img src="/images/vue-component.png" style="display: block; margin: 30px auto">

さて次にこちらに入ります:

- [完全版シンタックスハイライト](https://github.com/vuejs/awesome-vue#source-code-editing)
- [CommonJS モジュール](https://webpack.js.org/concepts/modules/#what-is-a-webpack-module)
- [コンポーネントスコープ CSS](https://github.com/vuejs/vue-loader/blob/master/docs/en/features/scoped-css.md)

約束したとおり、 Pug、 Babel(ES2015 モジュールと一緒に）や Stylus などより美しくかつ機能が豊富なコンポーネントもプリプロセッサとして利用できます。

<img src="/images/vue-component-with-preprocessors.png" style="display: block; margin: 30px auto">

これらの特定の言語は単なる一例です。Buble 、TypeScript 、SCSS 、PostCSS などの生産的なプリプロセッサも簡単に使うことができます。`vue-loader` で Webpack を使用しているならば、CSS Modules 向けに素晴らしいサポートがあります。

## 関心の分離について

注意すべき重要な点の1つは、**関心事項の分離がファイルタイプの分離と等しくないことです。** 現代の UI 開発では、コードベースを互いに織り交ぜる3つの巨大なレイヤーに分割するのではなく、それらを疎結合なコンポーネントに分割して構成する方がはるかに理にかなっています。コンポーネントの内部では、そのテンプレート、ロジック、スタイルが本質的に結合されており、実際にそれらを配置することで、コンポーネントがより一貫性と保守性に優れています。

単一ファイルコンポーネントのアイデアが気に入らなくても、JavaScript と CSS を別々のファイルに分けることで、ホットリロードとプリコンパイル機能を活用できます:

```html
<!-- my-component.vue -->
<template>
  <div>This will be pre-compiled</div>
</template>
<script src="./my-component.js"></script>
<style src="./my-component.css"></style>
```

## 始める

### JavaScript でモジュールビルドシステムが初めてなユーザー向け

`.vue` コンポーネントにより、高度な JavaScript アプリケーションの分野に入っていきます。これはあなたがまだ使ったことのない、いくつかの追加ツールの使い方を学ぶことを意味します。

- **Node Package Manager (NPM)**: [Getting Started guide](https://docs.npmjs.com/getting-started/what-is-npm) のセクション _10: Uninstalling global packages_ を読んでください。

- **Modern JavaScript with ES2015/16**: Babel の [Learn ES2015 guide](https://babeljs.io/docs/learn-es2015/) を読んでください。現状では全ての機能を暗記する必要はないですが、参考として戻れるようにしておいてください。

これらのリソースに没頭した後は、 [webpack-simple](https://github.com/vuejs-templates/webpack-simple) テンプレートを確認することをお勧めします。手順に沿って学習することで、あっという間に ES2015 とホットリローディングで動作した `.vue` コンポーネントの Vue プロジェクトを持っているはずです！

テンプレートでは、多数の"モジュール"を取りまとめ最終的なアプリケーションに束ねてくれる [Webpack](https://webpack.js.org/) というモジュールバンドラーを使用します。 Webpack についてもっと学ぶには、[それらの公式なドキュメント](https://webpack.js.org/configuration/)や [Webpack Academy](https://webpack.academy/p/the-core-concepts) を参照すると良いでしょう。

Webpack で、各モジュールは、バンドルに含まれる前に "loader" により変換されます。また Vue では `.vue` 単一ファイルコンポーネントをコンパイルするために [vue-loader](https://github.com/vuejs/vue-loader) を推奨しています。 [webpack-simple](https://github.com/vuejs-templates/webpack-simple) テンプレートはあなたのために全てセットアップ済みの状態で用意してありますが、もし Webpack と `.vue` コンポーネントについてもっと学びたい場合は、[vue-loader ドキュメント](https://vue-loader.vuejs.org) を読むこともできます。

### 上級者ユーザー向け

あなたが Webpack か Browserify のどちらが好みでも、私達はシンプルなものと、複雑なプロジェクトのテンプレート両方を用意しました。[github.com/vuejs-templates](https://github.com/vuejs-templates) を閲覧し、あなたに合ったテンプレートを選んでください。そうしたら、[vue-cli](https://github.com/vuejs/vue-cli) で新しいプロジェクトを生成するために README 内の手順に沿ってください。
