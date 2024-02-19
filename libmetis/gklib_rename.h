/*!
\file

 * Copyright 1997, Regents of the University of Minnesota
 *
 * This file contains header files
 *
 * Started 10/2/97
 * George
 *
 * $Id: gklib_rename.h 10395 2011-06-23 23:28:06Z karypis $
 *
 */


#ifndef _LIBMETIS_GKLIB_RENAME_H_
#define _LIBMETIS_GKLIB_RENAME_H_

/* gklib.c - generated from the .o files using the ./utils/listundescapedsumbols.csh */

#if IDXTYPEWIDTH == 32

#define iAllocMatrix libmetis__iAllocMatrix
#define iFreeMatrix libmetis__iFreeMatrix
#define iSetMatrix libmetis__iSetMatrix
#define iargmax libmetis__iargmax
#define iargmax_n libmetis__iargmax_n
#define iargmin libmetis__iargmin
#define iarray2csr libmetis__iarray2csr
#define iaxpy libmetis__iaxpy
#define icopy libmetis__icopy
#define idot libmetis__idot
#define iincset libmetis__iincset
#define ikvAllocMatrix libmetis__ikvAllocMatrix
#define ikvFreeMatrix libmetis__ikvFreeMatrix
#define ikvSetMatrix libmetis__ikvSetMatrix
#define ikvcopy libmetis__ikvcopy
#define ikvmalloc libmetis__ikvmalloc
#define ikvrealloc libmetis__ikvrealloc
#define ikvset libmetis__ikvset
#define ikvsmalloc libmetis__ikvsmalloc
#define ikvsortd libmetis__ikvsortd
#define ikvsorti libmetis__ikvsorti
#define ikvsortii libmetis__ikvsortii
#define imalloc libmetis__imalloc
#define imax libmetis__imax
#define imin libmetis__imin
#define inorm2 libmetis__inorm2
#define ipqCheckHeap libmetis__ipqCheckHeap
#define ipqCreate libmetis__ipqCreate
#define ipqDelete libmetis__ipqDelete
#define ipqDestroy libmetis__ipqDestroy
#define ipqFree libmetis__ipqFree
#define ipqGetTop libmetis__ipqGetTop
#define ipqInit libmetis__ipqInit
#define ipqInsert libmetis__ipqInsert
#define ipqLength libmetis__ipqLength
#define ipqReset libmetis__ipqReset
#define ipqSeeKey libmetis__ipqSeeKey
#define ipqSeeTopKey libmetis__ipqSeeTopKey
#define ipqSeeTopVal libmetis__ipqSeeTopVal
#define ipqUpdate libmetis__ipqUpdate
#define isrand libmetis__isrand
#define irand libmetis__irand
#define irandArrayPermute libmetis__irandArrayPermute
#define irandArrayPermuteFine libmetis__irandArrayPermuteFine
#define irandInRange libmetis__irandInRange
#define irealloc libmetis__irealloc
#define iscale libmetis__iscale
#define iset libmetis__iset
#define ismalloc libmetis__ismalloc
#define isortd libmetis__isortd
#define isorti libmetis__isorti
#define isrand libmetis__isrand
#define isum libmetis__isum
#define rAllocMatrix libmetis__rAllocMatrix
#define rFreeMatrix libmetis__rFreeMatrix
#define rSetMatrix libmetis__rSetMatrix
#define rargmax libmetis__rargmax
#define rargmax_n libmetis__rargmax_n
#define rargmin libmetis__rargmin
#define raxpy libmetis__raxpy
#define rcopy libmetis__rcopy
#define rdot libmetis__rdot
#define rincset libmetis__rincset
#define rkvAllocMatrix libmetis__rkvAllocMatrix
#define rkvFreeMatrix libmetis__rkvFreeMatrix
#define rkvSetMatrix libmetis__rkvSetMatrix
#define rkvcopy libmetis__rkvcopy
#define rkvmalloc libmetis__rkvmalloc
#define rkvrealloc libmetis__rkvrealloc
#define rkvset libmetis__rkvset
#define rkvsmalloc libmetis__rkvsmalloc
#define rkvsortd libmetis__rkvsortd
#define rkvsorti libmetis__rkvsorti
#define rmalloc libmetis__rmalloc
#define rmax libmetis__rmax
#define rmin libmetis__rmin
#define rnorm2 libmetis__rnorm2
#define rpqCheckHeap libmetis__rpqCheckHeap
#define rpqCreate libmetis__rpqCreate
#define rpqDelete libmetis__rpqDelete
#define rpqDestroy libmetis__rpqDestroy
#define rpqFree libmetis__rpqFree
#define rpqGetTop libmetis__rpqGetTop
#define rpqInit libmetis__rpqInit
#define rpqInsert libmetis__rpqInsert
#define rpqLength libmetis__rpqLength
#define rpqReset libmetis__rpqReset
#define rpqSeeKey libmetis__rpqSeeKey
#define rpqSeeTopKey libmetis__rpqSeeTopKey
#define rpqSeeTopVal libmetis__rpqSeeTopVal
#define rpqUpdate libmetis__rpqUpdate
#define rrealloc libmetis__rrealloc
#define rscale libmetis__rscale
#define rset libmetis__rset
#define rsmalloc libmetis__rsmalloc
#define rsortd libmetis__rsortd
#define rsorti libmetis__rsorti
#define rsum libmetis__rsum
#define uvwsorti libmetis__uvwsorti

#elif IDXTYPEWIDTH == 64

#define iAllocMatrix libmetis64__iAllocMatrix
#define iFreeMatrix libmetis64__iFreeMatrix
#define iSetMatrix libmetis64__iSetMatrix
#define iargmax libmetis64__iargmax
#define iargmax_n libmetis64__iargmax_n
#define iargmin libmetis64__iargmin
#define iarray2csr libmetis64__iarray2csr
#define iaxpy libmetis64__iaxpy
#define icopy libmetis64__icopy
#define idot libmetis64__idot
#define iincset libmetis64__iincset
#define ikvAllocMatrix libmetis64__ikvAllocMatrix
#define ikvFreeMatrix libmetis64__ikvFreeMatrix
#define ikvSetMatrix libmetis64__ikvSetMatrix
#define ikvcopy libmetis64__ikvcopy
#define ikvmalloc libmetis64__ikvmalloc
#define ikvrealloc libmetis64__ikvrealloc
#define ikvset libmetis64__ikvset
#define ikvsmalloc libmetis64__ikvsmalloc
#define ikvsortd libmetis64__ikvsortd
#define ikvsorti libmetis64__ikvsorti
#define ikvsortii libmetis64__ikvsortii
#define imalloc libmetis64__imalloc
#define imax libmetis64__imax
#define imin libmetis64__imin
#define inorm2 libmetis64__inorm2
#define ipqCheckHeap libmetis64__ipqCheckHeap
#define ipqCreate libmetis64__ipqCreate
#define ipqDelete libmetis64__ipqDelete
#define ipqDestroy libmetis64__ipqDestroy
#define ipqFree libmetis64__ipqFree
#define ipqGetTop libmetis64__ipqGetTop
#define ipqInit libmetis64__ipqInit
#define ipqInsert libmetis64__ipqInsert
#define ipqLength libmetis64__ipqLength
#define ipqReset libmetis64__ipqReset
#define ipqSeeKey libmetis64__ipqSeeKey
#define ipqSeeTopKey libmetis64__ipqSeeTopKey
#define ipqSeeTopVal libmetis64__ipqSeeTopVal
#define ipqUpdate libmetis64__ipqUpdate
#define isrand libmetis64__isrand
#define irand libmetis64__irand
#define irandArrayPermute libmetis64__irandArrayPermute
#define irandArrayPermuteFine libmetis64__irandArrayPermuteFine
#define irandInRange libmetis64__irandInRange
#define irealloc libmetis64__irealloc
#define iscale libmetis64__iscale
#define iset libmetis64__iset
#define ismalloc libmetis64__ismalloc
#define isortd libmetis64__isortd
#define isorti libmetis64__isorti
#define isrand libmetis64__isrand
#define isum libmetis64__isum
#define rAllocMatrix libmetis64__rAllocMatrix
#define rFreeMatrix libmetis64__rFreeMatrix
#define rSetMatrix libmetis64__rSetMatrix
#define rargmax libmetis64__rargmax
#define rargmax_n libmetis64__rargmax_n
#define rargmin libmetis64__rargmin
#define raxpy libmetis64__raxpy
#define rcopy libmetis64__rcopy
#define rdot libmetis64__rdot
#define rincset libmetis64__rincset
#define rkvAllocMatrix libmetis64__rkvAllocMatrix
#define rkvFreeMatrix libmetis64__rkvFreeMatrix
#define rkvSetMatrix libmetis64__rkvSetMatrix
#define rkvcopy libmetis64__rkvcopy
#define rkvmalloc libmetis64__rkvmalloc
#define rkvrealloc libmetis64__rkvrealloc
#define rkvset libmetis64__rkvset
#define rkvsmalloc libmetis64__rkvsmalloc
#define rkvsortd libmetis64__rkvsortd
#define rkvsorti libmetis64__rkvsorti
#define rmalloc libmetis64__rmalloc
#define rmax libmetis64__rmax
#define rmin libmetis64__rmin
#define rnorm2 libmetis64__rnorm2
#define rpqCheckHeap libmetis64__rpqCheckHeap
#define rpqCreate libmetis64__rpqCreate
#define rpqDelete libmetis64__rpqDelete
#define rpqDestroy libmetis64__rpqDestroy
#define rpqFree libmetis64__rpqFree
#define rpqGetTop libmetis64__rpqGetTop
#define rpqInit libmetis64__rpqInit
#define rpqInsert libmetis64__rpqInsert
#define rpqLength libmetis64__rpqLength
#define rpqReset libmetis64__rpqReset
#define rpqSeeKey libmetis64__rpqSeeKey
#define rpqSeeTopKey libmetis64__rpqSeeTopKey
#define rpqSeeTopVal libmetis64__rpqSeeTopVal
#define rpqUpdate libmetis64__rpqUpdate
#define rrealloc libmetis64__rrealloc
#define rscale libmetis64__rscale
#define rset libmetis64__rset
#define rsmalloc libmetis64__rsmalloc
#define rsortd libmetis64__rsortd
#define rsorti libmetis64__rsorti
#define rsum libmetis64__rsum
#define uvwsorti libmetis64__uvwsorti

#endif

#endif
