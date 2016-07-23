---
title: 算出プロパティ
type: guide
order: 5
---

テンプレート内に書ける式はとても便利ですが、それは非常に簡単な操作しかできません。テンプレートは View の構造を説明するはずです。テンプレート内に多くのロジックを詰め込むと、コードが肥大化し、メンテナンスが難しくなります。Vue.js がバインディング式を1つの式だけに制限するのはこのためです。複数の式を要求するロジックがある場合、**算出プロパティ (computed property)** を使用する必要があります。

### 基本の例

``` html
<div id="example">
  a={{ a }}, b={{ b }}
</div>
```

``` js
var vm = new Vue({
  el: '#example',
  data: {
    a: 1
  },
  computed: {
    // 算出 getter 関数
    b: function () {
      // `this` は vm インスタンスを指します
      return this.a + 1
    }
  }
})
```

結果:

{% raw %}
<div id="example" class="demo">
  a={{ a }}, b={{ b }}
</div>
<script>
var vm = new Vue({
  el: '#example',
  data: {
    a: 1
  },
  computed: {
    b: function () {
      return this.a + 1
    }
  }
})
</script>
{% endraw %}

ここでは、算出プロパティ `b` を宣言しました。私たちが提供した機能は、プロパティ `vm.b` に対しての getter 関数として使用されます:

``` js
console.log(vm.b) // -> 2
vm.a = 2
console.log(vm.b) // -> 3
```

コンソールを開いて、`vm` で遊んでみてください。`vm.b` の値は、常に `vm.a` の値に依存しています。

通常のプロパティのようにテンプレート内の算出プロパティにデータバインドすることができます。Vue は `vm.b` が `vm.a` に依存していることに気づいており、Vue は `vm.a` が変化するとき `vm.b` に依存する全てのバインディングを更新します。そして、最も良いところは、私達がこの依存関係を宣言的に作成したことです。算出 getter 関数は純粋で副作用がないので、テストとその考察が簡単になります。

### 算出プロパティ 対 $watch

Vue.js は Vue インスタンスのデータの変更を監視できる `$watch` と呼ばれる API メソッドを提供しています。他のデータに基づいて変更する必要があるデータがある場合、特に AngularJS に慣れていたら、`$watch` を使用するのは魅力的に映るでしょう。しかし、命令的な `$watch` コールバックよりもむしろ算出プロパティを使用するほうがよいでしょう。次の例で考えてみましょう:

``` html
<div id="demo">{{fullName}}</div>
```

``` js
var vm = new Vue({
  data: {
    firstName: 'Foo',
    lastName: 'Bar',
    fullName: 'Foo Bar'
  }
})

vm.$watch('firstName', function (val) {
  this.fullName = val + ' ' + this.lastName
})

vm.$watch('lastName', function (val) {
  this.fullName = this.firstName + ' ' + val
})
```

上記のコードは命令的で冗長です。次の算出プロパティのを使ったバージョンと比較してみましょう:

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

こちらの方が、はるかによくありませんか？

### 算出 Setter 関数

算出プロパティはデフォルトでは getter 関数のみだけですが、必要ならば setter 関数も使えます:

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

`vm.fullname = 'John Doe'` を呼ぶと、setter 関数が呼び出され、`vm.firstName` と `vm.lastName` がそれに応じて更新されます。

どうやって算出プロパティが更新されるかという技術的な詳細は、リアクティブシステムを説明した [別のセクション](reactivity.html#Inside_Computed_Properties) で議論されています。
