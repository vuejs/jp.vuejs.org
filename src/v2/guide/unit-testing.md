---
title: 単体テスト
updated: 2018-12-26
type: guide
order: 402
---

> [Vue CLI](https://cli.vuejs.org/) には、[Jest](https://github.com/facebook/jest) または [Mocha](https://mochajs.org/) を使って難しい設定なしにユニットテストするための組み込みのオプションがあります。カスタムセットアップのためのより詳細なガイダンスとなる公式の [Vue Test Utils](https://vue-test-utils.vuejs.org/ja/) もあります。

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

コンポーネントをテストする際には、[Vue Test Utils](https://vue-test-utils.vuejs.org/ja/) と合わせてインポートし、検証を実施します (ここでは、例として Jest スタイルの `expect` アサーションを使用しています):

``` js
// Vue Test Utils の `shallowMount` とテスト対象のコンポーネントをインポートする
import { shallowMount } from '@vue/test-utils'
import MyComponent from './MyComponent.vue'

// Mount the component
const wrapper = shallowMount(MyComponent)

// テストランナーや検証には、どのようなライブラリを用いても構いませんが
// ここでは Jest を用いたテスト記述を行っています。
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
    expect(wrapper.vm.$data.message).toBe('bye!')
  })

  // マウントされたコンポーネントインスタンスを描画して検証します。
  it('renders the correct message', () => {
    expect(wrapper.text()).toBe('bye!')
  })
})
```

## テストしやすいコンポーネントの記述

コンポーネントの描画結果は、コンポーネントの受け取るプロパティによってその大半が決定されます。実際、コンポーネントの描画結果が、単にプロパティの値によってのみ決まる場合、異なる引数を用いた関数の戻り値の検証と同じ様に、シンプルに考えることができます。例を見てみましょう。

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

`propsData`オプションを利用して、異なるプロパティを用いた描画結果の検証が可能です。

``` js
import Vue from 'vue'
import MyComponent from './MyComponent.vue'

// コンポーネントをマウントし描画結果を返すヘルパー関数
function getRenderedText (Component, propsData) {
  const Constructor = Vue.extend(Component)
  const vm = new Constructor({ propsData: propsData }).$mount()
  return vm.$el.textContent
}

describe('MyComponent', () => {
  it('renders correctly with different props', () => {
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

Vue は [非同期に DOM の更新を行う](reactivity.html#Async-Update-Queue) ため、 state の変更に対する DOM の更新に関する検証は、 `Vue.nextTick` コールバックを用いて行う必要があります。

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

Vue の単体テストに関する詳細情報については、[Vue Test Utils](https://vue-test-utils.vuejs.org/ja/) とクックブックエントリの [Vue コンポーネントの単体テスト](../cookbook/unit-testing-vue-components.html) について確認してください。
