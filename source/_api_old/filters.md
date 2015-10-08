title: フィルタ
type: api
order: 7
---

### capitalize

*'abc' => 'Abc'*

### uppercase

*'abc' => 'ABC'*

### lowercase

*'ABC' => 'abc'*

### currency

- このフィルタは1つ任意な引数を必要とします

*12345 => $12,345.00*

通貨記号(デフォルトは`$`)として使用される任意な引数を渡すことができます。

### pluralize

- このフィルタは少なくとも1つ引数を必要とします

フィルタされた値に基づいた引数を複数形にします。ちょうど1つの引数が指定されているとき、単純にその引数の終わりに "s" を追加します。よりもっと多くの引数が指定されているとき、それらの引数は、1、2、3、というような、複数形化される言葉の形式に対応する文字列の配列として利用されます。複数形化される数が引数の長さを上回るとき、それは配列の最後のエントリを利用します。

**例:**

``` html
{{count}} {{count | pluralize 'item'}}
```

*1 => '1 item'*  
*2 => '2 items'*

``` html
{{date}}{{date | pluralize 'st' 'nd' 'rd' 'th'}}
```

以下は結果になります:

*1 => '1st'*  
*2 => '2nd'*
*3 => '3rd'*
*4 => '4th'*
*5 => '5th'*

### json

- このフィルタは1つ任意な引数を必要とします

文字列表現(いわゆる `[object Object]`)を出力するというよりむしろ入ってくる値を JSON.stringify() を実行するフィルタです。このフィルタは、インデントレベルを1つ任意な引数として必要とします(デフォルトは 2):

``` html
<pre>{{$data | json 4}}</pre>
```

### key

- このフィルタは `v-on` との組み合わせでのみ動作します
- このフィルタはちょうど1つ引数を必要とします

キーコード(keyCode) が引数と一致するときだけ呼び出されるために、`v-on` に指定されたハンドラ(handler) を Wrap します。少数のよく使われるキーの代わりに、以下のような文字列エイリアスも利用できます。

- enter
- tab
- delete
- esc
- up
- down
- left
- right
- space

**例:**

``` html
<input v-on="keyup:doSomething | key 'enter'">
```

`doSomething` は Enter キーが押されたときにのみ呼び出されます。

### debounce

- このフィルタは `v-on` との組み合わせでのみ動作します
- このフィルタは1つ任意な引数を必要とします

X が引数であるとすると、X ミリ秒の間デバウンスするために、指定されたハンドラを Wrap します。デフォルトでは 300ms です。デバウンスされたハンドラは、少なくとも呼び出された瞬間から X ミリ秒経過するまで遅延されます。遅延期間が終わる前に再びハンドラが呼ばれた場合、遅延期間は X ミリ秒にリセットされます。

### filterBy

**構文:** `filterBy searchKey [in dataKey...]`.

- このフィルタは配列の値に対してのみ動作します

元の配列のフィルタされたバージョンを返します。`searchkey` 引数は ViewModel コンテキスト上のプロパティキーです。プロパティの値は文字列として検索するために利用されます:

``` html
<input v-model="searchText">
<ul>
  <li v-repeat="users | filterBy searchText">{{name}}</li>
</ul>
```

上記では、フィルタが適用されたとき、`users` 配列は配列の各アイテムに対して `searchText` の現在値に適した再帰的検索によってフィルタされます。例えば、もしアイテムが `{ name: 'Jack', phone: '555-123-4567' }` そして `searchText` の値が `'555'` の場合、そのアイテムは一致するとみなされます。

その他に、任意な `in dataKey` 引数では特定のプロパティを検索して絞ることができます:

``` html
<input v-model="searchText">
<ul>
  <li v-repeat="user in users | filterBy searchText in 'name'">{{name}}</li>
</ul>
```

上記では、今まさに `searchText` の値が `name` プロパティで見つかった場合は、そのアイテムのみが一致します。文字列リテラルの引数であることを明示するために、`name` をクオートで囲む必要があることに注意してください。この制約により、値 `'555'` な `searchText` は、もはやこのアイテムと一致しませんが、値 `'Jack'` なら一致します。

> 0.12.11 以降のみ

0.12.11 からは複数のデータキーを渡すことができます:

``` html
<li v-repeat="user in users | filterBy searchText in 'name' 'phone'"></li>
```

または、配列の値で動的に引数を渡すことができます:

``` html
<!-- fields = ['fieldA', 'fieldB'] -->
<div v-repeat="user in users | filterBy searchText in fields">
```

または、1つのカスタムフィルタ関数のみを渡します:

``` html
<div v-repeat="user in users | filterBy myCustomFilterFunction">
```

### orderBy

**構文:** `orderBy sortKey [reverseKey]`.

- このフィルタは配列の値に対してのみ動作します

入力された配列のソートされたバージョンを返します。`sortKey` 引数は ViewModel コンテキスト上のプロパティキーです。そのプロパティの値は配列のアイテムをソートするためのキーとして利用されます。任意な `reverseKey` 引数もまた、ViewModel コンテキスト上のプロパティキーです。しかし、この値の真偽は、結果が反転されるべきかどうかを決定します。

``` html
<ul>
  <li v-repeat="user in users | orderBy field reverse">{{name}}</li>
</ul>
```

``` js
new Vue({
  /* ... */
  data: {
    field: 'name',
    reverse: false
  }
})
```

リテラルな `sortKey` 引数としてシングルクオートも利用できます。ソート順の逆を意味するリテラルとして、`-1` を指定して利用できます:

``` html
<ul>
  <li v-repeat="user in users | orderBy 'name' -1">{{name}}</li>
</ul>
```
