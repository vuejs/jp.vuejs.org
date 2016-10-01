---
title: Render 関数
type: guide
order: 14
---

## 基本

Vue ではほとんどの場合 HTML をビルドするためにテンプレートを使うことが推奨されます。しかし、JavaScript による完全なプログラミングパワー
を必要とするシチュエーションもあります。そこでテンプレートへの代替で、よりコンパイラに近い **Render 関数**が使用できます。

`render` 関数が実用的になりうる簡単な例を見てみましょう。では、アンカーヘッダを生成したいとします。

``` html
<h1>
  <a name="hello-world" href="#hello-world">
    Hello world!
  </a>
</h1>
```

上記の HTML に対して、望ましいコンポーネントのインターフェースを決めましょう。

``` html
<anchored-heading :level="1">Hello world!</anchored-heading>
```

`level` プロパティを元にしてヘッダを生成するだけのコンポーネントから始める時、すぐに以下の例に辿りつくでしょう。

``` html
<script type="text/x-template" id="anchored-heading-template">
  <div>
    <h1 v-if="level === 1">
      <slot></slot>
    </h1>
    <h2 v-if="level === 2">
      <slot></slot>
    </h2>
    <h3 v-if="level === 3">
      <slot></slot>
    </h3>
    <h4 v-if="level === 4">
      <slot></slot>
    </h4>
    <h5 v-if="level === 5">
      <slot></slot>
    </h5>
    <h6 v-if="level === 6">
      <slot></slot>
    </h6>
  </div>
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

このテンプレートは良い気がしません。冗長なだけでなく、全てのヘッダレベルで `<slot></slot>` を重複させており、アンカー要素を追加したい時に同じことをする必要があります。コンポーネントは 1 つの root ノードのみ含めることができるので、全体もまた無駄な `div` で囲まれています。

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

少しシンプルになりましたね！コードは短くなりましたが、これもまた Vue インスタンスプロパティの豊富な知識を必要とします。このケースでは、 `slot` 属性無しでコンポーネントに子を渡した時に ( `anchored-heading` の内側の `Hello world!` のような) 、それらの子がコンポーネントインスタンス上の  `$slots.default` にストアされているかを知っている必要があります。**もしあなたがまだ知らないなら、render 関数に進む前に、 [インスタンスプロパティAPI](/api/#vm-slots) を読むことをオススメします。**

## `createElement` 引数

あなたが精通する必要がある 2 つ目のことは `createElement` 関数の中でテンプレートの機能をどのように使うかについてです。こちらが `createElement` の受け付ける引数です。

``` js
// @returns {VNode}
createElement(
  // {String | Object | Function}
  // HTML タグ名、コンポーネントオプションもしくは関数
  // これらの一つを返します。必須です。
  'div',

  // {Object}
  // テンプレート内で使うであろう属性と一致する
  // データオブジェクト。任意です。
  {
    // (詳細は下の次のセクションをご参照ください)
  },

  // {String | Array}
  // VNodes の子。任意です。
  [
    createElement('h1', 'hello world')
    createElement(MyComponent, {
      props: {
        someProp: 'foo'
      }
    }),
    'bar'
  ]
)
```

### データオブジェクト詳解

1 つ注意点: `v-bind:class` と `v-bind:style` がテンプレート内で特殊な扱いをされているのと同じように、それらは VNode のデータオブジェクト内で自身のトップレベルフィールドを持ちます。

``` js
{
  // `v-bind:class` と同じ API
  'class': {
    foo: true,
    bar: false
  },
  // `v-bind:style` と同じ API
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
  // v-on:keyup.enter などの修飾詞はサポートされませんが、
  // "on" の配下にイベントハンドラはネストされます。
  // その代わり、手動で keyCode をハンドラの中で
  // 確認することが可能です。
  on: {
    click: this.clickHandler
  },
  // コンポーネントに限って、
  // vm.$emit を使っているコンポーネントから emit されるイベントではなく
  // ネイティブのイベントを listen することができます。
  nativeOn: {
    click: this.nativeClickHandler
  },
  // 他の特殊なトップレベルのプロパティ
  key: 'myKey',
  ref: 'myRef'
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
    // kebabCase id の作成
    var headingId = getChildrenTextContent(this.$slots.default)
      .toLowerCase()
      .replace(/\W+/g, '-')
      .replace(/(^\-|\-$)/g, '')

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

#### VNodes は一意でなければならない

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

もし同じ要素 / コンポーネントを何度も重複させたい場合には、factory 関数を使うことで対応できます。例えば、次の render 関数は 20 個の一意に特定できるパラグラフをレンダリングする完全に正当な方法です。

``` js
render: function (createElement) {
  var myParagraph =
  return createElement('div',
    Array.apply(null, { length: 20 }).map(function () {
      return createElement('p', 'hi')
    })
  )
}
```

## 素の JavaScript を使ったテンプレート置換機能

どんなところでも素の JavaScript で簡単に物事は成し遂げることができるので、Vue の render 関数は独自の代替手段を提供しません。例えば、`v-if` と `v-for` を使っているテンプレート内です。

``` html
<ul v-if="items.length">
  <li v-for="item in items">{{ item.name }}</li>
</ul>
<p v-else>No items found.</p>
```

これは render 関数の中で JavaScript の `if` / `else` と `map` を使って書き換えることができます。

``` js
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

## JSX

もしあなたが多くの render 関数を書いている場合は、よりシンプルでほぼ間違いなく読み易いテンプレート JSX の代わりに上記の 14 行を使っていることがつらいと感じるかもしれません。

``` html
<anchored-heading :level="1">
  <span>Hello</span> world!
</anchored-heading>
```

そのような理由から Vue で JSX を使うための [Babel プラグイン](https://github.com/vuejs/babel-plugin-transform-vue-jsx) があります。よりテンプレートに近い文法が戻ってきました。

``` js
import AnchoredHeading from './AnchoredHeading.vue'

new Vue({
  el: '#demo',
  render (h) {
    return (
      <AnchoredHeading level={1}>
        <span>Hello</span> world!
      </AnchoredHeading>
    )
  }
})
```

<p class="tip">`createElement` を `h` にエイリアスしていることは、 Vue のエコシステムの中でよく見かける慣習です。そして、それは実は JSX には必須です。もし `h` がそのスコープ内で利用可能でない場合、アプリケーションはエラーを throw するでしょう。</p>

より詳しい JSX の JavaScript へのマップの仕方については、[usage docs](https://github.com/vuejs/babel-plugin-transform-vue-jsx#usage) をご参照ください。

## 関数型コンポーネント

私たちが先ほど作成したアンカーヘッダコンポーネントは比較的シンプルです。状態の管理や渡された状態の watch をしておらず、また、何もライフサイクルメソッドを持ちません。実際、これはいくつかのプロパティを持つただの関数です。

このようなケースにおいて、私たちは `関数型` としてのコンポーネントと特徴づけることができます。それは状態を持たない ( `data` が無い) でインスタンスを持たない ( `this` のコンテキストが無い) ことを意味します。**関数型コンポーネント** は次のような形式をしています。

``` js
Vue.component('my-component', {
  functional: true,
  // インスタンスが無いことを補うために、
  // 2 つ目の context 引数が提供されます。
  render: function (createElement, context) {
    // ...
  },
  // プロパティは任意です
  props: {
    // ...
  }
})
```

このコンポーネントが必要な全てのことは `context` を受け取ることです。それは次を含むオブジェクトです。

- `props`: 提供されるプロパティのオブジェクト
- `children`: 子 VNode の配列
- `slots`: slots オブジェクトを返す関数
- `data`: コンポーネントに渡される全体のデータオブジェクト
- `parent`: 親コンポーネントへの参照

`functional: true` を追加した後、私たちのアンカーヘッダコンポーネントの render 関数の更新として単に必要になるのは、
`context` 引数の追加、`this.$slots.default` の `context.children` への更新、`this.level` の `context.props.level` への更新でしょう。

関数型コンポーネントはただの関数なので、レンダリングのコストは少ないです。また、ラッパーコンポーネントとしてもとても便利です。例えば、以下が必要な時に。

- いくつかの他のコンポーネントから 1 つ delegate するためのものをプログラムで選ぶ時
- 子、プロパティ、または、データを子コンポーネントへ渡る前に操作したい時

こちらが、渡されるプロパティに応じてより具体的なコンポーネントに委譲する `smart-list` コンポーネントの例です。

``` js
var EmptyList = { /* ... */ }
var TableList = { /* ... */ }
var OrderedList = { /* ... */ }
var UnorderedList = { /* ... */ }

Vue.component('smart-list', {
  functional: true,
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
  },
  props: {
    items: {
      type: Array,
      required: true
    },
    isOrdered: Boolean
  }
})
```

### `slots()` vs `children`

もしかするとなぜ `slots()` と `children` の両方が必要なのか不思議に思うかもしれません。 `slots().default` は `children` と同じではないのですか？いくつかのケースではそうですが、もし以下の子を持つ関数型コンポーネントの場合はどうなるでしょう。

``` html
<my-functional-component>
  <p slot="foo">
    first
  </p>
  <p>second</p>
</my-functional-component>
```

このコンポーネントの場合、 `children` は両方のパラグラフが与えられます。`slots().default` は 2 つ目のものだけ与えられます。そして `slots().foo` は 1 つ目のものだけです。したがって、 `children` と `slots()` の両方を持つことで このコンポーネントが slot システムを知っているか、もしくは、単純に `children` を渡しておそらく他のコンポーネントへその責任を delegate するかどうかを選べるようになります。

## テンプレートコンパイル

もしかするとあなたは Vue のテンプレートが実際に render 関数にコンパイルされることを知ることに興味を持つかもしれません。これは普段あなたは知る必要もない実装の詳細ですが、どのように特定のテンプレート機能がコンパイルされるかをもし見たいならこれに興味を持つかもしれません。以下は `Vue.compile` を使ってテンプレート文字列をその場でコンパイルをするちょっとしたデモです。

{% raw %}
<div id="vue-compile-demo" class="demo">
  <textarea v-model="templateText" rows="10"></textarea>
  <div v-if="typeof result === 'object'">
    <label>render:</label>
    <pre><code>{{ result.render }}</code></pre>
    <label>staticRenderFns:</label>
    <pre v-for="(fn, index) in result.staticRenderFns"><code>_m({{ index }}): {{ fn }}</code></pre>
  </div>
  <div v-else>
    <label>Compilation Error:</label>
    <pre><code>{{ result }}</code></pre>
  </div>
</div>
<script>
new Vue({
  el: '#vue-compile-demo',
  data: {
    templateText: '\
<div>\n\
  <h1>I\'m a template!</h1>\n\
  <p v-if="message">\n\
    {{ message }}\n\
  </p>\n\
  <p v-else>\n\
    No message.\n\
  </p>\n\
</div>\
    ',
  },
  computed: {
    result: function () {
      if (!this.templateText) {
        return 'Enter a valid template above'
      }
      try {
        var result = Vue.compile(this.templateText.replace(/\s{2,}/g, ''))
        return {
          render: this.formatFunction(result.render),
          staticRenderFns: result.staticRenderFns.map(this.formatFunction)
        }
      } catch (error) {
        return error.message
      }
    }
  },
  methods: {
    formatFunction: function (fn) {
      return fn.toString().replace(/(\{\n)(\S)/, '$1  $2')
    }
  }
})
console.error = function (error) {
  throw new Error(error)
}
</script>
<style>
#vue-compile-demo pre {
  padding: 10px;
  overflow-x: auto;
}
#vue-compile-demo code {
  white-space: pre;
  padding: 0
}
#vue-compile-demo textarea {
  width: 100%;

}
</style>
{% endraw %}
