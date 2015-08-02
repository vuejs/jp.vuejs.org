all: update
	rm db.json
	hexo generate
	cp -R ./todomvc public/examples

test:
	@echo 'test ignore !!' >/dev/null 2>&1

deploy:	all
	hexo deploy

update:
	cd ../vue && git checkout master && grunt build
	cp ../vue/dist/vue.min.js themes/vue/source/js/vue.min.js
	cp ../vue/dist/vue.js themes/vue/source/js/vue.js
	node update.js
