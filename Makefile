CC = gcc
CF = -Wall -O3

OBJ = obj/calc-lex.o obj/calc-bison.o

all: bin/calc

bin/calc: $(OBJ)
	$(CC) -lfl $(OBJ) -o $@

obj/%.o: src/%.c
	$(CC) $(CF) -c $< -o $@

obj/calc-bison.o: src/calc-bison.c
obj/calc-lex.o: src/calc-lex.c

src/calc-lex.c: flex
src/calc-bison.c: bison

flex: src/calc.l
	flex -o src/calc-lex.c src/calc.l

bison: src/calc.y
	bison -d -o src/calc-bison.c src/calc.y

setup:
	mkdir -p bin
	mkdir -p obj

clean:
	rm -rf bin/*
	rm -rf obj/*

.PHONY: all clean setup
