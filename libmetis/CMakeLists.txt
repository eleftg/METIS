# Add this directory for internal users.
include_directories(${CMAKE_CURRENT_SOURCE_DIR})

# Find sources.
file(GLOB metis_sources *.c)

# Build libmetis with i32 index
add_library(metis_i32 ${metis_sources})
target_link_libraries(metis_i32 GKlib "$<$<BOOL:${OpenMP_FOUND}>:OpenMP::OpenMP_C>")
target_compile_definitions(metis_i32
    PUBLIC
        IDXTYPEWIDTH=32
    PRIVATE
        "$<$<BOOL:${GKLIB_AS_DLL}>:GKLIB_DLL_OVERSHADOWS_TLS>"
        "$<$<BOOL:${USE_STATIC_GKLIB}>:GKLIB_STATIC_DEFINE>"
)
# Build libmetis with i64 index
list(FILTER metis_sources EXCLUDE REGEX "frename\\.c")
list(APPEND metis_sources frename_i64.c)
add_library(metis_i64 ${metis_sources})
target_link_libraries(metis_i64 GKlib "$<$<BOOL:${OpenMP_FOUND}>:OpenMP::OpenMP_C>")
target_compile_definitions(metis_i64
    PUBLIC
        IDXTYPEWIDTH=64
    PRIVATE
        "$<$<BOOL:${GKLIB_AS_DLL}>:GKLIB_DLL_OVERSHADOWS_TLS>"
        "$<$<BOOL:${USE_STATIC_GKLIB}>:GKLIB_STATIC_DEFINE>"
)
install(TARGETS metis_i32 metis_i64
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
    ARCHIVE DESTINATION lib
)
install(
    FILES ${CMAKE_BINARY_DIR}/include/metis.h
    DESTINATION include
)
