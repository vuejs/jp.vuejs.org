---
title: Vue CLI 3.0 is here!
date: 2018-8-11 00:00:00
---
https://medium.com/the-vue-point/vue-cli-3-0-is-here-c42bebe28fbb

Over the past few months, we’ve been working really hard on the next generation of Vue CLI, the standard build toolchain for Vue applications. Today we are thrilled to announce the release of [Vue CLI 3.0](https://cli.vuejs.org/) and all the exciting features that come with it.

## Rich Built-in Features
Vue CLI 3 is a completely different beast from its previous version. The goal of the rewrite is two-fold:

1. Reduce configuration fatigue of modern frontend tooling, especially when mixing multiple tools together;
1. Incorporate best practices in the toolchain as much as possible so it becomes the default for any Vue app.

At the core, Vue CLI provides a pre-configured build setup built on top of webpack 4. We aim to minimize the amount of configuration developers have to go through, so any Vue CLI 3 project comes with out-of-the-box support for:

- Pre-configured webpack features such as [hot module replacement](https://webpack.js.org/concepts/hot-module-replacement/), [code-splitting](https://webpack.js.org/guides/code-splitting/), [tree-shaking](https://webpack.js.org/guides/tree-shaking/#src/components/Sidebar/Sidebar.jsx), [efficient long term caching](https://medium.com/webpack/predictable-long-term-caching-with-webpack-d3eee1d3fa31), [error overlays](https://webpack.js.org/configuration/dev-server/#devserver-overlay), etc.
- ES2017 transpilation (plus common proposals like object rest spread and dynamic import) and usage-based polyfills injection via Babel 7 + [preset-env](https://github.com/babel/babel/tree/master/packages/babel-preset-env)
- Support for PostCSS (with autoprefixer enabled by default) and all major CSS pre-processors
- Auto-generated HTML with hashed asset links and preload/prefetch resource hints
- Modes and cascading environment variables via `.env` files
- [Modern mode](https://cli.vuejs.org/guide/browser-compatibility.html#modern-mode): ship native ES2017+ bundle and legacy bundle in parallel (details below)
- [Multi-page mode](https://cli.vuejs.org/config/#pages): build an app with multiple HTML/JS entry points
- [Build targets](https://cli.vuejs.org/guide/build-targets.html#app): build Vue Single-File Components into a library or native web components (details below)

In addition, there are many optional integrations that you can mix and match when you create a new project, such as:

- [TypeScript](https://github.com/vuejs/vue-cli/tree/dev/packages/%40vue/cli-plugin-typescript)
- [PWA](https://github.com/vuejs/vue-cli/tree/dev/packages/%40vue/cli-plugin-pwa)
- [Vue Router](https://router.vuejs.org/) & [Vuex](https://vuex.vuejs.org/)
- [ESLint](https://eslint.org/) / [TSLint](https://palantir.github.io/tslint/) / [Prettier](https://prettier.io/)
- Unit Testing via [Jest](https://jestjs.io/) or [Mocha](https://mochajs.org/)
- E2E Testing via [Cypress](https://www.cypress.io/) or [Nightwatch](http://nightwatchjs.org/)

![](https://cdn-images-1.medium.com/max/880/1*llJjroMC2YJWizrXOgCDuA.png)
<figcaption style="font-size:14px;text-align:center;">Pick as much or as little as you want.</figcaption>

Most importantly, Vue CLI makes sure all the above features work nicely together so that you don’t have to do the plumbing yourself.

## Configurable with No Need to Eject
All the features listed above work with zero configuration from your part: when you scaffold a project via Vue CLI 3, it installs the Vue CLI runtime service (@vue/cli-service), selected feature plugins, and generates the necessary config files for you. In most cases, you just need to focus on writing the code.

However, CLI tools that attempt to abstract away underlying dependencies often strip away the ability to fine-tweak the internal configurations for those dependencies —in order to make such changes, the user typically has to “eject”, i.e. checking the raw configurations into the project in order to make changes. The downside of this is that once you eject, you are on your own and won’t be able to upgrade to a newer version of the tool in the long run.

We acknowledge the importance of being able to get lower-level access to the configs, but we also don’t want to leave ejected users behind, so we’ve figured out a way for you to tweak almost all aspects of the configurations without ejecting.

For 3rd party integrations like Babel, TypeScript and PostCSS, Vue CLI respects the corresponding configuration files for these tools. For webpack, the user can either leverage [webpack-merge](https://github.com/survivejs/webpack-merge) to merge simple options into the final config, or [precisely target and tweak existing loaders and plugins via webpack-chain](https://cli.vuejs.org/guide/webpack.html#chaining-advanced). In addition, Vue CLI ships with the [`vue inspect`](https://cli.vuejs.org/guide/webpack.html#inspecting-the-project-s-webpack-config) command to help you inspect the internal webpack configuration. The best part though, is that you don’t need to eject just to make small tweaks — you can still upgrade the CLI service and plugins to receive fixes and new features.

![](https://cdn-images-1.medium.com/max/880/1*jiQtvLrGM4MP78tXaEhLRg.png)
<figcaption style="font-size:14px;text-align:center;">Using <a href="https://github.com/mozilla-neutrino/webpack-chain">webpack-chain</a> to tweak the options for <a href="https://github.com/jantimon/html-webpack-plugin">html-webpack-plugin</a></figcaption>

## Extensible Plugin System
We want Vue CLI to be a platform the community can built upon, so we designed the new version with a plugin architecture from day one. A Vue CLI 3 plugin can be very powerful: it can inject dependencies and files during the app’s scaffolding phase, and tweak the app’s webpack config or inject additional commands to the CLI service during development. Most of the built-in integrations like TypeScript are implemented as plugins using the same [plugin API](https://github.com/vuejs/vue-cli/blob/dev/packages/%40vue/cli-service/lib/PluginAPI.js) that is available to all community plugins. If you are interested in writing your own plugin, check out the [plugin dev guide](https://cli.vuejs.org/dev-guide/plugin-dev.html#service-plugin).

In Vue CLI 3 we no longer have “templates” — instead, you can create your own [remote preset](https://cli.vuejs.org/guide/plugins-and-presets.html#remote-presets) to share your selection of plugins and options with other developers.

## Graphical User Interface
Thanks to the amazing work by [Guillaume CHAU](https://medium.com/@Akryum), Vue CLI 3 ships with a full-blown GUI that not only can create new projects, but also manage the plugins and tasks inside the projects (yes, it even comes with the fancy webpack dashboard shown below):

![](https://cdn-images-1.medium.com/max/880/1*gFc-hzoWXxts2VT40pic1Q.png)
<figcaption style="font-size:14px;text-align:center;">This does not require Electron — just launch it with `vue ui`.</figcaption>

>Note: although Vue CLI 3 is released as stable, the UI is still in beta. Expect a few quirks here and there.

## Instant Prototyping
It isn’t fun to wait for `npm install` before you can write any code. Sometimes we just need that instant access to a working environment to get that spark of inspiration flowing. <span style="background-color: transparent !important; background-image: linear-gradient(to bottom, rgba(219, 249, 229, 1), rgba(219, 249, 229, 1));">With Vue CLI 3’s `vue serve` command, this is all you need to do to start prototyping with Vue single-file components:</span>

![](https://cdn-images-1.medium.com/max/880/1*3eLVIg4G46mc5nEte_tzzA.png)
<figcaption style="font-size:14px;text-align:center;">Instant prototyping with `vue serve`</figcaption>

The prototyping dev server comes with the same setup of a standard app, so you can easily move the prototype `*.vue` file into a properly scaffolded project’s `src` folder to continue working on it.

## Versatile and Future Ready
### Modern Mode
With Babel we are able to leverage all the newest language features in ES2015+, but that also means we have to ship transpiled and polyfilled bundles in order to support older browsers. These transpiled bundles are often more verbose than the original native ES2015+ code, and also parse and run slower. Given that today a good majority of the modern browsers have decent support for native ES2015+, it is a waste shipping heavier and less efficient code to these browsers just because we have to support older ones.

Vue CLI offers a “Modern Mode” to help you solve this problem. When building for production with the following command:

```
vue-cli-service build --modern
```

Vue CLI will produce two versions of your app: one modern bundle targeting modern browsers that support [ES modules](https://jakearchibald.com/2017/es-modules-in-browsers/), and one legacy bundle targeting older browsers that do not.

The cool part though is that there are no special deployment requirements. The generated HTML file automatically employs the techniques discussed in [Phillip Walton’s excellent post](https://philipwalton.com/articles/deploying-es2015-code-in-production-today/):

- The modern bundle is loaded with `<script type="module">`, in browsers that support it; they are also preloaded using `<link rel="modulepreload">` instead.
- The legacy bundle is loaded with `<script nomodule>`, which is ignored by browsers that support ES modules.
- A fix for `<script nomodule>` in Safari 10 is also automatically injected.

For a Hello World app, the modern bundle is already 16% smaller. In production, the modern bundle will typically result in significantly faster parsing and evaluation, improving your app’s loading performance. The best part? All it needs from you is a `--modern` command line flag.

>The reason we are not making modern mode the default is the longer build time and some extra config needed if you are working with CORS / CSP.

### Building as Web Components
You can build any `*.vue` component in a Vue CLI 3 project into a web component with:

```
vue-cli-service build --target wc --name my-element src/MyComponent.vue
```

This will generate a JavaScript bundle that wraps and registers the internal Vue component as a native custom element on the page, which can then be used simply as `<my-element>`. The consuming page does need to include Vue on the page as a global, but other than that, Vue is completely hidden as an implementation detail.

You can even build multiple `*.vue` components into a code-split bundle with multiple chunks:

```
vue-cli-service build --target wc-async 'src/components/*.vue'
```

By including a small entry file from the resulting bundle, it registers all components as native custom elements, but only fetches the code for the underlying Vue component when the corresponding custom element is first instantiated on the page.

- - -

With Vue CLI 3, the same codebase can be used to build an app, a UMD library, or native web components. You get to enjoy the same Vue development experience no matter what targets you are building towards.

## Try It Out Today!
Vue CLI 3 is now ready to serve as the standard build tool behind Vue applications, but this is just the beginning. As mentioned, a longer-term goal for Vue CLI is to incorporate best practices from both the present and the future into the toolchain. We hope that as the web platform evolves, Vue CLI can keep helping its users ship performant apps.

You can try it out right now by [following the instruction from the docs](https://cli.vuejs.org/guide/installation.html). We can’t wait to see what you build with it. Happy hacking!

_Thanks to [Pine Wu](https://medium.com/@octref.register?source=post_page), [Edd Yerburgh](https://medium.com/@eddyerburgh?source=post_page), [Eduardo San Martin Morote](https://medium.com/@posva?source=post_page), and [Chris Fritz](https://medium.com/@chrisvfritz?source=post_page)._