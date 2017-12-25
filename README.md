# vuejs/jp.vuejs.org

[![Circle CI](https://circleci.com/gh/vuejs/jp.vuejs.org/tree/lang-ja.svg?style=svg&circle-token=833967ff387fa4a8d91a738086d5c166ea0a6f85)](https://circleci.com/gh/vuejs/jp.vuejs.org/tree/lang-ja)
[![Slack Status](https://vuejs-jp-slackin.herokuapp.com/badge.svg)](https://vuejs-jp-slackin.herokuapp.com/)

このリポジトリは Vue.js 最新バージョン 2.x 向けのドキュメントを管理しているレポジトリです。

- Vue.js 1.x 向けドキュメント管理リポジトリ: [こちら](https://github.com/vuejs/v1-jp.vuejs.org)
- Vue.js 0.12 向けドキュメント管理リポジトリ: [こちら](https://github.com/vuejs-jp/012-jp.vuejs.org)

このサイトは [hexo](https://hexo.io/) で構築されています。サイトコンテンツは `src` の位置に markdown フォーマットで書かれています。プルリクエスト、歓迎します！

## 貢献ガイド
[Vue.js 公式サイト日本語翻訳ガイド](https://github.com/vuejs/jp.vuejs.org/blob/lang-ja/CONTRIBUTING.md) を一読お願いします！

## 開発

```
$ npm install -g hexo-cli
$ npm install
$ npm start # http://localhost:4000 で開発サーバを開始
```

## デプロイ

このサイトは GitHub pages を使用してデプロイされているため、デプロイスクリプトを実行するには、 jp.vuejs.org レポジトリへの push アクセス権限が必要です:

``` bash
$ npm run deploy
```

フォークしたレポジトリにおいて作業していて異なる URL にデプロイする場合は、それに応じて以下のものを更新する必要があります:

- `_config.yml` の中の `url` と `deploy` セクション
- `src/CNAME`

## 貢献者
貢献された方々は、[こちら](http://jp.vuejs.org/contribution/) 
