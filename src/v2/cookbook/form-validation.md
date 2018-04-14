---
title: フォームのバリデーション
type: cookbook
updated: 2018-03-20
order: 3
---

> ⚠️注意: この内容は原文のままです。現在翻訳中ですのでお待ち下さい。🙏

## ベースとなる例

フォームのバリデーションはブラウザにネイティブサポートされていますが、異なるブラウザ間での取り扱いには注意が必要です。またバリデーションが完全にサポートされている場合であっても、カスタマイズしたバリデーションが必要な場合もあるため、 Vue ベースでのソリューションが適切かもしれません。簡単な例から見ていきましょう。

3 つのフィールドをもち、2 つが必須の場合。はじめに HTML を見てみましょう。

``` html
<form id="app" @submit="checkForm" action="https://vuejs.org/" method="post">

  <p v-if="errors.length">
    <b>Please correct the following error(s):</b>
    <ul>
      <li v-for="error in errors">{{ error }}</li>
    </ul>
  </p>

  <p>
    <label for="name">Name<label>
    <input type="text" name="name" id="name" v-model="name">
  </p>

  <p>
    <label for="age">Age<label>
    <input type="number" name="age" id="age" v-model="age" min="0">
  </p>

  <p>
    <label for="movie">Favorite Movie<label>
    <select name="movie" id="movie" v-model="movie">
      <option>Star Wars</option>
      <option>Vanilla Sky</option>
      <option>Atomic Blonde</option>
    </select>
  </p>

  <p>
    <input type="submit" value="Submit">
  </p>

</form>
```

そして、その HTML をラップしましょう。 `<form>` タグには、 Vue コンポーネントに使用する ID が存在します。フォーム送信のハンドラと `action` がありますが、一時的な URL であり、現実のサーバーのどこかを指しています(ここでは、サーバーサイドでのバリデーションをバックアップしています)。

その子には、エラーの状態にもとづいてそれ自身を表示・非表示とするための段落があります。これによって、フォーム上にシンプルなエラーのリストが表示されます。バリデーションはフィールドの変更時ではなく、フォーム送信の際に実行されることに注意してください。

最後に、3つのフィールドそれぞれに対応、対応する `v-model`が存在し、これをJavaScriptで利用する値と接続する必要があります。その例を見てみましょう。

``` js
const app = new Vue({
  el:'#app',
  data:{
    errors:[],
    name:null,
    age:null,
    movie:null
  },
  methods:{
    checkForm:function(e) {
      if(this.name && this.age) return true;
      this.errors = [];
      if(!this.name) this.errors.push("Name required.");
      if(!this.age) this.errors.push("Age required.");
      e.preventDefault();
    }
  }
})
```

短くてシンプルです。エラーを保持した上で、 3 つのフォームのフィールドに対して `null` を設定する配列を定義します。 `checkForm` のロジック(フォーム送信時に実行されるもの)では、 movie の値はオプショナルであるため、 name および age についてのみチェックしています。それぞれについて、空であればチェックをし、特定のエラーを設定するだけです。 以下のデモで実行してみることができます。なお、このデモでは送信が成功すると一時的な URL へと POST されることを忘れないでください。

<p data-height="265" data-theme-id="0" data-slug-hash="GObpZM" data-default-tab="html,result" data-user="cfjedimaster" data-embed-version="2" data-pen-title="form validation 1" class="codepen">See the Pen <a href="https://codepen.io/cfjedimaster/pen/GObpZM/">form validation 1</a> by Raymond Camden (<a href="https://codepen.io/cfjedimaster">@cfjedimaster</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

## Using Custom Validation

For the second example, the second text field (age) was switched to email which will be validated with a bit of custom logic. The code is taken from the StackOverflow question, [How to validate email address in JavaScript?](https://stackoverflow.com/questions/46155/how-to-validate-email-address-in-javascript). This is an awesome question because it makes your most intense Facebook political/religious argument look like a slight disagreement over who makes the best beer. Seriously - it's insane. Here is the HTML, even though it's really close to the first example.

``` html
<form id="app" @submit="checkForm" action="https://vuejs.org/" method="post" novalidate="true">

  <p v-if="errors.length">
    <b>Please correct the following error(s):</b>
    <ul>
      <li v-for="error in errors">{{ error }}</li>
    </ul>
  </p>

  <p>
    <label for="name">Name<label>
    <input type="text" name="name" id="name" v-model="name">
  </p>

  <p>
    <label for="email">Email<label>
    <input type="email" name="email" id="email" v-model="email">
  </p>

  <p>
    <label for="movie">Favorite Movie<label>
    <select name="movie" id="movie" v-model="movie">
      <option>Star Wars</option>
      <option>Vanilla Sky</option>
      <option>Atomic Blonde</option>
    </select>
  </p>

  <p>
    <input type="submit" value="Submit">
  </p>

</form>
```

While the change here is small, note the `novalidate="true"` on top. This is important because the browser will attempt to validate the email address in the field when `type="email"`. Frankly it may make more sense to trust the browser in this case, but as we wanted an example with custom validation, we're disabling it. Here's the updated JavaScript.

``` js
const app = new Vue({
  el:'#app',
  data:{
    errors:[],
    name:null,
    email:null,
    movie:null
  },
  methods:{
    checkForm:function(e) {
      this.errors = [];
      if(!this.name) this.errors.push("Name required.");
      if(!this.email) {
        this.errors.push("Email required.");
      } else if(!this.validEmail(this.email)) {
        this.errors.push("Valid email required.");
      }
      if(!this.errors.length) return true;
      e.preventDefault();
    },
    validEmail:function(email) {
      var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
      return re.test(email);
    }
  }
})
```

As you can see, we've added `validEmail` as a new method and it is simply called from `checkForm`. You can play with this example here:

<p data-height="265" data-theme-id="0" data-slug-hash="vWqNXZ" data-default-tab="html,result" data-user="cfjedimaster" data-embed-version="2" data-pen-title="form validation 2" class="codepen">See the Pen <a href="https://codepen.io/cfjedimaster/pen/vWqNXZ/">form validation 2</a> by Raymond Camden (<a href="https://codepen.io/cfjedimaster">@cfjedimaster</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

## Another Example of Custom Validation

For the third example, we've built something you've probably seen in survey apps. The user is asked to spend a "budget" for a set of features for a new Star Destroyer model. The total must equal 100. First, the HTML.

``` html
<form id="app" @submit="checkForm" action="https://vuejs.org/" method="post" novalidate="true">

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
    <input type="number" name="weapons" v-model.number="weapons"> Weapons <br/>
    <input type="number" name="shields" v-model.number="shields"> Shields <br/>
    <input type="number" name="coffee" v-model.number="coffee"> Coffee <br/>
    <input type="number" name="ac" v-model.number="ac"> Air Conditioning <br/>
    <input type="number" name="mousedroids" v-model.number="mousedroids"> Mouse Droids <br/>
  </p>

  <p>
    Current Total: {{total}}
  </p>

  <p>
    <input type="submit" value="Submit">
  </p>

</form>
```

Note the set of inputs covering the five different features. Note the addition of `.number` to the `v-model` attribute. This tells Vue to cast the value to a number when you use it. However, there is a bug with this feature such that when the value is blank, it turns back into a string. You'll see the workaround below. To make it a bit easier for the user, we also added a current total right below so they can see, in real time, what their total is. Now let's look at the JavaScript.

``` js
const app = new Vue({
  el:'#app',
  data:{
    errors:[],
    weapons:0,
    shields:0,
    coffee:0,
    ac:0,
    mousedroids:0
  },
  computed:{
     total:function() {
       // must parse cuz Vue turns empty value to string
       return Number(this.weapons)+
         Number(this.shields)+
         Number(this.coffee)+
         Number(this.ac+this.mousedroids);
     }
  },
  methods:{
    checkForm:function(e) {
      this.errors = [];
      if(this.total != 100) this.errors.push("Total must be 100!");
      if(!this.errors.length) return true;
      e.preventDefault();
    }
  }
})
```

We set up the total value as a computed value, and outside of that bug I ran into, it was simple enough to setup. My checkForm method now just needs to see if the total is 100 and that's it. You can play with this here:

<p data-height="265" data-theme-id="0" data-slug-hash="vWqGoy" data-default-tab="html,result" data-user="cfjedimaster" data-embed-version="2" data-pen-title="form validation 3" class="codepen">See the Pen <a href="https://codepen.io/cfjedimaster/pen/vWqGoy/">form validation 3</a> by Raymond Camden (<a href="https://codepen.io/cfjedimaster">@cfjedimaster</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

## サーバーサイドでのバリデーション

最後の例では、 Ajax を利用してサーバーにてバリデーションを行うものを作成しました。このフォームでは、新しい product の名前を尋ね、その名前が一意であることをチェックします。このバリデーションのために、サーバーレスな [OpenWhisk](http://openwhisk.apache.org/) アクションを書きました。ここでは重要ではありませんが、ロジックはこちらになります:

``` js
function main(args) {

    return new Promise((resolve, reject) => {

        // bad product names: vista, empire, mbp
        let badNames = ['vista','empire','mbp'];
        if(badNames.includes(args.name)) reject({error:'Existing product'});
        resolve({status:'ok'});

    });

}
```

基本的には "vista", "empire", "mbp" 以外の名前で問題ありません。フォームをみてみましょう。

``` html
<form id="app" @submit="checkForm" method="post">

  <p v-if="errors.length">
    <b>Please correct the following error(s):</b>
    <ul>
      <li v-for="error in errors">{{ error }}</li>
    </ul>
  </p>

  <p>
    <label for="name">New Product Name: </label>
    <input type="text" name="name" id="name" v-model="name">
  </p>

  <p>
    <input type="submit" value="Submit">
  </p>

</form>
```

ここには特別な要素はありません。 JavaScript の例に進みましょう。

``` js
const apiUrl = 'https://openwhisk.ng.bluemix.net/api/v1/web/rcamden%40us.ibm.com_My%20Space/safeToDelete/productName.json?name=';

const app = new Vue({
  el:'#app',
  data:{
    errors:[],
    name:''
  },
  methods:{
    checkForm:function(e) {
      e.preventDefault();
      this.errors = [];
      if(this.name === '') {
        this.errors.push("Product name is required.");
      } else {
        fetch(apiUrl+encodeURIComponent(this.name))
        .then(res => res.json())
        .then(res => {
          if(res.error) {
            this.errors.push(res.error);
          } else {
            // redirect to a new URL, or do something on success
            alert('ok!');
          }
        });
      }
    }
  }
})
```

OpenWhisk にて実行される API の URL を表す変数から始まります。 `checkForm` を見てみましょう。 In this version, we always prevent the form from submitting (which, by the way, could be done in the HTML with Vue as well). You can see a basic check on `this.name` being empty, and then we hit the API. If it's bad, we add an error as before. If it's good, right now we do nothing (just an alert), but you could navigate the user to a new page with the product name in the URL, or do other actions as well. You can run this demo below:

<p data-height="265" data-theme-id="0" data-slug-hash="BmgzeM" data-default-tab="js,result" data-user="cfjedimaster" data-embed-version="2" data-pen-title="form validation 4" class="codepen">See the Pen <a href="https://codepen.io/cfjedimaster/pen/BmgzeM/">form validation 4</a> by Raymond Camden (<a href="https://codepen.io/cfjedimaster">@cfjedimaster</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

## 代替パターン

このクックブックでは、手作業でフォームのバリデーションを行うことに焦点をあてていますが、もちろん、これを取り扱うための素晴らしい Vue ライブラリが多く存在します。パッケージ化されたライブラリに切り替えることで、アプリケーションの最終的なサイズに影響をあたえることがありますが、切り替えることは大きなメリットとなりえるでしょう。十分にテストされ、定期的に更新されているコードとして、 Vue のフォームバリデーションライブラリには次のようなものがあります:

* [vuelidate](https://github.com/monterail/vuelidate)
* [VeeValidate](http://vee-validate.logaretm.com/)

