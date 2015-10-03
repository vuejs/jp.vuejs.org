title: トランジションシステム
type: guide
order: 11
---

Vue.js のトランジションシステムを使用すると、DOM から要素を取得したり削除するといったトランジションエフェクトを自動的に適用できます。Vue.js は自動的に、適切な時に、あなたのために CSS トランジションまたはアニメーションをトリガするため、CSS クラスを追加または削除し、そしてトランジションの間は、カスタム DOM の操作をするために、JavaScript フック関数を提供することができます。

これには、CSS トランジションや CSS アニメーションによる定義と、登録したカスタム JavaScript を含む定義オブジェクトをフックする2つのオプションがあります。

`v-transition="my-transition"` というディレクティブを適用した場合：

1. `"my-transition"` の ID を使用して、`Vue.transition(id, hooks)` または、`transitions` オプションを通じて登録された JavaScript のトランジションのフックオブジェクトを探します。それが見つかると、さまざまな段階で、適切なフックを呼びます。

2. 自動的に、対象の要素に CSS トランジションか CSS アニメーションが適用されているか調べ、適切なタイミングで CSS クラスを追加/削除します。

3. もし、JavaScript フックが提供されていない、かつ CSS アニメーションも見つからなければ、次のフレームで直ちに DOM 操作(挿入/削除)が実行されます。

<p class="tip">Vue.js のすべてのトランジションは、内蔵のディレクティブ（ `v-if` など）や Vue のインスタンスメソッド（ `vm.$appendTo()` など）を通じて DOM 操作が適用された時のみ実行されます。</p>

## CSS トランジション

基本的な CSS トランジションは、次のようになります。

``` html
<div class="msg" v-if="show" v-transition="expand">hello!</div>
```

また `.expand-transition`クラス、`.expand-enter` クラスそして `.expand-leave` クラスの CSS ルールを定義する必要があります。

``` css
.expand-transition {
  transition: all .3s ease;
  height: 30px;
  padding: 10px;
  background-color: #eee;
  overflow: hidden;
}
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

<div id="demo"><div class="msg" v-if="show" v-transition="expand">Hello!</div><button v-on="click: show = !show">Toggle</button></div>

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

追加とトグルするクラス名の接頭辞は、`v-transition` ディレクティブの値に基づきます。`v-transition="fade"` と `.fade-transition` クラスと常に与えられた場合、トグルするクラス名の接頭辞は頃合いのよいときに自動的に、`.fade-enter` と`.fade-leave` になります。値がない場合は、`.v-transition`、`.v-enter`、そして `.v-leave` がデフォルトになります。

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

## CSS アニメーション

CSS アニメーションは、CSS トランジションと同じやり方で適用することができますが、対処の要素が追加された後、`animationend` がコールバックされるまで `v-enter` クラスが削除されないという違いがあります。

**例：** (CSS ルールの記述は諸略)

``` html
<span v-if="show" v-transition="bounce">Look at me!</span>
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

<div id="anim" class="demo"><span v-if="show" v-transition="bounce">Look at me!</span><br><button v-on="click: show = !show">Toggle</button></div>

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

## JavaScript だけによるトランジション

どんな CSS ルールの定義しなくても、JavaScript フックを利用することができます。JavaScript トランジションだけ利用するとき、`done` コールバックは `enter` と `leave` フック向けに必須とであり、そうでなければ、それらは同期的に呼ばれ、そしてトランジションはすぐに終了します。 以下の例では、jQuery を使用してカスタムな JavaScript トランジションの定義を登録します。

``` js
Vue.transition('fade', {
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

そして、`v-transition` のトランジションIDに値を渡すことで、この関数を使用することができます。同じ結果:

``` html
<p v-transition="fade"></p>
```
<p class="tip">もし JavaScript だけのトランジションを持った要素が、他の CSS トランジションまたはアニメーションが適用された場合、Vue のトランジションの検出は妨げられるかもしれません。そのような場合、 CSS 関連のトランジションを監視から Vue を明示的に無効にするためには、`css: false`を追加することができます。</p>

## スタガリングトランジション

`v-repeat` で `v-transition` を使用するとき、スタガリングトランジションを作成することが可能です。`stagger`、か `enter-stagger`、かまたは `leave-stagger` のいずれかの属性をトランジション要素に追加することによってこれをすることができます:

``` html
<div v-repeat="list" v-transition stagger="100"></div>
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

<iframe width="100%" height="200" style="margin-left:10px" src="http://jsfiddle.net/yyx990803/ujqrsu6w/embedded/result,html,js,css" allowfullscreen="allowfullscreen" frameborder="0"></iframe>

次: [大規模アプリケーションの構築](/guide/application.html)
