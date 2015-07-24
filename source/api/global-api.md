title: グローバル API
type: api
order: 5
---

### Vue.config

`Vue.config` は Vue のグローバル設定を含んでいるオブジェクトです。以下は、デフォルト値で利用可能な設定の全てのリストです:

``` js
{
  // デバッグモードを有効するかどうか。以下詳細を参照
  debug: true,
  // 厳格モード(Strict Mode)を有効にするかどうか。以下詳細を参照
  strict: false,
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

`Vue.config.debug` が true に設定されるとき、Vue は:

1. 全て警告としてスタックトレースを出力します。
2. 全てのアンカーノードは DOM でコメントノードとして表示します。これはレンダリングされた結果の構造を詳しく調べるために容易になります。

<p class="tip">デバッグモードは小さくなった production ビルドでは利用できません。</p>

**厳格モード(Strict Mode)**

デフォルトで、Vue のコンポーネントはクラスの継承チェーン(`Vue.extend`を介して)と view 階層のそれらコンポーネントの親、**両方**から全てのアセットを継承します。厳格モードでは、コンポーネントは**クラスの継承チェーンからだけ**アセットを継承できますが、**view 階層のそれらコンポーネントの親からはできません**。厳格モードを有効にするとき、アセットはグローバルに登録されるかまたは、それらを必要するコンポーネントに明示的に依存する必要があります。厳格モードを強制すると、これは大規模なプロジェクトでコンポーネントのカプセル化と再利用がより良い可能性につながります。

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
``` html
<div id="mount-point"></div>
```

``` js
// 再利用可能なコンストラクタを作成
var Profile = Vue.extend({
  el: function () {
    return document.createElement('p')
  },
  template: '<p>{{firstName}} {{lastName}} aka {{alias}}</p>'
})
// Profile のインスタンスの作成
var profile = new Profile({
  data: {
    firstName : 'Walter',
    lastName  : 'White',
    alias     : 'Heisenberg'
  }  
})
// 要素上にマウント
profile.$mount('#mount-point')
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

グローバルトランジションに登録または取得します。さらに詳しくガイド向けの [トランジションシステム(JavaScript だけによるトランジション)](/guide/transitions.html#JavaScript_だけによるトランジション) を参照してください。

### Vue.partial( id, [partial] )

- **id** `String`
- **partial** `String` *任意*

グローバルテンプレート partial 文字列に登録または取得します。さらに詳しくは [partial](/api/elements.html#partial) を参照してください。

### Vue.use( plugin, [args...] )

- **plugin** `Object` または `Function`
- **args...** *任意*

Vue.js は plugin をマウントします。もし、plugin がオブジェクトなら、それは `install` メソッドを実装していなければなりません。もし、それ自身が関数ならば、それは install メソッドとして扱われます。install メソッドは、Vue を引数として呼び出されます。さらに詳しくは、[プラグイン(プラグインによる拡張)](/guide/extending.html#プラグインによる拡張)を参照してください。

### Vue.util

多数のユーティリティメソッドを含む内部 `util` モジュールを公開します。これは高度なプラグイン/ディレクティブ作成向けに目的としており、そのため、何が可能かどうか確認するためにソースコードを見る必要があります。
