---
title: Vue コンポーネントの単体テスト
type: cookbook
updated: 2019-01-20
order: 6
---

## 基本的な例

単体テストはソフトウェア開発の重要な部分です。単体テストは、新しい機能の追加やバグの追跡を容易にするために、最小単位のコードを独立して実行します。 Vue の[単一ファイルコンポーネント](../guide/single-file-components.html)は独立したコンポーネントの単体テストを書くことを容易にします。これによって、あなたは既存の機能を壊さない確信を持って新しい機能を開発ができ、また他の開発者がコンポーネントがしていることを理解するのを手助けします。

この簡単な例はいくつかのテキストが描画されるかどうかをテストします:

```html
<template>
  <div>
    <input v-model="username">
    <div
      v-if="error"
      class="error"
    >
      {{ error }}
    </div>
  </div>
</template>

<script>
export default {
  name: 'Hello',
  data () {
    return {
      username: ''
    }
  },

  computed: {
    error () {
      return this.username.trim().length < 7
        ? 'Please enter a longer username'
        : ''
    }
  }
}
</script>
```

```js
import { shallowMount } from '@vue/test-utils'
import Hello from './Hello.vue'

test('Hello', () => {
  // コンポーネントを描画します
  const wrapper = shallowMount(Hello)

  // `username`は空白を除外して7文字未満は許されません
  wrapper.setData({ username: ' '.repeat(7) })

  // エラーが描画されることをアサートします
  expect(wrapper.find('.error').exists()).toBe(true)

  // 名前を十分な長さにします
  wrapper.setData({ username: 'Lachlan' })

  // エラーがなくなったことをアサートします
  expect(wrapper.find('.error').exists()).toBe(false)
})
```

上記のコードスニペットは、ユーザー名の長さに基づいてエラーメッセージが描画されるかどうかをテストする方法を示しています。 Vue コンポーネントの単体テストの一般的なアイデアを示します: コンポーネントを描画し、マークアップがコンポーネントの状態に一致するかをアサートします。

## なぜテストをするのですか

コンポーネントの単体テストにはたくさんの利点があります:

- コンポーネントがどう動作すべきかのドキュメントを提供します
- 過度な手動テストの時間を節約します
- 新しい機能におけるバグを減らします
- 設計を改良します
- リファクタリングを容易にします

自動テストは大規模な開発チームが複雑なコードベースを保つことを可能にします。

#### はじめる

[Vue Test Utils](https://github.com/vuejs/vue-test-utils) は Vue コンポーネントの単体テストのための公式ライブラリです。 [vue-cli](https://github.com/vuejs/vue-cli) の `webpack` テンプレートには Karma と Jest というよくサポートされたテストランナーを備えており、また Vue Test Utils にいくつかの[ガイド](https://vue-test-utils.vuejs.org/ja/guides/)があります。

## 実例

単体テストのすべきことは:

- 実行が早いこと
- 理解しやすいこと
- _一つの作業_ だけをテストすること

私達のテストをもっと簡潔に読みやすくするために<a href="https://en.wikipedia.org/wiki/Factory_(object-oriented_programming)">ファクトリ関数</a>のアイデアを紹介しつつ、以前の例の構築を続けていきましょう。コンポーネントがすべきこと：

- 'Welcome to the Vue.js cookbook' という挨拶を表示する
- ユーザーにユーザー名の入力を促す
- もし入力された文字数が7文字未満ならエラーを表示する

最初にコンポーネントのコードを見てみましょう:

```html
<template>
  <div>
    <div class="message">
      {{ message }}
    </div>
    ユーザー名を入力してください: <input v-model="username">
    <div
      v-if="error"
      class="error"
    >
      少なくとも7文字でユーザー名を入力してください
    </div>
  </div>
</template>

<script>
export default {
  name: 'Foo',

  data () {
    return {
      message: 'Welcome to the Vue.js cookbook',
      username: ''
    }
  },

  computed: {
    error () {
      return this.username.trim().length < 7
    }
  }
}
</script>
```

私たちがテストすべきは:

- `message` が表示されているか
- もし `error` が `true`の場合、 `<div class="error">` が存在するか
- もし `error` が `false`の場合、 `<div class="error">` が存在しないか

私達のテストでの最初の試み:

```js
import { shallowMount } from '@vue/test-utils'
import Foo from './Foo.vue'

describe('Foo', () => {
  it('メッセージを描画し、ユーザー入力に正しく応答します', () => {
    const wrapper = shallowMount(Foo, {
      data() {
        return {
          message: 'Hello World',
          username: ''
        }
      }
    })

    // message が描画されていたら見られる
    expect(wrapper.find('.message').text()).toEqual('Hello World')

    // エラーのアサートが描画される
    expect(wrapper.find('.error').exists()).toBeTruthy()

    // `username`を更新してエラーのアサートが描画されなくなる
    wrapper.setData({ username: 'Lachlan' })
    expect(wrapper.find('.error').exists()).toBeFalsy()
  })
})
```

上記テストにはいくつかの問題があります:

- 1つのテストが異なることについてアサーションを行っています
- コンポーネントが存在できる異なる状態や描画すべきものを伝えるのが難しい

以下の例では、テストを次のように改善していきます:

- `it` ブロックごとに1つのアサーションのみ作成する
- 短く明確なテストの説明を持つ
- テストに必要な最低限のデータだけを提供する
- 重複したロジック（`wrapper` の作成と `username` 変数の設定）をファクトリ関数にリファクタリングする

*更新したテスト*:

```js
import { shallowMount } from '@vue/test-utils'
import Foo from './Foo'

const factory = (values = {}) => {
  return shallowMount(Foo, {
    data () {
      return {
        ...values
      }
    }
  })
}

describe('Foo', () => {
  it('welcome メッセージを描画する', () => {
    const wrapper = factory()

    expect(wrapper.find('.message').text()).toEqual("Welcome to the Vue.js cookbook")
  })

  it('usernameが7未満のときエラーを描画する', () => {
    const wrapper = factory({ username: ''  })

    expect(wrapper.find('.error').exists()).toBeTruthy()
  })

  it('usernameが空白のときエラーを描画する', () => {
    const wrapper = factory({ username: ' '.repeat(7) })

    expect(wrapper.find('.error').exists()).toBeTruthy()
  })

  it('usernameが7文字かそれ以上のとき、エラーが描画されない', () => {
    const wrapper = factory({ username: 'Lachlan' })

    expect(wrapper.find('.error').exists()).toBeFalsy()
  })
})
```

注意すべき点:

一番上に `values` オブジェクトをまとめて `data` にして、新しい `wrapper` インスタンスを返すファクトリ関数を宣言します。このようにすると、すべてのテストで `const wrapper = shallowMount（Foo）` を複製する必要がありません。このことのもう1つの大きな利点は、メソッドや算出プロパティを持つ複雑なコンポーネントをすべてのテストでモックまたはスタブにしたい場合は、一度だけ宣言すればいいということです。

## コンテキストの追加

上記のテストはかなりシンプルですが、実際の Vue コンポーネントは以下のような他のテストしたい振る舞いをよく持ちます:

- API コール
- `Vuex` ストアでコミットやミューテーションのディスパッチやアクションすること
- 相互作用テスト

そのようなテストを示すより完全な例が Vue Test Utils [ガイド](https://vue-test-utils.vuejs.org/ja/guides/)にあります。

Vue Test Utils と巨大な JavaScript エコシステムはほぼ 100％ のテスト網羅率を容易にする豊富なツールを提供します。とはいえ、単体テストはテストピラミッドの一部に過ぎません。その他のタイプのテストには e2e (end to end) テストとスナップショットテストがあります。単体テストは最小で最も簡単なテストです - 最小の作業単位でアサーションを行い、単一のコンポーネントの各部分を分離します。

スナップショットテストはあなたの Vue コンポーネントのマークアップを保存し、テストが実行されるたびに新しく生成されたものと比較します。もし何かが変更された場合、開発者に通知され、そして開発者はその変化が意図的（コンポーネントが変更された）か偶発的（コンポーネントが正しい動作をしていない）かを選ぶことができます。

e2e テストは複数のコンポーネントがうまく相互作用することを保証します。それらはより高いレベルです。幾つかの例は、ユーザーがサインアップやログインやユーザー名を更新できるかどうかをテストするものです。これらは単体テストやスナップショットテストより実行が遅くなります。

単体テストはどうコンポーネントを設計するか、どう既存のコンポーネントをリファクタリングするかについて考えるのに役に立ち、コードが変更されるたびに実行されることが多いため、開発中にもっとも有用です。

e2e などのレベルの高いテストはかなり遅く実行されます。これらは通常デプロイ前に実行されて、システムの各部分がそれぞれ正しく連携して動いていることを確かにします。

Vue コンポーネントのテストについてのさらなる情報はコアチームメンバー [Edd Yerburgh](https://eddyerburgh.me/) による [Testing Vue.js Applications](https://www.manning.com/books/testing-vuejs-applications) で見つけることができます。

## このパターンを避けるとき

単体テストは重大なアプリケーションの重要な部分です。まず最初は、アプリケーションのビジョンが明確ではない時、単体テストによって開発が遅くなる可能性がありますが、しかし一度ビジョンが決まり、実際のユーザーがアプリケーションにふれると、単体テスト（と他の種類の自動テスト）はコードベースが維持可能でスケーラブルなことを保証するために絶対に必要です。
