---
type: style-guide
updated: 2017-10-09
---

# スタイルガイド <sup class="beta">beta</sup>

> 注意⚠️ : このドキュメントはまだ完全に翻訳されていません。このページは[随時翻訳作業](https://github.com/vuejs/jp.vuejs.org/projects/2)につき更新されていきます🙏 ！

This is the official style guide for Vue-specific code. If you use Vue in a project, it's a great reference to avoid errors, bikeshedding, and anti-patterns. However, we don't believe that any style guide is ideal for all teams or projects, so mindful deviations are encouraged based on past experience, the surrounding tech stack, and personal values.

For the most part, we also avoid suggestions about JavaScript or HTML in general. We don't mind whether you use semicolons or trailing commas. We don't mind whether your HTML uses single-quotes or double-quotes for attribute values. Some exceptions will exist however, where we've found that a particular pattern is helpful in the context of Vue.

> **Soon, we'll also provide tips for enforcement.** Sometimes you'll simply have to be disciplined, but wherever possible, we'll try to show you how to use ESLint and other automated processes to make enforcement simpler.

Finally, we've split rules into four categories:



## Rule Categories

### Priority A: Essential

These rules help prevent errors, so learn and abide by them at all costs. Exceptions may exist, but should be very rare and only be made by those with expert knowledge of both JavaScript and Vue.

### 優先度 B: 強く推奨

これらのルールは、ほとんどのプロジェクトで読みやすさや開発者の体験をよりよくするために見いだされました。これらに違反してもあなたのコードは動きますが、ごくまれなケースで、かつちゃんと正当を示した上でのみ違反するようにすべきです。

### 優先度 C: 推奨

同じくらい良いオプションが複数ある場合､一貫性を確保するために任意の選択をすることができます｡これらのルールでは､それぞれ許容可能なオプションを説明し､既定の選択を提案します｡つまり､一貫性があり､良い理由を持ち続ける限り､独自のコードベースで自由に異なる選択肢を作ることができます｡ですが､良い理由はあるのでしょうか！コミュニティの標準に合わせることで､あなたは:

1. 直面するコミュニティのコードを容易に理解できるように脳を慣れさせます｡
2. ほとんどのコミュニティのコードサンプルを変更なしにコピーして貼り付ける事ができます｡
3. 少なくとも Vue に関しては､ほとんどの場合､新たな人材はあなたのコーディングスタイルよりも既に慣れ親しんだものを好みます｡

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

<!-- Using the `scoped` attribute -->
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

**[単一ファイルコンポーネント](../guide/single-file-components.html) のファイル名は、すべてパスカルケース (PascalCase) にするか、すべてケバブケース (kebab-case) にするべきです。**

パスカルケースは、JS(X) やテンプレートの中でコンポーネントを参照する方法と一致しているので、コードエディタ上でオートコンプリートが可能な場合はとてもうまく働きます。しかし、大文字と小文字が混ざったファイル名は、大文字と小文字を区別しないファイルシステム上で時々問題を起こす可能性があります。そのため、ケバブケースもまた完全に受け入れられています。

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

**アプリケーション特有のスタイルやルールを適用する基底コンポーネント (またはプレゼンテーションコンポーネント: Presentation Components、ダムコンポーネント: Dumb Components、純粋コンポーネント: Pure Components とも) は、すべて `Base` 、 `App` 、`V` などの固有のプレフィックスで始まるべきです。**

{% raw %}
<details>
<summary>
  <h4>詳細な説明</h4>
</summary>
{% endraw %}

これらのコンポーネントは、あなたのアプリケーションに一貫したスタイルやふるまいをもたせる基礎として位置づけられます。これらは、おそらく以下のもの **だけ** を含むでしょう:

- HTML 要素、
- `Base` で始まる別のコンポーネント、そして
- サードパーティ製の UI コンポーネント

これらのコンポーネントの名前は、しばしばラップしている要素の名前を含みます(例えば `BaseButton` 、 `BaseTable`)。それ特有の目的のための要素がない場合は別ですが(例えば `BaseIcon`)。もっと特定の用途に向けた同じようなコンポーネントを作る時は、ほとんどすべての場合にこれらのコンポーネントを使うことになるでしょう。(例えば `BaseButton` を `ButtonSubmit` で使うなど)

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

**常に 1 つのアクティブなインスタンスしか持たないコンポーネントは、1 つしか存在しえないことを示すために `The` というプレフィックスで始めるべきです。**

これはそのコンポーネントが 1 つのページでしか使われないということを意味するのではなく、 _ページごとに_  1 回しか使われないという意味です。これらのコンポーネントは、アプリケーション内のコンテキストではなく、アプリケーションに対して固有のため、決してプロパティを受け入れることはありません。もしプロパティを追加する必要があることに気づいたのなら、それは _現時点で_ ページごとに 1 回しか使われていないだけで、実際には再利用可能なコンポーネントだということを示すよい目印です。


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

**親コンポーネントと密結合した子コンポーネントには、親コンポーネントの名前をプレフィックスとして含むべきです。**

もし、コンポーネントが単一の親コンポーネントの中でだけ意味をもつものなら、その関連性は名前からはっきりわかるようにするべきです。一般的にエディタはファイルをアルファベット順に並べるので、関連をもつものどうしが常に隣り合って並ぶことにもなります。

{% raw %}
<details>
<summary>
  <h4>詳細な説明</h4>
</summary>
{% endraw %}

この問題を、子コンポーネントを親コンポーネントの名前を元に命名したディレクトリの中に入れることで解決したいと思うかもしれません。
例えば:

```
components/
|- TodoList/
   |- Item/
      |- index.vue
      |- Button.vue
   |- index.vue
```

もしくは:

```
components/
|- TodoList/
   |- Item/
      |- Button.vue
   |- Item.vue
|- TodoList.vue
```

これは推奨されません。以下のような結果を生むからです:

- 同じような名前のファイルがたくさんできてしまい、コードエディタ上で素早くファイルを切り替えるのが難しくなります。
- ネストしたサブディレクトリがたくさんできてしまい、エディタのサイドバーでコンポーネントを参照するのに時間がかかるようになります。

{% raw %}</details>{% endraw %}

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

**コンポーネント名は、最高レベルの(たいていは最も一般的な)単語から始めて、説明的な修飾語で終わるべきです。**

{% raw %}
<details>
<summary>
  <h4>詳細な説明</h4>
</summary>
{% endraw %}

あなたは疑問に思うかもしれません:

> "なぜコンポーネント名に自然な言語でないものを使うように強制するのですか？"

自然な英語では、形容詞やその他の記述子は一般的に名詞の前に置かれ、そうでない場合には接続詞が必要になります。例えば:

- Coffee _with_ milk
- Soup _of the_ day
- Visitor _to the_ museum

もちろん、あなたがそうしたいのならば、これらの接続詞をコンポーネント名に含めても構いませんが、それでも順番は重要です。

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

一般的にエディタではファイルはアルファベット順に並ぶので、コンポーネント間のあらゆる重要な関連性はひと目ではっきりと分かります。

あなたは、これを別の方法で解決したいと思うかもしれません。つまり、すべての検索コンポーネントは search ディレクトリの下に、すべての設定コンポーネントは settings ディレクトリの下にネストするという方法です。以下の理由から、とても大規模なアプリケーション(例えば 100 以上のコンポーネントがあるような)の場合に限ってこのアプローチを考慮することを推奨します:

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

**中身を持たないコンポーネントは、 [単一ファイルコンポーネント](../guide/single-file-components.html) 、文字列テンプレート、および [JSX](render-function.html#JSX) の中では自己終了形式で書くべきです。ただし、DOM テンプレート内ではそうしてはいけません。**

自己終了形式のコンポーネントは、単に中身を持たないというだけでなく、中身を持たないことを **意図したものだ** ということをはっきりと表現します。本の中にある白紙のページと、「このページは意図的に白紙のままにしています」と書かれたページとは違うということです。また、不要な閉じタグがなくなることによってあなたのコードはより読みやすくなります。


残念ながら、HTML はカスタム要素の自己終了形式を許していません。[公式の「空」要素](https://www.w3.org/TR/html/syntax.html#void-elements) だけです。これが、Vue のテンプレートコンパイラが DOM よりも先にテンプレートにアクセスして、その後 DOM の仕様に準拠した HTML を出力することができる場合にだけこの方策を使うことができる理由です。 


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

**ほとんどのプロジェクトでは、コンポーネント名は [単一ファイルコンポーネント](../guide/single-file-components.html) と文字列テンプレートの中では常にパスカルケース(PascalCase)になるべきです。 - しかし、 DOM テンプレートの中ではケバブケース(kebab-case)です。**

パスカルケースには、ケバブケースよりも優れた点がいくつかあります:

- パスカルケースは JavaScript でも使われるので、エディタがテンプレート内のコンポーネント名を自動補完できます。
- `<MyComponent>` は `<my-component>` よりも一単語の HTML 要素との見分けがつきやすいです。なぜなら、ハイフン 1 文字だけの違いではなく 2 文字(2 つの大文字) の違いがあるからです。
- もし、テンプレート内で、例えば Web コンポーネントのような Vue 以外のカスタム要素を使っていたとしても、パスカルケースは Vue コンポーネントがはっきりと目立ったせることを保証します。

残念ですが、HTML は大文字と小文字を区別しないので、DOM テンプレートの中ではまだケバブケースを使う必要があります。

ただし、もしあなたが既にケバブケースを大量に使っているのなら、HTML の慣習との一貫性を保ちすべてのあなたのプロジェクトで同じ型式を使えるようにすることはおそらく上にあげた利点よりも重要です。このような状況では、 **どこでもケバブケースを使うのもアリです。**

{% raw %}<div class="style-example example-bad">{% endraw %}
#### 悪い例

``` html
<!-- 単一ファイルコンポーネント、文字列テンプレートの中 -->
<mycomponent/>
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

または

``` html
<!-- どこでも -->
<my-component></my-component>
```
{% raw %}</div>{% endraw %}



### JS/JSX 内でのコンポーネント名の形式 <sup data-p="b">強く推奨</sup>

**JS/[JSX](../guide/render-function.html#JSX) 内でのコンポーネント名はつねにパスカルケース(PascalCase)にするべきです。ただし、 `Vue.component` で登録したグローバルコンポーネントしか使わないような単純なアプリケーションでは、ケバブケース(kebab-case)を含む文字列になるかもしれません。**

{% raw %}
<details>
<summary>
  <h4>詳細な説明</h4>
</summary>
{% endraw %}

JavaScript では、クラスやプロトタイプのコンストラクタは - 原則として異なるインスタンスを持ちうるものはすべて- パスカルケースにするのがしきたりです。Vue コンポーネントもインスタンスをもつので、同じようにパスカルケースにするのが理にかなっています。さらなる利点として、JSX(とテンプレート)の中でパスカルケースを使うことによって、コードを読む人がコンポーネントと HTML 要素をより簡単に見分けられるようになります。

しかし、`Vue.component` によるグローバルコンポーネント定義 **だけ** を使うアプリケーションでは、代わりにケバブケースを使うことを推奨します。理由は以下の通りです:

- グローバルコンポーネントを JavaScript から参照することはほとんどないので、 JavaScript の原則に従う意味もほとんどありません。
- そのようなアプリケーションはたくさんの DOM 内テンプレート をもつのが常ですが、 そこでは ケバブケースを [**必ず** 使う必要があります](#テンプレート内でのコンポーネント名の形式-強く推奨)

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

**プロパティ名は、定義の時は常にキャメルケース(camelCase)にするべきですが、テンプレートや [JSX](../guide/render-function.html#JSX) ではケバブケース(kebab-case)にするべきです。**

私たちは単純にこの慣習に従っています。JavaScript の中ではキャメルケースがより自然で、HTML の中ではケバブケースが自然です。

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

**複数の属性をもつ要素は、1 行に 1 要素ずつ、複数の行にわたって書くべきです。**

JavaScript では、複数のプロパティをもつ要素を複数の行に分けて書くことはよい慣習だと広く考えられています。なぜなら、その方がより読みやすいからです。Vue のテンプレートや [JSX](../guide/render-function.html#JSX) も同じように考えることがふさわしいです。

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



### テンプレート内での単純な式 <sup data-p="b">強く推奨</sup>

**複雑な式は算出プロパティかメソッドにリファクタリングして、コンポーネントのテンプレートには単純な式だけを含むようにするべきです。**

テンプレート内に複雑な式があると、テンプレートが宣言的ではなくなります。私たちは、 __どのように__ その値を算出するかではなく、 __何が__ 表示されるべきかを記述するように努力するべきです。また、算出プロパティやメソッドによってコードが再利用できるようになります。

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
// 複雑な式を算出プロパティに移動
computed: {
  normalizedFullName: function () {
    return this.fullName.split(' ').map(function (word) {
      return word[0].toUpperCase() + word.slice(1)
    }).join(' ')
  }
}
```
{% raw %}</div>{% endraw %}



### 単純な算出プロパティ <sup data-p="b">強く推奨</sup>

**複雑な算出プロパティは、できる限りたくさんの単純なプロパティに分割するべきです。**

{% raw %}
<details>
<summary>
  <h4>詳細な説明</h4>
</summary>
{% endraw %}

単純な、よい名前を持つ算出プロパティは:

- __テストしやすい__
  それぞれの算出プロパティが、依存がとても少ないごく単純な式だけを含む場合、それが正しく動くことを確認するテストを書くことがより簡単になります。

- __読みやすい__
  算出プロパティを単純にするということは、たとえそれが再利用可能ではなかったとしても、それぞれに分かりやすい名前をつけることになります。それによって、他の開発者(そして未来のあなた)が、注意を払うべきコードに集中し、何が起きているかを把握することがより簡単になります。

- __要求の変更を受け入れやすい__

  名前をつけることができる値は何でも、ビューでも役に立つ可能性があります。例えば、いくら割引になっているかをユーザに知らせるメッセージを表示することに決めたとします。 また、消費税も計算して、最終的な価格の一部としてではなく、別々に表示することにします。

  小さく焦点が当てられた算出プロパティは、どのように情報が使われるかについての決めつけをより少なくし、少しのリファクタリングで要求の変更を受け入れられるようになります。

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



### 引用符付きの属性値 <sup data-p="b">強く推奨</sup>

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



## 優先度 C のルール: 推奨 (任意の選択肢と認知上のオーバーヘッドの最小化)



### コンポーネント/インスタンス オプション順序 <sup data-p="c">推奨</sup>

**コンポーネント/インスタンス オプションは､一貫した順序になるべきです｡**

これは推奨するコンポーネントオプションの既定の順序です｡それらは種類分けされており､プラグインからどこに新たなプロパティを追加するか知ることができます｡

1. **副作用** (コンポーネント外への影響)
  - `el`

2. **グローバルな認識** (コンポーネントを超えた知識が必要)
  - `name`
  - `parent`

3. **コンポーネントの種類** (コンポーネントの種類を変更)
  - `functional`

4. **テンプレートの修飾子** (テンプレートのコンパイル方法を変更)
  - `delimiters`
  - `comments`

5. **テンプレートの依存関係** (テンプレートで使用されるアセット)
  - `components`
  - `directives`
  - `filters`

6. **合成** (プロパティをオプションにマージ)
  - `extends`
  - `mixins`

7. **インタフェース** (コンポーネントへのインタフェース)
  - `inheritAttrs`
  - `model`
  - `props`/`propsData`

8. **ローカルの状態** (ローカル リアクティブ プロパティ)
  - `data`
  - `computed`

9. **イベント** (リアクティブなイベントによって引き起こされたコールバック)
  - `watch`
  - ライフサイクルイベント (呼び出される順)

10. **リアクティブではないプロパティ** (リアクティブシステムから独立したインスタンス プロパティ)
  - `methods`

11. **レンダリング** (コンポーネント出力の宣言的な記述)
  - `template`/`render`
  - `renderError`



### 要素の属性の順序 <sup data-p="c">推奨</sup>

**要素の属性 (コンポーネントを含む) は､一貫した順序になるべきです｡**

これは推奨するコンポーネントオプションの既定の順序です｡それらは種類分けされており､カスタム属性とディレクティブをどこに追加するか知ることができます｡

1. **定義** (コンポーネントオプションを提供)
  - `is`

2. **リスト描画** (同じ要素の複数のバリエーションを作成する)
  - `v-for`

2. **条件** (要素が描画/表示されているかどうか)
  - `v-if`
  - `v-else-if`
  - `v-else`
  - `v-show`
  - `v-cloak`

3. **描画修飾子** (要素の描画方法を変更)
  - `v-pre`
  - `v-once`

4. **グローバルな認識** (コンポーネントを超えた知識が必要)
  - `id`

5. **一意の属性** (一意の値を必要とする属性)
  - `ref`
  - `key`
  - `slot`

6. **双方向バインディング** (バインディングとイベントの結合)
  - `v-model`

7. **その他の属性** (すべての指定されていないバインドされた属性とバインドされていない属性)

8. **イベント** (コンポーネントのイベントリスナ)
  - `v-on`

9. **コンテンツ** (要素のコンテンツを上書きする)
  - `v-html`
  - `v-text`



### コンポーネント/インスタンス オプションの空行 <sup data-p="c">推奨</sup>

**特にオプションがスクロールなしでは画面に収まらなくなった場合､複数行に渡るプロバティの間に空行を追加してみてください｡**

コンポーネントに窮屈さや読みづらさを感じたら､複数行に渡るプロバティの間に空行を追加する事でそれらを簡単に読み流すことができるようになります｡ Vim など､一部のエディタでは、このような書式を使用するとキーボードで簡単に移動することができます。

{% raw %}<div class="style-example example-good">{% endraw %}
#### 良い例

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
// コンポーネントの読み取りや移動が容易であれば、
// 空行がなくても大丈夫です｡
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



### 単一ファイルコンポーネントのトップレベルの属性の順序 <sup data-p="c">推奨</sup>

**[単一ファイルコンポーネント](../guide/single-file-components.html)では､ `template` ､ `script` ､ `style` タグを一貫した順序にするべきです､ `<style>` は最後です､それは他の2つのうち少なくとも1つが常に必要だからです。**

{% raw %}<div class="style-example example-bad">{% endraw %}
#### 悪い例

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
#### 良い例

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



## 優先度 D のルール: 慎重に使用（危険をはらんだパターン）



### `key` を使わない `v-if`/`v-if-else`/`v-else` <sup data-p="d">慎重に使用</sup>

**それらが同じ種類の要素の場合、通常は `v-if` + `v-else` と一緒に `key` を使用するのが最善です(例: どちらも `<div>` 要素).**

デフォルトでは、Vue は可能な限り効率的に DOM を更新します。これは、同じ種類の要素間を切り替えるときに、既存の要素を取り除いてそこに新しい要素を作成するのではなく、単純に既存の要素を修正することを意味します。これらの要素が、実際には同じであるとみなされるべきでない場合、[予期せぬ副作用](https://jsfiddle.net/chrisvfritz/bh8fLeds/)を起こすことがあります。

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



### `scoped` 付きの要素セレクタ <sup data-p="d">慎重に使用</sup>

**`scoped` 付きの要素セレクタは避けるべきです。**

たくさんの要素セレクタは低速なため、`scoped` 付きの要素セレクタよりも、クラスセレクタを使用します。

{% raw %}
<details>
<summary>
  <h4>Detailed Explanation</h4>
</summary>
{% endraw %}

スコープスタイルのために、Vue は `data-v-f3f3eg9` のような一意な属性をコンポーネントの要素に追加します。そして、この属性をもったマッチする要素のみが選択されるように、セレクタが変更されます（例: `button[data-v-f3f3eg9]`）。

問題は、たくさんの[要素-属性 セレクタ](http://stevesouders.com/efws/css-selectors/csscreate.php?n=1000&sel=a%5Bhref%5D&body=background%3A+%23CFD&ne=1000)（例: `button[data-v-f3f3eg9]`）は、[クラス-属性 セレクタ](http://stevesouders.com/efws/css-selectors/csscreate.php?n=1000&sel=.class%5Bhref%5D&body=background%3A+%23CFD&ne=1000) （例: `.btn-close[data-v-f3f3eg9]`）よりもかなり遅くなることであり、よって可能であればクラスセレクタが推奨されます。

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



### 暗黙的な親子間のコミュニケーション <sup data-p="d">慎重に使用</sup>

**親子間のコミュニケーションは、`this.$parent` や変化するプロパティよりも、プロパティとイベントが推奨されます。**

理想的な Vue アプリケーションでは、プロパティは下がり、イベントは上がります。この習慣に従えば、コンポーネントの理解が簡単になります。ですが、プロパティの変化や `this.$parent` が、深く結合している２つのコンポーネントを単純化できるようなエッジケースも存在します。

問題は、これらのパターンが便利になるような、_シンプルな_ ケースも多く存在することです。注意: 短期間の利便性（少ないコードを書くこと）のための、取引のシンプルさ(状態の流れを理解出来るようになる)に誘惑されないでください。

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



### Flux 以外の状態管理 <sup data-p="d">慎重に使用</sup>

** グローバル状態管理には、`this.$root` やグローバルイベントバスよりも、[Vuex](https://github.com/vuejs/vuex) が推奨されます **

`this.$root` や [グローバルイベントバス](https://vuejs.org/v2/guide/migration.html#dispatch-and-broadcast-replaced) を使用した状態管理は非常にシンプルなケースでは便利かもしれませんが、ほとんどのアプリケーションにとっては適切ではありません. Vuex は状態管理のための中心地だけではなく、整理、追跡、そして状態変更のデバッグのためのツールも提供します。

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
