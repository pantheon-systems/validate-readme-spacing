lint:
	shellcheck ./*.sh

test:
	./test.sh

tag-release:
	./tag-release.sh
