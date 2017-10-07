---
type: style-guide
updated: 2017-10-02
---

# スタイルガイド <sup class="beta">beta</sup>

> 注意⚠️ : このドキュメントはまだ翻訳されていません。翻訳募集中です🙏 ！
> 翻訳に興味がある方は GitHub の[こちら](https://github.com/vuejs/jp.vuejs.org/issues/368)で募集中(先着順)です。

This is the official style guide for Vue-specific code. If you use Vue in a project, it's a great reference to avoid errors, bikeshedding, and anti-patterns. However, we don't believe that any style guide is ideal for all teams or projects, so mindful deviations are encouraged based on past experience, the surrounding tech stack, and personal values.

For the most part, we also avoid suggestions about JavaScript or HTML in general. We don't mind whether you use semicolons or trailing commas. We don't mind whether your HTML uses single-quotes or double-quotes for attribute values. Some exceptions will exist however, where we've found that a particular pattern is helpful in the context of Vue.

> **Soon, we'll also provide tips for enforcement.** Sometimes you'll simply have to be disciplined, but wherever possible, we'll try to show you how to use ESLint and other automated processes to make enforcement simpler.

Finally, we've split rules into four categories:



## Rule Categories

### Priority A: Essential

These rules help prevent errors, so learn and abide by them at all costs. Exceptions may exist, but should be very rare and only be made by those with expert knowledge of both JavaScript and Vue.

### 優先度 B: 強く推奨

<!--
These rules have been found to improve readability and/or developer experience in most projects. Your code will still run if you violate them, but violations should be rare and well-justified.
-->
これらのルールは、ほとんどのプロジェクトで読みやすさや開発者の体験をよりよくするために見いだされました。これらに違反してもあなたのコードは動きますが、ごくまれなケースで、かつちゃんと正当を示した上でのみ違反するようにすべきです。

### Priority C: Recommended

Where multiple, equally good options exist, an arbitrary choice can be made to ensure consistency. In these rules, we describe each acceptable option and suggest a default choice. That means you can feel free to make a different choice in your own codebase, as long as you're consistent and have a good reason. Please do have a good reason though! By adapting to the community standard, you will:

1. train your brain to more easily parse most of the community code you encounter
2. be able to copy and paste most community code examples without modification
2. often find new hires are already accustomed to your preferred coding style, at least in regards to Vue

### Priority D: Use with Caution

Some features of Vue exist to accommodate rare edge cases or smoother migrations from a legacy code base. When overused however, they can make your code more difficult to maintain or even become a source of bugs. These rules shine a light on potentially risky features, describing when and why they should be avoided.



## Priority A Rules: Essential (Error Prevention)



### Multi-word component names <sup data-p="a">essential</sup>

**Component names should always be multi-word, except for root `App` components.**

This [prevents conflicts](http://w3c.github.io/webcomponents/spec/custom/#valid-custom-element-name) with existing and future HTML elements, since all HTML elements are a single word.

{% raw %}<div class="style-example example-bad">{% endraw %}
#### Bad

``` js
Vue.component('todo', {
  // ...
})
```

``` js
export default {
  name: 'Todo',
  // ...
}
```
{% raw %}</div>{% endraw %}

{% raw %}<div class="style-example example-good">{% endraw %}
#### Good

``` js
Vue.component('todo-item', {
  // ...
})
```

``` js
export default {
  name: 'TodoItem',
  // ...
}
```
{% raw %}</div>{% endraw %}



### Component data <sup data-p="a">essential</sup>

**Component `data` must be a function.**

When using the `data` property on a component (i.e. anywhere except on `new Vue`), the value must be a function that returns an object.

{% raw %}
<details>
<summary>
  <h4>Detailed Explanation</h4>
</summary>
{% endraw %}

When the value of `data` is an object, it's shared across all instances of a component. Imagine, for example, a `TodoList` component with this data:

``` js
data: {
  listTitle: '',
  todos: []
}
```

We might want to reuse this component, allowing users to maintain multiple lists (e.g. for shopping, wishlists, daily chores, etc). There's a problem though. Since every instance of the component references the same data object, changing the title of one list will also change the title of every other list. The same is true for adding/editing/deleting a todo.

Instead, we want each component instance to only manage its own data. For that to happen, each instance must generate a unique data object. In JavaScript, this can be accomplished by returning the object in a function:

``` js
data: function () {
  return {
    listTitle: '',
    todos: []
  }
}
```
{% raw %}</details>{% endraw %}

{% raw %}<div class="style-example example-bad">{% endraw %}
#### Bad

``` js
Vue.component('some-comp', {
  data: {
    foo: 'bar'
  }
})
```

``` js
export default {
  data: {
    foo: 'bar'
  }
}
```
{% raw %}</div>{% endraw %}

{% raw %}<div class="style-example example-good">{% endraw %}
#### Good
``` js
Vue.component('some-comp', {
  data: function () {
    return {
      foo: 'bar'
    }
  }
})
```

``` js
// In a .vue file
export default {
  data () {
    return {
      foo: 'bar'
    }
  }
}
```

``` js
// It's OK to use an object directly in a root
// Vue instance, since only a single instance
// will ever exist.
new Vue({
  data: {
    foo: 'bar'
  }
})
```
{% raw %}</div>{% endraw %}



### Prop definitions <sup data-p="a">essential</sup>

**Prop definitions should be as detailed as possible.**

In committed code, prop definitions should always be as detailed as possible, specifying at least type(s).

{% raw %}
<details>
<summary>
  <h4>Detailed Explanation</h4>
</summary>
{% endraw %}

Detailed [prop definitions](https://vuejs.org/v2/guide/components.html#Prop-Validation) have two advantages:

- They document the API of the component, so that it's easy to see how the component is meant to be used.
- In development, Vue will warn you if a component is ever provided incorrectly formatted props, helping you catch potential sources of error.

{% raw %}</details>{% endraw %}

{% raw %}<div class="style-example example-bad">{% endraw %}
#### Bad

``` js
// This is only OK when prototyping
props: ['status']
```
{% raw %}</div>{% endraw %}

{% raw %}<div class="style-example example-good">{% endraw %}
#### Good

``` js
props: {
  status: String
}
```

``` js
// Even better!
props: {
  status: {
    type: String,
    required: true,
    validator: function (value) {
      return [
        'syncing',
        'synced',
        'version-conflict',
        'error'
      ].indexOf(value) !== -1
    }
  }
}
```
{% raw %}</div>{% endraw %}



### Keyed `v-for` <sup data-p="a">essential</sup>

**Always use `key` with `v-for`.**

`key` with `v-for` is _always_ required on components, in order to maintain internal component state down the subtree. Even for elements though, it's a good practice to maintain predictable behavior, such as [object constancy](https://bost.ocks.org/mike/constancy/) in animations.

{% raw %}
<details>
<summary>
  <h4>Detailed Explanation</h4>
</summary>
{% endraw %}

Let's say you have a list of todos:

``` js
data: function () {
  return {
    todos: [
      {
        id: 1,
        text: 'Learn to use v-for'
      },
      {
        id: 2,
        text: 'Learn to use key'
      }
    ]
  }
}
```

Then you sort them alphabetically. When updating the DOM, Vue will optimize rendering to perform the cheapest DOM mutations possible. That might mean deleting the first todo element, then adding it again at the end of the list.

The problem is, there are cases where it's important not to delete elements that will remain in the DOM. For example, you may want to use `<transition-group>` to animate list sorting, or maintain focus if the rendered element is an `<input>`. In these cases, adding a unique key for each item (e.g. `:key="todo.id"`) will tell Vue how to behave more predictably.

In our experience, it's better to _always_ add a unique key, so that you and your team simply never have to worry about these edge cases. Then in the rare, performance-critical scenarios where object constancy isn't necessary, you can make a conscious exception.

{% raw %}</details>{% endraw %}

{% raw %}<div class="style-example example-bad">{% endraw %}
#### Bad

``` html
<ul>
  <li v-for="todo in todos">
    {{ todo.text }}
  </li>
</ul>
```
{% raw %}</div>{% endraw %}

{% raw %}<div class="style-example example-good">{% endraw %}
#### Good

``` html
<ul>
  <li
    v-for="todo in todos"
    :key="todo.id"
  >
    {{ todo.text }}
  </li>
</ul>
```
{% raw %}</div>{% endraw %}



### Component style scoping <sup data-p="a">essential</sup>

**For applications, styles in a top-level `App` component and in layout components may be global, but all other components should always be scoped.**

This is only relevant for [single-file components](../guide/single-file-components.html). It does _not_ require that the [`scoped` attribute](https://vue-loader.vuejs.org/en/features/scoped-css.html) be used. Scoping could be through [CSS modules](https://vue-loader.vuejs.org/en/features/css-modules.html), a class-based strategy such as [BEM](http://getbem.com/), or another library/convention.

**Component libraries, however, should prefer a class-based strategy instead of using the `scoped` attribute.**

This makes overriding internal styles easier, with human-readable class names that don't have too high specificity, but are still very unlikely to result in a conflict.

{% raw %}
<details>
<summary>
  <h4>Detailed Explanation</h4>
</summary>
{% endraw %}

If you are developing a large project, working with other developers, or sometimes include 3rd-party HTML/CSS (e.g. from Auth0), consistent scoping will ensure that your styles only apply to the components they are meant for.

Beyond the `scoped` attribute, using unique class names can help ensure that 3rd-party CSS does not apply to your own HTML. For example, many projects use the `button`, `btn`, or `icon` class names, so even if not using a strategy such as BEM, adding an app-specific and/or component-specific prefix (e.g. `ButtonClose-icon`) can provide some protection.

{% raw %}</details>{% endraw %}

{% raw %}<div class="style-example example-bad">{% endraw %}
#### Bad

``` html
<template>
  <button class="btn btn-close">X</button>
</template>

<style>
.btn-close {
  background-color: red;
}
</style>
```
{% raw %}</div>{% endraw %}

{% raw %}<div class="style-example example-good">{% endraw %}
#### Good

``` html
<template>
  <button class="button button-close">X</button>
</template>

<!-- Using the scoped attribute -->
<style scoped>
.button {
  border: none;
  border-radius: 2px;
}

.button-close {
  background-color: red;
}
</style>
```

``` html
<template>
  <button :class="[$style.button, $style.buttonClose]">X</button>
</template>

<!-- Using CSS modules -->
<style module>
.button {
  border: none;
  border-radius: 2px;
}

.buttonClose {
  background-color: red;
}
</style>
```

``` html
<template>
  <button class="c-Button c-Button--close">X</button>
</template>

<!-- Using the BEM convention -->
<style>
.c-Button {
  border: none;
  border-radius: 2px;
}

.c-Button--close {
  background-color: red;
}
</style>
```
{% raw %}</div>{% endraw %}



### Private property names <sup data-p="a">essential</sup>

**Always use the `$_` prefix for custom private properties in a plugin, mixin, etc. Then to avoid conflicts with code by other authors, also include a named scope (e.g. `$_yourPluginName_`).**

{% raw %}
<details>
<summary>
  <h4>Detailed Explanation</h4>
</summary>
{% endraw %}

Vue uses the `_` prefix to define its own private properties, so using the same prefix (e.g. `_update`) risks overwriting an instance property. Even if you check and Vue is not currently using a particular property name, there is no guarantee a conflict won't arise in a later version.

As for the `$` prefix, it's purpose within the Vue ecosystem is special instance properties that are exposed to the user, so using it for _private_ properties would not be appropriate.

Instead, we recommend combining the two prefixes into `$_`, as a convention for user-defined private properties that guarantee no conflicts with Vue.

{% raw %}</details>{% endraw %}

{% raw %}<div class="style-example example-bad">{% endraw %}
#### Bad

``` js
var myGreatMixin = {
  // ...
  methods: {
    update: function () {
      // ...
    }
  }
}
```

``` js
var myGreatMixin = {
  // ...
  methods: {
    _update: function () {
      // ...
    }
  }
}
```

``` js
var myGreatMixin = {
  // ...
  methods: {
    $update: function () {
      // ...
    }
  }
}
```

``` js
var myGreatMixin = {
  // ...
  methods: {
    $_update: function () {
      // ...
    }
  }
}
```

{% raw %}</div>{% endraw %}

{% raw %}<div class="style-example example-good">{% endraw %}
#### Good

``` js
var myGreatMixin = {
  // ...
  methods: {
    $_myGreatMixin_update: function () {
      // ...
    }
  }
}
```
{% raw %}</div>{% endraw %}



## 優先度B のルール: 強く推奨 (読みやすさの向上)



### コンポーネントのファイル <sup data-p="b">強く推奨</sup>

<!--
**Whenever a build system is available to concatenate files, each component should be in its own file.**

This helps you to more quickly find a component when you need to edit it or review how to use it.
-->
**ファイルを結合してくれるビルドシステムがあったとしても、各コンポーネントはそれぞれ別のファイルに書くべきです。**

そうすれば、コンポーネントを編集したり使い方を確認するときにより素早く見つけることができます。

{% raw %}<div class="style-example example-bad">{% endraw %}
#### 悪い例

``` js
Vue.component('TodoList', {
  // ...
})

Vue.component('TodoItem', {
  // ...
})
```
{% raw %}</div>{% endraw %}

{% raw %}<div class="style-example example-good">{% endraw %}
#### 良い例

```
components/
|- TodoList.js
|- TodoItem.js
```

```
components/
|- TodoList.vue
|- TodoItem.vue
```
{% raw %}</div>{% endraw %}



### 単一ファイルコンポーネントのファイル名の形式 <sup data-p="b">強く推奨</sup>

<!--
**Filenames of [single-file components](../guide/single-file-components.html) should either be always PascalCase or always kebab-case.**

PascalCase works best with autocompletion in code editors, as it's consistent with how we reference components in JS(X) and templates, wherever possible. However, mixed case filenames can sometimes create issues on case-insensitive filesystems, which is why kebab-case is also perfectly acceptable.
-->
**[単一ファイルコンポーネント](../guide/single-file-components.html) のファイル名は、すべてパスカルケース (PascalCase) にするか、すべてケバブケース (kebab-case) にするべきです。**

パスカルケースは、JS(X) やテンプレートの中でコンポーネントを参照する方法と一致しているので、コードエディタ上でオートコンプリートが可能な場合はとてもうまく働きます。
しかし、大文字と小文字が混ざったファイル名は、大文字と小文字を区別しないファイルシステム上で時々問題を起こす可能性があります。そのため、ケバブケースもまた完全に受け入れられています。

{% raw %}<div class="style-example example-bad">{% endraw %}
#### 悪い例

```
components/
|- mycomponent.vue
```

```
components/
|- myComponent.vue
```
{% raw %}</div>{% endraw %}

{% raw %}<div class="style-example example-good">{% endraw %}
#### 良い例

```
components/
|- MyComponent.vue
```

```
components/
|- my-component.vue
```
{% raw %}</div>{% endraw %}



### 基底コンポーネントの名前 <sup data-p="b">強く推奨</sup>

<!--
**Base components (a.k.a. presentational, dumb, or pure components) that apply app-specific styling and conventions should all begin with a specific prefix, such as `Base`, `App`, or `V`.**
-->

**アプリケーション特有のスタイルやルールを適用する基底コンポーネント (またはプレゼンテーションコンポーネント、ダムコンポーネント、純粋コンポーネントとも) は、すべて `Base` 、 `App` 、`V` などの固有のプレフィックスで始まるべきです。**

{% raw %}
<details>
<summary>
  <h4>詳細な説明</h4>
</summary>
{% endraw %}

<!--
These components lay the foundation for consistent styling and behavior in your application. They may **only** contain:

- HTML elements,
- other `Base`-prefixed components, and
- 3rd-party UI components.

But they'll **never** contain global state (e.g. from a Vuex store).

Their names often include the name of an element they wrap (e.g. `BaseButton`, `BaseTable`), unless no element exists for their specific purpose (e.g. `BaseIcon`). If you build similar components for a more specific context, they will almost always consume these components (e.g. `BaseButton` may be used in `ButtonSubmit`).

-->
これらのコンポーネントは、あなたのアプリケーションに一貫したスタイルやふるまいをもたせる基礎として位置づけられます。これらは、おそらく以下のもの **だけ** を含むでしょう:

- HTML 要素、
- `Base` で始まる別のコンポーネント、そして
- サードパーティ製の UI コンポーネント

これらのコンポーネントの名前は、しばしばラップしている要素の名前を含みます(例えば `BaseButton` 、 `BaseTable`)。それ特有の目的のための要素がない場合は別ですが(例えば `BaseIcon`)。
もっと特定の用途に向けた同じようなコンポーネントを作る時は、ほとんどすべての場合にこれらのコンポーネントを使うことになるでしょう。(例えば `BaseButton` を `ButtonSubmit` で使うなど)

<!--
Some advantages of this convention:

- When organized alphabetically in editors, your app's base components are all listed together, making them easier to identify.

- Since component names should always be multi-word, this convention prevents you from having to choose an arbitrary prefix for simple component wrappers (e.g. `MyButton`, `VueButton`).

- Since these components are so frequently used, you may want to simply make them global instead of importing them everywhere. A prefix makes this possible with Webpack:
-->
このルールの長所:

- エディタ上でアルファベット順に並べられた時に、アプリケーションの基底コンポーネントはすべて一緒にリストされ、識別しやすくなります。

- コンポーネントの名前は常に複数単語にするべきなので、このルールによってシンプルなコンポーネントラッパーに勝手なプレフィックスを選ばなければならない(例えば `MyButton` 、 `VueButton`)ということがなくなります。

- これらのコンポーネントはとても頻繁に使われるので、あらゆる場所で import するよりも単純にグローバルにしてしまいたいと思うかもしれません。プレフィックスによって、それを Webpack でできるようになります。

  ``` js
  var requireComponent = require.context("./src", true, /^Base[A-Z]/)
  requireComponent.keys().forEach(function (fileName) {
    var baseComponentConfig = requireComponent(fileName)
    baseComponentConfig = baseComponentConfig.default || baseComponentConfig
    var baseComponentName = baseComponentConfig.name || (
      fileName
        .replace(/^.+\//, '')
        .replace(/\.\w+$/, '')
    )
    Vue.component(baseComponentName, baseComponentConfig)
  })
  ```

{% raw %}</details>{% endraw %}

{% raw %}<div class="style-example example-bad">{% endraw %}
#### 悪い例

```
components/
|- MyButton.vue
|- VueTable.vue
|- Icon.vue
```
{% raw %}</div>{% endraw %}

{% raw %}<div class="style-example example-good">{% endraw %}
#### 良い例

```
components/
|- BaseButton.vue
|- BaseTable.vue
|- BaseIcon.vue
```

```
components/
|- AppButton.vue
|- AppTable.vue
|- AppIcon.vue
```

```
components/
|- VButton.vue
|- VTable.vue
|- VIcon.vue
```
{% raw %}</div>{% endraw %}



### 単一インスタンスのコンポーネント名 <sup data-p="b">強く推奨</sup>

<!--
**Components that should only ever have a single active instance should begin with the `The` prefix, to denote that there can be only one.**

This does not mean the component is only used in a single page, but it will only be used once _per page_. These components never accept any props, since they are specific to your app, not their context within your app. If you find the need to add props, it's a good indication that this is actually a reusable component that is only used once per page _for now_.
-->
**常に一つのアクティブなインスタンスしか持たないコンポーネントは、一つしか存在しえないことを示すために `The` というプレフィックスで始めるべきです。**

これはそのコンポーネントが一つのページでしか使われないということを意味するのではなく、 _ページごとに_ 一回しか使われないという意味です。
これらのコンポーネントは、アプリケーション内のコンテキストではなく、アプリケーションに対して固有のため、決してプロパティを受け入れることはありません。
もしプロパティを追加する必要があることに気づいたのなら、それは _現時点で_ ページごとに一回しか使われていないだけで、実際には再利用可能なコンポーネントであることを示すよい目印です。


{% raw %}<div class="style-example example-bad">{% endraw %}
#### 悪い例

```
components/
|- Heading.vue
|- MySidebar.vue
```
{% raw %}</div>{% endraw %}

{% raw %}<div class="style-example example-good">{% endraw %}
#### 良い例

```
components/
|- TheHeading.vue
|- TheSidebar.vue
```
{% raw %}</div>{% endraw %}



### 密結合コンポーネントの名前 <sup data-p="b">強く推奨</sup>

<!--
**Child components that are tightly coupled with their parent should include the parent component name as a prefix.**

If a component only makes sense in the context of a single parent component, that relationship should be evident in its name. Since editors typically organize files alphabetically, this also keeps these related files next to each other.
-->
**親コンポーネントと密結合した子コンポーネントには、親コンポーネントの名前をプレフィックスとして含むべきです。**

もし、コンポーネントが単一の親コンポーネントの中でだけ意味をもつものなら、その関連性は名前からはっきりわかるようにするべきです。
一般的にエディタはファイルをアルファベット順に並べるので、関連をもつものどうしが常に隣り合って並ぶことにもなります。

{% raw %}<div class="style-example example-bad">{% endraw %}
#### 悪い例

```
components/
|- TodoList.vue
|- TodoItem.vue
|- TodoButton.vue
```

```
components/
|- SearchSidebar.vue
|- NavigationForSearchSidebar.vue
```
{% raw %}</div>{% endraw %}

{% raw %}<div class="style-example example-good">{% endraw %}
#### 良い例

```
components/
|- TodoList.vue
|- TodoListItem.vue
|- TodoListItemButton.vue
```

```
components/
|- SearchSidebar.vue
|- SearchSidebarNavigation.vue
```
{% raw %}</div>{% endraw %}



### コンポーネント名における単語の順番 <sup data-p="b">強く推奨</sup>

<!--
**Component names should start with the highest-level (often most general) words and end with descriptive modifying words.**
-->
**コンポーネント名は、最高レベルの(たいていは最も一般的な)単語から始めて、説明的な修飾語で終わるべきです。**

{% raw %}
<details>
<summary>
  <h4>詳細な説明</h4>
</summary>
{% endraw %}

<!--
You may be wondering:

> "Why would we force component names to use less natural language?"

In natural English, adjectives and other descriptors do typically appear before the nouns, while exceptions require connector words. For example:

- Coffee _with_ milk
- Soup _of the_ day
- Visitor _to the_ museum

You can definitely include these connector words in component names if you'd like, but the order is still important.

-->
あなたは疑問に思うかもしれません:

> "なぜコンポーネント名に自然な言語でないものを使うように強制するのですか？"

自然な英語では、形容詞やその他の記述子は一般的に名詞の前に置かれ、そうでない場合には接続詞が必要になります。例えば:

- Coffee _with_ milk
- Soup _of the_ day
- Visitor _to the_ museum

もちろん、あなたがそうしたいのであればこれらの接続詞をコンポーネント名に含めても構いませんが、それでも順番は重要です。

<!--
Also note that **what's considered "highest-level" will be contextual to your app**. For example, imagine an app with a search form. It may include components like this one:
-->
また、 **何を「最高レベル」として尊重するかがアプリケーションの文脈になる** ことに注意してください。
例えば、検索フォームを持ったアプリケーションを想像してください。こんなコンポーネントがあるかもしれません:


```
components/
|- ClearSearchButton.vue
|- ExcludeFromSearchInput.vue
|- LaunchOnStartupCheckbox.vue
|- RunSearchButton.vue
|- SearchInput.vue
|- TermsCheckbox.vue
```

<!--
As you might notice, it's quite difficult to see which components are specific to the search. Now let's rename the components according to the rule:
-->
あなたも気づいたと思いますが、これではどのコンポーネントが検索に特有のものなのかとても分かりづらいです。では、このルールに従ってコンポーネントの名前を変えてみましょう。

```
components/
|- SearchButtonClear.vue
|- SearchButtonRun.vue
|- SearchInputExcludeGlob.vue
|- SearchInputQuery.vue
|- SettingsCheckboxLaunchOnStartup.vue
|- SettingsCheckboxTerms.vue
```

<!--
Since editors typically organize files alphabetically, all the important relationships between components are now evident at a glance.

You might be tempted to solve this problem differently, nesting all the search components under a "search" directory, then all the settings components under a "settings" directory. We only recommend considering this approach in very large apps (e.g. 100+ components), for these reasons:

- It generally takes more time to navigate through nested sub-directories, than scrolling through a single `components` directory.
-->
一般的にエディタではファイルはアルファベット順に並ぶので、コンポーネント間のあらゆる重要な関連性は一目ではっきりと分かります。

あなたは、これを別の方法で解決したいと思うかもしれません。つまり、すべての検索コンポーネントは search ディレクトリの下に、すべての設定コンポーネントは settings ディレクトリの下にネストするという方法です。
私たちは、以下の理由から、とても大規模なアプリケーション(例えば100以上のコンポーネントがあるような)の場合に限ってこのアプローチを考慮することを推奨します:

- 一般的に、入れ子のサブディレクトリの中を移動するのは、単一の components ディレクトリをスクロールするのと比べて余分に時間がかかります。

{% raw %}</details>{% endraw %}

{% raw %}<div class="style-example example-bad">{% endraw %}
#### 悪い例

```
components/
|- ClearSearchButton.vue
|- ExcludeFromSearchInput.vue
|- LaunchOnStartupCheckbox.vue
|- RunSearchButton.vue
|- SearchInput.vue
|- TermsCheckbox.vue
```
{% raw %}</div>{% endraw %}

{% raw %}<div class="style-example example-good">{% endraw %}
#### 良い例

```
components/
|- SearchButtonClear.vue
|- SearchButtonRun.vue
|- SearchInputQuery.vue
|- SearchInputExcludeGlob.vue
|- SettingsCheckboxTerms.vue
|- SettingsCheckboxLaunchOnStartup.vue
```
{% raw %}</div>{% endraw %}



### 自己終了形式のコンポーネント <sup data-p="b">強く推奨</sup>

<!--
**Components with no content should be self-closing in [single-file components](../guide/single-file-components.html), string templates, and [JSX](../guide/render-function.html#JSX) - but never in DOM templates.**

Components that self-close communicate that they not only have no content, but are **meant** to have no content. It's the difference between a blank page in a book and one labeled "This page intentionally left blank." Your code is also cleaner without the unnecessary closing tag.
-->
**中身を持たないコンポーネントは、 [単一ファイルコンポーネント](../guide/single-file-components.html) 、文字列テンプレート、および [JSX](render-function.html#JSX) の中では自己終了形式で書くべきです。ただし、DOM テンプレート内ではそうしてはいけません。**

自己終了形式のコンポーネントは、単に中身を持たないというだけでなく、中身を持たないことを **意図したものだ** ということをはっきりと表現します。
本の中にある白紙のページと、「このページは意図的に白紙のままにしています」と書かれたページとは違うということです。また、不要な閉じタグがなくなることによってあなたのコードはより読みやすくなります。


<!--
Unfortunately, HTML doesn't allow custom elements to be self-closing - only [official "void" elements](https://www.w3.org/TR/html/syntax.html#void-elements). That's why the strategy is only possible when Vue's template compiler can reach the template before the DOM, then serve the DOM spec-compliant HTML.
-->
残念ながら、HTML はカスタム要素の自己終了形式を許していません。 - [公式の「空」要素](https://www.w3.org/TR/html/syntax.html#void-elements) だけです。
これが、Vue のテンプレートコンパイラが DOM よりも先にテンプレートにアクセスして、その後 DOM の仕様に準拠した HTML を出力することができる場合にだけこの方策を使うことができる理由です。 


{% raw %}<div class="style-example example-bad">{% endraw %}
#### 悪い例

``` html
<!-- 単一ファイルコンポーネント、文字列テンプレート、JSX の中 -->
<MyComponent></MyComponent>
```

``` html
<!-- DOM テンプレートの中 -->
<my-component/>
```
{% raw %}</div>{% endraw %}

{% raw %}<div class="style-example example-good">{% endraw %}
#### 良い例

``` html
<!-- 単一ファイルコンポーネント、文字列テンプレート、JSX の中 -->
<MyComponent/>
```

``` html
<!-- DOM テンプレートの中 -->
<my-component></my-component>
```
{% raw %}</div>{% endraw %}



### テンプレート内でのコンポーネント名の形式<sup data-p="b">強く推奨</sup>

<!--
**Component names should always be PascalCase in [single-file components](../guide/single-file-components.html) and string templates - but kebab-case in DOM templates.**
-->
**コンポーネント名は [単一ファイルコンポーネント](../guide/single-file-components.html) と文字列テンプレートの中では常にパスカルケース(PascalCase)であるべきです。 - しかし、 DOM テンプレートの中ではケバブケース(kebab-case)です。**

<!--
PascalCase has a few advantages over kebab-case:

- Editors can autocomplete component names in templates, because PascalCase is also used in JavaScript.
- `<MyComponent>` is more visually distinct from a single-word HTML element than `<my-component>`, because there are two character differences (the two capitals), rather than just one (a hyphen).
- If you use any non-Vue custom elements in your templates, such as a web component, PascalCase ensures that your Vue components remain distinctly visible.

Unfortunately, due to HTML's case insensitivity, DOM templates must still use kebab-case.
-->
パスカルケースには、ケバブケースよりも優れた点がいくつかあります:

- パスカルケースは JavaScript でも使われるので、エディタがテンプレート内のコンポーネント名を自動補完できます。
- `<MyComponent>` は `<my-component>` よりも一単語の HTML 要素との見分けがつきやすいです。なぜなら、ハイフン1文字だけの違いではなく2文字(2つの大文字)の違いがあるからです。
- もし、テンプレート内で、例えば Web コンポーネントのような Vue 以外のカスタム要素を使っていたとしても、パスカルケースは Vue コンポーネントがはっきりと目立ったせることを保証します。

残念ですが、HTML は大文字と小文字を区別しないので、DOM テンプレートの中ではまだケバブケースを使う必要があります。

{% raw %}<div class="style-example example-bad">{% endraw %}
#### 悪い例

``` html
<!-- 単一ファイルコンポーネント、文字列テンプレートの中 -->
<mycomponent/>
```

``` html
<!-- 単一ファイルコンポーネント、文字列テンプレートの中 -->
<my-component/>
```

``` html
<!-- 単一ファイルコンポーネント、文字列テンプレートの中 -->
<myComponent/>
```

``` html
<!-- DOM テンプレートの中 -->
<MyComponent></MyComponent>
```
{% raw %}</div>{% endraw %}

{% raw %}<div class="style-example example-good">{% endraw %}
#### 良い例

``` html
<!-- 単一ファイルコンポーネント、文字列テンプレートの中 -->
<MyComponent/>
```

``` html
<!-- DOM テンプレートの中 -->
<my-component></my-component>
```
{% raw %}</div>{% endraw %}



### JS/JSX 内でのコンポーネント名の形式 <sup data-p="b">強く推奨</sup>

<!--
**Component names in JS/[JSX](../guide/render-function.html#JSX) should always be PascalCase, though may be kebab-case inside strings for simpler applications that only use global component registration through `Vue.component`.**
-->
**JS/[JSX](../guide/render-function.html#JSX) 内でのコンポーネント名はつねにパスカルケース(PascalCase)にするべきです。
ただし、 `Vue.component` で登録したグローバルコンポーネントしか使わないような単純なアプリケーションでは、ケバブケース(kebab-case)を含む文字列になるかもしれません。**

{% raw %}
<details>
<summary>
  <h4>詳細な説明</h4>
</summary>
{% endraw %}

<!--
In JavaScript, PascalCase is the convention for classes and prototype constructors - essentially, anything that can have distinct instances. Vue components also have instances, so it makes sense to also use PascalCase. As an added benefit, using PascalCase within JSX (and templates) allows readers of the code to more easily distinguish between components and HTML elements.

However, for applications that use **only** global component definitions via `Vue.component`, we recommend kebab-case instead. The reasons are:

- It's rare that global components are ever referenced in JavaScript, so following a convention for JavaScript makes less sense.
- These applications always include many in-DOM components, where kebab-case [**must** be used](#Component-name-casing-in-templates).

XXX:
    in-DOM components は in-DOM templates の間違いではないかと思われる
    #Component-name-casing-in-templates は正しいリンクになっていない。正しくは #Component-name-casing-in-templates-strongly-recommended
-->
JavaScript では、クラスやプロトタイプのコンストラクタは - 原則として異なるインスタンスを持ちうるものはすべて - パスカルケースにするのがしきたりです。
Vue コンポーネントもインスタンスをもつので、同じようにパスカルケースにするのが理にかなっています。
さらなる利点として、JSX(とテンプレート)の中でパスカルケースを使うことによって、コードを読む人がコンポーネントと HTML 要素をより簡単に見分けられるようになります。

しかし、`Vue.component` によるグローバルコンポーネント定義 **だけ** を使うアプリケーションでは、代わりにケバブケースを使うことを推奨します。理由は以下の通りです:

- グローバルコンポーネントを JavaScript から参照することはほとんどないので、 JavaScript の原則に従う意味もほとんどありません。
- そのようなアプリケーションはたくさんの DOM 内コンポーネント をもつのが常ですが、 そこでは ケバブケースを [**必ず** 使う必要があります](#テンプレート内でのコンポーネント名の形式-強く推奨)

{% raw %}</details>{% endraw %}

{% raw %}<div class="style-example example-bad">{% endraw %}
#### 悪い例

``` js
Vue.component('myComponent', {
  // ...
})
```

``` js
import myComponent from './MyComponent.vue'
```

``` js
export default {
  name: 'myComponent',
  // ...
}
```

``` js
export default {
  name: 'my-component',
  // ...
}
```
{% raw %}</div>{% endraw %}

{% raw %}<div class="style-example example-good">{% endraw %}
#### 良い例

``` js
Vue.component('MyComponent', {
  // ...
})
```

``` js
Vue.component('my-component', {
  // ...
})
```

``` js
import MyComponent from './MyComponent.vue'
```

``` js
export default {
  name: 'MyComponent',
  // ...
}
```
{% raw %}</div>{% endraw %}



### 完全な単語によるコンポーネント名 <sup data-p="b">強く推奨</sup>

<!--
**Component names should prefer full words over abbreviations.**

The autocompletion in editors make the cost of writing longer names very low, while the clarity they provide is invaluable. Uncommon abbreviations, in particular, should always be avoided.
-->
**コンポーネント名には、略語よりも完全な単語を使うべきです。**

長い名前によってもたらされる明快さは非常に貴重ですが、それをタイプする労力はエディタの自動補完によってとても小さくなります。特に、一般的でない略語は常に避けるべきです。

{% raw %}<div class="style-example example-bad">{% endraw %}
#### 悪い例

```
components/
|- SdSettings.vue
|- UProfOpts.vue
```
{% raw %}</div>{% endraw %}

{% raw %}<div class="style-example example-good">{% endraw %}
#### 良い例

```
components/
|- StudentDashboardSettings.vue
|- UserProfileOptions.vue
```
{% raw %}</div>{% endraw %}



### プロパティ名の型式 <sup data-p="b">強く推奨</sup>

<!--
**Prop names should always use camelCase during declaration, but kebab-case in templates and [JSX](../guide/render-function.html#JSX).**

We're simply following the conventions of each language. Within JavaScript, camelCase is more natural. Within HTML, kebab-case is.
-->
**プロパティ名は、定義の時は常にキャメルケース(camelCase)にするべきですが、テンプレートや [JSX](../guide/render-function.html#JSX) ではケバブケース(kebab-case)にするべきです。**

私たちは単純にこの慣習に従っています。JavaScript の中ではキャメルケースがより自然であり、HTML の中ではケバブケースが自然です。

{% raw %}<div class="style-example example-bad">{% endraw %}
#### 悪い例

``` js
props: {
  'greeting-text': String
}
```

``` html
<WelcomeMessage greetingText="hi"/>
```
{% raw %}</div>{% endraw %}

{% raw %}<div class="style-example example-good">{% endraw %}
#### 良い例

``` js
props: {
  greetingText: String
}
```

``` html
<WelcomeMessage greeting-text="hi"/>
```
{% raw %}</div>{% endraw %}



### 複数の属性をもつ要素 <sup data-p="b">強く推奨</sup>

<!--
**Elements with multiple attributes should span multiple lines, with one attribute per line.**

In JavaScript, splitting objects with multiple properties over multiple lines is widely considered a good convention, because it's much easier to read. Our templates and [JSX](../guide/render-function.html#JSX) deserve the same consideration.
-->
**複数の属性をもつ要素は、１行に１要素ずつ、複数の行にわたって書くべきです。**

JavaScript では、複数のプロパティをもつ要素を複数の行に分けて書くことはよい慣習だと広く考えられています。なぜなら、その方がより読みやすいからです。
Vue のテンプレートや [JSX](../guide/render-function.html#JSX) も同じように考えることがふさわしいです。

{% raw %}<div class="style-example example-bad">{% endraw %}
#### 悪い例

``` html
<img src="https://vuejs.org/images/logo.png" alt="Vue Logo">
```

``` html
<MyComponent foo="a" bar="b" baz="c"/>
```
{% raw %}</div>{% endraw %}

{% raw %}<div class="style-example example-good">{% endraw %}
#### 良い例

``` html
<img
  src="https://vuejs.org/images/logo.png"
  alt="Vue Logo"
>
```

``` html
<MyComponent
  foo="a"
  bar="b"
  baz="c"
/>
```
{% raw %}</div>{% endraw %}



### テンプレート内での複雑な式 <sup data-p="b">強く推奨</sup>

<!--
**Component templates should only include simple expressions, with more complex expressions refactored into computed properties or methods.**

Complex expressions in your templates make them less declarative. We should strive to describe _what_ should appear, not _how_ we're computing that value. Computed properties and methods also allow the code to be reused.
-->
**複雑な式は算出プロパティかメソッドにリファクタリングして、コンポーネントのテンプレートには単純な式だけを含むようにするべきです。**

テンプレート内に複雑な式があると、テンプレートが宣言的ではなくなります。私たちは、 __どのように__ その値を算出するかではなく、 __何が__ 表示されるべきかを記述するように努力するべきです。
また、算出プロパティやメソッドによってコードが再利用できるようになります。

{% raw %}<div class="style-example example-bad">{% endraw %}
#### 悪い例

``` html
{{
  fullName.split(' ').map(function (word) {
    return word[0].toUpperCase() + word.slice(1)
  }).join(' ')
}}
```
{% raw %}</div>{% endraw %}

{% raw %}<div class="style-example example-good">{% endraw %}
#### 良い例

``` html
<!-- テンプレート内 -->
{{ normalizedFullName }}
```

``` js
// The complex expression has been moved to a computed property
computed: {
  normalizedFullName: function () {
    return this.fullName.split(' ').map(function (word) {
      return word[0].toUpperCase() + word.slice(1)
    }).join(' ')
  }
}
```
{% raw %}</div>{% endraw %}



### 複雑な算出プロパティ <sup data-p="b">強く推奨</sup>

<!--
**Complex computed properties should be split into as many simpler properties as possible.**
-->
**複雑な算出プロパティは、できる限りたくさんの単純なプロパティに分割するべきです。**

{% raw %}
<details>
<summary>
  <h4>詳細な説明</h4>
</summary>
{% endraw %}

<!--
Simpler, well-named computed properties are:

- __Easier to test__

  When each computed property contains only a very simple expression, with very few dependencies, it's much easier to write tests confirming that it works correctly.

- __Easier to read__

  Simplifying computed properties forces you to give each value a descriptive name, even if it's not reused. This makes it much easier for other developers (and future you) to focus in on the code they care about and figure out what's going on.

- __More adaptable to changing requirements__

  Any value that can be named might be useful to the view. For example, we might decide to display a message telling the user how much money they saved. We might also decide to calculate sales tax, but perhaps display it separately, rather than as part of the final price.

  Small, focused computed properties make fewer assumptions about how information will be used, so require less refactoring as requirements change.
-->
単純な、よい名前を持つ算出プロパティは:

- __テストしやすい__
  それぞれの算出プロパティが、依存がとても少ないごく単純な式だけを含む場合、それが正しく動くことを確認するテストを書くことがより簡単になります。

- __読みやすい__
  算出プロパティを単純にするということは、たとえそれが再利用可能ではなかったとしても、それぞれに分かりやすい名前をつけることになります。
  それによって、他の開発者(そして未来のあなた)が、注意を払うべきコードに集中し、何が起きているかを把握することがより簡単になります。

- __要求の変更を受け入れやすい__

  名前をつけることができる値は何でも、ビューでも役に立つ可能性があります。
  例えば、いくら割引になっているかをユーザに知らせるメッセージを表示することに決めたとします。 また、消費税も計算して、最終的な価格の一部としてではなく、別々に表示することにします。

  小さくフォーカスした算出プロパティは、どのように情報が使われるかについての決めつけをより少なくし、少しのリファクタリングで要求の変更を受け入れられるようになります。

{% raw %}</details>{% endraw %}

{% raw %}<div class="style-example example-bad">{% endraw %}
#### 悪い例

``` js
computed: {
  price: function () {
    var basePrice = this.manufactureCost / (1 - this.profitMargin)
    return (
      basePrice -
      basePrice * (this.discountPercent || 0)
    )
  }
}
```
{% raw %}</div>{% endraw %}

{% raw %}<div class="style-example example-good">{% endraw %}
#### 良い例

``` js
computed: {
  basePrice: function () {
    return this.manufactureCost / (1 - this.profitMargin)
  },
  discount: function () {
    return this.basePrice * (this.discountPercent || 0)
  },
  finalPrice: function () {
    return this.basePrice - this.discount
  }
}
```
{% raw %}</div>{% endraw %}



### 引用符つきの属性値 <sup data-p="b">強く推奨</sup>

<!--
**Non-empty HTML attribute values should always be inside quotes (single or double, whichever is not used in JS).**

While attribute values without any spaces are not required to have quotes in HTML, this practice often leads to _avoiding_ spaces, making attribute values less readable.
-->
**空ではない HTML 属性の値は常に引用符(シングルコーテーションかダブルコーテーション、 JS の中で使われていない方)でくくるべきです。**

HTML では、空白を含まない属性値は引用符でくくらなくてもよいことになっていますが、そのせいで空白の使用を _避けてしまい_ 属性値が読みづらくなることをしばしばもたらします。

{% raw %}<div class="style-example example-bad">{% endraw %}
#### 悪い例

``` html
<input type=text>
```

``` html
<AppSidebar :style={width:sidebarWidth+'px'}>
```
{% raw %}</div>{% endraw %}

{% raw %}<div class="style-example example-good">{% endraw %}
#### 良い例

``` html
<input type="text">
```

``` html
<AppSidebar :style="{ width: sidebarWidth + 'px' }">
```
{% raw %}</div>{% endraw %}



### ディレクティブの短縮記法 <sup data-p="b">強く推奨</sup>

<!--
**Directive shorthands (`:` for `v-bind:` and `@` for `v-on:`) should be used always or never.**
-->
**ディレクティブの短縮記法 (`v-bind:` に対する `:` 、 `v-on:` に対する `@`)は、常に使うか、まったく使わないかのどちらかにするべきです。**

{% raw %}<div class="style-example example-bad">{% endraw %}
#### 悪い例

``` html
<input
  v-bind:value="newTodoText"
  :placeholder="newTodoInstructions"
>
```

``` html
<input
  v-on:input="onInput"
  @focus="onFocus"
>
```
{% raw %}</div>{% endraw %}

{% raw %}<div class="style-example example-good">{% endraw %}
#### 良い例

``` html
<input
  :value="newTodoText"
  :placeholder="newTodoInstructions"
>
```

``` html
<input
  v-bind:value="newTodoText"
  v-bind:placeholder="newTodoInstructions"
>
```

``` html
<input
  @input="onInput"
  @focus="onFocus"
>
```

``` html
<input
  v-on:input="onInput"
  v-on:focus="onFocus"
>
```
{% raw %}</div>{% endraw %}



## Priority C Rules: Recommended (Minimizing Arbitrary Choices and Cognitive Overhead)



### Component/instance options order <sup data-p="c">recommended</sup>

**Component/instance options should be ordered consistently.**

This is the default order we recommend for component options. They're split into categories, so you'll know where to add new properties from plugins.

1. **Side Effects** (triggers effects outside the component)
  - `el`

2. **Global Awareness** (requires knowledge beyond the component)
  - `name`
  - `parent`

3. **Component Type** (changes the type of the component)
  - `functional`

4. **Template Modifiers** (changes the way templates are compiled)
  - `delimiters`
  - `comments`

5. **Template Dependencies** (assets used in the template)
  - `components`
  - `directives`
  - `filters`

6. **Composition** (merges properties into the options)
  - `extends`
  - `mixins`

7. **Interface** (the interface to the component)
  - `inheritAttrs`
  - `model`
  - `props`/`propsData`

8. **Local State** (local reactive properties)
  - `data`
  - `computed`

9. **Events** (callbacks triggered by reactive events)
  - `watch`
  - Lifecycle Events (in the order they are called)

10. **Non-Reactive Properties** (instance properties independent of the reactivity system)
  - `methods`

11. **Rendering** (the declarative description of the component output)
  - `template`/`render`
  - `renderError`



### Element attribute order <sup data-p="c">recommended</sup>

**The attributes of elements (including components) should be ordered consistently.**

This is the default order we recommend for component options. They're split into categories, so you'll know where to add custom attributes and directives.

1. **Definition** (provides the component options)
  - `is`

2. **List Rendering** (creates multiple variations of the same element)
  - `v-for`

2. **Conditionals** (whether the element is rendered/shown)
  - `v-if`
  - `v-else-if`
  - `v-else`
  - `v-show`
  - `v-cloak`

3. **Render Modifiers** (changes the way the element renders)
  - `v-pre`
  - `v-once`

4. **Global Awareness** (requires knowledge beyond the component)
  - `id`

5. **Unique Attributes** (attributes that require unique values)
  - `ref`
  - `key`
  - `slot`

6. **Two-Way Binding** (combining binding and events)
  - `v-model`

7. **Other Attributes** (all unspecified bound & unbound attributes)

8. **Events** (component event listeners)
  - `v-on`

9. **Content** (overrides the content of the element)
  - `v-html`
  - `v-text`



### Empty lines in component/instance options <sup data-p="c">recommended</sup>

**You may want to add one empty line between multi-line properties, particularly if the options can no longer fit on your screen without scrolling.**

When components begin to feel cramped or difficult to read, adding spaces between multi-line properties can make them easier to skim again. In some editors, such as Vim, formatting options like this can also make them easier to navigate with the keyboard.

{% raw %}<div class="style-example example-good">{% endraw %}
#### Good

``` js
props: {
  value: {
    type: String,
    required: true
  },

  focused: {
    type: Boolean,
    default: false
  },

  label: String,
  icon: String
},

computed: {
  formattedValue: function () {
    // ...
  },

  inputClasses: function () {
    // ...
  }
}
```

``` js
// No spaces are also fine, as long as the component
// is still easy to read and navigate.
props: {
  value: {
    type: String,
    required: true
  },
  focused: {
    type: Boolean,
    default: false
  },
  label: String,
  icon: String
},
computed: {
  formattedValue: function () {
    // ...
  },
  inputClasses: function () {
    // ...
  }
}
```
{% raw %}</div>{% endraw %}



### Single-file component top-level element order <sup data-p="c">recommended</sup>

**[Single-file components](../guide/single-file-components.html) should always order `template`, `script`, and `style` tags consistently, with `<style>` last, because at least one of the other two is always necessary.**

{% raw %}<div class="style-example example-bad">{% endraw %}
#### Bad

``` html
<style>/* ... */</style>
<template>...</template>
<script>/* ... */</script>
```

``` html
<!-- ComponentA.vue -->
<script>/* ... */</script>
<template>...</template>
<style>/* ... */</style>

<!-- ComponentB.vue -->
<template>...</template>
<script>/* ... */</script>
<style>/* ... */</style>
```
{% raw %}</div>{% endraw %}

{% raw %}<div class="style-example example-good">{% endraw %}
#### Good

``` html
<!-- ComponentA.vue -->
<template>...</template>
<script>/* ... */</script>
<style>/* ... */</style>

<!-- ComponentB.vue -->
<template>...</template>
<script>/* ... */</script>
<style>/* ... */</style>
```

``` html
<!-- ComponentA.vue -->
<script>/* ... */</script>
<template>...</template>
<style>/* ... */</style>

<!-- ComponentB.vue -->
<script>/* ... */</script>
<template>...</template>
<style>/* ... */</style>
```
{% raw %}</div>{% endraw %}



## Priority D Rules: Use with Caution (Potentially Dangerous Patterns)



### `v-if`/`v-if-else`/`v-else` without `key` <sup data-p="d">use with caution</sup>

**It's usually best to use `key` with `v-if` + `v-else`, if they are the same element type (e.g. both `<div>` elements).**

By default, Vue updates the DOM as efficiently as possible. That means when switching between elements of the same type, it simply patches the existing element, rather than removing it and adding a new one in its place. This can have [unintended side effects](https://jsfiddle.net/chrisvfritz/bh8fLeds/) if these elements should not actually be considered the same.

{% raw %}<div class="style-example example-bad">{% endraw %}
#### Bad

``` html
<div v-if="error">
  Error: {{ error }}
</div>
<div v-else>
  {{ results }}
</div>
```
{% raw %}</div>{% endraw %}

{% raw %}<div class="style-example example-good">{% endraw %}
#### Good

``` html
<div v-if="error" key="search-status">
  Error: {{ error }}
</div>
<div v-else key="search-results">
  {{ results }}
</div>
```

``` html
<p v-if="error">
  Error: {{ error }}
</p>
<div v-else>
  {{ results }}
</div>
```
{% raw %}</div>{% endraw %}



### Element selectors with `scoped` <sup data-p="d">use with caution</sup>

**Element selectors should be avoided with `scoped`.**

Prefer class selectors over element selectors in `scoped` styles, because large numbers of element selectors are slow.

{% raw %}
<details>
<summary>
  <h4>Detailed Explanation</h4>
</summary>
{% endraw %}

To scope styles, Vue adds a unique attribute to component elements, such as `data-v-f3f3eg9`. Then selectors are modified so that only matching elements with this attribute are selected (e.g. `button[data-v-f3f3eg9]`).

The problem is that large numbers of [element-attribute selectors](http://stevesouders.com/efws/css-selectors/csscreate.php?n=1000&sel=a%5Bhref%5D&body=background%3A+%23CFD&ne=1000) (e.g. `button[data-v-f3f3eg9]`) will be considerably slower than [class-attribute selectors](http://stevesouders.com/efws/css-selectors/csscreate.php?n=1000&sel=.class%5Bhref%5D&body=background%3A+%23CFD&ne=1000) (e.g. `.btn-close[data-v-f3f3eg9]`), so class selectors should be preferred whenever possible.

{% raw %}</details>{% endraw %}

{% raw %}<div class="style-example example-bad">{% endraw %}
#### Bad

``` html
<template>
  <button>X</button>
</template>

<style scoped>
button {
  background-color: red;
}
</style>
```
{% raw %}</div>{% endraw %}

{% raw %}<div class="style-example example-good">{% endraw %}
#### Good

``` html
<template>
  <button class="btn btn-close">X</button>
</template>

<style scoped>
.btn-close {
  background-color: red;
}
</style>
```
{% raw %}</div>{% endraw %}



### Parent-child communication <sup data-p="d">use with caution</sup>

**Props and events should be preferred for parent-child component communication, instead of `this.$parent` or mutating props.**

An ideal Vue application is props down, events up. Sticking to this convention makes your components much easier to understand. However, there are edge cases where prop mutation or `this.$parent` can simplify two components that are already deeply coupled.

The problem is, there are also many _simple_ cases where these patterns may offer convenience. Beware: do not be seduced into trading simplicity (being able to understand the flow of your state) for short-term convenience (writing less code).

{% raw %}<div class="style-example example-bad">{% endraw %}
#### Bad

``` js
Vue.component('TodoItem', {
  props: {
    todo: {
      type: Object,
      required: true
    }
  },
  template: '<input v-model="todo.text">'
})
```

``` js
Vue.component('TodoItem', {
  props: {
    todo: {
      type: Object,
      required: true
    }
  },
  methods: {
    removeTodo () {
      var vm = this
      vm.$parent.todos = vm.$parent.todos.filter(function (todo) {
        return todo.id !== vm.todo.id
      })
    }
  },
  template: `
    <span>
      {{ todo.text }}
      <button @click="removeTodo">
        X
      </button>
    </span>
  `
})
```
{% raw %}</div>{% endraw %}

{% raw %}<div class="style-example example-good">{% endraw %}
#### Good

``` js
Vue.component('TodoItem', {
  props: {
    todo: {
      type: Object,
      required: true
    }
  },
  template: `
    <input
      :value="todo.text"
      @input="$emit('input', $event.target.value)"
    >
  `
})
```

``` js
Vue.component('TodoItem', {
  props: {
    todo: {
      type: Object,
      required: true
    }
  },
  template: `
    <span>
      {{ todo.text }}
      <button @click="$emit('delete')">
        X
      </button>
    </span>
  `
})
```
{% raw %}</div>{% endraw %}



### Global state management <sup data-p="d">use with caution</sup>

**[Vuex](https://github.com/vuejs/vuex) should be preferred for global state management, instead of `this.$root` or a global event bus.**

Managing state on `this.$root` and/or using a [global event bus](https://vuejs.org/v2/guide/migration.html#dispatch-and-broadcast-replaced) can be convenient for very simple cases, but are not appropriate for most applications. Vuex offers not only a central place to manage state, but also tools for organizing, tracking, and debugging state changes.

{% raw %}</details>{% endraw %}

{% raw %}<div class="style-example example-bad">{% endraw %}
#### Bad

``` js
// main.js
new Vue({
  data: {
    todos: []
  },
  created: function () {
    this.$on('remove-todo', this.removeTodo)
  },
  methods: {
    removeTodo: function (todo) {
      var todoIdToRemove = todo.id
      this.todos = this.todos.filter(function (todo) {
        return todo.id !== todoIdToRemove
      })
    }
  }
})
```
{% raw %}</div>{% endraw %}

{% raw %}<div class="style-example example-good">{% endraw %}
#### Good

``` js
// store/modules/todos.js
export default {
  state: {
    list: []
  },
  mutations: {
    REMOVE_TODO (state, todoId) {
      state.list = state.list.filter(todo => todo.id !== todoId)
    }
  },
  actions: {
    removeTodo ({ commit, state }, todo) {
      commit('REMOVE_TODO', todo.id)
    }
  }
}
```

``` html
<!-- TodoItem.vue -->
<template>
  <span>
    {{ todo.text }}
    <button @click="removeTodo(todo)">
      X
    </button>
  </span>
</template>

<script>
import { mapActions } from 'vuex'

export default {
  props: {
    todo: {
      type: Object,
      required: true
    }
  },
  methods: mapActions(['removeTodo'])
}
</script>
```
{% raw %}</div>{% endraw %}



{% raw %}
<script>
(function () {
  var enforcementTypes = {
    none: '<span title="There is unfortunately no way to automatically enforce this rule.">self-discipline</span>',
    runtime: 'runtime error',
    linter: '<a href="https://github.com/vuejs/eslint-plugin-vue#eslint-plugin-vue" target="_blank">plugin:vue/recommended</a>'
  }
  Vue.component('sg-enforcement', {
    template: '\
      <span>\
        <strong>Enforcement</strong>:\
        <span class="style-rule-tag" v-html="humanType"/>\
      </span>\
    ',
    props: {
      type: {
        type: String,
        required: true,
        validate: function (value) {
          Object.keys(enforcementTypes).indexOf(value) !== -1
        }
      }
    },
    computed: {
      humanType: function () {
        return enforcementTypes[this.type]
      }
    }
  })

  // new Vue({
  //  el: '#main'
  // })
})()
</script>
{% endraw %}
