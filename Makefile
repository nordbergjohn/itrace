SRC := src
TEST_SRC := test/src

cov:
	gcc ${SRC}/main.c -o bin/itrace
test_prog:
	gcc -g ${TEST_SRC}/test.c -o bin/test_prog
	mkdir -p dbg
	objcopy --only-keep-debug bin/test_prog dbg/test_prog.dbg
	strip -g bin/test_prog

run_partial_coverage_test: cov test_prog
	./bin/itrace bin/test_prog | addr2line -e dbg/test_prog.dbg -f -p | grep -v ? | uniq

run_full_coverage_test: cov test_prog
	./bin/itrace bin/test_prog 1 2 3 | addr2line -e dbg/test_prog.dbg -p | grep -v ? | uniq

clean:
	rm -rf bin/itrace bin/test_prog dbg/


