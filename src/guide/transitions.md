---
title: トランジション
type: guide
order: 11
---

Vue.js のトランジション (Transition) システムを使用すると、DOM から要素を取得したり削除するといったトランジションエフェクトを自動的に適用できます。Vue.js は自動的に、適切な時に、あなたのために CSS トランジションまたはアニメーションをトリガするため、CSS クラスを追加または削除し、そしてトランジションの間は、カスタム DOM の操作をするために、JavaScript フック関数を提供することができます。

トランジションエフェクトを適用するために、対象要素で特別な `transition` 属性を使用する必要があります:

``` html
<div v-if="show" transition="my-transition"></div>
```

`transition` 属性は以下と一緒に使用することができます:

- `v-if`
- `v-show`
- `v-for` (挿入および削除のみに対するトリガ)
- 動的コンポーネント([次のセクション](components.html#動的コンポーネント)で導入)
- コンポーネントのルートノード、そして Vue インスタンス の DOM メソッド経由によるトリガ(例、`vm.$appendTo(el)`)

トランジションを持つ要素が挿入または削除されるとき、Vue は以下となります:

`v-transition="my-transition"` というディレクティブを適用した場合：

1. `"my-transition"` の ID を使用して、`Vue.transition(id, hooks)` または、`transitions` オプションを通じて登録された JavaScript のトランジションのフックオブジェクトを探します。それが見つかると、さまざまな段階で、適切なフックを呼びます。

2. 自動的に、対象の要素に CSS トランジションか CSS アニメーションが適用されているか調べ、適切なタイミングで CSS クラスを追加/削除します。

3. JavaScript フックが何も提供されず、CSS トランジション/アニメーションが何も検出されない場合、DOM オペレーション (挿入/削除) は次のフレームで直ちに実行されます。

## CSS トランジション

### 例

基本的な CSS トランジションは、次のようになります。

``` html
<div v-if="show" transition="expand">hello</div>
```

また `.expand-transition`クラス、`.expand-enter` クラスそして `.expand-leave` クラスの CSS ルールを定義する必要があります。

``` css
/* 常に表示 */
.expand-transition {
  transition: all .3s ease;
  height: 30px;
  padding: 10px;
  background-color: #eee;
  overflow: hidden;
}

/* .expand-enter は entering に対する開始状態を定義 */
/* .expand-leave は leaving に対する終了状態を定義 */
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

### トランジション CSS クラス

追加とトグルするクラス名の接頭辞は、`transition` 属性の値に基づきます。`transition="fade"` のケースでは、 3 つの CSS クラスが関与しています:

1. `.fade-transition` クラスは常に与えられます。

2. `.fade-enter` は、entering transition (トランジションに入っている)の開始状態を定義します。単一のフレームに適用した後に、すぐに削除されます。

3. `.fade-leave` は、leaving transition (トランジションから離れている)の終了状態を定義します。leaving transition が開始するときに適用され、トランジションが終了するときに削除されます。

`transition` が値を持たいない場合は、クラスはデフォルトで `.v-transition` 、`.v-enter` そして `v-leave` になります。

### カスタムトランジションクラス

> 1.0.14 で新規追加

トランジション定義でカスタムな `enterClass` と `leaveClass` を指定できます。これらは従来型のクラス名を上書きします。[Animate.css](https://daneden.github.io/animate.css/) の例のような、既に存在する CSS アニメーションライブラリで Vue のトランジションシステムに結合したい時は役に立ちます。

``` html
<div v-show="ok" class="animated" transition="bounce">Watch me bounce</div>
```

``` js
Vue.transition('bounce', {
  enterClass: 'bounceInLeft',
  leaveClass: 'bounceOutRight'
})
```

### トランジションタイプの宣言

> 1.0.14 で新規追加

Vue.js はトランジションが終了したのを知るためにイベントリスナにアタッチする必要があります。適当される CSS ルールのタイプ (type) に応じて、`transitionend` か `animationend` のどちらかできます。1 つだけまたは他のルールを適用したい場合は、Vue.js は自動的に正しいタイプを検出することができます。例えば CSS アニメーションが Vue によってトリガされ、ホバー (hover) において CSS トランジションエフェクトも持っているような、いくつかのケースで同じ要素で両方を持ちたい場合は、明示的に以下のようなタイプを宣言する必要があります。

``` js
Vue.transition('bounce', {
  // Vue はこのトランジションに対して直ちに
  // `animationend` イベントだけに気にかけるようになります
  type: 'animation'
})
```

### トランジションフローの詳細

`show` プロパティに変更があると、それに応じて Vue.js は `<div>` 要素を追加/削除し、以下に指定されているようにトランジションクラスを適用します。

- `show` プロパティが `false` の場合：
  1. `beforeLeave` フックを呼びます。
  2. `v-leave` クラスを要素に適用し、トランジションをトリガします。
  3. `leave` フックを呼びます。
  4. トランジションが終わるまで待ちます(`transitionend` イベントをリスニングします)。
  5. DOM から要素と `v-leave` を削除します。
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

最後に、`enter` と `leave` は、必要に応じて、第2引数にコールバックを取ることができます。これを行うと、トランジションが終了すべきときに明示的に制御したいと示しているため、CSS の `transitionend`イベントを待ち受ける代わりに、Vue.js は最終的にトランジションを完了するためにコールバックを呼びだすことを期待します。例えば:

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

### CSS アニメーション

CSS アニメーションは、CSS トランジションと同じやり方で適用することができますが、対象の要素が追加された後、`animationend` がコールバックされるまで `v-enter` クラスが削除されないという違いがあります。

例： (CSS ルールの記述は省略)

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

## JavaScript トランジション

どんな CSS ルールの定義しなくても、JavaScript フックを利用することができます。JavaScript トランジションだけ利用するとき、**`done` コールバックは `enter` と `leave` フック向けに必須とであり**、そうでなければ、それらは同期的に呼ばれ、そしてトランジションはすぐに終了します。

Vue.js は CSS の検出をスキップできるため、あなたの JavaScript トランジションに対して明示的に `css: false` を宣言することもよいアイディアです。これは、トランジションによる偶発的な干渉からカスケードされる CSS ルールも防止します。

以下の例では、jQuery を使用してカスタムな JavaScript トランジションの定義を登録します:

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

次に、`transition` 属性によってそれ使用するとき、同じ結果になります:

``` html
<p transition="fade"></p>
```

## スタガリングトランジション

`v-for` で `transition` を使用するとき、スタガリングトランジションを作成することが可能です。`stagger`、か `enter-stagger`、かまたは `leave-stagger` のいずれかの属性をトランジション要素に追加することによってこれをすることができます:

``` html
<div v-for="list" transition stagger="100"></div>
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
