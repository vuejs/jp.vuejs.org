title: コツ & ベストプラクティス
type: guide
order: 15
is_new: true
---

## データの初期化

Vue のデータ監視モデルは決定論的なデータモデルを好みます。それは `data` オプションで率直にリアクティブにする必要があるすべてのデータプロパティを初期化することをお勧めします。例えば、次のテンプレートが与えられると:

``` html
<div id="demo">
  <p v-class="green: validation.valid">{{message}}</p>
  <input v-model="message">
</div>
```

それは空オブジェクトの代わりに、データをこのように初期化することをお勧めします:

``` js
new Vue({
  el: '#demo',
  data: {
    message: '',
    validation: {
      valid: false
    }
  }
})
```

その理由は、 Vue は再帰的にデータオブジェクトを歩き見まわることによってデータ変更を監視していることと、`Object.defineProperty` を使用して既存のプロパティをリアクティブな getter と setter に変換するからです。インスタンスが作成される時にプロパティが存在しない場合、 Vue はそれを追跡することができません。

しかし、データ内のすべての単一のネストされたプロパティを設定する必要はありません。空オブジェクトとしてフィールドを初期化することは OK で、そして、それ以降のネストされた構造を持つ新しいオブジェクトに設定し、Vue はこの新しいオブジェクトのネストされたプロパティを歩き、それらを監視することができるようになるためだからです。

## プロパティの追加と削除

上述したように、Vue は `Object.defineProperty` でプロパティを変換してデータを監視します。しかしながら、ECMAScript 5 では、新しいプロパティがオブジェクトに追加された時、またはオブジェクトからプロパティが削除された時、それらを検出する方法はありません。この制約に対処するために、オブジェクトは3つのメソッドが拡張されて監視されます:

- `obj.$add(key, value)`
- `obj.$set(key, value)`
- `obj.$delete(key)`

これらのメソッドは、望まれた DOM 更新をトリガしながら、監視されたオブジェクトからプロパティを追加/削除するために使用できます。`$add` と `$set` の差異は、`$add` はもしキーが既にオブジェクトに存在する場合は早期に返すので、そういうわけでまさに `obj.$add(key)` を呼び出すことは `undefined` で既にある値を上書きしません。

関連注意事項は、インデックス(例えば `arr[1] = value`)を設定することによって、直接バウンドされたデータ配列を変更しますが、Vue は変更をピックアップできません。また、これらの変更について Vue.js に通知するために 拡張メソッドを使用できます。監視された配列は2つのメソッドで拡張されています:

- `arr.$set(index, value)`
- `arr.$remove(index | value)`

Vue のコンポーネントインスタンスもインスタンスメソッドで対応します:

- `vm.$get(path)`
- `vm.$set(path, value)`
- `vm.$add(key, value)`
- `vm.$delete(key, value)`

`vm.$get` と `vm.$set` 両方は path を受け入れることに注意してください。

<p class="tip">これらのメソッドの存在にも関わらず、必ず必要な時に監視されたフィールドを追加するだけにしてください。あなたのコンポーネント状態のために `data` オプションをスキーマとしてみなすと便利です。明示的にコンポーネント定義にありうる現行のプロパティをリストにすることは、後でそれを見た時にコンポーネントが含まれていてもよいか理解し易いです。</p>

## 非同期更新の理解

Vue はデフォルトで非同期的に view の更新を行うことを知っておくことは重要です。データ変更が監視されるたびに、Vue はキューをオープンし同じイベントループで生じた全てのデータ変更をバッファします。もし同じウォッチャが複数回起動される場合、それは一度だけキューに押し込まれます。内部的には、Vue はもし非同期キューイング向けに `MutationObserver` が利用可能ならそれを使い、そうでなければ `setTimeout(fn, 0)` にフォールバックします。

例として、`vm.someData = 'new value'` をセットした時、DOM はすぐには更新しません。 キューがフラッシュされた時、次の "tick" で更新します。 この振舞いは、更新した DOM の状態に依存する何かをしたい時、注意が必要です。Vue.js は一般的に"データ駆動"的な方法で考えることを開発者に奨励していますが、時々、いつも使用してきた便利な jQuery プラグインをまさに使用したい時は、DOM を直接触れないようにしてください。Vue.js でデータの変更後に、DOM の更新が完了するまでに待つためには、データが変更された直後に `Vue.nexttick(callback)` を使用することができます。コールバックが呼ばれた時、DOM は更新されているでしょう。例えば:

``` html
<div id="example">{{msg}}</div>
```

``` js
var vm = new Vue({
  el: '#example',
  data: {
    msg: '123'
  }
})
vm.msg = 'new message' // 変更データ
vm.$el.textContent === 'new message' // false
Vue.nextTick(function () {
  vm.$el.textContent === 'new message' // true
})
```

特に便利な内部コンポーネントのインスタンスメソッド `vm.$nextTick()` もあります。なぜなら、それはグローバルな `Vue` とそのコールバックの `this` コンテキストは自動的に現在の Vue インスタンスにバウンドされるからです:

``` js
Vue.component('example', {
  template: '{{msg}}',
  data: function () {
    return {
      msg: 'not updated'
    }
  },
  methods: {
    updateMessage: function () {
      this.msg = 'updated'
      console.log(this.$el.textContent) // => '更新されない'
      this.$nextTick(function () {
        console.log(this.$el.textContent) // => '更新される'
      })
    }
  }
})
```

## コンポーネントのスコープ

全ての Vue.js コンポーネントはそれ独自のスコープを持つ個々の Vue インスタンスです。それはコンポーネントを使用する時にスコープがどのように機能するか理解することが大事です。大雑把には:

> もし何かが親テンプレートに表示されている場合は、それは親スコープでコンパイルされます; もし子テンプレートに表示されている場合は、それ子スコープでコンパイルされます。

よくある間違いは、親テンプレート内の子プロパティ/メソッドにディレクティブをバインドしようとします:

``` html
<div id="demo">
  <!-- 動作しない -->
  <child-component v-on="click: childMethod"></child-component>
</div>
```

もし root ノードのコンポーネント上で子スコープのディレクティブをバインドする必要がある場合は、`replace: true` オプションを使用すべきで、そして子テンプレートに root ノードを含むべきです:

``` js
Vue.component('child-component', {
  // コンテナノードを置き換えるコンポーネントテンプレートを作る
  replace: true,
  // 正しいスコープなため、これは動作する
  template: '<div v-on="click: childMethod">Child</div>',
  methods: {
    childMethod: function () {
      console.log('child method invoked!')
    }
  }
})
```

`v-repeat` を持ったコンポーネントを使用している時、このパターンは `$index` にも適用されることに注意してください。

同様に、コンポーネントコンテナ内部の HTML コンテンツは、"transclusion content" と見なされます。子テンプレートは、少なくとも1つの `<content></content>` アウトレットを含んでいない限り、それらはどこにも挿入されません。挿入されたコンテンツは、親スコープでコンパイルされています:

``` html
<div>
  <child-component>
    <!-- 親スコープでコンパイル -->
    <p>{{msg}}</p>
  </child-component>
</div>
```

子テンプレートとして子スコープでコンテンツをコンパイルしたいことを示すために、`inline-template` 属性を使用しています:

``` html
<div>
  <child-component inline-template>
    <!-- 子スコープでコンパイル-->
    <p>{{msg}}</p>
  </child-component>
</div>
```

詳細は[コンテンツ挿入](/guide/components.html#コンテンツ挿入) を参照してください。

## インスタンス間の通信

Vue で親子間の通信の一般的なパターンは、`props` を使用して、子にコールバックとして親メソッドを渡しています。これは JavaScript 実装詳細を分離するのを維持しながら、(構成が起こる)テンプレート内部の未定義な通信を許可します:

``` html
<div id="demo">
  <p>Child says: {{msg}}</p>
  <child-component send-message="{{onChildMsg}}"></child-component>
</div>
```

``` js
new Vue({
  el: '#demo',
  data: {
    msg: ''
  },
  methods: {
    onChildMsg: function(msg) {
      this.msg = msg
      return 'Got it!'
    }
  },
  components: {
    'child-component': {
      props: [
        // コールバック prop が実際に関数であることを
        // 確認するために prop 検証を使用できる
        {
          name: 'send-message',
          type: Function,
          required: true
        }
      ],
      // props は自動で camelized されるハイフンを持っている
      template:
        '<button v-on="click:onClick">Say Yeah!</button>' +
        '<p>Parent responds: {{response}}</p>',
      // コンポーネント `data` オプションは関数を必要する
      data: function () {
        return {
          response: ''
        }
      },
      methods: {
        onClick: function () {
          this.response = this.sendMessage('Yeah!')
        }
      }
    }
  }
})
```

**結果:**

<div id="demo"><p>Child says: {&#123;msg&#125;}</p><child-component send-message="{&#123;onChildMsg&#125;}"></child-component></div>

<script>
new Vue({
  el: '#demo',
  data: {
    msg: ''
  },
  methods: {
    onChildMsg: function(msg) {
      this.msg = msg
      return 'Got it!'
    }
  },
  components: {
    'child-component': {
      props: [
        {
          name: 'send-message',
          type: Function,
          required: true
        }
      ],
      data: function () {
        return {
          fromParent: ''
        }
      },
      template:
        '<button v-on="click:onClick">Say Yeah!</button>' +
        '<p>Parent responds: <span v-text="fromParent"></span></p>',
      methods: {
        onClick: function () {
          this.fromParent = this.sendMessage('Yeah!')
        }
      }
    }
  }
})
</script>

複数のネストされたコンポーネント間で通信する必要がある時、[イベント](/api/instance-methods.html#イベント)を使用できます。それに加えてまた、Vue で大規模なアプリケーションを要検討するために、[Flux](https://facebook.github.io/flux/docs/overview.html) のようなアーキテクチャを実装することがかなり実現可能です。

## Props の可用性

もし、`created` フックでコンポーネントの props にアクセスしようとうした場合、`undefined` としてそれらを見つけるでしょう。これはインスタンスに対して全ての DOM のコンパイルが発生する前に `created` フックが呼ばれてしまうためで、従ってまだ Props が処理されていないからです。Props テンプレートのコンパイル**後**に親の値で初期化されます。同様に two-way バウンドされた props はコンパイル後、親の変更だけトリガできます。

## デフォルトオプションの変更

グローバルな `Vue.options` オブジェクトに設定することにより、オプションのデフォルト値を変更することが可能です。例えば、Vue インスタンスの`replace: true` の振舞いを与えるために `Vue.options.replace = true` を設定できます。この機能は慎重に使ってください。これは全てのインスタンスの動作に影響を与えるため、新しいプロジェクトを開始している場合にのみ、使用してください。

次: [FAQ](/guide/faq.html)
