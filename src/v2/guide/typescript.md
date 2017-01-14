---
title: TypeScript のサポート
type: guide
order: 25
---

## 公式宣言ファイル

静的型システムは、特にアプリケーションが成長するに伴い、多くの潜在的なランタイムエラーを防止するのに役立ちます。そのため、Vue は [TypeScript](https://www.typescriptlang.org/) 向けに[公式型宣言](https://github.com/vuejs/vue/tree/dev/types)を提供しており、Vue コアだけでなく [Vue Router](https://github.com/vuejs/vue-router/tree/dev/types) と [Vuex](https://github.com/vuejs/vuex/tree/dev/types) も同様に提供しています。

これらは、[NPM で公開](https://unpkg.com/vue/types/)されており、Vue によって宣言が自動的にインポートされるので、`Typings` のような外部ツールは必要ありません。つまり、以下のように単純です:

``` ts
import Vue = require('vue')
```

これにより、すべてのメソッド、プロパティ、およびパラメータが型チェックされます。例えば、`template` コンポーネントのオプションを `tempate` (`l` が欠けている)と間違えた場合、TypeScript コンパイラはコンパイル時にエラーメッセージを出力します。[Visual Studio Code](https://code.visualstudio.com/) のような、TypeScript を使用できるエディタを使用している場合、コンパイルする前にこれらのエラーをキャッチすることができます:

![Visual Studio Code での TypeScript による型エラー](/images/typescript-type-error.png)

### コンパイルオプション

Vue の宣言ファイルには `--lib DOM,ES5,ES2015.Promise` による[コンパイラオプション](https://www.typescriptlang.org/docs/handbook/compiler-options.html)が必要です。このオプションを `tsc` コマンドに渡すか、それと同等のものを `tsconfig.json` ファイルに追加することができます。

### Vue の型宣言へのアクセス

Vue の型で独自のコードにアノテート (annotate) したい場合は、Vue のエクスポートされたオブジェクトでそのコードにアクセスできます。例えば、以下は (`.vue` ファイルにおいて) エクスポートされたコンポーネントオプションオブジェクトにアノテートします:

``` ts
import Vue = require('vue')

export default {
  props: ['message'],
  template: '<span>{{ message }}</span>'
} as Vue.ComponentOptions<Vue>
```

## クラススタイルの Vue コンポーネント

Vue のコンポーネントオプションは容易に型でアノテートできます:

``` ts
import Vue = require('vue')

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
} as Vue.ComponentOptions<MyComponent>
```

残念ながら、ここではいくつかの制限があります:

- __TypeScript は、Vue の API においてすべての型を推論することはできません。__ 例えば、`data` 関数で返された `message` プロパティが `MyComponent` インスタンスに追加されることはわかりません。これは、数値やブール値を `message` に代入すると、リンタとコンパイラは文字列でなければならないというエラーを出力することはできません。
- この制限のため、__このようなアノテートする型は冗長になります。__ 文字列として `message` を手動で宣言しなければならない唯一の理由は、TypeScript がこの場合に型を推論することができないからです。

幸いにも、[vue-class-component](https://github.com/vuejs/vue-class-component)は、これらの問題を両方解決できます。これは公式ライブラリで、`@Component` デコレータでコンポーネントをネイティブな JavaScript クラスとして宣言することができます。例として、上記のコンポーネントを書き直してみましょう:

``` ts
import Vue = require('vue')
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
