
#
# Makefile for building the utilities...
#
#  PWM 15Feb94 - SCD Consulting....
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
ETC_DIR = @ETC_DIR@

SHELL = /bin/sh
RM = rm
INCLUDES  = ../lib
DEPLIB    = ../lib/libncaru.a
#CFLAGS    = -O2 -c -w -DSTRICT -I$(INCLUDES)
CFLAGS    = -O2 -c -w -I$(INCLUDES)
LDFLAGS   = -L../lib
LIBS      = -lncaru
INSTMODE  = 775 
INSTDIR   = ${ETC_DIR}

SRCS      = cosfile.c cosconvert.c cossplit.c
UTILS	  = cosfile cosconvert cossplit

all: $(UTILS)

cosfile : cosfile.o  $(DEPLIB)
	cc -o cosfile cosfile.o $(LDFLAGS) $(LIBS)

cosconvert : cosconvert.o  $(DEPLIB)
	cc -o cosconvert cosconvert.o $(LDFLAGS) $(LIBS)

cossplit : cossplit.o  $(DEPLIB)
	cc -o cossplit cossplit.o $(LDFLAGS) $(LIBS)

clean:
	- cd ${INSTDIR} ; ${RM} $(UTILS)
	rm -f  $(UTILS) core *.o conv_* *.bak

install: cosfile cossplit cosconvert
	- mkdir -p $(INSTDIR)
	@for i in $(UTILS) ; \
	do \
	    echo "Installing $$i in $(INSTDIR)..."; \
	    cp $$i $(INSTDIR)/$$i ;  \
	    chmod $(INSTMODE) $(INSTDIR)/$$i ; \
	done

depend:
	makedepend -I$(INCLUDES) -DSTRICT $(SRCS)

# DO NOT DELETE THIS LINE -- make depend depends on it.

#cosfile.o: /usr/include/stdio.h /usr/include/standards.h /usr/include/fcntl.h
#cosfile.o: /usr/include/sys/types.h /usr/include/ctype.h
#cosfile.o: /usr/include/sys/localedef.h /usr/include/sys/limits.h
#cosfile.o: /usr/include/sys/lc_core.h /usr/include/locale.h
#cosfile.o: /usr/include/sys/localedef31.h ../lib/cray.h
#cosconvert.o: /usr/include/stdio.h /usr/include/standards.h
#cosconvert.o: /usr/include/fcntl.h /usr/include/sys/types.h
#cosconvert.o: /usr/include/ctype.h /usr/include/sys/localedef.h
#cosconvert.o: /usr/include/sys/limits.h /usr/include/sys/lc_core.h
#cosconvert.o: /usr/include/locale.h /usr/include/sys/localedef31.h
#cosconvert.o: /usr/include/signal.h /usr/include/sys/signal.h
#cosconvert.o: /usr/include/string.h ../lib/cray.h
#cossplit.o: /usr/include/stdio.h /usr/include/standards.h
#cossplit.o: /usr/include/fcntl.h /usr/include/sys/types.h
#cossplit.o: /usr/include/ctype.h /usr/include/sys/localedef.h
#cossplit.o: /usr/include/sys/limits.h /usr/include/sys/lc_core.h
#cossplit.o: /usr/include/locale.h /usr/include/sys/localedef31.h
#cossplit.o: /usr/include/signal.h /usr/include/sys/signal.h
#cossplit.o: /usr/include/string.h ../lib/cray.h
