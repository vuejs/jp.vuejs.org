---
title: Enter/Leave とトランジション一覧
updated: 2018-05-23
type: guide
order: 201
---

# 概要

Vue は、DOM からアイテムが追加、更新、削除されたときにトランジション効果を適用するための方法を複数提供しています:

- 自動的に CSS トランジションやアニメーションのためのクラスを適用します。
- Animate.css のようなサードパーティの CSS アニメーションライブラリと連携します。
- トランジションフックが実行されている間、JavaScript を使って直接 DOM 操作を行います。
- Velocity.js のようなサードパーティの JavaScript アニメーションライブラリと連携します。

このページでは、entering/leaving によるリストのトランジションについて扱いますが、次の章では、[状態のトランジション](transitioning-state.html) について扱います。

## 単一要素/コンポーネントのトランジション

Vue は、`transition` ラッパーコンポーネントを提供しています。このコンポーネントは、次のコンテキストにある要素やコンポーネントに entering/leaving トランジションを追加することを可能にします:

- 条件付きの描画 (`v-if` を使用)
- 条件付きの表示 (`v-show` を利用)
- 動的コンポーネント
- コンポーネントルートノード (Component root nodes)

これは、アクションのように見える非常にシンプルな例です:

``` html
<div id="demo">
  <button v-on:click="show = !show">
    Toggle
  </button>
  <transition name="fade">
    <p v-if="show">hello</p>
  </transition>
</div>
```

``` js
new Vue({
  el: '#demo',
  data: {
    show: true
  }
})
```

``` css
.fade-enter-active, .fade-leave-active {
  transition: opacity .5s;
}
.fade-enter, .fade-leave-to /* .fade-leave-active below version 2.1.8 */ {
  opacity: 0;
}
```

{% raw %}
<div id="demo">
  <button v-on:click="show = !show">
    Toggle
  </button>
  <transition name="demo-transition">
    <p v-if="show">hello</p>
  </transition>
</div>
<script>
new Vue({
  el: '#demo',
  data: {
    show: true
  }
})
</script>
<style>
.demo-transition-enter-active, .demo-transition-leave-active {
  transition: opacity .5s
}
.demo-transition-enter, .demo-transition-leave-to {
  opacity: 0
}
</style>
{% endraw %}

`transition` コンポーネントにラップされた要素が挿入あるいは削除されるとき、次のことが行われます:

1. Vue は、対象の要素が CSS トランジションあるいはアニメーションが適用されるか自動的に察知します。それがない場合、適切なタイミングで、CSS トランジションのクラスを追加/削除します。

2. もし、トランジションコンポーネントが [JavaScript フック](#JavaScript-フック) を提供している場合は、適切なタイミングでそれらのフックが呼ばれます。

3. もし、CSS トランジション/アニメーションが検出されず、JavaScript フックも提供されない場合、挿入、削除のいずれか、あるいは両方の DOM 操作を次のフレームでただちに実行します。(注意: ここでのフレームはブラウザのアニメーションフレームを指します。 Vue の `nextTick` のコンセプトのそれとは異なるものです)

### トランジションクラス

これらは、enter/leave トランジションのために適用される 6 つのクラスです。

1. `v-enter`: enter の開始状態。要素が挿入される前に適用され、要素が挿入された 1 フレーム後に削除されます。
2. `v-enter-active`: enter の活性状態。トランジションに入るフェーズ中に適用されます。要素が挿入される前に追加され、トランジション/アニメーションが終了すると削除されます。このクラスは、トランジションの開始に対して、期間、遅延、およびイージングカーブを定義するために使用できます。
3. `v-enter-to`: **バージョン 2.1.8 以降でのみ利用可能です。** enter の終了状態です。要素が挿入後 (同時に `v-enter` が削除されます) 1 フレームが追加されます。トランジション/アニメーションが終了すると削除されます。
4. `v-leave`: leave の開始状態。トランジションの終了がトリガされるとき、直ちに追加され、1フレーム後に削除されます。
5. `v-leave-active`: leave の活性状態。トランジションが終わるフェーズ中に適用されます。leave トランジションがトリガされるとき、直ちに追加され、トランジション/アニメーションが終了すると削除されます。このクラスは、トランジションの終了に対して、期間、遅延、およびイージングカーブを定義するために使用できます。
6. `v-leave-to`: **バージョン 2.1.8 以降でのみ利用可能です。** leave の終了状態です。トランジションの終了がトリガされた後 (同時に `v-leave` が削除されます) 1 フレームが追加されます。トランジション/アニメーションが終了すると削除されます。

![トランジションダイアグラム](/images/transition.png)

各クラスは、トランジションの名前が先頭に付きます。`<transition>` 要素に名前がない場合は、デフォルトで `v-` が先頭に付きます。例えば、`<transition name="my-transition">` の場合は、`v-enter` クラスではなく、`my-transition-enter` となります。

`v-enter-active` と `v-leave-active` は、次のセクションの例で見ることができるような、enter/leave トランジションで異なるイージングカーブの指定を可能にします。

### CSS トランジション

トランジションを実現する最も一般な方法として、CSS トランジションを使います。これはシンプルな例です:

``` html
<div id="example-1">
  <button @click="show = !show">
    Toggle render
  </button>
  <transition name="slide-fade">
    <p v-if="show">hello</p>
  </transition>
</div>
```

``` js
new Vue({
  el: '#example-1',
  data: {
    show: true
  }
})
```

``` css
/* enter、 leave アニメーションで異なる間隔やタイミング関数を利用することができます */
.slide-fade-enter-active {
  transition: all .3s ease;
}
.slide-fade-leave-active {
  transition: all .8s cubic-bezier(1.0, 0.5, 0.8, 1.0);
}
.slide-fade-enter, .slide-fade-leave-to
/* .slide-fade-leave-active below version 2.1.8 */ {
  transform: translateX(10px);
  opacity: 0;
}
```

{% raw %}
<div id="example-1" class="demo">
  <button @click="show = !show">
    Toggle render
  </button>
  <transition name="slide-fade">
    <p v-if="show">hello</p>
  </transition>
</div>
<script>
new Vue({
  el: '#example-1',
  data: {
    show: true
  }
})
</script>
<style>
.slide-fade-enter-active {
  transition: all .3s ease;
}
.slide-fade-leave-active {
  transition: all .8s cubic-bezier(1.0, 0.5, 0.8, 1.0);
}
.slide-fade-enter, .slide-fade-leave-to {
  transform: translateX(10px);
  opacity: 0;
}
</style>
{% endraw %}

### CSS アニメーション

CSS アニメーションは、CSS トランジションと同じように適用されますが、異なるのは `v-enter` が要素が挿入された直後に削除されないことです。しかし、`animationend` イベント時には削除されています。

これは簡潔にするために CSS ルールの接頭辞を除いた例です。

``` html
<div id="example-2">
  <button @click="show = !show">Toggle show</button>
  <transition name="bounce">
    <p v-if="show">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris facilisis enim libero, at lacinia diam fermentum id. Pellentesque habitant morbi tristique senectus et netus.</p>
  </transition>
</div>
```

``` js
new Vue({
  el: '#example-2',
  data: {
    show: true
  }
})
```

``` css
.bounce-enter-active {
  animation: bounce-in .5s;
}
.bounce-leave-active {
  animation: bounce-in .5s reverse;
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
```

{% raw %}
<div id="example-2" class="demo">
  <button @click="show = !show">Toggle show</button>
  <transition name="bounce">
    <p v-show="show">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris facilisis enim libero, at lacinia diam fermentum id. Pellentesque habitant morbi tristique senectus et netus.</p>
  </transition>
</div>

<style>
  .bounce-enter-active {
    -webkit-animation: bounce-in .5s;
    animation: bounce-in .5s;
  }
  .bounce-leave-active {
    -webkit-animation: bounce-in .5s reverse;
    animation: bounce-in .5s reverse;
  }
  @keyframes bounce-in {
    0% {
      -webkit-transform: scale(0);
      transform: scale(0);
    }
    50% {
      -webkit-transform: scale(1.5);
      transform: scale(1.5);
    }
    100% {
      -webkit-transform: scale(1);
      transform: scale(1);
    }
  }
  @-webkit-keyframes bounce-in {
    0% {
      -webkit-transform: scale(0);
      transform: scale(0);
    }
    50% {
      -webkit-transform: scale(1.5);
      transform: scale(1.5);
    }
    100% {
      -webkit-transform: scale(1);
      transform: scale(1);
    }
  }
</style>
<script>
new Vue({
  el: '#example-2',
  data: {
    show: true
  }
})
</script>
{% endraw %}

### カスタムトランジションクラス

次の属性で、カスタムトランジションクラスを指定できます:

- `enter-class`
- `enter-active-class`
- `enter-to-class` (2.1.8 以降のみ)
- `leave-class`
- `leave-active-class`
- `leave-to-class` (2.1.8 以降のみ)

これらは、クラス名の規約を上書きします。これは、Vue のトランジションシステムと [Animate.css](https://daneden.github.io/animate.css/) のような既存の CSS アニメーションライブラリを組み合わせたいときに特に便利です。

これが例になります:

``` html
<link href="https://cdn.jsdelivr.net/npm/animate.css@3.5.1" rel="stylesheet" type="text/css">

<div id="example-3">
  <button @click="show = !show">
    Toggle render
  </button>
  <transition
    name="custom-classes-transition"
    enter-active-class="animated tada"
    leave-active-class="animated bounceOutRight"
  >
    <p v-if="show">hello</p>
  </transition>
</div>
```

``` js
new Vue({
  el: '#example-3',
  data: {
    show: true
  }
})
```

{% raw %}
<link href="https://cdn.jsdelivr.net/npm/animate.css@3.5.1" rel="stylesheet" type="text/css">
<div id="example-3" class="demo">
  <button @click="show = !show">
    Toggle render
  </button>
  <transition
    name="custom-classes-transition"
    enter-active-class="animated tada"
    leave-active-class="animated bounceOutRight"
  >
    <p v-if="show">hello</p>
  </transition>
</div>
<script>
new Vue({
  el: '#example-3',
  data: {
    show: true
  }
})
</script>
{% endraw %}

### トランジションとアニメーションを両方使う

Vue はトランジションが終了したことを把握するためのイベントリスナのアタッチを必要とします。イベントは、適用される CSS ルールに応じて `transitionend` か `animationend` のいずれかのタイプになります。あなたがトランジションとアニメーション、どちらか一方だけ使用する場合は、Vue は自動的に正しいタイプを判断することができます。

しかし、例えば、ホバーの CSS トランジション効果と Vue による CSS アニメーションのトリガの両方を持つ場合など、時には、同じ要素に両方を使うこともあるかもしれません。これらのケースでは、Vue に扱って欲しいタイプを `type` 属性で明示的に宣言するべきでしょう。この属性の値は、`animation` あるいは `transition` を取ります。

### 明示的なトランジション期間の設定

> 2.2.0 から新規

ほとんどの場合、 Vue は、自動的にトランジションが終了したことを見つけ出すことは可能です。デフォルトでは、 Vue はルート要素の初めの `transitionend` もしくは `animationend` イベントを待ちます。しかし、これが常に望む形とは限りません。例えば、幾つかの入れ子となっている内部要素にてトランジションの遅延がある場合や、ルートのトランジション要素よりも非常に長いトランジション期間を設けている場合の、一連のトランジションのまとまりなどです。

このような場合 `<transition>` コンポーネントがもつ `duration` プロパティを利用することで、明示的に遷移にかかる時間（ミリ秒単位）を指定することが可能です:

```html
<transition :duration="1000">...</transition>
```

また、活性化時と終了時の期間を、個別に指定することも可能です:

```html
<transition :duration="{ enter: 500, leave: 800 }">...</transition>
```

### JavaScript フック

属性で JavaScript フックを定義することができます:

``` html
<transition
  v-on:before-enter="beforeEnter"
  v-on:enter="enter"
  v-on:after-enter="afterEnter"
  v-on:enter-cancelled="enterCancelled"

  v-on:before-leave="beforeLeave"
  v-on:leave="leave"
  v-on:after-leave="afterLeave"
  v-on:leave-cancelled="leaveCancelled"
>
  <!-- ... -->
</transition>
```

``` js
// ...
methods: {
  // --------
  // ENTERING
  // --------

  beforeEnter: function (el) {
    // ...
  },
  // CSS と組み合わせて使う時、done コールバックはオプションです
  enter: function (el, done) {
    // ...
    done()
  },
  afterEnter: function (el) {
    // ...
  },
  enterCancelled: function (el) {
    // ...
  },

  // --------
  // LEAVING
  // --------

  beforeLeave: function (el) {
    // ...
  },
  // CSS と組み合わせて使う時、done コールバックはオプションです
  leave: function (el, done) {
    // ...
    done()
  },
  afterLeave: function (el) {
    // ...
  },
  // v-show と共に使うときだけ leaveCancelled は有効です
  leaveCancelled: function (el) {
    // ...
  }
}
```

これらのフックは、CSS トランジション/アニメーション、または別の何かと組み合わせて使うことができます。

<p class="tip">JavaScript のみを利用したトランジションの場合は、**`done` コールバックを `enter` と `leave` フックで呼ぶ必要があります**。呼ばない場合は、フックは同期的に呼ばれ、トランジションはただちに終了します。</p>

<p class="tip">JavaScript のみのトランジションのために明示的に `v-bind:css="false"` を追加するのは良いアイデアです。これは、Vue に CSS 判定をスキップさせます。また、誤って CSS ルールがトランジションに干渉するのを防ぎます。</p>

今から例をみていきましょう。これは Velocity.js を使ったシンプルな JavaScript トランジションの例です:

``` html
<!--
Velocity は jQuery.animate と非常によく似ています。
JavaScript アニメーションのための良い選択です。
-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/velocity/1.2.3/velocity.min.js"></script>

<div id="example-4">
  <button @click="show = !show">
    Toggle
  </button>
  <transition
    v-on:before-enter="beforeEnter"
    v-on:enter="enter"
    v-on:leave="leave"
    v-bind:css="false"
  >
    <p v-if="show">
      Demo
    </p>
  </transition>
</div>
```

``` js
new Vue({
  el: '#example-4',
  data: {
    show: false
  },
  methods: {
    beforeEnter: function (el) {
      el.style.opacity = 0
    },
    enter: function (el, done) {
      Velocity(el, { opacity: 1, fontSize: '1.4em' }, { duration: 300 })
      Velocity(el, { fontSize: '1em' }, { complete: done })
    },
    leave: function (el, done) {
      Velocity(el, { translateX: '15px', rotateZ: '50deg' }, { duration: 600 })
      Velocity(el, { rotateZ: '100deg' }, { loop: 2 })
      Velocity(el, {
        rotateZ: '45deg',
        translateY: '30px',
        translateX: '30px',
        opacity: 0
      }, { complete: done })
    }
  }
})
```

{% raw %}
<div id="example-4" class="demo">
  <button @click="show = !show">
    Toggle
  </button>
  <transition
    v-on:before-enter="beforeEnter"
    v-on:enter="enter"
    v-on:leave="leave"
  >
    <p v-if="show">
      Demo
    </p>
  </transition>
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/velocity/1.2.3/velocity.min.js"></script>
<script>
new Vue({
  el: '#example-4',
  data: {
    show: false
  },
  methods: {
    beforeEnter: function (el) {
      el.style.opacity = 0
      el.style.transformOrigin = 'left'
    },
    enter: function (el, done) {
      Velocity(el, { opacity: 1, fontSize: '1.4em' }, { duration: 300 })
      Velocity(el, { fontSize: '1em' }, { complete: done })
    },
    leave: function (el, done) {
      Velocity(el, { translateX: '15px', rotateZ: '50deg' }, { duration: 600 })
      Velocity(el, { rotateZ: '100deg' }, { loop: 2 })
      Velocity(el, {
        rotateZ: '45deg',
        translateY: '30px',
        translateX: '30px',
        opacity: 0
      }, { complete: done })
    }
  }
})
</script>
{% endraw %}

## 初期描画時のトランジション

ノードの初期描画時にトランジションを適用したい場合は、`appear` 属性を追加することができます:

``` html
<transition appear>
  <!-- ... -->
</transition>
```

デフォルトで、これは entering と leaving のために指定されたトランジションが使用されます。あるいは、カスタム CSS クラスを指定することもできます:

``` html
<transition
  appear
  appear-class="custom-appear-class"
  appear-to-class="custom-appear-to-class" (2.1.8 以降から)
  appear-active-class="custom-appear-active-class"
>
  <!-- ... -->
</transition>
```

そして、カスタム JavaScript フックも指定できます:

``` html
<transition
  appear
  v-on:before-appear="customBeforeAppearHook"
  v-on:appear="customAppearHook"
  v-on:after-appear="customAfterAppearHook"
  v-on:appear-cancelled="customAppearCancelledHook"
>
  <!-- ... -->
</transition>
```

## 要素間のトランジション

あとで [コンポーネント間のトランジション](#コンポーネント間のトランジション) について説明しますが、`v-if`/`v-else` を使った通常の要素同士でもトランジションできます。最も共通の2つの要素のトランジションの例として、リストコンテナとリストが空と説明するメッセージの間で行うものがあります:

``` html
<transition>
  <table v-if="items.length > 0">
    <!-- ... -->
  </table>
  <p v-else>Sorry, no items found.</p>
</transition>
```

これは動きますが、注意すべき点がひとつあります:

<p class="tip">**同じタグ名**を持つ要素同士でトグルするとき、それらに `key` 属性を指定することで、個別の要素であることを Vue に伝えなければいけません。そうしないと、 Vue のコンパイラは効率化のために要素の内容だけを置き換えようとします。技術的には不要な場合でも、**常に `<transition>` コンポーネント内の複数のアイテムを区別しようとすることは、よい習慣です**</p>

例:

``` html
<transition>
  <button v-if="isEditing" key="save">
    Save
  </button>
  <button v-else key="edit">
    Edit
  </button>
</transition>
```

このケースでは、他にも `key` 属性を同一要素の異なる状態のトランジションのために使うこともできます。`v-if` と `v-else` を使う代わりに、以下のように書きかえることができます:

``` html
<transition>
  <button v-bind:key="isEditing">
    {{ isEditing ? 'Save' : 'Edit' }}
  </button>
</transition>
```

`v-if` を複数使ったり、ひとつの要素に対して動的プロパティでバインディングを行ういずれの場合でも、複数個の要素を対象にトランジションすることが可能です。例:

``` html
<transition>
  <button v-if="docState === 'saved'" key="saved">
    Edit
  </button>
  <button v-if="docState === 'edited'" key="edited">
    Save
  </button>
  <button v-if="docState === 'editing'" key="editing">
    Cancel
  </button>
</transition>
```

このようにも書き換えることもできます:

``` html
<transition>
  <button v-bind:key="docState">
    {{ buttonMessage }}
  </button>
</transition>
```

``` js
// ...
computed: {
  buttonMessage: function () {
    switch (this.docState) {
      case 'saved': return 'Edit'
      case 'edited': return 'Save'
      case 'editing': return 'Cancel'
    }
  }
}
```

### トランジションモード

まだひとつ問題が残っています。以下のボタンをクリックしてください:

{% raw %}
<div id="no-mode-demo" class="demo">
  <transition name="no-mode-fade">
    <button v-if="on" key="on" @click="on = false">
      on
    </button>
    <button v-else key="off" @click="on = true">
      off
    </button>
  </transition>
</div>
<script>
new Vue({
  el: '#no-mode-demo',
  data: {
    on: false
  }
})
</script>
<style>
.no-mode-fade-enter-active, .no-mode-fade-leave-active {
  transition: opacity .5s
}
.no-mode-fade-enter, .no-mode-fade-leave-active {
  opacity: 0
}
</style>
{% endraw %}

それは、"on" ボタンと "off" ボタン間でトランジションを行うとき、片方のボタンがトランジションアウトして、別の片方がトランジションインするとき、両方のボタンが描画されてしまうことです。これは、`<transition>` のデフォルトの振る舞いです - entering と leaving は同時に起きます。

時には、これで問題なく、うまく動作する場合があります。例えば、位置が絶対位置で指定されているアイテムのトランジションを行うような場合です:

{% raw %}
<div id="no-mode-absolute-demo" class="demo">
  <div class="no-mode-absolute-demo-wrapper">
    <transition name="no-mode-absolute-fade">
      <button v-if="on" key="on" @click="on = false">
        on
      </button>
      <button v-else key="off" @click="on = true">
        off
      </button>
    </transition>
  </div>
</div>
<script>
new Vue({
  el: '#no-mode-absolute-demo',
  data: {
    on: false
  }
})
</script>
<style>
.no-mode-absolute-demo-wrapper {
  position: relative;
  height: 18px;
}
.no-mode-absolute-demo-wrapper button {
  position: absolute;
}
.no-mode-absolute-fade-enter-active, .no-mode-absolute-fade-leave-active {
  transition: opacity .5s;
}
.no-mode-absolute-fade-enter, .no-mode-absolute-fade-leave-active {
  opacity: 0;
}
</style>
{% endraw %}

また、スライドのようなトランジションを行う場合も同様です:

{% raw %}
<div id="no-mode-translate-demo" class="demo">
  <div class="no-mode-translate-demo-wrapper">
    <transition name="no-mode-translate-fade">
      <button v-if="on" key="on" @click="on = false">
        on
      </button>
      <button v-else key="off" @click="on = true">
        off
      </button>
    </transition>
  </div>
</div>
<script>
new Vue({
  el: '#no-mode-translate-demo',
  data: {
    on: false
  }
})
</script>
<style>
.no-mode-translate-demo-wrapper {
  position: relative;
  height: 18px;
}
.no-mode-translate-demo-wrapper button {
  position: absolute;
}
.no-mode-translate-fade-enter-active, .no-mode-translate-fade-leave-active {
  transition: all 1s;
}
.no-mode-translate-fade-enter, .no-mode-translate-fade-leave-active {
  opacity: 0;
}
.no-mode-translate-fade-enter {
  transform: translateX(31px);
}
.no-mode-translate-fade-leave-active {
  transform: translateX(-31px);
}
</style>
{% endraw %}

ただ、同時に entering と leaving が行われることは必ずしも望ましくないこともあります。このために Vue は代替となる **トランジションモード ** を提供しています:

- `in-out`: 最初に新しい要素がトランジションして、それが完了したら、現在の要素がトランジションアウトする。

- `out-in`: 最初に現在の要素がトランジションアウトして、それが完了したら、新しい要素がトランジションインする。

今から、`out-in` を使って、先程の on/off ボタンのトランジションを書き換えてみましょう:

``` html
<transition name="fade" mode="out-in">
  <!-- ... the buttons ... -->
</transition>
```

{% raw %}
<div id="with-mode-demo" class="demo">
  <transition name="with-mode-fade" mode="out-in">
    <button v-if="on" key="on" @click="on = false">
      on
    </button>
    <button v-else key="off" @click="on = true">
      off
    </button>
  </transition>
</div>
<script>
new Vue({
  el: '#with-mode-demo',
  data: {
    on: false
  }
})
</script>
<style>
.with-mode-fade-enter-active, .with-mode-fade-leave-active {
  transition: opacity .5s
}
.with-mode-fade-enter, .with-mode-fade-leave-active {
  opacity: 0
}
</style>
{% endraw %}

特別なスタイルの追加無しで、ひとつのシンプルな属性を追加するだけでオリジナルのトランジションを修正できました。

`in-out` モードは使用されることは多くありませんが、微妙に異なるトランジション効果を実現するために有用です。前の例のスライドフェードトランジションと組み合わせてみましょう:

{% raw %}
<div id="in-out-translate-demo" class="demo">
  <div class="in-out-translate-demo-wrapper">
    <transition name="in-out-translate-fade" mode="in-out">
      <button v-if="on" key="on" @click="on = false">
        on
      </button>
      <button v-else key="off" @click="on = true">
        off
      </button>
    </transition>
  </div>
</div>
<script>
new Vue({
  el: '#in-out-translate-demo',
  data: {
    on: false
  }
})
</script>
<style>
.in-out-translate-demo-wrapper {
  position: relative;
  height: 18px;
}
.in-out-translate-demo-wrapper button {
  position: absolute;
}
.in-out-translate-fade-enter-active, .in-out-translate-fade-leave-active {
  transition: all .5s;
}
.in-out-translate-fade-enter, .in-out-translate-fade-leave-active {
  opacity: 0;
}
.in-out-translate-fade-enter {
  transform: translateX(31px);
}
.in-out-translate-fade-leave-active {
  transform: translateX(-31px);
}
</style>
{% endraw %}

かなり良いと思いませんか？

## コンポーネント間のトランジション

コンポーネント間のトランジションは、 `key` 属性が必要ではないのでさらに単純です。代わりに、ただ [動的コンポーネント](components.html#動的コンポーネント) でラップするだけです:

``` html
<transition name="component-fade" mode="out-in">
  <component v-bind:is="view"></component>
</transition>
```

``` js
new Vue({
  el: '#transition-components-demo',
  data: {
    view: 'v-a'
  },
  components: {
    'v-a': {
      template: '<div>Component A</div>'
    },
    'v-b': {
      template: '<div>Component B</div>'
    }
  }
})
```

``` css
.component-fade-enter-active, .component-fade-leave-active {
  transition: opacity .3s ease;
}
.component-fade-enter, .component-fade-leave-to
/* .component-fade-leave-active for below version 2.1.8 */ {
  opacity: 0;
}
```

{% raw %}
<div id="transition-components-demo" class="demo">
  <input v-model="view" type="radio" value="v-a" id="a" name="view"><label for="a">A</label>
  <input v-model="view" type="radio" value="v-b" id="b" name="view"><label for="b">B</label>
  <transition name="component-fade" mode="out-in">
    <component v-bind:is="view"></component>
  </transition>
</div>
<style>
.component-fade-enter-active, .component-fade-leave-active {
  transition: opacity .3s ease;
}
.component-fade-enter, .component-fade-leave-to {
  opacity: 0;
}
</style>
<script>
new Vue({
  el: '#transition-components-demo',
  data: {
    view: 'v-a'
  },
  components: {
    'v-a': {
      template: '<div>Component A</div>'
    },
    'v-b': {
      template: '<div>Component B</div>'
    }
  }
})
</script>
{% endraw %}

## リストトランジション

ここまでで、次のトランジションを扱えるようになりました:

- 独立したノード
- 一度に 1 つのみ描画される複数ノード

それでは、例えば、`v-for` のように同時に描画したいリストのアイテムがある場合はどうすればよいでしょう？この場合は、`<transition-group>` コンポーネントを使うことができます。例を詳しく見ていく前に、このコンポーネントについて知っておくべき幾つかの重要なことをあげておきましょう。

- `<transition>` と異なり、実際に要素を描画する: `<span>` がデフォルトです。この要素は、`tag` 属性で変えることができます。
- [トランジションモード](#トランジションモード) は利用できません。もはや相互に排他的な要素を交互に利用する事が無いためです。
- 中の要素は、`key` 属性を持つことが **必須** です。

### リスト Entering/Leaving トランジション

では、シンプルな例をみていきましょう。これまでに使っていたものと同じ CSS クラスを entering と leaving のトランジションで使います:

``` html
<div id="list-demo">
  <button v-on:click="add">Add</button>
  <button v-on:click="remove">Remove</button>
  <transition-group name="list" tag="p">
    <span v-for="item in items" v-bind:key="item" class="list-item">
      {{ item }}
    </span>
  </transition-group>
</div>
```

``` js
new Vue({
  el: '#list-demo',
  data: {
    items: [1,2,3,4,5,6,7,8,9],
    nextNum: 10
  },
  methods: {
    randomIndex: function () {
      return Math.floor(Math.random() * this.items.length)
    },
    add: function () {
      this.items.splice(this.randomIndex(), 0, this.nextNum++)
    },
    remove: function () {
      this.items.splice(this.randomIndex(), 1)
    },
  }
})
```

``` css
.list-item {
  display: inline-block;
  margin-right: 10px;
}
.list-enter-active, .list-leave-active {
  transition: all 1s;
}
.list-enter, .list-leave-to /* .list-leave-active for below version 2.1.8 */ {
  opacity: 0;
  transform: translateY(30px);
}
```

{% raw %}
<div id="list-demo" class="demo">
  <button v-on:click="add">Add</button>
  <button v-on:click="remove">Remove</button>
  <transition-group name="list" tag="p">
    <span v-for="item in items" :key="item" class="list-item">
      {{ item }}
    </span>
  </transition-group>
</div>
<script>
new Vue({
  el: '#list-demo',
  data: {
    items: [1,2,3,4,5,6,7,8,9],
    nextNum: 10
  },
  methods: {
    randomIndex: function () {
      return Math.floor(Math.random() * this.items.length)
    },
    add: function () {
      this.items.splice(this.randomIndex(), 0, this.nextNum++)
    },
    remove: function () {
      this.items.splice(this.randomIndex(), 1)
    },
  }
})
</script>
<style>
.list-item {
  display: inline-block;
  margin-right: 10px;
}
.list-enter-active, .list-leave-active {
  transition: all 1s;
}
.list-enter, .list-leave-to {
  opacity: 0;
  transform: translateY(30px);
}
</style>
{% endraw %}

この例にはひとつ問題があります。アイテムを追加、削除するとき、周りのアイテムはスムーズにトランジションするのではなく、新しい位置にカチッと収まってしまうことです。それは後ほど修正します。

### リスト移動トランジション

`<transition-group>` コンポーネントは、別の秘策を持っています。 entering と leaving のアニメーションだけでなく、位置の変化も同様にアニメーションできます。この新しい機能を使うために知らないといけない新しいコンセプトは、アイテムの位置が変わる時に追加される**`v-move` クラス**だけです。他のクラスと同様に、接頭辞は `name` 属性値と一致しますし、`move-class` 属性でクラスを指定することもできます。

以下で分かるように、このクラスは主にトランジションのタイミングやイージングカーブを指定するのに便利です:

``` html
<script src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.14.1/lodash.min.js"></script>

<div id="flip-list-demo" class="demo">
  <button v-on:click="shuffle">Shuffle</button>
  <transition-group name="flip-list" tag="ul">
    <li v-for="item in items" v-bind:key="item">
      {{ item }}
    </li>
  </transition-group>
</div>
```

``` js
new Vue({
  el: '#flip-list-demo',
  data: {
    items: [1,2,3,4,5,6,7,8,9]
  },
  methods: {
    shuffle: function () {
      this.items = _.shuffle(this.items)
    }
  }
})
```

``` css
.flip-list-move {
  transition: transform 1s;
}
```

{% raw %}
<script src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.14.1/lodash.min.js"></script>
<div id="flip-list-demo" class="demo">
  <button v-on:click="shuffle">Shuffle</button>
  <transition-group name="flip-list" tag="ul">
    <li v-for="item in items" :key="item">
      {{ item }}
    </li>
  </transition-group>
</div>
<script>
new Vue({
  el: '#flip-list-demo',
  data: {
    items: [1,2,3,4,5,6,7,8,9]
  },
  methods: {
    shuffle: function () {
      this.items = _.shuffle(this.items)
    }
  }
})
</script>
<style>
.flip-list-move {
  transition: transform 1s;
}
</style>
{% endraw %}

これは魔法のように見えるかもしれませんが、内部で Vue は transforms を使って、前の位置から新しい位置へ要素を滑らかにトランジションさせるために [FLIP](https://aerotwist.com/blog/flip-your-animations/) と呼ばれる単純なアニメーションテクニックを使っています。

これまでの実装とこのテクニックを組み合わせることで、リストに対する全ての変更をアニメーションさせることができます！

``` html
<script src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.14.1/lodash.min.js"></script>

<div id="list-complete-demo" class="demo">
  <button v-on:click="shuffle">Shuffle</button>
  <button v-on:click="add">Add</button>
  <button v-on:click="remove">Remove</button>
  <transition-group name="list-complete" tag="p">
    <span
      v-for="item in items"
      v-bind:key="item"
      class="list-complete-item"
    >
      {{ item }}
    </span>
  </transition-group>
</div>
```

``` js
new Vue({
  el: '#list-complete-demo',
  data: {
    items: [1,2,3,4,5,6,7,8,9],
    nextNum: 10
  },
  methods: {
    randomIndex: function () {
      return Math.floor(Math.random() * this.items.length)
    },
    add: function () {
      this.items.splice(this.randomIndex(), 0, this.nextNum++)
    },
    remove: function () {
      this.items.splice(this.randomIndex(), 1)
    },
    shuffle: function () {
      this.items = _.shuffle(this.items)
    }
  }
})
```

``` css
.list-complete-item {
  transition: all 1s;
  display: inline-block;
  margin-right: 10px;
}
.list-complete-enter, .list-complete-leave-to
/* .list-complete-leave-active for below version 2.1.8 */ {
  opacity: 0;
  transform: translateY(30px);
}
.list-complete-leave-active {
  position: absolute;
}
```

{% raw %}
<script src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.14.1/lodash.min.js"></script>
<div id="list-complete-demo" class="demo">
  <button v-on:click="shuffle">Shuffle</button>
  <button v-on:click="add">Add</button>
  <button v-on:click="remove">Remove</button>
  <transition-group name="list-complete" tag="p">
    <span v-for="item in items" :key="item" class="list-complete-item">
      {{ item }}
    </span>
  </transition-group>
</div>
<script>
new Vue({
  el: '#list-complete-demo',
  data: {
    items: [1,2,3,4,5,6,7,8,9],
    nextNum: 10
  },
  methods: {
    randomIndex: function () {
      return Math.floor(Math.random() * this.items.length)
    },
    add: function () {
      this.items.splice(this.randomIndex(), 0, this.nextNum++)
    },
    remove: function () {
      this.items.splice(this.randomIndex(), 1)
    },
    shuffle: function () {
      this.items = _.shuffle(this.items)
    }
  }
})
</script>
<style>
.list-complete-item {
  transition: all 1s;
  display: inline-block;
  margin-right: 10px;
}
.list-complete-enter, .list-complete-leave-to {
  opacity: 0;
  transform: translateY(30px);
}
.list-complete-leave-active {
  position: absolute;
}
</style>
{% endraw %}

<p class="tip">一点、FLIP トランジションは `display: inline` が指定されていると動かないことに注意しましょう。 代わりに `display: inline-block` を使うか、flex コンテキストに要素を置き換えることで動かすことができます。</p>

FLIP アニメーションは、単一の軸だけに限定されるものではありません。多次元のグリッドにあるアイテムも [同じように簡単に](https://jsfiddle.net/chrisvfritz/sLrhk1bc/) トランジションできます:

{% raw %}
<div id="sudoku-demo" class="demo">
  <strong>Lazy Sudoku</strong>
  <p>Keep hitting the shuffle button until you win.</p>
  <button @click="shuffle">
    Shuffle
  </button>
  <transition-group name="cell" tag="div" class="sudoku-container">
    <div v-for="cell in cells" :key="cell.id" class="cell">
      {{ cell.number }}
    </div>
  </transition-group>
</div>
<script>
new Vue({
  el: '#sudoku-demo',
  data: {
    cells: Array.apply(null, { length: 81 })
      .map(function (_, index) {
        return {
          id: index,
          number: index % 9 + 1
        }
      })
  },
  methods: {
    shuffle: function () {
      this.cells = _.shuffle(this.cells)
    }
  }
})
</script>
<style>
.sudoku-container {
  display: flex;
  flex-wrap: wrap;
  width: 238px;
  margin-top: 10px;
}
.cell {
  display: flex;
  justify-content: space-around;
  align-items: center;
  width: 25px;
  height: 25px;
  border: 1px solid #aaa;
  margin-right: -1px;
  margin-bottom: -1px;
}
.cell:nth-child(3n) {
  margin-right: 0;
}
.cell:nth-child(27n) {
  margin-bottom: 0;
}
.cell-move {
  transition: transform 1s;
}
</style>
{% endraw %}

### スタッガリングリストトランジション

data 属性を介して、JavaScript トランジションとやりとりを行うことで、リスト内の遷移をずらすことが可能です:

``` html
<script src="https://cdnjs.cloudflare.com/ajax/libs/velocity/1.2.3/velocity.min.js"></script>

<div id="staggered-list-demo">
  <input v-model="query">
  <transition-group
    name="staggered-fade"
    tag="ul"
    v-bind:css="false"
    v-on:before-enter="beforeEnter"
    v-on:enter="enter"
    v-on:leave="leave"
  >
    <li
      v-for="(item, index) in computedList"
      v-bind:key="item.msg"
      v-bind:data-index="index"
    >{{ item.msg }}</li>
  </transition-group>
</div>
```

``` js
new Vue({
  el: '#staggered-list-demo',
  data: {
    query: '',
    list: [
      { msg: 'Bruce Lee' },
      { msg: 'Jackie Chan' },
      { msg: 'Chuck Norris' },
      { msg: 'Jet Li' },
      { msg: 'Kung Fury' }
    ]
  },
  computed: {
    computedList: function () {
      var vm = this
      return this.list.filter(function (item) {
        return item.msg.toLowerCase().indexOf(vm.query.toLowerCase()) !== -1
      })
    }
  },
  methods: {
    beforeEnter: function (el) {
      el.style.opacity = 0
      el.style.height = 0
    },
    enter: function (el, done) {
      var delay = el.dataset.index * 150
      setTimeout(function () {
        Velocity(
          el,
          { opacity: 1, height: '1.6em' },
          { complete: done }
        )
      }, delay)
    },
    leave: function (el, done) {
      var delay = el.dataset.index * 150
      setTimeout(function () {
        Velocity(
          el,
          { opacity: 0, height: 0 },
          { complete: done }
        )
      }, delay)
    }
  }
})
```

{% raw %}
<script src="https://cdnjs.cloudflare.com/ajax/libs/velocity/1.2.3/velocity.min.js"></script>
<div id="example-5" class="demo">
  <input v-model="query">
  <transition-group
    name="staggered-fade"
    tag="ul"
    v-bind:css="false"
    v-on:before-enter="beforeEnter"
    v-on:enter="enter"
    v-on:leave="leave"
  >
    <li
      v-for="(item, index) in computedList"
      v-bind:key="item.msg"
      v-bind:data-index="index"
    >{{ item.msg }}</li>
  </transition-group>
</div>
<script>
new Vue({
  el: '#example-5',
  data: {
    query: '',
    list: [
      { msg: 'Bruce Lee' },
      { msg: 'Jackie Chan' },
      { msg: 'Chuck Norris' },
      { msg: 'Jet Li' },
      { msg: 'Kung Fury' }
    ]
  },
  computed: {
    computedList: function () {
      var vm = this
      return this.list.filter(function (item) {
        return item.msg.toLowerCase().indexOf(vm.query.toLowerCase()) !== -1
      })
    }
  },
  methods: {
    beforeEnter: function (el) {
      el.style.opacity = 0
      el.style.height = 0
    },
    enter: function (el, done) {
      var delay = el.dataset.index * 150
      setTimeout(function () {
        Velocity(
          el,
          { opacity: 1, height: '1.6em' },
          { complete: done }
        )
      }, delay)
    },
    leave: function (el, done) {
      var delay = el.dataset.index * 150
      setTimeout(function () {
        Velocity(
          el,
          { opacity: 0, height: 0 },
          { complete: done }
        )
      }, delay)
    }
  }
})
</script>
{% endraw %}

## トランジションの再利用

Vue のコンポーネントシステムを通して、トランジションを再利用することができます。再利用できるトランジションを生成するには、ルートに `<transition>` や `<transition-group>` を配置しなければいけません。そして、トランジションコンポーネントに子を渡します。

ここにテンプレートを使ったコンポーネントの例があります:

``` js
Vue.component('my-special-transition', {
  template: '\
    <transition\
      name="very-special-transition"\
      mode="out-in"\
      v-on:before-enter="beforeEnter"\
      v-on:after-enter="afterEnter"\
    >\
      <slot></slot>\
    </transition>\
  ',
  methods: {
    beforeEnter: function (el) {
      // ...
    },
    afterEnter: function (el) {
      // ...
    }
  }
})
```

そして、関数型コンポーネントは、このタスクにとてもよく適しています:

``` js
Vue.component('my-special-transition', {
  functional: true,
  render: function (createElement, context) {
    var data = {
      props: {
        name: 'very-special-transition',
        mode: 'out-in'
      },
      on: {
        beforeEnter: function (el) {
          // ...
        },
        afterEnter: function (el) {
          // ...
        }
      }
    }
    return createElement('transition', data, context.children)
  }
})
```

## 動的トランジション

はい、Vue ではトランジションさえも、データドリブンです！動的トランジションの最も基本的な例は、`name` 属性を動的プロパティとして束縛することでしょう。

```html
<transition v-bind:name="transitionName">
  <!-- ... -->
</transition>
```

これは、Vue のトランジションクラス規約を使って CSS トランジション/アニメーションを定義したとき、それらをシンプルに切り替える場合に便利でしょう。

任意のトランジション属性を動的に束縛できますが、それは属性だけに限りません。イベントフックはメソッドなので、コンテキストのいかなるデータにもアクセスできます。これは、コンポーネントの状態に応じて、JavaScript トランジションが異なる振る舞いをすることを意味します。

``` html
<script src="https://cdnjs.cloudflare.com/ajax/libs/velocity/1.2.3/velocity.min.js"></script>

<div id="dynamic-fade-demo" class="demo">
  Fade In: <input type="range" v-model="fadeInDuration" min="0" v-bind:max="maxFadeDuration">
  Fade Out: <input type="range" v-model="fadeOutDuration" min="0" v-bind:max="maxFadeDuration">
  <transition
    v-bind:css="false"
    v-on:before-enter="beforeEnter"
    v-on:enter="enter"
    v-on:leave="leave"
  >
    <p v-if="show">hello</p>
  </transition>
  <button
    v-if="stop"
    v-on:click="stop = false; show = false"
  >Start animating</button>
  <button
    v-else
    v-on:click="stop = true"
  >Stop it!</button>
</div>
```

``` js
new Vue({
  el: '#dynamic-fade-demo',
  data: {
    show: true,
    fadeInDuration: 1000,
    fadeOutDuration: 1000,
    maxFadeDuration: 1500,
    stop: true
  },
  mounted: function () {
    this.show = false
  },
  methods: {
    beforeEnter: function (el) {
      el.style.opacity = 0
    },
    enter: function (el, done) {
      var vm = this
      Velocity(el,
        { opacity: 1 },
        {
          duration: this.fadeInDuration,
          complete: function () {
            done()
            if (!vm.stop) vm.show = false
          }
        }
      )
    },
    leave: function (el, done) {
      var vm = this
      Velocity(el,
        { opacity: 0 },
        {
          duration: this.fadeOutDuration,
          complete: function () {
            done()
            vm.show = true
          }
        }
      )
    }
  }
})
```

{% raw %}
<script src="https://cdnjs.cloudflare.com/ajax/libs/velocity/1.2.3/velocity.min.js"></script>
<div id="dynamic-fade-demo" class="demo">
  Fade In: <input type="range" v-model="fadeInDuration" min="0" v-bind:max="maxFadeDuration">
  Fade Out: <input type="range" v-model="fadeOutDuration" min="0" v-bind:max="maxFadeDuration">
  <transition
    v-bind:css="false"
    v-on:before-enter="beforeEnter"
    v-on:enter="enter"
    v-on:leave="leave"
  >
    <p v-if="show">hello</p>
  </transition>
  <button
    v-if="stop"
    v-on:click="stop = false; show = false"
  >Start animating</button>
  <button
    v-else
    v-on:click="stop = true"
  >Stop it!</button>
</div>
<script>
new Vue({
  el: '#dynamic-fade-demo',
  data: {
    show: true,
    fadeInDuration: 1000,
    fadeOutDuration: 1000,
    maxFadeDuration: 1500,
    stop: true
  },
  mounted: function () {
    this.show = false
  },
  methods: {
    beforeEnter: function (el) {
      el.style.opacity = 0
    },
    enter: function (el, done) {
      var vm = this
      Velocity(el,
        { opacity: 1 },
        {
          duration: this.fadeInDuration,
          complete: function () {
            done()
            if (!vm.stop) vm.show = false
          }
        }
      )
    },
    leave: function (el, done) {
      var vm = this
      Velocity(el,
        { opacity: 0 },
        {
          duration: this.fadeOutDuration,
          complete: function () {
            done()
            vm.show = true
          }
        }
      )
    }
  }
})
</script>
{% endraw %}

動的なトランジションを作成する究極の方法は、プロパティでトランジションの性質を変えながら試行錯誤することです。小さく聞こえるかもしれませんが、本当の限界はあなたの想像力だけなのです。
