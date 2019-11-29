---
title: 算出プロパティとウォッチャ
updated: 2019-04-08
type: guide
order: 5
---

## 算出プロパティ

<div class="vueschool"><a href="https://vueschool.io/lessons/vuejs-computed-properties?friend=vuejs" target="_blank" rel="sponsored noopener" title="Learn how computed properties work with Vue School">算出プロパティがどのように機能するのか Vue School の無料レッスンで学ぶ</a></div>

テンプレート内に式を書けるのはとても便利ですが、非常に簡単な操作しかできません。テンプレート内に多くのロジックを詰め込むと、コードが肥大化し、メンテナンスが難しくなります。例えば:

``` html
<div id="example">
  {{ message.split('').reverse().join('') }}
</div>
```

こうなってくると、テンプレートはシンプルでも宣言的でもなくなってしまっています。しばらく眺めて、やっとこれが `message` を逆にして表示していることに気付くでしょう。逆にしたメッセージをテンプレートの中で 2 回以上使おうとすると、問題はより深刻になります。

上記の理由から、複雑なロジックには**算出プロパティ**を利用すべきです。

### 基本的な例

``` html
<div id="example">
  <p>Original message: "{{ message }}"</p>
  <p>Computed reversed message: "{{ reversedMessage }}"</p>
</div>
```

``` js
var vm = new Vue({
  el: '#example',
  data: {
    message: 'Hello'
  },
  computed: {
    // 算出 getter 関数
    reversedMessage: function () {
      // `this` は vm インスタンスを指します
      return this.message.split('').reverse().join('')
    }
  }
})
```

結果:

{% raw %}
<div id="example" class="demo">
  <p>Original message: "{{ message }}"</p>
  <p>Computed reversed message: "{{ reversedMessage }}"</p>
</div>
<script>
var vm = new Vue({
  el: '#example',
  data: {
    message: 'Hello'
  },
  computed: {
    reversedMessage: function () {
      return this.message.split('').reverse().join('')
    }
  }
})
</script>
{% endraw %}

ここでは、算出プロパティ `reversedMessage` を宣言しました。私たちが提供した機能は、プロパティ `vm.reversedMessage` に対する getter 関数として利用されます:

``` js
console.log(vm.reversedMessage) // => 'olleH'
vm.message = 'Goodbye'
console.log(vm.reversedMessage) // => 'eybdooG'
```

コンソールを開いて、vm で遊んでみてください。`vm.reversedMessage` の値は、常に `vm.message` の値に依存しています。

通常のプロパティと同じように、テンプレート内の算出プロパティにデータバインドすることもできます。Vue は `vm.reversedMessage` が `vm.message` に依存していることを知っているので、`vm.message` が変わると `vm.reversedMessage` に依存する全てのバインディングを更新します。さらに、最も良いところは、この依存関係が宣言的に作成されていることです。算出 getter 関数は副作用がないので、テストや値の推論が容易になります。

### 算出プロパティ vs メソッド

こういった式を持つメソッドを呼び出すことで、同じ結果が実現できることに気付いたかもしれません:

``` html
<p>Reversed message: "{{ reverseMessage() }}"</p>
```

``` js
// コンポーネント内
methods: {
  reverseMessage: function () {
    return this.message.split('').reverse().join('')
  }
}
```

算出プロパティの代わりに、同じような関数をメソッドとして定義することも可能です。最終的には、2つのアプローチは完全に同じ結果になります。しかしながら、**算出プロパティはリアクティブな依存関係にもとづきキャッシュされる**という違いがあります。算出プロパティは、リアクティブな依存関係が更新されたときにだけ再評価されます。これはつまり、`message` が変わらない限りは、`reversedMessage` に何度アクセスしても、関数を再び実行することなく以前計算された結果を即時に返すということです。

`Date.now()` はリアクティブな依存ではないため、次の算出プロパティは二度と更新されないことを意味します:

``` js
computed: {
  now: function () {
    return Date.now()
  }
}
```

対称的に、メソッド呼び出しは、再描画が起きると**常に**関数を実行します。

なぜキャッシングが必要なのでしょうか？巨大な配列をループしたり多くの計算を必要とする、コストの高い **A** という算出プロパティがあることを想像してみてください。**A** に依存する他の算出プロパティもあるかもしれません。その場合、キャッシングがなければ必要以上に **A** の getter を実行することになってしまいます。キャッシングしたくない場合は、代わりにメソッドを使いましょう。

### 算出プロパティ vs 監視プロパティ

Vue は Vue インスタンス上のデータの変更を監視し反応させることができる、より汎用的な **監視プロパティ(watched property)** を提供しています。他のデータに基づいて変更する必要があるデータがある場合、特に AngularJS に慣れていたら、`watch` を多く利用したいと思うかもしれません。しかし、命令的な `watch` コールバックよりも、多くの場合では算出プロパティを利用するほうが良いでしょう。次の例で考えてみましょう:

``` html
<div id="demo">{{ fullName }}</div>
```

``` js
var vm = new Vue({
  el: '#demo',
  data: {
    firstName: 'Foo',
    lastName: 'Bar',
    fullName: 'Foo Bar'
  },
  watch: {
    firstName: function (val) {
      this.fullName = val + ' ' + this.lastName
    },
    lastName: function (val) {
      this.fullName = this.firstName + ' ' + val
    }
  }
})
```

上記のコードは命令的で冗長です。算出プロパティを利用したバージョンと比較してみましょう:

``` js
var vm = new Vue({
  el: '#demo',
  data: {
    firstName: 'Foo',
    lastName: 'Bar'
  },
  computed: {
    fullName: function () {
      return this.firstName + ' ' + this.lastName
    }
  }
})
```

こちらの方が、はるかに良くありませんか？

### 算出 Setter 関数

算出プロパティはデフォルトでは getter 関数のみですが、必要があれば setter 関数も使えます:

``` js
// ...
computed: {
  fullName: {
    // getter 関数
    get: function () {
      return this.firstName + ' ' + this.lastName
    },
    // setter 関数
    set: function (newValue) {
      var names = newValue.split(' ')
      this.firstName = names[0]
      this.lastName = names[names.length - 1]
    }
  }
}
// ...
```

`vm.fullName = 'John Doe'` を呼ぶと、setter 関数が呼び出され、`vm.firstName` と `vm.lastName` が適切に更新されます。

## ウォッチャ

多くの場合では算出プロパティの方が適切ではありますが、カスタムウォッチャが必要な時もあるでしょう。データの変更に対して反応する、より汎用的な `watch` オプションを Vue が提供しているのはそのためです。データが変わるのに応じて非同期やコストの高い処理を実行したいときに最も便利です。

例:

``` html
<div id="watch-example">
  <p>
    Ask a yes/no question:
    <input v-model="question">
  </p>
  <p>{{ answer }}</p>
</div>
```

``` html
<!-- ajax ライブラリの豊富なエコシステムや、汎用的なユーティリティ	-->
<!-- メソッドがたくさんあるので、Vue のコアはそれらを再発明せずに	-->
<!-- 小さく保たれています。この結果として、慣れ親しんでいるものだけを	-->
<!-- 使えるような自由さを Vue は持ち合わせています。			-->
<script src="https://cdn.jsdelivr.net/npm/axios@0.12.0/dist/axios.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/lodash@4.13.1/lodash.min.js"></script>
<script>
var watchExampleVM = new Vue({
  el: '#watch-example',
  data: {
    question: '',
    answer: 'I cannot give you an answer until you ask a question!'
  },
  watch: {
    // この関数は question が変わるごとに実行されます。
    question: function (newQuestion, oldQuestion) {
      this.answer = 'Waiting for you to stop typing...'
      this.debouncedGetAnswer()
    }
  },
  created: function () {
    // _.debounce は特にコストの高い処理の実行を制御するための
    // lodash の関数です。この場合は、どのくらい頻繁に yesno.wtf/api
    // へのアクセスすべきかを制限するために、ユーザーの入力が完全に
    // 終わるのを待ってから ajax リクエストを実行しています。
    // _.debounce (とその親戚である _.throttle )  についての詳細は
    // https://lodash.com/docs#debounce を見てください。
    this.debouncedGetAnswer = _.debounce(this.getAnswer, 500)
  },
  methods: {
    getAnswer: function () {
      if (this.question.indexOf('?') === -1) {
        this.answer = 'Questions usually contain a question mark. ;-)'
        return
      }
      this.answer = 'Thinking...'
      var vm = this
      axios.get('https://yesno.wtf/api')
        .then(function (response) {
          vm.answer = _.capitalize(response.data.answer)
        })
        .catch(function (error) {
          vm.answer = 'Error! Could not reach the API. ' + error
        })
    }
  }
})
</script>
```

結果:

{% raw %}
<div id="watch-example" class="demo">
  <p>
    Ask a yes/no question:
    <input v-model="question">
  </p>
  <p>{{ answer }}</p>
</div>
<script src="https://cdn.jsdelivr.net/npm/axios@0.12.0/dist/axios.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/lodash@4.13.1/lodash.min.js"></script>
<script>
var watchExampleVM = new Vue({
  el: '#watch-example',
  data: {
    question: '',
    answer: 'I cannot give you an answer until you ask a question!'
  },
  watch: {
    question: function (newQuestion, oldQuestion) {
      this.answer = 'Waiting for you to stop typing...'
      this.debouncedGetAnswer()
    }
  },
  created: function () {
    this.debouncedGetAnswer = _.debounce(this.getAnswer, 500)
  },
  methods: {
    getAnswer: function () {
      if (this.question.indexOf('?') === -1) {
        this.answer = 'Questions usually contain a question mark. ;-)'
        return
      }
      this.answer = 'Thinking...'
      var vm = this
      axios.get('https://yesno.wtf/api')
        .then(function (response) {
          vm.answer = _.capitalize(response.data.answer)
        })
        .catch(function (error) {
          vm.answer = 'Error! Could not reach the API. ' + error
        })
	}
  }
})
</script>
{% endraw %}

この場合では、`watch` オプションを利用することで、非同期処理( API のアクセス)の実行や、処理をどのくらいの頻度で実行するかを制御したり、最終的な answer が取得できるまでは中間の状態にしておく、といったことが可能になっています。これらはいずれも算出プロパティでは実現できません。

`watch` オプションに加えて、命令的な [vm.$watch API](../api/#vm-watch) を利用することもできます。
