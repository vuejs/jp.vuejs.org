---
title: Vue.js 2.0 が来ました！
date: 2016-10-01 03:30:00
---

このブログは[こちら](https://medium.com/the-vue-point/vue-2-0-is-here-ef1f26acf4b8#.70i8p9m8i)の翻訳ブログです。

今日（日本時間:2016/10/1）、私は [Vue.js 2.0：Ghost in the Shell（攻殻機動隊）](https://github.com/vuejs/vue/releases/tag/v2.0.0)の公式リリース発表に興奮しています。8つのアルファ、8つのベータ、そして8つの RC（全てが偶然の一致！）の後、Vue.js 2.0 は製品版の準備ができています！公式ガイドは完全に更新され、[vuejs.org/guide](https://vuejs.org/guide/) で入手可能です（訳注：日本語版は翻訳作業中です）。遡ること 4 月に 2.0 の作業を開始して以来、[コアチーム](https://github.com/orgs/vuejs/people)は API の設計、バグ修正、ドキュメントおよび Typescript での型付け（そう、npm パッケージで出荷された vue core、vue-router、そして vuex 2.0 はすべて TypeScript での型付けを持っています）に多大な貢献を行いました。そしてコミュニティもまた、API の変更に非常に貴重なフィードバックを提供してくれました。

## 2.0 の新機能

### 性能

![Benchmarks](https://cdn-images-1.medium.com/max/1600/1*Lu6OJiraJYShl4aBppoh3w.png)
<figcaption style="font-size:14px;text-align:center;">第3者の[ベンチマーク](http://stefankrause.net/js-frameworks-benchmark4/webdriver-ts/table.html)による。小さいほど性能が良い</figcaption>

レンダリング層は [snabbdom](https://github.com/snabbdom/snabbdom) から fork された軽量な仮想 DOM の実装を使って書き直されました。その上で、Vue のテンプレートコンパイラはコンパイル時にいくつかの賢い最適化、たとえば再レンダリングでの不要な差分抽出を回避するための分析や静的なサブツリーの巻き上げを適用することが可能です。新しいレンダリング層は v1 に比べて大幅なパフォーマンス向上を提供し、Vue 2.0 は現存する最速のフレームワークの1つとなります。加えて、Vue のリアクティブシステムは大規模で複雑なコンポーネントツリーの再レンダリングが必要なコンポーネントを正確に決定することができるので、最適化の観点から最小限の労力で済みます。

![Size](https://cdn-images-1.medium.com/max/1600/1*xV2_bx4eWC9RXiBZjeAMrw.png)
2.0 ランタイムのみのビルドはわずか 16kb（min+gzip時）と軽量であることにも言及する価値があります。vue-router と vuex を含めても合計 26kb であり、これは単体の v1 core と同等です！

### Render 関数

レンダリング層の全面改修にもかかわらず、Vue の 2.0 は大部分が 1.0 と互換性のあるテンプレート構文を維持しますが、わずかな非推奨があります。テンプレートは内部的に仮想 DOM Render 関数にコンパイルされますが、JavaScript の柔軟性を必要とする際には自前の Render 関数自身をユーザーが直接選択することができます。また、JSX を好む人のためにオプションの [JSX をサポート](https://github.com/vuejs/babel-plugin-transform-vue-jsx)もあります。

Render 関数は強力なコンポーネントベースパターンのための可能性を開くものです。例えば、新しいトランジションシステムは現在完全なコンポーネントベースですが、これは内部で Render 関数を使用しています。

### サーバーサイドレンダリング

Vue 2.0 は強烈な高速レンダリングを実現するため、ストリーミングおよびコンポーネントレベルキャッシングを使用してのサーバーサイドレンダリング（SSR）をサポートしました。加えて、vue-router と vuex 2.0 はユニバーサルルーティングとクライアントサイド状態補給 (state hydration) を使用して SSR をサポートするように設計されています。[vue-hackernews-2.0 demo app](https://github.com/vuejs/vue-hackernews-2.0/) の中でそれら全てが一緒に働いているので参照してください。

### サポートライブラリ

公式サポートライブラリとツール vue-router、vuex、vue-loader と vueify はすべて 2.0 をサポートするように更新されました。**vue-cli は現在デフォルトで 2.0 ベースのプロジェクトの土台を作るツールです。** 

特に、vue-router と vuex はともにそれぞれの 2.0 バージョンで多くの改善を受けています:

#### vue-router
- 複数の名前付き`<router-view>`サポート
- `<router-link>`コンポーネントでの改善されたナビゲーション
- 簡素化されたナビゲーションフックAPI
- カスタマイズ可能なスクロールの挙動制御
- [より包括的な例](https://github.com/vuejs/vue-router/tree/dev/examples)

#### vuex
- コンポーネントでの使用の簡素化
- 改善されたモジュール API でのより良いコードの構造化
- 構成可能な非同期アクション

詳細については、それぞれの2.0のドキュメントを参照してください：

- [http://router.vuejs.org/](http://router.vuejs.org/)
- [http://vuex.vuejs.org/](http://vuex.vuejs.org/)


### コミュニティプロジェクト

中国で最大のオンライン食品発注プラットフォームである [Ele.me のチーム](https://github.com/ElemeFE/)は、既に[完全なデスクトップ UI コンポーネントライブラリ](https://github.com/ElemeFE/element)を Vue 2.0 で構築しています。残念ながらドキュメントはまだ英語版がありませんが、彼らはそれに取り組んでいます！

他の多くのコミュニティプロジェクトもまた 2.0 互換性を持つように更新しました。[awesome-vue](https://github.com/vuejs/awesome-vue) をチェックし、ページ内で "2.0" を検索してください。

## 1.0 からの移行

もし Vue が初めてなら、今 2.0 で開始することは考えるまでもありません。しかし現在の 1.0 ユーザーのための最大の疑問は、どうやって新しいバージョンに移行するかです。

![migration](https://cdn-images-1.medium.com/max/1600/1*157Ly5X6gx0C2CIvsMaNog.png)

移行プロセスを支援するために、チームは CLI の移行ヘルパーと合わせ非常に詳細な移行ガイドに取り組んできました。このツールはすべての非推奨を検知することはできないものの、あなたが幸先の良いスタートを得ることを確実に助けることでしょう。

## もう一つ・・・

中国最大の電子商取引企業であるアリババのエンジニアは、Weex というプロジェクトに取り組んできました。これはネイティブモバイル UI の中に Vue 風の構文で記述された render コンポーネントです。しかしすぐに、"Vue 風の"は "Vue によって"になります。私たちは Weex のための Vue 2.0 で実際に JavaScript ランタイムフレームワークを作るために公式のコラボレーションを開始しました。これは Web、iOS、そして Android の間で再利用可能なユニバーサル Vue コンポーネントをユーザーが作成するために役立ちます！コラボレーションはまだ初期段階ですが、2.0 が公開されたことが今私たちには大きな焦点となりますので、ご期待ください！

（もちろん、それは ReactNative や NativeScript 同様にネイティブです。Cordova とは違います。）

Vue は個人サイドプロジェクトとしての謙虚な始まりから多くを発展させてきました。今日では[コミュニティファンド化され](https://www.patreon.com/evanyou)、[広く現実世界で採用され](https://www.quora.com/How-popular-is-VueJS-in-the-industry/answer/Evan-You-3?__snid3__=365957938&__nsrc__=2&__filter__)、そして [stats.js.org](https://stats.js.org) によるとすべての JavaScript ライブラリの中でも最も強力な成長傾向を誇っています。私たちは 2.0 がさらにそれを後押しすると信じています。これは開始以来の Vue の最大の更新であり、私たちはあなたが Vue で構築するものを見ることに興奮しています。関係者の皆さま本当にありがとうございました！
