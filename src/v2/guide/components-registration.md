---
title: コンポーネントの登録
updated: 2019-07-22
type: guide
order: 101
---

> このページは [コンポーネントの基本](components.html) を読まれていることが前提になっています。コンポーネントを扱った事のない場合はこちらのページを先に読んでください。

<div class="vueschool"><a href="https://vueschool.io/lessons/global-vs-local-components?friend=vuejs" target="_blank" rel="sponsored noopener" title="Free Vue.js Component Registration lesson">Vue School で無料の動画レッスンを見る</a></div>

## コンポーネント名

コンポーネントを登録するときは、いつでも名前が与えられます。例えば、グローバル登録の場合:

```js
Vue.component('my-component-name', { /* ... */ })
```

コンポーネント名は `Vue.component` の第一引数です。

コンポーネントの命名は、コンポーネントの使用箇所に左右されます。(文字列テンプレート、または[単一ファイルコンポーネント](single-file-components.html)ではなく) DOM 上で直接コンポーネントを使用する場合は、[W3C rules](https://html.spec.whatwg.org/multipage/custom-elements.html#valid-custom-element-name) に従ったカスタムタグ名(全て小文字で、ハイフンが含まれていること)を推奨します。これは、既に存在する、そして将来定義される HTML 要素との衝突を防止するのに役立ちます。

[スタイルガイド](../style-guide/#基底コンポーネントの名前-強く推奨)では、コンポーネント名についてのその他の推奨項目を見ることができます。

### 命名のケース (Name Casing)

コンポーネント名を定義する時、2 つの選択肢があります:

#### ケバブケース (kebab-case)

```js
Vue.component('my-component-name', { /* ... */ })
```

ケバブケースでコンポーネント名を定義する場合、そのカスタム要素を参照する時も同様に、 `<my-component-name>` のように、ケバブケースを用いなければいけません。

#### パスカルケース (PascalCase)

```js
Vue.component('MyComponentName', { /* ... */ })
```

パスカルケースでコンポーネントを定義する場合、そのカスタム要素の参照には、どちらのケースも用いることができます。これは、  `<my-component-name>` と `<MyComponentName>` のどちらも許容されることを意味します。ただし、DOM 内 (すなわち、文字列でないテンプレート) に直接使用する場合には、ケバブケースの名前のみが有効なので注意してください。

## グローバル登録

ここまでは `Vue.component` だけを使ってコンポーネントを作成しました:

```js
Vue.component('my-component-name', {
  // ... options ...
})
```

これらのコンポーネントは **グローバル登録** されています。これは、登録後に作成された、全てのルート Vue インスタンス(`new Vue`)のテンプレート内で使用できることを意味します。例えば:

```js
Vue.component('component-a', { /* ... */ })
Vue.component('component-b', { /* ... */ })
Vue.component('component-c', { /* ... */ })

new Vue({ el: '#app' })
```

```html
<div id="app">
  <component-a></component-a>
  <component-b></component-b>
  <component-c></component-c>
</div>
```

これは全てのサブコンポーネントにも適用されます。これら 3 つのコンポーネント全てが _内部で相互に_ 使用可能になることを意味します。

## ローカル登録
多くの場合、グローバル登録は理想的ではありません。例えば Webpack のようなビルドシステムを利用しているときに、グローバルに登録した全てのコンポーネントは、たとえ使用しなくなっても、依然として最終ビルドに含まれてしまうことでしょう。これは、ユーザがダウンロードしなくてはならない JavaScript のファイルサイズを不要に増加させてしまいます。

このような場合に、コンポーネントを素の JavaScript オブジェクトとして定義することができます:

```js
var ComponentA = { /* ... */ }
var ComponentB = { /* ... */ }
var ComponentC = { /* ... */ }
```

次に、`components` オプション内に使いたいコンポーネントを定義します:

```js
new Vue({
  el: '#app',
  components: {
    'component-a': ComponentA,
    'component-b': ComponentB
  }
})
```

`components` オブジェクトのそれぞれのプロパティは、キーはカスタム要素の名前になり、一方、値はコンポーネントのオプションオブジェクトを含みます。

**ローカル登録されたコンポーネントは、他のサブコンポーネント内では使用_できない_** ことに注意して下さい。例えば、`ComponentA` を `ComponentB` 内で使用可能にしたいときは、このように使う必要があります:

```js
var ComponentA = { /* ... */ }

var ComponentB = {
  components: {
    'component-a': ComponentA
  },
  // ...
}
```

もしくは、Babel と Webpack のようなものを用いて ES2015 モジュールを利用しているならば、このようになるでしょう:

```js
import ComponentA from './ComponentA.vue'

export default {
  components: {
    ComponentA
  },
  // ...
}
```

ES2015+ では `ComponentA` のような変数名をオブジェクト内部に配置することは `ComponentA: ComponentA` の省略記法にあたり、変数の名前は次のどちらも意味することに注意して下さい:

- テンプレート内で使われるカスタム要素名
- コンポーネントオプションを含んだ変数の名前

## モジュールシステム

もし、 `import`/`require` を用いたモジュールシステムを使用しないなら、このセクションをスキップすることができます。使用する場合、いくつかの特別な手順とヒントを用意しています。

### モジュールシステム内のローカル登録

ここを見ているということは、おそらくあなたは Babel と Webpack のようなものを用いて、モジュールシステムを使用していることでしょう。もしそうなら、それぞれのコンポーネントをファイルとして配置する `components` ディレクトリを作成することを推奨します。

ローカル登録をする前に、使いたいコンポーネントごとにインポートする必要があります。例えば、`ComponentB.js` または `ComponentB.vue` ファイルを仮定して:

```js
import ComponentA from './ComponentA'
import ComponentC from './ComponentC'

export default {
  components: {
    ComponentA,
    ComponentC
  },
  // ...
}
```

これで `ComponentA` と `ComponentC` の両方が `ComponentB` のテンプレート内で使えるようになります。

### 基底コンポーネントの自動グローバル登録

コンポーネントのうち多くは比較的共通して、 input や button のような要素をラップするだけです。時にこれらを [基底コンポーネント](../style-guide/#基底コンポーネントの名前-強く推奨) と呼び、これらは複数のコンポーネントを横断して頻繁に用いられます。

多数のコンポーネントが多数の基底コンポーネントを含めた結果:

```js
import BaseButton from './BaseButton.vue'
import BaseIcon from './BaseIcon.vue'
import BaseInput from './BaseInput.vue'

export default {
  components: {
    BaseButton,
    BaseIcon,
    BaseInput
  }
}
```

テンプレートでは、比較的少ないマークアップをサポートします:

```html
<BaseInput
  v-model="searchText"
  @keydown.enter="search"
/>
<BaseButton @click="search">
  <BaseIcon name="search"/>
</BaseButton>
```

幸いにも、Webpack (または 内部的に Webpack を利用している [Vue CLI 3+](https://github.com/vuejs/vue-cli) ) を使用しているなら、 このような非常に汎用的な基底コンポーネントのグローバル登録に `require.context` を用いることができます。次に示す例は、アプリケーションのエントリファイル(例: `src/main.js` )で、基底コンポーネントをグローバルにインポートするコードです:

```js
import Vue from 'vue'
import upperFirst from 'lodash/upperFirst'
import camelCase from 'lodash/camelCase'

const requireComponent = require.context(
  // コンポーネントフォルダの相対パス
  './components',
  // サブフォルダ内を調べるかどうか
  false,
  // 基底コンポーネントのファイル名に一致させるのに使う正規表現
  /Base[A-Z]\w+\.(vue|js)$/
)

requireComponent.keys().forEach(fileName => {
  // コンポーネント設定を取得する
  const componentConfig = requireComponent(fileName)

  // コンポーネント名をパスカルケース (PascalCase) で取得する
  const componentName = upperFirst(
    camelCase(
      // フォルダの深さに関わらずファイル名を取得する
      fileName
        .split('/')
        .pop()
        .replace(/\.\w+$/, '')
    )
  )


  // コンポーネントをグローバル登録する
  Vue.component(
    componentName,
    // `export default` を使ってコンポーネントがエクスポートされた場合に存在する
    // `.default` でコンポーネントオプションを期待していて
    // 存在しない場合にはモジュールのルートにフォールバックします。
    componentConfig.default || componentConfig
  )
})
```

**(`new Vue` を使って)ルート Vue インスタンスを作成するより前に、グローバル登録を行う必要があることを** 覚えておいてください。[この例は](https://github.com/chrisvfritz/vue-enterprise-boilerplate/blob/master/src/components/_globals.js)実際のプロジェクトの文脈における、このパターンの一例です。
