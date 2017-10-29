---
title: TypeScript のサポート
updated: 2017-10-23
type: guide
order: 404
---

> Vue 2.5.0 以降で、デフォルトのオブジェクトベースの API を使用するため型宣言が大幅に改善されました。同時に、アップグレード操作を必須とするいくつかの変更が導入されています。より詳細は[このブログ記事](https://medium.com/the-vue-point/upcoming-typescript-changes-in-vue-2-5-e9bd7e2ecf08)を読んで下さい。

## NPM パッケージ内の公式型宣言

静的型システムは、特にアプリケーションが成長するに伴い、多くの潜在的なランタイムエラーを防止するのに役立ちます。そのため、Vue は [TypeScript](https://www.typescriptlang.org/) 向けに[公式型宣言](https://github.com/vuejs/vue/tree/dev/types)を提供しており、Vue コアだけでなく [Vue Router](https://github.com/vuejs/vue-router/tree/dev/types) と [Vuex](https://github.com/vuejs/vuex/tree/dev/types) も同様に提供しています。

これらは [NPM に公開](https://cdn.jsdelivr.net/npm/vue/types/)されており、そして最新の TypeScript は NPM パッケージ内の型宣言を解決する方法を知っています。つまり、NPM でインストールした時、TypeScript を Vue と共に使うための追加のツールを必要としません。

近い将来、`vue-cli` で準備が整った  Vue + TypeScript プロジェクトで scaffold するためのオプションも提供する予定です。

## 推奨構成

``` js
{
  "compilerOptions": {
    // これは Vue のブラウザサポートに合わせます
    "target": "es5",
    // これは `this` におけるデータプロパティに対して厳密な推論を可能にします
    "strict": true,
    // webpack 2 以降 または rollup を使用している場合、ツリーシェイキングを活用するために
    "module": "es2015",
    "moduleResolution": "node"
  }
}
```

より詳細なことについては [TypeScript compiler options docs](https://www.typescriptlang.org/docs/handbook/compiler-options.html) を見てください。

## 開発ツール

TypeScript による Vue アプリケーションを開発するために、すぐに利用できる TypeScript のサポートを提供する [Visual Studio Code](https://code.visualstudio.com/) を使用することを強く勧めます。

[単一ファイルコンポーネント](./single-file-components.html) (SFC) を使用している場合、SFC 内部で TypeScript インターフェイスと他の多くの優れた機能を提供する素晴らしい [Vetur 拡張](https://github.com/vuejs/vetur) を入手してください。
  
## 基本的な使い方

Vue コンポーネントオプション内部で TypeScript が型を適切に推測できるようにするには、`Vue.component` または `Vue.extend` でコンポーネントを定義する必要があります:

```ts
import Vue from 'vue'

const Component = Vue.extend({
  // 型推論を有効にする
})
  
const Component = {
  // これは型推論を持っていません、
  // なぜなら、これは Vue コンポーネントのオプションであるということを伝えることができないためです。
}
```

## クラススタイル Vue コンポーネント
  
コンポーネントを宣言するときにクラスベース API を使用する場合は、公式にメンテナンスされている [vue-class-component](https://github.com/vuejs/vue-class-component) のデコレータを使用できます:
  
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

## プラグインで使用するための型拡張

プラグインは Vue のグローバル/インスタンスプロパティやコンポーネントオプションを追加することがあります。このような場合、TypeScript でそのプラグインを使用したコードをコンパイルするためには型定義が必要になります。幸い、TypeScript には[モジュール拡張 (Module Augmentation)](https://www.typescriptlang.org/docs/handbook/declaration-merging.html#module-augmentation) と呼ばれる、すでに存在する型を拡張する機能があります。

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
  // `VueConstructor` インターフェイスにおいて
  // グローバルプロパティを定義できます
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

## 戻り値の型にアノテーションをつける

Vue の宣言ファイルは循環的な性質を持つため、TypeScript は特定のメソッドの型を推論するのが困難な場合があります。
この理由のため、`render` や `computed` のメソッドに戻り値の型のアノテーションを付ける必要があるかもしれません。

```ts
import Vue, { VNode } from 'vue'

const Component = Vue.extend({
  data() {
    return {
      msg: 'Hello'
    }
  },
  methods: {
    // 戻り値の型の `this` のために、アノテーションが必要です
    greet(): string {
      return this.msg + ' world'
    }
  },
  computed: {
    // アノテーションが必要です
    greeting(): string {
      return this.greet() + '!'
    }
  },
  // `createElement` は推論されますが、`render` は戻り値の方が必要です
  render(createElement): VNode {
    return createElement('div', this.greeting)
  }
})
```

型推論やメンバの補完が機能していない場合、特定のメソッドにアノテーションを付けるとこれらの問題に対処できます。
`--noImplicitAny` オプションを使用すると、これらのアノテーションが付けられていないメソッドの多くを見つけるのに役立ちます。