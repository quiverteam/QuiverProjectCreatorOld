$(__builddir)/lib/foo.a: $(__builddir)/lib/foo.o
	ar rcs $@ $^

$(__builddir)/lib/foo.o: $(__rootdir)/lib/lib.cpp
	$(cxxc) -c -o $@ $^
