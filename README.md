# Examples of sanitizers in C++/Clang++

These programs show single, common programming errors that can be
identified and caught by the "Sanitizer" mechanism in GCC/LLVM and
VS-code compilers.

The repository is also using Github "actions" to run
[cppcheck](cppcheck_report.txt) and cpplint (see the "actions" tab) for defense programming / styling.

Running the code produces the following output.

```
$ make 
clang++ -g -o overflow-undefined.exe -fsanitize=undefined overflow-undefined.cc
========================================
== Undefined overflow
========================================
The following will not overflow...
./overflow-undefined.exe 0x3fffffff
isTMax(3fffffff) = 0
The following demonstrates overflow detection
./overflow-undefined.exe 0x7fffffff
overflow-undefined.cc:25:42: runtime error: signed integer overflow: 2147483647 + 1 cannot be represented in type 'int'
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior overflow-undefined.cc:25:42 in 
isTMax(7fffffff) = 1
clang++ -g -o heap-use-after-free.exe -fsanitize=address heap-use-after-free.cc
========================================
== Use after free error
========================================
./heap-use-after-free.exe
=================================================================
==1674141==ERROR: AddressSanitizer: heap-use-after-free on address 0x614000000044 at pc 0x0000004c6b02 bp 0x7ffce356ce70 sp 0x7ffce356ce68
READ of size 4 at 0x614000000044 thread T0
    #0 0x4c6b01 in main /home/grunwald/compiler-sanitizer-examples/heap-use-after-free.cc:5:10
    #1 0x7f12625ca0b2 in __libc_start_main (/lib/x86_64-linux-gnu/libc.so.6+0x270b2)
    #2 0x41c2dd in _start (/home/grunwald/compiler-sanitizer-examples/heap-use-after-free.exe+0x41c2dd)

0x614000000044 is located 4 bytes inside of 400-byte region [0x614000000040,0x6140000001d0)
freed by thread T0 here:
    #0 0x4c4aed in operator delete[](void*) (/home/grunwald/compiler-sanitizer-examples/heap-use-after-free.exe+0x4c4aed)
    #1 0x4c6ab1 in main /home/grunwald/compiler-sanitizer-examples/heap-use-after-free.cc:4:3
    #2 0x7f12625ca0b2 in __libc_start_main (/lib/x86_64-linux-gnu/libc.so.6+0x270b2)

previously allocated by thread T0 here:
    #0 0x4c429d in operator new[](unsigned long) (/home/grunwald/compiler-sanitizer-examples/heap-use-after-free.exe+0x4c429d)
    #1 0x4c6a8f in main /home/grunwald/compiler-sanitizer-examples/heap-use-after-free.cc:3:16
    #2 0x7f12625ca0b2 in __libc_start_main (/lib/x86_64-linux-gnu/libc.so.6+0x270b2)

SUMMARY: AddressSanitizer: heap-use-after-free /home/grunwald/compiler-sanitizer-examples/heap-use-after-free.cc:5:10 in main
Shadow bytes around the buggy address:
  0x0c287fff7fb0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0c287fff7fc0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0c287fff7fd0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0c287fff7fe0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0c287fff7ff0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
=>0x0c287fff8000: fa fa fa fa fa fa fa fa[fd]fd fd fd fd fd fd fd
  0x0c287fff8010: fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd
  0x0c287fff8020: fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd
  0x0c287fff8030: fd fd fd fd fd fd fd fd fd fd fa fa fa fa fa fa
  0x0c287fff8040: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x0c287fff8050: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
Shadow byte legend (one shadow byte represents 8 application bytes):
  Addressable:           00
  Partially addressable: 01 02 03 04 05 06 07 
  Heap left redzone:       fa
  Freed heap region:       fd
  Stack left redzone:      f1
  Stack mid redzone:       f2
  Stack right redzone:     f3
  Stack after return:      f5
  Stack use after scope:   f8
  Global redzone:          f9
  Global init order:       f6
  Poisoned by user:        f7
  Container overflow:      fc
  Array cookie:            ac
  Intra object redzone:    bb
  ASan internal:           fe
  Left alloca redzone:     ca
  Right alloca redzone:    cb
  Shadow gap:              cc
==1674141==ABORTING
make: [Makefile:32: heap-use-after-free-error] Error 1 (ignored)
clang++ -g -o heap-use-dangling.exe -fsanitize=address heap-use-dangling.cc
========================================
==  Dangling pointer (not deleted)
========================================
./heap-use-dangling.exe

=================================================================
==1674149==ERROR: LeakSanitizer: detected memory leaks

Direct leak of 400 byte(s) in 1 object(s) allocated from:
    #0 0x4c429d in operator new[](unsigned long) (/home/grunwald/compiler-sanitizer-examples/heap-use-dangling.exe+0x4c429d)
    #1 0x4c6a8f in main /home/grunwald/compiler-sanitizer-examples/heap-use-dangling.cc:3:16
    #2 0x7f639d21d0b2 in __libc_start_main (/lib/x86_64-linux-gnu/libc.so.6+0x270b2)

SUMMARY: AddressSanitizer: 400 byte(s) leaked in 1 allocation(s).
make: [Makefile:41: heap-use-dangling-error] Error 1 (ignored)
clang++ -g -o heap-shareptr-dangling.exe -fsanitize=address heap-shareptr-dangling.cc
========================================
==  Dangling pointer using std::share_ptr (not deleted)
========================================
./heap-shareptr-dangling.exe
Created not shared heap allocated
Created shared heap allocated
The shared pointer will be garbage collected
The un-shared version will cause a leak error
but for some reason does not
Deleted shared heap allocated
clang++ -g -o heap-buffer-overflow.exe -fsanitize=address heap-buffer-overflow.cc
========================================
== Heap buffer overflow error
========================================
./heap-buffer-overflow.exe
=================================================================
==1674166==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x6140000001d4 at pc 0x0000004c6b3b bp 0x7ffd924105d0 sp 0x7ffd924105c8
READ of size 4 at 0x6140000001d4 thread T0
    #0 0x4c6b3a in main /home/grunwald/compiler-sanitizer-examples/heap-buffer-overflow.cc:5:13
    #1 0x7fa0a5a9f0b2 in __libc_start_main (/lib/x86_64-linux-gnu/libc.so.6+0x270b2)
    #2 0x41c2dd in _start (/home/grunwald/compiler-sanitizer-examples/heap-buffer-overflow.exe+0x41c2dd)

0x6140000001d4 is located 4 bytes to the right of 400-byte region [0x614000000040,0x6140000001d0)
allocated by thread T0 here:
    #0 0x4c429d in operator new[](unsigned long) (/home/grunwald/compiler-sanitizer-examples/heap-buffer-overflow.exe+0x4c429d)
    #1 0x4c6a8f in main /home/grunwald/compiler-sanitizer-examples/heap-buffer-overflow.cc:3:16
    #2 0x7fa0a5a9f0b2 in __libc_start_main (/lib/x86_64-linux-gnu/libc.so.6+0x270b2)

SUMMARY: AddressSanitizer: heap-buffer-overflow /home/grunwald/compiler-sanitizer-examples/heap-buffer-overflow.cc:5:13 in main
Shadow bytes around the buggy address:
  0x0c287fff7fe0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0c287fff7ff0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0c287fff8000: fa fa fa fa fa fa fa fa 00 00 00 00 00 00 00 00
  0x0c287fff8010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0c287fff8020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
=>0x0c287fff8030: 00 00 00 00 00 00 00 00 00 00[fa]fa fa fa fa fa
  0x0c287fff8040: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x0c287fff8050: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x0c287fff8060: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x0c287fff8070: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x0c287fff8080: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
Shadow byte legend (one shadow byte represents 8 application bytes):
  Addressable:           00
  Partially addressable: 01 02 03 04 05 06 07 
  Heap left redzone:       fa
  Freed heap region:       fd
  Stack left redzone:      f1
  Stack mid redzone:       f2
  Stack right redzone:     f3
  Stack after return:      f5
  Stack use after scope:   f8
  Global redzone:          f9
  Global init order:       f6
  Poisoned by user:        f7
  Container overflow:      fc
  Array cookie:            ac
  Intra object redzone:    bb
  ASan internal:           fe
  Left alloca redzone:     ca
  Right alloca redzone:    cb
  Shadow gap:              cc
==1674166==ABORTING
make: [Makefile:60: heap-buffer-overflow-error] Error 1 (ignored)
clang++ -g -o stack-buffer-overflow.exe -fsanitize=address stack-buffer-overflow.cc
========================================
== Stack buffer overflow error
========================================
./stack-buffer-overflow.exe
=================================================================
==1674174==ERROR: AddressSanitizer: stack-buffer-overflow on address 0x7ffd55a25614 at pc 0x0000004c6ca8 bp 0x7ffd55a25450 sp 0x7ffd55a25448
READ of size 4 at 0x7ffd55a25614 thread T0
    #0 0x4c6ca7 in main /home/grunwald/compiler-sanitizer-examples/stack-buffer-overflow.cc:5:10
    #1 0x7f618b9c00b2 in __libc_start_main (/lib/x86_64-linux-gnu/libc.so.6+0x270b2)
    #2 0x41c2dd in _start (/home/grunwald/compiler-sanitizer-examples/stack-buffer-overflow.exe+0x41c2dd)

Address 0x7ffd55a25614 is located in stack of thread T0 at offset 436 in frame
    #0 0x4c6a7f in main /home/grunwald/compiler-sanitizer-examples/stack-buffer-overflow.cc:2

  This frame has 1 object(s):
    [32, 432) 'stack_array' (line 3) <== Memory access at offset 436 overflows this variable
HINT: this may be a false positive if your program uses some custom stack unwind mechanism, swapcontext or vfork
      (longjmp and C++ exceptions *are* supported)
SUMMARY: AddressSanitizer: stack-buffer-overflow /home/grunwald/compiler-sanitizer-examples/stack-buffer-overflow.cc:5:10 in main
Shadow bytes around the buggy address:
  0x10002ab3ca70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x10002ab3ca80: 00 00 00 00 00 00 00 00 00 00 00 00 f1 f1 f1 f1
  0x10002ab3ca90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x10002ab3caa0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x10002ab3cab0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
=>0x10002ab3cac0: 00 00[f3]f3 f3 f3 f3 f3 f3 f3 f3 f3 00 00 00 00
  0x10002ab3cad0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x10002ab3cae0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x10002ab3caf0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x10002ab3cb00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x10002ab3cb10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Shadow byte legend (one shadow byte represents 8 application bytes):
  Addressable:           00
  Partially addressable: 01 02 03 04 05 06 07 
  Heap left redzone:       fa
  Freed heap region:       fd
  Stack left redzone:      f1
  Stack mid redzone:       f2
  Stack right redzone:     f3
  Stack after return:      f5
  Stack use after scope:   f8
  Global redzone:          f9
  Global init order:       f6
  Poisoned by user:        f7
  Container overflow:      fc
  Array cookie:            ac
  Intra object redzone:    bb
  ASan internal:           fe
  Left alloca redzone:     ca
  Right alloca redzone:    cb
  Shadow gap:              cc
==1674174==ABORTING
make: [Makefile:69: stack-buffer-overflow-error] Error 1 (ignored)
clang++ -g -o global-buffer-overflow.exe -fsanitize=address global-buffer-overflow.cc
========================================
== Global buffer overflow error
========================================
./global-buffer-overflow.exe
=================================================================
==1674182==ERROR: AddressSanitizer: global-buffer-overflow on address 0x0000004fad34 at pc 0x0000004c6ae4 bp 0x7ffd05ce8910 sp 0x7ffd05ce8908
READ of size 4 at 0x0000004fad34 thread T0
    #0 0x4c6ae3 in main /home/grunwald/compiler-sanitizer-examples/global-buffer-overflow.cc:4:10
    #1 0x7f7dcf04d0b2 in __libc_start_main (/lib/x86_64-linux-gnu/libc.so.6+0x270b2)
    #2 0x41c2dd in _start (/home/grunwald/compiler-sanitizer-examples/global-buffer-overflow.exe+0x41c2dd)

0x0000004fad34 is located 4 bytes to the right of global variable 'global_array' defined in 'global-buffer-overflow.cc:2:5' (0x4faba0) of size 400
SUMMARY: AddressSanitizer: global-buffer-overflow /home/grunwald/compiler-sanitizer-examples/global-buffer-overflow.cc:4:10 in main
Shadow bytes around the buggy address:
  0x000080097550: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x000080097560: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x000080097570: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x000080097580: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x000080097590: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
=>0x0000800975a0: 00 00 00 00 00 00[f9]f9 f9 f9 f9 f9 f9 f9 f9 f9
  0x0000800975b0: f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 00 00 00 00
  0x0000800975c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0000800975d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0000800975e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0000800975f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Shadow byte legend (one shadow byte represents 8 application bytes):
  Addressable:           00
  Partially addressable: 01 02 03 04 05 06 07 
  Heap left redzone:       fa
  Freed heap region:       fd
  Stack left redzone:      f1
  Stack mid redzone:       f2
  Stack right redzone:     f3
  Stack after return:      f5
  Stack use after scope:   f8
  Global redzone:          f9
  Global init order:       f6
  Poisoned by user:        f7
  Container overflow:      fc
  Array cookie:            ac
  Intra object redzone:    bb
  ASan internal:           fe
  Left alloca redzone:     ca
  Right alloca redzone:    cb
  Shadow gap:              cc
==1674182==ABORTING
make: [Makefile:78: global-buffer-overflow-error] Error 1 (ignored)
clang++ -g -o uninit-memory-read.exe -fsanitize=memory uninit-memory-read.cc
========================================
== Uninitlized memory read
========================================
This will not cause an error
./uninit-memory-read.exe 5
Any value other than 5 will cause an error
./uninit-memory-read.exe 2
==1674193==WARNING: MemorySanitizer: use-of-uninitialized-value
    #0 0x497636 in main /home/grunwald/compiler-sanitizer-examples/uninit-memory-read.cc:8:7
    #1 0x7f826199f0b2 in __libc_start_main (/lib/x86_64-linux-gnu/libc.so.6+0x270b2)
    #2 0x41c26d in _start (/home/grunwald/compiler-sanitizer-examples/uninit-memory-read.exe+0x41c26d)

SUMMARY: MemorySanitizer: use-of-uninitialized-value /home/grunwald/compiler-sanitizer-examples/uninit-memory-read.cc:8:7 in main
Exiting
make: [Makefile:90: uninit-memory-read-error] Error 77 (ignored)
./uninit-memory-read.exe 7
==1674195==WARNING: MemorySanitizer: use-of-uninitialized-value
    #0 0x497636 in main /home/grunwald/compiler-sanitizer-examples/uninit-memory-read.cc:8:7
    #1 0x7f813c9c60b2 in __libc_start_main (/lib/x86_64-linux-gnu/libc.so.6+0x270b2)
    #2 0x41c26d in _start (/home/grunwald/compiler-sanitizer-examples/uninit-memory-read.exe+0x41c26d)

SUMMARY: MemorySanitizer: use-of-uninitialized-value /home/grunwald/compiler-sanitizer-examples/uninit-memory-read.cc:8:7 in main
Exiting
make: [Makefile:91: uninit-memory-read-error] Error 77 (ignored)
```