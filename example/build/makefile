# root build directory
__rootdir = $(realpath ..)
__builddir = $(realpath .)
cxxc = g++

all: hello

include lib/lib.mk

hello_sources = $(__rootdir)/main.cpp

hello: $(hello_sources) $(__builddir)/lib/foo.a
	$(cxxc) -o $@ $^
