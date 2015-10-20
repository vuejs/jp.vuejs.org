---
title: 算出プロパティ
type: guide
order: 5
---

テンプレート内での式はとても便利ですが、それらは実際には簡単な操作のためのものです。テンプレートはあなたの View の構造を記述することを意味しています。あなたのテンプレートに中にあまりにも多くのロジックを置きすぎるとそれらは肥大化し、維持するのが難しいです。Vue.js がバインディング式を1つの式だけに制限するのはこのためです。複数の式を要求する任意のロジックでは、**算出プロパティ (computed property)** を使用する必要があります。

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

ここでは、算出プロパティ `b` を宣言しました。私達が提供する機能は、私達がプロパティ `vm.b` に対して getter 関数として使用されます:

``` js
console.log(vm.b) // -> 2
vm.a = 2
console.log(vm.b) // -> 3
```

コンソールを開いて、例の vm をあなた自身で遊ぶことができます。`vm.b` の値は、常に `vm.a` の値に依存しています。

通常のプロパティのようにテンプレートで算出プロパティにデータバインドすることができます。Vue は `vm.b` が `vm.a` に依存していることに気づいており、Vue は `vm.a` が変化するとき `vm.b` に依存する任意のバインディングを更新します。そして、最良の部分は、私達がこの依存関係を宣言的に作成したことです。算出 getter 関数は純粋でありそして副作用がないので、それは簡単にテストしたりそしてほぼ理由になります。

### 算出プロパティ 対 $watch

Vue.js は Vue インスタンスでデータ変更を監視することを可能にする `$watch` と呼ばれる API メソッドを提供しています。いくつかの他のデータに基づいて変更する必要があるいくつかのデータを持っているとき、それは、特に、AngularJS のバックグラウンドからやってきている場合は、`$watch` を使用するのが魅力的です。しかしながら、それはしばしば、命令的な `$watch` コールバックよりもむしろ算出プロパティを使用するのがいっそうよいアイディアです。この例を考えてみます:

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

上記コードは命令的でくどいです。算出プロパティのバージョンでそれを比較します:

``` js
var demo = new Vue({
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

こちらの方が、はるかによいではありませんか？

### 算出 Setter 関数

算出プロパティはデフォルトでは getter 関数のみだけですが、必要なとき setter 関数も提供することができます:

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

今、`vm.fullname = 'John Doe'` を呼ぶとき、setter が呼び出され、`vm.firstName` と `vm.lastName` は適宜更新します。

技術的な詳細はリアクティブシステム専用の [別のセクション](reactivity.html#Inside_Computed_Properties) で、どうやって算出プロパティが更新されるか、説明されています。
