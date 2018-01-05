---
title: HackerNews クローン
updated: 2017-09-23
type: examples
order: 12
---

> これは Hackernews のオフィシャル Firebase API に基づいた Hackernews クローンで、Vue 2.0 + Vue Router + Vuex 、そしてサーバサイドレンダリングが使用されています。

{% raw %}
<div style="max-width: 600px;">
  <a href="https://github.com/vuejs/vue-hackernews-2.0" target="_blank">
    <img style="width: 100%;" src="../../images/hn.png">
  </a>
</div>
{% endraw %}
 

> [ライブデモ](https://vue-hn.now.sh/)
> 注意: 一定期間誰もアクセスしていなかった場合、デモはスピンアップ時間を要するかもしれません。
>
> [[ソース](https://github.com/vuejs/vue-hackernews-2.0)]

## 機能
- サーバサイドレンダリング
  - Vue + Vue Router + Vuex と一緒に使用
  - サーバサイドのデータのプリフェッチ
  - クライアントサイドの状態 & DOM ハイドレーション
- 単一ファイル Vue コンポーネント
  - 開発モードにおけるホットリロード
  - 本番向けの CSS 抽出
- FLIP アニメーションによるリアルタイムリストアップデート

## アーキテクチャ概要

<img width="973" alt="Hackernew clone architecture overview" src="../../images/hn-architecture.png">
