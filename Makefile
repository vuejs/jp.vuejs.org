all: update
	rm db.json
	hexo generate
	cp -R ./todomvc public/examples

deploy:
	hexo deploy

test:
	npm test

update:
	cd ../vue && \
		git checkout -- dist && \
		git checkout master && \
		npm run build && \
		npm run build-test > /dev/null
	cp ../vue/dist/vue.min.js themes/vue/source/js/vue.min.js
	cp ../vue/dist/vue.js themes/vue/source/js/vue.js
	node update.js
