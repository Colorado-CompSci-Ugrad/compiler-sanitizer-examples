all:	overflow-undefined-error heap-use-after-free-error

overflow-undefined.exe: overflow-undefined.cc
	$(CXX) -o $@ -fsanitize=undefined $<

overflow-undefined-error: overflow-undefined.exe
	@echo ========================================
	@echo ==  Undefined overflow
	@echo ========================================
	@echo The following will not overflow...
	./overflow-undefined.exe 0x3fffffff
	@echo The following demonstrates overflow detection
	-./overflow-undefined.exe 0x7fffffff

heap-use-after-free.exe: heap-use-after-free.cc
	$(CXX) -o $@ -fsanitize=address $<

heap-use-after-free-error: heap-use-after-free.exe
	@echo ========================================
	@echo ==  Use after free error
	@echo ========================================
	-./heap-use-after-free.exe


clean::
	-rm -f *.o
	-rm -f *.exe
