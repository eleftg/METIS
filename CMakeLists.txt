cmake_minimum_required(VERSION 3.15)
project(METIS C)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_STANDARD_EXTENSIONS OFF)

# Configure libmetis library.
if(BUILD_SHARED_LIBS)
  set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
endif()

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
