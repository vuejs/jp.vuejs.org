---
title: クライアントサイドストレージ
type: cookbook
order: 11
---

## 基本の例

クライアントサイドストレージは、パフォーマンスの向上をアプリケーションに対してすばやく追加する優れた方法です。ブラウザ自体にデータを格納することで、ユーザが必要とするたびにサーバから情報を取得するのをスキップすることができます。オフラインのとき特に便利ですが、オンラインユーザでもリモートサーバと比較してローカルデータを使用することにメリットがあります。クライアントサイドストレージは、[クッキー](https://developer.mozilla.org/ja/docs/Web/HTTP/Cookies), [ローカルストレージ](https://developer.mozilla.org/ja/docs/Web/API/Web_Storage_API)（技術的には "Web Storage"）, [IndexedDB](https://developer.mozilla.org/ja/docs/Web/API/IndexedDB_API), および [WebSQL](https://www.w3.org/TR/webdatabase/)（新しいプロジェクトでは使用しないでください）で実行できます。

このクックブックでは最も単純なストレージメカニズムの、ローカルストレージに焦点を当てます。ローカルストレージはデータを格納するための key/value システムを使用します。単純な値だけを格納することに限られますが JSON で値をエンコード及びデコードする場合は複雑なデータを格納できます。一般的に、ローカルストレージは保持したいと思う小さなデータセット、環境設定やフォームデータなどに適しています。より複雑なストレージニーズを伴う大規模なデータは、通常は IndexedDB に格納する方がよいでしょう。

簡単なフォームベースの例からはじめましょう:

``` html
<div id="app">
  My name is <input v-model="name">
</div>
```

この例では `name` という Vue にバインドされたひとつのフォームフィールドがあります。ここに JavaScript があります:

``` js
const app = new Vue({
  el: '#app',
  data: {
    name: ''
  },
  mounted() {
    if (localStorage.name) {
      this.name = localStorage.name;
    }
  },
  watch: {
    name(newName) {
      localStorage.name = newName;
    }
  }
});
```

`mounted` と ` watch` パーツに注目してください。localStorage の値のロードを処理するために `mounted` を使います。データベースの作成を扱うために、`name` 値を監視し変更したら、直ちに書き込みます。

あなたはここで実行することができます:

<p data-height="265" data-theme-id="0" data-slug-hash="KodaKb" data-default-tab="js,result" data-user="cfjedimaster" data-embed-version="2" data-pen-title="testing localstorage" class="codepen">See the Pen <a href="https://codepen.io/cfjedimaster/pen/KodaKb/">testing localstorage</a> by Raymond Camden (<a href="https://codepen.io/cfjedimaster">@cfjedimaster</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

フォームに何か入力してこのページをリロードしてください。前に入力した値が自動的に表示されます。ブラウザがクラインアントサイドストレージを詳しく調べるための優れた開発者ツールを提供していることを忘れないでください。ここでは、Firefox の例です:

![Storage devtools in Firefox](/images/devtools-storage.png)

そしてここでは Chrome です:

![Storage devtools in Chrome](/images/devtools-storage-chrome.png)

最後に、Microsoft Edge の例です。アプリケーションのストレージ値は、デバッガタブで確認することができます。

![Storage devtools in Edge](/images/devtools-storage-edge.png)

<p class="tip">これらの開発ツールは、すぐにストレージ値を削除する手段を提供します。これはテスト時に非常に便利です。</p>

直ちに値を書くことはお勧めできません。やや高度な例を考えてみましょう。まず、更新されたフォーム。

``` html
<div id="app">
  <p>
    My name is <input v-model="name">
    and I am <input v-model="age"> years old.
  </p>
  <p>
    <button @click="persist">Save</button>
  </p>
</div>
```

今度は2つのフィールド（Vue インスタンスにバインドされています）がありますが、`persist` メソッドを実行するボタンが追加されています。JavaScript を見てみましょう。

``` js
const app = new Vue({
  el: '#app',
  data: {
    name: '',
    age: 0
  },
  mounted() {
    if (localStorage.name) {
      this.name = localStorage.name;
    }
    if (localStorage.age) {
      this.age = localStorage.age;
    }
  },
  methods: {
    persist() {
      localStorage.name = this.name;
      localStorage.age = this.age;
      console.log('now pretend I did more stuff...');
    }
  }
})
```

前述したように、`mounted` は永続されたデータがあれば、それを読み込みます。ただし、今回は、ボタンがクリックされたときにのみデータが保持されます。値を保持する前に、ここで検証や変換を行うことも可能です。値が格納された日を表す日付を格納することもできます。このメタデータを使用することで、`mounted` メソッドは値を再度格納するかどうかを論理的に呼び出すことができます。次のバージョンを試してください。

<p data-height="265" data-theme-id="0" data-slug-hash="rdOjLN" data-default-tab="js,result" data-user="cfjedimaster" data-embed-version="2" data-pen-title="testing localstorage 2" class="codepen">See the Pen <a href="https://codepen.io/cfjedimaster/pen/rdOjLN/">testing localstorage 2</a> by Raymond Camden (<a href="https://codepen.io/cfjedimaster">@cfjedimaster</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

## 複雑な値を扱う

上記のように、ローカルストレージは単純な値でしか動作しません。オブジェクトや配列などにより複雑な値を格納するには、JSON を使用して値をシリアライズまたデシリアライズする必要があります。以下は、猫の配列を維持するより高度な例です（可能な限り最良の配列）。

``` html
<div id="app">
  <h2>Cats</h2>
  <div v-for="(cat, n) in cats">
    <p>
      <span class="cat">{{ cat }}</span>
      <button @click="removeCat(n)">Remove</button>
    </p>
  </div>

  <p>
    <input v-model="newCat">
    <button @click="addCat">Add Cat</button>
  </p>

</div>
```

この "app" は、上部のシンプルなリスト（猫を除外するボタン付き）と新しい猫を追加するための下部の小さなフォームから成り立っています。JavaScript を見てみましょう。

``` js
const app = new Vue({
  el: '#app',
  data: {
    cats: [],
    newCat: null
  },
  mounted() {
    if (localStorage.getItem('cats')) {
      try {
        this.cats = JSON.parse(localStorage.getItem('cats'));
      } catch(e) {
        localStorage.removeItem('cats');
      }
    }
  },
  methods: {
    addCat() {
      // 実際に何かしたことを入力する
      if (!this.newCat) {
        return;
      }

      this.cats.push(this.newCat);
      this.newCat = '';
      this.saveCats();
    },
    removeCat(x) {
      this.cats.splice(x, 1);
      this.saveCats();
    },
    saveCats() {
      const parsed = JSON.stringify(this.cats);
      localStorage.setItem('cats', parsed);
    }
  }
})
```

このアプリケーションでは、"ダイレクト" アクセスに対しローカルストレージ API を使用するように切り替えました。どちらも機能しますが API メソッドのほうが一般的に好まれます。`mounted` は値を取得し JSON の値を解析する必要があります。もし何か問題が発生した場合データが破損していると判断しそれを削除します。（Web アプリケーションがクライアントサイドストレージを使用するときはいつでも、ユーザーはそれにアクセスして好きなように変更することができるということを忘れないでください）

猫を処理するための3つのメソッドがあります。`addCat` と `removeCat` は `this.cats` に格納されている "生" Vue データの更新を処理します。次にデータのシリアライズと永続化を処理する `saveCats` を実行します。あなたは次のバージョンを試すことができます:

<p data-height="265" data-theme-id="0" data-slug-hash="qoYbyW" data-default-tab="js,result" data-user="cfjedimaster" data-embed-version="2" data-pen-title="localstorage, complex" class="codepen">See the Pen <a href="https://codepen.io/cfjedimaster/pen/qoYbyW/">localstorage, complex</a> by Raymond Camden (<a href="https://codepen.io/cfjedimaster">@cfjedimaster</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

## 代替パターン

ローカルストレージ API は比較的シンプルですが、多くのアプリケーションで役に立ついくつかの基本的な機能が欠けています。以下のプラグインでは、ローカルストレージをラップして使いやすくし、デフォルト値のような機能を追加します。

* [vue-local-storage](https://github.com/pinguinjkeke/vue-local-storage)
* [vue-reactive-storage](https://github.com/ropbla9/vue-reactive-storage)
* [vue2-storage](https://github.com/yarkovaleksei/vue2-storage)

## おわりに

ブラウザはサーバの永続性システムを置き換えることはありませんが、データをローカルにキャッシュする方法が複数あると、アプリケーションのパフォーマンスが大幅に向上し、Vue.js でそれを処理することでさらに強力になります。
