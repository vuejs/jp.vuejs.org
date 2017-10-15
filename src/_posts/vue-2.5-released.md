---
title: Vue 2.5 がリリースされました
date: 2017-10-14
---

このブログは[こちら](https://medium.com/the-vue-point/vue-2-5-released-14bd65bf030b)の翻訳ブログです。

私たちは Vue 2.5 レベル E のリリース発表に興奮しています！このリリースにはさまざまな機能の改善が含まれており、完全な詳細については[リリースノート](https://github.com/vuejs/vue/releases/tag/v2.5.0)をチェックすることをお勧めします。この記事ではいくつかのより顕著な変更： TypeScript 統合の改善、エラー処理の改善、単一ファイルコンポーネント内の関数型コンポーネントのサポート改善、そして環境に依存しないサーバーサイドレンダリングを取り上げます。

## TypeScript 統合の改善
![](https://cdn-images-1.medium.com/max/1600/1*vB-z-t961mJnd4a6re02Iw.png)

TypeScript チームの助けを借りて、 2.5 はコンポーネントクラスのデコレータ無しに Vue の API そのままで動作する大幅に改善された型定義を提供します。新しい型定義は、 [Vetur](https://marketplace.visualstudio.com/items?itemName=octref.vetur) のようなエディタ拡張も備えているため、素の JavaScript ユーザーに対しても Intellisense のサポートが強化されています。詳細は、[変更点に関する前回の記事](https://jp.vuejs.org/2017/09/23/upcoming-typeScript-changes-in-vue-2.5/)をチェックしてください。

TypeScript チームからの [Daniel Rosenwasser](https://github.com/danielrosenwasser) にはこの PR を開始することについて 、そしてコアチームのメンバーの [Herrington Darkholme](https://github.com/HerringtonDarkholme) と [Katashin](https://github.com/ktsn) にはこの変更の改善やレビューについて、それぞれ感謝いたします。

>注：TypeScript ユーザーは型定義の互換性のため以下のパッケージも最新版にアップデートする必要があります：`vue-router`、`vuex`、`vuex-router-sync` 及び  `vue-class-component`。

## エラー処理の改善
![](https://cdn-images-1.medium.com/max/1600/1*ZHamhzmnoQcQTxCJE3cmvA.jpeg)

2.4及びそれ以前のバージョンでは、アプリケーションの予期せぬエラーを処理するためにグローバルの `config.errorHandler` オプションを典型的に使用していました。またレンダリング関数内のエラーを処理するための `renderError` コンポーネントオプションもありました。しかし、アプリケーションの特定の部分で一般エラーを扱うためのメカニズムがありませんでした。

2.5 で私たちは新しい `errorCaptured` フックを導入しました。このフックを持つコンポーネントは子コンポーネントツリー（自身を除く）からすべてのエラー（非同期コールバック内で発生したものを除く）をキャプチャします。もし React に精通しているなら、これは React 16で 導入された [Error Boundaries](https://reactjs.org/blog/2017/07/26/error-handling-in-react-16.html#introducing-error-boundaries)  の概念に似ています。フックはグローバルの \`errorHandler\` と同じ引数を受け取り、このフックを利用して[エラーを安全に処理して表示する](https://gist.github.com/yyx990803/9bdff05e5468a60ced06c29c39114c6b#error-handling-with-errorcaptured-hook)ことができます。

## 単一ファイルコンポーネント (SFC) 内での関数型コンポーネントのサポート改善
![](https://cdn-images-1.medium.com/max/1600/1*jg9qGPkPadGBEa-KUPrMpA.png)

`vue-loader >= 13.3.0` 及び Vue 2.5 の組合わせで、 `*.vue` ファイル内の単一ファイルコンポーネントとして定義された関数型コンポーネントは今や適切な[テンプレートコンパイル、スコープ付きCSS 及びホットリロードのサポート](https://vue-loader.vuejs.org/ja/features/functional.html)を楽しめます。このことはパフォーマンスを最適化するために末端のコンポーネントを関数型コンポーネントに変換することを極めて容易にします。

コアチームメンバーの [Blake Newman](https://github.com/blake-newman) にはこれらの機能に貢献したことを感謝します。

## 環境に依存しないサーバサイドレンダリング (SSR)
\`vue-server-renderer\` のデフォルトのビルドは Node.js 環境を想定しており、それ故  [php-v8js](https://github.com/phpv8/v8js) や Nashorn などの代替 JavaScript ランタイムでは使用できません。 2.5 で私たちはブラウザや素の JavaScript エンジンで使用できる[環境に依存しない `vue-server-renderer` のビルド](https://github.com/vuejs/vue/blob/dev/packages/vue-server-renderer/basic.js)を出荷しました。このことは [PHP プロセスで直接 Vue サーバレンダリングを利用する](https://gist.github.com/yyx990803/9bdff05e5468a60ced06c29c39114c6b#environment-agnostic-ssr)などの面白い戦略を開く可能性があります。

---
繰り返しとなりますが、`v-on`、`v-model`を含む他の API の改善、スコープ付きスロット、提供/注入などのために私たちは[完全なリリースノート](https://github.com/vuejs/vue/releases/tag/v2.5.0)をチェックすることをお勧めします。チームが現在取り組んでいることを詳述している[パブリックロードマップ](https://github.com/vuejs/roadmap)にも興味があるかもしれません。それでは！