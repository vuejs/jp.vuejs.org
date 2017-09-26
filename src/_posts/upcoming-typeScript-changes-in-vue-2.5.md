---
title: やって来る Vue 2.5 での TypeScript の変更
date: 2017-9-23
---

このブログは[こちら](https://medium.com/the-vue-point/upcoming-typescript-changes-in-vue-2-5-e9bd7e2ecf08)の翻訳ブログです。

## 型定義の改善
私たちは Vue 2.0 のリリース以来、よりよい TypeScript 統合を求められています。リリース以来、私たちはほとんどのコアライブラリ (`vue`, `vue-router`, `vuex`) のための公式の Typescript の型定義を含めました。しかし、Vue API をそのまま使用するとき、現在の統合は幾分不足しています。たとえば、 TypeScript は Vue が使用するデフォルトのオブジェクトベースの API 内部の `this` の型を簡単には推論できません。 Vue のコードを TypeScript でうまく操るためには、 [`vue-class-component`](https://github.com/vuejs/vue-class-component) デコレータを使用する必要があり、これによってクラスベースの構文を使用して Vue コンポーネントを作成することができます。

クラスベースの API を好むユーザーの場合はこれで十分でしょうが、型推論のために異なる API を使用しなければならないというのはちょっと残念です。このことはまた既存の Vue コードベースを TypeScript に移行することをより困難にしています。

今年初め、 TypeScript は多くの[新機能](https://github.com/Microsoft/TypeScript/pull/14141)を導入し、 Vue の型定義を改善して TypeScript がオブジェクトリテラルベースの API をよりよく理解できるようにしました。 TypeScript チームの [Daniel Rosenwasser](https://github.com/DanielRosenwasser) は[野心的な PR](https://github.com/vuejs/vue/pull/5887)（今は[ここ](https://github.com/vuejs/vue/pull/6391)でコアチームメンバーの [HerringtonDarkholme](https://github.com/HerringtonDarkholme) によってメンテされています）を開始しました。いったんマージされると、以下が提供されます：
- デフォルトの Vue API を使用する際の `this` の適切な型推論。これは単一ファイルコンポーネントの中でも動作します！
- コンポーネントの props オプションに基づく `this` の props の型推論。
- 最も重要なのは、**これらの改善点が素の JavaScript ユーザーにとっても有益だということです！** VSCode を素晴らしい [Vetur](https://github.com/vuejs/vetur) 拡張機能とともに使用している場合、 Vue コンポーネントで素の JavaScript を使用すると、自動補完候補が大幅に改善され、ヒントも入力されるようになります！これは Vue コンポーネントの分析を担当する内部パッケージ [`vue-language-server`](https://www.npmjs.com/package/vue-language-server) のおかげで、 TypeScript コンパイラを利用してコードに関する詳細情報を抽出できるからです。さらに、言語サーバプロトコル（Language Server Protocol）をサポートするどんなエディタも同様の機能を提供するために　[`vue-language-server`](https://www.npmjs.com/package/vue-language-server) を活用することができます。

![動作中の VSCode + Vetur + 新しい型定義](https://cdn-images-1.medium.com/max/2000/1*ftKUpzYGIzn1eS87JcBS8Q.gif)
<figcaption style="font-size:14px;text-align:center;">動作中の VSCode + Vetur + 新しい型定義</figcaption>

興味のある方は、[この遊び場プロジェクト](https://github.com/octref/veturpack/tree/new-types)を clone して（`new-types` ブランチをチェックアウトしてください）VSCode + Vetur で開くことで今すぐ試すことができます！

## TypeScript ユーザーが潜在的に求められる対応
型定義のアップグレードは今のところ 10 月上旬にリリースされる予定の Vue 2.5で出荷される予定です。 JavaScript の公開 API に破壊的な変更がないためマイナーリリースでリリースしていきますが、このアップグレードは既存の TypeScript + Vue ユーザーにいくつかの対応を潜在的に要求します。これが今の段階で変更を発表する理由で、アップグレードの計画に十分な時間を確保できるようにするためです。
- 新しいタイピングには最低でも TypeScript 2.4 が必要です。 Vue 2.5 とともに TypeScript の最新バージョンにアップグレードすることをお勧めします。
- 以前から、`tsconfig.json` に `“allowSyntheticDefaultImports”: true` を指定することでどこでも ES 形式のインポート(`import Vue from ‘vue’`)を使用することをお勧めしています。新しいタイピングは正式に ES スタイルの import/export 構文に移行するため、 config はもはや不要となり全てのケースで ES スタイルのインポートを使用する必要があります。
- export 構文の変更を伴うため、 Vue のコアタイピングに頼るタイピングを持つ次のコアライブラリ群は、新しいメジャーバージョンを受け取り、Vue コア 2.5 と一緒にアップグレードする必要があります：`vuex`, `vue-router`, `vuex-router-sync`, `vue-class-component`。
- カスタムモジュール拡張を行うとき、ユーザーは今や `namespace Vue` の代わりに `interface VueConstructor` を使用する必要があります。([diff の例](https://github.com/vuejs/vue/pull/6391/files#diff-1c3e3e4cf681d5fde88941717da1058aL11))
- `as ComponentOptions<Something>`でコンポーネントオプションにアノテーションを付ける場合、`computed`, `watch`, `render` の ThisType とライフサイクルのフックは手作業で型のアノテーションを付ける必要があります。

私たちは必要なアップグレード作業を最小限に抑えるためベストを尽くし、これらの型定義の改善は `vue-class-component` で使用されるクラスベースの API と互換性があります。ほとんどのユーザーは、単に依存関係を更新して ES スタイルのインポートに切り替えるだけです。その間、貴方がアップグレードする準備が整うまで Vue のバージョンを 2.4.x に固定することも私たちはお勧めします。

## ロードマップ： vue-cli での TypeScript のサポート
2.5 以降は、私たちは TS + Vue ユーザーが新しいプロジェクトを簡単に開始できるようにするため vue-cli の次のバージョンで TypeScript の公式サポートを導入する予定です。ご期待ください！

## 非 TypeScript ユーザーの場合
これらの変更は非 TypeScript の Vue ユーザーに悪影響を及ぼすことはありません；セマンティックバージョンにより、 2.5 は公開 JavaScript API に関しては完全に後方互換性があり、 TypeScript CLI 統合は完全にオプトインになります。しかし上記で述べたように、 [`vue-language-server`](https://github.com/vuejs/vetur/tree/master/server) でのエディタ拡張機能を使用している場合はオートコンプリート提案が気に入るはずです。

—

[Daniel Rosenwasser](https://github.com/danielrosenwasser)、 [HerringtonDarkholme](https://github.com/HerringtonDarkholme)、 [Katashin](https://github.com/ktsn) 、 [Pine Wu](https://github.com/octref)
の方々にはこれらの機能への取り組みとこの記事（訳注：原文のほう）のレビューについて感謝します。
