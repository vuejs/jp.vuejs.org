---
title: TypeScript のサポート
updated: 2017-10-01
type: guide
order: 404
---

> In Vue 2.5.0 we have greatly improved our type declarations to work with the default object-based API. At the same time it introduces a few changes that require upgrade actions. Read [this blog post](https://medium.com/the-vue-point/upcoming-typescript-changes-in-vue-2-5-e9bd7e2ecf08) for more details.

## NPM パッケージ内の公式型宣言

静的型システムは、特にアプリケーションが成長するに伴い、多くの潜在的なランタイムエラーを防止するのに役立ちます。そのため、Vue は [TypeScript](https://www.typescriptlang.org/) 向けに[公式型宣言](https://github.com/vuejs/vue/tree/dev/types)を提供しており、Vue コアだけでなく [Vue Router](https://github.com/vuejs/vue-router/tree/dev/types) と [Vuex](https://github.com/vuejs/vuex/tree/dev/types) も同様に提供しています。

これらは [NPM に公開](https://cdn.jsdelivr.net/npm/vue/types/)されており、そして最新の TypeScript は NPM パッケージ内の型宣言を解決する方法を知っています。つまり、NPM でインストールした時、TypeScript を Vue と共に使うための追加のツールを必要としません。

We also plan to provide an option to scaffold a ready-to-go Vue + TypeScript project in `vue-cli` in the near future.

## 推奨構成

``` js
{
  "compilerOptions": {
    // this aligns with Vue's browser support
    "target": "es5",
    // this enables stricter inference for data properties on `this`
    "strict": true,
    // if using webpack 2+ or rollup, to leverage tree shaking:
    "module": "es2015",
    "moduleResolution": "node"
  }
}
```

より詳細なことについては [TypeScript compiler options docs](https://www.typescriptlang.org/docs/handbook/compiler-options.html) を見てください。

## Development Tooling

For developing Vue applications with TypeScript, we strongly recommend using [Visual Studio Code](https://code.visualstudio.com/), which provides great out-of-the-box support for TypeScript.

If you are using [single-file components](./single-file-components.html) (SFCs), get the awesome [Vetur extension](https://github.com/vuejs/vetur), which provides TypeScript inference inside SFCs and many other great features.
  
## Basic Usage

To let TypeScript properly infer types inside Vue component options, you need to define components with `Vue.component` or `Vue.extend`:

```ts
import Vue from 'vue'

const Component = Vue.extend({
  // type inference enabled
})
  
const Component = {
  // this will NOT have type inference,
  // because TypeScript can't tell this is options for a Vue component.
}
```

Note that when using Vetur with SFCs, type inference will be automatically applied to the default export, so there's no need to wrap it in `Vue.extend`:

``` html
<template>
  ...
</template>

<script lang="ts">
export default {
  // type inference enabled
}
</script>
```
## Class-Style Vue Components
  
If you prefer a class-based API when declaring components, you can use the officially maintained [vue-class-component](https://github.com/vuejs/vue-class-componen) decorator:
  
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

## Augmenting Types for Use with Plugins

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
console.log(vm.$myProperty) // これはうまくコンパイルされる
```

追加でグローバルプロパティやコンポーネントオプションも定義することもできます:

```ts
import Vue from 'vue'

declare module 'vue/types/vue' {
  // グローバルプロパティを定義できます
  // on the VueConstructor interface
  interface VueConstructor {
    $myGlobal: string
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
