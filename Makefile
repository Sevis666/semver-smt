all: build test

build: bin/main

bin/main: $(shell find src -type f -name "*.cr")
	crystal build src/main.cr -o bin/main

test:
	crystal spec

tar: clean
	tar czf ROBIN.tgz --exclude=*.tgz -C .. $(shell basename $(CURDIR))

clean:
	rm -f bin/* ROBIN.tgz
