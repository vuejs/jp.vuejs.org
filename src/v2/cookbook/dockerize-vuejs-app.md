---
title: Vue.js アプリケーションを Docker 化する
type: cookbook
updated: 2019-10-29
order: 13
---

## 簡単な例

あなたははじめての Vue.js アプリケーションを素晴らしい [Vue.js webpack テンプレート](https://github.com/vuejs-templates/webpack) を利用して作成し、Docker コンテナで実行もできることを同僚に披露したいと思っています。

ではプロジェクトルートに `Dockerfile` を作成しましょう:

```docker
FROM node:lts-alpine

# 静的コンテンツを配信するシンプルな http サーバをインストールする
RUN npm install -g http-server

# カレントワーキングディレクトリとして 'app' フォルダを指定する
WORKDIR /app

# `package.json` と `package-lock.json` （あれば）を両方コピーする
COPY package*.json ./

# 開発環境用の依存を除いて、プロジェクトの依存ライブラリをインストールする
RUN npm install --production

# カレントワーキングディレクトリ(つまり 'app' フォルダ)にプロジェクトのファイルやフォルダをコピーする
COPY . .

# 本番向けに圧縮しながらアプリケーションをビルドする
RUN npm run build

EXPOSE 8080
CMD [ "http-server", "dist" ]
```

はじめに `package.json` と `package-lock.json` をコピーし、次にプロジェクトの全てのファイルとフォルダをコピーするという2つに別れたステップは冗長に見えるかもしれませんが、実際には [とてももっともな理由](http://bitjudo.com/blog/2014/03/13/building-efficient-dockerfiles-node-dot-js/) があります。(ネタばれ: これによってキャッシュされた Docker レイヤーを活用できます)

では Vue.js アプリケーションの Docker イメージをビルドしましょう:

```bash
docker build -t vuejs-cookbook/dockerize-vuejs-app .
```

最後に、 Vue.js アプリケーションを Docker コンテナで実行しましょう:

```bash
docker run -it -p 8080:8080 --rm --name dockerize-vuejs-app-1 vuejs-cookbook/dockerize-vuejs-app
```

`localhost:8080` で Vue.js アプリケーションにアクセスができるでしょう。

## 現実の例

上述の例では、シンプルで設定の無いコマンドラインの [http server](https://github.com/indexzero/http-server) を使って、素早いプロトタイピング完璧で、シンプルな本番のシナリオに良い _かもしれない_ Vue.js アプリケーションを配信しました。とにかく、そのドキュメントではこう言っています:

> 本番環境で使うには十分強力ですが、テスト、ローカル開発、および学習に使用するにはシンプルでハックが可能です。

それでも、現実的に複雑な本番環境のユースケースでは、 [NGINX](https://www.nginx.com/) や [Apache](https://httpd.apache.org/) などの巨人の肩に乗るのが賢明でしょうし、それがまさに我々が次にやろうとしていることです。我々は最も性能が良く実戦で試されている解決策の1つだと考えられているという理由で、まさに NGINX を活用して Vue.js アプリケーションを配信しようとしています。

`Dockerfile` を NGINX を使うようにリファクタリングしましょう:

 ```docker
# ビルド環境
FROM node:lts-alpine as build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY . .
RUN npm run build

# 本番環境
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

OK、ここで何が起きているか見てみましょう:
* 元の `Dockerfile` を Docker の [マルチステージビルド](https://docs.docker.com/develop/develop-images/multistage-build/) 機能を活用して、複数のステージに分離しました。
* はじめのステージでは Vue.js アプリケーションの本番環境に準備された成果物をビルドする責務があります。
* 2つ目のステージではその成果物を NGINX を使って配信する責務があります。

さて Vue.js アプリケーションを Docker イメージを使ってビルドしましょう:

```bash
docker build -t vuejs-cookbook/dockerize-vuejs-app .
```

最後に、 Vue.js アプリケーション を Docker コンテナの中で実行しましょう:

```bash
docker run -it -p 8080:80 --rm --name dockerize-vuejs-app-1 vuejs-cookbook/dockerize-vuejs-app
```

`localhost:8080` で Vue.js アプリケーションにアクセスができるでしょう。

<!-- ## Additional Context -->
## さらなる背景

もしあなたがこのクックブックを読んでいるなら、おそらく Vue.js アプリケーションを Docker 化することにした理由を既にわかっているでしょう。しかし、あなたが単に Google の `I'm feeling lucky` ボタンを押した後にこのページにたどり着いたとしたら、いくつかのもっともな理由を共有しましょう。

今日のモダンな流行りは、主に下記のバズワードを中心にしたアプローチとして [Cloud-Native](https://pivotal.io/cloud-native) を使ってアプリケーションを構築することです。
* マイクロサービス
* DevOps
* 継続的デリバリ

これらのコンセプトが実際にどうやって Vue.js アプリケーションを Docker 化するという決断に影響するか見ていきましょう。

### マイクロサービスへの効果

[マイクロサービスアーキテクチャスタイル](https://martinfowler.com/microservices/) を採用することによって、独自のプロセスで動き、軽量な機構で連携する小さなサービスの集まりとして単一のアプリケーションを構築することになります。これらのサービスはビジネスの機能を中心に構築され、完全に自動化されたデプロイ機構によって独立してデプロイ可能です。

そのため、このアーキテクチャのアプローチへほとんどの時間を費やすことは、フロントエンドを独立したサービスとして開発・配信することを意味します。

### DevOps への効果

[DevOps](https://martinfowler.com/bliki/DevOpsCulture.html) 文化、ツールおよびアジャイル開発の実践を採用することは、とりわけ開発と運用の役割の協力を増やす良い影響があります。過去の（しかし一部では実際に今でも）主な問題の1つは開発チームは一度運用チームに引き渡されたシステムの運用や保守には無関心な傾向にあり、後者はシステムのビジネスの目標を知らず、したがってシステムの運用上のニーズを満たすことを渋る（「開発者の気まぐれ」と言われる）傾向にあります。

そのため、 Vue.js アプリケーションを Docker イメージとして配信することは、全てを無くすことはないとしても、開発者のラップトップや本番環境など考えうる全ての環境で実行されるサービスの差を減らす助けになります。

### 継続的デリバリへの効果

[継続的デリバリ](https://martinfowler.com/bliki/ContinuousDelivery.html) の規律を活用することで、いつでも本番にリリースされる可能性のあるやり方でソフトウェアを構築します。このようなエンジニアリングの実践は通常、 [継続的デリバリパイプライン](https://martinfowler.com/bliki/DeploymentPipeline.html) と呼ばれるものによって可能になります。継続的デリバリパイプラインの目的はビルドを段階（例：コンパイル、単体テスト、結合テスト、性能テストなど）に分け、ソフトウェアの変更のたびにそれぞれの段階でビルド成果物を検証することです。最終的に、それぞれの段階はプロダクションビルドの成果物の準備状況の自信を高め、したがって本番環境（またはそのような他の環境）で壊れるリスクを減らします。

そのため、 Vue.js アプリケーションから Docker イメージを作ることは最終的なビルド成果物、つまり継続的デリバリパイプラインで検証され、自信を持って本番環境に配信できる成果物を表すため、ここでは良い選択です。

## 代替パターン

もしあなたの会社が Docker や Kubernetes を使っていない場合や、ただシンプルに MVP を世にリリースしたいという場合は、 Vue.js アプリケーションを Docker 化するのは求めているものではないかもしれません。

よくある代替パターンは以下の通りです:
* [Netlify](https://www.netlify.com/) のような全部入りのプラットフォームを活用する。
* SPA を [Amazon S3](https://aws.amazon.com/jp/s3/) でホスティングし、 [Amazon CloudFront](https://aws.amazon.com/jp/cloudfront/)（[こちら](https://serverless-stack.com/chapters/deploy-the-frontend.html) のリンクで詳細なガイドを読んでください）で配信する。
