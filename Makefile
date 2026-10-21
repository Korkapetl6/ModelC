.PHONY: build test
build:
	python3 tools/build.py
test: build
	node tests/core.js
	node tests/controller.js
	python3 tests/package.py
