---
title: 単体テスト Vue コンポーネント
type: cookbook
updated: 2018-03-20
order: 6
---

> ⚠️注意: この内容は原文のままです。現在翻訳中ですのでお待ち下さい。🙏

## 基本的な例

単体テストはソフトウエア開発の基本的な部分です。単体テストは、新しい機能の追加やバグの追跡を容易にするために、最小単位のコードを独立して実行します。Vueの[単一ファイルコンポーネント](../guide/single-file-components.html)は独立したコンポーネントの単体テストを書くことを容易にします。これによって、あなたは既存の機能を壊さない確信を持って新しい機能を開発ができ、また他の開発者がコンポーネントがしていることを理解するのを手助けします。

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

上記のコードスニペットは、usernameの長さに基づいてエラーメッセージがレンダリングされるかどうかをテストする方法を示しています。
Vueコンポーネント単一テストの一般的なアイデアを示します: コンポーネントをレンダリングし、マークアップがコンポーネントの状態に一致するかをアサートします。

## Why test?

Component unit tests have lots of benefits:

- Provide documentation on how the component should behave
- Save time over testing manually
- Reduce bugs in new features
- Improve design
- Facilitate refactoring

Automated testing allows large teams of developers to maintain complex codebases.

#### Getting started

[Vue Test Utils](https://github.com/vuejs/vue-test-utils) is the official library for unit testing Vue components. The [vue-cli](https://github.com/vuejs/vue-cli) `webpack` template comes with either Karma or Jest, both well supported test runners, and there are some [guides](https://vue-test-utils.vuejs.org/en/guides/) in the Vue Test Utils documentation.

## Real-World Example

Unit tests should be:

- Fast to run
- Easy to understand
- Only test a _single unit of work_

Let's continue building on the previous example, while introducing the idea of a <a href="https://en.wikipedia.org/wiki/Factory_(object-oriented_programming)">factory function</a> to make our test more compact and readable. The component should:

- show a 'Welcome to the Vue.js cookbook' greeting.
- prompt the user to enter their username
- display an error if the entered username is less than seven letters

Let's take a look at the component code first:

```html
<template>
  <div>
    <div class="message">
      {{ message }}
    </div>
    Enter your username: <input v-model="username">
    <div 
      v-if="error"
      class="error"
    >
      Please enter a username with at least seven letters.
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

The things that we should test are:

- is the `message` rendered?
- if `error` is `true`, `<div class="error">` should be present
- if `error` is `false`, `<div class="error">` should not be present

And our first attempt at test:

```js
import { shallow } from '@vue/test-utils'

describe('Foo', () => {
  it('renders a message and responds correctly to user input', () => {
      const wrapper = shallow(Foo, {
    data: {
      message: 'Hello World',
      username: ''
    }
  })

  // see if the message renders
  expect(wrapper.find('.message').text()).toEqual('Hello World')

  // assert the error is rendered
  expect(wrapper.find('.error').exists()).toBeTruthy()

  // update the `username` and assert error is longer rendered
  wrapper.setData({ username: 'Lachlan' })
  expect(wrapper.find('.error').exists()).toBeFalsy()
  })
})
```

There are some problems with the above:

- a single test is making assertions about different things
- difficult to tell the different states the component can be in, and what should be rendered

The below example improves the test by:

- only making one assertion per `it` block
- having short, clear test descriptions
- providing only the minimum data requires for the test
- refactoring duplicated logic (creating the `wrapper` and setting the `username` variable) into a factory function

*Updated test*:
```js
import { shallow } from '@vue/test-utils'
import Foo from './Foo'

const factory = (values = {}) => {
  return shallow(Foo, {
    data: { ...values  }
  })
}

describe('Foo', () => {
  it('renders a welcome message', () => {
    const wrapper = factory()

    expect(wrapper.find('.message').text()).toEqual("Welcome to the Vue.js cookbook")
  })

  it('renders an error when username is less than 7 characters', () => {
    const wrapper = factory({ username: ''  })

    expect(wrapper.find('.error').exists()).toBeTruthy()
  })

  it('renders an error when username is whitespace', () => {
    const wrapper = factory({ username: ' '.repeat(7) })

    expect(wrapper.find('.error').exists()).toBeTruthy()
  })

  it('does not render an error when username is 7 characters or more', () => {
    const wrapper = factory({ username: 'Lachlan'  })

    expect(wrapper.find('.error').exists()).toBeFalsy()
  })
})
```

Points to note:

At the top, we declare the factory function which merges the `values` object into `data` and returns a new `wrapper` instance. This way, we don't need to duplicate `const wrapper = shallow(Foo)` in every test. Another great benefit to this is when more complex components with a method or computed property you might want to mock or stub in every test, you only need to declare it once.

## Additional Context

The above test is fairly simple, but in practice Vue components often have other behaviors you want to test, such as:

- making API calls
- committing or dispatching mutations or actions with a `Vuex` store
- testing interaction

There are more complete examples showing such tests in the Vue Test Utils [guides](https://vue-test-utils.vuejs.org/en/guides/).

Vue Test Utils and the enormous JavaScript ecosystem provides plenty of tooling to facilitate almost 100% test coverage. Unit tests are only one part of the testing pyramid, though. Some other types of tests include e2e (end to end) tests, and snapshot tests. Unit tests are the smallest and most simple of tests - they make assertions on the smallest units of work, isolating each part of a single component.

Snapshot tests save the markup of your Vue component, and compare to the new one generated each time the test runs. If something changes, the developer is notified, and can decide if the change was intentional (the component was updated) or accidental (the component is behaving incorrectly).

End to end tests ensure a number of components interact well together. They are more high level. Some examples might be testing if a user can sign up, log in, and update their username. These are slower to run than unit tests or snapshot tests.

Unit tests are most useful during development, either to help a developer think about how to design a component, or refactor an existing component, and are often run every time code is changed.

Higher level tests, such as end to end tests, run much slower. These usually run pre-deploy, to ensure each part of the system is working together correctly.

More information about testing Vue components can be found in [Testing Vue.js Applications](https://www.manning.com/books/testing-vuejs-applications) by core team member [Edd Yerburgh](https://eddyerburgh.me/).

## When To Avoid This Pattern

Unit testing is an important part of any serious application. At first, when the vision of an application is not clear, unit testing might slow down development, but once a vision is established and real users will be interacting with the application, unit tests (and other types of automated tests) are absolutely essential to ensure the codebase is maintainable and scalable.
