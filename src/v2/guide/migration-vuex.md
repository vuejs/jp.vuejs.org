---
title: Vuex 0.6.x から 1.0 への移行
updated: 2017-09-08
type: guide
order: 703
---

> Vuex 2.0 はリリースされましたが、このガイドは 1.0 への移行だけをカバーしているのでしょうか？間違いでしょうか？Vuex 1.0 と2.0 が同時にリリースされたようですが、どういうことでしょうか？どっちを使用すると、Vue 2.0 と互換性があるでしょうか？

Vuex 1.0 と 2.0 の両方は:

- Vue 1.0 と 2.0 のバージョン両方をフルにサポートします
- 近い将来までメンテされる予定です

しかしながら、ターゲットユーザーはわずかに異なります。

__Vuex 2.0__ は、新しいプロジェクトを開始やクライアント側の状態管理の最先端を目指したりするための、API の根本的な再設計と単純化したものです。もし、それについてもっと学びたいならば、__これはこの移行ガイドではカバーされない__ため詳細については、[Vuex 2.0 ドキュメント](https://vuex.vuejs.org/ja/index.html) を参照してください。

__Vuex 1.0__ はほとんど下位互換性があるため、アップグレードするための変更はほとんど必要ありません。既存の大規模なコードベースを持つ人、または Vue 2.0 への最もスムーズなアップグレードパスが必要な人にはおすすめです。このガイドは、そのプロセスを容易にすることを目的としていますが、移行に関する注意事項のみを含んでいます。完全な使い方については [Vuex 1.0 ドキュメント](https://github.com/vuejs/vuex/tree/1.0/docs/ja) を参照してください。

## 文字列プロパティパスによる `store.watch` <sup>置き換え</sup>

`store.watch` は関数を受け付けるようになりました。たとえば、次のように置き換える必要があります:

``` js
store.watch('user.notifications', callback)
```

は以下により:

``` js
store.watch(
  // 返された結果が変更されたとき...
  function (state) {
    return state.user.notifications
  },
  // このコールバックを動かす
  callback
)
```

これにより、リアクティブをより完全に制御することができます。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>コードに対し <a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a> を実行し 最初の引数として文字列による <code>store.watch</code> が呼び出される箇所を検出してください。</p>
</div>
{% endraw %}

## store のイベントエミッタ <sup>削除</sup>

store インスタンスは、イベントエミッタインタフェース (`on`、` off`、`emit`) を公開しなくなりました。以前に store をグローバルイベントバスとして使用していた場合は、移行手順については、[こちらのセクション](migration.html#dispatch-および-broadcast-置き換え) を参照してください。

このインターフェイスを使用して store 自体が発行する監視イベント (例 `store.on('mutation', callback)`) の代わりに、新しいメソッド `store.subscribe` が導入されています。プラグインの典型的な使い方は次のとおりです:

``` js
var myPlugin = store => {
  store.subscribe(function (mutation, state) {
    // 何かの処理 ...
  })
}

```

より詳細については、[プラグインのドキュメント](https://github.com/vuejs/vuex/blob/1.0/docs/ja/plugins.md) の example を参照してください。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>コードに対し <a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a> を実行し、<code>store.on</code>、<code>store.off</code>、<code>store.emit</code>が呼び出される箇所を検出してください。</p>
</div>
{% endraw %}

## ミドルウェア <sup>置き換え</sup>

ミドルウェアはプラグインとして置き換えられました。プラグインは、単に引数として store を受け取る関数で、store で mutation イベントを購読することができます:

``` js
const myPlugins = store => {
  store.subscribe('mutation', (mutation, state) => {
    // 何かの処理 ...
  })
}
```

より詳細については、[プラグインのドキュメント](https://github.com/vuejs/vuex/blob/1.0/docs/ja/plugins.md) の example を参照してください。

{% raw %}
<div class="upgrade-path">
  <h4>移行ガイド</h4>
  <p>コードに対し <a href="https://github.com/vuejs/vue-migration-helper">移行ヘルパー</a> を実行し、store 上で<code>middlewares</code>を検出してください。</p>
</div>
{% endraw %}
