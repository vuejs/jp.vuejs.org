---
title: vue-resource の引退について
date: 2016-11-03 23:27:00
---

このブログは[こちら](https://medium.com/the-vue-point/retiring-vue-resource-871a82880af4#.33jmtzpgb)の翻訳ブログです。

Vue のユーザーとして、皆さんの多くが使用している可能性がある [*vue-resource*](https://github.com/vuejs/vue-resource) は Vue アプリケーションでの ajax リクエストを処理するためのものです。
長い間それは Vue 用の「公式」ajax ライブラリとして考えられてきましたが、本日私たちはそれを公式推奨という状態から引退させました。

vuejs organization のもとに列挙されているものの、*vue-resource* はほぼ完全に [PageKit チーム](https://github.com/pagekit)によって書かれ、保守されてきました。
私たちが初期の頃 vuejs organization にそれを移したのは、コミュニティが本質的な問題を解決するためのライブラリを寄付することは良いことだと思ったからで、また私たちは PageKit チームがプロジェクトに投下したすべての作業に大いに感謝しています。
しかし、時が経つにつれ私たちは Vue 用の「公式 ajax ライブラリ」は実は必要ではないとの結論に至りました。なぜなら：

1. ルーティングや 状態管理とは異なり、ajax は Vue のコアとの緊密な統合を必要とする問題領域ではありません。
ほとんどの場合純粋な 3rd パーティのソリューションが同様にうまく問題を解決できます。
2. 同じ問題を解決するための優れた 3rd パーティの ajax ライブラリがあり、より積極的に改良/保守されていて、かつuniversal/isomorphic（Node とブラウザの両方で動作し、そのことはサーバーサイドレンダリング用途での Vue 2.0 にとって重要）になるよう設計されています。
3. (1) と (2) なので、vue-resource の現状を維持することは二度手間かつ不要なメンテナンスの負担をもたらしていることが明らかです。
私たちが vue-resource の問題の解決に費やしていた時間を他のスタック（訳注：課題リスト）の改善により費やすことが可能となります。

## Q&A

### これは vue-resource の廃止を意味していますか？

いいえ。もはや「公式推奨」の一部ではないということだけです。
リポジトリは pagekit/vue-resource に戻され、開発は継続されるでしょう。
このライブラリの長期計画を決定するのは PageKit チームの役目です。

### 私は使用を中止する必要がありますか？

あなたがそれに満足している場合、使い続けることは全くもって結構です。
移行する可能性のある理由としては、保守、universal/isomorphic サポートと、より高度な機能（訳注：が欲しい場合）が含まれます。

### 私は次に何を使うべきですか？

何を好んで選択するかはあなたの自由（単に（訳注：jQuery の）`$.ajax` でさえも）ですが、デフォルトの推奨として ― 特に新規ユーザー向けに ― 私たちは [Axios](https://github.com/mzabriskie/axios) を調べることをお勧めします。
これは、現在もっとも人気がある HTTP クライアントライブラリの1つで、 vue-resource が提供するほとんどすべてを非常によく似た API でカバーしています。
加えて、それは universal で、キャンセルをサポートし、かつ TypeScript の定義を持っています。
もし低水準なものを好む場合は、単に標準の [fetch API](https://developer.mozilla.org/ja/docs/Web/API/Fetch_API) が使用できます。
ブラウザと Node の両方で動作するポリフィルの [isomorphic-fetch](https://github.com/matthew-andrews/isomorphic-fetch) を調べてみてください。

### Vue で Axios を使用するための Tips

1. ターゲット環境が Promise をネイティブにサポートしていない場合、Axios を使用するときは独自の Promise ポリフィル(訳注：[es6-promise](https://github.com/stefanpenner/es6-promise) 等)を提供する必要があります。
2. もし vue-resource のように `this.$http` としてアクセスしたい場合は、単に `Vue.prototype.$http = axios` と設定すればよいです。
