# Helper modules.
include(CheckFunctionExists)
include(CheckIncludeFile)

# Setup options.
option(GDB "enable use of GDB" OFF)
option(ASSERT "turn asserts on" OFF)
option(ASSERT2 "additional assertions" OFF)
option(GPROF "add gprof support" OFF)
option(VALGRIND "add valgrind support" OFF)
option(OPENMP "enable OpenMP support" OFF)
option(PCRE "enable PCRE support" OFF)
option(GKREGEX "enable GKREGEX support" OFF)
option(GKRAND "enable GKRAND support" OFF)

if(CMAKE_C_COMPILER_ID MATCHES GNU)
  if(VALGRIND)
    set(_gnu_flags -march=x86-64 -mtune=generic)
  else()
    # -march=native is not a valid flag on PPC:
    if(CMAKE_SYSTEM_PROCESSOR MATCHES "power|ppc|powerpc|ppc64|powerpc64" OR (APPLE AND CMAKE_OSX_ARCHITECTURES MATCHES "ppc|ppc64"))
      set(_gnu_flags -mtune=native)
    else()
      set(_gnu_flags -march=native)
    endif()
  endif()
  list(APPEND _gnu_flags -O2 -fno-strict-aliasing -Werror -Wall -pedantic -Wno-unused-function -Wno-unused-but-set-variable -Wno-unused-variable -Wno-unknown-pragmas -Wno-unused-label)
  if(GPROF)
    list(APPEND _gnu_flags -pg)
  endif()
endif()

# Find OpenMP if it is requested.
if(OPENMP)
  find_package(OpenMP COMPONENTS C)
  if(NOT OpenMP_FOUND)
    message(WARNING "OpenMP was requested but support was not found")
  endif()
endif()

# Check for features. Verify presence of platform-specific headers on the system
include(CheckIncludeFile)
check_include_file(sys/resource.h HAVE_SYS_RESOURCE_H)
check_include_file(execinfo.h HAVE_EXECINFO_H)
check_function_exists(getline HAVE_GETLINE)

# Custom check for TLS.
if(MSVC)
  # This if checks whether that value is cached or not.
  if("${HAVE_THREADLOCALSTORAGE}" MATCHES "^${HAVE_THREADLOCALSTORAGE}$")
    try_compile(HAVE_THREADLOCALSTORAGE
      ${CMAKE_BINARY_DIR}
      ${CMAKE_SOURCE_DIR}/conf/check_thread_storage.c
      COMPILE_DEFINITIONS "/D__thread=__declspec(thread)"
    )
    if(HAVE_THREADLOCALSTORAGE)
      message(STATUS "checking for thread-local storage - found")
    else()
      message(STATUS "checking for thread-local storage - not found")
    endif()
  endif()
endif()

add_compile_definitions(
  "$<$<BOOL:${MSVC}>:WIN32;MSC;_CRT_SECURE_NO_DEPRECATE;_CRT_SECURE_NO_WARNINGS;$<IF:$<BOOL:HAVE_THREADLOCALSTORAGE>,__thread=__declspec(thread),__thread=>>"
  "$<$<BOOL:${UNIX}>:LINUX;_FILE_OFFSET_BITS=64>"
  "$<$<BOOL:${APPLE}>:MACOS>"
  "$<$<BOOL:${OpenMP_FOUND}>:ENABLE_OPENMP>"
  "$<$<BOOL:${CYGWIN}>:CYGWIN>"

  "$<$<NOT:$<BOOL:${ASSERT}>>:NDEBUG>"
  "$<$<NOT:$<BOOL:${ASSERT2}>>:NDEBUG2>"
  "$<$<CONFIG:Debug>:DEBUG>"

  "$<$<BOOL:${PCRE}>:__WITHPCRE__>"
  "$<$<OR:$<BOOL:${GKREGEX}>,$<BOOL:${MINGW}>,$<BOOL:${MSVC}>>:USE_GKREGEX>"
  "$<$<BOOL:${GKRAND}>:USE_GKRAND>"

  "$<$<BOOL:${HAVE_SYS_RESOURCE_H}>:HAVE_SYS_RESOURCE_H>"
  "$<$<BOOL:${HAVE_EXECINFO_H}>:HAVE_EXECINFO_H>"
  "$<$<BOOL:${HAVE_GETLINE}>:HAVE_GETLINE>"
)
add_compile_options(
  "$<$<AND:$<C_COMPILER_ID:MSVC>,$<NOT:$<CONFIG:Debug>>>:/Ox>"
  "$<$<C_COMPILER_ID:GNU>:${_gnu_flags}>"
  "$<$<C_COMPILER_ID:Intel>:$<IF:$<BOOL:${WIN32}>,/QxHost,-xHost>>"
)
