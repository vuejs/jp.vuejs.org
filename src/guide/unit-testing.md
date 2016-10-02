---
title: ユニットテスト
type: guide
order: 22
---

## テストツールとセットアップ

テストツールは、モジュールベースのビルドシステムで動作するものならどのようなものでも問題ありませんが、テストツールを探している場合、[Karma](http://karma-runner.github.io/0.12/index.html)を試してみましょう。 Karma には多くのコミュニティ製プラグインが存在し、[Webpack](https://github.com/webpack/karma-webpack)や[Browserify](https://github.com/Nikku/karma-browserify)へのサポートも充実しています。 Karma の設定例として、[Webpack](https://github.com/vuejs/vue-loader-example/blob/master/build/karma.conf.js) と[Browserify](https://github.com/vuejs/vueify-example/blob/master/karma.conf.js)のサンプル設定が最初のスタートに役立ちますが、詳しいセットアップについては、各テストツールのドキュメントを確認して下さい。

## 単純なテスト

テスト設計の観点から、コンポーネントのテスタビリティを向上させるためにコンポーネント内で特別な何かを行う必要はありません。単純に options をエクスポートするだけです。

``` html
<template>
  <span>{{ message }}</span>
</template>

<script>
  export default {
    data () {
      return {
        message: 'hello!'
      }
    },
    created () {
      this.message = 'bye!'
    }
  }
</script>
```

コンポーネントをテストする際には、 Vue と合わせて options のオブジェクトをインポートし、検証を実施します。

``` js
// Vue と テスト対象のコンポーネントをインポートする
import Vue from 'vue'
import MyComponent from 'path/to/MyComponent.vue'

// テストランナーや検証には、どのようなライブラリを用いても構いませんが
// ここでは Jasmine 2.0 を用いたテスト記述を行っています。
describe('MyComponent', () => {
  // コンポーネントの options を直接検証します。
  it('has a created hook', () => {
    expect(typeof MyComponent.created).toBe('function')
  })

  // コンポーネントの options 内にある関数を実行し、
  // 結果を検証します。
  it('sets the correct default data', () => {
    expect(typeof MyComponent.data).toBe('function')
    const defaultData = MyComponent.data()
    expect(defaultData.message).toBe('hello!')
  })

  // コンポーネントインスタンスをマウントして検証します。
  it('correctly sets the message when created', () => {
    const vm = new Vue(MyComponent).$mount()
    expect(vm.message).toBe('bye!')
  })

  // マウントされたコンポーネントインスタンスを描画して検証します。
  it('renders the correct message', () => {
    const Ctor = Vue.extend(MyComponent)
    const vm = new Ctor().$mount()
    expect(vm.$el.textContent).toBe('bye!')
  })
})
```

## テストしやすいコンポーネントの記述

コンポーネントの描画結果は、コンポーネントの受け取る props によってその大半が決定されます。実際、コンポーネントの描画結果が、単に props の値によってのみ決まる場合、異なる引数を用いた関数の戻り値の検証と同じ様に、シンプルに考えることができます。例を見てみましょう。

``` html
<template>
  <p>{{ msg }}</p>
</template>

<script>
  export default {
    props: ['msg']
  }
</script>
```

`propsData`オプションを利用して、異なる props を用いた描画結果の検証が可能です。

``` js
import Vue from 'vue'
import MyComponent from './MyComponent.vue'

// コンポーネントをマウントし描画結果を返すヘルパー関数
function getRenderedText (Component, propsData) {
  const Ctor = Vue.extend(Component)
  const vm = new Ctor({ propsData }).$mount()
  return vm.$el.textContent
}

describe('MyComponent', () => {
  it('render correctly with different props', () => {
    expect(getRenderedText(MyComponent, {
      msg: 'Hello'
    })).toBe('Hello')

    expect(getRenderedText(MyComponent, {
      msg: 'Bye'
    })).toBe('Bye')
  })
})
```

## 非同期な更新の検証

Vue は [非同期に DOM の更新を行う](/guide/reactivity.html#Async-Update-Queue) ため、 state の変更に対する DOM の更新に関する検証は、 `Vue.nextTick` コールバックを用いて行う必要があります。

``` js
// state の更新後、生成された HTML の検証を行う
it('updates the rendered message when vm.message updates', done => {
  const vm = new Vue(MyComponent).$mount()
  vm.message = 'foo'

  // state 変更後、 DOM が更新されるまでの "tick" で待機する
  Vue.nextTick(() => {
    expect(vm.$el.textContent).toBe('foo')
    done()
  })
})
```

私たちは、コンポーネントを特別な状態で描画し検証する(例えば、子コンポーネントを無視した浅い描画など)ような、テストをより簡単にするためのヘルパーセットの開発も検討しています。
