title: グローバル API
type: api
order: 5
---

### Vue.config

`Vue.config` は Vue のグローバル設定を含んでいるオブジェクトです。以下は、デフォルト値で利用可能な設定の全てのリストです:

``` js
{
  // 警告するためのスタックトレースを表示するかどうか
  debug: true,
  // directive 向けの属性(attribute)プレフィックス
  prefix: 'v-',
  // HTML 展開に対応するデミリタ、最も外側に特別な1文字を追加
  delimiters: ['{{', '}}'],
  // 警告を抑制するかどうか
  silent: false,
  // mustache バインディングを展開するかどうか
  interpolate: true,
  // 非同期更新(directive & watcher 向け)するかどうか
  async: true,
  // 監視された配列プロトタイプチェーンを変更することを許可するかどうか
  proto: true
}
```

以下の例のように、それらを直接変更できます:

``` js
Vue.config.debug = true // デバッギングモードをオンにする
```

**デバッグモード**

`Vue.config.debug` が true に設定されるとき、Vue は自動的に同期モードを使い、そして警告があるときは `debugger` ステートメント を投げます。これはブラウザの開発ツールで、完全なスタックトレースを詳しく調べることが可能になります。

<p class="tip">デバッグモードは小さくなった production ビルドでは利用できません。</p>

**デリミタの変更**

デリミタはテキスト展開に対して設定されるとき、HTML 展開に対するデリミタは両側の最も外側のシンボルが追加されることによって生成されます:

``` js
Vue.config.delimiters = ['(%', '%)']
// タグは現在テキスト展開に対して (% %)
// そして HTML展開に対して ((% %))
```

### Vue.extend( options )

- **options** `Object`

Vue コンストラクタベースの"サブクラス"を作成します。[コンポーネントオプション](/api/options.html)の全てはここで使うことができます。ここでの注意すべき特別なケースは、`el` と `data` で、このケースでは関数にしなければなりません。

内部的に、`Vue.extend()` は component をインスタンス化する前に、全ての component オプション上で呼び出されます。さらに詳しくは component に関しては、[コンポーネントシステム](/guide/components.html) を参照してください。

**例**

``` js
var Profile = Vue.extend({
  el: function () {
    return document.createElement('p')
  },
  template: '{{firstName}} {{lastName}} aka {{alias}}'
})
var profile = new Profile({
  data: {
    firstName : 'Walter',
    lastName  : 'White',
    alias     : 'Heisenberg'
  }  
})
profile.$appendTo('body')
```

結果は以下のようになります:

``` html
<p>Walter White aka Heisenberg</p>
```

### Vue.nextTick( callback )

- **callback** `Function`

callback を延期し、DOM の更新サイクル後に実行されます。DOM の更新を待つ待ち受けるためにいくつかのデータを更新した直後に使用してください。さらに詳しくは[非同期更新の理解](/guide/directives.html#非同期更新の理解)を参照してください。

### Vue.directive( id, [definition] )

- **id** `String`
- **definition** `Function` または `Object` *任意*

グローバルカスタムディレクティブに登録または取得します。さらに詳しくは[カスタムディレクティブ](/guide/custom-directive.html)を参照してください。

### Vue.elementDirective( id, [definition] )

- **id** `String`
- **definition** `Function` or `Object` *任意*

グローバルエレメントディレクティブに登録または取得します。さらに詳しくは[エレメントディレクティブ](/guide/custom-directive.html#エレメントディレクティブ)を参照してください。

### Vue.filter( id, [definition] )

- **id** `String`
- **definition** `Function` *任意*

グローバルカスタムフィルタに登録または取得します。さらに詳しくは[カスタムフィルタ](/guide/custom-filter.html)を参照してください。

### Vue.component( id, [definition] )

- **id** `String`
- **definition** `Function` コンストラクタ または `Object` *任意*

グローバルコンポーネントに登録または取得します。さらに詳しくは[コンポーネントシステム](/guide/components.html)を参照してください。

### Vue.transition( id, [definition] )

- **id** `String`
- **definition** `Object` *任意*

グローバルトランジションに登録または取得します。さらに詳しくガイド向けの [トランジション(JavaScript 関数)](/guide/transitions.html#JavaScript_関数) を参照してください。

### Vue.use( plugin, [args...] )

- **plugin** `Object` または `Function`
- **args...** *任意*

Vue.js は plugin をマウントします。もし、plugin がオブジェクトなら、それは `install` メソッドを実装していなければなりません。もし、それ自身が関数ならば、それは install メソッドとして扱われます。install メソッドは、Vue を引数として呼び出されます。さらに詳しくは、[プラグイン(プラグインによる拡張)](/guide/extending.html#プラグインによる拡張)を参照してください。

### Vue.util

多数のユーティリティメソッドを含む内部 `util` モジュールを公開します。これは高度なプラグイン/ディレクティブ作成向けに目的としており、そのため、何が可能かどうか確認するためにソースコードを見る必要があります。
