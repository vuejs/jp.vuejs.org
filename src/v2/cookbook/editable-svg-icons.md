---
title: 編集可能なSVGアイコンシステム
type: cookbook
updated: 2018-03-20
order: 4
---

> ⚠️注意: この内容は原文のままです。現在翻訳中ですのでお待ち下さい。🙏

## Base Example
## ベースとなる例

There are many ways to create an SVG Icon System, but one method that takes advantage of Vue's capabilities is to create editable inline icons as components. Some of the advantages of this way of working is:
SVGアイコンシステムを作成する方法は多くありますが、 Vue の能力を活かす1つの方法はコンポーネントとして編集可能なインラインのアイコンを作成することです。この方法のいくつかの利点は:

* They are easy to edit on the fly
* すぐに編集することが簡単です
* They are animatable
* アニメーション可能です
* You can use standard props and defaults to keep them to a typical size or alter them if you need to
* 一般的なサイズを保つために標準の props やデフォルトを使用することができ、必要であれば変えることもできます
* They are inline, so no HTTP requests are necessary
* インラインなので、 HTTP リクエストは必要ありません
* They can be made accessible dynamically
* 動的にアクセス可能に作ることができます

First, we'll create a folder for all of the icons, and name them in a standardized fashion for easy retrieval:
まず、全てのアイコンのためのフォルダを作り、簡単に検索できるように標準化された方法で命名をしましょう。

> components/icons/IconBox.vue
> components/icons/IconCalendar.vue
> components/icons/IconEnvelope.vue

Here's an example repo to get you going, where you can see the entire setup: [https://github.com/sdras/vue-sample-svg-icons/](https://github.com/sdras/vue-sample-svg-icons/)
ここにサンプルのリポジトリがあります。全てのセットアップを見ることができます: [https://github.com/sdras/vue-sample-svg-icons/](https://github.com/sdras/vue-sample-svg-icons/)

![Documentation site](https://s3-us-west-2.amazonaws.com/s.cdpn.io/28963/screendocs.jpg 'Docs demo')

We'll create a base icon (`IconBase.vue`) component that uses a slot.
スロットを使うベースとなるアイコンコンポーネント (`IconBase.vue`) を作成しましょう。

```html
<template>
  <svg xmlns="http://www.w3.org/2000/svg"
    :width="width"
    :height="height"
    viewBox="0 0 18 18"
    :aria-labelledby="iconName"
    role="presentation"
  >
    <title :id="iconName" lang="en">{{iconName}} icon</title>
    <g :fill="iconColor">
      <slot />
    </g>
  </svg>
</template>
```

You can use this base icon as is- the only thing you might need to update is the `viewBox` depending on the `viewBox` of your icons. In the base, we're making the `width`, `height`, `iconColor`, and name of the icon props so that it can be dynamically updated with props. The name will be used for both the `<title>` content and its `id` for accessibility.
あなたはこのベースとなるアイコンをそのまま使うことができます。あなたが更新する必要があるものは、あなたのアイコンの `viewBox` に依存している `viewBox` だけです。ベースに、`width` 、 `height` 、 `iconColor` 、そして props を動的に更新できるようにアイコンの props の名前を作ります。その名前は `<title>` コンテンツと、アクセシビリティのための `id` の両方に使用されます。

Our script will look like this, we'll have some defaults so that our icon will be rendered consistently unless we state otherwise:
我々のスクリプトはこのようになるでしょう。そうでないと宣言しない限り一貫してアイコンが表示されるように、いくつかのデフォルトを持っています:

```js
export default {
  props: {
    iconName: {
      type: String,
      default: 'box'
    },
    width: {
      type: [Number, String],
      default: 18
    },
    height: {
      type: [Number, String],
      default: 18
    },
    iconColor: {
      type: String,
      default: 'currentColor'
    }
  }
}
```

The `currentColor` property that's the default on the fill will make the icon inherit the color of whatever text surrounds it. We could also pass in a different color as a prop if we wish.
塗りのデフォルトである `currentColor` プロパティはアイコンにそれを囲むテキストの色を継承させます。私たちが望むのなら、 prop として別の色を渡すこともできます。

We can use it like so, with the only contents of `IconWrite.vue` containing the paths inside the icon:
アイコンの中にパスを含む `IconWrite.vue` の内容のみでそのように使うことができます:

```html
<icon-base icon-name="write"><icon-write /></icon-base>
```

Now, if we'd like to make many sizes for the icon, we can do so very easily:
今、もしアイコンのために多くのサイズを作りたいのであれば、とても簡単にできます:

```html
<p>
  <!-- you can pass in a smaller `width` and `height` as props -->
  <!-- props として小さな `width` と `height` を渡すことができます  -->
  <icon-base width="12" height="12" icon-name="write"><icon-write /></icon-base>
  <!-- or you can use the default, which is 18 -->
  <!-- あるいはデフォルトを使うことも可能です。デフォルトは18です -->
  <icon-base icon-name="write"><icon-write /></icon-base>
  <!-- or make it a little bigger too :) -->
  <!-- あるいはすこし大きくすることももちろん可能です :) -->
  <icon-base width="30" height="30" icon-name="write"><icon-write /></icon-base>
</p>
```

<img src="https://s3-us-west-2.amazonaws.com/s.cdpn.io/28963/Screen%20Shot%202018-01-01%20at%204.51.40%20PM.png" width="450" />

## Animatable Icons
## アニメーション可能なアイコン

Keeping icons in components comes in very handy when you'd like to animate them, especially on an interaction. Inline SVGs have the highest support for interaction of any method. Here's a very basic example of an icon that's animated on click:
Keeping icons in components comes in very handy when you'd like to animate them, especially on an interaction. Inline SVGs have the highest support for interaction of any method. Here's a very basic example of an icon that's animated on click:

```html
<template>
  <svg @click="startScissors"
    xmlns="http://www.w3.org/2000/svg"
    viewBox="0 0 100 100"
    width="100"
    height="100"
    aria-labelledby="scissors"
    role="presentation"
    >
    <title id="scissors" lang="en">Scissors Animated Icon</title>
    <path id="bk" fill="#fff" d="M0 0h100v100H0z"/>
    <g ref="leftscissor">
      <path d="M..."/>
      ...
    </g>
    <g ref="rightscissor">
      <path d="M..."/>
      ...
    </g>
  </svg>
</template>
```

```js
import { TweenMax, Sine } from 'gsap'

export default {
  methods: {
    startScissors() {
      this.scissorAnim(this.$refs.rightscissor, 30)
      this.scissorAnim(this.$refs.leftscissor, -30)
    },
    scissorAnim(el, rot) {
      TweenMax.to(el, 0.25, {
        rotation: rot,
        repeat: 3,
        yoyo: true,
        svgOrigin: '50 45',
        ease: Sine.easeInOut
      })
    }
  }
}
```

We're applying `refs` to the groups of paths we need to move, and as both sides of the scissors have to move in tandem, we'll create a function we can reuse where we'll pass in the `refs`. The use of GreenSock helps resolve animation support and `transform-origin` issues across browser.

<p data-height="300" data-theme-id="0" data-slug-hash="dJRpgY" data-default-tab="result" data-user="Vue" data-embed-version="2" data-pen-title="Editable SVG Icon System: Animated icon" class="codepen">See the Pen <a href="https://codepen.io/team/Vue/pen/dJRpgY/">Editable SVG Icon System: Animated icon</a> by Vue (<a href="https://codepen.io/Vue">@Vue</a>) on <a href="https://codepen.io">CodePen</a>.</p><script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

<p style="margin-top:-30px">Pretty easily accomplished! And easy to update on the fly.</p>

You can see more animated examples in the repo [here](https://github.com/sdras/vue-sample-svg-icons/)

## Additional Notes

Designers may change their minds. Product requirements change. Keeping the logic for the entire icon system in one base component means you can quickly update all of your icons and have it propagate through the whole system. Even with the use of an icon loader, some situations require you to recreate or edit every SVG to make global changes. This method can save you that time and pain.

## When To Avoid This Pattern

This type of SVG icon system is really useful when you have a number of icons that are used in different ways throughout your site. If you're repeating the same icon many times on one page (e.g. a giant table a delete icon in each row), it might make more sense to have all of the sprites compiled into a sprite sheet and use `<use>` tags to load them.

## Alternative Patterns

Other tooling to help manage SVG icons includes:

* [svg-sprite-loader](https://github.com/kisenka/svg-sprite-loader)
* [svgo-loader](https://github.com/rpominov/svgo-loader)

These tools bundle SVGs at compile time, but make them a little harder to edit during runtime, because `<use>` tags can have strange cross-browser issues when doing anything more complex. They also leave you with two nested `viewBox` properties and thus two coordinate systems. This makes the implementation a little more complex.
