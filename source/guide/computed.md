title: Computed Properties
type: guide
order: 8
---

Vue.js のインライン expression は非常に便利ですが、最良のユースケースはシンプルな boolean 演算や文字列の連結を使用したものです。より複雑なロジックに関しては、 **computed properties** を活用しましょう。

Vue.js では `computed` オプションを使って computed properties を定義します。

computed property は他の値に依存する値を宣言的に記述するために利用されます。テンプレート内で computed property にデータバインドすると、Vue は computed property が依存する値のどれかが変化したときに DOM を更新することを知ります。これは非常にパワフルにでき、かつより宣言的でデータドリブンなコードになり、それによってメンテナンスが容易になります。

多くの場合 computed property を使うことは命令的な `$watch` コールバックを使うよりも良いアイデアです。この例を考えてみます:

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

上記のコードは命令的で扱いにくいです。computed property によるバージョンと比べてみましょう:

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

ずっと良いでしょう。加えて、computed property による setter も定義できます。

``` js
// ...
computed: {
  fullName: {
    // getter
    get: function () {
      return this.firstName + ' ' + this.lastName
    },
    // setter
    set: function (newValue) {
      var names = newValue.split(' ')
      this.firstName = names[0]
      this.lastName = names[names.length - 1]
    }
  }
}
// ...
```

### computed property のキャッシュ

0.12.8 より前は、computed property は getter のように振舞っていました - アクセスするたびに getter 関数は再評価されていました。0.12.8 ではこれが改善されました - computed property はキャッシュされ reactive dependency のうち1つでも変化した場合にのみ再評価されます。

巨大な配列のループと多くの計算を必要とする高価な computed property A を持っているとします。そして、他に A に依存する computed property を持っているとします。キャッシュが無いと、A の getter が必要以上に多く呼び出され、潜在的なパフォーマンスの問題の原因になります。キャッシュがあると、A の値は依存するものの値が変化しない限りキャッシュされ、繰り返しアクセスしても必要のない計算を引き起こしません。

しかしながら、"reactive dependency" がどのように考えられているのか理解することは重要です:

``` js
var vm = new Vue({
  data: {
    msg: 'hi'
  },
  computed: {
    example: {
      return Date.now() + this.msg
    }
  }
})
```

上記の例では、computed property は `vm.msg` を頼っています。これは Vue インスタンス上で監視されているデータプロパティであるため、reactive property であるとされます。`vm.msg` が変化したときは、`vm.example` の値は再評価されます。

しかし、Vue のデータ監視システムとの間で何もしないため、`Date.now()` は reactive property **ではありません**。そのため、プログラムで `vm.example` にアクセスしたとき、`vm.msg` の再評価が行われない限りは同じタイムスタンプが残り続けるでしょう。

アクセスするたびに `vm.example` を単純に再評価して欲しいというような、シンプルな getter のような挙動を保ちたいという場合もあるでしょう。0.12.11 からは、特定の computed property のキャッシュを無効化できます。

``` js
computed: {
  example: {
    cache: false,
    get: function () {
      return Date.now() + this.msg
    }
  }
}
```

これで、`vm.example` にアクセスするたびにタイムスタンプは更新されるでしょう。しかし、これは JavaScript 内でのプログラムでのアクセスにのみ影響します; データバインディングは依然として依存関係ドリブンです。テンプレート内で `{% raw %}{{example}}{% endraw %}` として computed property をバインドした場合、DOM は reactive property が変化したときのみ更新されるでしょう。

次: [カスタムディレクティブ](/guide/custom-directive.html)
