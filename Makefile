.PHONY: build test
build:
	python3 tools/build.py

test: build
	node tests/test-core.js
	node tests/test-runtime.js
	python3 tests/test-package.py
