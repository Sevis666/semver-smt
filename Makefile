all: build test

build: bin/main

bin/main: $(shell find src -type f -name "*.cr")
	crystal build $< -o $@

test:
	crystal spec

tar: clean
	tar czf ROBIN.tgz -C .. $(shell basename $(CURDIR))

clean:
	rm -f bin/* ROBIN.tgz
