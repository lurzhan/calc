CC := gcc
CF := -Wall -O3

flex-sources := src/calc.l
bison-sources := src/calc.y

flex-gen-sources := $(patsubst %.l, %-flex.c, $(flex-sources))
bison-gen-sources := $(patsubst %.y, %-bison.c, $(bison-sources))
bison-gen-headers := $(patsubst %.y, %-bison.h, $(bison-sources))

sources := $(bison-gen-sources) $(flex-gen-sources)
objects := $(patsubst %.c, %.o, $(patsubst src%, obj%, $(sources)))

target: bin/calc

bin/calc: $(objects)
	$(CC) -lfl $^ -o $@

$(objects): obj/%.o: src/%.c
	$(CC) $(CF) -c $< -o $@

$(flex-gen-sources): src/%-flex.c: src/%.l
	flex -o $@ $<

$(bison-gen-sources): src/%-bison.c: src/%.y
	bison -d -o $@ $<

.PHONY: setup
setup:
	mkdir -p bin
	mkdir -p obj

.PHONY: clean
clean:
	rm -rf obj/*
	rm -f bin/calc
	rm -f $(flex-gen-sources) $(bison-gen-sources) $(bison-gen-headers)
