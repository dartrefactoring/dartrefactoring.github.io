.PHONY: serve changelog clean

serve: changelog
	bundle exec jekyll serve --livereload

changelog:
	@scripts/generate-changelog.sh

clean:
	rm -rf _site .jekyll-cache _posts/*-changelog.md
