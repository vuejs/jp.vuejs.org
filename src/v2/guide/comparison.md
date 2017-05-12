---
title: 他のフレームワークとの比較
type: guide
order: 29
---

これは確かにガイドの中では最も書くことが難しいページですが、私たちはこれが重要だと感じています。きっと、あなたは解決したい問題を抱えていて、その問題を解決するために他のライブラリを使ったことがあるでしょう。あなたがこのページを読んでいるのは Vue があなた特有の問題をよりよく解決することができるかどうかを知りたいからでしょう。それは私たちがあなたに答えを示したいことです。

また、私たちは偏見を避けるために多くの努力を費やしています。Vue のコアチームですので、私たちは明らかに Vue がとても好きです。私たちはいくつかの問題については Vue が世の中に存在する他のものよりもより良く解決すると考えています。もし私達がそれを信じることができなかったら、Vue のために作業をすることはなかったでしょう。しかし、私たちは公平で間違いのないようにしたいと考えています。React の代替レンダラの巨大なエコシステムや Knockout の IE6 からのブラウザサポートのように、他のライブラリが著しく優れていると示される部分に関して、私たちはそれらをできる限り載せるようにしています。

さらに、私たちは**あなた**がこのドキュメントを最新の情報に保っていただけることを望みます。なぜなら、JavaScript の世界は速く動いているからです！もし、あなたが正確ではない部分や、あまり正しくないように見える部分に気がついたら、[Issue を開いて](https://github.com/vuejs/vuejs.org/issues/new?title=Inaccuracy+in+comparisons+guide)教えてください。

## React

React と Vue には多くの類似点があります。それらは両方とも：

- 仮想 DOM を活用しています
- リアクティブで組み合わせ可能なビューのコンポーネントを提供しています
- コアライブラリに焦点をあわせることに努めており、ルーティングやグローバルの状態管理のような関心事は関連ライブラリに担当させています

スコープがとてもよく似ているため、この比較の改善に他よりも多くの時間をかけています。私たちは技術的な正確さだけでなく、バランスも保証したいと考えています。例えば、React のエコシステムの豊かさや、カスタムレンダラの豊富さのように、私たちは React が Vue よりも優れている点を示します。

ですので、調査対象の多くはある程度主観的なため、ある React ユーザーには、比較が Vue に偏っているようにみえるのはそれは必然です。私たちは様々な技術的な好みが存在することを認め、そしてあなたの好みが私たちのものと一致する場合は、Vue は潜在的によりフィットする可能性があるため、この比較は主に理由を概説することを目的としています。

React のコミュニティは、私たちがこのバランスを達成するのを[手助けしてくださいました](https://github.com/vuejs/vuejs.org/issues/364)。React チームの Dan Abramov 氏には心から感謝いたします。彼にはとても寛容に時間を費やしていただき、私たちが[お互いに最終結果に満足するまで](https://github.com/vuejs/vuejs.org/issues/364#issuecomment-244575740)このドキュメントを改善するための数多くの助言をいただきました。

### Performance

Both React and Vue offer comparable performance in most commonly seen use cases, with Vue usually slightly head due to its lighter-weight Virtual DOM implementation. If you are interested in numbers, you can check out this [3rd party benchmark](https://rawgit.com/krausest/js-framework-benchmark/master/webdriver-ts/table.html) which focuses on raw rendering/updating performance. Note that this does not take complex component structures into account, so should only be considered a reference rather than a verdict.

#### Optimization Efforts

In React, when a component's state changes, it triggers the re-render of the entire component sub-tree, starting at that component as root. To avoid unnecessary re-renders of child components, you need to either use `PureComponent` or implement `shouldComponentUpdate` whenever you can. You may also need to use immutable data structures to make your state changes more optimization-friendly. However, in certain cases you may not be able to rely on such optimizations because `PureComponent/shouldComponentUpdate` assumes the entire sub tree's render output is determined by the props of the current component. If that is not the case, then such optimizations may lead to inconsistent DOM state.

In Vue, a component's dependencies are automatically tracked during its render, so the system knows precisely which components actually need to re-render when state changes. Each component can be considered to have `shouldComponentUpdate` automatically implemented for you, without the nested component caveats.

### HTML & CSS

React では、すべてのものは単なる JavaScript で、これはとてもシンプルで洗練されているように聞こえます。Not only are HTML structures expressed via JSX, the recent trends also tend to put CSS management inside JavaScript as well. This approach has its own benefits, but also comes with various trade-offs that may not seem worthwhile for every developer.

Vue embraces classic web technologies and builds on top of them. To show you what that means, we'll dive into some examples.

#### JSX vs Templates

React では、すべてのコンポーネントは JSX を用いた 描画関数 (render) の中でそれらの UI を表現します。JSX とは JavaScript の中で用いることのできる、宣言的で XML のような構文です。

JSX を伴う 描画関数にはいくつかの優位な点があります：

- You can leverage the power of a full programming language (JavaScript) to build your view. This includes temporary variables, flow controls, and directly referencing JavaScript values in scope.
- JSX のためのツールのサポート（例えば、Lint、型チェック、エディタのオートコンプリート）は現在 Vue のテンプレートで利用可能なものよりもいくつかの点で優れています。

Vue は、[描画関数](render-function.html)と、さらに [JSX のサポート](render-function.html#JSX)を備えています、なぜなら、あなたは時折その力を必要とするためです。しかしながら、デフォルトのエクスペリエンスとして、より単純な代替手段としてテンプレートを提供しており、Any valid HTML is also a valid Vue template, and this leads to a few advantages of its own:

- For many developers who have been working with HTML, templates simply feel more natural to read and write. The preference itself can be somewhat subjective, but if it makes the developer more productive then the benefit is objective.
-  HTML-based templates make it much easier to progressively migrate existing applications to take advantage of Vue's reactivity features.
- It also makes it much easier for designers and less experienced developers to parse and contribute to the codebase.
- You can even use pre-processors such as Pug (formerly known as Jade) to author your Vue templates.

Some argue that you'd need to learn an extra DSL (Domain-Specific Language) to be able to write templates - we believe this difference is superficial at best. First, JSX doesn't mean the user don't need to learn anything - it's additional syntax on top of plain JavaScript, so it's easy for anyone familar with JavaScript to learn, but saying it's essentially free is misleading. Similarly, template is just additional syntax on top of plain HTML and thus has very low learning cost for those who are already familiar with HTML. With the DSL we are also able to help the user get more done with less code (e.g. `v-on` modifiers). The same task can involve a lot more code when using plain JSX or render functions.

On a higher level, we can divide components into two categories: presentational ones and logical ones. We recommend using templates for presentational components and render function / JSX for logical ones. The percentage of these components depends on the type of app you are building, but in general we find presentational ones to be much more common.

#### コンポーネントスコープ CSS（Scoped CSS）

あなたがコンポーネントを複数のファイルに分けない限り（例えば、[CSS モジュール](https://github.com/gajus/react-css-modules)を使うなど）、React で CSS のスコープを限定するときには CSS-in-JS ソリューション経由でしばし行われます。そこには競合するソリューションが多数あり、それぞれ独自に注意事項があります。

共通の問題は、hover 状態、メディアクエリや、疑似セレクタのようなより複雑な機能はすべて、CSS がすでに行っていることを再発明するために多くの依存を必要とするか、またはそれらは単にサポートされていません。 CSS-in-JS では慎重に最適化されていないと、実行時の性能にはほとんど影響を与えません。最も重要なのは、通常の CSS を作成した経験から逸脱していることです。

その一方で Vue は、[単一ファイルコンポーネント](single-file-components.html)の中で CSS のすべての機能を使用できるようにしています：

``` html
<style scoped>
  @media (min-width: 250px) {
    .list-container:hover {
      background: orange;
    }
  }
</style>
```

任意に付与できる `scoped` 属性は、要素に一意な属性（`data-v-21e5b78` のようなもの）を付与し、`.list-container:hover` を `.list-container[data-v-21e5b78]:hover` のようなものにコンパイルすることで、この CSS のスコープをあなたのコンポーネントに限定します。

すでに CSS モジュールに精通している場合、Vue の単一ファイルコンポーネントには[ファーストクラスのサポート](http://vue-loader.vuejs.org/en/features/css-modules.html)もあります。

最後に、ちょうど HTML のように、あなたには任意の好きなプリプロセッサ（または、ポストプロセッサ）を使って CSS を書くという選択肢、それらのエコシステムの既存のライブラリを活用できます。あなたがビルドサイズやアプリケーションの複雑さの増加を引き起こす特殊なライブラリをインポートするのではなく、ビルド時に色の操作を行うようなデザイン中心の運用を行う事ができるようにしています。

### 規模

#### スケールアップ

大きなアプリケーションのために、Vue も React も強力なルーティングの解法を提供しています。React コミュニティは状態管理という観点でとても革新的な解法を持っています（例えば、Flux/Redux）。これらの状態管理のパターンと、[さらに Redux 自体](https://github.com/egoist/revue)は簡単に Vue のアプリケーションと統合することができます。実際に、Vue はこのモデルをさらに一歩進めた [Vuex](https://github.com/vuejs/vuex) という、Vue と深く統合されている Elm に触発された状態管理の解法をもっており、私たちはそれがより優れた開発体験をもたらすと考えています。

これらの間にあるもう 1 つの重要な違いは、Vue における状態管理やルーティング（や[その他の関心事](https://github.com/vuejs)）のための関連ライブラリはすべて公式にサポートされていて、コアのライブラリとともに更新され続けているということです。React はそのような関心事はコミュニティにまかせており、より断片的なエコシステムを作り上げています。それはより大衆的ではありますが、React のエコシステムは Vue のそれを大きく上回って豊かです。

最後に、Vue は [CLI によるプロジェクト生成ツール](https://github.com/vuejs/vue-cli)を提供しており、それによってあなたは好きなビルドシステムを使った新しいプロジェクトをとても簡単に始めることができます。ビルドシステムには、[Webpack](https://github.com/vuejs-templates/webpack)、[Browserify](https://github.com/vuejs-templates/browserify)、さらに[ビルドシステム無し](https://github.com/vuejs-templates/simple)などがあります。React も [create-react-app](https://github.com/facebookincubator/create-react-app) でこの領域に取り組んでいますが、現在いくつかの制限があります：

- Vue のプロジェクトテンプレートが [Yeoman](http://yeoman.io/) ライクなカスタマイズ機能を持つ一方で、それはプロジェクトの生成においてどのような設定も許可していません。
- Vue が様々な目的やビルドシステムのために広い種類のテンプレートを提供している一方で、それはシングルページアプリケーションを構築することを仮定した 1 つのテンプレートしか提供していません。
- ユーザーが作ったテンプレートからプロジェクトを生成することは、開発スタイルを決定する前の企業の環境では特に役立ちますが、そのようなことはできません。

しかしながら、これらの制限は create-react-app のチームによって意図された設計上の決定で、それによる優位性も確かにあります。例えば、あなたのプロジェクトの要件がとても単純で、あなたがビルドプロセスをカスタマイズするために"脱出"することを決して必要としていなければ、あなたはそれを依存として更新することができるでしょう。あなたはこの[哲学の違いをここで](https://github.com/facebookincubator/create-react-app#philosophy)より詳しく読むことができます。

#### スケールダウン

React はその急な学習曲線で有名です。あなたが本当に始めることができるようになるまでに、JSX とおそらく ES2015+ について知る必要があります。なぜなら多くのコード例が React の class 構文を使っているからです。あなたはさらにビルドシステムについて学ぶ必要があります。なぜなら、技術的には Babel Standalone を使ってコードをブラウザでその場でコンパイルすることは可能ですが、プロダクション環境では絶対に適していません。

React ほどではないかもしれませんが、Vue は単にうまく規模を大きくできますし、一方で、jQuery のように規模を小さくすることもできます。そうです - あなたはページの中に 1 つの script タグを放り込むだけで良いのです：

``` html
<script src="https://unpkg.com/vue/dist/vue.js"></script>
```

これであなたは Vue のコードを書き始めることができますし、後ろめたい思いをしたり性能問題について心配したりすることなく、ミニファイ（minify）版をプロダクション環境へ設置することもできます。

あなたは Vue を始めるにあたって JSX、ES2015 やビルドシステムについて知る必要はないので、重要なアプリケーションをビルドするための十分な学習をするために[ガイド](../guide)を読むのにはたいてい一日もかからないでしょう。

### ネイティブレンダリング

React Native によって同じ React コンポーネントモデルを使って iOS や Android のためのネイティブ描画を行うアプリを書くことができます。これは開発者にとっては素晴らしいことで、あなたは複数のプラットフォームをまたいであなたのフレームワークの知識を適用することができます。この点において Vue は、アリババグループによって開発されていて、JavaScript フレームワークのランタイムとして Vue が用いられている、クロスプラットフォームな UI フレームワークの [Weex](https://alibaba.github.io/weex/) と公式に協業しています。これが意味するのは、Weex とともに用いることにより、あなたは同じ Vue コンポーネントの構文で、ブラウザの描画だけではなく、iOS や Android のネイティブ描画を行うことのできるコンポーネントを作れるということです！

今の段階では、Weex はまだ活発に開発が続いており、React Native ほど熟しておらず、実際に使われているわけではありませんが、その開発は世界で最も大きな e コマースの製品要件に基づいており、そして Vue のチームは Vue の開発者のための円滑な体験を保証するために Weex のチームと活発に協業するつもりです。

### MobX と用いた場合

MobX は React コミュニティ内でとても人気になってきており、実はそれは Vue のリアクティブシステムとほぼ同じものを使っています。限られた範囲内では、React + MobX の流れはより冗長な Vue として考えることができるので、もしあなたがその組み合わせを使って、それを楽しんでいるのならば、Vue を使ってみるのは、おそらく次のステップとして理にかなっているでしょう。

## AngularJS (Angular 1)

いくつかの Vue の構文は Angular と非常に良く似ているように見えることでしょう（例えば、`v-if` と `ng-if`）。これは Angular が解決した多くのものがあるのと、最初期の Vue の開発の際にインスピレーションを受けているためです。しかしながら、Angular から導入された多くの痛みもあり、それらは Vue が大きな改善を提供しようと試みた点でもあります。

### 複雑性

API と設計の両方の観点から、Vue は Angular 1 と比較してとても単純です。重要なアプリケーションを構築するために十分学ぶのには大抵 1 日もかからないでしょう。これは Angular 1 には当てはまらない点です。

### 柔軟性とモジュール性

Angular 1 にはあなたのアプリケーションがどのような構成になるべきかという点について強い思想が反映されていますが、対して Vue はより柔軟で、モジュール組み立て式な解決を図っています。このことが Vue を広い種類のプロジェクトにより適合可能にしている一方で、私たちは、時にはあなたのためにいくつかの決断をすることは役に立つと認識しています、ですので、あなたはただコーディングを始めることもできます。

これは私たちが、1 分以内にセットアップ可能で、さらに、Hot Module Reload、Lint、CSS 抽出などといった高度な機能を使用可能にする、[Webpack のテンプレート](https://github.com/vuejs-templates/webpack)を提供している理由になります。

### データバインディング

Angular 1 がスコープ間による双方向バインディングを使用している一方で、Vue はコンポーネント間では一方向のデータフローを行うようになっています。これは小さくないアプリケーションにおいてデータの流れを推測することをより簡単にします。

### ディレクティブ vs コンポーネント

Vue はディレクティブとコンポーネントの間に明確な線引きをしています。ディレクティブは DOM の操作のみをカプセル化するように意図されている一方で、コンポーネントは自身のビューとデータロジックを持つ独立した構成単位です。Angular では、それらの間には多くの混乱があります。

### 性能

Vue は Dirty Checking を使用していないため、より良い性能を発揮し、さらに、もっともっと簡単に最適化できます。Angular 1 はスコープ内の何かが変更されると、毎回すべてのウォッチャーがもう一度再評価される必要があるため、たくさんのウォッチャーが存在する時は遅くなってしまいます。さらに、ダイジェストサイクルは、もしいくつかのウォッチャーが追加の更新をトリガしたら、"安定"のために複数回の実行が必要となる場合もあります。Angular のユーザーはダイジェストサイクルを回避するために難解なテクニックによく頼る必要がありますし、いくつかの状況では、多くのウォッチャーが存在する状況でスコープを最適化する単純な方法がない場合もあります。

Vue では、非同期キューイングを用いた透過的な依存追跡監視システムを使用しているため、このことで苦しむことはまったくありません。すべての変更は明示的な依存関係を持たない限り独立してトリガされます。

興味深いことに、これらの Angular 1 の問題点に Angular 2 と Vue がどのように対処しているかという点について、いくつかとてもよく似ている点があります。

## Angular (Formerly known as Angular 2)

Angular 2 は本当に Angular 1 から完全に異なるフレームワークなので、私たちは新しい Angular のために分割した節を設けています。例えば、それは第一級のコンポーネントシステムを特徴として持っており、多くの詳細な実装は完全に書き換えられており、そして、API もまた抜本的に変更されています。

### TypeScript

Angular essentially requires using TypeScript, given that almost all its documentation and learning resources are TypeScript-based. TypeScript has its obvious benefits - static type checking can be very useful for large-scale applications, and can be a big productivity boost for developers which backgrounds in Java and C#.

However, not everyone wants to use TypeScript. In many smaller-scale use cases, introducing a type system may result in more overhead than productivity gain. In those cases you'd be better off going with Vue instead, since using Angular without TypeScript can be challenging.

Finally, although not as deeply integrated with TypeScript as Angular is, Vue also offers [official typings](https://github.com/vuejs/vue/tree/dev/types) and [official decorator](https://github.com/vuejs/vue-class-component) for those who wish to use TypeScript with Vue. We are also actively collaborating with the TypeScript and VSCode teams at Microsoft to improve the TS/IDE experience for Vue + TS users.

### サイズと性能

性能面では、2 つのフレームワークは非常に速く、判決するための現実世界のユースケースでの十分なデータはありません。しかしながら、もしあなたがいくつかの数字を見ることを決意したのなら、この[サードパーティのベンチマーク](http://stefankrause.net/js-frameworks-benchmark4/webdriver-ts/table.html)から Vue 2.0 は Angular 2 よりも優位なようです。

Recent versions of Angular, with AOT compilation and tree-shaking, have been able to get its size down considerably. However, a full-featured Vue 2 project with Vuex + vue-router included (~30kb gzipped) is still significantly lighter than an out-of-the-box, AOT-compiled application generated by `angular-cli` (~130kb gzipped).

### 柔軟性

Vue は Angular 2 よりもずっとあなたのやり方には口出しすることはありません（less opinionated）、様々なビルドシステムのための公式サポートを提供していますし、あなたがあなたのアプリケーションをどのように構成するかについては制限していません。多くの開発者はこの自由を楽しんでいますし、一方で任意のアプリケーションをビルドするためのただ 1 つの正しいやり方を持つことを好む人もいます。

### 学習曲線

Vue を始めるために、あなたは HTML と ES5 JavaScript（つまり、プレーンな JavaScript）をよく知るだけで良いです。これらの基本的なスキルがあれば、[ガイド](../guide)を読むのに一日もかからずに重要なアプリケーションの構築を始めることができます。

Angular の学習曲線はもっと急です。The API surface of the framework is simply huge and the user will need to familiarize yourself with a lot more concepts before getting productive. Obviously, the complexity of Angular is largely due to its design goal of targeting only large, complex applications - but that does make the framework a lot more difficult for less-experienced developers to pick up.

## Ember

Ember はフル機能のフレームワークでとても強い思想（highly opinionated）の下で設計されています。それはすでに用意されたたくさんのやり方を提供しており、あなたがそれらを十分使いこなせれば、高い生産性を発揮できることでしょう。しかしながら、それは学習曲線が高く、柔軟性に乏しいことも意味しています。これは強い思想を持つフレームワークか、関係の弱いツールの集合とともに使うライブラリのどちらかを選ぼうとする時のトレードオフになります。後者はあなたにより多くの自由を与えますが、あなたはアーキテクチャ上の決定をより多くする必要もあります。

ですので、Vue のコアと Ember の[テンプレート](https://guides.emberjs.com/v2.10.0/templates/handlebars-basics/)と[オブジェクトモデル](https://guides.emberjs.com/v2.10.0/object-model/)レイヤーを比較することは比較をより良いものにすることでしょう：

- Vue はプレーンな JavaScript 上で控えめなリアクティビティと完全に自動的な算出プロパティを提供しています。Ember では、あなたはすべてを Ember のオブジェクトの中にラップし、算出プロパティの依存を手動で定義する必要があります。

- Vue のテンプレート構文は JavaScript の式の完全な力を利用しているのに対し、Handlebars の式とヘルパの構文は意図的にかなり制限されています。

- 性能面では、Vue は大きく差をつけて Ember よりも優れています、Ember 2.0 で最新の Glimmer エンジンのアップデートがされた後でもです。Ember では性能が重要な状況において、手動でランループ（run loop）を管理する必要がある一方で、Vue は自動的にバッチ更新を行います。

## Knockout

Knockout は MVVM と依存追跡の分野における先駆者で、そのリアクティブシステムは Vue のものととてもよく似ています。その[ブラウザサポート](http://knockoutjs.com/documentation/browser-support.html)もまた他の機能を考慮しても特にすばらしく、IE6 からをサポートしています！Vue は一方で、IE9 以上のみをサポートしています。

しかしながら、時間とともに Knockout の開発は遅くなっており、少々古さを見せ始めています。例えば、そのコンポーネントシステムはライフサイクルフックの一式が欠けており、とてもよくあるユースケースにもかかわらず、コンポーネントへ子要素を渡すためのインタフェースは [Vue のもの](components.html#Content-Distribution-with-Slots)と比較して少々ぎこちないものに感じられます。

さらに、あなたが興味を持っているかもしれない API デザインにも哲学的な違いがあるようで、[単純な TODO リスト](https://gist.github.com/chrisvfritz/9e5f2d6826af00fcbace7be8f6dccb89)の作成をそれぞれどのように扱うのかによって実演することができます。これは確かに少々主観的ですが、多くの人は Vue の API はより複雑でなく、よく構造化されていると考えています。

## Polymer

Polymer は Google がスポンサーをしているもう 1 つのプロジェクトで、その上実は Vue がインスピレーションを受けていたものでした。Vue のコンポーネントは Polymer の Custom Elements と緩く比較することができ、さらに両方ともとてもよく似た開発スタイルを提供しています。最も大きな違いは Polymer が最新の Web Component の機能を基に構築されており、ネイティブでこれらの機能をサポートしていないブラウザ上で（より劣った性能で）動かすためには小さくない Polyfill を必要とする点です。それと比較して、Vue は IE9 まで依存や Polyfill 無しで動きます。

Polymer 1.0 では、その開発チームは性能を補うためにデータバインディングシステムもかなり制限しました。例えば、Polymer のテンプレートは真偽値の反転と単一のメソッド呼び出しの構文のみしかサポートされていません。その算出プロパティの実装についてもあまり柔軟ではありません。

Polymer の Custom Elements は HTML ファイルの中に書くことになりますが、これはつまり、あなたはプレーンな JavaScript/CSS（と現在のブラウザによってサポートされている言語機能）しか書けないということです。それと比べて、Vue の単一ファイルコンポーネントでは、あなたが欲する ES2015+ や任意の CSS プリプロセッサを簡単に使うことができます。

プロダクション環境にデプロイする時、Polymer はすべてを HTML Imports によってその場で読み込むことを推奨しています、これはブラウザがその仕様を実装していることと、サーバーとクライアントの両方の HTTP/2 サポートを前提としています。これはあなたが対象としているユーザやデプロイ環境によっては適しているかもしれないし、そうではないかもしれません。これが適していない場合は、あなたは Polymer の要素をバンドルするために Vulcanizer と呼ばれる特別なツールを使う必要があるでしょう。この面では、Vue は遅延読み込みのためにアプリケーションバンドルの一部を簡単に分割することを目的として、Webpack のコード分割機能を使い、非同期コンポーネントの機能を統合することができます。これはアプリのすばらしい読み込み性能を維持しつつ、古いブラウザとの互換性を保証しています。

さらに、Vue と、Custom Elements や Shadow DOM のスタイルカプセル化のような Web Component 仕様の深い統合を提供することは全体的に適しています - しかしながら今の段階では、私たちは本格的にコミットする前に、その仕様が熟し、すべての主要なブラウザ上に広く実装されるのをまだ待っています。

## Riot

Riot 2.0 はよく似たコンポーネントベースの開発モデル（"タグ"と Riot では呼ばれています）を提供しており、必要最小限の美しく設計された API を持っています。Riot と Vue はおそらくその設計哲学の多くが共通しているのでしょう。しかしながら、Riot よりも少し重いにも関わらず、Vue はいくつか著しく優れた点を持っています：

- [トランジションエフェクトシステム](transitions.html)。Riot にはありません。
- ずっと強力なルータ。Riot のルーティング API は極めて最小限です。
- より優れた性能。Riot は 仮想 DOM を使用しているというよりむしろ[DOM ツリーをトラバース](http://riotjs.com/compare/#virtual-dom-vs-expressions-binding)しているため、Angular 1 と同じ性能問題に苦しめられています。
- より熟成したツールのサポート。Vue は [Webpack](https://github.com/vuejs/vue-loader)、[Browserify](https://github.com/vuejs/vueify) の公式サポートを提供していますが、対して Riot はビルドシステムの統合についてはコミュニティのサポートに頼っています。
