---
title: Vue 1.xからの移行
type: guide
order: 24
---

## FAQ

> わお、このページは非常に長いですね！ということは、バージョン 2.0 は従来と全く異なっていて、私は全てを基礎からもう一度学ぶ必要があるのでしょう。その上で、移行は不可能ということでしょうか？

よくぞ聞いてくれました！その答えは No です。 API のおおよそ 90% が同じで、かつ基本となるコンセプトは変わっていません。 このセクションは、非常に詳しい説明と、多くの例を提供したいため、非常に長いです。 ですが、安心してください、 __このセクションは、上から下まで全て読むようなものではありません！__

> どこから移行をはじめるべきですか？

1. 現在のプロジェクト上で、[移行ヘルパー](https://github.com/vuejs/vue-migration-helper)を実行します。
私たちは以前の Vue 開発を単純なコマンドライン インターフェースに最小構成で注意深く詰め込みました。
それは、非推奨のパターンを認識するたびに移行をサジェストし、その上で詳しい情報へのリンクを提供します。

2. その後、このページのサイドバーの目次より、あなたが影響を受ける可能性のあるトピックを参照してください。移行ヘルパーが何も検出していない場合、それは素晴らしいことです。

3. もし、テストがある場合は、それらを実行し、失敗したものを参照してください。テストがない場合は、ブラウザ上でアプリケーションを開き、警告やエラーに対して、あなた自身の目で確認してください。

4. そろそろ、あなたのアプリケーションは完全に移行されるべきでしょう。もし、あなたがよりいっそう飢えている場合は、このページを残りの部分を読む、もしくは新しく、かつ改良されたガイドに「[はじめに](index.html)」から飛び込むこともできます。あなたは既に基本となるコンセプトに精通しているので、多くの場合、拾い読みすることとなります。

> Vue 1.x のアプリケーションを 2.0 に移行するにはどのくらいの時間がかかりますか？

移行期間は、いくつかの要因に依存します:

- アプリケーションの規模（小〜中規模アプリケーションの場合、おそらく1日かからないでしょう）

- 新しい機能を使う場合は、何度も混乱したことがあるでしょう。特に差別をしているわけではなく、 Vue 2.0 で作る際も、同様のことは起こるでしょう。

- 将来的に廃止される機能を使用している場合、大半は検索と置換でアップグレードできますが、一部は少し時間がかかるかもしれません。もしあなたが、現在のベスト・プラクティスを踏襲していない場合、 Vue 2.0 はあなたにそれを強制します。これは、長期的に見ると良いことですが、大幅(though possibly overdue)なリファクタリングを意味するかもしれません。

> もし Vue 2 へアップグレードする場合、 Vuex および Vue-Router もアップグレードする必要がありますか？

Vue-Router 2は、 Vue 2のみに互換性があるため、アップグレードする必要があります。同様に、 [migration path for Vue-Router](migration-vue-router.html) に従う必要があります。
幸いなことに、ほとんどのアプリケーションは、ルーターに関するコードが多くないため、この作業が1時間以上かかることはおそらくありません。

Vuex については、バージョン 0.8 は Vue 2 との互換性があるため、アップグレードは強制ではありません。
Vuex 2に導入された、新たな機能やボイラープレートを使用したい場合でないかぎり、直ちにアップグレードする必要はないでしょう。

## テンプレート

### フラグメントインスタンス <sup>非推奨</sup>

すべてのコンポーネントは、1つのルート要素を持っている必要があります。フラグメントインスタンスは、もはや許されません。もし、あなたが以下のようなテンプレートを使用している場合:

``` html
<p>foo</p>
<p>bar</p>
```

単に全体を新しい要素で囲うことを推奨します。  
例えば、このような形となります:

``` html
<div>
  <p>foo</p>
  <p>bar</p>
</div>
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>アップグレード後に end-to-end のテストスイートや、それに準ずるアプリケーションを実行し、テンプレート内の複数のルート要素に対してのコンソールの警告を探します。</p>
</div>
{% endraw %}

## ライフサイクルフック

### `beforeCompile` <sup>非推奨</sup>

代わりに、 `created` フックを使用します。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、このフックを全て見つけます。</p>
</div>
{% endraw %}

### `compiled` <sup>非推奨</sup>

代わりに、新たに `mounted` フックを使用します。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、このフックを全て見つけます。</p>
</div>
{% endraw %}

### `attached` <sup>非推奨</sup>

他のフックで DOM チェックをカスタムして使用します。 例えば、以下の場合:

``` js
attached: function () {
  doSomething()
}
```

このように置き換えます:

``` js
mounted: function () {
  this.$nextTick(function () {
    doSomething()
  })
}
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、このフックを全て見つけます。</p>
</div>
{% endraw %}

### `detached` <sup>非推奨</sup>

他のフックで DOM チェックをカスタムして使用します。 例えば、以下の場合:

``` js
detached: function () {
  doSomething()
}
```

このように置き換えます:

``` js
destroyed: function () {
  this.$nextTick(function () {
    doSomething()
  })
}
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、このフックを全て見つけます。</p>
</div>
{% endraw %}

### `init` <sup>非推奨</sup>

代わりに新しい `beforeCreate` フックを使用します。これは本質的には同じものです。
他のライフサイクルメソッドとの整合性のために改名されました。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、このフックを全て見つけます。</p>
</div>
{% endraw %}

### `ready` <sup>非推奨</sup>

<!-- 質問する -->
Use the new mounted hook instead. It should be noted though that with mounted, there’s no guarantee to be in-document. For that, also include Vue.nextTick/vm.$nextTick. For example:

``` js
mounted: function () {
  this.$nextTick(function () {
    // code that assumes this.$el is in-document
  })
}
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、このフックを全て見つけます。</p>
</div>
{% endraw %}

## `v-for`

### 配列においての `v-for` の引数の順序

`index` を含む場合、引数を `(index, value)` の順序で使用していました。それは今は、 `(value, index)` となり、 JavaScript ネイティブの `forEach` や `map` と一貫性を持つようになりました。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、非推奨な引数の順序を見つけます。
    <code>position</code> や <code>num</code> のような、あまり使われないような名称をインデックスの引数につけた場合、ヘルパーはそれを検出できないことがありますが、ご了承ください。
  </p>
</div>
{% endraw %}

### オブジェクトにおいての `v-for` の引数の順序

`key` を含む場合、引数を `(key, value)` の順序で使用していました。それは今は、 `(value, key)` となり、 lodash などの一般的なオブジェクトのイテレータと一貫性を持つようになりました。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、非推奨な引数の順序を見つけます。
    もしキーとなる引数に <code>name</code> や <code>property</code> のような、名称をつけていた場合、ヘルパーはそれを検出できないことがありますが、ご了承ください。
  </p>
</div>
{% endraw %}

### `$index` および `$key` <sup>非推奨</sup>

暗黙的に割り当てられていた `$index` および `$key` 変数が、 `v-for` にて明示的にそれらを定義するために廃止されました。
これは、 Vue の経験が浅い開発者がネストされたループを扱う場合に、コードを読むことが容易になります。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、これらの非推奨な変数を見つけます。もし間違いがある場合、 <strong>console errors</strong> などが表示されます: <code>Uncaught ReferenceError: $index is not defined</code></p>
</div>
{% endraw %}

### `track-by` <sup>非推奨</sup>

`track-by` は `key` に置き換えられました。
他の属性と同様に、 `v-bind` または `:` プリフィックスがない場合は文字列として処理されます。
殆どの場合、式として動的なバインディングを行いたいでしょう。その場合、例えば、以下の代わりに


``` html
<div v-for="item in items" track-by="id">
```

このように使用します:

``` html
<div v-for="item in items" v-bind:key="item.id">
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>track-by</code> を見つけます。
</div>
{% endraw %}

### `v-for` の値の範囲

以前は、 `v-for="number in 10"` がもつ `number` は0ではじまり、9で終わっていましたが、1ではじまり、10で終わるようになりました。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコードから <code>/\w+ in \d+/</code> の正規表現を探し出します。
    そして、それが <code>v-for</code> 内で使われている場合、あなたが影響を受ける可能性があるかどうかを確認してください。
  </p>
</div>
{% endraw %}

## Props

### `coerce` Prop オプション <sup>非推奨</sup>

もしあなたが prop に対して `coerce` オプションを利用したい場合、代わりにそのコンポーネント内に、その値に基づく computed value を設定してください。例えば、以下の代わりに:

``` js
props: {
  username: {
    type: String,
    coerce: function (value) {
      return value
        .toLowerCase()
        .replace(/\s+/, '-')
    }
  }
}
```

このように使用します:

``` js
props: {
  username: String,
},
computed: {
  normalizedUsername: function () {
    return this.username
      .toLowerCase()
      .replace(/\s+/, '-')
  }
}
```

これには、いくつかの利点があります:

- prop の元の値にアクセスし続けることができます。
- 強制された値に別名をつけることによって、よりはっきりと prop で与えられた値とは違うことがわかるようになります。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>coerce</code> オプションを見つけます。</p>
</div>
{% endraw %}

### `twoWay` Prop オプション <sup>非推奨</sup>

Prop は今や、全て単方向となりました。
親スコープ内への副作用を生成するために、コンポーネントは暗黙のバインディングの代わりに、明示的にイベントを発生させる必要があります。
より詳細な情報については、以下を参照します:

- [カスタムイベント](components.html#カスタムイベント)
- [カスタム入力コンポーネント](components.html#カスタム入力コンポーネント) (コンポーネントイベントを使用)
- [状態管理](state-management.html)

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>twoWay</code> オプションを見つけます。</p>
</div>
{% endraw %}

### `v-bind` への `.once` と `.sync` 修飾子 <sup>非推奨</sup>

Prop は今や、全て単方向となりました。
親スコープ内への副作用を生成するために、コンポーネントは暗黙のバインディングの代わりに、明示的にイベントを発生させる必要があります。
より詳細な情報については、以下を参照します:

- [カスタムイベント](components.html#カスタムイベント)
- [カスタム入力コンポーネント](components.html#カスタム入力コンポーネント) (コンポーネントイベントを使用)
- [状態管理](state-management.html)

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>.once</code> と <code>.sync</code> 修飾子を見つけます。</p>
</div>
{% endraw %}

### Prop のミューテーション <sup>非推奨</sup>

ローカルでの prop のミューテーションは、今はアンチパターンとみなされます。例えば、 prop を宣言した後に、コンポーネントに対して `this.myProp = 'someOtherValue'` 設定することなどです。
新しいレンダリング機構によって、親コンポーネントを再描画するたびに、子コンポーネントのローカルな変更は上書きされます。

prop のミューテーションのユースケースのほとんどの場合は、以下のオプションのいずれかで置き換えることができます:

- デフォルト値を設定したデータプロパティ
- 算出プロパティ

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>アップグレード後に end-to-end のテストスイートや、それに準ずるアプリケーションを実行し、 Prop のミューテーションに関するコンソールの警告を探します。</p>
</div>
{% endraw %}

### ルートインスタンス上での Props <sup>非推奨</sup>

ルートの Vue インスタンス(言い換えれば、 `new Vue({ ... })` によって作成されたインスタンス)においては、 `props` の代わりに `propsData` を使用します。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    もしあれば、 end-to-end のテストを走らせます。
    失敗したテストについては、ルートインスタンスに渡された prop はもはや動かないということをあなたに警告します。
  </p>
</div>
{% endraw %}

## 内蔵ディレクティブ

### `v-bind` においての Truthiness/Falsiness

`v-bind` を使用する時、 falsy な値は `null`, `undefined`, そして `false` のみとなります。これは、 `0` や空の文字列は truthy な値としてレンダリングされることを意味します。例として、 `v-bind:draggable="''"` は `draggable="true"` としてレンダリングされます。

列挙された属性について、上記の falsy な値に加え、文字列の `"false"` は、 `atr="false"` としてレンダリングされます。

<p class="tip">その他のディレクティブ(たとえば、 `v-if` や `v-show` )は、 JavaScript の一般的な truthiness がまだ適用されます。</p>

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    もしあれば、 end-to-end のテストを走らせます。
    失敗したテストについては、上記の変更によって影響を受ける可能性があり、その可能性があるアプリケーションの箇所を警告します。
  </p>
</div>
{% endraw %}

### コンポーネントにおける `v-on` を用いたネイティブイベントのListen

コンポーネントを使用している時、 `v-on` は、そのコンポーネントに向けて発生したカスタムイベントのみを待ち受けるようになりました。ルートエレメント上でネイティブの DOM イベントを待ち受けたい時は、 `.native` 修飾子によって実現できます。以下がその例です:

``` html
<my-component v-on:click.native="doSomething"></my-component>
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    もしあれば、 end-to-end のテストを走らせます。
    失敗したテストについては、上記の変更によって影響を受ける可能性があり、その可能性があるアプリケーションの箇所を警告します。
  </p>
</div>
{% endraw %}

### `v-model` の `debounce` <sup>非推奨</sup>

デバウンスは、 Ajax リクエストやその他の高不可な処理の実装頻度を制限するために使用されます。
Vue の `v-model` の `debounce` 属性パラメータは、非常に単純な用法を想定し、簡潔に作りましたが、それによって実際の状態の更新ではなく、自身をデバウンスする仕組みとなっています。
これは、小さな違いではありますが、アプリケーションの規模が大きくなるに連れて、この手法には限界がきます。

例えば、このように、検索指標を設計する際にこれらの限界が明らかになります:

{% raw %}
<script src="https://cdn.jsdelivr.net/lodash/4.13.1/lodash.js"></script>
<div id="debounce-search-demo" class="demo">
  <input v-model="searchQuery" placeholder="Type something">
  <strong>{{ searchIndicator }}</strong>
</div>
<script>
new Vue({
  el: '#debounce-search-demo',
  data: {
    searchQuery: '',
    searchQueryIsDirty: false,
    isCalculating: false
  },
  computed: {
    searchIndicator: function () {
      if (this.isCalculating) {
        return '⟳ Fetching new results'
      } else if (this.searchQueryIsDirty) {
        return '... Typing'
      } else {
        return '✓ Done'
      }
    }
  },
  watch: {
    searchQuery: function () {
      this.searchQueryIsDirty = true
      this.expensiveOperation()
    }
  },
  methods: {
    expensiveOperation: **********.debounce(function () {
      this.isCalculating = true
      setTimeout(function () {
        this.isCalculating = false
        this.searchQueryIsDirty = false
      }.bind(this), 1000)
    }, 500)
  }
})
</script>
{% endraw %}

Using the `debounce` attribute, there'd be no way to detect the "Typing" state, because we lose access to the input's real-time state. By decoupling the debounce function from Vue however, we're able to debounce only the operation we want to limit, removing the limits on features we can develop:

``` html
<!--
By using the debounce function from lodash or another dedicated
utility library, we know the specific debounce implementation we
use will be best-in-class - and we can use it ANYWHERE. Not just
in our template.
-->
<script src="https://cdn.jsdelivr.net/lodash/4.13.1/lodash.js"></script>
<div id="debounce-search-demo">
  <input v-model="searchQuery" placeholder="Type something">
  <strong>{{ searchIndicator }}</strong>
</div>
```

``` js
new Vue({
  el: '#debounce-search-demo',
  data: {
    searchQuery: '',
    searchQueryIsDirty: false,
    isCalculating: false
  },
  computed: {
    searchIndicator: function () {
      if (this.isCalculating) {
        return '⟳ Fetching new results'
      } else if (this.searchQueryIsDirty) {
        return '... Typing'
      } else {
        return '✓ Done'
      }
    }
  },
  watch: {
    searchQuery: function () {
      this.searchQueryIsDirty = true
      this.expensiveOperation()
    }
  },
  methods: {
    // This is where the debounce actually belongs.
    expensiveOperation: _.debounce(function () {
      this.isCalculating = true
      setTimeout(function () {
        this.isCalculating = false
        this.searchQueryIsDirty = false
      }.bind(this), 1000)
    }, 500)
  }
})
```

この方法のもう1つの利点として、デバウンスが完全なるラッパー関数でないことが挙げられます。
例えば、検索候補の為の API を叩く時、ユーザーが入力の手を止めてから候補を提供することは、理想的な体験とは言えません。
その代わりに欲しいのは、スロットリング関数になるでしょう。
現状、既にあなたが lodash のようなユーティリティライブラリを利用している場合、 `throttle` 関数を使用する形に置き換えます。これは、数分もあれば終わることです。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>debounce</code> 属性を見つけます。</p>
</div>
{% endraw %}

### `v-model` への `lazy` や `number` 属性 <sup>非推奨</sup>

`lazy` と `number` の属性値は修飾子となりました。それは、以下のように置き換えることを意味します:

``` html
<input v-model="name" lazy>
<input v-model="age" type="number" number>
```

このように置き換えます:

``` html
<input v-model.lazy="name">
<input v-model.number="age" type="number">
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、これらの非推奨の属性を見つけます。</p>
</div>
{% endraw %}

### `v-model` においてのインライン `value` <sup>非推奨</sup>

`v-model` はもはや、 インラインの `value` 属性を尊重しません。予測可能性のため、それは代わりに、常に Vue インスタンスをデータをソースとして扱います。
これは、以下のような要素を意味します:

``` html
<input v-model="text" value="foo">
```

このようなデータに裏付けられる場合:

``` js
data: {
  text: 'bar'
}
```

"foo" の代わりに "bar" がレンダリングされます。これは、既に内容を持つ場合の `<textarea>` においても同じことが言えます。以下の場合:

``` html
<textarea v-model="text">
  hello world
</textarea>
```

`text` の初期値が "hello world" となることが確認できます。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>アップグレード後に end-to-end のテストスイートや、それに準ずるアプリケーションを実行し、 <code>v-model</code> においてのインライン value 属性に対してのコンソールの警告を探します。</p>
</div>
{% endraw %}

### `v-model` への `v-for` プリミティブ値のイテレート <sup>非推奨</sup>

このようなケースは、もはや動作しません:

``` html
<input v-for="str in strings" v-model="str">
```

その理由は、以下の `<input>` にコンパイルされる JavaScript と同等の処理をおこなっているためです:

``` js
strings.map(function (str) {
  return createElement('input', ...)
})
```

これを見てわかるように、 `v-model` による双方向バインディングは、ここでは意味がありません。
それは、関数内のローカルスコープのみの変数なので、イテレータにて `str` に別の値を設定した場合にも何もしません。

代わりに、 `v-model` が、オブジェクトのフィールドを更新できるようにするためには、 __オブジェクト__ の配列を使用する必要があります。例えば以下となります:

``` html
<input v-for="obj in objects" v-model="obj.str">
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    もしあれば、テストスイートを走らせます。
    失敗したテストについては、ルートインスタンスに渡された prop はもはや動かないということをあなたに警告します。
  </p>
</div>
{% endraw %}

### `v-bind:style` with Object Syntax and `!important` <sup>非推奨</sup>

もはや、これは動かなくなります:

``` html
<p v-bind:style="{ color: myColor + ' !important' }">hello</p>
```

もしあなたが本当に `!important` をオーバーライドする必要がある場合、文字列の構文として使用します:

``` html
<p v-bind:style="'color: ' + myColor + ' !important'">hello</p>
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、オブジェクトへのスタイルのバインディングにおいての <code>!important</code> を見つけます。</p>
</div>
{% endraw %}

### `v-el` と `v-ref` <sup>非推奨</sup>

For simplicity, `v-el` and `v-ref` have been merged into the `ref` attribute, accessible on a component instance via `$refs`. That means `v-el:my-element` would become `ref="myElement"` and `v-ref:my-component` would become `ref="myComponent"`. When used on a normal element, the `ref` will be the DOM element, and when used on a component, the `ref` will be the component instance.

Since `v-ref` is no longer a directive, but a special attribute, it can also be dynamically defined. This is especially useful in combination with `v-for`. For example:

``` html
<p v-for="item in items" v-bind:ref="'item' + item.id"></p>
```

Previously, `v-el`/`v-ref` combined with `v-for` would produce an array of elements/components, because there was no way to give each item a unique name. You can still achieve this behavior by given each item the same `ref`:

``` html
<p v-for="item in items" ref="items"></p>
```

1.x とは異なり、これらの `$refs` は、それら自身のレンダリングに登録および更新をおこなっているため、リアクティブではありません。
それらを重複して反応させる際は、変更があるたびにレンダリングします。

一方で、 `$refs` は JavaScript によるプログラム的なアクセスとして主に利用するために設計されているため、テンプレートでそれらに依存することは推奨しません。
それは、インスタンス自体に属していない状態を指すこととなるので、 Vue のデータ駆動な ViewModel の設計に違反することとなります。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>v-el</code> and <code>v-ref</code> を見つけます。
</div>
{% endraw %}

### `v-else` への `v-show` <sup>非推奨</sup>

`v-else` はもはや、 `v-show` では動作しません。代わりに、 `v-if` の否定式を使用してください。例えば、このような場合代わりに:

``` html
<p v-if="foo">Foo</p>
<p v-else v-show="bar">Not foo, but bar</p>
```

このように使用します:

``` html
<p v-if="foo">Foo</p>
<p v-if="!foo && bar">Not foo, but bar</p>
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>v-else</code> への <code>v-show</code> を見つけます。</p>
</div>
{% endraw %}

## カスタムディレクティブ

ディレクティブはその責任範囲を大幅に削減しました: ディレクティブは、今やローレベルの直接な DOM 操作を適用するためにのみ使用されます。
ほとんどの場合、メインのコード再利用可能にし、抽象化したコンポーネントを使用するべきです。

顕著な違いとして、以下のようなものがあります:

- ディレクティブはもはや、インスタンスを持ちません。これは、もはや `this` 内部にディレクティブのフックがないことを意味します。その代わり、彼らは引数として必要なものを全て受け取ります。もし、あなたが本当にフック間で状態を保持する必要がある場合、 `el` 上にて行うことができます。
- `acceptStatement`, `deep`, `priority` などのようなオプションは全て非推奨となりました。
- 一部のフックが異なる振るまいをおこなっており、また、新たなフックと対になっているものもあります。

新しいディレクティブははるかにシンプルなので、幸いにも、よりかんたんに習得することができます。
より多くを学ぶには、新しい [Custom Directives guide](custom-directive.html) をお読みください。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 定義済みのディレクティブを見つけます。
    ヘルパーによって検出された箇所は、ほとんどの場合、将来的にコンポーネントにリファクタリングしたくなる部分となります。
  </p>
</div>
{% endraw %}

## トランジション

### `transition` 属性 <sup>非推奨</sup>

Vue のトランジション機構は大幅な変更を遂げました。
`transition` 属性ではなく、 `<transition>` および `<transition-group>` ラッパー要素を使用します。
より多くを学ぶためには、新しい[トランジションガイド](transitions.html)を読むことをおすすめします。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>transition</code> 属性を見つけます。</p>
</div>
{% endraw %}

### 再利用可能なトランジションへの `Vue.transition` <sup>非推奨</sup>

新しいトランジション機構の [再利用可能なトランジションへのコンポーネントの使用](http://rc.vuejs.org/guide/transitions.html#Reusable-Transitions) によって実現することができます。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>Vue.transition</code> を見つけます。</p>
</div>
{% endraw %}

### `stagger` 属性 <sup>非推奨</sup>

If you need to stagger list transitions, you can control timing by setting and accessing a `data-index` (or similar attribute) on an element. See [an example here](transitions.html#Staggering-List-Transitions).

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>transition</code> 属性を見つけます。
    During your update, you can transition (pun very much intended) to the new staggering strategy as well.
  </p>
</div>
{% endraw %}

## イベント

### `Vue.directive('on').keyCodes` <sup>非推奨</sup>

`keyCodes` を設定するための、より新しくかつ簡潔な方法は、`Vue.config.keyCodes` を介して行うことです。例えば、以下のようなものとなります:

``` js
// enable v-on:keyup.f1
Vue.config.keyCodes.f1 = 112
```
{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 古い <code>keyCode</code>のコンフィグが用いられた属性見つけます。</p>
</div>
{% endraw %}

### `$dispatch` および `$broadcast` <sup>非推奨</sup>

`$dispatch` and `$broadcast` are being deprecated in favor of more explicitly cross-component communication and more maintainable state management solutions, such as [Vuex](https://github.com/vuejs/vuex).

The problem is event flows that depend on a component's tree structure can be hard to reason about and very brittle when the tree becomes large. It simply doesn't scale well and we don't want to set you up for pain later. `$dispatch` and `$broadcast` also do not solve communication between sibling components.

For the simplest possible upgrade from `$dispatch` and `$broadcast`, you can use a centralized event hub that allows components to communicate no matter where they are in the component tree. Because Vue instances implement an event emitter interface, you can actually use an empty Vue instance for this purpose.

For example, let's say we have a todo app structured like this:

```
Todos
|-- NewTodoInput
|-- Todo
    |-- DeleteTodoButton
```


これらの単一のイベントハブとコンポーネント間の通信を管理することができました:

``` js
// This is the event hub we'll use in every
// component to communicate between them.
var eventHub = new Vue()
```

そして、コンポーネントにて、それによって `$emit` や `$on` 、 `$off` を用いてイベントを発生させることや、新たに待ち受けること、そしてそれらを初期化することができます。
以下がそれぞれの例となります:

``` js
// NewTodoInput
// ...
methods: {
  addTodo: function () {
    eventHub.$emit('add-todo', { text: this.newTodoText })
    this.newTodoText = ''
  }
}
```

``` js
// DeleteTodoButton
// ...
methods: {
  deleteTodo: function (id) {
    eventHub.$emit('delete-todo', id)
  }
}
```

``` js
// Todos
// ...
created: function () {
  eventHub.$on('add-todo', this.addTodo)
  eventHub.$on('delete-todo', this.deleteTodo)
},
// It's good to clean up event listeners before
// a component is destroyed.
beforeDestroy: function () {
  eventHub.$off('add-todo', this.addTodo)
  eventHub.$off('delete-todo', this.deleteTodo)
},
methods: {
  addTodo: function (newTodo) {
    this.todos.push(newTodo)
  },
  deleteTodo: function (todoId) {
    this.todos = this.todos.filter(function (todo) {
      return todo.id !== todoId
    })
  }
}
```

This pattern can serve as a replacement for `$dispatch` and `$broadcast` in simple scenarios, but for more complex cases, it's recommended to use a dedicated state management layer such as [Vuex](https://github.com/vuejs/vuex).

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>$dispatch</code> and <code>$broadcast</code> を見つけます。</p>
</div>
{% endraw %}

## フィルタ

### フィルタ外でのテキストの展開 <sup>非推奨</sup>

フィルタは、今やテキスト内での補完(`{% raw %}{{ }}{% endraw %}` タグ)のみで使用することができます。
今までの `v-model` や `v-on` ディレクティブ上でのフィルタリングは、それ自体の利便性よりも、コードの複雑化につながることのほうが多いことに気がつきました。
`v-for` 上でのリストのフィルタリングについては、それをコンポーネント上で再利用可能とするために、 computed property としてJavaScript上のそのロジックを移動させるようにしても良いでしょう。

行いたい処理がプレーンな JavaScript で実現可能な場合は、基本的には同じ結果をもたらすフィルタのような特殊な構文を導入しないようにしたいです。
この項で紹介する方法によって、 Vue の内蔵のディレクティブフィルタを置き換えることができます。具体的な方法は以下のとおりです:

#### `debounce` フィルタの置き換え

このような記述の代わりに:

``` html
<input v-on:keyup="doStuff | debounce 500">
```

``` js
methods: {
  doStuff: function () {
    // ...
  }
}
```

[lodash の `debounce` メソッド](https://lodash.com/docs/4.15.0#debounce)(または可能ならば [`throttle`](https://lodash.com/docs/4.15.0#throttle))を直接メソッドに対して使用します。上記のような挙動を望む場合、以下のように書くことで達成できます:

``` html
<input v-on:keyup="doStuff">
```

``` js
methods: {
  doStuff: _.debounce(function () {
    // ...
  }, 500)
}
```

この方法に対するより詳細な利点は[the example here with `v-model`](#v-model-with-debounce-deprecated)を参照してください。

#### `limitBy` フィルタの置き換え

このような記述の代わりに:

``` html
<p v-for="item in items | limitBy 10">{{ item }}</p>
```

JavaScript 内蔵の [`.slice` メソッド](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/slice#Examples)を算術プロパティへ使用します:

``` html
<p v-for="item in filteredItems">{{ item }}</p>
```

``` js
computed: {
  filteredItems: function () {
    return this.items.slice(0, 10)
  }
}
```

#### `filterBy` フィルタの置き換え

このような記述の代わりに:

``` html
<p v-for="user in users | filterBy searchQuery in 'name'">{{ user.name }}</p>
```

JavaScript 内蔵の [`.filter` メソッド](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/slice#Examples) を算術プロパティへ使用します:

``` html
<p v-for="user in filteredUsers">{{ user.name }}</p>
```

``` js
computed: {
  filteredUsers: function () {
    return this.users.filter(function (user) {
      return user.name.indexOf(this.searchQuery)
    })
  }
}
```

算術プロパティに対しては、完全なるアクセス権があるため、 JavaScript 内蔵の `.filter` は、非常に複雑なフィルタリングの管理を行うことができます。
例えば、もしあなたがすべてのアクティブユーザーを見つけるために、大文字小文字を区別せず、名前と E メールアドレスの両方を調べたい場合は、以下のようになります:

``` js
this.users.filter(function (user) {
  var searchRegex = new RegExp(this.searchQuery, 'i')
  return user.isActive && (
    searchRegex.test(user.name) ||
    searchRegex.test(user.email)
  )
})
```

#### `orderBy` フィルタの置き換え

このような記述の代わりに:

``` html
<p v-for="user in users | orderBy 'name'">{{ user.name }}</p>
```

算術プロパティへ、[lodash の `orderBy`](https://lodash.com/docs/4.15.0#orderBy) (もしくは [`sortBy`](https://lodash.com/docs/4.15.0#sortBy))を使用します。

``` html
<p v-for="user in orderedUsers">{{ user.name }}</p>
```

``` js
computed: {
  orderedUsers: function () {
    return _.orderBy(this.users, 'name')
  }
}
```

複数のカラムを用いた並び替えも可能です:

``` js
_.orderBy(this.users, ['name', 'last_login'], ['asc', 'desc'])
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 ディレクティブ内部で使用されているフィルタを見つけます。
    もし間違いがある場合、 <strong>consoleのエラー</strong>を参照してください。
  </p>
</div>
{% endraw %}

### フィルタ引数の構文

JavaScript の関数を呼び出す際、引数のフィルタがより良い構文となります。例えば、スペースで区切る形には以下のように置き換えることができます。

``` html
<p>{{ date | formatDate 'YY-MM-DD' timeZone }}</p>
```

カッコで引数を囲んだ上で、カンマを用いて引数を区切ります:

``` html
<p>{{ date | formatDate('YY-MM-DD', timeZone) }}</p>
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、古いフィルタが用いられているコードを見つけます。
    もし間違いがある場合、 <strong>consoleのエラー</strong>を参照してください。
  </p>
</div>
{% endraw %}

### 内蔵フィルタ <sup>非推奨</sup>

テキストを展開するためのフィルタは、現状はまだ利用できますが、すべてのフィルタが削除されました。
それらの代わりに、（例えば日付のフォーマットには [`date-fns`](https://date-fns.org/)　、通貨処理には [`accounting`](http://openexchangerates.github.io/accounting.js/) と言った形で) より専門的なライブラリの使用を推奨します。

Vue に内蔵されたテキストフィルタ群は、それぞれ以下のように置き換えることができます。
これらの例には、カスタムヘルパーや関数、メソッドの他、算術プロパティなどが含まれます。

#### `json` フィルタの置き換え

Vue がうまい具合に文字列や数値、配列からオブジェクトまで、自動的にフォーマットした上で出力するようになったため、あなたがデバッグする必要はありません。
もし、あなたが JavaScript の `JSON.stringify` と全く同じ機能が必要ならば、 computed property にて行うことが可能です。

#### `capitalize` フィルタの置き換え

``` js
text[0].toUpperCase() + text.slice(1)
```

#### `uppercase` フィルタの置き換え

``` js
text.toUpperCase()
```

#### `lowercase` フィルタの置き換え

``` js
text.toLowerCase()
```

#### `pluralize` フィルタの置き換え

npm 上にある [pluralize](https://www.npmjs.com/package/pluralize) パッケージによってこの目的を果たすことができますが、あなたがもし、特定の単語のみを複数形にしたい場合や、 `0` のようなケースの場合に特別な出力を行いたい場合は、例えば、以下のように簡単に独自の複数形にする関数を定義することができます。:

``` js
function pluralizeKnife (count) {
  if (count === 0) {
    return 'no knives'
  } else if (count === 1) {
    return '1 knife'
  } else {
    return count + 'knives'
  }
}
```

#### `currency` フィルタの置き換え

非常に単純な実装例として、このような形で実現することができます:

``` js
'$' + price.toFixed(2)
```

しかしながら、ほとんどの場合、これらは奇妙な動作をする場合があります(例えば、 0.035.toFixed(2) の丸め誤差が 0.4 として評価されるにも関わらず、 0.045 の丸め誤差が 0.4と評価されるなどです)。
これらの問題を解消するためには、より確実な [通貨のフォーマット管理のライブラリ](http://openexchangerates.github.io/accounting.js/) などを使用します。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、非推奨のフィルタを見つけます。
    もし間違いがある場合、 <strong>consoleのエラー</strong>を参照してください。
  </p>
</div>
{% endraw %}

## スロット

### 重複したスロット <sup>非推奨</sup>

もはや、同じテンプレート内に、同名のスロットを持つことはサポートされません。
スロットがレンダリングされるとき、そのスロットは「使い果たされ」、同じレンダリングツリーの中で再度レンダリングすることはできません。
もし、複数の場所で同一の内容をレンダリングする必要がある場合は、 prop としてそのコンテンツを渡します。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>アップグレード後に end-to-end のテストスイートや、それに準ずるアプリケーションを実行し、 <code>v-model</code> においての重複スロットに対してのコンソールの警告を探します。</p>
</div>
{% endraw %}

### `slot` 属性のスタイリング <sup>非推奨</sup>

名前付きスロットを経由して挿入されたコンテンツは、もはや `slot` 属性を保持しません。

スタイル属性を付与したい場合は、なんらかのラップした要素に適用するか、複雑なユースケースの場合は、 [`render` 関数](render-function.html) を用いて、プログラムにてコンテンツを変更してください。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 名前付き slot を対象としているCSSのセレクタ(例えば、 <code>slot="my-slot-name"]</code> など)を見つけます。</p>
</div>
{% endraw %}

## 特別な属性

### `keep-alive` 属性 <sup>非推奨</sup>

`keep-alive` はもはや、特別な属性ではなく、 `<transition>` と同様に、コンポーネントのラッパーではありません。例えば以下の場合:

``` html
<keep-alive>
  <component v-bind:is="view"></component>
</keep-alive>
```

これによって、 `<keep-alive>` を複数条件下において使用することができます:

``` html
<keep-alive>
  <todo-list v-if="todos.length > 0"></todo-list>
  <no-todos-gif v-else></no-todos-gif>
</keep-alive>
```

<p class="tip">
    `<keep-alive>` が複数の子要素を持っているとき、 `<keep-alive>` は単一の子要素のみを評価します。
    最初のひとつ目の要素以外は、単純に無視されます。
</p>

`<transition>` とともに用いるときは、それらをネストさせてください:

``` html
<transition>
  <keep-alive>
    <component v-bind:is="view"></component>
  </keep-alive>
</transition>
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>keep-alive</code> 属性を見つけます。</p>
</div>
{% endraw %}

## 展開

### 属性内での展開 <sup>非推奨</sup>

属性内での展開は、もはや有効ではありません。例えば、以下の場合:

``` html
<button v-bind:class="btn btn-{{ size }}"></button>
```

いずれかのインライン式を使用するように更新する必要があります:

``` html
<button v-bind:class="'btn btn-' + size"></button>
```

もしくはデータ/算出プロパティを使用します:

``` html
<button v-bind:class="buttonClasses"></button>
```

``` js
computed: {
  buttonClasses: function () {
    return 'btn btn-' + size
  }
}
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、属性内で使用されている interpolation を見つけます。</p>
</div>
{% endraw %}

### HTML の展開 <sup>非推奨</sup>

新たな [`v-html` ディレクティブ](/api/#v-html) を支持することによって、 HTML の展開(`{% raw %}{{{ foo }}}{% endraw %}`) は非推奨となりました。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 HTML の展開が行われているコードを検索します。</p>
</div>
{% endraw %}

### ワンタイムバインディング <sup>非推奨</sup>

新たな [`v-once` ディレクティブ](/api/#v-once) を支持することによって、ワンタイムバインディング  (`{% raw %}{{* foo }}{% endraw %}`) は非推奨となりました。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、ワンタイムバインディングを見つけます。</p>
</div>
{% endraw %}

## リアクティブ

### `vm.$watch`

Watchers created via `vm.$watch` are now fired before the associated component rerenders.
This gives you the chance to further update state before the component rerender, thus avoiding unnecessary updates.
For example, you can watch a component prop and update the component's own data when the prop changes.

これまで、 `vm.$watch` を利用することでコンポーネントのアップデート後に　DOM に対して何らかの操作をしていた場合、それを `updated` ライフサイクルフックに置き換えることができます。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    もしあれば、 end-to-end のテストを走らせます。
    失敗したテストについては、ウォッチャーが古い動作であることを警告します。
  </p>
</div>
{% endraw %}

### `vm.$set`

`vm.$set` は非推奨となっており、 [`Vue.set`](/api/#Vue-delete) という名称になっています。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、非推奨の用法を見つけます。</p>
</div>
{% endraw %}

### `vm.$delete`

`vm.$delete` は非推奨となっており、 [`Vue.delete`](/api/#Vue-delete) という名称になっています。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、非推奨の用法を見つけます。</p>
</div>
{% endraw %}

### `Array.prototype.$set`  <sup>非推奨</sup>

代わりに、 Vue.set を使用します。

(console error, migration helper)

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、配列に対しての <code>.$set</code> を見つけます。
    もし間違いがある場合、 <strong>consoleのエラー</strong>を参照してください。
  </p>
</div>
{% endraw %}

### `Array.prototype.$remove` <sup>非推奨</sup>

例えば、代わりに `Array.prototype.splice` を使用します:

``` js
methods: {
  removeTodo: function (todo) {
    var index = this.todos.indexOf(todo)
    this.todos.splice(index, 1)
  }
}
```

いっそのこと、削除メソッドに index を渡す方法も良いでしょう:

``` js
methods: {
  removeTodo: function (index) {
    this.todos.splice(index, 1)
  }
}
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、配列に対しての <code>.$remove</code> を見つけます。
    もし間違いがある場合、 <strong>consoleのエラー</strong>を参照してください。
  </p>
</div>
{% endraw %}

### Vue インスタンス上での `Vue.set` および `Vue.delete` <sup>非推奨</sup>

Vue.set および Vue.delete はもはや、 Vue インスタンス上で動作することはできません。
データオプション内で、全てのトップレベルのリアクティブなプロパティが必須となりました。
もし、 Vue のインスタンス上で `$data` を削除したい場合、単に null を代入します。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 Vue インスタンス上で使われている  <code>Vue.set</code> もしくは <code>Vue.delete</code> を見つけます。
    もし間違いがある場合、 <strong>consoleの警告</strong>を参照してください。
  </p>
</div>
{% endraw %}

### Replacing `vm.$data` <sup>非推奨</sup>

現在では、コンポーネントのインスタンスのルートにある `$data` を書き換えることは禁止されています。
これは、リアクティブなシステムの上での極端なケースを防ぎ、(特に型チェックシステム上での)コンポーネントの状態をより予測しやすくします。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>vm.$data</code> が上書きされている箇所を見つけます。
    もし間違いがある場合、 <strong>consoleの警告</strong>を参照してください。
  </p>
</div>
{% endraw %}

### `vm.$get` <sup>非推奨</sup>

リアクティブなデータを直接取得します。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>vm.$get</code> を見つけます。
    もし間違いがある場合、 <strong>consoleのエラー</strong>を参照してください。
  </p>
</div>
{% endraw %}

## DOM を中心としたインスタンスメソッド

### `vm.$appendTo` <sup>非推奨</sup>

ネイティブの DOM API を使用します:

``` js
myElement.appendChild(vm.$el)
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>vm.$appendTo</code> を見つけます。
    もし間違いがある場合、 <strong>consoleのエラー</strong>を参照してください。
  </p>
</div>
{% endraw %}

### `vm.$before` <sup>非推奨</sup>

ネイティブの DOM API を使用します:

``` js
myElement.parentNode.insertBefore(vm.$el, myElement)
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>vm.$before</code> を見つけます。
    もし間違いがある場合、 <strong>consoleのエラー</strong>を参照してください。
  </p>
</div>
{% endraw %}

### `vm.$after` <sup>非推奨</sup>

ネイティブの DOM API を使用します:

``` js
myElement.parentNode.insertBefore(vm.$el, myElement.nextSibling)
```

もし `myElement` が最後の要素の場合は、以下のように対処します:

``` js
myElement.parentNode.appendChild(vm.$el)
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>vm.$after</code> を見つけます。
    もし間違いがある場合、 <strong>consoleのエラー</strong>を参照してください。
  </p>
</div>
{% endraw %}

### `vm.$remove` <sup>非推奨</sup>

ネイティブの DOM API を使用します:

``` js
vm.$el.remove()
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>vm.$remove</code> を見つけます。
    もし間違いがある場合、 <strong>consoleのエラー</strong>を参照してください。
  </p>
</div>
{% endraw %}

## メタインスタンスメソッド

### `vm.$eval` <sup>非推奨</sup>

この機能が実際に使用されることはありません。
もしあなたがこの機能を利用する機会があり、それを回避する方法が思いつかない場合は、[フォーラム](http://forum.vuejs.org/)にてアイデアを募ってください。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>vm.$eval</code> を見つけます。
    もし間違いがある場合、 <strong>consoleのエラー</strong>を参照してください。
  </p>
</div>
{% endraw %}

### `vm.$interpolate` <sup>非推奨</sup>

この機能が実際に使用されることはありません。
もしあなたがこの機能を利用する機会があり、それを回避する方法が思いつかない場合は、[フォーラム](http://forum.vuejs.org/)にてアイデアを募ってください。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>vm.$interpolate</code> を見つけます。
    もし間違いがある場合、 <strong>consoleのエラー</strong>を参照してください。
  </p>
</div>
{% endraw %}

### `vm.$log` <sup>非推奨</sup>

最適なデバッグのために、 [Vue Devtools](https://github.com/vuejs/vue-devtools) を利用してください。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>vm.$log</code> を見つけます。
    もし間違いがある場合、 <strong>consoleのエラー</strong>を参照してください。
  </p>
</div>
{% endraw %}

## インスタンス DOM オプション

### `replace: false` <sup>非推奨</sup>

コンポーネントは常に紐づく要素に置き換えられます。 `replace:false` の挙動を再現するには、コンポーネントのルートを置き換えたい要素で囲みます。例えば、このような場合は:

``` js
new Vue({
  el: '#app',
  template: '<div id="app"> ... </div>'
})
```

render 関数で行います:

``` js
new Vue({
  el: '#app',
  render: function (h) {
    h('div', {
      attrs: {
        id: 'app',
      }
    }, /* ... */)
  }
})
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>replace: false</code> を見つけます。</p>
</div>
{% endraw %}

## グローバル設定

### `Vue.config.debug` <sup>非推奨</sup>

警告に対して、必要に応じてデフォルトでスタックトレースが付随しています。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>Vue.config.debug</code> を見つけます。</p>
</div>
{% endraw %}

### `Vue.config.async` <sup>非推奨</sup>

非同期処理は現在では、レンダリングパフォーマンスのために必要とされます。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>Vue.config.async</code> を見つけます。</p>
</div>
{% endraw %}

### `Vue.config.delimiters` <sup>非推奨</sup>

[コンポーネントレベルのオプション](/api/#delimiters) として作り直されました。
これは、サードパーティのコンポーネントを壊すことなく、アプリケーション内で代替のデリミタを使用することができます。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>Vue.config.delimiters</code> を見つけます。</p>
</div>
{% endraw %}

### `Vue.config.unsafeDelimiters` <sup>非推奨</sup>

[`v-html` を支持すること](#HTML-Interpolation-deprecated) によって、 HTML の展開は非推奨となりました。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>Vue.config.delimiters</code> を見つけます。
    その後、ヘルパーは <code>v-html</code> に置き換えることができる HTML の展開が行われているコードを検索します。
  </p>
</div>
{% endraw %}

## グローバル API

### `Vue.extend` への `el` <sup>非推奨</sup>

el オプションは、もはや `Vue.extend` で使用することはできません。これは、インスタンスの作成オプションとしてのみ有効です。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>アップグレード後に end-to-end のテストスイートやアプリケーションを実行し、 <code>Vue.extend</code> への <code>el</code> に関するコンソールの警告を探します。</p>
</div>
{% endraw %}

### `Vue.elementDirective` <sup>非推奨</sup>

代わりに components を使用します。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>Vue.elementDirective</code> を見つけます。</p>
</div>
{% endraw %}

### `Vue.partial` <sup>非推奨</sup>

代わりに、[関数型コンポーネント](render-function.html#関数型コンポーネント)を使用します。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>Vue.partial</code> を見つけます。</p>
</div>
{% endraw %}
