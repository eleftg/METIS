/*
 * Copyright 1997, Regents of the University of Minnesota
 *
 * rename.h
 *
 * This file contains header files
 *
 * Started 10/2/97
 * George
 *
 * $Id: rename.h 20398 2016-11-22 17:17:12Z karypis $
 *
 */


#ifndef _LIBMETIS_RENAME_H_
#define _LIBMETIS_RENAME_H_


/* balance.c */
#define Balance2Way			libmetis64__Balance2Way
#define Bnd2WayBalance			libmetis64__Bnd2WayBalance
#define General2WayBalance		libmetis64__General2WayBalance
#define McGeneral2WayBalance            libmetis64__McGeneral2WayBalance

/* bucketsort.c */
#define BucketSortKeysInc		libmetis64__BucketSortKeysInc

/* checkgraph.c */
#define CheckGraph                      libmetis64__CheckGraph
#define CheckInputGraphWeights          libmetis64__CheckInputGraphWeights
#define FixGraph                        libmetis64__FixGraph

/* coarsen.c */
#define CoarsenGraph			libmetis64__CoarsenGraph
#define CoarsenGraphNlevels			libmetis64__CoarsenGraphNlevels
#define Match_RM                        libmetis64__Match_RM
#define Match_SHEM                      libmetis64__Match_SHEM
#define Match_2Hop                      libmetis64__Match_2Hop
#define Match_2HopAny                   libmetis64__Match_2HopAny
#define Match_2HopAll                   libmetis64__Match_2HopAll
#define Match_JC                        libmetis64__Match_JC
#define PrintCGraphStats                libmetis64__PrintCGraphStats
#define CreateCoarseGraph		libmetis64__CreateCoarseGraph
#define SetupCoarseGraph		libmetis64__SetupCoarseGraph
#define ReAdjustMemory			libmetis64__ReAdjustMemory

/* compress.c */
#define CompressGraph			libmetis64__CompressGraph
#define PruneGraph			libmetis64__PruneGraph

/* contig.c */
#define ComputeBFSOrdering  libmetis64__ComputeBFSOrdering
#define FindPartitionInducedComponents  libmetis64__FindPartitionInducedComponents
#define IsConnected                     libmetis64__IsConnected
#define IsConnectedSubdomain            libmetis64__IsConnectedSubdomain
#define FindSepInducedComponents        libmetis64__FindSepInducedComponents
#define EliminateComponents             libmetis64__EliminateComponents
#define MoveGroupContigForCut           libmetis64__MoveGroupContigForCut
#define MoveGroupContigForVol           libmetis64__MoveGroupContigForVol

/* debug.c */
#define ComputeCut			libmetis64__ComputeCut
#define ComputeVolume			libmetis64__ComputeVolume
#define ComputeMaxCut			libmetis64__ComputeMaxCut
#define CheckBnd			libmetis64__CheckBnd
#define CheckBnd2			libmetis64__CheckBnd2
#define CheckNodeBnd			libmetis64__CheckNodeBnd
#define CheckRInfo			libmetis64__CheckRInfo
#define CheckNodePartitionParams	libmetis64__CheckNodePartitionParams
#define IsSeparable			libmetis64__IsSeparable
#define CheckKWayVolPartitionParams     libmetis64__CheckKWayVolPartitionParams

/* fm.c */
#define FM_2WayRefine                   libmetis64__FM_2WayRefine
#define FM_2WayCutRefine                libmetis64__FM_2WayCutRefine
#define FM_Mc2WayCutRefine              libmetis64__FM_Mc2WayCutRefine
#define SelectQueue                     libmetis64__SelectQueue
#define Print2WayRefineStats            libmetis64__Print2WayRefineStats

/* fortran.c */
#define Change2CNumbering		libmetis64__Change2CNumbering
#define Change2FNumbering		libmetis64__Change2FNumbering
#define Change2FNumbering2		libmetis64__Change2FNumbering2
#define Change2FNumberingOrder		libmetis64__Change2FNumberingOrder
#define ChangeMesh2CNumbering		libmetis64__ChangeMesh2CNumbering
#define ChangeMesh2FNumbering		libmetis64__ChangeMesh2FNumbering
#define ChangeMesh2FNumbering2		libmetis64__ChangeMesh2FNumbering2

/* graph.c */
#define SetupGraph			libmetis64__SetupGraph
#define SetupGraph_adjrsum              libmetis64__SetupGraph_adjrsum
#define SetupGraph_tvwgt                libmetis64__SetupGraph_tvwgt
#define SetupGraph_label                libmetis64__SetupGraph_label
#define SetupSplitGraph                 libmetis64__SetupSplitGraph
#define CreateGraph                     libmetis64__CreateGraph
#define InitGraph                       libmetis64__InitGraph
#define FreeSData                       libmetis64__FreeSData
#define FreeRData                       libmetis64__FreeRData
#define FreeGraph                       libmetis64__FreeGraph
#define graph_WriteToDisk               libmetis64__graph_WriteToDisk
#define graph_ReadFromDisk              libmetis64__graph_ReadFromDisk

/* initpart.c */
#define Init2WayPartition		libmetis64__Init2WayPartition
#define InitSeparator			libmetis64__InitSeparator
#define RandomBisection			libmetis64__RandomBisection
#define GrowBisection			libmetis64__GrowBisection
#define GrowBisectionNode2			libmetis64__GrowBisectionNode2
#define McRandomBisection               libmetis64__McRandomBisection
#define McGrowBisection                 libmetis64__McGrowBisection
#define GrowBisectionNode		libmetis64__GrowBisectionNode

/* kmetis.c */
#define MlevelKWayPartitioning		libmetis64__MlevelKWayPartitioning
#define InitKWayPartitioning            libmetis64__InitKWayPartitioning

/* kwayfm.c */
#define Greedy_KWayOptimize		libmetis64__Greedy_KWayOptimize
#define Greedy_KWayCutOptimize		libmetis64__Greedy_KWayCutOptimize
#define Greedy_KWayEdgeStats		libmetis64__Greedy_KWayEdgeStats
#define Greedy_KWayEdgeCutOptimize		libmetis64__Greedy_KWayEdgeCutOptimize
#define Greedy_KWayVolOptimize          libmetis64__Greedy_KWayVolOptimize
#define Greedy_McKWayCutOptimize        libmetis64__Greedy_McKWayCutOptimize
#define Greedy_McKWayVolOptimize        libmetis64__Greedy_McKWayVolOptimize
#define IsArticulationNode              libmetis64__IsArticulationNode
#define KWayVolUpdate                   libmetis64__KWayVolUpdate

/* kwayrefine.c */
#define RefineKWay			libmetis64__RefineKWay
#define AllocateKWayPartitionMemory	libmetis64__AllocateKWayPartitionMemory
#define ComputeKWayPartitionParams	libmetis64__ComputeKWayPartitionParams
#define ProjectKWayPartition		libmetis64__ProjectKWayPartition
#define ComputeKWayBoundary		libmetis64__ComputeKWayBoundary
#define ComputeKWayVolGains             libmetis64__ComputeKWayVolGains
#define IsBalanced			libmetis64__IsBalanced

/* mcutil */
#define rvecle                          libmetis64__rvecle
#define rvecge                          libmetis64__rvecge
#define rvecsumle                       libmetis64__rvecsumle
#define rvecmaxdiff                     libmetis64__rvecmaxdiff
#define ivecle                          libmetis64__ivecle
#define ivecge                          libmetis64__ivecge
#define ivecaxpylez                     libmetis64__ivecaxpylez
#define ivecaxpygez                     libmetis64__ivecaxpygez
#define BetterVBalance                  libmetis64__BetterVBalance
#define BetterBalance2Way               libmetis64__BetterBalance2Way
#define BetterBalanceKWay               libmetis64__BetterBalanceKWay
#define ComputeLoadImbalance            libmetis64__ComputeLoadImbalance
#define ComputeLoadImbalanceDiff        libmetis64__ComputeLoadImbalanceDiff
#define ComputeLoadImbalanceDiffVec     libmetis64__ComputeLoadImbalanceDiffVec
#define ComputeLoadImbalanceVec         libmetis64__ComputeLoadImbalanceVec

/* mesh.c */
#define CreateGraphDual                 libmetis64__CreateGraphDual
#define FindCommonElements              libmetis64__FindCommonElements
#define CreateGraphNodal                libmetis64__CreateGraphNodal
#define FindCommonNodes                 libmetis64__FindCommonNodes
#define CreateMesh                      libmetis64__CreateMesh
#define InitMesh                        libmetis64__InitMesh
#define FreeMesh                        libmetis64__FreeMesh

/* meshpart.c */
#define InduceRowPartFromColumnPart     libmetis64__InduceRowPartFromColumnPart

/* minconn.c */
#define ComputeSubDomainGraph           libmetis64__ComputeSubDomainGraph
#define UpdateEdgeSubDomainGraph        libmetis64__UpdateEdgeSubDomainGraph
#define PrintSubDomainGraph             libmetis64__PrintSubDomainGraph
#define EliminateSubDomainEdges         libmetis64__EliminateSubDomainEdges
#define MoveGroupMinConnForCut          libmetis64__MoveGroupMinConnForCut
#define MoveGroupMinConnForVol          libmetis64__MoveGroupMinConnForVol

/* mincover.c */
#define MinCover			libmetis64__MinCover
#define MinCover_Augment		libmetis64__MinCover_Augment
#define MinCover_Decompose		libmetis64__MinCover_Decompose
#define MinCover_ColDFS			libmetis64__MinCover_ColDFS
#define MinCover_RowDFS			libmetis64__MinCover_RowDFS

/* mmd.c */
#define genmmd				libmetis64__genmmd
#define mmdelm				libmetis64__mmdelm
#define mmdint				libmetis64__mmdint
#define mmdnum				libmetis64__mmdnum
#define mmdupd				libmetis64__mmdupd


/* ometis.c */
#define MlevelNestedDissection		libmetis64__MlevelNestedDissection
#define MlevelNestedDissectionCC	libmetis64__MlevelNestedDissectionCC
#define MlevelNodeBisectionMultiple	libmetis64__MlevelNodeBisectionMultiple
#define MlevelNodeBisectionL2		libmetis64__MlevelNodeBisectionL2
#define MlevelNodeBisectionL1		libmetis64__MlevelNodeBisectionL1
#define SplitGraphOrder			libmetis64__SplitGraphOrder
#define SplitGraphOrderCC		libmetis64__SplitGraphOrderCC
#define MMDOrder			libmetis64__MMDOrder

/* options.c */
#define SetupCtrl                       libmetis64__SetupCtrl
#define SetupKWayBalMultipliers         libmetis64__SetupKWayBalMultipliers
#define Setup2WayBalMultipliers         libmetis64__Setup2WayBalMultipliers
#define PrintCtrl                       libmetis64__PrintCtrl
#define FreeCtrl                        libmetis64__FreeCtrl
#define CheckParams                     libmetis64__CheckParams

/* parmetis.c */
#define MlevelNestedDissectionP		libmetis64__MlevelNestedDissectionP
#define FM_2WayNodeRefine1SidedP        libmetis64__FM_2WayNodeRefine1SidedP
#define FM_2WayNodeRefine2SidedP        libmetis64__FM_2WayNodeRefine2SidedP

/* pmetis.c */
#define MlevelRecursiveBisection	libmetis64__MlevelRecursiveBisection
#define MultilevelBisect		libmetis64__MultilevelBisect
#define SplitGraphPart			libmetis64__SplitGraphPart

/* refine.c */
#define Refine2Way			libmetis64__Refine2Way
#define Allocate2WayPartitionMemory	libmetis64__Allocate2WayPartitionMemory
#define Compute2WayPartitionParams	libmetis64__Compute2WayPartitionParams
#define Project2WayPartition		libmetis64__Project2WayPartition

/* separator.c */
#define ConstructSeparator		libmetis64__ConstructSeparator
#define ConstructMinCoverSeparator	libmetis64__ConstructMinCoverSeparator

/* sfm.c */
#define FM_2WayNodeRefine2Sided         libmetis64__FM_2WayNodeRefine2Sided
#define FM_2WayNodeRefine1Sided         libmetis64__FM_2WayNodeRefine1Sided
#define FM_2WayNodeBalance              libmetis64__FM_2WayNodeBalance

/* srefine.c */
#define Refine2WayNode			libmetis64__Refine2WayNode
#define Allocate2WayNodePartitionMemory	libmetis64__Allocate2WayNodePartitionMemory
#define Compute2WayNodePartitionParams	libmetis64__Compute2WayNodePartitionParams
#define Project2WayNodePartition	libmetis64__Project2WayNodePartition

/* stat.c */
#define ComputePartitionInfoBipartite   libmetis64__ComputePartitionInfoBipartite
#define ComputePartitionBalance		libmetis64__ComputePartitionBalance
#define ComputeElementBalance		libmetis64__ComputeElementBalance

/* timing.c */
#define InitTimers			libmetis64__InitTimers
#define PrintTimers			libmetis64__PrintTimers

/* util.c */
#define iargmax_strd                    libmetis64__iargmax_strd
#define iargmax_nrm                     libmetis64__iargmax_nrm
#define iargmax2_nrm                    libmetis64__iargmax2_nrm
#define rargmax2                        libmetis64__rargmax2
#define InitRandom                      libmetis64__InitRandom
#define metis_rcode                     libmetis64__metis_rcode

/* wspace.c */
#define AllocateWorkSpace               libmetis64__AllocateWorkSpace
#define AllocateRefinementWorkSpace     libmetis64__AllocateRefinementWorkSpace
#define FreeWorkSpace                   libmetis64__FreeWorkSpace
#define wspacemalloc                    libmetis64__wspacemalloc
#define wspacepush                      libmetis64__wspacepush
#define wspacepop                       libmetis64__wspacepop
#define iwspacemalloc                   libmetis64__iwspacemalloc
#define rwspacemalloc                   libmetis64__rwspacemalloc
#define ikvwspacemalloc                 libmetis64__ikvwspacemalloc
#define cnbrpoolReset                   libmetis64__cnbrpoolReset
#define cnbrpoolGetNext                 libmetis64__cnbrpoolGetNext
#define vnbrpoolReset                   libmetis64__vnbrpoolReset
#define vnbrpoolGetNext                 libmetis64__vnbrpoolGetNext

#endif


