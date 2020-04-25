---
title: 単体テスト
updated: 2020-04-25
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

コンポーネントをテストする際には、 Vue と合わせて options のオブジェクトをインポートし、検証を実施します (ここでは、例として Jasmine/Jest スタイルの `expect` アサーションを使用しています):

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
    const Constructor = Vue.extend(MyComponent)
    const vm = new Constructor().$mount()
    expect(vm.$el.textContent).toBe('bye!')
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

[Vue Test Utils](https://vue-test-utils.vuejs.org/) を利用して、異なるプロパティを用いた描画結果の検証が可能です。

``` js
import { shallowMount } from '@vue/test-utils'
import MyComponent from './MyComponent.vue'

// コンポーネントをマウントし描画結果を返すヘルパー関数
function getMountedComponent(Component, propsData) {
  return shallowMount(MyComponent, {
    propsData
  })
}

describe('MyComponent', () => {
  it('renders correctly with different props', () => {
    expect(
      getMountedComponent(MyComponent, {
        msg: 'Hello'
      }).text()
    ).toBe('Hello')

    expect(
      getMountedComponent(MyComponent, {
        msg: 'Bye'
      }).text()
    ).toBe('Bye')
  })
})
```

## 非同期な更新の検証

Vue は[非同期に DOM の更新を行う](reactivity.html#非同期更新キュー)ため、state の変更に対する DOM の更新に関する検証は、`Vue.nextTick()` が解決した後に行う必要があります。

``` js
// state の更新後、生成された HTML の検証を行う
it('updates the rendered message when wrapper.message updates', async () => {
  const wrapper = shallowMount(MyComponent)
  wrapper.setData({ message: 'foo' })

  // state の更新後、DOM の更新をアサートする前に "tick" を待つ
  await wrapper.vm.$nextTick()
  expect(wrapper.text()).toBe('foo')
})
```

Vue の単体テストに関する詳細情報については、[Vue Test Utils](https://vue-test-utils.vuejs.org/ja/) とクックブックエントリの [Vue コンポーネントの単体テスト](../cookbook/unit-testing-vue-components.html) について確認してください。
