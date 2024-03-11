include_guard()

# Helper modules.
include(CheckFunctionExists)
include(CheckIncludeFile)

# Setup options.
option(GDB "enable use of GDB" OFF)
option(ASSERT "turn asserts on" OFF)
option(ASSERT2 "additional assertions" OFF)
option(DEBUG "add debugging support" OFF)
option(GPROF "add gprof support" OFF)
option(OPENMP "enable OpenMP support" OFF)
option(PCRE "enable PCRE support" OFF)
option(GKREGEX "enable GKREGEX support" OFF)
option(GKRAND "enable GKRAND support" OFF)

if(CMAKE_C_COMPILER_ID MATCHES GNU)
  # -march=native is not a valid flag on PPC:
  if(CMAKE_SYSTEM_PROCESSOR MATCHES "power|ppc|powerpc|ppc64|powerpc64" OR (APPLE AND CMAKE_OSX_ARCHITECTURES MATCHES "ppc|ppc64"))
    set(_gnu_flags -mtune=native)
  else()
    set(_gnu_flags -march=native)
  endif()
  list(APPEND _gnu_flags -fno-strict-aliasing -Wall -pedantic -Wno-unused-but-set-variable -Wno-unused-variable -Wno-unknown-pragmas)
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

# Check for features.
check_include_file(execinfo.h HAVE_EXECINFO_H)
check_function_exists(getline HAVE_GETLINE)

# Custom check for TLS.
if(MSVC)
  # This if checks whether that value is cached or not.
  if("${HAVE_THREADLOCALSTORAGE}" MATCHES "^${HAVE_THREADLOCALSTORAGE}$")
    try_compile(HAVE_THREADLOCALSTORAGE
      ${CMAKE_BINARY_DIR}
      ${CMAKE_SOURCE_DIR}/GKlib/conf/check_thread_storage.c
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
  "$<${linux_and_nodebug_and_noasan}:_FORTIFY_SOURCE=2>"

  "$<${msvc}:WIN32;MSC;_CRT_SECURE_NO_DEPRECATE;_CRT_SECURE_NO_WARNINGS;$<IF:$<BOOL:HAVE_THREADLOCALSTORAGE>,__thread=__declspec(thread),__thread=>>"
  "$<${unix}:LINUX;_FILE_OFFSET_BITS=64>"

  "$<$<BOOL:${OpenMP_FOUND}>:ENABLE_OPENMP>"
  "$<$<BOOL:${CYGWIN}>:CYGWIN>"

  "$<$<NOT:$<BOOL:${ASSERT}>>:NDEBUG>"
  "$<$<NOT:$<BOOL:${ASSERT2}>>:NDEBUG2>"
  "$<${debug}:DEBUG>"

  "$<$<BOOL:${PCRE}>:__WITHPCRE__>"
  "$<$<OR:$<BOOL:${GKREGEX}>,$<BOOL:${MINGW}>,$<BOOL:${MSVC}>>:USE_GKREGEX>"
  "$<$<BOOL:${GKRAND}>:USE_GKRAND>"

  "$<$<BOOL:${HAVE_EXECINFO_H}>:HAVE_EXECINFO_H>"
  "$<$<BOOL:${HAVE_GETLINE}>:HAVE_GETLINE>"
)
add_compile_options(
  "${stack_protect}"
  "$<${msvc}:$<${asan}:/fsanitize=address>>"
  "$<${fuzzer}:/fsanitize=fuzzer>"
  "$<${nomsvc}:$<${asan_and_debug}:-fsanitize=address>>"
  "$<${nomsvc}:$<${asan_and_nodebug}:-Wp,-U_FORTIFY_SOURCE;-O1;-fsanitize=address;-fno-omit-frame-pointer;-fno-optimize-sibling-calls>>"
  "$<${tsan}:-fsanitize=thread>"
  "$<${lsan}:-fsanitize=leak>"
  "$<$<AND:$<C_COMPILER_ID:MSVC>,$<NOT:$<CONFIG:Debug>>>:/Ox>"
  "$<${gnu}:${_gnu_flags}>"
  "${deal_with_corrupt_pdb}"
)
add_link_options(
  "$<${nomsvc}:$<${asan}:-fsanitize=address>>"
  "$<${tsan}:-fsanitize=thread>"
  "$<${lsan}:-fsanitize=leak>"
)
if(WITH_ASAN_POINTER_COMPARE)
    add_compile_options(-fsanitize=pointer-compare)
    add_link_options(-fsanitize=pointer-compare)
endif()
if(WITH_ASAN_POINTER_SUBTRACT)
    add_compile_options(-fsanitize=pointer-subtract)
    add_link_options(-fsanitize=pointer-subtract)
endif()
# Find GKlib sources.
file(GLOB GKlib_sources ${CMAKE_SOURCE_DIR}/GKlib/*.c)
file(GLOB GKlib_includes ${CMAKE_SOURCE_DIR}/GKlib/*.h)
