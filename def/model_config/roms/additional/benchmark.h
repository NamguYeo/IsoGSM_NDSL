/*
** svn $Id: benchmark.h,v 1.2 2009/10/02 00:34:46 kana Exp $
*******************************************************************************
** Copyright (c) 2002-2008 The ROMS/TOMS Group                               **
**   Licensed under a MIT/X style license                                    **
**   See License_ROMS.txt                                                    **
*******************************************************************************
**
** Options for Benchmark Tests.  There are several grids configurations to run,
** choose the appropriate standard input script: small ("ocean_bench1.in"),
** medium ("ocean_bench2.in"), and large (ocean_bench3.in).
**
** Application flag:   BENCHMARK
** Input script:       benchmark1.in, benchmark2.in, benchmark3.in
*/

#define UV_ADV
#define UV_COR
#define UV_QDRAG
#define UV_VIS2
#define MIX_S_UV
#define DJ_GRADPS
#define TS_U3HADVECTION
#define TS_C4VADVECTION
#define TS_DIF2
#define MIX_GEO_TS
#define SOLAR_SOURCE
#define NONLIN_EOS
#define SALINITY
#define CURVGRID
#define SOLVE3D
#define SPLINES
#define EW_PERIODIC
#define SOUTHERN_WALL
#define NORTHERN_WALL
#define LMD_MIXING
#ifdef LMD_MIXING
# define LMD_RIMIX
# define LMD_CONVEC
# define LMD_SKPP
# define LMD_NONLOCAL
#endif
#define BULK_FLUXES
#ifdef BULK_FLUXES
# define ANA_WINDS
# define ANA_TAIR
# define ANA_PAIR
# define ANA_HUMIDITY
# define ANA_RAIN
# define LONGWAVE
# define ANA_CLOUD
#endif
#define SPHERICAL
#define ANA_GRID
#define ANA_INITIAL
#define ALBEDO
#define ANA_SRFLUX
#define ANA_SSFLUX
#define ANA_BSFLUX
#define ANA_BTFLUX
