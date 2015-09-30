title: カスタムフィルタ
type: guide
order: 14
---

## 基本

カスタムディレクティブと同様に、グローバルな `Vue.filter()` を使用してカスタマイズしたフィルタを登録することができます。引数には **filterID** と **filter function** を渡します。このフィルタの関数は引数として値を受け取って、変換した値を返します:

``` js
Vue.filter('reverse', function (value) {
  return value.split('').reverse().join('')
})
```

``` html
<!-- 'abc' => 'cba' -->
<span v-text="message | reverse"></span>
```

フィルタ関数はインラインの引数を受け取ることもできます:

``` js
Vue.filter('wrap', function (value, begin, end) {
  return begin + value + end
})
```

``` html
<!-- 'hello' => 'before hello after' -->
<span v-text="message | wrap 'before' 'after'"></span>
```

## Two-way フィルタ

これまでフィルタはモデルから渡される値をビューに表示される前に変換するために使用していました。しかし、input 要素などのビューからモデルに書き込みがされる前に値を変換するフィルタの定義も可能です。

``` js
Vue.filter('currencyDisplay', {
  currencyDisplay: {
    // model -> view
    // input 要素が更新される際に値を変換します。
    read: function(val) {
      return '$'+val.toFixed(2)
    },
    // view -> model
    // データが更新される際に値を変換します。
    write: function(val, oldVal) {
      var number = +val.replace(/[^\d.]/g, '')
      return isNaN(number) ? 0 : number
    }
  }
})
```

デモ:

{% raw %}
<div id="two-way-filter-demo" class="demo">
  <input type="text" v-model="money | currencyDisplay">
  <p>Model value: {{money}}</p>
</div>
<script>
new Vue({
  el: '#two-way-filter-demo',
  data: {
    money: 123.45
  },
  filters: {
    currencyDisplay: {
      read: function(val) {
        return '$'+val.toFixed(2)
      },
      write: function(val, oldVal) {
        var number = +val.replace(/[^\d.]/g, '')
        return isNaN(number) ? 0 : number
      }
    }
  }
})
</script>
{% endraw %}

## 動的な引数

もし、フィルタ引数が引用符 ('') で閉じていない場合は、現在の vm データコンテキストで動的に評価されます。それに加えて、フィルタ関数はいつも現在の vm は `this` コンテキストとして利用して起動されます。例えば:

``` html
<input v-model="userInput">
<span>{{msg | concat userInput}}</span>
```

``` js
Vue.filter('concat', function (value, input) {
  // ここは `input` === `this.userInput`
  return value + input
})
```

上記の簡単な例では、 expression をそのまま記述した時と同じ結果が得られます。しかし、複数のステートメントが必要な複雑な処理においては、Computed Property もしくは カスタムフィルタが必要になります。

ビルトインの `filterBy` と `orderBy` フィルタは共に渡された配列に対して重要な変更を行うものであり、所有者である Vue インスタンスの現在の状態に依存するものです。

以上！これで次は [コンポーネントシステム](/guide/components.html) がどのように動作するか学ぶ時間です。
