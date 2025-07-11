
/* Copyright 1994 University Corporation for Atmospheric Research (UCAR).
** 
** Permission to use, copy, and modify this software and its documentation 
** for any non-commercial purpose is hereby granted without fee, provided 
** that the above copyright notice appear in all copies and that both that 
** copyright notice and this permission notice appear in supporting 
** documentation. UCAR makes no representations about the suitability of 
** this software for any purpose.   It is provided "as is" without express
** or implied warranty.
*/

#ifndef CRAY_WORD_SIZE

/*
 * Definitions for CRAY Dataset routines
 *
 * When STRICT is defined, everything is set up explicitly.
 * Otherwise we take advantage of the setting of the control word to zeros
 * before use and fields that are not used.
 */

#define CRAY_OPENERR	-1
#define CRAY_BADCRAY	-2
#define CRAY_SHORTRD	-3
#define CRAY_EOF	-4
#define CRAY_EOD	-5
#define CRAY_DISKERR	-6
#define CRAY_UNBLKERR	-7
#define CRAY_WRONLY	-8

#define CRAY_WORD_SIZE	8
#define CRAY_BLCK_SIZE	4096

/*
** define all the operations possible.
*/
#define C_INIT	-1
#define C_READ	-2
#define	C_WRITE	-3
#define	C_BCKSP	-4
#define	C_REWND	-5

typedef struct {
	int		unblkFlag;	/* unblocked flag */
	int		last_op;    /* what the last operation was...a */
	int		blockn;
	int		bufblockn;  /* blk no. of first blk in buf */
	int		crayfd;
	int		reod;
	int		weod;
	int		weof;
	int		fwi;
	int		pfi;
	int		pri;
	int		rw;
	int		oflags; /*  "       flags "     "     "   */
	union pcw	*cw;
	union pcw	*endcw;
	union pcw	*endblk;
	int		numBlocks;	/* n blocks in "block" */
	char		*block;
	char		*cbuf;		/*  conversion buffer */
	int		cbufSize; 	/* size of cbuf */
} CrayFile;

CrayFile	*_CrayOpen(/* char *name, int flag, int mode */);
CrayFile	*CrayFdopen(/* int fd, int flag */);
int		_CrayRead(/* CrayFile *cf, char *buf, int size */);
int		_CrayWrite(/* CrayFile *cf, char *buf, int size */);
int		_CrayWEOF(/* CrayFile *cf */);
int		_CrayWEOD(/* CrayFile *cf */);
int		_CrayClose(/* CrayFile *cf */);
int		_CrayBackSpace(/* CrayFile *cf */);
void		_CrayCfDump(/* CrayFile *cf */);

#ifdef CRAY_PRIVATE

#ifdef vax

struct pbcw {
	unsigned int		:4;	
	unsigned int	m	:4;	/* 0 - 3 */
	unsigned int		:4;
	unsigned int	bdf	:1;	/* 11 */
	unsigned int		:3;
	unsigned int		:8;
	unsigned int	bnH	:1;	/* 31 */
	unsigned int		:7;

	unsigned int	bnLH	:8;	/* 32 - 39 */
	unsigned int	bnLM	:8;	/* 40 - 47 */
	unsigned int	fwiH	:1;	/* 55 */
	unsigned int	bnLL	:7;	/* 48 - 54 */
	unsigned int	fwiL	:8;	/* 56 - 63 */
};

#else !vax
#ifdef UNICOS

struct pbcw {
	unsigned int	m	:4;	/* 0 - 3 */
	unsigned int		:7;	/* 4 - 10 */
	unsigned int	bdf	:1;	/* 11 */
	unsigned int		:19;	/* 12 - 30 */
	unsigned int	bn	:24;	/* 31 - 54 */
	unsigned int	fwi	:9;	/* 55 - 63 */
};

#else !UNICOS

struct pbcw {
	unsigned int	m	:4;	/* 0 - 3 */
	unsigned int		:7;	/* 4 - 10 */
	unsigned int	bdf	:1;	/* 11 */
	unsigned int		:19;	/* 12 - 30 */
	unsigned int	bnH	:1;	/* 31 */
	unsigned int	bnL	:23;	/* 32 - 54 */
	unsigned int	fwi	:9;	/* 55 - 63 */
};

#endif !UNICOS
#endif !vax

struct bcw {
	unsigned int	bn;		/* 24 bits */
	unsigned short	fwi;		/* 9 bits */
	unsigned char	m;		/* 4 bits */
	unsigned char	bdf;		/* 1 bit */
};

#ifdef STRICT

#ifdef vax

#define PACK_BCW(u, p)			\
	(p)->m = (u)->m;		\
	(p)->bdf = (u)->bdf;		\
	(p)->fwiH = (u)->fwi >> 8;	\
	(p)->fwiL = (u)->fwi;		\
	(p)->bnH = (u)->bn >> 23;	\
	(p)->bnLH = (u)->bn >> 15;	\
	(p)->bnLM = (u)->bn >> 7;	\
	(p)->bnLL = (u)->bn

#define UNPACK_BCW(p, u)		\
	(u)->m = (p)->m;		\
	(u)->bdf = (p)->bdf;		\
	(u)->fwi = (p)->fwiH << 8;	\
	(u)->fwi |= (p)->fwiL;		\
	(u)->bn = (p)->bnH << 23;	\
	(u)->bn |= (p)->bnLH << 15;	\
	(u)->bn |= (p)->bnLM << 7;	\
	(u)->bn |= (p)->bnLL

#else !vax
#ifdef UNICOS

#define PACK_BCW(u, p)			\
	(p)->m = (u)->m;		\
	(p)->bdf = (u)->bdf;		\
	(p)->fwi = (u)->fwi;		\
	(p)->bn = (u)->bn;

#define UNPACK_BCW(p, u)		\
	(u)->m = (p)->m;		\
	(u)->bdf = (p)->bdf;		\
	(u)->fwi = (p)->fwi;		\
	(u)->bn = (p)->bn;


#else !UNICOS

#define PACK_BCW(u, p)			\
	(p)->m = (u)->m;		\
	(p)->bdf = (u)->bdf;		\
	(p)->fwi = (u)->fwi;		\
	(p)->bnH = (u)->bn >> 23;	\
	(p)->bnL = (u)->bn & 0x7fffff

#define UNPACK_BCW(p, u)		\
	(u)->m = (p)->m;		\
	(u)->bdf = (p)->bdf;		\
	(u)->fwi = (p)->fwi;		\
	(u)->bn = (p)->bnH << 23;	\
	(u)->bn |= (p)->bnL

#endif !UNICOS
#endif !vax

#else !STRICT

#ifdef vax

#define PACK_BCW(u, p)			\
	(p)->bnH = (u)->bn >> 23;	\
	(p)->bnLH = (u)->bn >> 15;	\
	(p)->bnLM = (u)->bn >> 7;	\
	(p)->bnLL = (u)->bn

#define UNPACK_BCW(p, u)		\
	(u)->fwi = (p)->fwiH << 8;	\
	(u)->fwi |= (p)->fwiL;		\
	(u)->bn = (p)->bnH << 23;	\
	(u)->bn |= (p)->bnLH << 15;	\
	(u)->bn |= (p)->bnLM << 7;	\
	(u)->bn |= (p)->bnLL

#else !vax

#ifdef UNICOS

#define PACK_BCW(u, p)			\
	(p)->bn = (u)->bn;

#define UNPACK_BCW(p, u)		\
	(u)->fwi = (p)->fwi;		\
	(u)->bn = (p)->bn;

#else !UNICOS

#define PACK_BCW(u, p)			\
	(p)->bnH = (u)->bn >> 23;	\
	(p)->bnL = (u)->bn & 0x7fffff

#define UNPACK_BCW(p, u)		\
	(u)->fwi = (p)->fwi;		\
	(u)->bn = (p)->bnH << 23;	\
	(u)->bn |= (p)->bnL

#endif !UNICOS
#endif !vax

#endif STRICT

#ifdef vax

struct prcw {
	unsigned int	ubcH	:4;	/* 4 - 7 */
	unsigned int	m	:4;	/* 0 - 3 */
	unsigned int		:3;
	unsigned int	srs	:1;	/* 12 */
	unsigned int	bdf	:1;	/* 11 */
	unsigned int	tran	:1;	/* 10 */
	unsigned int	ubcL	:2;	/* 8 - 9 */
	unsigned int	pfiH	:4;	/* 20 - 23 */
	unsigned int		:4;
	unsigned int	pfiM	:8;	/* 24 - 31 */
	unsigned int	pfiL	:8;	/* 32 - 39 */
	unsigned int	priH	:8;	/* 40 - 47 */
	unsigned int	fwiH	:1;	/* 55 */
	unsigned int	priL	:7;	/* 48 - 54 */
	unsigned int	fwiL	:8;	/* 56 - 63 */
};

#else !vax

#ifdef UNICOS

struct prcw {
	unsigned int	m	:4;	/* 0 - 3 */
	unsigned int	ubc	:6;	/* 4 - 9 */
	unsigned int	tran	:1;	/* 10 */
	unsigned int	bdf	:1;	/* 11 */
	unsigned int	srs	:1;	/* 12 */
	unsigned int		:7;	/* 13 - 19 */
	unsigned int	pfi	:20;	/* 20 - 39 */
	unsigned int	pri	:15;	/* 40 - 54 */
	unsigned int	fwi	:9;	/* 55 - 63 */
};

#else !UNICOS

struct prcw {
	unsigned int	m	:4;	/* 0 - 3 */
	unsigned int	ubc	:6;	/* 4 - 9 */
	unsigned int	tran	:1;	/* 10 */
	unsigned int	bdf	:1;	/* 11 */
	unsigned int	srs	:1;	/* 12 */
	unsigned int		:7;	/* 13 - 19 */
	unsigned int	pfiH	:12;	/* 20 - 31 */
	unsigned int	pfiL	:8;	/* 32 - 39 */
	unsigned int	pri	:15;	/* 40 - 54 */
	unsigned int	fwi	:9;	/* 55 - 63 */
};

#endif !UNICOS
#endif !vax

struct rcw {
	unsigned int	pfi;		/* 20 bits */
	unsigned short	pri;		/* 15 bits */
	unsigned short	fwi;		/* 9 bits */
	unsigned char	m;		/* 4 bits */
	unsigned char	ubc;		/* 6 bits */
	unsigned char	tran;		/* 1 bit */
	unsigned char	bdf;		/* 1 bit */
	unsigned char	srs;		/* 1 bit */
};

#ifdef STRICT

#ifdef vax

#define PACK_RCW(u, p)			\
	(p)->m = (u)->m;		\
	(p)->ubcH = (u)->ubc >> 2;	\
	(p)->ubcL = (u)->ubc;		\
	(p)->tran = (u)->tran;		\
	(p)->bdf = (u)->bdf;		\
	(p)->srs = (u)->srs;		\
	(p)->priH = (u)->pri >> 7;	\
	(p)->priL = (u)->pri;		\
	(p)->fwiH = (u)->fwi >> 8;	\
	(p)->fwiL = (u)->fwi;		\
	(p)->pfiH = (u)->pfi >> 16;	\
	(p)->pfiM = (u)->pfi >> 8;	\
	(p)->pfiL = (u)->pfi

#define UNPACK_RCW(p, u)		\
	(u)->m = (p)->m;		\
	(u)->ubc = (p)->ubcH << 2;	\
	(u)->ubc |= (p)->ubcL;		\
	(u)->tran = (p)->tran;		\
	(u)->bdf = (p)->bdf;		\
	(u)->srs = (p)->srs;		\
	(u)->pri = (p)->priH << 7;	\
	(u)->pri = (p)->priL;		\
	(u)->fwi = (p)->fwiH << 8;	\
	(u)->fwi |= (p)->fwiL;		\
	(u)->pfi = (p)->pfiH << 16;	\
	(u)->pfi |= (p)->pfiM << 8;	\
	(u)->pfi |= (p)->pfiL

#else !vax
#ifdef UNICOS

#define PACK_RCW(u, p)			\
	(p)->m = (u)->m;		\
	(p)->ubc = (u)->ubc;		\
	(p)->tran = (u)->tran;		\
	(p)->bdf = (u)->bdf;		\
	(p)->srs = (u)->srs;		\
	(p)->pri = (u)->pri;		\
	(p)->fwi = (u)->fwi;		\
	(p)->pfi = (u)->pfi;

#define UNPACK_RCW(p, u)		\
	(u)->m = (p)->m;		\
	(u)->ubc = (p)->ubc;		\
	(u)->tran = (p)->tran;		\
	(u)->bdf = (p)->bdf;		\
	(u)->srs = (p)->srs;		\
	(u)->pri = (p)->pri;		\
	(u)->fwi = (p)->fwi;		\
	(u)->pfi = (p)->pfi;

#else !UNICOS

#define PACK_RCW(u, p)			\
	(p)->m = (u)->m;		\
	(p)->ubc = (u)->ubc;		\
	(p)->tran = (u)->tran;		\
	(p)->bdf = (u)->bdf;		\
	(p)->srs = (u)->srs;		\
	(p)->pri = (u)->pri;		\
	(p)->fwi = (u)->fwi;		\
	(p)->pfiH = (u)->pfi >> 8;	\
	(p)->pfiL = (u)->pfi & 0xff

#define UNPACK_RCW(p, u)		\
	(u)->m = (p)->m;		\
	(u)->ubc = (p)->ubc;		\
	(u)->tran = (p)->tran;		\
	(u)->bdf = (p)->bdf;		\
	(u)->srs = (p)->srs;		\
	(u)->pri = (p)->pri;		\
	(u)->fwi = (p)->fwi;		\
	(u)->pfi = (p)->pfiH << 8;	\
	(u)->pfi |= (p)->pfiL

#endif !UNICOS
#endif !vax

#else !STRICT

#ifdef vax

#define PACK_RCW(u, p)			\
	(p)->m = (u)->m;		\
	(p)->ubcH = (u)->ubc >> 2;	\
	(p)->ubcL = (u)->ubc;		\
	(p)->priH = (u)->pri >> 7;	\
	(p)->priL = (u)->pri;		\
	(p)->pfiH = (u)->pfi >> 16;	\
	(p)->pfiM = (u)->pfi >> 8;	\
	(p)->pfiL = (u)->pfi

#define UNPACK_RCW(p, u)		\
	(u)->m = (p)->m;		\
	(u)->ubc = (p)->ubcH << 2;	\
	(u)->ubc |= (p)->ubcL;		\
	(u)->pri = (p)->priH << 7;	\
	(u)->pri |= (p)->priL;		\
	(u)->fwi = (p)->fwiH << 8;	\
	(u)->fwi |= (p)->fwiL;

#else !vax
#ifdef UNICOS

#define PACK_RCW(u, p)			\
	(p)->m = (u)->m;		\
	(p)->ubc = (u)->ubc;		\
	(p)->pri = (u)->pri;		\
	(p)->pfi = (u)->pfi;

#define UNPACK_RCW(p, u)		\
	(u)->m = (p)->m;		\
	(u)->ubc = (p)->ubc;		\
	(u)->pri = (p)->pri;		\
	(u)->fwi = (p)->fwi;

#else !UNICOS

#define PACK_RCW(u, p)			\
	(p)->m = (u)->m;		\
	(p)->ubc = (u)->ubc;		\
	(p)->pri = (u)->pri;		\
	(p)->pfiH = (u)->pfi >> 8;	\
	(p)->pfiL = (u)->pfi & 0xff

#define UNPACK_RCW(p, u)		\
	(u)->m = (p)->m;		\
	(u)->ubc = (p)->ubc;		\
	(u)->pri = (p)->pri;		\
	(u)->fwi = (p)->fwi;

#endif !UNICOS
#endif !vax

#endif !STRICT

union pcw {
	struct pbcw	block;
	struct prcw	record;
#ifdef vax
	struct {
		unsigned int		:4;	/* 4 - 10 */
		unsigned int	m	:4;	/* 0 - 3 */
		unsigned int		:4;
		unsigned int	bdf	:1;	/* 11 */
		unsigned int		:3;
		unsigned int		:8;
		unsigned int	bnH	:1;	/* 31 */
		unsigned int		:7;

		unsigned int	bnLH	:8;	/* 32 - 39 */
		unsigned int	bnLM	:8;	/* 40 - 47 */
		unsigned int	fwiH	:1;	/* 55 */
		unsigned int	bnLL	:7;	/* 48 - 54 */
		unsigned int	fwiL	:8;	/* 56 - 63 */
	} u;
#else !vax
	struct {
		unsigned int	m	:4;
		unsigned int		:28;
		unsigned int		:23;
		unsigned int	fwi	:9;
	} u;
#endif
};

#ifdef vax

#define SET_PCW_FWI(c, f) \
	(c)->u.fwiH = f >> 8; \
	(c)->u.fwiL = f

#else !vax

#define SET_PCW_FWI(c, f) \
	(c)->u.fwi = f

#endif

/*
 * Control word types (m field)
 */

#define M_BCW	0
#define M_EOR	010
#define M_EOF	016
#define M_EOD	017

#endif CRAY_PRIVATE

#endif

