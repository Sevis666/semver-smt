all: build test

build: bin/main

bin/main: src/main.cr
	crystal build $< -o $@

test:
	crystal spec

clean:
	rm bin/*
