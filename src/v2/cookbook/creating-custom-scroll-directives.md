---
title: Creating Custom Scroll Directives
type: cookbook
updated: 2018-03-20
order: 7
---

> ⚠️注意: この内容は原文のままです。現在翻訳中ですのでお待ち下さい。🙏

## 基本的な例

ちょっとした振る舞いを加えたくなる時は数多くあるでしょう。特に Web サイト上でスクロールイベントと連動するアニメーションなどです。そうする方法は多くありますが、最も少ないコード量と依存で実現できる方法はおそらく、特定のスクロールイベントを発火させるフック作成のための、[カスタムディレクティブ](https://vuejs.org/v2/guide/custom-directive.html)を使用することでしょう。

```js
Vue.directive('scroll', {
  inserted: function (el, binding) {
    let f = function (evt) {
      if (binding.value(evt, el)) {
        window.removeEventListener('scroll', f)
      }
    }
    window.addEventListener('scroll', f)
  }
})

// main app
new Vue({
  el: '#app',
  methods: {
    handleScroll: function (evt, el) {
      if (window.scrollY > 50) {
        el.setAttribute(
          'style',
          'opacity: 1; transform: translate3d(0, -10px, 0)'
        )
      }
      return window.scrollY > 100
    }
  }
})
```

```html
<div id="app">
  <h1 class="centered">Scroll me</h1>
  <div class="box" v-scroll="handleScroll">
    <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. A atque amet harum aut ab veritatis earum porro praesentium ut corporis. Quasi provident dolorem officia iure fugiat, eius mollitia sequi quisquam.</p>
  </div>
</div>
```

<p class="tip">注意! ディレクティブは Vue インスタンス作成前に登録されなければなりません。</p>

私達はこのケースで、中継値を移行するスタイルプロパティも必要としています。

```
.box {
  transition: 1.5s all cubic-bezier(0.39, 0.575, 0.565, 1);
}
```

<p data-height="450" data-theme-id="5162" data-slug-hash="983220ed949ac670dff96bdcaf9d3338" data-default-tab="result" data-user="sdras" data-embed-version="2" data-pen-title="Custom Scroll Directive- CSS Transition" class="codepen">See the Pen <a href="https://codepen.io/sdras/pen/983220ed949ac670dff96bdcaf9d3338/">Custom Scroll Directive- CSS Transition</a> by Sarah Drasner (<a href="https://codepen.io/sdras">@sdras</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

また GreenSock(GSAP) や他の JavaScript ライブラリーを使用することで、コードはよりシンプルになります。

```js
Vue.directive('scroll', {
  inserted: function (el, binding) {
    let f = function (evt) {
      if (binding.value(evt, el)) {
        window.removeEventListener('scroll', f)
      }
    }
    window.addEventListener('scroll', f)
  }
})

// main app
new Vue({
  el: '#app',
  methods: {
    handleScroll: function (evt, el) {
      if (window.scrollY > 50) {
        TweenMax.to(el, 1.5, {
          y: -10,
          opacity: 1,
          ease: Sine.easeOut
        })
      }
      return window.scrollY > 100
    }
  }
})
```

CSS トランジションは今 JavaScript によって操作されているので、私達はこの実装から以前の CSS トランジションを取り除くことができるでしょう。

## カスタムディレクティブを使用することのメリット

Vue はディレクティブに対する豊富なオプションがあります。それらのオプションは一般的なユースケースをほとんど網羅し、とても生産的な開発体験を提供することでしょう。しかし、たとえフレームワークに網羅されていないニッチなユースケースを持っていたとしても、フレームワークに網羅されているユースケースと同様に網羅することができます。なぜなら、とても簡単にあなたが必要とするカスタムディレクティブを作成できるからです。

要素に対してスクロールイベントを着脱は本当に良いユースケースです。なぜなら私たちが使用する他のディレクティブと同様に、要素に結びつく必要があり、DOM を参照しなければならないためです。このパターンはトラバーサルの必要性を回避し、参照先のノードとイベントロジックの組み合わせを保ちます。

## 実例: カスケードアニメーションでのカスタムスクロールディレクティブの使用

一貫性のあるサイトを作成する過程で、あなたは様々な箇所で同じアニメーションロジックを再利用していることに気づくかもしれません。シンプルに見えますが、私達はとても限定的なカスタムディレクティブを作成します。概して、もしあなたがそれを再利用するならば、使用の度に「ほんの」些細な変更を必要とするでしょう。

簡潔で読みやすいコードの維持に役立てるため、私達はページを下にスクロールするときにアニメーションの開始・終了座標といった定義済みの引数を渡したいと思うでしょう。

**この例は[フルスクリーンバージョン](https://s.codepen.io/sdras/debug/078c19f5b3ed7f7d28584da450296cd0)の方が見やすいです.**

<p data-height="500" data-theme-id="5162" data-slug-hash="c8c55e3e0bba997350551dd747119100" data-default-tab="result" data-user="sdras" data-embed-version="2" data-pen-title="Scrolling Example- Using Custom Directives in Vue" class="codepen">See the Pen <a href="https://codepen.io/sdras/pen/c8c55e3e0bba997350551dd747119100/">Scrolling Example- Using Custom Directives in Vue</a> by Sarah Drasner (<a href="https://codepen.io/sdras">@sdras</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

上のデモで、それぞれのセクションはスクロールによって引き起こされる、2つの異なるアニメーションがあります。変形アニメーションと、SVG内の個々のパスに沿って動く描画アニメーションです。私達はこれら2つのアニメーションを再利用するので、それぞれのカスタムディレクティブを作成できます。私達が渡すであろう引数は、シンプルかつ再利用可能なコードの維持に役立ちます。

やり方を示すために、モーフィングシェイプの例を見てみましょう。ここでは開始・終了座標の状態と共に、モーフィングを作成するパス値が必要です。これらの引数はそれぞれ `binding.value.foo` に定義されています。

```js
Vue.directive('clipscroll', {
  inserted: function (el, binding) {
    let f = function (evt) {
      var hasRun = false
      if (!hasRun && window.scrollY > binding.value.start) {
        hasRun = true
        TweenMax.to(el, 2, {
          morphSVG: binding.value.toPath,
          ease: Sine.easeIn
        })
      }
      if (window.scrollY > binding.value.end) {
        window.removeEventListener('scroll', f)
      }
    }
    window.addEventListener('scroll', f)
  }
})
```

テンプレートにこのアニメーションを使用することができます。この場合、`clipPath`要素にディレクティブを加え、全ての引数をオブジェクトとしてディレクティブに渡します。

```html
<clipPath id="clip-path">
  <path
    v-clipscroll="{ start: '50', end: '100', toPath: 'M0.39 0.34H15.99V22.44H0.39z' }"
    id="poly-shapemorph"
    d="M12.46 20.76L7.34 22.04 3.67 18.25 5.12 13.18 10.24 11.9 13.91 15.69 12.46 20.76z"
  />
</clipPath>
```

## Alternative Patterns

Custom directives are extremely useful, but you may find some situations where you need something very specific that already exists in scrolling libraries that you don't wish to rebuild from scratch yourself.

[Scrollmagic](http://scrollmagic.io/) has a very rich ecosystem of offerings to work with, as well as good documentation and demos to explore. This includes, but is not limited to things like [parallax](http://scrollmagic.io/examples/advanced/parallax_scrolling.html), [cascading pinning](http://scrollmagic.io/examples/expert/cascading_pins.html), [section wipes](http://scrollmagic.io/examples/basic/section_wipes_natural.html), and [responsive duration](http://scrollmagic.io/examples/basic/responsive_duration.html).
