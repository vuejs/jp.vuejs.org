---
title: フォームのバリデーション
type: cookbook
updated: 2020-04-19
order: 3
---

## 基本的な例

<div class="vueschool"><a href="https://vueschool.io/lessons/vuejs-form-validation-diy?friend=vuejs" target="_blank" rel="sponsored noopener" title="Free Vue.js Form Validation Lesson">Vue School で無料の動画レッスンを見る</a></div>

フォームのバリデーションはブラウザにネイティブサポートされますが、異なるブラウザ間での取り扱いには注意が必要です。またバリデーションが完全にサポートされている場合においても、カスタマイズしたバリデーションが必要な場合もあるため、 Vue ベースでのソリューションが適切かもしれません。簡単な例から見ていきましょう。

3 つのフィールドをもち、2 つが必須の場合。はじめに HTML を見てみましょう。

``` html
<form
  id="app"
  @submit="checkForm"
  action="https://vuejs.org/"
  method="post"
>

  <p v-if="errors.length">
    <b>Please correct the following error(s):</b>
    <ul>
      <li v-for="error in errors">{{ error }}</li>
    </ul>
  </p>

  <p>
    <label for="name">Name</label>
    <input
      id="name"
      v-model="name"
      type="text"
      name="name"
    >
  </p>

  <p>
    <label for="age">Age</label>
    <input
      id="age"
      v-model="age"
      type="number"
      name="age"
      min="0"
    >
  </p>

  <p>
    <label for="movie">Favorite Movie</label>
    <select
      id="movie"
      v-model="movie"
      name="movie"
    >
      <option>Star Wars</option>
      <option>Vanilla Sky</option>
      <option>Atomic Blonde</option>
    </select>
  </p>

  <p>
    <input
      type="submit"
      value="Submit"
    >
  </p>

</form>
```

そして、その HTML をラップしましょう。 `<form>` タグには、 Vue コンポーネントに使用する ID が存在します。フォーム送信のハンドラと `action` がありますが、一時的な URL で、本来は現実のサーバーのどこかを指しています(ここでは、サーバーサイドでのバリデーションをバックアップしています)。

その子には、エラーの状態にもとづいてそれ自身を表示・非表示とするための段落があります。これによって、フォーム上にシンプルなエラーのリストが表示されます。バリデーションはフィールドの変更時ではなく、フォーム送信の際に実行されることに注意してください。

最後に、 3 つのフィールドそれぞれに対応、対応する `v-model` が存在し、これを JavaScript で利用する値と紐付ける必要があります。その例を見てみましょう。

``` js
const app = new Vue({
  el: '#app',
  data: {
    errors: [],
    name: null,
    age: null,
    movie: null
  },
  methods:{
    checkForm: function (e) {
      if (this.name && this.age) {
        return true;
      }

      this.errors = [];

      if (!this.name) {
        this.errors.push('Name required.');
      }
      if (!this.age) {
        this.errors.push('Age required.');
      }

      e.preventDefault();
    }
  }
})
```

短くてシンプルです。エラーを保持した上で、 3 つのフォームのフィールドに対して `null` を設定する配列を定義します。 `checkForm` のロジック(フォーム送信時に実行されるもの)では、 movie の値はオプショナルなので、 name および age についてのみチェックしています。それぞれについて、空ならばチェックをし、特定のエラーを設定するだけです。 以下のデモで実行してみることができます。なお、このデモでは送信が成功すると一時的な URL へと POST されることを忘れないでください。

<p data-height="265" data-theme-id="0" data-slug-hash="GObpZM" data-default-tab="html,result" data-user="cfjedimaster" data-embed-version="2" data-pen-title="form validation 1" class="codepen">See the Pen <a href="https://codepen.io/cfjedimaster/pen/GObpZM/">form validation 1</a> by Raymond Camden (<a href="https://codepen.io/cfjedimaster">@cfjedimaster</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

## カスタムバリデーションの利用

次の例では、 2 つめのテキストフィールドを email へと切り替え、カスタマイズしたロジックでバリデーションをします。このコードは、 StackOverflow の質問「[How to validate email address in JavaScript?](https://stackoverflow.com/questions/46155/how-to-validate-email-address-in-javascript)」から持ってきています。 HTML はこちらですが、はじめの例と非常に似通っています。

``` html
<form
  id="app"
  @submit="checkForm"
  action="https://vuejs.org/"
  method="post"
  novalidate="true"
>

  <p v-if="errors.length">
    <b>Please correct the following error(s):</b>
    <ul>
      <li v-for="error in errors">{{ error }}</li>
    </ul>
  </p>

  <p>
    <label for="name">Name</label>
    <input
      id="name"
      v-model="name"
      type="text"
      name="name"
    >
  </p>

  <p>
    <label for="email">Email</label>
    <input
      id="email"
      v-model="email"
      type="email"
      name="email"
    >
  </p>

  <p>
    <label for="movie">Favorite Movie</label>
    <select
      id="movie"
      v-model="movie"
      name="movie"
    >
      <option>Star Wars</option>
      <option>Vanilla Sky</option>
      <option>Atomic Blonde</option>
    </select>
  </p>

  <p>
    <input
      type="submit"
      value="Submit"
    >
  </p>

</form>
```

ここでの変更は少しだけですが、トップのフォームに対して `novalidate="true"` に注目してください。 `type="email"` の場合、ブラウザがフィールドに入力された E メールアドレスをバリデーションしようするため、この設定は重要です。率直に言えば、この場合はブラウザを信用すべきかもしれませんが、ここではカスタムバリデーションのサンプルのため無効化しています。 JavaScript 側の更新は以下になります:

``` js
const app = new Vue({
  el: '#app',
  data: {
    errors: [],
    name: null,
    email: null,
    movie: null
  },
  methods: {
    checkForm: function (e) {
      this.errors = [];

      if (!this.name) {
        this.errors.push("Name required.");
      }
      if (!this.email) {
        this.errors.push('Email required.');
      } else if (!this.validEmail(this.email)) {
        this.errors.push('Valid email required.');
      }

      if (!this.errors.length) {
        return true;
      }

      e.preventDefault();
    },
    validEmail: function (email) {
      var re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
      return re.test(email);
    }
  }
})
```

見て分かるとおり、 `validEmail` メソッドが新しく追加されました。これは、単純に `checkForm` から呼び出されています。こちらで実際に動作させることができます:

<p data-height="265" data-theme-id="0" data-slug-hash="vWqNXZ" data-default-tab="html,result" data-user="cfjedimaster" data-embed-version="2" data-pen-title="form validation 2" class="codepen">See the Pen <a href="https://codepen.io/cfjedimaster/pen/vWqNXZ/">form validation 2</a> by Raymond Camden (<a href="https://codepen.io/cfjedimaster">@cfjedimaster</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

## カスタムバリデーションにおけるその他の例

3 つめの例は、アンケートアプリにて見たことがあるかもしれません。ユーザーは、 戦艦のそれぞれの機能に対して予算を振り分ける必要があります。かつ合計は必ず 100 となる必要があります。まずは HTML です。

``` html
<form
  id="app"
  @submit="checkForm"
  action="https://vuejs.org/"
  method="post"
  novalidate="true"
>

  <p v-if="errors.length">
    <b>Please correct the following error(s):</b>
    <ul>
      <li v-for="error in errors">{{ error }}</li>
    </ul>
  </p>

  <p>
    Given a budget of 100 dollars, indicate how much
    you would spend on the following features for the
    next generation Star Destroyer. Your total must sum up to 100.
  </p>

  <p>
    <input
      v-model.number="weapons"
      type="number"
      name="weapons"
    > Weapons <br/>
    <input
      v-model.number="shields"
      type="number"
      name="shields"
    > Shields <br/>
    <input
      v-model.number="coffee"
      type="number"
      name="coffee"
    > Coffee <br/>
    <input
      v-model.number="ac"
      type="number"
      name="ac"
    > Air Conditioning <br/>
    <input
      v-model.number="mousedroids"
      type="number"
      name="mousedroids"
    > Mouse Droids <br/>
  </p>

  <p>
    Current Total: {{total}}
  </p>

  <p>
    <input
      type="submit"
      value="Submit"
    >
  </p>

</form>
```

5 つの機能ごとの入力フォームを見てみてください。そして、 `v-model` 属性に対して、 `.number` が付与されていることを注目してください。これは、値が利用される時に、 number にキャストするように Vue に対して指定することが可能です。しかしながら、この機能にはバグがあり、値が空の場合は空文字列に戻ってしまいます。以下に、その回避策を示しています。ユーザーにとってわかりやすくするため、現在の合計値をリアルタイムで見ることができるように追加しました。 JavaScript 側を見てみましょう。

``` js
const app = new Vue({
  el: '#app',
  data:{
    errors: [],
    weapons: 0,
    shields: 0,
    coffee: 0,
    ac: 0,
    mousedroids: 0
  },
  computed: {
     total: function () {
       // Vue は空の値を string に変換するので、パースする必要があります
       return Number(this.weapons) +
         Number(this.shields) +
         Number(this.coffee) +
         Number(this.ac+this.mousedroids);
     }
  },
  methods:{
    checkForm: function (e) {
      this.errors = [];

      if (this.total != 100) {
        this.errors.push('Total must be 100!');
      }

      if (!this.errors.length) {
        return true;
      }

      e.preventDefault();
    }
  }
})
```

合計値を算出プロパティとして設定し、バグを取り除いて動かすために十分に簡潔でした。 checkForm メソッドでは、合計値が 100 かどうかだけ確認する必要があります。こちらで実際に動作させることができます:

<p data-height="265" data-theme-id="0" data-slug-hash="vWqGoy" data-default-tab="html,result" data-user="cfjedimaster" data-embed-version="2" data-pen-title="form validation 3" class="codepen">See the Pen <a href="https://codepen.io/cfjedimaster/pen/vWqGoy/">form validation 3</a> by Raymond Camden (<a href="https://codepen.io/cfjedimaster">@cfjedimaster</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

## サーバーサイドでのバリデーション

最後の例では、 Ajax を利用してサーバーにてバリデーションを行うものを作成しました。このフォームでは、新しい product の名前を尋ね、その名前が一意かをチェックします。このバリデーションのために、サーバーレスな [Netlify](https://netlify.com/) アクションを書きました。ここでは重要ではありませんが、ロジックはこちらになります:

``` js
exports.handler = async (event, context) => {
  
    const badNames = ['vista', 'empire', 'mbp'];
    const name = event.queryStringParameters.name;

    if (badNames.includes(name)) {
      return { 
        statusCode: 400,         
        body: JSON.stringify({error: 'Invalid name passed.'}) 
      }
    }

    return {
      statusCode: 204
    }

}

```

基本的には "vista", "empire", "mbp" 以外の名前で問題ありません。フォームをみてみましょう。

``` html
<form
  id="app"
  @submit="checkForm"
  method="post"
>

  <p v-if="errors.length">
    <b>Please correct the following error(s):</b>
    <ul>
      <li v-for="error in errors">{{ error }}</li>
    </ul>
  </p>

  <p>
    <label for="name">New Product Name: </label>
    <input
      id="name"
      v-model="name"
      type="text"
      name="name"
    >
  </p>

  <p>
    <input
      type="submit"
      value="Submit"
    >
  </p>

</form>
```

ここには特別な要素はありません。 JavaScript の例に進みましょう。

``` js
const apiUrl = 'https://vuecookbook.netlify.com/.netlify/functions/product-name?name=';

const app = new Vue({
  el: '#app',
  data: {
    errors: [],
    name: ''
  },
  methods:{
    checkForm: function (e) {
      e.preventDefault();

      this.errors = [];

      if (this.name === '') {
        this.errors.push('Product name is required.');
      } else {
        fetch(apiUrl + encodeURIComponent(this.name))
        .then(async res => {
          if (res.status === 204) {
            alert('OK');
          } else if (res.status === 400) {
            let errorResponse = await res.json();
            this.errors.push(errorResponse.error);
          }
        });
      }
    }
  }
})
```

OpenWhisk にて実行される API の URL を表す変数から始まります。 `checkForm` を見てみましょう。この例においては、フォームが送信されないようにしています(ただし、 HTML 上で Vue にて動かすことはできます). ここで、 `this.name` が空かどうかのチェックを行い、その後 API を叩いていることが見てとれます。問題がある場合は、先ほどの例と同じようにエラーを追加しています。うまくいけば、なにもしません(ここではアラートのみ) URL に含まれる product の名前をもとに新しいページへと遷移させたり、他の動作を実行することもできます。以下でデモを実行できます:

<p data-height="265" data-theme-id="0" data-slug-hash="BmgzeM" data-default-tab="js,result" data-user="cfjedimaster" data-embed-version="2" data-pen-title="form validation 4" class="codepen">See the Pen <a href="https://codepen.io/cfjedimaster/pen/BmgzeM/">form validation 4</a> by Raymond Camden (<a href="https://codepen.io/cfjedimaster">@cfjedimaster</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

## 代替パターン

このクックブックでは、手作業でフォームのバリデーションを行うことに焦点をあてていますが、もちろん、これを取り扱うための素晴らしい Vue ライブラリが多く存在します。パッケージ化されたライブラリに切り替えることで、アプリケーションの最終的なサイズに影響をあたえることがありますが、切り替えることは大きなメリットとなりえるでしょう。十分にテストされ、定期的に更新されているコードとして、 Vue のフォームバリデーションライブラリには次のようなものがあります:

* [vuelidate](https://github.com/monterail/vuelidate)
* [VeeValidate](https://logaretm.github.io/vee-validate/)
