# Vue.js 公式サイト日本語翻訳ガイド

ようこそ、Vue.js 公式サイト日本語翻訳レポジトリへ！
翻訳プロジェクトに貢献したい方は、以下の内容を一読の上、お願いします。


## 貢献方法

1. このレポジトリをフォークします!
2. `lang-ja` ブランチからトピックブランチを作成します: `git branch my-topic-branch lang-ja`
3. 変更をコミットします: `git commit -am 'Fix some files'`
4. フォークした自分のレポジトリに Push します: `git push origin my-topic-branch`
5. プルリクエストを `vuejs-jp/vuejs.org` の `lang-ja` ブランチに送ります


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

### 単語の統一 (特に技術用語)

- 技術用語は基本英語、ただ日本語で一般的に使われている場合は日本語 OK !!
  - 例: 英語の filter 、日本語のフィルタ
- 和訳に困った、とりあえず英語
  - 例: expression -> 式、表現
- 和訳にして分かりづらい場合は、翻訳と英語(どちらに括弧付け)でも OK
  - 例: Two way -> Two way (双方向)
