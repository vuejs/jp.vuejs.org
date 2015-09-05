title: フォームのハンドリング
type: guide
order: 7
---

## 基礎

フォームの input 要素に two way (双方向)バインディングを作成するには、 `v-model` ディレクティブを使用します。 `v-model` ディレクティブは、input の type に基づき、要素を更新する正しい方法を自動的に選択します。

**例**

``` html
<form id="demo">
  <!-- text -->
  <p>
    <input type="text" v-model="msg">
    {{msg}}
  </p>
  <!-- checkbox -->
  <p>
    <input type="checkbox" v-model="checked">
    {{checked ? "yes" : "no"}}
  </p>
  <!-- radio buttons -->
  <p>
    <input type="radio" name="picked" value="one" v-model="picked">
    <input type="radio" name="picked" value="two" v-model="picked">
    {{picked}}
  </p>
  <!-- select -->
  <p>
    <select v-model="selected">
      <option>one</option>
      <option>two</option>
    </select>
    {{selected}}
  </p>
  <!-- multiple select -->
  <p>
    <select v-model="multiSelect" multiple>
      <option>one</option>
      <option>two</option>
      <option>three</option>
    </select>
    {{multiSelect}}
  </p>
  <p><pre>data: {{$data | json 2}}</pre></p>
</form>
```

``` js
new Vue({
  el: '#demo',
  data: {
    msg      : 'hi!',
    checked  : true,
    picked   : 'one',
    selected : 'two',
    multiSelect: ['one', 'three']
  }
})
```

**結果**

<form id="demo"><p><input type="text" v-model="msg"> {&#123;msg&#125;}</p><p><input type="checkbox" v-model="checked"> {&#123;checked ? &quot;yes&quot; : &quot;no&quot;&#125;}</p><p><input type="radio" v-model="picked" name="picked" value="one"><input type="radio" v-model="picked" name="picked" value="two"> {&#123;picked&#125;}</p><p><select v-model="selected"><option>one</option><option>two</option></select> {&#123;selected&#125;}</p><p><select v-model="multiSelect" multiple><option>one</option><option>two</option><option>three</option></select>{&#123;multiSelect&#125;}</p><p>data:<pre style="font-size:13px;background:transparent;line-height:1.5em">{&#123;$data | json 2&#125;}</pre></p></form>
<script>
new Vue({
  el: '#demo',
  data: {
    msg      : 'hi!',
    checked  : true,
    picked   : 'one',
    selected : 'two',
    multiSelect: ['one', 'three']
  }
})
</script>

## 遅延更新

デフォルトで、`v-model` はデータと input を `input` イベントの直後に同期します。`lazy` 属性を追加することで、 `change` イベントの直後に同期させるように、挙動を変更することができます:

``` html
<!-- "input" の代わりに、"change" の直後に同期する  -->
<input v-model="msg" lazy>
```

## 値を数値としてキャストする

もし、ユーザの入力を自動的に数値として永続化したいのであれば、`v-model` で管理している input に `number` 属性を追加することができます:

``` html
<input v-model="age" number>
```

## 動的な選択オプション

`<select>` 要素のオプションリストを動的にレンダリングする必要があれば、オプションが動的に変更されるとき、`v-model` は正しく同期しているため、`v-model`  と一緒に `options` 属性を利用することが推奨されています:

``` html
<select v-model="selected" options="myOptions"></select>
```

あなたの data では、`myOptions` はオプションとして使いたい配列を指す keypath または expression である必要があります。

配列はプレーンなテキストまたは `{text:'', value:''}` の形式のオブジェクトを含めることができます。このオブジェクト形式は、値とは異なるオプション文字列を表示することができます:

``` js
[
  { text: 'A', value: 'a' },
  { text: 'B', value: 'b' }
]
```

これは下記のようにレンダリングされます:

``` html
<select>
  <option value="a">A</option>
  <option value="b">B</option>
</select>
```

一方、オブジェクトは `{ label:'', options:[...] }` の形式も取ることができます。このケースでは、 `<optgroup>` としてレンダリングされます:

``` js
[
  { label: 'A', options: ['a', 'b']},
  { label: 'B', options: ['c', 'd']}
]
```

これは下記のようにレンダリングされます:

``` html
<select>
  <optgroup label="A">
    <option value="a">a</option>
    <option value="b">b</option>
  </optgroup>
  <optgroup label="B">
    <option value="c">c</option>
    <option value="d">d</option>
  </optgroup>
</select>
```

### オプションフィルタ

あなたの元データがこれらの希望されるフォーマットでなく、動的にオプションを生成するためにデータを変換しなければならない場合がよくあります。DRY な変換をするために、`options` パラメータはフィルタをサポートしており、あなたの変換ロジックを再利用可能な[カスタムフィルタ](/guide/custom-filter.html)で置き換えるのに役に立ちます。

``` js
Vue.filter('extract', function (value, keyToExtract) {
  return value.map(function (item) {
    return item[keyToExtract]
  })
})
```

``` html
<select
  v-model="selectedUser"
  options="users | extract 'name'">
</select>
```

上記フィルタは `[{ name: 'Bruce' }, { name: 'Chuck' }]` のようなデータを `['Bruce', 'Chuck']` に変換し、 正しいフォーマットになります。

### 静的なデフォルトオプション

> 0.12.10 以降のみ

動的な生成オプションに加えて、1つの静的デフォルトオプションを提供することができます:

``` html
<select v-model="selectedUser" options="users">
  <option value="">Select a user...</option>
</select>
```

`users` から作成された動的なオプションは、静的なオプションの後に追加されます。`v-model` の値が偽と評価される (`0` は除く) 値の場合、静的なオプションはデフォルトで選択されます。

## 入力デバウンス

`debounce` パラメータは、入力値が Model に同期される前の各キーストローク後の最小遅延の設定を許可します。これは、例えば、先行入力自動補完向けに Ajax リクエストを作成するような、各更新時に高価な操作を実行しているときには便利です。

``` html
<input v-model="msg" debounce="500">
```

**結果**

<div id="debounce-demo" class="demo">{&#123;msg&#125;}<br><input v-model="msg" debounce="500"></div>
<script>
new Vue({
  el:'#debounce-demo',
  data: { msg: 'edit me' }
})
</script>

`debounce` パラメータはユーザーの入力イベントをデバウンスしないことに注意してください: それは基礎となるデータに "書き込み" 操作をデバウンスします。そのため、`debounce` を使用するときデータ変更に反応するために `vm.$watch()` を使用する必要があります。本物の DOM イベントをデバウンスするためには、[debounce filter](/api/filters.html#debounce) を使います。
次: [Computed Properties](/guide/computed.html)
