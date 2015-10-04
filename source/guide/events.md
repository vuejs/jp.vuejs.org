title: Methods and Event Handling
type: guide
order: 7
---

## Method Handler

We can then use the `v-on` directive to listen to DOM events:

``` html
<div id="example">
  <button v-on:click="greet">Greet</button>
</div>
```

We are binding a click event listener to a method named `greet`. Here's how to define that method in our Vue instance:

``` js
var vm = new Vue({
  el: '#example',
  data: {
    name: 'Vue.js'
  },
  // define methods under the `methods` object
  methods: {
    greet: function (event) {
      // `this` inside methods point to the Vue instance
      alert('Hello ' + this.name + '!')
      // `event` is the native DOM event
      alert(event.target.tagName)
    }
  }
})

// you can invoke methods in JavaScript too
vm.greet() // -> 'Hello Vue.js!'
```

Test it yourself:

{% raw %}
<div id="example" class="demo">
  <button v-on:click="greet">Greet</button>
</div>
<script>
var vm = new Vue({
  el: '#example',
  data: {
    name: 'Vue.js'
  },
  // define methods under the `methods` object
  methods: {
    greet: function (event) {
      // `this` inside methods point to the vm
      alert('Hello ' + this.name + '!')
      // `event` is the native DOM event
      alert(event.target.tagName)
    }
  }
})
</script>
{% endraw %}

## Inline Statement Handler

Instead of binding directly to a method name, we can also use an inline JavaScript statement:

``` html
<div id="example-2">
  <button v-on:click="say('hi')">Say Hi</button>
  <button v-on:click="say('what')">Say What</button>
</div>
```
``` js
new Vue({
  el: '#example-2',
  methods: {
    say: function (msg) {
      alert(msg)
    }
  }
})
```

Result:
{% raw %}
<div id="example-2" class="demo">
  <button v-on:click="say('hi')">Say Hi</button>
  <button v-on:click="say('what')">Say What</button>
</div>
<script>
new Vue({
  el: '#example-2',
  methods: {
    say: function (msg) {
      alert(msg)
    }
  }
})
</script>
{% endraw %}

Similar to the restrictions on inline expressions, event handlers are restricted to **one statement only**.

Sometimes we also need to access the original DOM event in an inline statement handler. You can pass it into a method using the speical `$event` variable:

``` html
<button v-on:click="say('hello!', $event)">Submit</button>
```

``` js
// ...
methods: {
  say: function (msg, event) {
    // now we have access to the native event
    event.preventDefault()
  }
}
```

## Event Modifiers

It is a very common need to call `event.preventDefault()` or `event.stopPropagation()` inside event handlers. Although we can do this easily inside methods, it would be better if the methods can be purely about data logic rather than having to deal with DOM event details.

To address this problem, Vue.js provides two **event modifiers** for `v-on`: `.prevent` and `.stop`. Recall that modifiers are directive postfixes denoted by a dot:

``` html
<!-- the click event's propagation will be stopped -->
<a v-on:click.stop="doThis"></a>

<!-- the submit event will no longer reload the page -->
<form v-on:submit.prevent="onSubmit"></form>

<!-- modifiers can be chained -->
<a v-on:click.stop.prevent="doThat">
```

## Key Modifiers

When listening for keyboard events, we often need to check for common key codes. Vue.js also allows adding key modifiers for `v-on` when listening for key events:

``` html
<!-- only call vm.submit() when the keyCode is 13 -->
<input v-on:keyup.13="submit">
```

Remembering all the keyCodes is a hassle, so Vue.js provides aliases for most commonly used keys:

``` html
<!-- same as above -->
<input v-on:keyup.enter="submit">

<!-- also works for shorthand -->
<input @keyup.enter="submit">
```

Here's the full list of key modifier aliases:

- enter
- tab
- delete
- esc
- space
- up
- down
- left
- right

## なぜ HTML 内にリスナを記述するのですか？

このようなイベント監視のアプローチは、「関心の分離」という古き良きルールを破っているのではないか、と心配されるかもしれません。安心して下さい。すべての Vue.js のハンドラ関数と expression は現在のビューのみを扱う ViewModel にのみバインドされるよう制限されています。それによってメンテナンスが難しくなることはありません。実際に、`v-on` を利用することでいくつかの利点があります:

1. HTML テンプレートを単に眺めることで、あなたの JS コード内のハンドラ関数を簡単に見つけ出すことができます。
2. JS 内のイベントリスナを手作業でアタッチする必要がないので、ViewModel のコードはロジックのみとなり、DOM 依存もなくなります。このことはテストをより簡単にします。
3. ViewModel が破棄されたとき、すべてのイベントリスナは自動的に削除されます。それらを自力でクリーンアップすることを気にかける必要もありません。

Next up: [Conditional Rendering](conditional.html).
