---
title: スタイルガイド
type: style-guide
updated: 2019-06-26
---

このドキュメントは、 Vue 固有の記法についての公式なスタイルガイドです。もしあなたがプロジェクトにおいて Vue を使用する場合は、エラーや有益でない議論、アンチパターンを避けるための参考となります。しかし、スタイルガイドはすべてのチームやプロジェクトで理想とは限らないと考えていますので、過去の経験や、周囲の技術スタック、個人の価値観に基づいた上で必要に応じて慎重に逸脱することが推奨されます。

ほとんどのパートにおいて、基本的に JavaScript や HTML に対する提案はさけています。セミコロンやカンマの使用の是非はどちらでも良いです。 HTML の属性に対してシングルクォートかダブルクォートどちらかを利用するかもどちらでも良いです。しかし、特定のパターンにおいて Vue のコンテキストが役立つと判明した場合については、その限りではありません。

> **近々、実施のヒントを提供予定です。** スタイルガイドについて、必要に応じて自身で実施しなければならない場所もありますが、可能な限り ESLint やその他自動化されたプロセスを用いて、より簡単に行う方法を明示します。

最後に、私たちはルール群を 4 つのカテゴリに分割しました:



## ルールカテゴリ

### 優先度 A: 必須

これらのルールは、エラー防止に役立ちます。ですので、学び、遵守してください。例外は存在するかもしれませんが、それらは極めて稀で、かつ JavaScript と Vue の両方の専門知識を持った人によってのみ作られるべきです。

### 優先度 B: 強く推奨

これらのルールは、ほとんどのプロジェクトで読みやすさや開発者の体験をよりよくするために見いだされました。これらに違反してもあなたのコードは動きますが、ごくまれなケースで、かつちゃんと正当を示した上でのみ違反するようにすべきです。

### 優先度 C: 推奨

同じくらい良いオプションが複数ある場合､一貫性を確保するために任意の選択をすることができます｡これらのルールでは､それぞれ許容可能なオプションを説明し､既定の選択を提案します｡つまり､一貫性があり､良い理由を持ち続ける限り､独自のコードベースで自由に異なる選択肢を作ることができます｡ですが､良い理由はあるのでしょうか！コミュニティの標準に合わせることで､あなたは:

1. 直面するコミュニティのコードを容易に理解できるように脳を慣れさせます｡
2. ほとんどのコミュニティのコードサンプルを変更なしにコピーして貼り付ける事ができます｡
3. 少なくとも Vue に関しては､ほとんどの場合､新たな人材はあなたのコーディングスタイルよりも既に慣れ親しんだものを好みます｡

### 優先度 D: 使用注意

Vue のいくつかの機能は、レアケースまたは従来のコードベースからスムーズな移行に対応するために存在します。しかしながら、これを使いすぎると、コードを保守することが難しくなり、またバグの原因になることさえあります。これらのルールは潜在的な危険な機能を照らし、いつ、なぜ避けなかればならないのかを説明しています。



## 優先度 A ルール: 必須 (エラー防止)



### 複数単語コンポーネント名 <sup data-p="a">必須</sup>

**ルートの `App` コンポーネントや、Vue が提供する `<transition>` や `<component>` のようなビルトインコンポーネントを除き、コンポーネント名は常に複数単語とするべきです。**

これは、全ての HTML 要素は 1 単語となっているというこれまでの経緯から、既に存在する、そして将来定義される HTML 要素との[衝突を防止します](http://w3c.github.io/webcomponents/spec/custom/#valid-custom-element-name)。

{% raw %}<div class="style-example example-bad">{% endraw %}
#### 悪い例

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
#### 良い例

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



### コンポーネントのデータ <sup data-p="a">必須</sup>

**コンポーネントの `data` は関数でなければなりません。**

コンポーネントで `data` プロパティを使用する際 (つまり `new Vue` 以外のどこでも)、その値はオブジェクトを返す関数でなければなりません。

{% raw %}
<details>
<summary>
  <h4>詳細な説明</h4>
</summary>
{% endraw %}

`data` の値がオブジェクトの時、それはコンポーネントの全てのインスタンスで共有されます。例として、このデータを持つ `TodoList` コンポーネントを想像してみましょう:


``` js
data: {
  listTitle: '',
  todos: []
}
```

私たちは、ユーザーが複数のリスト(例えば 買い物、ウィッシュリスト、毎日の仕事など)を管理できるように、このコンポーネントを再利用したいかもしれません。しかし問題があります。コンポーネントの全てのインスタンスが同じデータオブジェクトを参照しているので、1つのリストのタイトルを変えることは、他の全てのリストのタイトルを変えることになるでしょう。1つの todo を追加/編集/削除する場合も同様です。

代わりに、各コンポーネントのインスタンスにはそれ自身のデータだけを管理してもらいたいです。そのためには、各インスタンスは一意のデータオブジェクトを生成しなければなりません。 JavaScript において、それは関数内でオブジェクトを返すことにより達成されます。


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
#### 悪い例

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
#### 良い例
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
// .vue ファイル内
export default {
  data () {
    return {
      foo: 'bar'
    }
  }
}
```

``` js
// ルートで直接オブジェクトを使うのは OK です
// なぜなら Vue インスタンスはずっと存在する唯一のインスタンスだからです
new Vue({
  data: {
    foo: 'bar'
  }
})
```
{% raw %}</div>{% endraw %}



### プロパティの定義 <sup data-p="a">必須</sup>

**プロパティの定義はできる限り詳細とするべきです。**

コミットされたコード内で、プロパティの定義は常に少なくとも1つのタイプを指定し、できる限り詳細とするべきです。

{% raw %}
<details>
<summary>
  <h4>詳細な説明</h4>
</summary>
{% endraw %}

詳細な [プロパティの定義](../guide/components-props.html#%E3%83%97%E3%83%AD%E3%83%91%E3%83%86%E3%82%A3%E3%81%AE%E3%83%90%E3%83%AA%E3%83%87%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3) には2つの利点があります:

- それらはコンポーネントの API を記録するため、そのコンポーネントの使用方法が簡単に分かります。
- 開発中にもしコンポーネントに対して誤った設定のプロパティが提供されたら、 Vue はあなたに警告します。それは潜在的なエラー原因の検知に役立ちます。

{% raw %}</details>{% endraw %}

{% raw %}<div class="style-example example-bad">{% endraw %}
#### 悪い例

``` js
// プロトタイピングの時だけ OK
props: ['status']
```
{% raw %}</div>{% endraw %}

{% raw %}<div class="style-example example-good">{% endraw %}
#### 良い例

``` js
props: {
  status: String
}
```

``` js
// さらに良いです!
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



### キー付き `v-for` <sup data-p="a">必須</sup>

**常に `v-for` に対しては `key` を使用してください。**

サブツリー下に内部コンポーネントの状態を維持するために `v-for` に `key` は _常に_ コンポーネントに必要です。それが要素の場合においても、 アニメーションにおける [オブジェクトの一貫性](https://bost.ocks.org/mike/constancy/) のような予測可能な振る舞いを維持するためには良い手法でしょう。

{% raw %}
<details>
<summary>
  <h4>詳細な説明</h4>
</summary>
{% endraw %}

TODO リストを持っているとしましょう:

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

アルファベット順に並べ替えます。 DOM を更新する時、 Vue はできる限りコストをかけずに DOM 変化を実行するために描画を最適化します。それは、最初の todo 要素を削除してから、それを再びリストの最後に加えることを意味します。

問題は、 DOM に残る要素を削除しないことが重要な場合があることです。例えば、リストの並び替えに `<transition-group>` を使いたいかもしれないですし、描画された要素が `<input>` の場合は、フォーカスを維持したいかもしれません。このような場合には、各アイテムに対して一意のキー (つまり `:key="todo.id"` ) を与えることによって、 Vue により予測可能な振る舞いを伝えることができます。

私たちの経験では、 _常に_ 一意のキーを与える方が良いので、あなたやあなたのチームはこれらのエッジケースについて心配する必要はありません。稀に、オブジェクトの一貫性が必要とされないパフォーマンスが重要なシナリオにおいては、意識的に例外を作ることはできます。

{% raw %}</details>{% endraw %}

{% raw %}<div class="style-example example-bad">{% endraw %}
#### 悪い例

``` html
<ul>
  <li v-for="todo in todos">
    {{ todo.text }}
  </li>
</ul>
```
{% raw %}</div>{% endraw %}

{% raw %}<div class="style-example example-good">{% endraw %}
#### 良い例

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



### `v-for` と一緒に `v-if` を使うのを避ける <sup data-p="a">必須</sup>

**`v-for` と同じ要素に `v-if` を使わないでください。**

こうしたくなってしまう2つの一般的なケースがあります:

- リスト内のアイテムをフィルタする(例: `v-for="user in users" v-if="user.isActive"`)。このような場合は、フィルタリングされたリストを返却する算出プロパティに `users` を置き換えてください(例: `activeUsers`)。

- 非表示にする必要がある場合、リストを描画しないようにする(例: `v-for="user in users" v-if="shouldShowUsers"`)。このような場合は、`v-if` をコンテナ要素(例: `ul`、`ol`)に移動してください。

{% raw %}
<details>
<summary>
  <h4>詳細な説明</h4>
</summary>
{% endraw %}

Vue がディレクティブを処理するとき、`v-for`は `v-if` よりも優先度が高いので、このテンプレートは、

``` html
<ul>
  <li
    v-for="user in users"
    v-if="user.isActive"
    :key="user.id"
  >
    {{ user.name }}
  </li>
</ul>
```

以下と同様に評価されます:

``` js
this.users.map(function (user) {
  if (user.isActive) {
    return user.name
  }
})
```

たとえほんの少しのユーザーだけをレンダリングする場合でも、アクティブユーザーが変更されたかどうかに関わらず、再レンダリングするたびにリスト全体を繰り返し処理する必要があります。

代わりに算出プロパティを繰り返し処理すると、次のようになります:

``` js
computed: {
  activeUsers: function () {
    return this.users.filter(function (user) {
      return user.isActive
    })
  }
}
```

``` html
<ul>
  <li
    v-for="user in activeUsers"
    :key="user.id"
  >
    {{ user.name }}
  </li>
</ul>
```

以下のような利点を得ます:

- フィルタリングされたリストは `users` 配列に関連する変更があった場合に _のみ_ 再評価されるので、フィルタリングがはるかに効率的になります。
- `v-for="user in activeUsers"` を使用して、描画中にアクティブユーザー _のみ_ 繰り返し処理するので、描画がはるかに効率的になります。
- ロジックがプレゼンテーションレイヤから切り離され、メンテナンス(ロジックの変更/拡張)がはるかに容易になります。

更新でも同様のメリットが得られます:

``` html
<ul>
  <li
    v-for="user in users"
    v-if="shouldShowUsers"
    :key="user.id"
  >
    {{ user.name }}
  </li>
</ul>
```

は以下のように書き換えられます:

``` html
<ul v-if="shouldShowUsers">
  <li
    v-for="user in users"
    :key="user.id"
  >
    {{ user.name }}
  </li>
</ul>
```

`v-if` をコンテナ要素に移動することで、リスト内の _すべての_ ユーザーに対して `shouldShowUsers` をチェックしなくなりました。代わりに、それを一度チェックし、`shouldShowUsers`が false の場合は `v-for` を評価しません。

{% raw %}</details>{% endraw %}

{% raw %}<div class="style-example example-bad">{% endraw %}
#### 悪い例

``` html
<ul>
  <li
    v-for="user in users"
    v-if="user.isActive"
    :key="user.id"
  >
    {{ user.name }}
  </li>
</ul>
```

``` html
<ul>
  <li
    v-for="user in users"
    v-if="shouldShowUsers"
    :key="user.id"
  >
    {{ user.name }}
  </li>
</ul>
```
{% raw %}</div>{% endraw %}

{% raw %}<div class="style-example example-good">{% endraw %}
#### 良い例

``` html
<ul>
  <li
    v-for="user in activeUsers"
    :key="user.id"
  >
    {{ user.name }}
  </li>
</ul>
```

``` html
<ul v-if="shouldShowUsers">
  <li
    v-for="user in users"
    :key="user.id"
  >
    {{ user.name }}
  </li>
</ul>
```
{% raw %}</div>{% endraw %}



### コンポーネントスタイルのスコープ <sup data-p="a">必須</sup>

**アプリケーションにとって、トップレベルの `App` コンポーネントとレイアウトコンポーネント内のスタイルはグローバルかもしれませんが、他のすべてのコンポーネントは常にスコープされているべきです。**

これは[単一ファイルコンポーネント](../guide/single-file-components.html)にのみ関係します。 [`scoped` 属性](https://vue-loader.vuejs.org/en/features/scoped-css.html)の使用は必須_ではありません_。スコープは [CSS modules](https://vue-loader.vuejs.org/en/features/css-modules.html) 、 [BEM](http://getbem.com/) のようなクラスに基づいた戦略、あるいは他のライブラリや慣例を介して行うことができます。

**しかしながら、コンポーネントライブラリでは `scoped` 属性を使用する代わりに、クラスに基づいた戦略の方がむしろ好ましいです。**

これは内部スタイルの上書きを容易にし、人間が読みやすいクラス名は高い詳細度を持ちませんが、しかし依然として衝突する可能性はほとんどありません。

{% raw %}
<details>
<summary>
  <h4>詳細な説明</h4>
</summary>
{% endraw %}

もしあなたが、他の開発者と一緒に、あるいは時々サードパーティ(例えば Auth0 から)の HTML/CSS を含んだりする大きなプロジェクトを開発しているのなら、一貫したスコープは意図されたコンポーネントだけにあなたのスタイルを適用することを保証します。

`scoped` 属性を超えて、一意のクラス名を使うことはサードパーティの CSS があなたの HTML に適用されないことを保証するのに役立ちます。 例えば、多くのプロジェクトは `button` 、 `btn` 、 や `icon` のようなクラス名を使っているので、たとえ BEM のような戦略を使わなくても、アプリケーション固有 かつ/あるいは コンポーネント固有のプレフィックス(例 `ButtonClose-icon` )を付与することはいくらかの防御になります。

{% raw %}</details>{% endraw %}

{% raw %}<div class="style-example example-bad">{% endraw %}
#### 悪い例

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
#### 良い例

``` html
<template>
  <button class="button button-close">X</button>
</template>

<!-- `scoped` を使用 -->
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

<!-- CSS modules を使用 -->
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

<!-- BEM の慣例を使用 -->
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



### プライベートなプロパティ名 <sup data-p="a">必須</sup>

**プライベートな関数に外部からアクセスできないようにするために、モジュールスコープを使用してください。それが難しい場合は、プラグインやミックスインなどのプライベートなカスタムプロパティには常に `$_` プレフィックスを使用してください。さらに、他の著者によるコードとの衝突を避けるため、名前付きのスコープを含めてください (例 `$_yourPluginName_` )。**

{% raw %}
<details>
<summary>
  <h4>詳細な説明</h4>
</summary>
{% endraw %}

Vue は、それ自体のプライベートなプロパティを定義するために `_` プレフィックスを使用しているので、同じプレフィックス(例 `_update` )を使用することはインスタンスのプロパティを上書きする危険があります。たとえ Vue が現在特定のプロパティ名を使用していないことを確認するとしても、後のバージョンで衝突が起きないという保証はありません。

`$` プレフィックスについて、 Vue のエコシステム間でのその目的はユーザーに公開される特別なインスタンスのプロパティなので、それを _プライベートな_プロパティに対して使用するのは適切ではありません。

代わりに、 Vue と衝突しないユーザー定義されたプライベートなプロパティの慣例として、2つのプレフィックスを組み合わせて `$_` にすることを推奨します。



{% raw %}</details>{% endraw %}

{% raw %}<div class="style-example example-bad">{% endraw %}
#### 悪い例

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
#### 良い例

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

``` js
// さらによい!
var myGreatMixin = {
  // ...
  methods: {
    publicMethod() {
      // ...
      myPrivateFunction()
    }
  }
}

function myPrivateFunction() {
  // ...
}

export default myGreatMixin
```
{% raw %}</div>{% endraw %}



## 優先度B のルール: 強く推奨 (読みやすさの向上)



### コンポーネントのファイル <sup data-p="b">強く推奨</sup>

**ファイルを結合してくれるビルドシステムがあるときは必ず、各コンポーネントはそれぞれ別のファイルに書くべきです。**

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
- 別の基底コンポーネント、そして
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



### テンプレート内でのコンポーネント名の形式 <sup data-p="b">強く推奨</sup>

**ほとんどのプロジェクトでは、コンポーネント名は [単一ファイルコンポーネント](../guide/single-file-components.html) と文字列テンプレートの中では常にパスカルケース(PascalCase)になるべきです。 - しかし、 DOM テンプレートの中ではケバブケース(kebab-case)です。**

パスカルケースには、ケバブケースよりも優れた点がいくつかあります:

- パスカルケースは JavaScript でも使われるので、エディタがテンプレート内のコンポーネント名を自動補完できます。
- `<MyComponent>` は `<my-component>` よりも一単語の HTML 要素との見分けがつきやすいです。なぜなら、ハイフン 1 文字だけの違いではなく 2 文字(2 つの大文字) の違いがあるからです。
- もし、テンプレート内で、例えば Web コンポーネントのような Vue 以外のカスタム要素を使っていたとしても、パスカルケースは Vue コンポーネントがはっきりと目立つことを保証します。

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

{% codeblock lang:html %}
<WelcomeMessage greetingText="hi"/>
{% endcodeblock %}
{% raw %}</div>{% endraw %}

{% raw %}<div class="style-example example-good">{% endraw %}
#### 良い例

``` js
props: {
  greetingText: String
}
```

{% codeblock lang:html %}
<WelcomeMessage greeting-text="hi"/>
{% endcodeblock %}
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

**ディレクティブの短縮記法 (`v-bind:` に対する `:` 、 `v-on:` に対する `@` 、 `v-slot:` に対する `#`)は、常に使うか、まったく使わないかのどちらかにするべきです。**

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

``` html
<template v-slot:header>
  <h1>Here might be a page title</h1>
</template>

<template #footer>
  <p>Here's some contact info</p>
</template>
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

``` html
<template v-slot:header>
  <h1>Here might be a page title</h1>
</template>

<template v-slot:footer>
  <p>Here's some contact info</p>
</template>
```

``` html
<template #header>
  <h1>Here might be a page title</h1>
</template>

<template #footer>
  <p>Here's some contact info</p>
</template>
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
    - `beforeCreate`
    - `created`
    - `beforeMount`
    - `mounted`
    - `beforeUpdate`
    - `updated`
    - `activated`
    - `deactivated`
    - `beforeDestroy`
    - `destroyed`

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

3. **条件** (要素が描画/表示されているかどうか)
  - `v-if`
  - `v-else-if`
  - `v-else`
  - `v-show`
  - `v-cloak`

4. **描画修飾子** (要素の描画方法を変更)
  - `v-pre`
  - `v-once`

5. **グローバルな認識** (コンポーネントを超えた知識が必要)
  - `id`

6. **一意の属性** (一意の値を必要とする属性)
  - `ref`
  - `key`
  - `slot`

7. **双方向バインディング** (バインディングとイベントの結合)
  - `v-model`

8. **その他の属性** (すべての指定されていないバインドされた属性とバインドされていない属性)

9. **イベント** (コンポーネントのイベントリスナ)
  - `v-on`

10. **コンテンツ** (要素のコンテンツを上書きする)
  - `v-html`
  - `v-text`



### コンポーネント/インスタンス オプションの空行 <sup data-p="c">推奨</sup>

**特にオプションがスクロールなしでは画面に収まらなくなった場合､複数行に渡るプロパティの間に空行を追加してみてください｡**

コンポーネントに窮屈さや読みづらさを感じたら､複数行に渡るプロパティの間に空行を追加する事でそれらを簡単に読み流すことができるようになります｡ Vim など､一部のエディタでは、このような書式を使用するとキーボードで簡単に移動することができます。

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

**[単一ファイルコンポーネント](../guide/single-file-components.html)では､ `<script>` ､ `<template>` ､ `<style>` タグを一貫した順序にするべきです､ `<style>` は最後です､それは他の2つのうち少なくとも1つが常に必要だからです。**

{% raw %}<div class="style-example example-bad">{% endraw %}
#### 悪い例

``` html
<style>/* ... */</style>
<script>/* ... */</script>
<template>...</template>
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
<script>/* ... */</script>
<template>...</template>
<style>/* ... */</style>

<!-- ComponentB.vue -->
<script>/* ... */</script>
<template>...</template>
<style>/* ... */</style>
```

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
{% raw %}</div>{% endraw %}



## 優先度 D のルール: 使用注意（潜在的に危険なパターン）



### `key` を使わない `v-if`/`v-else-if`/`v-else` <sup data-p="d">使用注意</sup>

**それらが同じ種類の要素の場合、通常は `v-if` + `v-else` と一緒に `key` を使用するのが最善です(例: どちらも `<div>` 要素).**

デフォルトでは、Vue は可能な限り効率的に DOM を更新します。これは、同じ種類の要素間を切り替えるときに、既存の要素を取り除いてそこに新しい要素を作成するのではなく、単純に既存の要素を修正することを意味します。これらの要素が、実際には同一とみなされないほうが良い場合、[予期せぬ結果](https://jsfiddle.net/chrisvfritz/bh8fLeds/)を起こすことがあります。

{% raw %}<div class="style-example example-bad">{% endraw %}
#### 悪い例

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
#### 良い例

``` html
<div
  v-if="error"
  key="search-status"
>
  Error: {{ error }}
</div>
<div
  v-else
  key="search-results"
>
  {{ results }}
</div>
```
{% raw %}</div>{% endraw %}



### `scoped` 付きの要素セレクタ <sup data-p="d">使用注意</sup>

**`scoped` 付きの要素セレクタは避けるべきです。**

たくさんの要素セレクタは低速なため、`scoped` 付きの要素セレクタよりも、クラスセレクタを使用します。

{% raw %}
<details>
<summary>
  <h4>詳細な説明</h4>
</summary>
{% endraw %}

スコープスタイルのために、Vue は `data-v-f3f3eg9` のような一意な属性をコンポーネントの要素に追加します。そして、この属性をもったマッチする要素のみが選択されるように、セレクタが変更されます（例: `button[data-v-f3f3eg9]`）。

問題は、たくさんの[要素-属性 セレクタ](http://stevesouders.com/efws/css-selectors/csscreate.php?n=1000&sel=a%5Bhref%5D&body=background%3A+%23CFD&ne=1000)（例: `button[data-v-f3f3eg9]`）は、[クラス-属性 セレクタ](http://stevesouders.com/efws/css-selectors/csscreate.php?n=1000&sel=.class%5Bhref%5D&body=background%3A+%23CFD&ne=1000)（例: `.btn-close[data-v-f3f3eg9]`）よりもかなり遅くなることです。よって可能ならクラスセレクタが推奨されます。

{% raw %}</details>{% endraw %}

{% raw %}<div class="style-example example-bad">{% endraw %}
#### 悪い例

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
#### 良い例

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



### 暗黙的な親子間のやりとり <sup data-p="d">使用注意</sup>

**親子間のやりとりは、`this.$parent` や変化するプロパティよりも、プロパティとイベントが推奨されます。**

理想的な Vue アプリケーションでは、props down, events up となります。この習慣に従えば、コンポーネントの理解が簡単になります。ですが、プロパティの変化や `this.$parent` が、深く結合している2つのコンポーネントを単純化できるようなエッジケースも存在します。

問題は、これらのパターンが便利になるような、_シンプルな_ ケースも多く存在することです。注意: 短期間の利便性（少ないコードを書くこと）のための、取引のシンプルさ(状態の流れを理解出来るようになる)に誘惑されないでください。

{% raw %}<div class="style-example example-bad">{% endraw %}
#### 悪い例

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
#### 良い例

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



### Flux 以外の状態管理 <sup data-p="d">使用注意</sup>

** グローバル状態管理には、`this.$root` やグローバルイベントバスよりも、[Vuex](https://github.com/vuejs/vuex) が推奨されます **

`this.$root` や [グローバルイベントバス](../guide/migration.html#dispatch-および-broadcast-置き換え) を使用した状態管理は非常にシンプルなケースでは便利かもしれませんが、ほとんどのアプリケーションにとっては適切ではありません。

Vuex は状態管理のための中心地だけではなく、整理、追跡、そして状態変更のデバッグのためのツールも提供します。
Vuex is the [official flux-like implementation](https://vuejs.org/v2/guide/state-management.html#Official-Flux-Like-Implementation) for Vue, and offers not only a central place to manage state, but also tools for organizing, tracking, and debugging state changes. It integrates well in the Vue ecosystem (including full [Vue DevTools](https://vuejs.org/v2/guide/installation.html#Vue-Devtools) support).

{% raw %}</details>{% endraw %}

{% raw %}<div class="style-example example-bad">{% endraw %}
#### 悪い例

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
#### 良い例

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
    linter: '<a href="https://github.com/vuejs/eslint-plugin-vue#eslint-plugin-vue" target="_blank" rel="noopener noreferrer">plugin:vue/recommended</a>'
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
