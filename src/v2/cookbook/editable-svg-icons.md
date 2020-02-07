---
title: 編集可能な SVG アイコンシステム
type: cookbook
updated: 2018-03-20
order: 4
---

## 基本的な例

SVG アイコンシステムを作成する方法は多くありますが、 Vue の機能を活かす 1 つの方法は、編集可能なインラインのアイコンをコンポーネントとして作成することです。この方法のいくつかの利点は以下の通りです:

* 即座に編集することが簡単です
* アニメーション可能です
* 標準のプロパティやデフォルトを使用して標準サイズを保つことができ、必要ならば変更することもできます
* インラインなので、 HTTP リクエストは必要ありません
* 動的にアクセス可能に作ることができます

まず、全てのアイコン用のフォルダを作り、簡単に検索できるように標準化された方法で命名をしましょう。

> components/icons/IconBox.vue
> components/icons/IconCalendar.vue
> components/icons/IconEnvelope.vue

ここに全てのセットアップを見ることができるサンプルのリポジトリがあります: [https://github.com/sdras/vue-sample-svg-icons/](https://github.com/sdras/vue-sample-svg-icons/)

![Documentation site](https://s3-us-west-2.amazonaws.com/s.cdpn.io/28963/screendocs.jpg 'Docs demo')

スロットを使うベースアイコン (`IconBase.vue`) コンポーネントを作成しましょう。

```html
<template>
  <svg xmlns="http://www.w3.org/2000/svg"
    :width="width"
    :height="height"
    viewBox="0 0 18 18"
    :aria-labelledby="iconName"
    role="presentation"
  >
    <title
      :id="iconName"
      lang="en"
    >{{ iconName }} icon</title>
    <g :fill="iconColor">
      <slot />
    </g>
  </svg>
</template>
```

あなたはこのベースアイコンをそのまま使うことができます。あなたのアイコンの `viewBox` に応じて `viewBox` を更新することだけは必要かもしれません。ベースには、`width` 、 `height` 、 `iconColor` 、そしてプロパティで動的に更新できるようにアイコンのプロパティの名前を作ります。その名前はアクセシビリティのために `<title>` コンテンツと `id` の両方に使用されます。

スクリプトは次のようになるでしょう。いくつかのデフォルトを持っているので、デフォルト以外を宣言しない限り、アイコンは一貫して描画されます:

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

塗りつぶしのデフォルトの `currentColor` プロパティは、アイコンを囲むテキストの色を継承させます。私たちが望むのなら、プロパティとして別の色を渡すこともできます。

アイコンの中にパスを含む `IconWrite.vue` の内容のみでそのように使うことができます:

```html
<icon-base icon-name="write"><icon-write /></icon-base>
```

もし、多くのアイコンのサイズを作成したいなら、とても簡単にすることができます:

```html
<p>
  <!-- プロパティとして小さな `width` と `height` を渡すことができます -->
  <icon-base
    width="12"
    height="12"
    icon-name="write"
  ><icon-write /></icon-base>
  <!-- あるいはデフォルトを使うことも可能です。デフォルトは18です -->
  <icon-base icon-name="write"><icon-write /></icon-base>
  <!-- あるいはすこし大きくすることももちろん可能です :) -->
  <icon-base
    width="30"
    height="30"
    icon-name="write"
  ><icon-write /></icon-base>
</p>
```

<img src="https://s3-us-west-2.amazonaws.com/s.cdpn.io/28963/Screen%20Shot%202018-01-01%20at%204.51.40%20PM.png" width="450" />

## アニメーション可能なアイコン

アイコンをコンポーネントの中に保持させておくことは、アイコンをアニメーションをさせたい時、特にインタラクションにおいてとても便利です。インライン SVG は、あらゆるメソッドのインタラクションに対して最も高いサポートを持っています。以下は、クリックでアニメーションするアイコンのとても基本的な例です:

```html
<template>
  <svg
    @click="startScissors"
    xmlns="http://www.w3.org/2000/svg"
    viewBox="0 0 100 100"
    width="100"
    height="100"
    aria-labelledby="scissors"
    role="presentation"
  >
    <title
      id="scissors"
      lang="en"
    >Scissors Animated Icon</title>
    <path
      id="bk"
      fill="#fff"
      d="M0 0h100v100H0z"/>
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

動かす必要のあるパスのグループに `refs` を適用し、そしてハサミの両側は連携して動く必要があるので、  `refs` を渡すところで再利用できる関数をつくります。 GreenSock を使うとブラウザ間のアニメーションサポートと `transform-origin` の問題を解決してくれるでしょう。

<p data-height="300" data-theme-id="0" data-slug-hash="dJRpgY" data-default-tab="result" data-user="Vue" data-embed-version="2" data-pen-title="Editable SVG Icon System: Animated icon" class="codepen"> Pen を見てください<a href="https://codepen.io/team/Vue/pen/dJRpgY/">編集可能なアイコンシステム: アニメーションするアイコン</a> by Vue (<a href="https://codepen.io/Vue">@Vue</a>) on <a href="https://codepen.io">CodePen</a>.</p><script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

<p style="margin-top:-30px">とても簡単に完成しました！そして即座に更新をすることが簡単です。</p>

[こちらの](https://github.com/sdras/vue-sample-svg-icons/)リポジトリでより多くのアニメーションの例を見ることができます。

## 補足

デザイナーは気持ちを変えるかもしれません。プロダクトの要件は変わります。全てのアイコンシステムのロジックを基本となる 1 つのコンポーネントに保持しておくことは、全てのアイコンを素早く更新でき、それがすぐシステム全体に伝播することを意味します。アイコンローダーを使用しても、場合によってはグローバルな変更をさせるために全ての SVG を再作成したり編集したりする必要があります。この方法はその時間と苦痛からあなたを救うことができます。

## このパターンを避ける時

このタイプの SVG アイコンシステムは、サイト全体で様々な方法で使われているアイコンをいくつか持っている時にとても便利です。もし 1 つのページで何回も同じアイコンを繰り返しているのなら(例 各行に削除アイコンのある大きなテーブル)、 全てのスプライトをスプライトシートにコンパイルして `<use>` タグを使ってロードする方が有意義でしょう。

## 代替パターン

SVG アイコンの管理に役立つ他のツールは以下を含みます:

* [svg-sprite-loader](https://github.com/kisenka/svg-sprite-loader)
* [svgo-loader](https://github.com/rpominov/svgo-loader)

これらのツールは、コンパイル時に SVG をバンドルしますが、ランタイム中にそれらを編集することが少し難しくなります。なぜなら `<use>` タグは、より複雑なことをしようとする時に奇妙なクロスブラウザの問題を持っているからです。それらは 2 つにネストされた `viewBox` プロパティと 2 つの座標系を残します。これが、実装を少し難しくします。
