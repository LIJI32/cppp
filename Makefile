#  Makefile for cppp

# Where to install
#
prefix = /usr/local

.PHONY: all check install clean dist

all: cppp

PLATFORM := $(shell uname -s)

ifneq ($(findstring MSYS,$(PLATFORM)),)
PLATFORM := windows32
endif


ifeq ($(PLATFORM),windows32)
UNIXISMS := unixisms-win32
else
UNIXISMS := unixisms
endif

CC := clang
CFLAGS = -Wall -Wextra -O2

OBJLIST = gen.o $(UNIXISMS).o error.o symset.o mstr.o \
          clexer.o exptree.o ppproc.o cppp.o

cppp: $(OBJLIST)

gen.o     : gen.c gen.h
unixisms.o: unixisms.c unixisms.h
error.o   : error.c error.h gen.h
symset.o  : symset.c symset.h gen.h types.h
mstr.o    : mstr.c mstr.h gen.h types.h
clexer.o  : clexer.c clexer.h gen.h types.h error.h
exptree.o : exptree.c exptree.h gen.h types.h error.h symset.h clexer.h
ppproc.o  : ppproc.c ppproc.h gen.h types.h error.h symset.h mstr.h \
            clexer.h exptree.h
cppp.o    : cppp.c gen.h types.h unixisms.h error.h symset.h ppproc.h

unixisms-win32.o: unixisms-win32.c unixisms.h

install:
	cp ./cppp $(prefix)/bin/.
	cp ./cppp.1 $(prefix)/share/man/man1/.

test: cppp
	./tests/testall
	: All tests passed.

clean:
	rm -f $(OBJLIST) cppp
