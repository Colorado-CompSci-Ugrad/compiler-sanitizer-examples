all:	overflow-undefined-error

overflow-undefined.exe: overflow-undefined.cc
	$(CXX) -o $@ -fsanitize=undefined $<

overflow-undefined-error: overflow-undefined.exe
	@echo The following will not overflow...
	./overflow-undefined.exe 0x3fffffff
	@echo The following demonstrates overflow detection
	./overflow-undefined.exe 0x7fffffff

clean::
	-rm -f *.o
	-rm -f *.exe
