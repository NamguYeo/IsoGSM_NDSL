#
#  Makefile to build libncaru.a for the Cluster and other nodes.
#
# 

# Copyright 1994 University Corporation for Atmospheric Research (UCAR).
# 
# Permission to use, copy, and modify this software and its documentation 
# for any non-commercial purpose is hereby granted without fee, provided 
# that the above copyright notice appear in all copies and that both that 
# copyright notice and this permission notice appear in supporting 
# documentation. UCAR makes no representations about the suitability of 
# this software for any purpose.   It is provided "as is" without express
# or implied warranty.

SHELL = /bin/sh
LIB_DIR = /rhome/yeong/test/svrtest/libs/lib
AR = ar
CC = cc

#
# Set the proper optimization flag.
#
OPTFLAG  = -O -w

#CFLAGS   = $(OPTFLAG)   -DSTRICT
#
#  You might have to try different -D options
#
CFLAGS   = $(OPTFLAG) -Dsun
FFLAGS   = $(OPTFLAG)  -qautodbl=dblpad 
ARFLAGS  = r

LIBNM  = libncaru.a

LIBD   = .

SRCS =    cray.c ctodpf.c ctosp.c dptocf.c sptoc.c

.SUFFIXES : .c

.c :
	${CC} -o $@ ${INCLUDE_DIR} $< -lm

$(LIBNM) : cray.o ctodpf.o ctosp.o dptocf.o sptoc.o
	${AR} -r $@ $?

install: $(LIBNM)
	@echo "Installing $(LIBNM) in $(LIB_DIR)..."
	if [ ! -s ${LIB_DIR} ] ; then \
		${MKDIR} -p ${LIB_DIR} ; \
	fi
	@cp $(LIBNM) $(LIB_DIR)/$(LIBNM)
	@chmod 644 $(LIB_DIR)/$(LIBNM)

clean:
	rm -f $(LIBNM) *.o *.bak

lint:
	lint  -DSTRICT $(SRCS)

depend:
	makedepend -DSTRICT $(SRCS)

# DO NOT DELETE THIS LINE -- make depend depends on it.

#cray.o: /usr/include/stdio.h /usr/include/sys/feature_tests.h
#cray.o: /usr/include/fcntl.h /usr/include/sys/types.h
#cray.o: /usr/include/sys/isa_defs.h /usr/include/sys/machtypes.h
#cray.o: /usr/include/sys/select.h /usr/include/sys/time.h /usr/include/time.h
#cray.o: /usr/include/sys/fcntl.h cray.h /usr/include/unistd.h
#cray.o: /usr/include/sys/unistd.h /usr/include/memory.h /usr/include/malloc.h
