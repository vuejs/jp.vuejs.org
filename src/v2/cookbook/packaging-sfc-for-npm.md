---
title: Vue コンポーネントを npm パッケージ化する
updated: 2020-04-25
type: cookbook
order: 12
---

## 基本例

元々 Vue コンポーネントは再利用される物です。再利用はそのコンポーネントを1つのアプリケーション内でのみ利用する場合は簡単に行えます。しかし一度書いたコンポーネントを複数のサイトやアプリケーションで利用するにはどうしたら良いでしょう。おそらく最も簡単な解決策は npm を利用する事です。

npm を経由して共有できるようにコンポーネントをパッケージ化する事で、成熟したウェブ・アプリケーションにおけるビルドのプロセス内にコンポーネントを組み込むことができます。:

```js
import MyComponent from 'my-component';

export default {
  components: {
    MyComponent,
  },
  // コンポーネントの残りの箇所
}
```

直接ブラウザ内で `<script>` タグを用いて利用する事もできます:

```html
  <script src="https://unpkg.com/vue"></script>
  <script src="https://unpkg.com/my-component"></script>
  ...
  <my-component></my-component>
  ...
```

この手順を踏む事でコンポーネント周りをコピー&ペーストしなくて済むだけでなく、Vue コミュニティに還元する事にもなります！

## `.vue` ファイルを直接共有するだけでは駄目なのか

Vue は既にコンポーネントを1つのファイルとして記述する事を許容しています。単一ファイルコンポーネントは元から1つのファイルのため、次のような疑問を抱くかもしれません:

> 「なぜみんなは `.vue` ファイルを直接使ってくれないんだろう？これがコンポーネントを共有する最も簡単な方法でしょう？」

その考えは正しく、`.vue` ファイルは直接共有する事ができ、Vue コンパイラを含んで [ビルドされた Vue](https://jp.vuejs.org/v2/guide/installation.html#さまざまなビルドについて) を利用する人は誰でもそのファイルを直ちに利用できます。また、サーバサイドレンダリングのためのビルドにおいては文字列の連結を最適化のため用いるので、その状況においては `.vue` ファイルの利用が適しています（詳細は [npm を用いたコンポーネントのパッケージ化 > サーバサイドレンダリングでの利用](#サーバサイドレンダリングでの利用) を参照）。しかしながら、その方針ではコンポーネントをブラウザで `<script>` タグを通して直接利用したい人、ランタイム限定ビルドや、 `.vue` ファイルをどのように扱うかが示されていないビルドを用いる人を排除する事になります。

npm を用いて配布できるように単一ファイルコンポーネントを適切にパッケージ化する事でどこでも利用可能な物としてコンポーネントを共有できるのです！

## npm を用いたコンポーネントのパッケージ化

このセクションを理解するため、以下のファイル構造を想定して下さい:

```
package.json
build/
   rollup.config.js
src/
   wrapper.js
   my-component.vue
dist/
```

<p class="tip">本ドキュメント全体を通して、上記の package.json が参照されます。以下の例で用いられるこのファイルは手動で生成され、じきに行う議論や課題に必要とされる最小限の設定を含んでいます。各自が利用している package.json ファイルはここに示されるよりも多くの設定を保持している可能性があります。</p>

### ブラウザやビルドプロセスに対して提供するバージョンを npm にどのように定義するか

npm が用いる package.json ファイルにおいて本当は1つのバージョン (`main`) が必要なのですが、それは何も、作成の制限が存在するという事ではありません。ここでは最も一般的な利用ケースとして 2 つの追加バージョン (`module` および `unpkg`) を定義し、 `browser` フィールドを用いて直接 `.vue` ファイルへのアクセスを提供するとします。例示した package.json は以下のようになります:

```json
{
  "name": "my-component",
  "version": "1.2.3",
  "main": "dist/my-component.umd.js",
  "module": "dist/my-component.esm.js",
  "unpkg": "dist/my-component.min.js",
  "browser": {
    "./sfc": "src/my-component.vue"
  },
  ...
}
```

webpack バージョン 2 以降や、 Rollup あるいは他のモダンなビルドツールを用いれば、 `module` ビルドを解釈してくれます。レガシーなアプリケーションは `main` ビルドを使い、 `unpkg` ビルドはブラウザで直接利用されます。実際に、誰かがあなたのモジュールの URL を入れれば彼らのサービス内では [unpkg](https://unpkg.com) の CDN がこのビルドを自動的に利用します。

### サーバサイドレンダリングでの利用

興味深い点に気づかれたかもしれません - ブラウザは `browser` バージョンを利用する訳ではないのです。これはこのフィールドが実は利用者側で各自のパッケージを作成する際に作成者が [モジュールバンドラを補助する](https://github.com/defunctzombie/package-browser-field-spec#spec) ために有るからです。少し創造性を持たせて、このフィールドは `.vue` ファイル自体へエイリアスを作成する事を許容します。以下の例のように記述できます:

```js
import MyComponent from 'my-component/sfc'; // '/sfc' に注意
```

互換性の有るモジュールバンドラは package.json 内の `browser` の定義を参照して `my-component/sfc` に対するリクエストを `my-component/src/my-component.vue` へと変換し、結果として元の `.vue` ファイルが代わりに利用されます。現在ではサーバサイドレンダリングの処理においてパフォーマンス向上の為に必要な文字列連結時の最適化を利用できます。

<p class="tip">注意: `.vue` 形式のコンポーネントを直接利用する場合、`script` や `style` タグが必要とするあらゆるプリ・プロセス処理に注意して下さい。これらの依存性は利用者に引き継がれます。可能な限り物事を簡単にしておくため「プレーンな」単一ファイルコンポーネントを提供する事を心がけてください。</p>

### どのようにしてコンポーネントのバージョンを複数作成するのか

モジュールを複数回作成する必要は有りません。少しの時間で完了する、1つの手順でモジュールの 3 つのバージョン全てを用意する事が可能です。ここの例では設定を最小限にするため [Rollup](https://rollupjs.org) を利用しますが、他のビルドツールでも同様の設定ができます - この決定に関わる詳細は [こちら](https://medium.com/webpack/webpack-and-rollup-the-same-but-different-a41ad427058c) から参照できます。 package.json の `scripts` セクションはビルド対象毎に行う処理、加えてそれら全てをまとめて処理する、より一般的な `build` スクリプトによって更新されます。例となる package.json ファイルは以下のようになります:

```json
{
  "name": "my-component",
  "version": "1.2.3",
  "main": "dist/my-component.umd.js",
  "module": "dist/my-component.esm.js",
  "unpkg": "dist/my-component.min.js",
  "browser": {
    "./sfc": "src/my-component.vue"
  },
  "scripts": {
    "build": "npm run build:umd & npm run build:es & npm run build:unpkg",
    "build:umd": "rollup --config build/rollup.config.js --format umd --file dist/my-component.umd.js",
    "build:es": "rollup --config build/rollup.config.js --format es --file dist/my-component.esm.js",
    "build:unpkg": "rollup --config build/rollup.config.js --format iife --file dist/my-component.min.js"
  },
  "devDependencies": {
    "rollup": "^1.17.0",
    "@rollup/plugin-buble": "^0.21.3",
    "@rollup/plugin-commonjs": "^11.1.0",
    "rollup-plugin-vue": "^5.0.1",
    "vue": "^2.6.10",
    "vue-template-compiler": "^2.6.10"
    ...
  },
  ...
}
```

<p class="tip">もし既に package.json ファイルを利用している場合、上記よりも多くの内容を含んでいるであろう事を忘れないでください。これは単に初期段階を示しただけです。また、 devDependencies 内に記述された(それぞれのバージョンでなく)<i>パッケージ</i>は先述した 3 つの異なるビルド (umd、 es および unpkg) を rollup が作成するために最低限必要な物になっています。より新しいバージョンが利用できるようになれば、必要に応じて更新する必要が有ります。</p>

package.json に加える変更は完了しました。続いて、実際に単一ファイルコンポーネントをエクスポートおよび自動インストールするための小さなラッパーを用意し、必要な Rollup の設定を加えて準備します。

### パッケージ化されたコンポーネントはどのようになったか

コンポーネントがどのように利用されるかに応じて、[CommonJS/UMD](https://medium.freecodecamp.org/javascript-modules-a-beginner-s-guide-783f7d7a5fcc#c33a) の javascript モジュール、 [ES6 javascript](https://medium.freecodecamp.org/javascript-modules-a-beginner-s-guide-783f7d7a5fcc#4f5e) のモジュール、あるいは `<script>` タグでの利用に対応した形式のいずれかの形で利用可能とする必要が有り、そのコンポーネントは `Vue.use(...)` を通して Vue に自動的に読み込まれてページ上で即座に利用できるようになります。この処理はモジュールのエクスポートおよび自動インストールを引き受ける単純な wrapper.js ファイルによって行えます。その wrapper は、全体を記述すると、以下のようになります:

```js
// vue コンポーネントのインポート
import component from './my-component.vue';

// Vue.use() によって実行される install 関数を定義
export function install(Vue) {
	if (install.installed) return;
	install.installed = true;
	Vue.component('MyComponent', component);
}

// Vue.use() のためのモジュール定義を作成
// Create module definition for Vue.use()
const plugin = {
	install,
};

// vue が見つかった場合に自動インストールする (ブラウザで <script> タグを用いた場合等)
let GlobalVue = null;
if (typeof window !== 'undefined') {
	GlobalVue = window.Vue;
} else if (typeof global !== 'undefined') {
	GlobalVue = global.Vue;
}
if (GlobalVue) {
	GlobalVue.use(plugin);
}

// (npm/webpack 等で) モジュールとして利用させるためコンポーネントを export する
export default component;
```

最初の行では単一ファイルコンポーネントを直接読み込み、最後の行ではその内容を変更しないでエクスポートしている事に気づくでしょう。コード内のコメントで示されるように、このラッパーは Vue のための `install` 関数を提供し、続いて Vue を検知してコンポーネントを自動的にインストールしようと試みています。作業は9割方終わりました、最後まで一気に進みましょう。

### Rollup ビルドをどのように設定するか

package.json の `script` セクションの準備と単一ファイルコンポーネント用のラッパーが用意できれば、残りは Rollup が適切に設定されていることを確認するだけです。幸いにも、この操作はほんの 16 行の rollup.config.js ファイルによって行えます:

```js
import commonjs from '@rollup/plugin-commonjs'; // CommonJS モジュールを ES6 に変換
import vue from 'rollup-plugin-vue'; // .vue 単一ファイルコンポーネントを取得
import buble from '@rollup/plugin-buble'; // 適切にブラウザをサポートするトランスパイラおよびポリフィル
export default {
    input: 'src/wrapper.js', // Path relative to package.json
    output: {
        name: 'MyComponent',
        exports: 'named',
    },
    plugins: [
        commonjs(),
        vue({
            css: true, // css を <style> タグとして注入
            compileTemplate: true, // 明示的にテンプレートを描画関数に変換
        }),
        buble(), // ES5 へトランスパイルする
    ],
};
```

ここに例示した設定ファイルは npm のために単一ファイルコンポーネントをパッケージ化する最小限の設定となっています。CSS プリプロセッサを利用して、 CSS を別のファイルとして取得したり、JS の出力を難読化したりするカスタマイズを加える余地が有ります。

また、ここでコンポーネントに付与された `name` の値に注目すべきです。コンポーネントに付与されるのはパスカルケースの名称で、これはここまでの手順で利用されてきたケバブケースの名称に対応していなければなりません。

### この手順は現在の開発工程に取って代わるものか

このページの設定は現在使っている開発工程を置き換えるものでは有りません。もし現在 webpack を用いたホット・モジュール・リロードを行う環境を利用しているのならば、その環境を使い続けるべきです。もし何もない状態ならば、ホット・モジュール・リロードの設定全体を自由に扱える、 [Vue CLI 3](https://github.com/vuejs/vue-cli/) を使って下さい。

```bash
vue serve --open src/my-component.vue
```

言い換えると、各自の好みに合った物を開発環境で使ってください。この手順で大まかに示されているのは完全な開発プロセスというよりは「最後の仕上げ」になります。

## どのような場合にこのパターンの利用を避けるべきか

ここで示した方法で単一ファイルコンポーネントをパッケージ化するのは特定の状況では良いアイデアとはならないかもしれません。この手順はコンポーネント自体がどのように書かれるかという点については深く掘り下げませんでした。ある種のコンポーネントはディレクティブや追加した機能によって他のライブラリに対して副作用をおよぼすかもしれません。こういった場合には、ここで紹介した手順が必要とする変更が広い範囲に及び過ぎないか評価する必要が有るでしょう。

加えて、自分の単一ファイルコンポーネントが持つかもしれないあらゆる依存性に注意をはらって下さい。例えば、ソートや API を使った操作のためにサードパーティのライブラリが必要となる場合、適切に設定されていないと Rollup はこれらのパッケージを最終的なコードにまとめてしまう可能性が有ります。この手順を使い続けるにあたって、このようなファイルを出力から除外するように Rollup を設定し、利用者に対してはその依存性について周知するためドキュメントを更新する必要が有るかもしれません。

## 別のパターンについて

このページが書かれた時点では、Vue CLI 3 はベータ版の状態でした。このバージョンの CLI には、コンポーネントの CommonJS および UMD バージョンを生成するビルドインの `library` ビルドモードが備わっています。これは状況によっては適していますが、 package.json ファイルが `main` および `unpkg` を正しく指定している事は確認する必要が有ります。また、リリースの前に CLI にその機能が付与されるかプラグインを経由しなければ ES6 の `module` は出力されません。

## 謝辞

このページは 2018 年 3 月の VueConf.us で発表された [Mike Dodge](https://twitter.com/webdevdodge) によるライトニング・トークの成果です。彼はこの手順を用いてサンプルの単一ファイルコンポーネントを基本に構築したユーティリティを npm に公開しました。このユーティリティは、 npm を通じて、 [vue-sfc-rollup](https://www.npmjs.com/package/vue-sfc-rollup) からダウンロードできます。さらに [そのリポジトリをクローンして](https://github.com/team-innovation/vue-sfc-rollup) カスタマイズする事もできます。
