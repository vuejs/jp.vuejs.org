title: Form Input Bindings
type: guide
order: 9
---

## 基礎

フォームの input 要素に two way (双方向)バインディングを作成するには、 `v-model` ディレクティブを使用します。 `v-model` ディレクティブは、input の type に基づき、要素を更新する正しい方法を自動的に選択します。

### Text

### Checkbox

### Radio

### Select

**Example**

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

## Binding Non-String Values

チェックボックスとラジオボックスの入力上で `v-model` を使用するとき、バインドされた値は boolean 値か、string のどちらかです:

``` html
<!-- true または false のどちらかでトグル -->
<input type="checkbox" v-model="toggle">

<!-- このラジオボックスが選択されるとき、pick は "red" になります -->
<input type="radio" v-model="pick" value="red">
```

これは、時々何か他のものへ根本的な値をバインドしたいかもしれない時、少し制限することができます。ここでは、次のとおりにできます:

**Checkbox**

``` html
<input type="checkbox" v-model="toggle" true-exp="a" false-exp="b">
```

``` js
// チェックしたとき:
vm.toggle === vm.a
// チェックがはずれされたとき:
vm.toggle === vm.b
```

**Radio**

``` html
<input type="radio" v-model="pick" exp="a">
```

``` js
// チェックしたとき:
vm.pick === vm.a
```

## Param Attributes

### lazy

By default, `v-model` syncs the input with the data after each `input` event. You can add a `lazy` attribute to change the behavior to sync after `change` events:

``` html
<!-- synced after "change" instead of "input" -->
<input v-model="msg" lazy>
```

### number

If you want user input to be automatically persisted as numbers, you can add a `number` attribute to your `v-model` managed inputs:

``` html
<input v-model="age" number>
```

### debounce

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

Note that the `debounce` param does not debounce the user's input events: it debounces the "write" operation to the underlying data. Therefore you should use `vm.$watch()` to react to data changes when using `debounce`. For debouncing real DOM events you should use the [debounce filter](/api/filters.html#debounce).

We've covered a lot of ground so far. By now you should already be able to build some simple, dynamic interfaces with Vue.js, but you may still feel that the whole reactive system is a bit like magic. It is time that we talk about it in more details. Next up: [Reactivity In Depth](reactivity.html).
