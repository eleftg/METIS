cmake_minimum_required(VERSION 3.15)
project(METIS C)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_STANDARD_EXTENSIONS OFF)
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)

find_package(gklib REQUIRED CONFIG)

# Configure libmetis library.
include(./conf/gkbuild.cmake)

option(REAL64 "enable 64 bit floats (i.e. double)" OFF)

if(REAL64)
    set(realtypewidth 64)
else()
    set(realtypewidth 32)
endif()

# generate a configuration header that transforms the above options
# into preprocessor macros
configure_file(
    ${CMAKE_SOURCE_DIR}/conf/metis.h.in
    ${CMAKE_BINARY_DIR}/include/metis.h @ONLY
)
configure_file(${CMAKE_SOURCE_DIR}/conf/metis_sanitizers.cmake.in
    ${CMAKE_BINARY_DIR}/metis_sanitizers.cmake
)
install(FILES ${CMAKE_BINARY_DIR}/metis_sanitizers.cmake DESTINATION lib/cmake)

# Add include directories.
# i.e., the -I equivalent
include_directories(${CMAKE_BINARY_DIR}/include)

# Recursively look for CMakeLists.txt in subdirs.
add_subdirectory(libmetis)
add_subdirectory(programs)
