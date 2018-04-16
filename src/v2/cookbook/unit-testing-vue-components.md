---
title: 単体テスト Vue コンポーネント
type: cookbook
updated: 2018-03-24
order: 6
---

> ⚠️注意: この内容は原文のままです。現在翻訳中ですのでお待ち下さい。🙏

## 基本的な例

単体テストはソフトウエア開発の基本的な部分です。単体テストは、新しい機能の追加やバグの追跡を容易にするために、最小単位のコードを独立して実行します。 Vue の[単一ファイルコンポーネント](../guide/single-file-components.html)は独立したコンポーネントの単体テストを書くことを容易にします。これによって、あなたは既存の機能を壊さない確信を持って新しい機能を開発ができ、また他の開発者がコンポーネントがしていることを理解するのを手助けします。

この簡単な例はいくつかのテキストがレンダリングされるかどうかをテストします:

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
import { shallow } from '@vue/test-utils'

test('Foo', () => {
  // コンポーネントをレンダリングします。
  const wrapper = shallow(Hello)

  // `username`は空白を除外して7文字未満は許されません。
  wrapper.setData({ username: ' '.repeat(7) })

  // エラーがレンダリングされることをアサート（assert）します。
  expect(wrapper.find('.error').exists()).toBe(true)

  // 名前を十分な長さにします。
  wrapper.setData({
    username: 'Lachlan'
  })

  // エラーがなくなったとアサート（assert）します。
  expect(wrapper.find('.error').exists()).toBe(false)
})
```

上記のコードスニペットは、 username の長さに基づいてエラーメッセージがレンダリングされるかどうかをテストする方法を示しています。
Vue コンポーネント単一テストの一般的なアイデアを示します: コンポーネントをレンダリングし、マークアップがコンポーネントの状態に一致するかをアサートします。

## なぜテストをするのですか

単体テスト Vue コンポーネントはたくさんの利益を持っています:

- コンポーネントがどう動作すべきかのドキュメントを提供します
- 過度な(over)手動テストの時間を節約します
- 新しい機能におけるバグを減らします
- デザインを改良します
- リファクタリングを容易にします

自動テストは大規模な開発チームチームが複雑なコードベース(codebases)を維持するのを許します。

#### はじめる

[Vue Test Utils](https://github.com/vuejs/vue-test-utils) は Vue コンポーネントをテストするための公式ライブラリです。[vue-cli](https://github.com/vuejs/vue-cli)の `webpack` テンプレートには Karma と Jest というよくサポートされたテストランナーを備えており、また Vue Test Utils にいくつかの[ガイド](https://vue-test-utils.vuejs.org/en/guides/)があります。

## 現実的な例

単体テストのすべきことは

- 実行が早いこと
- 理解しやすいこと
- _一つの仕事_だけをテストすること

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
      少なくとも7文字でユーザー名を入力してください。
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
import { shallow } from '@vue/test-utils'

describe('Foo', () => {
  it('メッセージを表示し、ユーザー入力に正しく応答します', () => {
      const wrapper = shallow(Foo, {
    data: {
      message: 'Hello World',
      username: ''
    }
  })

  // message がレンダーされていたら見られる
  expect(wrapper.find('.message').text()).toEqual('Hello World')

  // エラーのアサートがレンダーされる
  expect(wrapper.find('.error').exists()).toBeTruthy()

  // `username`を更新してエラーのアサートがレンダリングされなくなる
  wrapper.setData({ username: 'Lachlan' })
  expect(wrapper.find('.error').exists()).toBeFalsy()
  })
})
```

上記テストにはいくつかの問題があります:

- 1つのテストが異なることについてアサーションが行われています
- コンポーネントが存在できる異なる状態やレンダリングすべきものを伝えるのは難しい

以下の例では、テストを次のように改善していきます:

- `it` ブロックごとに1つのアサーションしか作成しない
- 短く明確なテストの説明を持つ
- テストに必要な最低限のデータだけを提供する
- 二重のロジック（`wrapper` の作成と `username` 変数の設定）をファクトリ関数にリファクタリングする

*テストの更新*:

```js
import { shallow } from '@vue/test-utils'
import Foo from './Foo'

const factory = (values = {}) => {
  return shallow(Foo, {
    data: { ...values  }
  })
}

describe('Foo', () => {
  it('welcome メッセージをレンダリングする', () => {
    const wrapper = factory()

    expect(wrapper.find('.message').text()).toEqual("Welcome to the Vue.js cookbook")
  })

  it('usernameが7未満のときエラーをレンダリングする', () => {
    const wrapper = factory({ username: ''  })

    expect(wrapper.find('.error').exists()).toBeTruthy()
  })

  it('usernameが空白のときエラーをレンダリングする', () => {
    const wrapper = factory({ username: ' '.repeat(7) })

    expect(wrapper.find('.error').exists()).toBeTruthy()
  })

  it('usernameが7文字かそれ以上のとき、エラーがレンダリングされない', () => {
    const wrapper = factory({ username: 'Lachlan' })

    expect(wrapper.find('.error').exists()).toBeFalsy()
  })
})
```

注意すべき点:

一番上に `values` オブジェクトをまとめて `data` にして、新しい `wrapper` インスタンスを返すファクトリ関数を宣言します。このようにすると、すべてのテストで `const wrapper = shallow（Foo）` を複製する必要がありません。このことのもう1つの大きな利点は、メソッドや computed プロパティを持つ複雑なコンポーネントをすべてのテストでモックまたはスタブにしたい場合は、一度だけ宣言すればいいということです。

## コンテキストの追加

上記のテストはかなりシンプルですが、実際の Vue コンポーネントは以下のような他のテストしたい振る舞いをよく持ちます:

- API コールの作成
- `Vuex` ストアでコミットやミューテーションのディスパッチやアクションすること
- 対話的テスト

そのようなテストを示すより完全な例がVue Test Utils [ガイド](https://vue-test-utils.vuejs.org/en/guides/)にあります。

Vue Test Utils と巨大な JavaScript エコシステムはほぼ 100％ のテスト網羅率を容易にする豊富なツールを提供します。とはいえ、単体テストはテストピラミッドの一部に過ぎません。その他のタイプのテストには e2e (end to end) テストとスナップショットテストがあります。単体テストは最小で最も簡単なテストです - 最小の仕事単位でアサーションを行い、単一のコンポーネントの各部分を分離します。

スナップショットテストはあなたの Vue コンポーネントのマークアップを保存し、テストが実行されるたびに新しく生成されたものと比較します。もし何かが変更された場合、開発者に通知され、そして開発者はその変化が意図的（コンポーネントが変更された）か偶発的（コンポーネントが正しい動作をしていない）かを選ぶことができます。

e2e テストは複数のコンポーネントがうまく相互作用することを保証します。それらはより高いレベルです。幾つかの例は、ユーザーがサインアップやログインやユーザー名を更新できるかどうかをテストするものです。これらは単体テストやスナップショットテストより実行が遅くなります。

単体テストはどうコンポーネントを設計するか、どう既存のコンポーネントをリファクタリングするかについて考えるのに役に立ち、コードが変更されるたびに実行されることが多いため、開発中にもっとも有用です。

エンドツーエンドテストなどのレベルの高いテストはかなり遅く実行されます。これらは通常デプロイ前に実行されて、システムの各部分がそれぞれ正しく連携して動いていることを確かにします。

Vue コンポーネントのテストについてらさらなる情報はコアチームメンバー[Edd Yerburgh](https://eddyerburgh.me/)による[Testing Vue.js Applications](https://www.manning.com/books/testing-vuejs-applications)で見つけることができます。

## When To Avoid This Pattern

Unit testing is an important part of any serious application. At first, when the vision of an application is not clear, unit testing might slow down development, but once a vision is established and real users will be interacting with the application, unit tests (and other types of automated tests) are absolutely essential to ensure the codebase is maintainable and scalable.
