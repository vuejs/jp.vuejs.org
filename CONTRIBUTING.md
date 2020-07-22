# Vue.js 公式サイト日本語翻訳ガイド

ようこそ、Vue.js 公式サイト日本語翻訳レポジトリへ！
翻訳プロジェクトに貢献したい方は、以下の内容を一読の上、お願いします。


## 貢献方法

### GitHub Issues にある本家ドキュメントの差分更新内容を翻訳して貢献する

1. [GitHub Issues](https://github.com/vuejs/jp.vuejs.org/issues)から、[このクエリ](https://github.com/vuejs/jp.vuejs.org/issues?q=is%3Aissue+is%3Aopen+label%3Adocumentation+sort%3Acreated-asc) でソート&フィルタして、アサインされていない issues 一覧からできるだけ古いものからやりたい issue を選択します
2. 選択した issue で、「翻訳やります！」的なコメントで宣言します :raising_hand: (`vuejs/jp.vuejs.org`のメンテナの方々は、GitHub の assign 機能で self assign で OK です)
3. このレポジトリ`vuejs/jp.vuejs.org`のメンテナから同 issue でコメントで承認されたら、正式に自分が選んだ issue の翻訳担当者としてアサインされたことになります
4. このレポジトリをフォークします!
5. `lang-ja` ブランチからトピックブランチを作成します: `git branch my-topic-branch lang-ja`
6. 変更をコミットします: `git commit -am 'Fix some files'`
7. lint で引っかかる場合は再度修正を行いコミットします
8. 翻訳した `.md` の `updated` 属性を修正した日に変更してコミットします: `git commit -am 'Update date'`
9. フォークした自分のレポジトリに Push します: `git push origin my-topic-branch`
10. 問題がなければ、プルリクエストを `vuejs/jp.vuejs.org` の `lang-ja` ブランチに送ります
11. レビュー :eyes: で指摘事項があったら修正し、再度 Push します :pencil:
12. レビュー :eyes: で OK :ok_woman: ならば、マージされて内容がデプロイされてドキュメントに反映されます! :tada:
13. ドキュメント反映後、[貢献者一覧](https://jp.vuejs.org/contribution/)に**貢献者**としてあなたの GitHub アカウントが登録されます！ :tada:

#### Tips: より円滑な Pull Request のコメント記載方法

GitHub の Pull Request には、特定の記法を Pull Request の本文に書くことによって、該当 Pull Request のマージ時に自動的に対応する Issues をクローズできる機能があります。
Pull Request を送るときに、余裕があれば "resolve #123" といった形で、該当する Issues の番号を記載されているとレビュアーが非常に助かります :pray:

### GitHub Issues とは別のものについて貢献する

手順は上記の `4.`以降と同じです。


## 翻訳スタイル

- [JTF日本語標準スタイルガイド（翻訳用）](https://www.jtf.jp/jp/style_guide/styleguide_top.html) に準拠
- JTF日本語標準スタイルのチェックツールは [textlint-plugin-JTF-style](https://github.com/azu/textlint-plugin-JTF-style) を使用し、ルールはVue.js 公式サイト向けに[一部カスタマイズ](.textlintrc)


## 翻訳のゆらぎ & トーン

### 文体
「だである」ではなく「ですます」調

> Vue.js is a library for building modern web interfaces. 

- NG : Vue.js はモダンな Web インターフェースを構築するためのライブラリ**である**。
- OK : Vue.js はモダンな Web インターフェースを構築するためのライブラリ**です**。

### 半角スペースでアルファベット両端を入れて読みやすく！

> Vue.js is a library for building modern web interfaces. 

- NG : Vue.jsはモダンなWebインターフェースを構築するためのライブラリです。
- OK : Vue.js はモダンな Web インターフェースを構築するためのライブラリです。

例外として、句読点の前後にアルファベットがある場合は、スペースを入れなくてもいいです。

- 読点: 技術的に、Vue.js は MVVM パターンの ViewModel レイヤに注目しています。

### 原則、一語一句翻訳、ただ日本語として分かりにくい場合は読みやすさを優先

> Alternatively, you can bind the directive directly to an Object. The keys of the object will be the list of classes to toggle based on corresponding values.

- NG: 別な方法としては、直接ディレクティブをオブジェクトにバインドできます。オブジェクトのキーは、クラスのリストは対応する値に基づいてトグルします。
- OK: 別な方法としては、直接ディレクティブをオブジェクトにバインドできます。オブジェクトのキーは、対応する値に基づいてトグルする class のリストになります。

### 原文に使われる ':' や '!' や '?' などの記号は極力残して翻訳

> Example:

- NG: 例
- OK: 例:

ただし、文の途中にハイフン`-` や セミコロン`;` がある場合は、その記号があると理解しづらい訳になる場合は、例外として削除してもよいです。

- 原文:
> Avoid using track-by="$index" in two situations: when your repeated block contains form inputs that can cause the list to re-render; or when you are repeating a component with mutable state in addition to the repeated data being assigned to it.

- 訳文:
> track-by="$index" は2つの状況で使用を回避してください。繰り返されたブロックにリストを再描画するために使用することができる form の input を含んでいるとき、または、繰り返されるデータがそれに割り当てられる他に、可変な状態でコンポーネントを繰り返しているときです。

### 単語の統一 (特に技術用語)

- 技術用語は基本英語、ただ日本語で一般的に使われている場合は日本語 OK !!
  - 例: 英語の filter 、日本語のフィルタ
- 和訳に困った、とりあえず英語
  - 例: expression -> 式、表現
- 和訳にして分かりづらい場合は、翻訳と英語(どちらかに括弧付け)でも OK
  - 例: Two way -> Two way (双方向)

### 長音訳のついて
原則、**長音なし**で翻訳する。

- NG: コンピューター
- OK: コンピュータ

ただし、長音なしで訳した場合、**意味が分かりにくいものは、例外として長音あり**で訳してもよいです。

> Pull Request flow

- NG: プルリクエストフロ
- OK: プルリクエストフロー

#### 長音訳例外リスト
> NOTE: 以下のリストは随時追加していく

- error: エラー
- throw: スロー
- flow: フロー
- ...
