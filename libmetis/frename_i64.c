/*
 * Copyright 1997, Regents of the University of Minnesota
 *
 * Frename.c
 *
 * THis file contains some renaming routines to deal with different Fortran compilers
 *
 * Started 9/15/97
 * George
 *
 */


#include "metislib.h"

#define FRENAME(name, dargs, cargs, name1, name2, name3, name4)   \
  int name1 dargs { return name cargs; }                          \
  int name2 dargs { return name cargs; }                          \
  int name3 dargs { return name cargs; }                          \
  int name4 dargs { return name cargs; }


FRENAME(
    METIS_PartGraphRecursive,
    (idx_t *nvtxs, idx_t *ncon, idx_t *xadj, idx_t *adjncy, idx_t *vwgt,
     idx_t *vsize, idx_t *adjwgt, idx_t *nparts, real_t *tpwgts,
     real_t *ubvec, idx_t *options, idx_t *edgecut, idx_t *part),
    (nvtxs, ncon, xadj, adjncy, vwgt,
     vsize, adjwgt, nparts, tpwgts,
     ubvec, options, edgecut, part),
    METIS64_PARTGRAPHRECURSIVE, 
    metis64_partgraphrecursive,
    metis64_partgraphrecursive_,
    metis64_partgraphrecursive__
)


FRENAME(
    METIS_PartGraphKway,
    (idx_t *nvtxs, idx_t *ncon, idx_t *xadj, idx_t *adjncy, idx_t *vwgt,
     idx_t *vsize, idx_t *adjwgt, idx_t *nparts, real_t *tpwgts,
     real_t *ubvec, idx_t *options, idx_t *edgecut, idx_t *part),
    (nvtxs, ncon, xadj, adjncy, vwgt,
     vsize, adjwgt, nparts, tpwgts,
     ubvec, options, edgecut, part),
    METIS64_PARTGRAPHKWAY,
    metis64_partgraphkway,
    metis64_partgraphkway_,
    metis64_partgraphkway__
)

FRENAME(
  METIS_MeshToDual,
  (idx_t *ne, idx_t *nn, idx_t *eptr, idx_t *eind, idx_t *ncommon, idx_t *numflag,
   idx_t **r_xadj, idx_t **r_adjncy),
  (ne, nn, eptr, eind, ncommon, numflag, r_xadj, r_adjncy),
  METIS64_MESHTODUAL,
  metis64_meshtodual,
  metis64_meshtodual_,
  metis64_meshtodual__
)


FRENAME(
  METIS_MeshToNodal,
  (idx_t *ne, idx_t *nn, idx_t *eptr, idx_t *eind, idx_t *numflag, idx_t **r_xadj,
   idx_t **r_adjncy),
  (ne, nn, eptr, eind, numflag, r_xadj, r_adjncy),
  METIS64_MESHTONODAL,
  metis64_meshtonodal,
  metis64_meshtonodal_,
  metis64_meshtonodal__
)


FRENAME(
  METIS_PartMeshNodal,
  (idx_t *ne, idx_t *nn, idx_t *eptr, idx_t *eind, idx_t *vwgt, idx_t *vsize,
   idx_t *nparts, real_t *tpwgts, idx_t *options, idx_t *objval, idx_t *epart,
   idx_t *npart),
  (ne, nn, eptr, eind, vwgt, vsize, nparts, tpwgts, options, objval, epart, npart),
  METIS64_PARTMESHNODAL,
  metis64_partmeshnodal,
  metis64_partmeshnodal_,
  metis64_partmeshnodal__
)


FRENAME(
  METIS_PartMeshDual,
  (idx_t *ne, idx_t *nn, idx_t *eptr, idx_t *eind, idx_t *vwgt, idx_t *vsize,
   idx_t *ncommon, idx_t *nparts, real_t *tpwgts, idx_t *options, idx_t *objval,
   idx_t *epart, idx_t *npart),
  (ne, nn, eptr, eind, vwgt, vsize, ncommon, nparts, tpwgts, options, objval, epart, npart),
  METIS64_PARTMESHDUAL,
  metis64_partmeshdual,
  metis64_partmeshdual_,
  metis64_partmeshdual__
)


FRENAME(
  METIS_NodeND,
  (idx_t *nvtxs, idx_t *xadj, idx_t *adjncy, idx_t *vwgt, idx_t *options, idx_t *perm,
   idx_t *iperm),
  (nvtxs, xadj, adjncy, vwgt, options, perm, iperm),
  METIS64_NODEND,
  metis64_nodend,
  metis64_nodend_,
  metis64_nodend__
)


FRENAME(
  METIS_Free,
  (void *ptr),
  (ptr),
  METIS64_FREE,
  metis64_free,
  metis64_free_,
  metis64_free__
)


FRENAME(
  METIS_SetDefaultOptions,
  (idx_t *options),
  (options),
  METIS64_SETDEFAULTOPTIONS,
  metis64_setdefaultoptions,
  metis64_setdefaultoptions_,
  metis64_setdefaultoptions__
)



