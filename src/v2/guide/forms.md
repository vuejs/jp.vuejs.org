---
title: フォーム入力バインディング
updated: 2020-05-15
type: guide
order: 10
---

## 基本的な使い方

form の input 要素 や textarea 要素、 select 要素に双方向 (two-way) データバインディングを作成するには、`v-model` ディレクティブを使用することができます。それは、自動的に入力要素のタイプに基づいて要素を更新するための正しい方法を選択します。ちょっと魔法のようですが、`v-model` はユーザーの入力イベントにおいてデータを更新するための基本的な糖衣構文 (syntax sugar) で、それに加えて、いくつかのエッジケースに対しては特別な配慮をしてくれます。

<p class="tip">`v-model` は任意の form 要素にある `value`、`checked`、または `selected` 属性の初期値を無視します。input または textarea は常に、信頼できる情報源として Vue インスタンスを扱います。コンポーネントの `data` オプションの中で JavaScript 側で初期値を宣言する必要があります。</p>

`v-model` は、内部的には input 要素に応じて異なるプロパティを使用し、異なるイベントを送出します:
- テキストと複数行テキストは、`value` プロパティと `input` イベントを使用します
- チェックボックスとラジオボタンは、`checked` プロパティと `change` イベントを使用します
- 選択フィールドは、`value` プロパティと `change` イベントを使用します

<p class="tip" id="vmodel-ime-tip">[IME](https://en.wikipedia.org/wiki/Input_method) (中国語、日本語、韓国語、その他) が必須な言語において、`v-model` では IME でテキストが確定するまでは更新されないことに注意してください。これらの更新に対して対応したい場合は、`input` イベントを代わりに使用します。</p>

### テキスト

``` html
<input v-model="message" placeholder="edit me">
<p>Message is: {{ message }}</p>
```

{% raw %}
<div id="example-1" class="demo">
  <input v-model="message" placeholder="edit me">
  <p>Message is: {{ message }}</p>
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

### 複数行テキスト

``` html
<span>Multiline message is:</span>
<p style="white-space: pre-line;">{{ message }}</p>
<br>
<textarea v-model="message" placeholder="add multiple lines"></textarea>
```

{% raw %}
<div id="example-textarea" class="demo">
  <span>Multiline message is:</span>
  <p style="white-space: pre-line;">{{ message }}</p>
  <br>
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

{% raw %}
<p class="tip">textarea への挿入 (<code>&lt;textarea&gt;{{text}}&lt;/textarea&gt;</code>) は動きません。代わりに、<code>v-model</code>を使用してください。</p>
{% endraw %}

### チェックボックス

単体のチェックボックスは、 boolean 値です:

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

複数のチェックボックスは、同じ配列に束縛します。:

``` html
<input type="checkbox" id="jack" value="Jack" v-model="checkedNames">
<label for="jack">Jack</label>
<input type="checkbox" id="john" value="John" v-model="checkedNames">
<label for="john">John</label>
<input type="checkbox" id="mike" value="Mike" v-model="checkedNames">
<label for="mike">Mike</label>
<br>
<span>Checked names: {{ checkedNames }}</span>
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
  <span>Checked names: {{ checkedNames }}</span>
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

### ラジオ

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

### 選択

単体の選択:

``` html
<select v-model="selected">
  <option disabled value="">Please select one</option>
  <option>A</option>
  <option>B</option>
  <option>C</option>
</select>
<span>Selected: {{ selected }}</span>
```

``` js
new Vue({
  el: '...',
  data: {
    selected: ''
  }
})
```

{% raw %}
<div id="example-5" class="demo">
  <select v-model="selected">
    <option disabled value="">Please select one</option>
    <option>A</option>
    <option>B</option>
    <option>C</option>
  </select>
  <span>Selected: {{ selected }}</span>
</div>
<script>
new Vue({
  el: '#example-5',
  data: {
    selected: ''
  }
})
</script>
{% endraw %}

<p class="tip">`v-model` の式の初期値がオプションのどれとも一致しない場合、`<select>` 要素は "未選択" の状態で描画されます。iOS では、この場合 iOS が `change` イベントを発生させないため、最初のアイテムを選択できなくなります。したがって、上記の例に示すように、disabled な空の値のオプションを追加しておくことをおすすめします。</p>

複数の選択（配列に束縛）:

``` html
<select v-model="selected" multiple>
  <option>A</option>
  <option>B</option>
  <option>C</option>
</select>
<br>
<span>Selected: {{ selected }}</span>
```
{% raw %}
<div id="example-6" class="demo">
  <select v-model="selected" multiple style="width: 50px;">
    <option>A</option>
    <option>B</option>
    <option>C</option>
  </select>
  <br>
  <span>Selected: {{ selected }}</span>
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

動的オプションは `v-for` で描画できます:

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

radio 、 checkbox 、 select オプションの、 `v-model` でバインディングされる値は通常は静的な文字列 (チェックボックスなら boolean) です:

``` html
<!-- チェックされたとき、`picked` は文字列"a"になります -->
<input type="radio" v-model="picked" value="a">

<!-- `toggle` は true かまたは false のどちらかです -->
<input type="checkbox" v-model="toggle">

<!-- 最初のオプションが選択されたとき、`selected` は文字列"abc"です -->
<select v-model="selected">
  <option value="abc">ABC</option>
</select>
```

しかし、時には、Vue インスタンスの動的なプロパティに値を束縛したくなるかもしれません。それを達成するために `v-bind` を使用することができます。 加えて、`v-bind` を使用することで input 値に文字列以外の値を束縛することができるようになります。

### チェックボックス

``` html
<input
  type="checkbox"
  v-model="toggle"
  true-value="yes"
  false-value="no"
>
```

``` js
// チェックされたとき:
vm.toggle === 'yes'
// チェックが外されたとき:
vm.toggle === 'no'
```

<p class="tip">`true-value` と ` false-value` 属性は入力フォームの `value` 属性には影響を及ぼしません。なぜならブラウザはフォームの送信の中にチェックされていないチェックボックスを含めないからです。 2つの値 (つまり "yes" または "no") のどちらかが必ずフォームで送信されることを保証するには、代わりにラジオを使用してください。</p>

### ラジオ

``` html
<input type="radio" v-model="pick" v-bind:value="a">
```

``` js
// チェックしたとき:
vm.pick === vm.a
```

### 選択オプション

``` html
<select v-model="selected">
<!-- インラインオブジェクトリテラル -->
  <option v-bind:value="{ number: 123 }">123</option>
</select>
```

``` js
// 選択したとき:
typeof vm.selected // => 'object'
vm.selected.number // => 123
```

## 修飾子

### `.lazy`

デフォルトでは、 `v-model` は各 `input` イベント ([上記](#vmodel-ime-tip)の IME 確定前を除いて) 後に、データと入力を同期します。 `change` イベント _の後に_ 同期するように変更するために `lazy` 修飾子を追加することができます:

``` html
<!-- "input" の代わりに "change" 後に同期します -->
<input v-model.lazy="msg">
```

### `.number`

ユーザの入力を Number として自動的に型変換したいとき、 `v-model` に管理された入力に `number` 修飾子を追加することができます:

``` html
<input v-model.number="age" type="number">
```

これは、しばしば有用です。なぜなら、 `type=number` と書いたときでさえ、 HTML の input 要素の value は常に文字列を返すからです。もし値が `parseFloat()` で解釈できない場合は、もとの値が返却されます。

### `.trim`

ユーザの入力から空白を自動的に取り除きたいときは、 `v-model` に管理された入力に `trim` 修飾子を追加することができます:

```html
<input v-model.trim="msg">
```

## コンポーネントの `v-model`

> Vue のコンポーネントにまだ精通していない人は、この部分をスキップしてください。

HTML の組み込みの input 要素は常にあなたの要望に合うとは限りません。幸いにも、Vue のコンポーネントを使用すると、完全にカスタマイズされた動作で再利用可能な独自の input 要素的なものを作成することができます。これらの入力コンポーネントは `v-model` を使用することができます！

より詳細については、[カスタム入力](components.html#コンポーネントで-v-model-を使う)をコンポーネントガイドで参照してください。
