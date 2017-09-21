---
title: TypeScript のサポート
updated: 2017-09-03
type: guide
order: 404
---

## TS と Webpack 2ユーザに向けた、2.2 以降における重要な変更のお知らせ

Vue 2.2 からは 配布ファイルを ES モジュール形式でエクスポートするようにしました。これは webpack 2 が標準で使用する形式です。残念ながら、この変更は意図しないところで破壊的変更をもたらしてしまいました。なぜなら TypeScript と webpack 2 を組み合わせた時、 `import Vue = require('vue')` は Vue そのものではなく総合的な ES モジュールのオブジェクトを返すからです。

将来的には全ての公式で提供する型宣言を、ES モジュール形式でエクスポートするようにしようと考えています。将来性を考えた[推奨構成](#推奨構成) を以下に示しているのでご覧ください。

## NPM パッケージ内の公式型宣言

静的型システムは、特にアプリケーションが成長するに伴い、多くの潜在的なランタイムエラーを防止するのに役立ちます。そのため、Vue は [TypeScript](https://www.typescriptlang.org/) 向けに[公式型宣言](https://github.com/vuejs/vue/tree/dev/types)を提供しており、Vue コアだけでなく [Vue Router](https://github.com/vuejs/vue-router/tree/dev/types) と [Vuex](https://github.com/vuejs/vuex/tree/dev/types) も同様に提供しています。

これらは [NPM に公開](https://cdn.jsdelivr.net/npm/vue/types/)されており、そして最新の TypeScript は NPM パッケージ内の型宣言を解決する方法を知っています。つまり、NPM でインストールした時、TypeScript を Vue と共に使うための追加のツールを必要としません。

## 推奨構成

``` js
// tsconfig.json
{
  "compilerOptions": {
    // ... 他のオプションは除外しています
    "allowSyntheticDefaultImports": true,
    "lib": [
      "dom",
      "es5",
      "es2015.promise"
    ]
  }
}
```

`allowSyntheticDefaultImports` オプションにより以下の記述が可能となることに留意してください:

``` js
import Vue from 'vue'
```

これは以下の記述の代わりとなるものです:

``` js
import Vue = require('vue')
```

推奨しているのは前者（ES モジュール構文）です。なぜなら推奨している素のES モジュールのやり方と変わらず、そして将来的に全ての公式で提供する型宣言を ES モジュール形式とするように移行しようと考えているからです。

加えて、もし webpack 2 と共に TypeScript を使用しているならば、以下の設定も推奨します:

``` js
{
  "compilerOptions": {
    // ... 他のオプションは除外しています
    "module": "es2015",
    "moduleResolution": "node"
  }
}
```

このようにすることで TypeScript に対して ES モジュールの import 文をそのまま残すように伝えることができ、そうすると、webpack 2 は ES モジュール をベースとした tree-shaking を利用できます。

より詳細なことについては [TypeScript compiler options docs](https://www.typescriptlang.org/docs/handbook/compiler-options.html) を見てください。

## Vue の型宣言の利用

Vue の型定義はたくさんの便利な[型宣言](https://github.com/vuejs/vue/blob/dev/types/index.d.ts)をエクスポートしています。例えば、以下は (`.vue` ファイルにおいて) エクスポートされたコンポーネントオプションオブジェクトにアノテートします:

``` ts
import Vue, { ComponentOptions } from 'vue'

export default {
  props: ['message'],
  template: '<span>{{ message }}</span>'
} as ComponentOptions<Vue>
```

## クラススタイルの Vue コンポーネント

Vue のコンポーネントオプションは容易に型でアノテートできます:

``` ts
import Vue, { ComponentOptions }  from 'vue'

// コンポーネントの型を宣言
interface MyComponent extends Vue {
  message: string
  onClick (): void
}

export default {
  template: '<button @click="onClick">Click!</button>',
  data: function () {
    return {
      message: 'Hello!'
    }
  },
  methods: {
    onClick: function () {
      // TypeScriptは `this` が MyComponent 型で、
      // `this.message` が文字列であることを知っています
      window.alert(this.message)
    }
  }
// エクスポートされたオプションオブジェクトに
// MyComponent 型を明示的にアノテートする必要があります
} as ComponentOptions<MyComponent>
```

残念ながら、ここではいくつかの制限があります:

- __TypeScript は、Vue の API においてすべての型を推論することはできません。__ 例えば、`data` 関数で返された `message` プロパティが `MyComponent` インスタンスに追加されることはわかりません。これは、数値やブール値を `message` に代入すると、リンタとコンパイラは文字列でなければならないというエラーを出力することはできません。
- この制限のため、__このようなアノテートする型は冗長になります。__ 文字列として `message` を手動で宣言しなければならない唯一の理由は、TypeScript がこの場合に型を推論することができないからです。

幸いにも、[vue-class-component](https://github.com/vuejs/vue-class-component)は、これらの問題を両方解決できます。これは公式ライブラリで、`@Component` デコレータでコンポーネントをネイティブな JavaScript クラスとして宣言することができます。例として、上記のコンポーネントを書き直してみましょう:

``` ts
import Vue from 'vue'
import Component from 'vue-class-component'

// @Component デコレータはクラスが Vue コンポーネントであることを示します
@Component({
  // ここではすべてのコンポーネントオプションが許可されています
  template: '<button @click="onClick">Click!</button>'
})
export default class MyComponent extends Vue {
  // 初期データはインスタンスプロパティとして宣言できます
  message: string = 'Hello!'

  // コンポーネントメソッドはインスタンスメソッドとして宣言できます
  onClick (): void {
    window.alert(this.message)
  }
}
```

この構文では、コンポーネントの定義が短くなるだけでなく、明示的なインタフェース宣言がなくても `message` と `onClick` の型を推論することができます。この戦略では、算出プロパティ、ライフサイクルフック、描画関数の型を扱うこともできます。詳細な使用方法については、[vue-class-component のドキュメント](https://github.com/vuejs/vue-class-component#vue-class-component)を参照してください。

## Vue プラグインの型定義

プラグインは Vue のグローバル/インスタンスプロパティやコンポーネントオプションを追加することがあります。このような場合、TypeScript でそのプラグインを使用したコードをコンパイルするためには型定義が必要になります。幸い、TypeScript には[モジュール拡張（Module Augmentation](https://www.typescriptlang.org/docs/handbook/declaration-merging.html#module-augmentation)と呼ばれる、すでに存在する型を拡張する機能があります。

例えば、`string` 型をもつ `$myProperty` インスタンスプロパティを定義するには:

``` ts
// 1. 拡張した型を定義する前に必ず 'vue' をインポートするようにしてください
import Vue from 'vue'

// 2. 拡張したい型が含まれるファイルを指定してください
//    Vue のコンストラクタの型は types/vue.d.ts に入っています
declare module 'vue/types/vue' {
  // 3. 拡張した Vue を定義します
  interface Vue {
    $myProperty: string
  }
}
```

上記のコードを（`my-property.d.ts` のような）型定義ファイルとしてあなたのプロジェクトに含めると、Vue インスタンス上で `$myProperty` が使用できるようになります。

```ts
var vm = new Vue()
console.log(vm.$myProperty) // これはうまくコンパイルされるでしょう
```

追加でグローバルプロパティやコンポーネントオプションも定義することもできます:

```ts
import Vue from 'vue'

declare module 'vue/types/vue' {
  // `interface` ではなく `namespace` を使うことで
  // グローバルプロパティを定義できます
  namespace Vue {
    const $myGlobal: string
  }
}

// ComponentOptions は types/options.d.ts に定義されています
declare module 'vue/types/options' {
  interface ComponentOptions<V extends Vue> {
    myOption?: string
  }
}
```

上記の型定義は次のコードをコンパイルできるようにします:

```ts
// グローバルプロパティ
console.log(Vue.$myGlobal)

// 追加のコンポーネントオプション
var vm = new Vue({
  myOption: 'Hello'
})
```
