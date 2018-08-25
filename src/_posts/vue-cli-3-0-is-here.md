---
title: Vue CLI 3.0 が来ました！
date: 2018-8-11 00:00:00
---
このブログは[こちら](https://medium.com/the-vue-point/vue-cli-3-0-is-here-c42bebe28fbb
)の翻訳ブログです。

過去数ヶ月にわたり、私たちは Vue アプリケーション用の標準ビルドツールチェーン、次世代の Vue CLI について懸命に取り組んできました。
今日私たちは [Vue CLI 3.0](https://cli.vuejs.org/) のリリースとそれに付随する全てのエキサイティングな機能を発表することにわくわくしています。

## 豊富なビルトイン機能
Vue CLI 3 は以前のバージョンとは全く別物です。書換えのゴールは以下の 2 つです：

1. モダンなフロントエンドツール、特に複数のツールを混在させる場合の構築疲れを軽減する；
1. どんな Vue アプリのデフォルトにもなるよう、可能な限りツールチェインにベストプラクティスを組込む

核として、 Vue CLI は webpack 4 の上に構築された事前設定済みのビルド設定を提供します。開発者が必要とする構成の量を最小限に抑えることを目指すため、 Vue CLI 3 プロジェクトは以下の革新的なサポートを同梱しています：

- [hot module replacement](https://webpack.js.org/concepts/hot-module-replacement/)、[コード分​​割](https://webpack.js.org/guides/code-splitting/)、 [tree Shaking](https://webpack.js.org/guides/tree-shaking/#src/components/Sidebar/Sidebar.jsx) 、[効率的な長期キャッシング](https://medium.com/webpack/predictable-long-term-caching-with-webpack-d3eee1d3fa31)、[エラーオーバーレイ](https://webpack.js.org/configuration/dev-server/#devserver-overlay)などの事前設定済みの webpack 機能
- ES2017 トランスコンパイル（オブジェクトのレスト、スプレッドやダイナミックインポートのような一般的な提案を含む）及び Babel 7 と[プリセット env](https://github.com/babel/babel/tree/master/packages/babel-preset-env) による使用に応じたポリフィル注入
- PostCSS （デフォルトで autoprefixer が有効）と全ての主要な CSS プリプロセッサのサポート
- ハッシュ付のアセットリンクとプリロード/プリフェッチのリソースヒントを含む HTML の自動生成
- `.env` ファイルを介したモードとカスケード環境変数
- [モダンモード](https://cli.vuejs.org/guide/browser-compatibility.html#modern-mode)：ネイティブ ES2017+ バンドルとレガシーバンドルを並行で出荷（詳細は後述）
- [マルチページモード](https://cli.vuejs.org/config/#pages)：複数の HTML/JS エントリポイントを持つアプリケーションの構築
- [ビルドターゲット](https://cli.vuejs.org/guide/build-targets.html#app)： Vue 単一ファイルコンポーネントをライブラリまたはネイティブ web コンポーネントにビルド（詳細は後述）

加えて、新しいプロジェクトを作成するときに混在させることができる多数のオプションが統合されています。例えば：

- [TypeScript](https://github.com/vuejs/vue-cli/tree/dev/packages/%40vue/cli-plugin-typescript)
- [PWA](https://github.com/vuejs/vue-cli/tree/dev/packages/%40vue/cli-plugin-pwa)
- [Vue Router](https://router.vuejs.org/ja/) & [Vuex](https://vuex.vuejs.org/ja/)
- [ESLint](https://eslint.org/) / [TSLint](https://palantir.github.io/tslint/) / [Prettier](https://prettier.io/)
- [Jest](https://jestjs.io/ja/) または [Mocha](https://mochajs.org/) による単体テスト
- [Cypress](https://www.cypress.io/) または [Nightwatch](http://nightwatchjs.org/) による E2E テスト

![](https://cdn-images-1.medium.com/max/880/1*llJjroMC2YJWizrXOgCDuA.png)
<figcaption style="font-size:14px;text-align:center;">あなたが望むよういくらでも選択してください</figcaption>

最も重要なのは、Vue CLI は上記の全ての機能がうまく連携しているので構築作業を自身で行う必要がないことです。

## イジェクト不要の構成が可能
上記の全ての機能は何の構築無しで動作します： Vue CLI 3 でプロジェクトを生成すると、それは Vue CLI ランタイムサービス ( @vue/cli-service ）と選択された機能プラグインをインストールし、必要な設定ファイルを生成します。ほとんどの場合、あなたはコードの作成に専念するだけで良いです。

しかしながら、潜在的な依存関係を抽象化しようとする CLI ツールではしばしばそれら依存関係の内部構成を細かく調整する機能が削除されることがありますーそのような変更を行うには、ユーザーは通常 "イジェクト" 、つまり変更を加えるため生の構成をプロジェクトにチェックインする必要があります。これの欠点は一度イジェクトすると、自己責任となり長期的にはツールの新しいバージョンにアップグレードすることができなくなることです。

私たちは設定のより低レベルのアクセスを得ることの重要性を認識していますが、イジェクトしたユーザを取り残したくは無いので、イジェクトすることなく設定のほぼ全ての側面を微調整する方法を見つけました。

Babel 、 TypeScript 、 PostCSS などのサードパーティの統合では、Vue CLI はこれらのツールに対応する設定ファイルを使用します。 Webpack の場合、ユーザーは [webpack-merge](https://github.com/survivejs/webpack-merge) を使用して単純なオプションを最終的な設定にマージする、または [webpack-chain 経由で正確にターゲット設定して既存のローダーとプラグインを微調整する](https://cli.vuejs.org/guide/webpack.html#chaining-advanced)ことができます。加えて、 Vue CLI には [`vue inspect`](https://cli.vuejs.org/guide/webpack.html#inspecting-the-project-s-webpack-config) コマンドが付属していており内部の webpack 設定を調べるのに役立ちます。しかし最も重要な部分は、小さな微調整をするためにイジェクトする必要が無いということですーあなたは依然として CLI サービスやプラグインをアップグレードして修正や新機能を利用できます。

![](https://cdn-images-1.medium.com/max/880/1*jiQtvLrGM4MP78tXaEhLRg.png)
<figcaption style="font-size:14px;text-align:center;"><a href="https://github.com/mozilla-neutrino/webpack-chain">webpack-chain</a> を使って <a href="https://github.com/jantimon/html-webpack-plugin">html-webpack-plugin</a> のオプションを微調整する</figcaption>

## 拡張可能なプラグインシステム
私たちは Vue CLI をコミュニティが構築できるプラットフォームにしたいと望んでいるので、新バージョンを最初からプラグインアーキテクチャで設計しました。 Vue CLI 3 プラグインは非常に強力です：アプリの生成段階で依存関係やファイルを挿入したり、アプリの webpack config を微調整したり開発中に追加のコマンドを CLI サービスに注入することができます。 TypeScript のような組込み統合のほとんどは全てのコミュニティプラグインで使用可能な同じ[プラグイン API](https://github.com/vuejs/vue-cli/blob/dev/packages/%40vue/cli-service/lib/PluginAPI.js) を使用してプラグインとして実装されています。もし独自のプラグインの作成に興味がある場合は、[プラグイン開発ガイド](https://cli.vuejs.org/dev-guide/plugin-dev.html#service-plugin)を参照してください。

Vue CLI 3 にはもはや "テンプレート" がありませんー代わりに、独自の[リモートプリセット](https://cli.vuejs.org/guide/plugins-and-presets.html#remote-presets)を作成してプラグインやオプションの選択肢を他の開発者と共有することができます。

## Graphical User Interface
[Guillaume CHAU](https://medium.com/@Akryum) の素晴らしい仕事のおかげで、 Vue CLI 3 には完全な GUI が付属しており、それは新しいプロジェクトを作成するだけでなく、プロジェクト内のプラグインやタスクも管理できます（そう、以下の上質な webpack ダッシュボードも付属しています）：

![](https://cdn-images-1.medium.com/max/880/1*gFc-hzoWXxts2VT40pic1Q.png)
<figcaption style="font-size:14px;text-align:center;">これは Electron を必要としませんー 単に `vue ui` で起動します.</figcaption>

>注： Vue CLI 3 は安定版としてリリースされていますが、 UI は未だベータ版です。あちこちにいくつかのおかしな挙動が見受けられます。

## 即時プロトタイピング
コードを書く前に `npm install` を待つのは楽しいことではありません。時にはインスピレーションを呼び起こすために作業環境への即時アクセスが必要な場合もあります。<span style="background-color: transparent !important; background-image: linear-gradient(to bottom, rgba(219, 249, 229, 1), rgba(219, 249, 229, 1));">Vue CLI 3 の `vue serve` コマンドは、Vue 単一ファイルコンポーネントでプロトタイピングを開始するための唯一必要な作業です：</span>

![](https://cdn-images-1.medium.com/max/880/1*3eLVIg4G46mc5nEte_tzzA.png)
<figcaption style="font-size:14px;text-align:center;">`vue serve` での即時プロトタイピング</figcaption>

プロトタイプ開発サーバーには標準のアプリケーションと同じ設定が用意されているので、プロトタイプの`*.vue`ファイルを適切に生成されたプロジェクトの`src`フォルダに簡単に移動して作業を続けることができます。

## 多目的かつ将来への備え
### モダンモード
Babel を使って ES2015+ の最新の言語機能全てを活用することができますが、それは古いブラウザをサポートするためにはトランスコンパイルとポリフィルされたバンドルを出荷する必要があることも意味します。これらのトランスコンパイルされたバンドルはしばしば元のネイティブ ES2015+ コードよりも冗長で、解析や実行も遅くなります。モダンブラウザの大多数がネイティブの ES2015+ をうまくサポートしていることを考えると、いくら古いブラウザをサポートする必要があるからといってもこれらのブラウザではコードが重く非効率です。

Vue CLI はこの問題を解決するのに役立つ "モダンモード" を提供します。プロダクション用にビルドする場合は以下のコマンド：

```
vue-cli-service build --modern
```

Vue CLI は 2 種類のバージョンを生成します：一つは[ES モジュール](https://jakearchibald.com/2017/es-modules-in-browsers/)をサポートするモダンブラウザを対象としたモダンバンドル、もう一つはそうでない古いブラウザを対象としたレガシーバンドル。

しかしクールなところは特別なデプロイ要件が無いことです。生成された HTML ファイルは、[Phillip Walton の素晴らしい記事](https://philipwalton.com/articles/deploying-es2015-code-in-production-today/)で説明されているテクニックを自動的に用います：

- モダンバンドルは `<script type="module">` をサポートするブラウザでロードされます；それらは代わりに `<link rel="modulepreload">` を使ってプリロードもされます。
- レガシーバンドルは `<script nomodule>` でロードされ、これは ES モジュールをサポートするブラウザでは無視されます。
- Safari 10 の `<script nomodule>` 修正プログラムも自動的に挿入されます。

Hello World アプリケーションの場合、モダンバンドルは既に 16％ 小さくなっています。プロダクションでは、モダンバンドルは一般に解析と評価が大幅に高速になり、アプリの読み込みパフォーマンスが向上します。一番良いところ？あなたが必要なのは `--modern` コマンドラインフラグだけということです。

>モダンモードをデフォルトにしない理由は CORS / CSP を使用している場合にはビルド時間が長くなりいくつかの余分な設定も必要になるためです。

### Web コンポーネントとしてビルド
Vue CLI 3 プロジェクトの任意の `*.vue` コンポーネントを Web コンポーネントにビルドできます：

```
vue-cli-service build --target wc --name my-element src/MyComponent.vue
```

これはページ内のネイティブカスタム要素として内部 Vue コンポーネントをラップし登録する JavaScript バンドルを生成し、それは単に `<my-element>` として使用できます。使用するページでは Vue をページにグローバルとして含める必要がありますが、それ以外の場合、 Vue は実装の詳細として完全に隠されています。

複数の `*.vue` コンポーネントを複数のチャンクを持つコード分割バンドルとしてビルドすることもできます：

```
vue-cli-service build --target wc-async 'src/components/*.vue'
```

ビルド結果のバンドルから小さなエントリファイルをインクルードすることで、全てのコンポーネントをネイティブカスタム要素として登録しますが、基礎となる Vue コンポーネントのコードを取得するのは対応するカスタム要素がページ上で最初にインスタンス化されたときだけです。

- - -

Vue CLI 3 で、同じコードベースを使用してアプリケーション、 UMD ライブラリ、またはネイティブ Web コンポーネントを構築できます。どんなターゲットを構築していても同じ Vue 開発エクスペリエンスを楽しむことができます。

## 今日それを試してみましょう！
Vue CLI 3 は 今 Vue アプリケーションの標準ビルドツールとして機能する準備が整いましたが、これはほんの始まりに過ぎません。前述のように、Vue CLI の長期目標は現在と未来のベストプラクティスをツールチェーンに組込むことです。私たちは web プラットフォームが進化するにつれて、Vue CLI はユーザーがパフォーマンスの良いアプリを提供する手助けとなることを願っています。

あなたは[このドキュメントの指示に従う](https://cli.vuejs.org/guide/installation.html)ことで今すぐ試すことができます。私たちはあなたがそれを使って何を構築するか待てません。ハッピーハッキング！

<small>[Pine Wu](https://medium.com/@octref.register?source=post_page), [Edd Yerburgh](https://medium.com/@eddyerburgh?source=post_page), [Eduardo San Martin Morote](https://medium.com/@posva?source=post_page), そして [Chris Fritz](https://medium.com/@chrisvfritz?source=post_page) に感謝します。</small>