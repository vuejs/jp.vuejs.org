---
title: 描画関数とJSX
updated: 2019-07-06
type: guide
order: 303
---

## 基本

Vue ではほとんどの場合 HTML をビルドするためにテンプレートを使うことが推奨されます。しかし、JavaScript による完全なプログラミングパワーを必要とする状況もあります。そこでテンプレートへの代替で、よりコンパイラに近い **描画 (render) 関数**が使用できます。

`render` 関数が実用的になりうる簡単な例を見てみましょう。では、アンカーヘッダを生成したいとします。

``` html
<h1>
  <a name="hello-world" href="#hello-world">
    Hello world!
  </a>
</h1>
```

上記の HTML に対して、望ましいコンポーネントのインターフェイスを決めましょう。

``` html
<anchored-heading :level="1">Hello world!</anchored-heading>
```

`level` プロパティを元にしてヘッダを生成するだけのコンポーネントから始める時、すぐに以下の例にたどり着くでしょう。

``` html
<script type="text/x-template" id="anchored-heading-template">
  <h1 v-if="level === 1">
    <slot></slot>
  </h1>
  <h2 v-else-if="level === 2">
    <slot></slot>
  </h2>
  <h3 v-else-if="level === 3">
    <slot></slot>
  </h3>
  <h4 v-else-if="level === 4">
    <slot></slot>
  </h4>
  <h5 v-else-if="level === 5">
    <slot></slot>
  </h5>
  <h6 v-else-if="level === 6">
    <slot></slot>
  </h6>
</script>
```

``` js
Vue.component('anchored-heading', {
  template: '#anchored-heading-template',
  props: {
    level: {
      type: Number,
      required: true
    }
  }
})
```

このテンプレートは良い気がしません。冗長なだけでなく、全てのヘッダレベルで `<slot></slot>` を重複させており、アンカー要素を追加したい時に同じことをする必要があります。

テンプレートはほとんどのコンポーネントでうまく動作しますが、この例はそうではないことが明確です。では、 `render` 関数を使ってこれを書き直してみましょう。

``` js
Vue.component('anchored-heading', {
  render: function (createElement) {
    return createElement(
      'h' + this.level,   // タグ名
      this.$slots.default // 子の配列
    )
  },
  props: {
    level: {
      type: Number,
      required: true
    }
  }
})
```

少しシンプルになりましたね！コードは短くなりましたが、Vue インスタンスプロパティの豊富な知識を必要とします。このケースでは、 `v-slot` ディレクティブ無しでコンポーネントに子を渡した時に ( `anchored-heading` の内側の `Hello world!` のような) 、それらの子がコンポーネントインスタンス上の  `$slots.default` にストアされていることを知っている必要があります。もしまだ知らないなら、**render 関数に進む前に [インスタンスプロパティAPI](../api/#インスタンスプロパティ) を読むことをオススメします。**

## ノード、ツリー、および仮想 DOM

render 関数を説明する前に、ブラウザの仕組みについて少し知っておくことが重要です。例えば、次のように HTML を入力します。

```html
<div>
  <h1>My title</h1>
  Some text content
  <!-- TODO: Add tagline  -->
</div>
```

ブラウザはこのコードを読み込むと、血縁関係を追跡するために家系図を構築するのと同じように、全てを追跡する ["DOM ノード"ツリー](https://javascript.info/dom-nodes)を構築します。

上記の HTML の DOM ノードのツリーは次のようになります。

![DOM Tree Visualization](/images/dom-tree.png)

全ての要素はノードです。全てのテキストはノードです。コメントさえもノードです！ノードはページの一部に過ぎません。 そして、家系図のように、各ノードは子供を持つことができます(つまり、各部分には他の部分を含めることができます)。

これらのノードを全て効率的に更新するのは難しいかもしれませんが、ありがたいことに、手動で行う必要はありません。テンプレート内のどの HTML をページに表示するかを Vue に伝えるだけです。

```html
<h1>{{ blogTitle }}</h1>
```

または render 関数の場合:

``` js
render: function (createElement) {
  return createElement('h1', this.blogTitle)
}
```

どちらの場合でも、`blogTitle`が変更されるときでさえ、Vue はページを自動的に更新します。

### 仮想 DOM

Vue は、実際の DOM に加える必要がある変更を追跡する**仮想 DOM** を構築することで、これを達成します。

``` js
return createElement('h1', this.blogTitle)
```

`createElement` は実際に何を返しているのでしょうか？_正確には_実際の DOM 要素ではありません。どのノードを描画するかを記述した情報が子ノードの記述を含んで Vue に含まれているため、より正確には `createNodeDescription` という名前になります。このノード記述は"仮想ノード"と呼ばれ、通常は **VNode** と略されます。"仮想 DOM" は、Vue コンポーネントのツリーで構築された VNode のツリー全体と呼んでいるものです。

## `createElement` 引数

あなたが精通する必要がある次のことは `createElement` 関数の中でテンプレートの機能をどのように使うかについてです。こちらが `createElement` の受け付ける引数です。

``` js
// @returns {VNode}
createElement(
  // {String | Object | Function}
  // HTML タグ名、コンポーネントオプション、もしくは
  // そのどちらかを解決する非同期関数です。必須です。
  'div',

  // {Object}
  // テンプレート内で使うであろう属性に対応する
  // データオブジェクト。任意です。
  {
    // (詳細は下の次のセクションをご参照ください)
  },

  // {String | Array}
  // 子のVNode。`createElement()` を使用して構築するか、
  // テキスト VNode の場合は単に文字列を使用します。任意です。
  [
    'Some text comes first.',
    createElement('h1', 'A headline'),
    createElement(MyComponent, {
      props: {
        someProp: 'foobar'
      }
    })
  ]
)
```

### データオブジェクト詳解

1 つ注意点: `v-bind:class` と `v-bind:style` がテンプレート内で特殊な扱いをされているのと同じように、それらは VNode のデータオブジェクト内で自身のトップレベルフィールドを持ちます。このオブジェクトは `innerHTML` のような通常の HTML 属性だけでなく DOM プロパティもバインドすることができます(これは `v-html` ディレクティブに取って代わるものです):

``` js
{
  // `v-bind:class` と同じ API、いずれかを受け付ける
  // 文字列、オブジェクトまたは文字列とオブジェクトの配列
  class: {
    foo: true,
    bar: false
  },
  // `v-bind:style` と同じ API、いずれかを受け付ける
  // 文字列、オブジェクトまたはオブジェクトの配列
  style: {
    color: 'red',
    fontSize: '14px'
  },
  // 通常の HTML 属性
  attrs: {
    id: 'foo'
  },
  // コンポーネントプロパティ
  props: {
    myProp: 'bar'
  },
  // DOM プロパティ
  domProps: {
    innerHTML: 'baz'
  },
  // イベントハンドラは `on` の配下に置かれます。
  // ただし、 `v-on:keyup.enter` などの修飾詞はサポートされません。
  // その代わり、手動で keyCode をハンドラの中で
  // 確認する必要があります。
  on: {
    click: this.clickHandler
  },
  // コンポーネントの場合のみ。
  // `vm.$emit` を使ってコンポーネントから emit されるイベントではなく
  // ネイティブのイベントを listen することができます。
  nativeOn: {
    click: this.nativeClickHandler
  },
  // カスタムディレクティブ。`binding` の `oldValue` については
  // あなたの代わりに Vue が面倒を見るので、設定することはできません。
  directives: [
    {
      name: 'my-custom-directive',
      value: '2',
      expression: '1 + 1',
      arg: 'foo',
      modifiers: {
        bar: true
      }
    }
  ],
  // { name: props => VNode | Array<VNode> }
  // の 形式でのスコープ付きスロット
  scopedSlots: {
    default: props => createElement('span', props.text)
  },
  // このコンポーネントが他のコンポーネントの子の場合は、そのスロット名
  slot: 'name-of-slot',
  // 他の特殊なトップレベルのプロパティ
  key: 'myKey',
  ref: 'myRef',
  // If you are applying the same ref name to multiple
  // elements in the render function. This will make `$refs.myRef` become an
  // array
  refInFor: true
}
```

### 完全な例

これらの知識を使えば、私たちが始めたコンポーネントを完了させることができるようになりました。

``` js
var getChildrenTextContent = function (children) {
  return children.map(function (node) {
    return node.children
      ? getChildrenTextContent(node.children)
      : node.text
  }).join('')
}

Vue.component('anchored-heading', {
  render: function (createElement) {
    // kebab-case id の作成
    var headingId = getChildrenTextContent(this.$slots.default)
      .toLowerCase()
      .replace(/\W+/g, '-')
      .replace(/(^-|-$)/g, '')

    return createElement(
      'h' + this.level,
      [
        createElement('a', {
          attrs: {
            name: headingId,
            href: '#' + headingId
          }
        }, this.$slots.default)
      ]
    )
  },
  props: {
    level: {
      type: Number,
      required: true
    }
  }
})
```

### 制約

#### VNode は一意でなければならない

コンポーネントツリーの中で全ての VNode は一意でなければなりません。つまり、以下の render 関数は不正です。

``` js
render: function (createElement) {
  var myParagraphVNode = createElement('p', 'hi')
  return createElement('div', [
    // うわ - 重複の VNodes ！
    myParagraphVNode, myParagraphVNode
  ])
}
```

もし同じ要素 / コンポーネントを何度も重複させたい場合には、factory 関数を使うことで対応できます。例えば、次の render 関数は 20 個の一意に特定できるパラグラフを描画する完全に正当な方法です。

``` js
render: function (createElement) {
  return createElement('div',
    Array.apply(null, { length: 20 }).map(function () {
      return createElement('p', 'hi')
    })
  )
}
```

## 素の JavaScript によるテンプレートの書き換え

### `v-if` と `v-for`

どんなところでも素の JavaScript で簡単に物事は成し遂げることができるので、Vue の render 関数は独自の代替手段を提供しません。例えば、以下の `v-if` と `v-for` を使ったテンプレート：

``` html
<ul v-if="items.length">
  <li v-for="item in items">{{ item.name }}</li>
</ul>
<p v-else>No items found.</p>
```

これは render 関数においては JavaScript の `if` / `else` と `map` を使って書き換えることができます。

``` js
props: ['items'],
render: function (createElement) {
  if (this.items.length) {
    return createElement('ul', this.items.map(function (item) {
      return createElement('li', item.name)
    }))
  } else {
    return createElement('p', 'No items found.')
  }
}
```

### `v-model`
描画関数には直接的な `v-model` の対応はありません。 あなた自身でロジックを実装する必要があります:

``` js
props: ['value'],
render: function (createElement) {
  var self = this
  return createElement('input', {
    domProps: {
      value: self.value
    },
    on: {
      input: function (event) {
        self.$emit('input', event.target.value)
      }
    }
  })
}
```

これは低レベルのコストですが、`v-model` と比較してインタラクションをより詳細に制御することもできます。

### イベントとキー修飾子

`.passive`、`.capture` と `.once` イベント修飾子に対して、Vue は `on` で使用できる接頭辞を提供しています:

| 修飾子 | 接頭辞 |
| ------ | ------ |
| `.passive` | `&` |
| `.capture` | `!` |
| `.once` | `~` |
| `.capture.once` または <br>`.once.capture` | `~!` |

例:

```javascript
on: {
  '!click': this.doThisInCapturingMode,
  '~keyup': this.doThisOnce,
  '~!mouseover': this.doThisOnceInCapturingMode
}
```

全ての他のイベントとキー修飾子に対しては、単にハンドラ内のイベントメソッドを使用できるため、独自の接頭辞は必要ありません:

| 修飾子 | ハンドラに相当 |
| ------ | ------ |
| `.stop` | `event.stopPropagation()` |
| `.prevent` | `event.preventDefault()` |
| `.self` | `if (event.target !== event.currentTarget) return` |
| キー:<br>`.enter`, `.13` | `if (event.keyCode !== 13) return` (他のキー修飾子に対して、`13` を[別のキーコード](http://keycode.info/)に変更する) |
| 修飾子キー:<br>`.ctrl`, `.alt`, `.shift`, `.meta` | `if (!event.ctrlKey) return` (`ctrlKey` を `altKey`、`shiftKey`、または `metaKey`、それぞれ変更する) |

以下に、これらの修飾子がすべて一緒に使用されている例を示します:

```javascript
on: {
  keyup: function (event) {
    // イベントを発行している要素が、
    // イベントが束縛されている要素でない場合は中止します。
    if (event.target !== event.currentTarget) return
    // up したキーが enter キー (13) でなく、
    // shift キーが同時に押されていない場合は中止します。
    if (!event.shiftKey || event.keyCode !== 13) return
    // イベントの伝播を停止します。
    event.stopPropagation()
    // この要素に対する、デフォルトの keyup ハンドラを無効にします。
    event.preventDefault()
    // ...
  }
}
```

### スロット

[`this.$slots`](../api/#vm-slots) から VNode の配列として静的なスロットの内容にアクセスできます:

``` js
render: function (createElement) {
  // `<div><slot></slot></div>`
  return createElement('div', this.$slots.default)
}
```

そして、[`this.$scopedSlots`](../api/#vm-scopedSlots) から VNode を返す関数としてスコープ付きスロットにアクセスできます:

``` js
props: ['message'],
render: function (createElement) {
  // `<div><slot :text="message"></slot></div>`
  return createElement('div', [
    this.$scopedSlots.default({
      text: this.message
    })
  ])
}
```

スコープ付きスロットを描画関数を使って子コンポーネントに渡すには、VNode データの `scopedSlots` フィールドを使います:

``` js
render: function (createElement) {
  // `<div><child v-slot="props"><span>{{ props.text }}</span></child></div>`
  return createElement('div', [
    createElement('child', {
      // { name: props => VNode | Array<VNode> } の形式で
      // `scopedSlots` を データオブジェクトに渡す
      scopedSlots: {
        default: function (props) {
          return createElement('span', props.text)
        }
      }
    })
  ])
}
```

## JSX

もしあなたが多くの render 関数を書いている場合は、このような書き方はつらいと感じるかもしれません。

``` js
createElement(
  'anchored-heading', {
    props: {
      level: 1
    }
  }, [
    createElement('span', 'Hello'),
    ' world!'
  ]
)
```

特に、テンプレートならそれにくらべてこんなに簡単に書けるという場合は:

``` html
<anchored-heading :level="1">
  <span>Hello</span> world!
</anchored-heading>
```

そのような理由から Vue で JSX を使うための [Babel プラグイン](https://github.com/vuejs/jsx) があります。よりテンプレートに近い文法が戻ってきました。

``` js
import AnchoredHeading from './AnchoredHeading.vue'

new Vue({
  el: '#demo',
  render: function (h) {
    return (
      <AnchoredHeading level={1}>
        <span>Hello</span> world!
      </AnchoredHeading>
    )
  }
})
```

<p class="tip">`createElement` を `h` にエイリアスしていることは、 Vue のエコシステムの中でよく見かける慣習です。そして、それは実は JSX には必須です。Vue の Babel プラグインの [バージョン 3.4.0](https://github.com/vuejs/babel-plugin-transform-vue-jsx#h-auto-injection) 以降では、ES2015 のシンタックスで宣言された JSX を含むメソッドや getter（関数やアロー関数は対象外）に対しては、自動的に `const h = this.$createElement` が注入されるため、`(h)` パラメーターは省略できます。それ以前のバージョンでは、もし `h` がそのスコープ内で利用可能でない場合、アプリケーションはエラーを throw するでしょう。</p>

より詳しい JSX の JavaScript へのマップの仕方については、[usage ドキュメント](https://github.com/vuejs/jsx#installation) をご参照ください。

## 関数型コンポーネント

先ほど作成したアンカーヘッダコンポーネントは比較的シンプルです。状態の管理や渡された状態の watch をしておらず、また、何もライフサイクルメソッドを持ちません。実際、これはいくつかのプロパティを持つただの関数です。

このようなケースにおいて、私たちは `関数型` としてコンポーネントをマークすることができます。それは状態を持たない ([リアクティブデータ](../api/#オプション-データ)が無い) でインスタンスを持たない ( `this` のコンテキストが無い) ことを意味します。**関数型コンポーネント** は次のような形式をしています。

``` js
Vue.component('my-component', {
  functional: true,
  // プロパティは任意です
  props: {
    // ...
  },
  // インスタンスが無いことを補うために、
  // 2 つ目の context 引数が提供されます。
  render: function (createElement, context) {
    // ...
  }
})
```

> 注意: 2.3.0 以前のバージョンでは、`props` オプションは、関数型コンポーネントでプロパティを受け入れたい場合必須です。2.3.0 以降では、`props` オプションを省略することができ、そしてコンポーネントのノード上にある全ての属性は、暗黙的にプロパティとして抽出されます。
> 
> 関数型コンポーネントは状態を持たずインスタンス化もできないので、その参照は HTMLElement になります。

2.5.0以降では、[単一ファイルコンポーネント](single-file-components.html)を使用している場合、テンプレートベースの関数型コンポーネントは次のように宣言できます。

``` html
<template functional>
</template>
```

コンポーネントが必要とする全てのものは `context` を通して渡されます。それは次を含むオブジェクトです。

- `props`: 提供されるプロパティのオブジェクト
- `children`: 子 VNode の配列
- `slots`: slots オブジェクトを返す関数
- `scopedSlots`: (2.6.0 以降) スコープ付きスロットを公開するオブジェクト。通常のスロットも関数として公開します
- `data`: `createElement` の第 2 引数としてコンポーネントに渡される全体の[データオブジェクト](#データオブジェクト詳解)
- `parent`: 親コンポーネントへの参照
- `listeners`: (2.3.0 以降) 親に登録されたイベントリスナーを含むオブジェクト。これは単純に `data.on` のエイリアスです
- `injections`: (2.3.0 以降) [`inject`](../api/#provide-inject) オプションで使用する場合、これは解決されたインジェクション(注入)が含まれます

`functional: true` を追加した後、私たちのアンカーヘッダコンポーネントの render 関数の更新として単に必要になるのは、
`context` 引数の追加、`this.$slots.default` の `context.children` への更新、`this.level` の `context.props.level` への更新でしょう。

関数型コンポーネントはただの関数なので、描画コストは少ないです。

また、ラッパーコンポーネントとしてもとても便利です。例えば、以下が必要な時に。

- いくつかの他のコンポーネントから 1 つ委譲するためのものをプログラムで選ぶ時
- 子、プロパティ、または、データを子コンポーネントへ渡る前に操作したい時

こちらが、渡されるプロパティに応じてより具体的なコンポーネントに委譲する `smart-list` コンポーネントの例です。

``` js
var EmptyList = { /* ... */ }
var TableList = { /* ... */ }
var OrderedList = { /* ... */ }
var UnorderedList = { /* ... */ }

Vue.component('smart-list', {
  functional: true,
  props: {
    items: {
      type: Array,
      required: true
    },
    isOrdered: Boolean
  },
  render: function (createElement, context) {
    function appropriateListComponent () {
      var items = context.props.items

      if (items.length === 0)           return EmptyList
      if (typeof items[0] === 'object') return TableList
      if (context.props.isOrdered)      return OrderedList

      return UnorderedList
    }

    return createElement(
      appropriateListComponent(),
      context.data,
      context.children
    )
  }
})
```

### 子要素/コンポーネントへの属性およびイベントの受け渡し

通常のコンポーネントでは、props として定義されていない属性はコンポーネントのルート要素に自動的に追加され、同名の既存の属性と置換または[賢くマージ](class-and-style.html)されます。

ところが、関数型コンポーネントでは、この動作を明示的に定義する必要があります:

```js
Vue.component('my-functional-button', {
  functional: true,
  render: function (createElement, context) {
    // 任意の属性、イベントリスナ、子などを透過的に渡します。
    return createElement('button', context.data, context.children)
  }
})
```

`context.data` を `createElement` の第2引数として渡すことで、`my-function-button` で使用された属性やイベントリスナを渡しています。実際、イベントは `.native` 修飾子を必要としないため、とても透過的です。

もしあなたがテンプレートベースの関数型コンポーネントを使用している場合、属性とリスナーも手動で追加する必要があります。私たちは個々のコンテキストの内容にアクセスできるので、イベントリスナを渡すための `listeners` _(`data.on` のエイリアス)_ と HTML の属性を渡すための `data.attrs` を使用することができます。

```html
<template functional>
  <button
    class="btn btn-primary"
    v-bind="data.attrs"
    v-on="listeners"
  >
    <slot/>
  </button>
</template>
```

### `slots()` vs `children`

もしかするとなぜ `slots()` と `children` の両方が必要なのか不思議に思うかもしれません。 `slots().default` は `children` と同じではないのですか？いくつかのケースではそうですが、もし以下の子を持つ関数型コンポーネントの場合はどうなるでしょう。

``` html
<my-functional-component>
  <p v-slot:foo>
    first
  </p>
  <p>second</p>
</my-functional-component>
```

このコンポーネントの場合、 `children` は両方のパラグラフが与えられます。`slots().default` は 2 つ目のものだけ与えられます。そして `slots().foo` は 1 つ目のものだけです。したがって、 `children` と `slots()` の両方を持つことで このコンポーネントが slot システムを知っているか、もしくは、単純に `children` を渡しておそらく他のコンポーネントへその責任を委譲するかどうかを選べるようになります。

## テンプレートのコンパイル

もしかすると Vue のテンプレートが実際に render 関数にコンパイルされることを知ることに興味を持つかもしれません。これは普段あなたは知る必要もない実装の詳細ですが、どのように特定のテンプレート機能がコンパイルされるかをもし見たいならこれに興味を持つかもしれません。以下は `Vue.compile` を使ってテンプレート文字列をその場でコンパイルをするちょっとしたデモです。

<iframe src="https://codesandbox.io/embed/github/vuejs/vuejs.org/tree/master/src/v2/examples/vue-20-template-compilation?codemirror=1&hidedevtools=1&hidenavigation=1&theme=light&view=preview" style="width:100%; height:500px; border:0; border-radius: 4px; overflow:hidden;" title="vue-20-template-compilation" allow="geolocation; microphone; camera; midi; vr; accelerometer; gyroscope; payment; ambient-light-sensor; encrypted-media; usb" sandbox="allow-modals allow-forms allow-popups allow-scripts allow-same-origin"></iframe>
