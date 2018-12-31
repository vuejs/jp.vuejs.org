---
title: Practical use of scoped slots with GoogleMaps
type: cookbook
order: 14
---

## ベースとなる部分のコード例

> Base Example

slot 内の template が、slot の content をレンダリングをする役割を持った子コンポーネントの側の「データ」へ、アクセスできたらいいのに、と思うことはないでしょうか。

(訳注: ここでの `slot` というのは `slot タグ` のことではありません。`slot タグ` を持ったコンポネーネントを使用する際に、そのコンポーネントタグの内側に配置される部分のことです。`<WithSlotTagComponent>この部分 = slot</WithSlotTagComponent>`)

> There are situations when you want the template inside the slot to be able to access data from the child component that is responsible for rendering the slot content. 

とくにそれが有効なのは、子コンポーネントの data プロパティを使用するカスタム template を作成する必要がある場合です。まさに `scoped slots` を使用するのに最適な場面です。  

> This is particularly useful when you need freedom in creating custom templates that use the child component's data properties. That is a typical use case for scoped slots.

外部 API の設定と使用準備をするコンポーネントを実装する場合を想定してみましょう。そのコンポーネントは、他のコンポーネントから使用されるわけですが、具体的な template と密接には結びついません。そのためレンダリングする template が異なる様々な場所で使いまわすことができ、それでいて特定の API を持つ同じベースオブジェクトを使用します。

> Imagine a component that configures and prepares an external API to be used in another component, but is not tightly coupled with any specific template. Such a component could then be reused in multiple places rendering different templates but using the same base object with specific API.

では `GoogleMapLoader.vue` コンポーネントを作っていきましょう。このコンポーネントは以下の処理をおこないます。

> We'll create a component (`GoogleMapLoader.vue`) that:

1.  [Google Maps API](https://developers.google.com/maps/documentation/javascript/reference/) を初期化する。
2. `google` と `map` の2つの object を作成する。
3. これら2つの object を `GoogleMapLoader` を使用する親コンポーネントに対して露出させている。


1. Initializes the [Google Maps API](https://developers.google.com/maps/documentation/javascript/reference/)
2. Creates `google` and `map` objects
3. Exposes those objects to the parent component in which the `GoogleMapLoader` is used

次のセクションでこのコードの詳細をみていくことにしましょう。そして何が起きているのかということも説明していきます。

> Below is an example of how this can be achieved. We will analyze the code piece-by-piece and see what is actually happening in the next section.
 
まずは `GoogleMapLoader.vue` の template 部分を作りましょう。

> Let’s first establish our `GoogleMapLoader.vue` template:

```html
<template>
  <div>
    <div class="google-map" ref="googleMap"></div>
    <template v-if="Boolean(this.google) && Boolean(this.map)">
      <slot
        :google="google"
        :map="map"
      />
    </template>
  </div>
</template>
```

次に script の部分で、いくつかの props をコンポーネントに渡す必要があります。この props の内容を使って [Google Maps API](https://developers.google.com/maps/documentation/javascript/reference/) と [Map object](https://developers.google.com/maps/documentation/javascript/reference/map#Map) の設定をすることになります。

> Now, our script needs to pass some props to the component which allows us to set the [Google Maps API](https://developers.google.com/maps/documentation/javascript/reference/) and [Map object](https://developers.google.com/maps/documentation/javascript/reference/map#Map):

```js
import GoogleMapsApiLoader from 'google-maps-api-loader'

export default {
  props: {
    mapConfig: Object,
    apiKey: String,
  },

  data() {
    return {
      google: null,
      map: null
    }
  },

  async mounted() {
    const googleMapApi = await GoogleMapsApiLoader({
      apiKey: this.apiKey
    })
    this.google = googleMapApi
    this.initializeMap()
  },

  methods: {
    initializeMap() {
      const mapContainer = this.$refs.googleMap
      this.map = new this.google.maps.Map(
        mapContainer, this.mapConfig
      )
    }
  }
}
```

ここまでのコードは部分的なものですが、完成した全体のコードは以下の CodeSandbox で確認することができます。

> This is just part of a working example, you can find the whole example in the Codesandbox below.

<iframe src="https://codesandbox.io/embed/1o45zvxk0q" style="width:100%; height:500px; border:0; border-radius: 4px; overflow:hidden;" sandbox="allow-modals allow-forms allow-popups allow-scripts allow-same-origin"></iframe>

## 実例：Google Map Loader コンポーネントの作成

> Real-World Example: Creating a Google Map Loader component

### マップを初期化するコンポーネントを作成する

> 1. Create a component that initializes our map

`GoogleMapLoader.vue`

template の中にマップのためのコンテナを作成しましょう。このコンテナへ Google Maps API から抽出した [Map](https://developers.google.com/maps/documentation/javascript/reference/map#Map) がマウントされます。

> In the template, we create a container for the map which will be used to mount the [Map](https://developers.google.com/maps/documentation/javascript/reference/map#Map) object extracted from the Google Maps API.

```html
<template>
  <div>
    <div class="google-map" ref="googleMap"></div>
  </div>
</template>
```

次に、親コンポーネントから props を受け取る必要がありますね。この props を使って Google Map を設定します。この props は次の2つから成ります。

> Next up, our script needs to receive props from the parent component which will allow us to set the Google Map. Those props consist of:

- [mapConfig](https://developers.google.com/maps/documentation/javascript/reference/3/map#MapOptions): Google Maps の設定用 object
- [apiKey](https://developers.google.com/maps/documentation/javascript/get-api-key): Google Maps の使用に必要な自分の personal api key

---

- [mapConfig](https://developers.google.com/maps/documentation/javascript/reference/3/map#MapOptions): Google Maps config object
- [apiKey](https://developers.google.com/maps/documentation/javascript/get-api-key): Our personal api key required by Google Maps

```js
import GoogleMapsApiLoader from 'google-maps-api-loader'

export default {
  props: {
    mapConfig: Object,
    apiKey: String,
  },
```

google と map の初期値を `null` に設定します。

> Then, we set the initial values of google and map to null:

```js
  data() {
    return {
      google: null,
      map: null
    }
  },
```

`mounted` フック時に、 `googleMapApi` と `Map` オブジェクトを ` GoogleMapsApi` からインスタンス化し、それを作成されたインスタンスへ `google` と `map` という値としてセットします。

(訳注: 作成されたインスタンスというのは GoogleMapLoader コンポーントのことで、このコンポーネントの data の google, map へ値をセットしている)

> On `mounted` hook we instantiate a `googleMapApi` and `Map` objects from the `GoogleMapsApi` and we set the values of `google` and `map` to the created instances:

```js
  async mounted() {
    const googleMapApi = await GoogleMapsApiLoader({
      apiKey: this.apiKey
    })
    this.google = googleMapApi
    this.initializeMap()
  },

  methods: {
    initializeMap() {
      const mapContainer = this.$refs.googleMap
      this.map = new this.google.maps.Map(mapContainer, this.mapConfig)
    }
  }
}
```

ここまでは順調ですね。マップに作るのに必要な全ての作業が終了しましたので、あとはいつも通りに他のオブジェクトをこのマップ（マーカー、ポリラインなど）に追加していば、マップコンポーネントは完成します。

> So far, so good. With all that done, we could continue adding the other objects to the map (Markers, Polylines, etc.) and use it as an ordinary map component.

しかし今回は `GoogleMapLoader` には map オブジェクトを準備する役割「だけ」を与えたいわけですね。つまり、マーカー、ポリラインなど他の要素はこのコンポーネントにはレンダリングさせたくないわけです。

> But, we want to use our `GoogleMapLoader` component only as a loader that prepares the map — we don’t want to render anything on it.

そうするためには、`GoogleMapLoader` を使用する親コンポーネント(訳注: 今回の例では `TravelMap`)が、`GoogleMapLoader` の `this.google` と `this.map` にアクセスできるようにしなくてはいけません。こういうときに [scoped slots](https://vuejs.org/v2/guide/components-slots.html#Scoped-Slots) が大活躍します。Scoped slot を使うことで、子コンポーネントに存在するプロパティを、親コンポーネントへと露出させることができます。Inseption の世界のことのように聞こえるかもしれませんが、もう何分か私の話を辛抱強く聞いてほしい。そうすれば深くまで入り込むことができる。

(訳注: Inseption とは 2010 年にアメリカで公開され大ヒットした SF 映画で、劇中に登場する職業=エクストラクターが、他人の頭の中（＝夢の中）に侵入して、潜在意識の中からアイデアを”エクストラクション（抜き出す）する様に、子コンポーネントの data を親コンポーネントから参照できる scoped slot を例えている)

> To achieve that, we need to allow the parent component that will use our `GoogleMapLoader` to access `this.google` and `this.map` that are set inside the `GoogleMapLoader` component. That’s where [scoped slots](https://vuejs.org/v2/guide/components-slots.html#Scoped-Slots) really shine. Scoped slots allow us to expose the properties set in a child component to the parent component. It may sound like Inception, but bear with me one more minute as we break that down further.

### 2. 先ほど作った初期化用コンポーネントを使用するコンポーネントを作成する

> 2. Create component that uses our initializer component.

`TravelMap.vue`

template の中で、`GoogleMapLoader` コンポーネントをレンダーし、さらにこのコンポーネントへ、マップをを初期化するために必要な props を渡します。

In the template, we render the `GoogleMapLoader` component and pass props that are required to initialize the map.

```html
<template>
  <GoogleMapLoader
    :mapConfig="mapConfig"
    apiKey="yourApiKey"
  />
</template>
```

このコンポーネントの Script 部分はこうなるでしょう。

> Our script tag will look like this:

```js
<script>
import GoogleMapLoader from './GoogleMapLoader'
import { mapSettings } from '@/constants/mapSettings'

export default {
  components: {
    GoogleMapLoader
  },

  computed: {
    mapConfig () {
      return {
        ...mapSettings,
        center: { lat: 0, lng: 0 }
      }
    },
  },
}
</script>
```

まだ scoped slot を使っていないので、追加していきましょう。

> Still no scoped slots, so let's add one.

### 3. scoped slot を追加して、親コンポーネントへ google と map のプロパティを露出させる

> Expose `google` and `map` properties to the parent component by adding a scoped slot.

最後に scoped slot を追加して、望む仕事をしてもらうことにしましょう。これによって、親コンポーネントの中から、子コンポーネントのプロパティにアクセすることができるようになります。子コンポーネントの中に `<slot>` タグを追加し、さらに `v-bind` もしくは `:propName` を使って、親コンポーネントへと露出させたい値をプロパティとして渡します。これは通常の props の役割である、子コンポーネントへと値を伝える機能とは異なっています。`<slot>` タグの中で props を渡すことで、(訳注: 親から子へという通常の) 流れとは反対の方向に、データを流すことができます。

> Finally, we can add a scoped slot that will do the job and allow us to access the child component props in the parent component. We do that by adding the `<slot>` tag in the child component and passing the props that we want to expose (using `v-bind` directive or `:propName` shorthand). It does not differ from passing the props down to the child component, but doing it in the `<slot>` tag will reverse the direction of data flow.

`GoogleMapLoader.vue`

```html
<template>
  <div>
    <div class="google-map" ref="googleMap"></div>
    <template v-if="Boolean(this.google) && Boolean(this.map)">
      <slot
        :google="google"
        :map="map"
      />
    </template>
  </div>
</template>
```

さて、子コンポーネントに slot を用意しましたので、次にそうやって親コンポーネントへと露出した props を受け取って、それを使うことにしましょう。


> Now, when we have the slot in the child component, we need to receive and consume the exposed props in the parent component.

### 4. `slot-scope` を用いて、露出された props を親コンポーネントで受け取る

> Receive exposed props in the parent component using `slot-scope` attribute.

親コンポーネントで露出された props を受け取るために、temlate 要素を用意して、その要素に `slot-scope` 属性を付与します。この属性の中では、子コンポーネントから露出されている props を全てもったオブジェクトにアクセスすることができます。オブジェクトそれ自体を使用することもできますし、[オブジェクトのプロパティを分割して](https://vuejs.org/v2/guide/components-slots.html#Destructuring-slot-scope) 必要な値だけを受け取ることもできます。

> To receive the props in the parent component, we declare a template element and use the `slot-scope` attribute. This attribute has access to the object carrying all the props exposed from the child component. We can grab the whole object or we can [de-structure that object](https://vuejs.org/v2/guide/components-slots.html#Destructuring-slot-scope) and only what we need.

今回はオブジェクトのプロパティを分割して、必要なものだけを使うことにしましょう。

> Let’s de-structure this thing to get what we need.

`TravelMap.vue`

```html
<GoogleMapLoader
  :mapConfig="mapConfig"
  apiKey="yourApiKey"
>
  <template slot-scope="{ google, map }">
  	{{ map }}
  	{{ google }}
  </template>
</GoogleMapLoader>
```

こうすることで `google` と `map` というプロパティは `TravelMap` コンポーネントのスコープには存在しないにも関わらず、これにアクセスすることができ、そしてそれを template の中で使用することができます。

> Even though the `google` and `map` props do not exist in the `TravelMap` scope, the component has access to them and we can use them in the template.

なぜこんなことをするのか疑問に思うかもしれません。それからそんなことをする利点があるのかも不思議でしょう。

> You might wonder why would we do things like that and what is the use of all that?

(訳注:次の一文は、翻訳はをしたものの、正確な意味がわかりません。申し訳ない) Scoped slot は、レンダーされた要素ではなく、代わりに template を slot に渡すことができます。`scoped` と呼ばれているのは、これを使うことで子コンポーネントのデータにアクセスでき、それでいて template は親コンポーネントの scope でレンダーされるからです。 これによって親コンポーネントで作られたカスタムコンテンツを、子コンポーネントは使って temlate を作ることができます。(訳注: これは普通の slot の機能ではある)

> Scoped slots allow us to pass a template to the slot instead of a rendered element. It’s called a `scoped` slot because it will have access to certain child component data even though the template is rendered in the parent component scope. This gives us the freedom to fill the template with custom content from the parent component.

### 5. Create factory components for Markers and Polylines

さてマップはすでにできているので、2つのファクトリーコンポーネントを作りましょう。この2つのファクトリーコンポーネントは、マップに要素を追加する役割を持ちます。

> Now when we have our map ready we will create two factory components that will be used to add elements to the `TravelMap`.

`GoogleMapMarker.vue`

```js
import { POINT_MARKER_ICON_CONFIG } from '@/constants/mapSettings'

export default {
  props: {
    google: {
      type: Object,
      required: true
    },
    map: {
      type: Object,
      required: true
    },
    marker: {
      type: Object,
      required: true
    }
  },

  mounted() {
    new this.google.maps.Marker({
      position: this.marker.position,
      marker: this.marker,
      map: this.map,
      icon: POINT_MARKER_ICON_CONFIG
    })
  }
}
```

`GoogleMapLine.vue`

```js
import { LINE_PATH_CONFIG } from '@/constants/mapSettings'

export default {
  props: {
    google: {
      type: Object,
      required: true
    },
    map: {
      type: Object,
      required: true
    },
    path: {
      type: Array,
      required: true
    }
  },

  mounted() {
    new this.google.maps.Polyline({
      path: this.path,
      map: this.map,
      ...LINE_PATH_CONFIG
    })
  }
}
```

どちらのファクトリーコンポーネントも、Marker と Polyline を抽出するために必要な `google` と、それから作成した要素をマウントするために必要な `map` を受け取っています。

> Both of these receive `google` that we use to extract the required object (Marker or Polyline) as well as `map` which gives as a reference to the map on which we want to place our element.

またどちらのコンポーネントも、要素を作るために必要な追加の props をうけとっています。今回の例では、`GoogleMapMarker` コンポーネントは `marker` を、`GoogleMapLine` コンポーネントは `path` をそれぞれ受け取っていますね。

> Each component also expects an extra prop to create a corresponding element. In this case, we have `marker` and `path`, respectively.

mounted フックが走ったら、Marker と Polyline という要素を作って、それを map に紐づけています。map へ紐づけているのは、オブジェクトコンストラクタ(訳注: `new this.google.maps.Marker()` `new this.google.maps.Polyline()` の部分)に `this.map` を渡している部分です。

> On the mounted hook, we create an element (Marker/Polyline) and attach it to our map by passing the `map` property to the object constructor.

あともう1つだけ、やることが残っています…

> There’s still one more step to go...

### 6. 他のマップの要素を追加する

> Add elements to map

では先ほど作った factory コンポーネントを使うことで、マップに要素を追加させるようにしましょう。そのためには factory コンポーネントをレンダーするわけですが、その際に `google` と `map` の2つのオブジェクトを渡します。そうすることで、このデータが正しいところへと流れていきます。(訳注: つまりそれぞれの factory コンポーネントの必要な場所へ)

> Let’s use our factory components to add elements to our map. We must render the factory component and pass the `google` and `map` objects so data flows to the right places.

他にも必要な値があります。1つは `marker` オブジェクトで、これにはマーカーをどこに配置するのかという位置情報が入っていて、もう1つは `path` オブジェクトで、これはポリライン(訳注: 直線をつなげて作られる折り曲がった線)の座標情報が入っています。

> We also need to provide the data that’s required by the element itself. In our case, that’s the `marker` object with the position of the marker and the `path` object with Polyline coordinates.
 
さあさあ、これらの値を直接渡していきます。

> Here we go, integrating the data points directly into the template:

```html
<GoogleMapLoader
  :mapConfig="mapConfig"
  apiKey="yourApiKey"
>
  <template slot-scope="{ google, map }">
    <GoogleMapMarker
      v-for="marker in markers"
      :key="marker.id"
      :marker="marker"
      :google="google"
      :map="map"
    />
    <GoogleMapLine
      v-for="line in lines"
      :key="line.id"
      :path.sync="line.path"
      :google="google"
      :map="map"
    />
  </template>
</GoogleMapLoader>
```

それから script の中で、factory component を script の中でインポートし、marker と lines という名前でコンポーネントに値をセットします。

> We need to import the required factory components in our script and set the data that will be passed to the markers and lines:

```js
import { mapSettings } from '@/constants/mapSettings'

export default {
  components: {
    GoogleMapLoader,
    GoogleMapMarker,
    GoogleMapLine
  },

  data () {
    return {
      markers: [
      { id: 'a', position: { lat: 3, lng: 101 } },
      { id: 'b', position: { lat: 5, lng: 99 } },
      { id: 'c', position: { lat: 6, lng: 97 } },
      ],
      lines: [
        { id: '1', path: [{ lat: 3, lng: 101 }, { lat: 5, lng: 99 }] },
        { id: '2', path: [{ lat: 5, lng: 99 }, { lat: 6, lng: 97 }] }
      ],
    }
  },

  computed: {
    mapConfig () {
      return {
        ...mapSettings,
        center: this.mapCenter
      }
    },

    mapCenter () {
      return this.markers[1].position
    }
  },
}
```

## When To Avoid This Pattern

このような非常に複雑な解決法は魅力的に思われるかもしれませんが、ある一定のレベルまでその複雑さが進んでしまうと、その抽象性が、この機能を構成する他のコードの部分よりもかなり高くなってしまい、浮いた存在になってしまうでしょう。そこまできた場合は、add-on に抽出することを検討する段階でしょう。(訳注: add-on はおそらく、plugin や mixin などのことです)

> It might be tempting to create a very complex solution based on the example, but at some point we can get to the situation where this abstraction becomes an independent part of the code living in our codebase. If we get to that point it might be worth considering extraction to an add-on.

## まとめ
> Wrapping Up
 
さあ全てやりとげました。こまごまと作業をしてきた結果として `GoogleMapLoader` コンポーネントを、マップを使う際のベースとして使いまわすことができるようになりました。それぞれの用途に合わせた template を渡せばこのコンポーネントに渡せば、どんなものにでも対応できます。例えば今回のケースとは異なるマーカーや、ポリラインがない場合にも使えますね。今回紹介したパターンを使うことで `GoogleMapLoader` にケースによってことなる必要なコンテンツを渡すだけで、この目的を達成できます。

> That's it. With all those bits and pieces created we can now re-use the `GoogleMapLoader` component as a base for all our maps by passing different templates to each one of them. Imagine that you need to create another map with different Markers or just Markers without Polylines. By using the above pattern it becomes very easy as we just need to pass different content to the `GoogleMapLoader` component.

このパターンは Google Map の場合にしか使えないわけではありません。どんなライブラリであれ、ベースとなるコンポーネントをセットして、(ベースコンポーネントを呼び出したコンポーネントが実行する) API を露出させればいいのです。

> This pattern is not strictly connected to Google Maps; it can be used with any library to set the base component and expose the library's API that might be then used in the component that summoned the base component.
