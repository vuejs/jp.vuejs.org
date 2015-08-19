title: はじめに
type: guide
order: 2
---

## 序論

Vue.js はインタラクティブな Web インターフェイスを作るためのライブラリです。

技術的に、Vue.js は MVVM パターンの [ViewModel](#ViewModel) レイヤに注目しています。それは two way (双方向)バインディングによって [View](#View) と [Model](#Model) を接続します。実際の DOM 操作と出力の形式は[ディレクティブ](#ディレクティブ)と[フィルタ](#フィルタ)によって抽象化されています。

Vue.js の哲学的なゴールは、可能な限り簡単な API を通じて、反応性の良いデータバインディングの利点と構成可能な View のコンポーネントを提供することです。Vue.js は万能なフレームワークではありません。 Vue.js は単純かつ自由自在な View レイヤになるようにデザインされています。Vue.js 単体でラピッドプロトタイピングができます。特別なフロントエンドスタック用のライブラリ達と一緒に使ったり組み合わせたりもできます。Vue.js は Firebase のようなバックエンドがないサービスとも相性が良いです。

Vue.js の API は [AngularJS]、[KnockoutJS]、[Ractive.js]、 [Rivets.js]に強く影響を受けています。それらと似てはいますが、単純さと機能性のちょうど良いスィートスポットを見つけることによって、Vue.js はそれらのライブラリに対して価値ある代変手段になりうると私は信じています。

その他のライブラリの表現に既に慣れているかもしれませんが、それらの表現の記法が Vue.js のコンテキストにおいて意味するところとは違っているかもしれませんので、以下に示すコンセプトの全体像に目を通してみてください。

## コンセプト概要

![MVVM](/images/mvvm.png)

### ViewModel

Model と View を同期するオブジェクトです。 Vue.js において, 全ての Vue インスタンスは ViewModel です。 それらは `Vue` コンストラクタかそのサブクラスでインスタンス化されます:

```js
var vm = new Vue({ /* options */ })
```

これは Vue.js をつかって開発するときに初めて出会うオブジェクトです。詳細は [Vue コンストラクタ](/api/) を参照してください。

### View

Vue インスタンスによって管理される実際の DOM です。

```js
vm.$el // The View
```

Vue.js は DOM ベースのテンプレーティングを使います。各々の Vue インスタンスは対応する DOM 要素と関連づいています。Vue インスタンスが作られると、必要なデータバインディングを設定している間、Vue インスタンスはその親要素の全ての子ノードを再帰的に巡回します。View はコンパイルされると、データの変更に対してリアクティブになります。

Vue.js を使っているときに、あなた自身で DOM に触れることはカスタムディレクティブ(後述)を除いてほとんどありません。 View の更新はデータが変わったときに自動的に行われます。これらの View の更新は、textNode に至る精度を持った高い粒度で行われます。これらは高性能化のために、バッチ化されて非同期実行されています。

### Model

若干修正されたプレーンな JavaScript オブジェクトです。

```js
vm.$data // The Model
```

Vue.js において、Model は単純にプレーンな JavaScript オブジェクトか**データオブジェクト**です。一度、オブジェクトが Vue インスタンス内部でデータとして利用されると、それは**リアクティブ**になります。それらのプロパティと、それらが変更されるかを監視している Vue インスタンスを操作できます。Vue.js はデータオブジェクトのプロパティを ES5 getter/setters に変換することによって、透明性のある反応を実現します。 ダーティーチェックは必要ありませんし、View を更新するために、明示的なシグナルを Vue に送る必要もありません。 データが変更されたときはいつでも、次のフレームで View は更新されます。

Vue インスタンスは、それらが監視しているデータオブジェクトの全てのプロパティをプロキシしています。 そのため、一度オブジェクト `{ a: 1 }` が監視されれば、 `vm.$data.a` と`vm.a` の両方が同じ値を返します。また、`vm.a = 2` に設定すると `vm.$data` が変わります.

データオブジェクトは適当な位置で変化します。そのため、参照によってそれらを変更することは、`vm.$data` を変更することと同じ効果を持っています. この事が、複数の Vue インスタンスがデータの同じ部分を監視することを可能にしています。より広い応用としては、 Vue インスタンスは純粋な view として使われ、そして、より分離したストアレイヤにデータ操作ロジックを外面化します。

ここでの問題は、一度監視が始まったら、Vue.js はプロパティの新規追加と削除を検出できないことです。
この問題を避けるために、監視されたオブジェクトは `$add` 、`$set` そして `$delete` メソッドで追加削除されます。

以下は Vue.js でどのようにリアクティブな更新が実装されているかの、高レベルな概要です:

![データ監視](/images/data.png)

### ディレクティブ

Vue.js が DOM 要素についての何かをすることを伝えているプレフィックスのついた HTML 属性です。

```html
<div v-text="message"></div>
```

ここでは div 要素は値が `message` でディレクティブ `v-text` を持っています。 これは Vue.js が、div の textContent が Vue インスタンスの `message` プロパティと同期していることを、保っていることを伝えています。

ディレクティブは任意の DOM 操作をカプセル化できます。例えば、`v-attr` は要素の属性を操作し、`v-repeat` は配列に基づいて要素をクローンし、 `v-on` はイベントリスナを随行します。これらは後にまとめます。

### Mustache バインディング

テキストと属性の両方において mustache なスタイルのバインディングを使うこともできます。それらは内部で、`v-text` ディレクティブ と `v-attr` ディレクティブに翻訳されます。例えば:

```html
<div id="person-{{id}}">Hello {{name}}!</div>
```

この書き方は便利ですが、いくつか注意しなければならないことがあります:

<p class="tip"> `<image>` 要素の `src` 属性は、値が設定されたときに HTTP リクエストを作成します。そのため、テンプレートが初めに解析されたときに、404 の結果が返ってきます. この場合は、`v-attr` を使うのが良いです。</p>

<p class="tip">Internet Explorer (IE) は、HTML を解析しているときに、`style` 属性の無効なインラインを削除します。 そのため IE をサポートしたい場合、 インライン CSS をバインディングするときにはいつも `v-style` を使ってください。</p>

エスケープされていない HTML に対して3重の mustache を使うことができ、それは内部で `v-html` に翻訳されます:

```html
{{{ safeHTMLString }}}
```

しかしながら、これは潜在的な XSS 攻撃の窓を開けてしまいます。それゆえ、データソースのセキュリティが絶対に確かなときか、信頼できない HTML を削除するカスタムフィルタを通じてパイプしたときのみ、3重の mustaches を使うことがよいでしょう。


最後に、一度だけの挿入を示すために、mustache バインディングに `*` を追加することもできます。これはデータ変更には反応しません:

```html
{{* onlyOnce }}
```

### フィルタ

フィルタは View を更新する前の生の値を処理するために使われる関数です。これらは、 ディレクティブかバインディングの中の"パイプ(`|`)"によって示されます:

```html
<div>{{message | capitalize}}</div>
```

div の textContent が更新されたときに、`message` の値は `capitalize` 関数を通じて初めて解析されます。詳細は[フィルタ](/guide/filters.html) を参照してください。

### コンポーネント

![コンポーネントのツリー](/images/components.png)

Vue.js では、全ての要素は単に Vue インスタンスです。コンポーネントは、アプリケーションインターフェイスを表現するネストされたツリーのような階層構造を形作ります。これらは `Vue.extend` から返ってきたカスタムコンストラクタによって初期化されます。しかし、より宣言的なアプローチはそれらを `Vue.component(id, constructor)` で登録することです。 一度登録されれば、カスタム要素のフォームで、他の Vue インスタンスのテンプレートに宣言的にネストされます:

```html
<my-component>
  <!-- internals handled by my-component -->
</my-component>
```

この簡単な機構は、宣言の再利用と [Web Components](http://www.w3.org/TR/components-intro/) と似た方法での Vue インスタンスの構成を可能にします。最新ブラウザや重い polyfills は必要ありません。アプリケーションをより小さなコンポーネントに分割することにより、結果は高度に分離され、メンテナンスしやすいコードベースになります。 詳細は[コンポーネントシステム](/guide/components.html)を参照してください。

## クイックな例

```html
<div id="demo">
  <h1>{{title | uppercase}}</h1>
  <ul>
    <li
      v-repeat="todos"
      v-on="click: done = !done"
      class="{{done ? 'done' : ''}}">
      {{content}}
    </li>
  </ul>
</div>
```

```js
var demo = new Vue({
  el: '#demo',
  data: {
    title: 'todos',
    todos: [
      {
        done: true,
        content: 'Learn JavaScript'
      },
      {
        done: false,
        content: 'Learn Vue.js'
      }
    ]
  }
})
```

**結果**

<div id="demo"><h1>&#123;&#123;title | uppercase&#125;&#125;</h1><ul><li v-repeat="todos" v-on="click: done = !done" class="&#123;&#123;done ? 'done' : ''&#125;&#125;">&#123;&#123;content&#125;&#125;</li></ul></div>
<script>
var demo = new Vue({
  el: '#demo',
  data: {
    title: 'todos',
    todos: [
      {
        done: true,
        content: 'Learn JavaScript'
      },
      {
        done: false,
        content: 'Learn Vue.js'
      }
    ]
  }
})
</script>

[jsfiddle](http://jsfiddle.net/yyx990803/yMv7y/)も利用できます.

todo をクリックして toggle したり、 ブラウザのコンソールを開いて `demo` オブジェクトで遊んでみることも可能です。例えば、`demo.title` を変更して、`demo.todos` に新しいオブジェクトを追加したり、 todo の`done` 状態をトグルしてみたりしてみて下さい。

多分、いくつかの疑問が心に浮かんできたでしょう。しかし心配ありません。我々はそれらの疑問をすぐに解決します。

次の[ディレクティブ](/guide/directives.html)に進みましょう。

[AngularJS]: http://angularjs.org
[KnockoutJS]: http://knockoutjs.com
[Ractive.js]: http://ractivejs.org
[Rivets.js]: http://www.rivetsjs.com
