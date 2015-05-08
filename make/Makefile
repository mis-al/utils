all: hello

hello: main.o factorial.o hello.o
	g++ main.cpp hello.cpp factorial.cpp -o hello

main.o: main.cpp
	g++ -c main.cpp

factorial.o: factorial.cpp
	g++ -c factorial.cpp

hello.o: hello.cpp
	g++ -c hello.cpp

clean:
	rm *o hello