all: build test

build: bin/main

bin/main: $(shell find src -type f -name "*.cr")
	crystal build $< -o $@

test:
	crystal spec

clean:
	rm bin/*
