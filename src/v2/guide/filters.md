---
title: フィルター
updated: 2018-01-30
type: guide
order: 305
---

Vue.js では、一般的なテキストフォーマットを適用するために使用できるフィルタを定義できます。フィルタは、**mustache 展開と `v-bind` 式**、2 つの場所で使用できます(後者は2.1.0以降でサポートされています)。フィルタは JavaScript 式の末尾に追加する必要があります。これは "パイプ('|')" 記号で表されます。

``` html
<!-- mustaches -->
{{ message | capitalize }}

<!-- v-bind -->
<div v-bind:id="rawId | formatId"></div>
```

コンポーネントのオプション内でローカルフィルタを定義できます:

``` js
filters: {
  capitalize: function (value) {
    if (!value) return ''
    value = value.toString()
    return value.charAt(0).toUpperCase() + value.slice(1)
  }
}
```

もしくは Vue インスタンスを作成する前にグローバルでフィルタを定義することもできます:

``` js
Vue.filter('capitalize', function (value) {
  if (!value) return ''
  value = value.toString()
  return value.charAt(0).toUpperCase() + value.slice(1)
})

new Vue({
  // ...
})
```

以下は `capitalize` フィルタの使用例です。

{% raw %}
<div id="example_1" class="demo">
  <input type="text" v-model="message">
  <p>{{ message | capitalize }}</p>
</div>
<script>
  new Vue({
    el: '#example_1',
    data: function () {
      return {
        message: 'john'
      }
    },
    filters: {
      capitalize: function (value) {
        if (!value) return ''
        value = value.toString()
        return value.charAt(0).toUpperCase() + value.slice(1)
      }
    }
  })
</script>
{% endraw %}

フィルタ関数は常に式の値(前のチェーンの結果)を第一引数として受け取ります。この例では、 `capitalize` フィルタ関数は引数として `message` の値を受け取ります。

フィルタは連結できます:

``` html
{{ message | filterA | filterB }}
```

この場合、単一の引数で定義された `filterA` は `message` の値を受け取り、`filterB`の単一引数に `filterA` の結果を渡して `filterB` 関数が呼び出されます。

フィルタは JavaScript 関数なので、引数を取ることができます:

``` html
{{ message | filterA('arg1', arg2) }}
```

ここで `filterA` は3つの引数をとる関数として定義されています。`message` の値は最初の引数に渡されます。プレーン文字列 `'arg1'` は、第2引数として `filterA` に渡されます。そして、式 `arg2` の値が評価され、第3引数としてフィルタに渡されます。