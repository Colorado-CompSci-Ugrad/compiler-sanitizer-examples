CXXFLAGS=-g

all:	overflow-undefined-error heap-use-after-free-error heap-buffer-overflow-error

overflow-undefined.exe: overflow-undefined.cc
	$(CXX) $(CXXFLAGS) -o $@ -fsanitize=undefined $<

overflow-undefined-error: overflow-undefined.exe
	@echo ========================================
	@echo ==  Undefined overflow
	@echo ========================================
	@echo The following will not overflow...
	./overflow-undefined.exe 0x3fffffff
	@echo The following demonstrates overflow detection
	-./overflow-undefined.exe 0x7fffffff

heap-use-after-free.exe: heap-use-after-free.cc
	$(CXX) $(CXXFLAGS) -o $@ -fsanitize=address $<

heap-use-after-free-error: heap-use-after-free.exe
	@echo ========================================
	@echo ==  Use after free error
	@echo ========================================
	-./heap-use-after-free.exe

heap-buffer-overflow.exe: heap-buffer-overflow.cc
	$(CXX) $(CXXFLAGS) -o $@ -fsanitize=address $<

heap-buffer-overflow-error: heap-buffer-overflow.exe
	@echo ========================================
	@echo ==  Buffer overflow error
	@echo ========================================
	-./heap-buffer-overflow.exe

clean::
	-rm -f *.o
	-rm -f *.exe
