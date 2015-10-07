title: Transitions
type: guide
order: 11
---

Vue.js のトランジションシステムを使用すると、DOM から要素を取得したり削除するといったトランジションエフェクトを自動的に適用できます。Vue.js は自動的に、適切な時に、あなたのために CSS トランジションまたはアニメーションをトリガするため、CSS クラスを追加または削除し、そしてトランジションの間は、カスタム DOM の操作をするために、JavaScript フック関数を提供することができます。

To apply transition effects, you need to use the special `transition` attribute on the target element:

``` html
<div v-if="show" transition="my-transition"></div>
```

The `transition` attribute can be used together with:

- `v-if`
- `v-show`
- `v-for` (triggered for insertion and removal only)
- Dynamic components (introduced in the [next section](components.html#Dynamic_Components))
- On a component root node, and triggered via Vue instance DOM methods, e.g. `vm.$appendTo(el)`.

When an element with transition is inserted or removed, Vue will:

`v-transition="my-transition"` というディレクティブを適用した場合：

1. `"my-transition"` の ID を使用して、`Vue.transition(id, hooks)` または、`transitions` オプションを通じて登録された JavaScript のトランジションのフックオブジェクトを探します。それが見つかると、さまざまな段階で、適切なフックを呼びます。

2. 自動的に、対象の要素に CSS トランジションか CSS アニメーションが適用されているか調べ、適切なタイミングで CSS クラスを追加/削除します。

## CSS Transitions

### Example

A typical CSS transition looks like this:

``` html
<div v-if="show" transition="expand">hello</div>
```

また `.expand-transition`クラス、`.expand-enter` クラスそして `.expand-leave` クラスの CSS ルールを定義する必要があります。

``` css
/* always present */
.expand-transition {
  transition: all .3s ease;
  height: 30px;
  padding: 10px;
  background-color: #eee;
  overflow: hidden;
}

/* .expand-enter defines the starting state for entering */
/* .expand-leave defines the ending state for leaving */
.expand-enter, .expand-leave {
  height: 0;
  padding: 0 10px;
  opacity: 0;
}
```

加えて、JavaScript フックを提供できます。

``` js
Vue.transition('expand', {
  beforeEnter: function (el) {
    el.textContent = 'beforeEnter'
  },
  enter: function (el) {
    el.textContent = 'enter'
  },
  afterEnter: function (el) {
    el.textContent = 'afterEnter'
  },
  enterCancelled: function (el) {
    // 取り消しハンドル
  },

  beforeLeave: function (el) {
    el.textContent = 'beforeLeave'
  },
  leave: function (el) {
    el.textContent = 'leave'
  },
  afterLeave: function (el) {
    el.textContent = 'afterLeave'
  },
  leaveCancelled: function (el) {
    // 取り消しハンドル
  }
})
```

{% raw %}
<div id="demo">
  <div v-if="show" transition="expand">hello</div>
  <button @click="show = !show">Toggle</button>
</div>

<style>
.expand-transition {
  transition: all .3s ease;
  padding: 10px;
  height: 30px;
  background-color: #eee;
  overflow: hidden;
}
.expand-enter, .expand-leave {
  height: 0;
  padding: 0 10px;
  opacity: 0;
}
</style>

<script>
new Vue({
  el: '#demo',
  data: {
    show: true,
    transitionState: 'Idle'
  },
  transitions: {
    expand: {
      beforeEnter: function (el) {
        el.textContent = 'beforeEnter'
      },
      enter: function (el) {
        el.textContent = 'enter'
      },
      afterEnter: function (el) {
        el.textContent = 'afterEnter'
      },
      beforeLeave: function (el) {
        el.textContent = 'beforeLeave'
      },
      leave: function (el) {
        el.textContent = 'leave'
      },
      afterLeave: function (el) {
        el.textContent = 'afterLeave'
      }
    }
  }
})
</script>
{% endraw %}

### Transition CSS Classes

The classes being added and toggled are based on the value of the `transition` attribute. In the case of `transition="fade"`, three CSS classes are involved:

1. The class `.fade-transition` will be always present on the element.

2. `.fade-enter` defines the starting state of an entering transition. It is applied for a single frame and then immediately removed.

3. `.fade-leave` defines the ending state of a leaving transition. It is applied when the leaving transition starts and removed when the tranition finishes.

If the `transition` attribute has no value, the classes will default to `.v-transition`, `.v-enter` and `.v-leave`.

### Transition Flow Details

`show` プロパティに変更があると、それに応じて Vue.js は `<div>` 要素を追加/削除し、以下に指定されているようにトランジションクラスを適用します。

- `show` プロパティが `false` の場合：
  1. `beforeLeave` フックを呼びます。
  2. `v-leave` クラスを要素に適用し、トランジションをトリガします。
  3. `leave` フックを呼びます。
  4. トランジションが終わるまで待ちます。(`transitionend` イベントをリスニングします)
  5. DOM から要素と `v-leave`　を削除します。
  6. `afterLeave` フックを呼びます。

- `show` プロパティが `true` の場合：
  1. `beforeEnter` フックを呼びます。
  2. `v-enter` クラスを要素に適用します。
  3. それを DOM に挿入します。
  4. `enter` フックを呼びます。
  5. `v-enter` が実際に適用されるように CSS レイアウトを強制し、それから要素を元の状態にトランジションを戻すのをトリガするため、`v-enter` クラスを削除します。
  6. トランジションが終わるまで待ちます。
  7. `afterEnter` フックを呼びます。

加えて、もし enter トランジションが進行中のときに要素が削除される場合、`enterCancelled` フックは、変更を一掃する、または `enter` でタイマーが作成されるための機会を与えるために呼び出されます。逆である leaving トランジションも同じです。

上記のようなフック関数の全ては、それらの `this` コンテキストは関連付けられた Vue インスタンスを設定して呼び出されます。もし要素が Vue インスタンスのルートノードの場合、そのインスタンスはそのコンテキストとして使用されます。それ以外の場合は、そのコンテキストはトランジションディレクティブのインスタンスの所有者になります。

最後に、`enter` と `leave` は、必要に応じて、第2引数にコールバックを取ることができます。これを行うと、トランジションが終了すべきときに明示的に制御したいと示しているため、CSS の `transitionend`イベントを待ち受ける代わりに、Vue.js は最終的にトランジションを完了するためにコールバックを呼び出すことを期待します。例えば:

``` js
enter: function (el) {
  // 第2引数はなく、トランジションと CSS トランジションイベントで決定
}
```

に対して

``` js
enter: function (el, done) {
  // 第2引数で、`done` が呼ばれたときだけ、トランジションは終了する
}
```

<p class="tip">複数要素を同時にトランジションさせる場合、Vue.js はその要素をバッチにし、自動的に連続処理を行います。</p>

### CSS Animations

CSS アニメーションは、CSS トランジションと同じやり方で適用することができますが、対処の要素が追加された後、`animationend` がコールバックされるまで `v-enter` クラスが削除されないという違いがあります。

Example: (omitting prefixed CSS rules here)

``` html
<span v-show="show" transition="bounce">Look at me!</span>
```

``` css
.bounce-enter {
  animation: bounce-in .5s;
}
.bounce-leave {
  animation: bounce-out .5s;
}
@keyframes bounce-in {
  0% {
    transform: scale(0);
  }
  50% {
    transform: scale(1.5);
  }
  100% {
    transform: scale(1);
  }
}
@keyframes bounce-out {
  0% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.5);
  }
  100% {
    transform: scale(0);
  }
}
```

{% raw %}
<div id="anim" class="demo">
  <span v-show="show" transition="bounce">Look at me!</span>
  <br>
  <button @click="show = !show">Toggle</button>
</div>

<style>
  .bounce-enter {
    -webkit-animation: bounce-in .5s;
    animation: bounce-in .5s;
  }
  .bounce-leave {
    -webkit-animation: bounce-out .5s;
    animation: bounce-out .5s;
  }
  @keyframes bounce-in {
    0% {
      transform: scale(0);
      -webkit-transform: scale(0);
    }
    50% {
      transform: scale(1.5);
      -webkit-transform: scale(1.5);
    }
    100% {
      transform: scale(1);
      -webkit-transform: scale(1);
    }
  }
  @keyframes bounce-out {
    0% {
      transform: scale(1);
      -webkit-transform: scale(1);
    }
    50% {
      transform: scale(1.5);
      -webkit-transform: scale(1.5);
    }
    100% {
      transform: scale(0);
      -webkit-transform: scale(0);
    }
  }
  @-webkit-keyframes bounce-in {
    0% {
      -webkit-transform: scale(0);
    }
    50% {
      -webkit-transform: scale(1.5);
    }
    100% {
      -webkit-transform: scale(1);
    }
  }
  @-webkit-keyframes bounce-out {
    0% {
      -webkit-transform: scale(1);
    }
    50% {
      -webkit-transform: scale(1.5);
    }
    100% {
      -webkit-transform: scale(0);
    }
  }
</style>

<script>
new Vue({
  el: '#anim',
  data: { show: true }
})
</script>
{% endraw %}

## JavaScript Transitions

You can also use just the JavaScript hooks without defining any CSS rules. When using JavaScript only transitions, **the `done` callbacks are required for the `enter` and `leave` hooks**, otherwise they will be called synchronously and the transition will finish immediately.

It's also a good idea to explicitly declare `css: false` for your JavaScript transitions so that Vue.js can skip the CSS detection. This also prevents cascaded CSS rules from accidentally interfering with the transition.

The following example registers a custom JavaScript transition using jQuery:

``` js
Vue.transition('fade', {
  css: false,
  enter: function (el, done) {
    // 要素は既に DOM に挿入されており、
    // アニメーションが終わったとき、done は呼ばれます
    $(el)
      .css('opacity', 0)
      .animate({ opacity: 1 }, 1000, done)
  },
  enterCancelled: function (el) {
    $(el).stop()
  },
  leave: function (el, done) {
    // enter と同様
    $(el).animate({ opacity: 0 }, 1000, done)
  },
  leaveCancelled: function (el) {
    $(el).stop()
  }
})
```

Then you can use it with the `transition` attribute, same deal:

``` html
<p transition="fade"></p>
```
<p class="tip">もし JavaScript だけのトランジションを持った要素が、他の CSS トランジションまたはアニメーションが適用された場合、Vue のトランジションの検出は妨げられるかもしれません。そのような場合、 CSS 関連のトランジションを監視から Vue を明示的に無効にするためには、`css: false`を追加することができます。</p>

## Staggering Transitions

It's possible to create staggering transitions when using `transition` with `v-for`. You can do this either by adding a `stagger`, `enter-stagger` or `leave-stagger` attribute to your transitioned element:

``` html
<div v-repeat="list" transition stagger="100"></div>
```

または、より細かい制御のために、`stagger`、`enterStagger` または `leaveStagger` フックを提供することができます:

``` js
Vue.transition('stagger', {
  stagger: function (index) {
    // 各トランジションされた項目に対して 50ms 遅延を増加させ、
    // しかし最大遅延は 300ms に制限
    return Math.min(300, index * 50)
  }
})
```

例:

<iframe width="100%" height="200" style="margin-left:10px" src="http://jsfiddle.net/yyx990803/mvo99bse/embedded/result,html,js,css" allowfullscreen="allowfullscreen" frameborder="0"></iframe>
