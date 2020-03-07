---
title: Vue 1.x からの移行
updated: 2020-03-07
type: guide
order: 701
---

## FAQ

> わお、このページは非常に長いですね！ということは、バージョン 2.0 は従来と全く異なっていて、私は全てを基礎からもう一度学ぶ必要があるのでしょう。その上で、移行は不可能ということでしょうか？

よくぞ聞いてくれました！その答えは No です。 API のおおよそ 90% が同じで、かつ基本となるコンセプトは変わっていません。 このセクションは、非常に詳しい説明と、多くの例を提供したいため、非常に長いです。 ですが、安心してください、 __このセクションは、上から下まで全て読むようなものではありません！__

> どこから移行をはじめるべきですか？

1. 現在のプロジェクト上で、[移行ヘルパー](https://github.com/vuejs/vue-migration-helper)を実行します。私たちは以前の Vue 開発を単純なコマンドライン インターフェースに最小構成で注意深く詰め込みました。それは、廃止された機能を認識するたびに移行をサジェストし、その上で詳しい情報へのリンクを提供します。

2. その後、このページのサイドバーの目次より、あなたが影響を受ける可能性のあるトピックを参照してください。移行ヘルパーが何も検出していない場合、それは素晴らしいことです。

3. もし、テストがある場合は、それらを実行し、失敗したものを参照してください。テストがない場合は、ブラウザ上でアプリケーションを開き、警告やエラーに対して、あなた自身の目で確認してください。

4. そろそろ、あなたのアプリケーションは完全に移行されるべきでしょう。もし、あなたがよりいっそう飢えている場合は、このページを残りの部分を読む、もしくは新しく、かつ改良されたガイドに「[はじめに](index.html)」から飛び込むこともできます。あなたは既に基本となるコンセプトに精通しているので、多くの場合、拾い読みすることとなります。

> Vue 1.x のアプリケーションを 2.0 に移行するにはどのくらいの時間がかかりますか？

移行期間は、いくつかの要因に依存します:

- アプリケーションの規模（小〜中規模アプリケーションの場合、おそらく1日かからないでしょう）

- 新しい機能を使う場合は、何度も混乱したことがあるでしょう。😉 特に差別をしているわけではなく、 Vue 2.0 で作る際も、同様のことは起こるでしょう。

- 将来的に廃止される機能を使用している場合、大半は検索と置換でアップグレードできますが、一部は少し時間がかかるかもしれません。もしあなたが、現在のベストプラクティスを踏襲していない場合、 Vue 2.0 はあなたにそれを強制します。これは、長期的に見ると良いことですが、大幅(though possibly overdue)なリファクタリングを意味するかもしれません。

> もし Vue 2.0 へアップグレードする場合、 Vuex および Vue Router もアップグレードする必要がありますか？

Vue Router 2 は、Vue 2.0 のみに互換性があるため、アップグレードする必要があります。同様に、[Vue-Router 向けの移行パス](migration-vue-router.html) に従う必要があります。
幸いなことに、ほとんどのアプリケーションは、ルーターに関するコードが多くないため、この作業が 1 時間以上かかることはおそらくありません。

Vuex については、バージョン 0.8 は Vue 2.0 との互換性があるため、アップグレードは強制ではありません。
Vuex 2 に導入された、新たな機能やボイラープレートを使用したい場合でないかぎり、直ちにアップグレードする必要はないでしょう。

## テンプレート

### フラグメントインスタンス <sup>削除</sup>

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

### `beforeCompile` <sup>削除</sup>

代わりに、 `created` フックを使用します。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、このフックを全て見つけます。</p>
</div>
{% endraw %}

### `compiled` <sup>置き換え</sup>

代わりに、新たに `mounted` フックを使用します。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、このフックを全て見つけます。</p>
</div>
{% endraw %}

### `attached` <sup>削除</sup>

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

### `detached` <sup>削除</sup>

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

### `init` <sup>置き換え</sup>

代わりに新しい `beforeCreate` フックを使用します。これは本質的には同じものです。
他のライフサイクルメソッドとの整合性のために改名されました。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、このフックを全て見つけます。</p>
</div>
{% endraw %}

### `ready` <sup>置き換え</sup>

かわりに、新しい mounted フックを使用します。ただし、マウントされたとしてもドキュメントに存在する保証はありません。 そのため、`Vue.nextTick/vm.$nextTick` で包む必要があります。 例えば、以下のようになります:

``` js
mounted: function () {
  this.$nextTick(function () {
    // this.$el がドキュメント内にあることを前提としたコードを書きます
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

### 配列においての `v-for` の引数の順序 <sup>変更</sup>

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

### オブジェクトにおいての `v-for` の引数の順序 <sup>変更</sup>

プロパティ名/キーを含む場合、引数を `(name, value)` の順序で使用していました。それは今は、 `(value, name)` となり、 lodash などの一般的なオブジェクトのイテレータと一貫性を持つようになりました。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、非推奨な引数の順序を見つけます。
    もしキーとなる引数に <code>name</code> や <code>property</code> のような、名称をつけていた場合、ヘルパーはそれを検出できないことがありますが、ご了承ください。
  </p>
</div>
{% endraw %}

### `$index` および `$key` <sup>削除</sup>

暗黙的に割り当てられていた `$index` および `$key` 変数が、 `v-for` にて明示的にそれらを定義するために廃止されました。
これは、 Vue の経験が浅い開発者がネストされたループを扱う場合に、コードを読むことが容易になります。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、これらの非推奨な変数を見つけます。もし間違いがある場合以下のような、 <strong>console errors</strong> などが表示されます: <code>Uncaught ReferenceError: $index is not defined</code></p>
</div>
{% endraw %}

### `track-by` <sup>置き換え</sup>

`track-by` は `key` に置き換えられました。
他の属性と同様に、 `v-bind` または `:` 接頭辞がない場合は文字列として処理されます。
殆どの場合、式として動的なバインディングを行いたいでしょう。その場合、例えば、以下の代わりに


{% codeblock lang:html %}
<div v-for="item in items" track-by="id">
{% endcodeblock %}

このように使用します:

{% codeblock lang:html %}
<div v-for="item in items" v-bind:key="item.id">
{% endcodeblock %}

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>track-by</code> を見つけます。
</div>
{% endraw %}

### `v-for` の値の範囲 <sup>変更</sup>

以前は、 `v-for="number in 10"` がもつ `number` は 0 ではじまり、9 で終わっていましたが、1 ではじまり、10 で終わるようになりました。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコードから <code>/\w+ in \d+/</code> の正規表現を探し出します。
    そして、それが <code>v-for</code> 内で使われている場合、あなたが影響を受ける可能性があるかどうかを確認してください。
  </p>
</div>
{% endraw %}

## プロパティ

### `coerce` プロパティオプション <sup>削除</sup>

もしあなたがプロパティに対して `coerce` オプションを利用したい場合、その代わりとしてコンポーネント内の算出プロパティで算出された値で設定してください。例えば、以下の代わりに:

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

- プロパティの元の値にアクセスし続けることができます。
- 強制された値に別名をつけることによって、よりはっきりとプロパティで与えられた値とは違うことがわかるようになります。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>coerce</code> オプションを見つけます。</p>
</div>
{% endraw %}

### `twoWay` プロパティオプション <sup>削除</sup>

プロパティは今や、全て単方向となりました。
親スコープ内への副作用を生成するために、コンポーネントは暗黙のバインディングの代わりに、明示的にイベントを発生させる必要があります。
より詳細な情報については、以下を参照します:

- [カスタムイベント](components.html#カスタムイベント)
- [カスタム入力コンポーネント](components.html#カスタムイベントを使用したフォーム入力コンポーネント) (コンポーネントイベントを使用)
- [状態管理](state-management.html)

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>twoWay</code> オプションを見つけます。</p>
</div>
{% endraw %}

### `v-bind` への `.once` と `.sync` 修飾子 <sup>削除</sup>

プロパティは今や、全て単方向となりました。
親スコープ内への副作用を生成するために、コンポーネントは暗黙のバインディングの代わりに、明示的にイベントを発生させる必要があります。
より詳細な情報については、以下を参照します:

- [カスタムイベント](components.html#カスタムイベント)
- [カスタム入力コンポーネント](components.html#カスタムイベントを使用したフォーム入力コンポーネント) (コンポーネントイベントを使用)
- [状態管理](state-management.html)

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>.once</code> と <code>.sync</code> 修飾子を見つけます。</p>
</div>
{% endraw %}

### プロパティの変更 <sup>非推奨</sup>

ローカルでのプロパティの変更は、今はアンチパターンとみなされます。例えば、 プロパティを宣言した後に、コンポーネントに対して `this.myProp = 'someOtherValue'` 設定することなどです。新しいレンダリングシステムによって、親コンポーネントを再描画するたびに、子コンポーネントのローカルな変更は上書きされます。

プロパティの変更のユースケースのほとんどの場合は、以下のオプションのいずれかで置き換えることができます:

- デフォルト値を設定したデータプロパティ
- 算出プロパティ

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>アップグレード後に end-to-end のテストスイートや、それに準ずるアプリケーションを実行し、プロパティの変更に関するコンソールの警告を探します。</p>
</div>
{% endraw %}

### ルートインスタンス上でのプロパティ<sup>置き換え</sup>

ルートの Vue インスタンス(言い換えれば、 `new Vue({ ... })` によって作成されたインスタンス)においては、 `props` の代わりに `propsData` を使用します。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    もしあれば、 end-to-end のテストを走らせます。
    失敗したテストについては、ルートインスタンスに渡されたプロパティはもはや動かないということをあなたに警告します。
  </p>
</div>
{% endraw %}

## 算出プロパティ

### `cache: false` <sup>非推奨</sup>

将来のメジャーバージョンの Vue では、算出プロパティのキャッシュ無効化が削除されます。キャッシュされていない算出プロパティを、同じ結果を持つメソッドに置き換えます。

例:

``` js
template: '<p>message: {{ timeMessage }}</p>',
computed: {
  timeMessage: {
    cache: false,
    get: function () {
      return Date.now() + this.message
    }
  }
}
```

または、コンポーネントメソッドで:

``` js
template: '<p>message: {{ getTimeMessage() }}</p>',
methods: {
  getTimeMessage: function () {
    return Date.now() + this.message
  }
}
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>cache: false</code>オプションを見つけます。</p>
</div>
{% endraw %}

## 組み込みディレクティブ

### `v-bind` においての 真/偽 <sup>変更</sup>

`v-bind` を使用する時、偽となりうる値は `null`, `undefined`, そして `false` のみとなります。これは、 `0` や空の文字列は、真となりうる値として描画されることを意味します。例として、 `v-bind:draggable="''"` は `draggable="true"` として描画されます。

列挙された属性については、上記の偽となりうる値に加え、文字列の `"false"` は、 `attr="false"` として描画されます。

<p class="tip">その他のディレクティブ(たとえば、 `v-if` や `v-show` )は、 JavaScript の一般的な真がまだ適用されます。</p>

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    もしあれば、 end-to-end のテストを走らせます。
    失敗したテストについては、上記の変更によって影響を受ける可能性があり、その可能性があるアプリケーションの箇所を警告します。
  </p>
</div>
{% endraw %}

### コンポーネントにおける `v-on` を用いたネイティブイベントの購読 <sup>変更</sup>

コンポーネントを使用している時、 `v-on` は、そのコンポーネントに向けて発生したカスタムイベントのみを購読するようになりました。ルート要素上でネイティブの DOM イベントを購読したい時は、 `.native` 修飾子によって実現できます。以下がその例です:

{% codeblock lang:html %}
<my-component v-on:click.native="doSomething"></my-component>
{% endcodeblock %}

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    もしあれば、 end-to-end のテストを走らせます。
    失敗したテストについては、上記の変更によって影響を受ける可能性があり、その可能性があるアプリケーションの箇所を警告します。
  </p>
</div>
{% endraw %}

### `v-model` の `debounce` <sup>削除</sup>

デバウンスは、 Ajax リクエストやその他の高負荷な処理の実装頻度を制限するために使用されます。Vue の `v-model` の `debounce` 属性パラメータは、非常に単純な用法を想定し、簡潔に作りましたが、それによって実際の状態の更新ではなく、自身をデバウンスする仕組みとなっています。これは、小さな違いではありますが、アプリケーションの規模が大きくなるに連れて、この手法には限界がきます。

例えば、このように、検索ボックスを設計する際にこれらの限界が明らかになります:

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
    expensiveOperation: _.debounce(function () {
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

デバウンス属性を使用している場合、入力の状態に関するリアルタイムなアクセス権を失うため、「タイピング中」の状態を検出する方法がないと思います。
しかし、 Vue からデバウンス機能を切り離すことによって、将来的な開発での制限を取り除くことができます。

``` html
<!--
lodash もしくは他の専用のユーティリティライブラリのデバウンス機能を用いてデバウンスを行うことが最も良いでしょう。また、それを Vue ではあらゆる箇所で利用することが可能です。
そしてそれは、テンプレート内に限った話ではありません。
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
    // これが、実際のデバウンスが書かれているところです。
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

この方法のもう1つの利点として、デバウンスが完全なるラッパー関数でないことが挙げられます。例えば、検索候補の為の API を叩く時、ユーザーが入力の手を止めてから候補を提供することは、理想的な体験とは言えません。その代わりに欲しいのは、スロットリング関数になるでしょう。現状、既にあなたが lodash のようなユーティリティライブラリを利用している場合、 `throttle` 関数を使用する形に置き換えます。これは、数分もあれば終わることです。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>debounce</code> 属性を見つけます。</p>
</div>
{% endraw %}

### `v-model` への `lazy` や `number` 属性 <sup>置き換え</sup>

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

### `v-model` においてのインライン `value` <sup>削除</sup>

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

"foo" の代わりに "bar" が描画されます。これは、既に内容を持つ場合の `<textarea>` においても同じことが言えます。以下の場合:

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

### `v-model` への `v-for` プリミティブ値の反復 <sup>削除</sup>

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

これを見てわかるように、 `v-model` による双方向バインディングは、ここでは意味がありません。それは、関数内のローカルスコープのみの変数なので、イテレータにて `str` に別の値を設定した場合にも何もしません。

代わりに、 `v-model` が、オブジェクトのフィールドを更新できるようにするためには、 __オブジェクト__ の配列を使用する必要があります。例えば以下となります:

{% codeblock lang:html %}
<input v-for="obj in objects" v-model="obj.str">
{% endcodeblock %}

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    もしあれば、テストスイートを走らせます。
    失敗したテストについては、ルートインスタンスに渡されたプロパティはもはや動かないということをあなたに警告します。
  </p>
</div>
{% endraw %}

### `v-bind:style` においての オブジェクトおよび `!important` 構文 <sup>削除</sup>

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

### `v-el` と `v-ref` <sup>置き換え</sup>

わかりやすくするために、 `v-el` と `v-ref` は コンポーネントのインスタンスよりアクセス可能な `$refs` として、 `ref` 属性に統合されました。これは、 `v-el:my-element` は `ref="myElement"` となり、 `v-ref:my-component` もまた `ref="myComponent"` となることを意味します。通常の要素で使用する場合、 `ref` は DOM 要素となり、コンポーネント内で使用する場合、 `ref` はコンポーネントのインスタンスになります。

`v-ref` は、もはやディレクティブではありません。しかし、特別な値で、動的な定義が可能となっています。これは、 `v-for` との組み合わせで使用する場合に、特に役にたちます。例えば、以下のような場合:

``` html
<p v-for="item in items" v-bind:ref="'item' + item.id"></p>
```

以前は、 `v-el` や `v-ref` と組み合わせた `v-for` の各項目に対して、一意な名前をつけること方法はなかったため、要素やコンポーネントの配列を生成していたと思います。各項目に同じ参照が与えられることによって、現在でもその動作を実現することが可能です。

``` html
<p v-for="item in items" ref="items"></p>
```

1.x とは異なり、これらの `$refs` は、それら自身の描画に登録および更新をおこなっているため、リアクティブではありません。それらを重複して反応させる際は、変更があるたびに描画します。

一方で、 `$refs` は JavaScript によるプログラム的なアクセスとして主に利用するために設計されているため、テンプレートでそれらに依存することは推奨しません。それは、インスタンス自体に属していない状態を指すこととなるので、 Vue のデータ駆動な ViewModel の設計に違反することとなります。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>v-el</code> and <code>v-ref</code> を見つけます。
</div>
{% endraw %}

### `v-else` への `v-show` <sup>削除</sup>

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

## カスタムディレクティブ <sup>単純化</sup>

ディレクティブはその責任範囲を大幅に削減しました: ディレクティブは、今やローレベルの直接な DOM 操作を適用するためにのみ使用されます。ほとんどの場合、メインのコード再利用可能にし、抽象化したコンポーネントを使用するべきです。

顕著な違いとして、以下のようなものがあります:

- ディレクティブはもはや、インスタンスを持ちません。これは、もはや `this` 内部にディレクティブのフックがないことを意味します。その代わり、それらは引数として必要なものを全て受け取ります。もし、あなたが本当にフック間で状態を保持する必要がある場合、 `el` 上にて行うことができます。
- `acceptStatement`, `deep`, `priority` などのようなオプションは全て非推奨となりました。
- 一部のフックが異なる振るまいをおこなっており、また、新たなフックと対になっているものもあります。`twoWay` なディレクティブを置き換えるためには、[この example](#Two-Way-Filters-deprecated) を参照してください。

新しいディレクティブははるかにシンプルなので、幸いにも、より簡単に習得することができます。より多くを学ぶには、新しい [カスタムディレクティブガイド](custom-directive.html) をお読みください。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 定義済みのディレクティブを見つけます。
    ヘルパーによって検出された箇所は、ほとんどの場合、将来的にコンポーネントにリファクタリングしたくなる部分となります。
  </p>
</div>
{% endraw %}

### `.literal` ディレクティブの修飾子 <sup>削除</sup>

`.literal` 修飾子は、値として文字列リテラルを提供することによって、同じ事が容易に達成できるため、削除されました。

例えば、以下のように更新できます:

``` html
<p v-my-directive.literal="foo bar baz"></p>
```
これは、以下のようにできます:

``` html
<p v-my-directive="'foo bar baz'"></p>
```

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、ディレクティブの<code>`.literal`</code> 修飾子を見つけます。</p>
</div>
{% endraw %}

## トランジション

### `transition` 属性 <sup>置き換え</sup>

Vue のトランジション機構は大幅な変更を遂げました。`transition` 属性ではなく、 `<transition>` および `<transition-group>` ラッパー要素を使用します。より多くを学ぶためには、新しい[トランジションガイド](transitions.html)を読むことをおすすめします。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>transition</code> 属性を見つけます。</p>
</div>
{% endraw %}

### 再利用可能なトランジションへの `Vue.transition` <sup>置き換え</sup>

新しいトランジション機構の [再利用可能なトランジションへのコンポーネントの使用](../guide/transitions.html#Reusable-Transitions) によって実現することができます。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>Vue.transition</code> を見つけます。</p>
</div>
{% endraw %}

### `stagger` トランジション属性 <sup></sup>

もしあなたがリストのトランジションを遅延させたい場合、その要素の設定やデータのインデックス(もしくは同様の属性)にアクセスすることによって、そのタイミングを制御することができます。詳しくは、[こちら](transitions.html#Staggering-List-Transitions)にあるサンプルを参照してください。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>transition</code> 属性を見つけます。
    アップデートの間に、(これはダジャレですが、)新たなかつスタガリングな遷移手法へ置き換えることが可能です。
  </p>
</div>
{% endraw %}

## イベント

### `events` オプション<sup>削除</sup>

`events` オプションは非推奨になりました。代わりに、イベントハンドラは `created` フックで登録すべきです。詳細な example 向けとして[`$dispatch` と `$broadcast` のマイグレーションガイド](#dispatch-および-broadcast-非推奨) を確認してください。

### `Vue.directive('on').keyCodes` <sup>置き換え</sup>

`keyCodes` を設定するための、より新しくかつ簡潔な方法は、`Vue.config.keyCodes` を介して行うことです。例えば、以下のようなものとなります:

``` js
// v-on:keyup.f1 を有効化します。
Vue.config.keyCodes.f1 = 112
```
{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 古い <code>keyCode</code>の設定が用いられた属性見つけます。</p>
</div>
{% endraw %}

### `$dispatch` および `$broadcast` <sup>置き換え</sup>

`$dispatch` および `$broadcast` については、 [Vuex](https://github.com/vuejs/vuex) などような、よりはっきりとしたコンポーネント間の通信及び状態管理のソリューションを支持するかたちで廃止となりました。

これまでの問題として、コンポーネントツリーが肥大化した際、その動作を推論することが非常に困難となり、また、コンポーネントのツリー構造に依存する、非常に脆いイベントフローがありました。それは、単純にうまくスケールしませんし、後々に痛みを伴う変更となってはなりません。`$dispatch` および `$broadcast` に関しても、兄弟コンポーネント間の通信を解決するものではありません。

これらの方法の最も一般的な用途の 1 つは、親とその直接の子供との間の通信です。このような場合、実際に [`v-on`で子から `$emit` によって購読](components.html#カスタムイベントを使用したフォーム入力コンポーネント)できます。これにより、明示的に追加されたイベントの利便性を保つことができます。

しかしながら、遠い子孫/祖先の間で通信するとき、`$emit` はあなたを助けないでしょう。代わりに、最も簡単なアップグレードは、集中型のイベントハブを使用することです。これはコンポーネントツリー内のどこにあっても（兄弟間だとしても）、コンポーネント間で通信できるという利点があります。Vue インスタンスは event emitter インタフェースを実装しているため、実際にはこの目的で空の Vue インスタンス (`$mount` で DOM にマウントしない状態のこと)を使用できます。

例えば、このような ToDo アプリケーションがある場合:

```
Todos
├─ NewTodoInput
└─ Todo
   └─ DeleteTodoButton
```

これらを単一のイベントハブによって、コンポーネント間の通信を管理することができるようになりました:

``` js
// これは、あらゆる場合に使用されるイベントハブです。
// コンポーネントは、これを介して通信します。
var eventHub = new Vue()
```

そして、コンポーネントにて、それによって `$emit` や `$on` 、 `$off` を用いてイベントを発行させることや、新たに購読すること、そしてそれらを初期化することができます。

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
// 以下は、コンポーネントの削除前に
// イベントリスナーをクリアするための良い手法です。
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

単純なシナリオ上では、 `$dispatch` および `$boardcast` を代替品に置き換えるパターンで動かすことができますが、より複雑なケースを想定して、 [Vuex](https://github.com/vuejs/vuex) のような専門的な状態管理層を設けることをおすすめします。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>$dispatch</code> and <code>$broadcast</code> を見つけます。</p>
</div>
{% endraw %}

## フィルタ

### フィルタ外でのテキスト展開 <sup>削除</sup>

フィルタは、今やテキスト内での補完(`{% raw %}{{ }}{% endraw %}` タグ)のみで使用することができます。今までの `v-model` や `v-on` ディレクティブ上でのフィルタリングは、それ自体の利便性よりも、コードの複雑化につながることのほうが多いことに気がつきました。`v-for` 上でのリストのフィルタリングについては、それをコンポーネント上で再利用可能とするために、算出プロパティとして JavaScript 上のそのロジックを移動させるようにしても良いでしょう。

行いたい処理がプレーンな JavaScript で実現可能な場合は、基本的には同じ結果をもたらすフィルタのような特殊な構文を導入しないようにしたいです。この項で紹介する方法によって、 Vue の内蔵のディレクティブフィルタを置き換えることができます。具体的な方法は以下のとおりです:

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

この方法に対するより詳細な利点は[ここの `v-model` による example ](#v-model-の-debounce-削除)を参照してください。

#### `limitBy` フィルタの置き換え

このような記述の代わりに:

``` html
<p v-for="item in items | limitBy 10">{{ item }}</p>
```

JavaScript 組み込みの [`.slice` メソッド](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/slice#Examples)を算出プロパティへ使用します:

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

JavaScript 組み込みの [`.filter` メソッド](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/slice#Examples) を算出プロパティへ使用します:

``` html
<p v-for="user in filteredUsers">{{ user.name }}</p>
```

``` js
computed: {
  filteredUsers: function () {
    var self = this
    return self.users.filter(function (user) {
      return user.name.indexOf(self.searchQuery) !== -1
    })
  }
}
```

算出プロパティに対しては、完全なるアクセス権があるため、 JavaScript 組み込みの `.filter` は、非常に複雑なフィルタリングの管理を行うことができます。例えば、もしあなたがすべてのアクティブユーザーを見つけるために、大文字小文字を区別せず、名前と E メールアドレスの両方を調べたい場合は、以下のようになります:

``` js
var self = this
self.users.filter(function (user) {
  var searchRegex = new RegExp(self.searchQuery, 'i')
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

算出プロパティへ、[lodash の `orderBy`](https://lodash.com/docs/4.15.0#orderBy) (もしくは [`sortBy`](https://lodash.com/docs/4.15.0#sortBy))を使用します。

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

{% codeblock lang:js %}
_.orderBy(this.users, ['name', 'last_login'], ['asc', 'desc'])
{% endcodeblock %}

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 ディレクティブ内部で使用されているフィルタを見つけます。
    もし間違いがある場合、 <strong>consoleのエラー</strong>を参照してください。
  </p>
</div>
{% endraw %}

### フィルタ引数の構文 <sup>変更</sup>

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

### 組み込みテキストフィルタ <sup>削除</sup>

テキストを展開するためのフィルタは、現状はまだ利用できますが、すべてのフィルタが削除されました。それらの代わりに、（例えば日付のフォーマットには [`date-fns`](https://date-fns.org/)、通貨処理には [`accounting`](http://openexchangerates.github.io/accounting.js/) と言った形で) より専門的なライブラリの使用を推奨します。

Vue に組み込まれたテキストフィルタ群は、それぞれ以下のように置き換えることができます。これらの例には、カスタムヘルパーや関数、メソッドの他、算出プロパティなどが含まれます。

#### `json` フィルタの置き換え

Vue がうまい具合に文字列や数値、配列からオブジェクトまで、自動的にフォーマットした上で出力するようになったため、あなたがデバッグする必要はありません。
もし、あなたが JavaScript の `JSON.stringify` と全く同じ機能が必要ならば、算出プロパティにて行うことが可能です。

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

{% codeblock lang:js %}
'$' + price.toFixed(2)
{% endcodeblock %}

しかしながら、ほとんどの場合、これらは奇妙な動作をする場合があります(例えば、 0.035.toFixed(2) の丸め誤差が 0.04 として評価されるにも関わらず、 0.045 の丸め誤差が 0.04と評価されるなどです)。これらの問題を解消するためには、より確実な [通貨のフォーマット管理のライブラリ](http://openexchangerates.github.io/accounting.js/) などを使用します。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、非推奨のフィルタを見つけます。
    もし間違いがある場合、 <strong>consoleのエラー</strong>を参照してください。
  </p>
</div>
{% endraw %}

### Two-Way フィルタ <sup>置き換え</sup>

あるユーザは、`v-model` で two-way フィルタを使い、非常に小さなコードで面白い入力を作成するのを楽しんでいます。しかしながら、_間違いなく_シンプルですが、two-way フィルタは複雑さを大幅に隠すことができ、状態の更新を遅らせることで不十分な UX を奨励します。代わりに、カスタム入力を作成するための、より明示的で機能豊富な方法として、入力をラップするコンポーネントが推奨されます。

例として、two-way 通貨フィルタの移行について説明します:

<iframe src="https://codesandbox.io/embed/github/vuejs/vuejs.org/tree/master/src/v2/examples/vue-10-two-way-currency-filter?codemirror=1&hidedevtools=1&hidenavigation=1&theme=light" style="width:100%; height:300px; border:0; border-radius: 4px; overflow:hidden;" title="vue-20-template-compilation" allow="geolocation; microphone; camera; midi; vr; accelerometer; gyroscope; payment; ambient-light-sensor; encrypted-media; usb" sandbox="allow-modals allow-forms allow-popups allow-scripts allow-same-origin"></iframe>

ほとんどの場合うまく動作しますが、遅延状態の更新によって異常な動作が発生する可能性があります。例えば、それらの入力の 1 つに ` 9.999` を入力してみてください。入力のフォーカスを失うと、その値は `$ 10.00` に更新されます。計算された合計を見ると、`9.999` がデータに格納されていることがわかります。ユーザーに見える現実のバージョンは同期していません！

Vue 2.0 を使用してより堅牢なソリューションに移行するには、最初に新しい `<currency-input>` コンポーネントでこのフィルタをラップしましょう:

<iframe src="https://codesandbox.io/embed/github/vuejs/vuejs.org/tree/master/src/v2/examples/vue-10-two-way-currency-filter-v2?codemirror=1&hidedevtools=1&hidenavigation=1&theme=light" style="width:100%; height:300px; border:0; border-radius: 4px; overflow:hidden;" title="vue-20-template-compilation" allow="geolocation; microphone; camera; midi; vr; accelerometer; gyroscope; payment; ambient-light-sensor; encrypted-media; usb" sandbox="allow-modals allow-forms allow-popups allow-scripts allow-same-origin"></iframe>

これにより、フォーカスのある入力の内容を選択するなど、フィルタだけでカプセル化できなかった動作を追加できます。次のステップは、フィルタからビジネスロジックを抽出することです。以下では、すべてを外部[`currencyValidator` オブジェクト](https://gist.github.com/chrisvfritz/5f0a639590d6e648933416f90ba7ae4e) にします:

<iframe src="https://codesandbox.io/embed/github/vuejs/vuejs.org/tree/master/src/v2/examples/vue-10-two-way-currency-filter-v3?codemirror=1&hidedevtools=1&hidenavigation=1&theme=light" style="width:100%; height:300px; border:0; border-radius: 4px; overflow:hidden;" title="vue-20-template-compilation" allow="geolocation; microphone; camera; midi; vr; accelerometer; gyroscope; payment; ambient-light-sensor; encrypted-media; usb" sandbox="allow-modals allow-forms allow-popups allow-scripts allow-same-origin"></iframe>

このようにモジュール性が向上すると、Vue 2.0 への移行が容易になるだけでなく、通貨の解析と書式設定も可能になります:

- Vue コードから単体でテストされたユニット
- API エンドポイントへのペイロードの検証など、アプリケーションの他の部分で使用される

このバリデータを抽出することで、より堅牢なソリューションとしてより快適に構築できました。状態の不具合は解消されており、ユーザーが間違った入力を実際に行うことは不可能です。これは、ブラウザのネイティブ番号の入力と同様です。

ただし、フィルタと Vue 1.0 の一般的な制限はありますので、Vue 2.0 へのアップグレードを完了しましょう:

<iframe src="https://codesandbox.io/embed/github/vuejs/vuejs.org/tree/master/src/v2/examples/vue-20-two-way-currency-filter?codemirror=1&hidedevtools=1&hidenavigation=1&theme=light" style="width:100%; height:300px; border:0; border-radius: 4px; overflow:hidden;" title="vue-20-template-compilation" allow="geolocation; microphone; camera; midi; vr; accelerometer; gyroscope; payment; ambient-light-sensor; encrypted-media; usb" sandbox="allow-modals allow-forms allow-popups allow-scripts allow-same-origin"></iframe>

次のことに気付くかもしれません:

- two-way フィルタの隠された動作の代わりに、ライフサイクルフックと DOM イベントを使用して、入力のあらゆる側面がより明示的になります。
- 私たちはカスタム入力に `v-model` を直接使うことができます。これは通常の入力と一貫性があるだけでなく、私たちのコンポーネントが Vuex に優しいことを意味します。
- 返される値を必要とするフィルタオプションを使用しなくなったため、実際には非同期で通貨作業を行うことができます。つまり、通貨を使用しなければならないアプリがたくさんある場合、このロジックを簡単に共有してマイクロサービスにすることができます。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、ディレクティブにおいて <code>v-model</code> のように使用されているフィルタの example を見つけます。
    もし間違いがある場合、 <strong>consoleのエラー</strong>を参照してください。
  </p>
</div>
{% endraw %}

## スロット

### 重複したスロット <sup>削除</sup>

もはや、同じテンプレート内に、同名のスロットを持つことはサポートされません。スロットが描画されるとき、そのスロットは「使い果たされ」、同じレンダリングツリーの中で再度描画することはできません。もし、複数の場所で同一の内容を描画する必要がある場合は、プロパティとしてそのコンテンツを渡します。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>アップグレード後に end-to-end のテストスイートや、それに準ずるアプリケーションを実行し、 <code>v-model</code> においての重複スロットに対してのコンソールの警告を探します。</p>
</div>
{% endraw %}

### `slot` 属性のスタイリング <sup>削除</sup>

名前付きスロットを経由して挿入されたコンテンツは、もはや `slot` 属性を保持しません。

スタイル属性を付与したい場合は、なんらかのラップした要素に適用するか、複雑なユースケースの場合は、 [`render` 関数](render-function.html) を用いて、プログラムにてコンテンツを変更してください。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 名前付き slot を対象としているCSSのセレクタ(例えば、 <code>[slot="my-slot-name"]</code> など)を見つけます。</p>
</div>
{% endraw %}

## 特別な属性

### `keep-alive` 属性 <sup>置き換え</sup>

`keep-alive` はもはや、特別な属性ではなく、 むしろ `<transition>` と同様に、コンポーネントのラッパーです。例えば以下の場合:

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

### 属性内での展開 <sup>削除</sup>

属性内での展開は、もはや有効ではありません。例えば、以下の場合:

``` html
<button class="btn btn-{{ size }}"></button>
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
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、属性内で使用されている展開を見つけます。</p>
</div>
{% endraw %}

### HTML の展開 <sup>削除</sup>

新たな [`v-html` ディレクティブ](../api/#v-html) を支持することによって、 HTML の展開(`{% raw %}{{{ foo }}}{% endraw %}`) は非推奨となりました。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 HTML の展開が行われているコードを検索します。</p>
</div>
{% endraw %}

### ワンタイムバインディング <sup>置き換え</sup>

新たな [`v-once` ディレクティブ](../api/#v-once) を支持することによって、ワンタイムバインディング  (`{% raw %}{{* foo }}{% endraw %}`) は非推奨となりました。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、ワンタイムバインディングを見つけます。</p>
</div>
{% endraw %}

## リアクティブ

### `vm.$watch` <sup>変更</sup>

`vm.$watch` を経由して作成されたウォッチャーは、関連するコンポーネントの描画の前に発火します。これは、不要な更新を避けることと、描画前にコンポーネントの状態を更新する機会を与えてくれます。例えば、コンポーネントのプロパティや、それらの値の変更をウォッチすることができます。

これまで、 `vm.$watch` を利用することでコンポーネントのアップデート後に DOM に対して何らかの操作をしていた場合、それを `updated` ライフサイクルフックに置き換えることができます。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    もしあれば、 end-to-end のテストを走らせます。
    失敗したテストについては、ウォッチャーが古い動作であることを警告します。
  </p>
</div>
{% endraw %}

### `vm.$set` <sup>変更</sup>

`vm.$set` は非推奨となっており、 [`Vue.set`](../api/#Vue-delete) という名称になっています。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、非推奨の用法を見つけます。</p>
</div>
{% endraw %}

### `vm.$delete` <sup>変更</sup>

`vm.$delete` は非推奨となっており、 [`Vue.delete`](../api/#Vue-delete) という名称になっています。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、非推奨の用法を見つけます。</p>
</div>
{% endraw %}

### `Array.prototype.$set`  <sup>削除</sup>

代わりに、 Vue.set を使用します。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、配列に対しての <code>.$set</code> を見つけます。
    そうすることで、メソッドが見つからないエラーがコンソールに出力されているので確認してください。
  </p>
</div>
{% endraw %}

### `Array.prototype.$remove` <sup>削除</sup>

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
    そうすることで、メソッドが見つからないエラーがコンソールに出力されているので確認してください。
  </p>
</div>
{% endraw %}

### Vue インスタンス上での `Vue.set` および `Vue.delete` <sup>削除</sup>

Vue.set および Vue.delete はもはや、 Vue インスタンス上で動作することはできません。データオプション内で、全てのトップレベルのリアクティブなプロパティが必須となりました。もし、 Vue のインスタンス上で `$data` を削除したい場合、単に null を代入します。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 Vue インスタンス上で使われている  <code>Vue.set</code> もしくは <code>Vue.delete</code> を見つけます。
    もし間違いがある場合、 <strong>consoleの警告</strong>を参照してください。
  </p>
</div>
{% endraw %}

### `vm.$data` の置き換え <sup>削除</sup>

現在では、コンポーネントのインスタンスのルートにある `$data` を書き換えることは禁止されています。これは、リアクティブなシステムの上での極端なケースを防ぎ、(特に型チェックシステム上での)コンポーネントの状態をより予測しやすくします。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>vm.$data</code> が上書きされている箇所を見つけます。
    もし間違いがある場合、 <strong>consoleの警告</strong>を参照してください。
  </p>
</div>
{% endraw %}

### `vm.$get` <sup>削除</sup>

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

### `vm.$appendTo` <sup>削除</sup>

ネイティブの DOM API を使用します:

{% codeblock lang:js %}
myElement.appendChild(vm.$el)
{% endcodeblock %}

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>vm.$appendTo</code> を見つけます。
    もし間違いがある場合、 <strong>consoleのエラー</strong>を参照してください。
  </p>
</div>
{% endraw %}

### `vm.$before` <sup>削除</sup>

ネイティブの DOM API を使用します:

{% codeblock lang:js %}
myElement.parentNode.insertBefore(vm.$el, myElement)
{% endcodeblock %}

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>vm.$before</code> を見つけます。
    もし間違いがある場合、 <strong>consoleのエラー</strong>を参照してください。
  </p>
</div>
{% endraw %}

### `vm.$after` <sup>削除</sup>

ネイティブの DOM API を使用します:

{% codeblock lang:js %}
myElement.parentNode.insertBefore(vm.$el, myElement.nextSibling)
{% endcodeblock %}

もし `myElement` が最後の要素の場合は、以下のように対処します:

{% codeblock lang:js %}
myElement.parentNode.appendChild(vm.$el)
{% endcodeblock %}

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>vm.$after</code> を見つけます。
    もし間違いがある場合、 <strong>consoleのエラー</strong>を参照してください。
  </p>
</div>
{% endraw %}

### `vm.$remove` <sup>削除</sup>

ネイティブの DOM API を使用します:

{% codeblock lang:js %}
vm.$el.remove()
{% endcodeblock %}

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

### `vm.$eval` <sup>削除</sup>

この機能が実際に使用されることはありません。もしあなたがこの機能を利用する機会があり、それを回避する方法が思いつかない場合は、[フォーラム](https://forum.vuejs.org/)にてアイデアを募ってください。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>vm.$eval</code> を見つけます。
    もし間違いがある場合、 <strong>consoleのエラー</strong>を参照してください。
  </p>
</div>
{% endraw %}

### `vm.$interpolate` <sup>削除</sup>

この機能が実際に使用されることはありません。
もしあなたがこの機能を利用する機会があり、それを回避する方法が思いつかない場合は、[フォーラム](https://forum.vuejs.org/)にてアイデアを募ってください。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>
    あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>vm.$interpolate</code> を見つけます。
    もし間違いがある場合、 <strong>consoleのエラー</strong>を参照してください。
  </p>
</div>
{% endraw %}

### `vm.$log` <sup>削除</sup>

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

### `replace: false` <sup>削除</sup>

コンポーネントは常に要素に紐付いて置き換えられます。 `replace:false` の挙動を再現するには、コンポーネントのルートを置き換えたい要素で囲みます。例えば、このような場合は:

``` js
new Vue({
  el: '#app',
  template: '<div id="app"> ... </div>'
})
```

もしくは render 関数で行います:

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

### `Vue.config.debug` <sup>削除</sup>

警告に対して、必要に応じてデフォルトでスタックトレースが付随しています。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>Vue.config.debug</code> を見つけます。</p>
</div>
{% endraw %}

### `Vue.config.async` <sup>削除</sup>

非同期処理は現在では、描画性能のために必要とされます。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>Vue.config.async</code> を見つけます。</p>
</div>
{% endraw %}

### `Vue.config.delimiters` <sup>置き換え</sup>

[コンポーネントレベルのオプション](../api/#delimiters) として作り直されました。これは、サードパーティのコンポーネントを壊すことなく、アプリケーション内で代替のデリミタを使用することができます。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>Vue.config.delimiters</code> を見つけます。</p>
</div>
{% endraw %}

### `Vue.config.unsafeDelimiters` <sup>削除</sup>

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

### `Vue.extend` への `el` <sup>削除</sup>

el オプションは、もはや `Vue.extend` で使用することはできません。これは、インスタンスの作成オプションとしてのみ有効です。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>アップグレード後に end-to-end のテストスイートやアプリケーションを実行し、 <code>Vue.extend</code> への <code>el</code> に関するコンソールの警告を探します。</p>
</div>
{% endraw %}

### `Vue.elementDirective` <sup>削除</sup>

代わりに components を使用します。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>Vue.elementDirective</code> を見つけます。</p>
</div>
{% endraw %}

### `Vue.partial` <sup>削除</sup>

パーシャルは、プロパティを使用して、コンポーネント間のより明示的なデータフローを優先するため非推奨になりました。性能が重要な領域で部分的なものを使用している場合を除いて、単に[通常のコンポーネント](components.html)を代わりに使用することを推奨します。部分的に `name` を動的に束縛する場合は、[動的コンポーネント](components.html#動的コンポーネント)を使用できます。

アプリケーションの性能に重大な影響を及ぼす部分でパーシャルを使用する場合は、[関数型コンポーネント](render-function.html#関数型コンポーネント)にアップグレードする必要があります。それらはプレーンな JS / JSX ファイル (`.vue` ファイルではなく)になければならず、パーシャルと同様に、ステートレスでインスタンスレスです。これにより描画が非常に高速になります。

パーシャル的なに関数型コンポーネントのメリットは、JavaScript のフルパワーにアクセスできるようになるため、より動的なものにできることです。しかし、この力にはコストがかかります。以前に描画関数を使ったコンポーネントフレームワークを使ったことがない人は、学習に少し時間がかかるかもしれません。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>あなたのコード上で<a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a>を実行し、 <code>Vue.partial</code> を見つけます。</p>
</div>
{% endraw %}
