cmake_minimum_required(VERSION 3.15)
project(METIS C)

# Configure libmetis library.
if(BUILD_SHARED_LIBS)
  set(METIS_LIBRARY_TYPE SHARED)
  set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
else()
  set(METIS_LIBRARY_TYPE STATIC)
endif()

include(./conf/gkbuild.cmake)

# METIS' custom options
option(IDX64 "enable 64 bit ints" OFF)
option(REAL64 "enable 64 bit floats (i.e. double)" OFF)

if(IDX64)
    set(idxtypewidth 64)
else()
    set(idxtypewidth 32)
endif()

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
# verify presence of platform-specific headers on the system
include(CheckIncludeFile)
check_include_file(sys/resource.h HAVE_SYS_RESOURCE_H)
configure_file(
    ${CMAKE_SOURCE_DIR}/conf/metis_config.h.in
    ${CMAKE_BINARY_DIR}/include/metis_config.h @ONLY
)
# Add include directories.
# i.e., the -I equivalent
include_directories(${GKLIB_PATH}/include)
include_directories(${CMAKE_BINARY_DIR}/include)

# List of paths that the compiler will search for library files.
# i.e., the -L equivalent
link_directories(${GKLIB_PATH}/lib)

# Recursively look for CMakeLists.txt in subdirs.
add_subdirectory(libmetis)
add_subdirectory(programs)
