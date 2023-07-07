lint:
	shellcheck ./check-readme-newlines.sh

test:
	./test.sh

tag-release:
	./tag.sh
