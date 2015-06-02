title: Transitions
type: guide
order: 12
---

Vue.jsのトランジションシステムを使用すると、DOMから要素を取得したり削除するといったトランジションエフェクトを自動的に適用できます。これには、CSSトランジションやCSSアニメーションによる定義と、登録したカスタムJavaScriptを含む定義オブジェクトをフックする２つのオプションがあります。

`v-transition="my-transition"` というディレクティブを適用した場合：

1. `"my-transition"` のIDから、`Vue.transition(id, def)` または、`transitions` オプションを通じて登録されたJavaScriptのトランジションの定義を探します。定義が見つかると、カスタムJavaScriptベースのトランジションを実行します。

2. もし、カスタムJavaScriptによるトランジションが見つからなければ、対象の要素にCSSトランジションかCSSアニメーションが適用されているか調べ、適切なタイミングでCSSクラスを追加/削除します。

3. もし、CSSトランジションやCSSアニメーションも見つからなければ、次のフレームでDOM操作が実行されます。

<p class="tip">Vue.jsのすべてのトランジションは、内蔵のディレクティブ（ `v-if` など）や Vueのインスタンスメソッド（ `vm.$appendTo()` など）を通じてDOM操作が適用された時のみ実行されます。</p>

## CSSトランジション

基本的なCSSトランジションは、次のようになります。

``` html
<p class="msg" v-if="show" v-transition="expand">Hello!</p>
```

また `.expand-enter` クラスと `.expand-leave` クラスのCSSルールを定義する必要があります。

``` css
.msg {
  transition: all .3s ease;
  height: 30px;
  padding: 10px;
  background-color: #eee;
  overflow: hidden;
}
.msg.expand-enter, .msg.expand-leave {
  height: 0;
  padding: 0 10px;
  opacity: 0;
}
```

<div id="demo"><p class="msg" v-if="show" v-transition="expand">Hello!</p><button v-on="click: show = !show">Toggle</button></div>

<style>
.msg {
  transition: all .5s ease;
  height: 30px;
  background-color: #eee;
  overflow: hidden;
  padding: 10px;
  margin: 0 !important;
}
.msg.expand-enter, .msg.expand-leave {
  height: 0;
  padding: 0 10px;
  opacity: 0;
}
</style>

<script>
new Vue({
  el: '#demo',
  data: { show: true }
})
</script>

トグルするクラス名の接頭辞は、`v-transition`ディレクティブの値に基づきます。`v-transition="fade"`とした場合、トグルするクラス名の接頭辞は、`.fade-enter`と`.fade-leave`になります。`v-transition`だけで値がない場合は、`.v-enter`と`.v-leave`がデフォルトになります。

`show`プロパティに変更があると、それに応じてVue.jsは`<p>`要素を追加/削除し、以下に指定されているようにトランジションクラスを適用します。

- `show`プロパティが`false`の場合：
  1. `v-leave`クラスが対象の要素に適用され、トランジションが実行されます。
  2. トランジション終了を待ちます。（`transitionend`イベントを待機）
  3. DOMから対象の要素を削除し、`v-leave`クラスを削除します。

- `show`プロパティが`true`の場合：
  1. `v-enter`クラスが対象の要素に挿入されます。
  2. 対象の要素がDOMに追加されます。
  3. `v-enter`クラスのCSSレイアウトを対象の要素に適用します。
  4. `v-enter`クラスが削除され、対象の要素を元の状態に戻します。

<p class="tip">複数要素を同時にトランジションさせる場合、Vue.js はその要素をバッチにし、自動的に連続処理を行います。</p>

## CSSアニメーション

CSSアニメーションは、CSSトランジションと同じやり方で適用することができますが、対処の要素が追加された後、`animationend`がコールバックされるまで`v-enter`クラスが削除されないという違いがあります。

**例：** (CSSルールの記述は諸略)

``` html
<p class="animated" v-if="show" v-transition="bounce">Look at me!</p>
```

``` css
.animated {
  display: inline-block;
}
.animated.bounce-enter {
  animation: bounce-in .5s;
}
.animated.bounce-leave {
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

<div id="anim" class="demo"><span class="animated" v-if="show" v-transition="bounce">Look at me!</span><br><button v-on="click: show = !show">Toggle</button></div>

<style>
  .animated {
    display: inline-block;
  }
  .animated.bounce-enter {
    -webkit-animation: bounce-in .5s;
    animation: bounce-in .5s;
  }
  .animated.bounce-leave {
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

## JavaScript 関数

以下の例では、jQueryを使用してカスタムなJavaScriptトランジションの定義を登録します。

``` js
Vue.transition('fade', {
  beforeEnter: function (el) {
    // a synchronous function called right before the
    // element is inserted into the document.
    // you can do some pre-styling here to avoid
    // FOC (flash of content).
  },
  enter: function (el, done) {
    // element is already inserted into the DOM
    // call done when animation finishes.
    $(el)
      .css('opacity', 0)
      .animate({ opacity: 1 }, 1000, done)
    // optionally return a "cancel" function
    // to clean up if the animation is cancelled
    return function () {
      $(el).stop()
    }
  },
  leave: function (el, done) {
    // same as enter
    $(el).animate({ opacity: 0 }, 1000, done)
    return function () {
      $(el).stop()
    }
  }
})
```

上記のようなフック関数の全ては、それらの `this` コンテキストは関連付けられた Vue インスタンスを設定して呼び出されます。もし要素が Vue インスタンスのルートノードの場合、そのインスタンスはそのコンテキストとして使用されます。それ以外の場合は、そのコンテキストはトランジションディレクティブのインスタンスの所有者になります。

そして、`v-transition`のトランジションIDに値を渡すことで、この関数を使用することができます。JavaScriptによる定義は、CSSトランジションよりも優先順位が高いことに注意してください。

``` html
<p v-transition="fade"></p>
```

Next: [Building Larger Apps](/guide/application.html).
