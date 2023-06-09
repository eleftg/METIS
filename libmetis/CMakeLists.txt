# Add this directory for internal users.
include_directories(.)

# Find sources.
file(GLOB metis_sources *.c)

# Build libmetis.
add_library(metis ${METIS_LIBRARY_TYPE} ${metis_sources})
target_link_libraries(metis GKlib)

install(TARGETS metis
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
    ARCHIVE DESTINATION lib
)
install(
    FILES ${CMAKE_BINARY_DIR}/include/metis.h
    DESTINATION include
)
