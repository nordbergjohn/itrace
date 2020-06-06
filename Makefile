SRC := src
TEST_SRC := test/src

cov:
	gcc ${SRC}/main.c -o cov
test_prog:
	gcc -g ${TEST_SRC}/test.c -o test_prog
	objcopy --only-keep-debug test_prog test_prog.dbg
	strip -g test_prog

run_test: cov test_prog
	./cov test_prog | addr2line -e test_prog.dbg -f -p | grep -v ? | uniq

clean:
	rm -rf cov test_prog


