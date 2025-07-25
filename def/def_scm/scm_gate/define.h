
#include <machine.h>

#define _jcap_ 0
#define _levs_ 19
#define _lonf_ 1
#define _latg_ 2
#define _nvect_ 2

#define _ilonf_ 1
#define _ilatg_ 2
#define _ijcap_ 0
#define _ilevs_ 19

#define _io_ 1
#define _jo_ 2
#define _ko_ 19

#define _kt_ 6
#define _ktt_ 1
#define _kzz_ 1
#define _moo_ 1

#define _igrdp_ 1
#define _jgrdp_ 1

#define _lpnt_ 30
#define _ltstp_ 48
#define _slvark_ 80
#define _mlvark_ 8

#define SCM
#define GATE

#ifdef SCM
#define CONDENS
#endif
#ifdef GATE
#define _gxlon_ 336.5
#define _gylat_ 9.0
#define _lsmsk_ 0
#define RLX_FRC
#endif

