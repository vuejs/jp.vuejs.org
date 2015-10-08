title: Comparison with Other Frameworks
type: guide
order: 19
---

## Angular

何にでも当てはまるわけではないと思いますが、Angular の代わりに Vue を使用する理由がいくつかあります：

- Vue.js is much simpler than Angular, both in terms of API and design. You can learn almost everything about it really fast and get productive.

- Vue.js is a more flexible, less opinionated solution. That allows you to structure your app the way you want it to be, instead of being forced to do everything the Angular way. It's only an interface layer so you can use it as a light feature in pages instead of a full blown SPA. It gives you bigger room to mix and match with other libraries, but you are also responsible for making more architectural decisions. For example, Vue.js' core doesn't come with routing or ajax functionalities by default, and usually assumes you are building the application using an external module bundler. This is probably the most important distinction.

- Vue.js has better performance and is much, much easier to optimize, because it doesn't use dirty checking. Angular gets slow when there are a lot of watchers, because every time anything in the scope changes, all these watchers need to be re-evaluated again. Also, the digest cycle may have to run multiple times to "stabilize" if some watcher triggers another update. Angular users often have to resort to esoteric techniques to get around the digest cycle, and in some situations there's simply no way to optimize a scope with a large amount of watchers. Vue.js doesn't suffer from this at all because it uses a transparent dependency-tracking observing system with async queueing - all changes trigger independently unless they have explicit dependency relationships. The only optimization hint you'll ever need is the `track-by` param on `v-for` lists.

- Vue.js has a clearer separation between directives and components. Directives are meant to encapsulate DOM manipulations only, while Components stand for a self-contained unit that has its own view and data logic. In Angular there's a lot of confusion between the two.

Interestingly, quite a few Angular 1 issues that are non-existent in Vue are also addressed by the design decisions in Angular 2.

## React

React and Vue.js do share a similarity in that they both provide reactive & composable View components. There are, of course, many differences as well.

First, the internal implementation is fundamentally different. React's rendering leverages the Virtual DOM - an in-memory representation of what the actual DOM should look like. When the state changes, React does a full re-render of the Virtual DOM, diffs it, and then patches the real DOM.

Instead of a Virtual DOM, Vue.js uses the actual DOM as the template and keeps references to actual nodes for data bindings. This limits Vue.js to environments where DOM is present. However, contrary to the common misconception that Virtual-DOM makes React faster than anything else, Vue.js actually out-performs React when it comes to hot updates, and requires almost no hand-tuned optimization. With React, you need to implement `shouldComponentUpdate` everywhere or use immutable data structures to achieve fully optimized re-renders.

API-wise, one issue with React (or JSX) is that the render function often involves a lot of logic, and ends up looking more like a piece of program (which in fact it is) rather than a visual representation of the interface. For some developers this is a bonus, but for designer/developer hybrids like me, having a template makes it much easier to think visually about the design and CSS. JSX mixed with JavaScript logic breaks that visual model I need to map the code to the design. In contrast, Vue.js pays the cost of a lightweight data-binding DSL so that we have a visually scannable template and with logic encapsulated into directives and filters.

Another issue with React is that because DOM updates are completely delegated to the Virtual DOM, it's a bit tricky when you actually **want** to control the DOM yourself (although theoretically you can, you'd be essentially working against the library when you do that). For applications that needs ad-hoc custom DOM manipulations, especially animations with complex timing requirements, this can become a pretty annoying restriction. On this front, Vue.js allows for more flexibility and there are [multiple FWA/Awwwards winning sites](https://github.com/yyx990803/vue/wiki/Projects-Using-Vue.js#interactive-experiences) built with Vue.js.

## Ember

Ember is a full-featured framework that is designed to be highly opnionated. It provides a lot of established conventions, and once you are familiar enough with them, it can make you very productive. However, it also means the learning curve is high and the flexibility suffers. It's a tradeoff when you try to pick between an opinionated framework and a library with a loosely coupled set of tools that work together. The latter gives you more freedom but also requires you to make more architectural decisions.

That said, it would probably make a better comparison between Vue.js core and Ember's templating and object model layer:

- Vue provides unobtrusive reactivity on plain JavaScript objects, and fully automatic computed properties. In Ember you need to wrap everything in Ember Objects and manually declare dependencies for computed properties.

- Vue's template syntax harnesses the full power of JavaScript expressions, while Handlebars' expression and helper syntax is quite limited in comparison.

- Performance wise, Vue outperforms Ember by a fair margin, even after the latest Glimmer engine update in Ember 2.0. Vue automatically batches updates, while in Ember you need to manually manage run loops in performance-critical situations.

## Polymer

Polymer はさらにもう1つの Google によってスポンサーされたプロジェクトで、実際には Vue.js も同様、インスピレーションの源でした。Vue.js のコンポーネントは Polymer のカスタム要素と比較して緩く、そして両方ともとても似た開発スタイルを提供します。最大の違いは、Polymer は最新の Web Components の機能に基づいて構築されており、そしてネイティブにこれらの機能をサポートしていないブラウザでは動作せるために(パフォーマンス低下)、ささいでない polyfills を必要します。これとは対照的に、Vue.js は IE9 まで依存せずに動作します。

また、Polymer 1.0 はパフォーマンスを保証するために非常に限定的なデータバインディングのシステムしか持たされていませんでした。例えば、Polymer のテンプレートでサポートされる唯一の式は、ブール否定と単一メソッド呼び出しです。そこでの computed property の実装もまた非常に柔軟であるとは言えません。

最後に、プロダクションにデプロイする場合、Polymer の要素は vulcanizer と呼ばれる Polymer 依存のツールによってバンドルされる必要があります。一方、単一ファイルの Vue のコンポーネントは Webpack のエコシステムを提供しているすべてのものを活用でき、したがって Vue コンポーネントで ES6 や希望するあらゆる CSS プリプロセッサを簡単に利用できます。

## Riot

Riot 2.0 はコンポーネントベースの開発モデルに似たもの (Riot では "tag" と読んでいます) および、最小限の美しく設計された API を提供します。私は Riot と Vue は多くの設計哲学を共有していると考えます。しかし、Riot より若干重いにもかかわらず、Vue には Riot に対していくつかの重要な利点を提供します。

- 真に条件付きのレンダリング (Riot はすべての if のブランチをレンダリングし、単にそれらを表示/非表示にします)
- ずっとパワフルなルータ (Riot の ルーティング API は簡素すぎます)
- より成熟したツールのサポート (webpack と vue-loader をご覧ください)
- トランジションエフェクトシステム (Riot にはありません)
- よりよいパフォーマンス (Riot は実際には virtual-dom よりもダーティチェックを使うので、Angular と同様のパフォーマンスの問題をいくつか抱えています)
