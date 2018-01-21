---
title: Vue Devtools 4.0 の新機能
date: 2018-01-16
---

このブログは[こちら](https://medium.com/the-vue-point/whats-new-in-vue-devtools-4-0-9361e75e05d0)の翻訳ブログです。

先日 Vue devtools の大きなアップデートがリリースされました。
新機能と改善点を掘り下げてみましょう！🎄

## コンポーネントデータが編集可能に
コンポーネントのデータを直接コンポーネントインスペクター枠内で変更できるようになりました。

1. コンポーネントを選択します
2. インスペクターの `data` セクションでフィールドにマウスを置きます
3. 鉛筆アイコンをクリックします
4. 完了アイコンのクリックまたは Enter キーの押下で変更を確定します。 Escape キーの押下で編集をキャンセルできます

<iframe width="480" height="360" src="https://www.youtube.com/embed/xeBRtXLrQYA?ecver=1" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

フィールドの内容はシリアライズされた JSON 値です。例えば、文字列を入力したいならダブルクオート付きで `"hello"` と入力します。配列は `[1, 2, "bar"]` のように、オブジェクトは `{ "a": 1, "b": "foo" }` のように入力します。

現在、以下の型について値の編集が可能です：

- `null` と `undefined`
- `文字列`
- リテラル定数： `Boolean`, `Number`, `Infinity`, `-Infinity`（訳注：負の無限大）及び `NaN`
- 配列
- プレーンオブジェクト

配列とプレーンオブジェクトは、専用のアイコンを使用して項目の追加と削除が可能です。またオブジェクトキーの名前を変更することもできます。

<iframe width="480" height="360" src="https://www.youtube.com/embed/fx1zjvHryJ0?ecver=1" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

入力が正しい JSON でない場合は警告が表示されます。ただし、`undefined` や `NaN` のような一部の値はよりよい利便性のため直接入力することができます。

今後のリリースではより多くの型がサポートされる予定です！

## クイック編集
いくつかの型の値は 'Quick Edit' 機能を使用してワンクリックで編集することができます。

ブール値はチェックボックスアイコンで直接反転させることができます：

<iframe width="480" height="360" src="https://www.youtube.com/embed/llNJapRZaHo?ecver=1" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

数値はプラスまたはマイナスアイコンで増減できます：

<iframe width="480" height="360" src="https://www.youtube.com/embed/ZCToaOpId0w?ecver=1" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

いくつかの修飾キー（訳注： Shift/Ctrl/Alt のこと）を用い値を高速に増減させることができます。

## エディタでコンポーネントを開く
プロジェクトで vue-loader または Nuxt を使用している場合、選択したコンポーネントを好みのコードエディタで開くことができます（単一ファイルコンポーネントの場合）。

1. この[設定ガイド](https://github.com/vuejs/vue-devtools/blob/master/docs/open-in-editor.md)に従ってください（Nuxt を使用している場合は、何もする必要はありません）
2. コンポーネントインスペクターで、コンポーネント名の上にマウスを置くと — ファイルパスが表示されたツールチップが表示されます
3. コンポーネント名をクリックすることでエディタが開きます

<iframe width="480" height="360" src="https://www.youtube.com/embed/XBKStgyhY18?ecver=1" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

## 元のコンポーネント名を表示
[manico](https://github.com/manico) による PR

既定では、すべてのコンポーネント名は CamelCase にフォーマットされています。これはコンポーネントタブの 'Format component names' ボタンをトグルすることで無効にできます。この設定は記憶されイベントタブにも適用されます。

<iframe width="480" height="270" src="https://www.youtube.com/embed/PoZmEcCdSbU?ecver=1" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

## コンポーネントのインスペクトがより簡単に
Vue devtools を開いている間は、コンポーネントを右クリックすることでインスペクト可能です：

![](https://cdn-images-1.medium.com/max/800/1*8fhP5VTb6uev-8HfI4stYw.png)
<figcaption style="font-size:smaller; text-align:center;">ページ内のコンポーネントを右クリック</figcaption>

特殊メソッド `$inspect`を使用してコンポーネントをプログラムからインスペクトすることもできます：

<script src="https://gist.github.com/Akryum/0187dbfd782d584eef46e85622685bac.js" charset="utf-8"></script>
<figcaption style="font-size:smaller; text-align:center;">コンポーネントで `$inspect` メソッドを使う</figcaption>

いずれの方法でも、コンポーネントツリーが新しく選択されたコンポーネントに自動展開されます。

## コンポーネント毎にイベントをフィルター
[eigan](https://github.com/eigan) による PR

イベントを発行したコンポーネントによってイベント履歴をフィルターできるようになりました。 `<` の後に続けてコンポーネント名またはその一部を入力してください。

<iframe width="480" height="270" src="https://www.youtube.com/embed/wytquoUPSFo?ecver=1" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

## Vuex インスペクターフィルター
[bartlomieju](https://github.com/bartlomieju) による PR

Vuex インスペクターにフィルター入力が付きました：

<iframe width="480" height="270" src="https://www.youtube.com/embed/T095k5hI_pA?ecver=1" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

## 垂直レイアウト
[crswll](https://github.com/crswll) による PR

devtools の幅が十分でないときは、便利な垂直レイアウトに切り替わります。既定の水平モードの場合と同様、上下の枠の仕切りは移動することができます。

<iframe width="480" height="360" src="https://www.youtube.com/embed/33tJ_md8bX8?ecver=1" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

## コンポーネントへのスクロールの改善
既定では、コンポーネントを選択してもビューはスクロールされなくなりました。代わりに、新設の 'Scroll into view' アイコンをクリックする必要があります：

![](https://cdn-images-1.medium.com/max/800/1*TJEfzB4ifK8t-5kpbZieRw.png)
<figcaption style="font-size:smaller; text-align:center;">目のアイコンをクリックしてコンポーネントにスクロール</figcaption>

これでコンポーネントが画面中央に表示されます。

## インスペクターが折り畳み可能に
異なるインスペクターのセクションを折り畳むことができます。修飾キーを使用することで全てを折り畳んだりワンクリックで全てを展開できます。これは例えば、 Vuex タブのミューテックスの詳細のみに興味がある場合には非常に便利です。

<iframe width="480" height="270" src="https://www.youtube.com/embed/bblGueKPsjE?ecver=1" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

## さらに！
- 環境にその機能がない場合 'Inspect DOM' ボタンが非表示になります -  [michalsnik](https://github.com/michalsnik) により
- `-Infinity` がサポートされました - [David-Desmaisons](https://github.com/David-Desmaisons) により
- イベントフックにあった問題が修正されました - [maxushuang](https://github.com/maxushuang) により
- コードのいくつかが綺麗になりました - [anteriovieira](https://github.com/anteriovieira) により
- Date, RegExp, Component サポートが改善されました（これらの型では Time Travel が動作するはずです）
- devtools は現在リッチなツールチップやポップオーバー用に [v-tooltip](https://github.com/Akryum/v-tooltip) を使用しています（いくつかの問題も修正されています）

拡張機能が既に存在する場合は、自動的に 4.0.1 に更新されます。また [Chrome](https://chrome.google.com/webstore/detail/vuejs-devtools/nhdogjmejiglipccpnnnanhbledajbpd) や [Firefox](https://addons.mozilla.org/fr/firefox/addon/vue-js-devtools/) に新規インストールすることもできます。

**この大きなアップデートを可能にした全ての貢献者に感謝します！**

もし問題を見つけたり新機能を提案する場合は、[それを共有](https://new-issue.vuejs.org/?repo=vuejs/vue-devtools)してください！

## 今後の予定は？
新しいリリースではページ内のコンポーネントの選択（カラーピッカー風）やいくつかの UI の改善などのさらに多くの機能が追加される予定です。

また（Chrome や Firefox だけでなく）あらゆる環境でのデバッグを可能にするスタンドアロンの Vue devtools アプリや、まったく新しいルーティングタブ、そして `Set` と `Map` 型の改善されたサポートなどのいくつかの機能があります。

乞うご期待！
