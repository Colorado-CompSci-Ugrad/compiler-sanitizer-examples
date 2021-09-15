CXXFLAGS=-g

all:	overflow-undefined-error heap-use-after-free-error \
	heap-buffer-overflow-error \
	stack-buffer-overflow-error \
	global-buffer-overflow-error \
	uninit-memory-read-error

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

stack-buffer-overflow.exe: stack-buffer-overflow.cc
	$(CXX) $(CXXFLAGS) -o $@ -fsanitize=address $<

stack-buffer-overflow-error: stack-buffer-overflow.exe
	@echo ========================================
	@echo ==  Buffer overflow error
	@echo ========================================
	-./stack-buffer-overflow.exe

global-buffer-overflow.exe: global-buffer-overflow.cc
	$(CXX) $(CXXFLAGS) -o $@ -fsanitize=address $<

global-buffer-overflow-error: global-buffer-overflow.exe
	@echo ========================================
	@echo ==  Buffer overflow error
	@echo ========================================
	-./global-buffer-overflow.exe

uninit-memory-read.exe: uninit-memory-read.cc
	$(CXX) $(CXXFLAGS) -o $@ -fsanitize=memory $<

uninit-memory-read-error: uninit-memory-read.exe
	@echo ========================================
	@echo ==  Uninitlized memory read
	@echo ========================================
	@echo This will not cause an error
	./uninit-memory-read.exe 5
	@echo Any value other than 5 will cause an error
	-./uninit-memory-read.exe 2
	-./uninit-memory-read.exe 7

clean::
	-rm -f *.o
	-rm -f *.exe
	-rm -rf *.dSYM # macos
