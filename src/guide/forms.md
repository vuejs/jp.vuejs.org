---
title: フォーム入力バインディング
type: guide
order: 10
---

## 基本的な使い方

form の input 要素 と textarea 要素で双方向 (two-way) データバインディングを作成するには、`v-model` ディレクティブを使用することができます。それは、自動的に入力されたタイプに基づいて要素を更新するための正しい方法を選択します。わずかな魔法とはいえ、`v-model` は本質的にユーザーの入力イベントにおいてデータを更新するための糖衣構文 (syntax sugar) で、そのうえ、いくつかのエッジケースに対して特別な配慮が必要です。

### Text

``` html
<span>Message is: {{ message }}</span>
<br>
<input type="text" v-model="message" placeholder="edit me">
```

{% raw %}
<div id="example-1" class="demo">
  <span>Message is: {{ message }}</span><br>
  <input type="text" v-model="message" placeholder="edit me">
</div>
<script>
new Vue({
  el: '#example-1',
  data: {
    message: ''
  }
})
</script>
{% endraw %}

### TextArea

``` html
<span>Multiline message is:</span>
<p>{{ message }}</p>
<br>
<textarea v-model="message"></textarea>
```

{% raw %}
<div id="example-textarea" class="demo">
  <span>Message is:</span>
  <p style="white-space: pre">{{ message }}</p><br>
  <textarea v-model="message" placeholder="add multiple lines"></textarea>
</div>
<script>
new Vue({
  el: '#example-textarea',
  data: {
    message: ''
  }
})
</script>
{% endraw %}


### Checkbox

単体のチェックボックスは、boolean 値です:

``` html
<input type="checkbox" id="checkbox" v-model="checked">
<label for="checkbox">{{ checked }}</label>
```
{% raw %}
<div id="example-2" class="demo">
  <input type="checkbox" id="checkbox" v-model="checked">
  <label for="checkbox">{{ checked }}</label>
</div>
<script>
new Vue({
  el: '#example-2',
  data: {
    checked: false
  }
})
</script>
{% endraw %}

複数のチェックボックスは、同じ配列にバウンドします:

``` html
<input type="checkbox" id="jack" value="Jack" v-model="checkedNames">
<label for="jack">Jack</label>
<input type="checkbox" id="john" value="John" v-model="checkedNames">
<label for="john">John</label>
<input type="checkbox" id="mike" value="Mike" v-model="checkedNames">
<label for="mike">Mike</label>
<br>
<span>Checked names: {{ checkedNames | json }}</span>
```

``` js
new Vue({
  el: '...',
  data: {
    checkedNames: []
  }
})
```

{% raw %}
<div id="example-3" class="demo">
  <input type="checkbox" id="jack" value="Jack" v-model="checkedNames">
  <label for="jack">Jack</label>
  <input type="checkbox" id="john" value="John" v-model="checkedNames">
  <label for="john">John</label>
  <input type="checkbox" id="mike" value="Mike" v-model="checkedNames">
  <label for="mike">Mike</label>
  <br>
  <span>Checked names: {{ checkedNames | json }}</span>
</div>
<script>
new Vue({
  el: '#example-3',
  data: {
    checkedNames: []
  }
})
</script>
{% endraw %}

### Radio


``` html
<input type="radio" id="one" value="One" v-model="picked">
<label for="one">One</label>
<br>
<input type="radio" id="two" value="Two" v-model="picked">
<label for="two">Two</label>
<br>
<span>Picked: {{ picked }}</span>
```
{% raw %}
<div id="example-4" class="demo">
  <input type="radio" id="one" value="One" v-model="picked">
  <label for="one">One</label>
  <br>
  <input type="radio" id="two" value="Two" v-model="picked">
  <label for="two">Two</label>
  <br>
  <span>Picked: {{ picked }}</span>
</div>
<script>
new Vue({
  el: '#example-4',
  data: {
    picked: ''
  }
})
</script>
{% endraw %}

### Select

単体の選択:

``` html
<select v-model="selected">
  <option selected>A</option>
  <option>B</option>
  <option>C</option>
</select>
<span>Selected: {{ selected }}</span>
```
{% raw %}
<div id="example-5" class="demo">
  <select v-model="selected">
    <option selected>A</option>
    <option>B</option>
    <option>C</option>
  </select>
  <span>Selected: {{ selected }}</span>
</div>
<script>
new Vue({
  el: '#example-5',
  data: {
    selected: null
  }
})
</script>
{% endraw %}

複数の選択 (配列にバウンド):

``` html
<select v-model="selected" multiple>
  <option selected>A</option>
  <option>B</option>
  <option>C</option>
</select>
<br>
<span>Selected: {{ selected | json }}</span>
```
{% raw %}
<div id="example-6" class="demo">
  <select v-model="selected" multiple style="width: 50px">
    <option selected>A</option>
    <option>B</option>
    <option>C</option>
  </select>
  <br>
  <span>Selected: {{ selected | json }}</span>
</div>
<script>
new Vue({
  el: '#example-6',
  data: {
    selected: []
  }
})
</script>
{% endraw %}

動的オプションは `v-for` でレンダリングできます:

``` html
<select v-model="selected">
  <option v-for="option in options" v-bind:value="option.value">
    {{ option.text }}
  </option>
</select>
<span>Selected: {{ selected }}</span>
```
``` js
new Vue({
  el: '...',
  data: {
    selected: 'A',
    options: [
      { text: 'One', value: 'A' },
      { text: 'Two', value: 'B' },
      { text: 'Three', value: 'C' }
    ]
  }
})
```
{% raw %}
<div id="example-7" class="demo">
  <select v-model="selected">
    <option v-for="option in options" v-bind:value="option.value">
      {{ option.text }}
    </option>
  </select>
  <span>Selected: {{ selected }}</span>
</div>
<script>
new Vue({
  el: '#example-7',
  data: {
    selected: 'A',
    options: [
      { text: 'One', value: 'A' },
      { text: 'Two', value: 'B' },
      { text: 'Three', value: 'C' }
    ]
  }
})
</script>
{% endraw %}

## 値のバインディング

radio、checkbox、そして select オプションは、`v-model`バインディングの値は通常静的文字列 (または、チェックボックスには boolean )を指定します:

``` html
<!-- チェックされたとき、`picked` は文字列"a"になります -->
<input type="radio" v-model="picked" value="a">

<!-- `toggle` は true かまたは false のどちらかです -->
<input type="checkbox" v-model="toggle">

<!-- 選択されたとき、`selected` は文字列"abc"です -->
<select v-model="selected">
  <option value="abc">ABC</option>
</select>
```

しかし、時どき、私達は、Vue インスタンスで動的プロパティに値をバインドしたいかもしれません。私達はそれを達成するために `v-bind` を使用することができます。 ほかに、`v-bind` の使用は、私達に文字列ではない値に input 値をバインドします。

### Checkbox

``` html
<input
  type="checkbox"
  v-model="toggle"
  v-bind:true-value="a"
  v-bind:false-value="b">
```

``` js
// チェックしたとき:
vm.toggle === vm.a
// チェックがはずれされたとき:
vm.toggle === vm.b
```

### Radio

``` html
<input type="radio" v-model="pick" v-bind:value="a">
```

``` js
// チェックしたとき:
vm.pick === vm.a
```

### Select Options

``` html
<select v-model="selected">
  <!-- インラインオブジェクトリテラル -->
  <option v-bind:value="{ number: 123 }">123</option>
</select>
```

``` js
// 選択したとき
typeof vm.selected // -> 'object'
vm.selected.number // -> 123
```

## パラメータ属性

### lazy

デフォルトでは、`v-model` は各 `input` イベント後に、データと入力を同期します。`change` イベント後、同期するための振舞いを変更するために、`lazy` 属性を追加します:

``` html
<!-- "input" の代わりに "change" 後に同期します -->
<input v-model="msg" lazy>
```

### number

ユーザーの入力において自動的に数値として永続化する場合、`v-model` を管理された input の値に対して、`number` 属性を追加することができます。

``` html
<input v-model="age" number>
```

### debounce

`debounce` パラメータは、入力値が Model に同期される前の各キーストローク後の最小遅延の設定を許可します。これは、例えば、先行入力自動補完向けに Ajax リクエストを作成するような、各更新時に高価な操作を実行しているときには便利です。

``` html
<input v-model="msg" debounce="500">
```
 {% raw %}
<div id="debounce-demo" class="demo">
  {{ msg }}<br>
  <input v-model="msg" debounce="500">
</div>

<script>
new Vue({
  el:'#debounce-demo',
  data: { msg: 'edit me' }
})
</script>
{% endraw %}

`debounce` パラメータはユーザーの入力イベントをデバウンスしないことに注意してください: それは基礎となるデータに “書き込み” 操作をデバウンスします。そのため`debounce` を使用するときデータ変に対して反応するために `vm.$watch()` を使用する必要があります。本物の DOM イベントをデバウンスするためには、[debounce filter](/api/#debounce) を使います。
