---
title: Vue コンポーネントを npm パッケージ化する
updated: 2018-05-28
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

> 「なぜみんなは `.vue` ファイルを直接使ってくれないんだ？これがコンポーネントを共有する最も簡単な方法だろ？」

その考えは正しく、`.vue` ファイルは直接共有する事ができ、Vue コンパイラを含んで [ビルドされた Vue](https://vuejs.org/v2/guide/installation.html#Explanation-of-Different-Builds) を利用する人は誰でもそのファイルを直ちに利用できます。また、サーバサイドレンダリングのためのビルドにおいては文字列の連結を最適化のため用いるので、その状況においては `.vue` ファイルの利用が適しています（詳細は [npm を用いたコンポーネントのパッケージ化 > サーバサイドレンダリングでの利用](#サーバサイドレンダリングでの利用) を参照）。しかしながら、その方針ではコンポーネントをブラウザで `<script>` タグを通して直接利用したい人、ランタイム限定ビルドや、 `.vue` ファイルをどのように扱うかが示されていないビルドを用いる人を排除する事になります。

npm を用いて配布できるように単一ファイルコンポーネントを適切にパッケージ化する事でどこでも利用可能な物としてコンポーネントを共有できるのです！

## npm を用いたコンポーネントのパッケージ化

このセクションを理解するため、以下のファイル構造を想定して下さい:

```
package.json
build/
   rollup.config.json
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

興味深い点に気づかれたかもしれません - ブラウザは `brower` バージョンを利用する訳ではないのです。これはこのフィールドが実は利用者側で各自のパッケージを作成する際に作成者が [モジュールバンドラを補助する](https://github.com/defunctzombie/package-browser-field-spec#spec) ために有るからです。少し創造性を持たせて、このフィールドは `.vue` ファイル自体へエイリアスを作成する事を許容します。以下の例のように記述できます:

```js
import MyComponent from 'my-component/sfc'; // '/sfc' に注意
```

互換性の有るモジュールバンドラは package.json 内の `browser` の定義を参照して `my-component/sfc` に対するリクエストを `my-component/src/my-component.vue` へと変換し、結果として元の `.vue` ファイルが代わりに利用されます。現在ではサーバサイドレンダリングの処理においてパフォーマンス向上の為に必要な文字列連結時の最適化を利用できます。

<p class="tip">注意: `.vue` 形式のコンポーネントを直接利用する場合、`script` や `style` タグが必要とするあらゆるプリ・プロセス処理に注意して下さい。これらの依存性は利用者に引き継がれます。可能な限り物事を簡単にしておくため「プレーンな」単一ファイルコンポーネントを提供する事を心がけてください。</p>

### How do I make multiple versions of my component?

There is no need to write your module multiple times. It is possible to prepare all 3 versions of your module in one step, in a matter of seconds. The example here uses [Rollup](https://rollupjs.org) due to its minimal configuration, but similar configuration is possible with other build tools - more details on this decision can be found [here](https://medium.com/webpack/webpack-and-rollup-the-same-but-different-a41ad427058c). The package.json `scripts` section can be updated with a single entry for each build target, and a more generic `build` script that runs them all in one pass. The sample package.json file now looks like this:

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
    "rollup": "^0.57.1",
    "rollup-plugin-buble": "^0.19.2",
    "rollup-plugin-vue": "^3.0.0",
    "vue": "^2.5.16",
    "vue-template-compiler": "^2.5.16",
    ...
  },
  ...
}
```

<p class="tip">Remember, if you have an existing package.json file, it will likely contain a lot more than this one does. This merely illustrates a starting point. Also, the <i>packages</i> listed in devDependencies (not their versions) are the minimum requirements for rollup to create the three separate builds (umd, es, and unpkg) mentioned. As newer versions become available, they should be updated as necessary.</p>

Our changes to package.json are complete. Next, we need a small wrapper to export/auto-install the actual SFC, plus a mimimal Rollup configuration, and we're set!

### What does my packaged component look like?

Depending on how your component is being used, it needs to be exposed as either a [CommonJS/UMD](https://medium.freecodecamp.org/javascript-modules-a-beginner-s-guide-783f7d7a5fcc#c33a) javascript module, an [ES6 javascript](https://medium.freecodecamp.org/javascript-modules-a-beginner-s-guide-783f7d7a5fcc#4f5e) module, or in the case of a `<script>` tag, it will be automatically loaded into Vue via `Vue.use(...)` so it's immediately available to the page. This is accomplished by a simple wrapper.js file which handles the module export and auto-install. That wrapper, in its entirety, looks like this:

```js
// Import vue component
import component from './my-component.vue';

// Declare install function executed by Vue.use()
export function install(Vue) {
	if (install.installed) return;
	install.installed = true;
	Vue.component('MyComponent', component);
}

// Create module definition for Vue.use()
const plugin = {
	install,
};

// Auto-install when vue is found (eg. in browser via <script> tag)
let GlobalVue = null;
if (typeof window !== 'undefined') {
	GlobalVue = window.Vue;
} else if (typeof global !== 'undefined') {
	GlobalVue = global.Vue;
}
if (GlobalVue) {
	GlobalVue.use(plugin);
}

// To allow use as module (npm/webpack/etc.) export component
export default component;
```

Notice the first line directly imports your SFC, and the last line exports it unchanged. As indicated by the comments in the rest of the code, the wrapper provides an `install` function for Vue, then attempts to detect Vue and automatically install the component. With 90% of the work done, it's time to sprint to the finish!

### How do I configure the Rollup build?

With the package.json `scripts` section ready and the SFC wrapper in place, all that is left is to ensure Rollup is properly configured. Fortunately, this can be done with a small 16 line rollup.config.js file:

```js
import vue from 'rollup-plugin-vue'; // Handle .vue SFC files
import buble from 'rollup-plugin-buble'; // Transpile/polyfill with reasonable browser support
export default {
    input: 'build/wrapper.js', // Path relative to package.json
    output: {
        name: 'MyComponent',
        exports: 'named',
    },
    plugins: [
        vue({
            css: true, // Dynamically inject css as a <style> tag
            compileTemplate: true, // Explicitly convert template to render function
        }),
        buble(), // Transpile to ES5
    ],
};
```

This sample config file contains the minimum settings to package your SFC for npm. There is room for customization, such as extracting CSS to a separate file, using a CSS preprocessor, uglifying the JS output, etc.

Also, it is worth noting the `name` given the component here. This is a PascalCase name that the component will be given, and should correspond with the kebab-case name used elsewhere throughout this recipe.

### Will this replace my current development process?

The configuration here is not meant to replace the development process that you currently use. If you currently have a webpack setup with hot module reloading (HMR), keep using it! If you're starting from scratch, feel free to install [Vue CLI 3](https://github.com/vuejs/vue-cli/), which will give you the whole HMR experience config free:

```bash
vue serve --open src/my-component.vue
```

In other words, do all of your development in whatever way you are comfortable. The things outlined in this recipe are more like 'finishing touches' than a full dev process.

## When to Avoid this Pattern

Packaging SFCs in this manner might not be a good idea in certain scenarios. This recipe doesn't go into detail on how the components themselves are written. Some components might provide side effects like directives, or extend other libraries with additional functionality. In those cases, you will need to evaluate whether or not the changes required to this recipe are too extensive.

In addition, pay attention to any dependencies that your SFC might have. For example, if you require a third party library for sorting or communication with an API, Rollup might roll those packages into the final code if not properly configured. To continue using this recipe, you would need to configure Rollup to exclude those files from the output, then update your documentation to inform your users about these dependencies.

## Alternative Patterns

At the time this recipe was written, Vue CLI 3 was itself in beta. This version of the CLI comes with a built-in `library` build mode, which creates CommonJS and UMD versions of a component. This might be adequate for your use cases, though you will still need to make sure your package.json file points to `main` and `unpkg` properly. Also, there will be no ES6 `module` output unless that capability is added to the CLI before its release or via plugin.

## Acknowledgements

This recipe is the result of a lightning talk given by [Mike Dodge](https://twitter.com/mgdodgeycode) at VueConf.us in March 2018. He has published a utility to npm which will quickly scaffold a sample SFC using this recipe. You can download the utility, [vue-sfc-rollup](https://www.npmjs.com/package/vue-sfc-rollup), from npm. You can also [clone the repo](https://github.com/team-innovation/vue-sfc-rollup) and customize it.
