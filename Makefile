CC ?= gcc
DEFS ?= -DHAVE_POLL
EXTRA_CFLAGS ?= -Wall -Werror
CFLAGS += $(DEFS) $(EXTRA_CFLAGS)


LIBS +=
VFLAGS=$(shell ./genversion.sh)

objs_lib = mdns.o poll.o rr.o inet.o compat.o

ver=$(shell cat ./VERSION)
maj=$(shell cat ./VERSION | cut -f1 -d.)

.PHONY: all tests clean install

all: libmicrodns.so.$(ver)

%.o: %.c
	$(CC) $(CFLAGS) $(VFLAGS) -fPIC -c -o $@ $<


libmicrodns.so.$(ver): $(objs_lib)
	$(CC) $(CFLAGS) $(VFLAGS) \
		-shared -Wl,-soname,libmicrodns.so.$(maj) -o $@ $^ $(LIBS)
	-ln -sf $@ libmicrodns.so.$(maj)
	-ln -sf $@ libmicrodns.so

tests:
	$(MAKE) -C tests all

INCDIR=/usr/include/microdns

-include Makefile.inc

install: install-headers install-libs


clean:
	rm -f *.o *so*
