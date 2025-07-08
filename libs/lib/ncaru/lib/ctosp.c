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

/*  ctospf() and ctospi():  routines to convert Cray Fortran single
**      precision reals and integers (64 bits each) to IEEE (32 bit) format;
**	it is assumed that char == 8 bits on all machines.
**
**  Written April 1987 by Chuck D'Ambra.
**  Last modified 15 August 1988 by CD.
**  Last modified Feb 26,1992 by Dan Anderson
**  Code cleanup Peter Morreale January 94
*/

#define CBIAS		040000	/*  Cray f.p. exponent bias  */
#define MBIAS		126	/*  IEEE f.p. exponent bias  */
#define CSIGNMASK	0200	/*  Mask to get 1st of 8 bits  */
#define LCDIF		sizeof(long) - sizeof(char)

void checkrng();

/*
** Because the SUN Fortran compiler adds an underscore to Fortran entry
** points, we need to define the following wrappers to the user
** entry points.
**
** There probably is a cleaner way to manage this, however we are now
** stuck with this documented (and widely used) interface.
**
** By doing this, the interfaces are the same for SUNs and RS6000s
*/

extern void ctospf();
extern void ctospi();

#ifdef sun
void ctospf_(in, out, n)
unsigned char   in[], out[];
int             *n;
{
        ctospf(in, out, n);
        return;
}

void ctospi_(in, out, n, zpad)
unsigned char   in[], out[];
int             *n;
int             *zpad;
{
        ctospi(in, out, n, zpad);
        return;
}
#endif


/*------------------------------------------------------------------------*/
void ctospf(in, out, n)
unsigned char in[], out[];
int *n;
{
  	register int 		i, j, joff;
  	unsigned char 		*p, sign, *expp, *manp[3];
  	long 			exp;
  	static unsigned char 	maxman = 0xff, minman = 0;

	/*  
	** Cray 64 bit float representation:
 	**	bits 0-47:	mantissa
 	**	bits 48-62:	exponent
 	**	bit 63:		sign
 	*/

  	for (i = 0; i < *n; i++) {
    	    p = in+i*8;
    	    joff = i * 4;

    	    sign = *(p) & CSIGNMASK;	/*  sign bit  */

    	    /*
	    ** Point at mantissa
	    */
	    manp[0] = p+2;
	    manp[1] = p+3;
	    manp[2] = p+4;
	
	    /* 
	    ** Get the exponet
	    */
	    exp = (*(p+1)) | ((*p & 0x7f) << 8);
	    if (exp != 0) exp = exp - CBIAS + MBIAS;
	
	    /*  
	    ** If input is outside range representable on IEEE, set to
	    ** closest representable number.  
	    */
	    if (exp > 254) { /*  Too large  */
	        exp = 254;
	        /*  Set all bits in mantissa  */
	        for (j = 0; j < 3; j++) manp[j] = &maxman;
	    }
	    else if (exp < 0) {	/*  Too small  */
	        exp = 1;
	        /*  Turn off all bits in mantissa  */
	        for (j = 0; j < 3; j++)	manp[j] = &minman;
	    }
	
	    /*  
	    ** Pack it into 32 bit IEEE float representation:
	    **	bits 0-22:	mantissa
	    **	bits 23-30:	exponent
	    **	bit 31:		sign
	    */
	    expp = ((unsigned char *)(&exp)) + LCDIF;
	    out[joff] = sign | (*expp >> 1);
	    out[joff+1] = (*manp[0] & (~CSIGNMASK)) | ((*expp & 1) << 7);
	    out[joff+2] = *manp[1];
	    out[joff+3] = *manp[2];
	}
}


/*----------------------------------------------------------------------*/
void ctospi(in, out, n, zpad)
unsigned char in[], out[];
int *n; int *zpad;
{
	register int i, joff;
	register unsigned char *pin, sign;
	unsigned char *p[4];
	
	for (i = 0; i < *n; i++) {
	    pin = in+i*8;
	    joff = i * (*zpad+1)*4;
	
	    sign = *(pin) & CSIGNMASK;	/*  sign bit  */
	
	    p[0] = pin+4;	
	    p[1] = pin+5;	
	    p[2] = pin+6;	
	    p[3] = pin+7;	
	
	    checkrng(sign,pin,p);	/*  check if int w/i IEEE limits  */
	
	    /*  
	    ** Pack it into 4 byte IEEE integer representation  
	    */
	
	    out[joff] = sign | (*p[0] & (~CSIGNMASK));
	    out[joff+1] = *p[1];
	    out[joff+2] = *p[2];
	    out[joff+3] = *p[3];

	    /* 
	    ** 4 bytes of zeros if requested 
	    */
	    if (*zpad) {
	        out[joff+4]=out[joff+5]=out[joff+6]=out[joff+7]=0;
	    }
	}
}

/*----------------------------------------------------------------------*/
void checkrng(sign,cp,p)
unsigned char sign, *cp, *p[4];
{
	static unsigned char maxint = 0xff, minint = 0;
	
	/*
	** int >= 0; 1st 33 bits must be 0. 
	*/
	if (sign == 0)	{
	    if ((*(cp+4) & CSIGNMASK) != 0 || *cp != 0 || *(cp+1) != 0
	                                     || *(cp+2) != 0 || *(cp+3) != 0)
	        p[0] = p[1] = p[2] = p[3] = &maxint;
	}
	else {		
	    /*  
	    ** int < 0; 1st 33 bits must be 1. 
	    */
	    if ((*(cp+4) & CSIGNMASK) < 0200 || *cp != 0377 || *(cp+1) != 0377
	                               || *(cp+2) != 0377  ||  *(cp+3) != 0377)
	      p[0] = p[1] = p[2] = p[3] = &minint;
	}
}
	
