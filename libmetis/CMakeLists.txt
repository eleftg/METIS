# Find sources.
file(GLOB metis_sources *.c)

# Build libmetis with i32 index
add_library(metis_i32 ${metis_sources})
target_link_libraries(metis_i32 PRIVATE GKlib_i32 "$<$<BOOL:${OpenMP_FOUND}>:OpenMP::OpenMP_C>")
target_compile_definitions(metis_i32 PUBLIC IDXTYPEWIDTH=32)
target_include_directories(metis_i32 PUBLIC
    "$<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/include;${CMAKE_CURRENT_SOURCE_DIR}>"
    $<INSTALL_INTERFACE:include>
)
# Build libmetis with i64 index
add_library(metis_i64 ${metis_sources})
target_link_libraries(metis_i64 PRIVATE GKlib_i64 "$<$<BOOL:${OpenMP_FOUND}>:OpenMP::OpenMP_C>")
target_compile_definitions(metis_i64 PUBLIC IDXTYPEWIDTH=64)
target_include_directories(metis_i64 PUBLIC
    "$<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/include;${CMAKE_CURRENT_SOURCE_DIR}>"
    $<INSTALL_INTERFACE:include>
)
install(TARGETS metis_i32 metis_i64
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
    ARCHIVE DESTINATION lib
)
install(
    FILES ${CMAKE_SOURCE_DIR}/include/metis.h
    DESTINATION include
)
