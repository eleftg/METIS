include_guard()

macro(_compose_handy_generator_expressions)
    if(CMAKE_GENERATOR MATCHES "Visual Studio")
        set(vsgen 1)
    else()
        set(vsgen 0)
    endif()
    set(debug $<CONFIG:Debug>)
    set(nodebug $<NOT:$<CONFIG:Debug>>)
    set(shared $<BOOL:${BUILD_SHARED_LIBS}>)
    set(static $<NOT:${shared}>)
    set(linux $<BOOL:${LINUX}>)
    set(unix $<BOOL:${UNIX}>)
    set(msvc $<BOOL:${MSVC}>)
    set(nomsvc $<NOT:$<BOOL:${MSVC}>>)
    set(win $<BOOL:${WIN32}>)

    set(asan $<BOOL:${WITH_ASAN}>)
    set(tsan $<BOOL:${WITH_TSAN}>)
    set(lsan $<BOOL:${WITH_LSAN}>)
    set(fuzzer $<BOOL:${WITH_FUZZER}>)

    set(intel $<C_COMPILER_ID:Intel,IntelLLVM>)
    set(gnu $<C_COMPILER_ID:GNU>)
    set(clang $<C_COMPILER_ID:Clang>)

    set(win_and_shared $<AND:${win},${shared}>)
    set(unix_and_intel $<AND:${unix},${intel}>)
    set(unix_and_gnu $<AND:${unix},${gnu}>)
    set(win_and_intel $<AND:${win},${intel}>)
    set(linux_and_nodebug $<AND:${linux},${nodebug}>)
    set(gnu_and_nodebug $<AND:${gnu},${nodebug}>)

    set(asan_and_debug $<AND:${asan},${debug}>)
    set(asan_and_nodebug $<AND:${asan},${nodebug}>)
    set(lsan_and_clang $<AND:${lsan},${clang}>)

    # "error #31000: corrupt PDB file; delete and rebuild;
    # if problem persists, delete and try /Z7 instead"
    # (highly parallel ninja builds sometimes suffer
    # concurrency issues related to pdb access)
    if(CMAKE_GENERATOR MATCHES Ninja AND
    MSVC_VERSION VERSION_GREATER 1700)
        # The /FS flag prevents the compiler from locking the
        # *.pdb files and serializes access to them
        # through MSPDBSRV.EXE. However, the /FS flag is unavailable
        # in icl.exe, in which case compiler-generated pdb (/Zi)
        # must be overriden by /Z7 (debug information embedded
        # into the object files). PDB files can still be
        # generated later by the linker with the /DEBUG flag
        set(z7 $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>,$<CONFIG:Noopt>>:/Z7>)
        set(fs $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>,$<CONFIG:Noopt>>:/FS>)
        set(deal_with_corrupt_pdb $<IF:${intel},${z7},${fs}>)
    endif()
endmacro()

macro(_protect_and_sanitize)
    include(CheckCCompilerFlag)
    include(CMakeDependentOption)
    if(MSVC)
        check_c_compiler_flag(/fsanitize=address have_address_sanitizer)
        cmake_dependent_option(WITH_ASAN
            "build with AddressSanitizer" OFF
            have_address_sanitizer OFF
        )
        check_c_compiler_flag(/fsanitize=fuzzer have_fuzzer)
        cmake_dependent_option(WITH_FUZZER
            "build with Fuzzer" OFF
            have_fuzzer OFF
        )
    else()
        # check stack protection capabilities
        check_c_compiler_flag(-fstack-protector-strong
            have_strong_stack_protector
        )
        if(have_strong_stack_protector)
            set(stack_protect -fstack-protector-strong)
        else()
            check_c_compiler_flag(-fstack-protector
                have_stack_protector
            )
            if(have_stack_protector)
                set(stack_protect -fstack-protector)
            endif()
        endif()
        # check implemented sanitizers
        set(CMAKE_REQUIRED_LINK_OPTIONS -fsanitize=address)
        check_c_compiler_flag(-fsanitize=address have_address_sanitizer)
        cmake_dependent_option(WITH_ASAN
            "build with AddressSanitizer" OFF
            have_address_sanitizer OFF
        )
        if(have_address_sanitizer)
            set(CMAKE_REQUIRED_FLAGS -fsanitize=address)
            check_c_compiler_flag(-fsanitize=pointer-compare
                have_asan_pointer_compare
            )
            cmake_dependent_option(WITH_ASAN_POINTER_COMPARE
                "build with -fsanitize=pointer-compare" ON
                "have_asan_pointer_compare;WITH_ASAN" OFF
            )
            check_c_compiler_flag(-fsanitize=pointer-subtract
                have_asan_pointer_subtract
            )
            cmake_dependent_option(WITH_ASAN_POINTER_SUBTRACT
                "build with -fsanitize=pointer-subtract" ON
                "have_asan_pointer_subtract;WITH_ASAN" OFF
            )
            unset(CMAKE_REQUIRED_FLAGS)
        endif()
        set(CMAKE_REQUIRED_LINK_OPTIONS -fsanitize=thread)
        check_c_compiler_flag(-fsanitize=thread have_thread_sanitizer)
        unset(CMAKE_REQUIRED_LINK_OPTIONS)
        cmake_dependent_option(WITH_TSAN
            "build with ThreadSanitizer" OFF
            have_thread_sanitizer OFF
        )
        set(CMAKE_REQUIRED_LINK_OPTIONS -fsanitize=leak)
        check_c_compiler_flag(-fsanitize=leak have_leak_sanitizer)
        unset(CMAKE_REQUIRED_LINK_OPTIONS)
        cmake_dependent_option(WITH_LSAN
            "build with LeakSanitizer" OFF
            have_leak_sanitizer OFF
        )
        if(WITH_ASAN AND WITH_TSAN)
            message(FATAL_ERROR "The AddressSanitizer cannot be combined with the ThreadSanitizer")
        endif()
        if(WITH_TSAN AND WITH_LSAN)
            message(FATAL_ERROR "The ThreadSanitizer cannot be combined with the LeakSanitizer")
        endif()
    endif()
endmacro()

# Clear erroneous -DNDEBUG polluting the Intel compiler flags
# on Windows (it's /DNDEBUG instead, which is already present)
function(_fix_ndebug)
    if(MSVC AND CMAKE_C_COMPILER_ID STREQUAL Intel)
        # foreach(lang C CXX Fortran)
        foreach(lang C)
            foreach(conf RELEASE MINSIZEREL RELWITHDEBINFO NOOPT)
                if(UNIX)
                    separate_arguments(CMAKE_${lang}_FLAGS_${conf} UNIX_COMMAND "${CMAKE_${lang}_FLAGS_${conf}}")
                elseif(WIN32)
                    separate_arguments(CMAKE_${lang}_FLAGS_${conf} WINDOWS_COMMAND "${CMAKE_${lang}_FLAGS_${conf}}")
                else()
                    separate_arguments(CMAKE_${lang}_FLAGS_${conf})
                endif()
                list(REMOVE_ITEM CMAKE_${lang}_FLAGS_${conf} -DNDEBUG)
                string(REPLACE ";" " " CMAKE_${lang}_FLAGS_${conf} "${CMAKE_${lang}_FLAGS_${conf}}")
                set(CMAKE_${lang}_FLAGS_${conf} "${CMAKE_${lang}_FLAGS_${conf}}" CACHE STRING "Flags used by the ${lang} compiler during ${conf} builds" FORCE)
            endforeach()
        endforeach()
    endif()
endfunction()

# drop the optimization level from 3 to 2 replacing the -O3 optimization
# flag with -O2 for Release & RelWithDebInfo & Noopt configs
function(_O2_instead_of_O3)
    # foreach(lang C CXX Fortran)
    foreach(lang C)
        foreach(bt RELEASE RELWITHDEBINFO NOOPT)
            if(UNIX)
                separate_arguments(CMAKE_${lang}_FLAGS_${bt} UNIX_COMMAND "${CMAKE_${lang}_FLAGS_${bt}}")
            elseif(WIN32)
                separate_arguments(CMAKE_${lang}_FLAGS_${bt} WINDOWS_COMMAND "${CMAKE_${lang}_FLAGS_${bt}}")
            else()
                separate_arguments(CMAKE_${lang}_FLAGS_${bt})
            endif()
            list(TRANSFORM CMAKE_${lang}_FLAGS_${bt} REPLACE "-O3" "-O2")
            string(REPLACE ";" " " CMAKE_${lang}_FLAGS_${bt} "${CMAKE_${lang}_FLAGS_${bt}}")
            set(CMAKE_${lang}_FLAGS_${bt} "${CMAKE_${lang}_FLAGS_${bt}}" CACHE STRING "Flags used by the ${lang} compiler during ${bt} builds." FORCE)
        endforeach()
    endforeach()
endfunction()

# Introduce ESI's very-own, custom "Noopt" configuration type.
# Which is actually RelWithDebInfo minus the optimizations.
# See also: https://confluence.esi-group.com/x/xghDDw
function(_introduce_noopt)
    set(CMAKE_CONFIGURATION_TYPES "Debug;MinSizeRel;Noopt;Release;RelWithDebInfo" CACHE STRING "List of supported configuration types" FORCE)
    mark_as_advanced(CMAKE_CONFIGURATION_TYPES)

    # foreach(lang C CXX Fortran)
    foreach(lang C)
        set(_${lang}_noopt "${CMAKE_${lang}_FLAGS_RELWITHDEBINFO}")
        if(UNIX)
            separate_arguments(_${lang}_noopt UNIX_COMMAND "${_${lang}_noopt}")
        elseif(WIN32)
            separate_arguments(_${lang}_noopt WINDOWS_COMMAND "${_${lang}_noopt}")
        else()
            separate_arguments(_${lang}_noopt)
        endif()
        list(REMOVE_ITEM _${lang}_noopt -O1 /O1 -O2 /O2 -O3 /O3 /Ob1 /Ob2)
        if(MSVC)
            list(APPEND _${lang}_noopt /Od /Ob0)
            if(lang STREQUAL Fortran)
                list(PREPEND CMAKE_Fortran_FLAGS_NOOPT /Zi)
            endif()
        else()
            list(APPEND _${lang}_noopt -O0)
        endif()
        string(REPLACE ";" " " _${lang}_noopt "${_${lang}_noopt}")
        set(CMAKE_${lang}_FLAGS_NOOPT "${_${lang}_noopt}" CACHE STRING "Flags used by the ${lang} compiler during NOOPT builds" FORCE)
        mark_as_advanced(CMAKE_${lang}_FLAGS_NOOPT)
        unset(_${lang}_noopt)
    endforeach()
    if(NOT CMAKE_EXE_LINKER_FLAGS_NOOPT)
        set(CMAKE_EXE_LINKER_FLAGS_NOOPT "${CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO}" CACHE STRING "Flags used by the linker during NOOPT builds" FORCE)
    endif()
    if(NOT CMAKE_MODULE_LINKER_FLAGS_NOOPT)
        set(CMAKE_MODULE_LINKER_FLAGS_NOOPT "${CMAKE_MODULE_LINKER_FLAGS_RELWITHDEBINFO}" CACHE STRING "Flags used by the linker during the creation of modules during NOOPT builds" FORCE)
    endif()
    if(NOT CMAKE_RC_FLAGS_NOOPT)
        set(CMAKE_RC_FLAGS_NOOPT "${CMAKE_RC_FLAGS_RELWITHDEBINFO}" CACHE STRING "Flags for Windows Resource Compiler during NOOPT builds" FORCE)
    endif()
    if(NOT CMAKE_SHARED_LINKER_FLAGS_NOOPT)
        set(CMAKE_SHARED_LINKER_FLAGS_NOOPT "${CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO}" CACHE STRING "Flags used by the linker during the creation of shared libraries during NOOPT builds" FORCE)
    endif()
    if(NOT CMAKE_STATIC_LINKER_FLAGS_NOOPT)
        set(CMAKE_STATIC_LINKER_FLAGS_NOOPT "${CMAKE_STATIC_LINKER_FLAGS_RELWITHDEBINFO}" CACHE STRING "Flags used by the linker during the creation of static libraries during NOOPT builds" FORCE)
    endif()

    mark_as_advanced(
        CMAKE_EXE_LINKER_FLAGS_NOOPT
        CMAKE_MODULE_LINKER_FLAGS_NOOPT
        CMAKE_RC_FLAGS_NOOPT
        CMAKE_SHARED_LINKER_FLAGS_NOOPT
        CMAKE_STATIC_LINKER_FLAGS_NOOPT
    )
endfunction()

# Avoid overlinking. Link only those symbols that are actually needed
if(LINUX)
    separate_arguments(exe_link_flags UNIX_COMMAND "${CMAKE_EXE_LINKER_FLAGS}")
    list(FIND exe_link_flags "-Wl,--as-needed" _found)
    if(_found EQUAL -1)
        list(PREPEND exe_link_flags "-Wl,--as-needed")
    endif()
    separate_arguments(shared_link_flags UNIX_COMMAND "${CMAKE_SHARED_LINKER_FLAGS}")
    list(FIND shared_link_flags "-Wl,--as-needed" _found)
    if(_found EQUAL -1)
        list(PREPEND shared_link_flags "-Wl,--as-needed")
    endif()
    string(REPLACE ";" " " exe_link_flags "${exe_link_flags}")
    string(REPLACE ";" " " shared_link_flags "${shared_link_flags}")
    set(CMAKE_EXE_LINKER_FLAGS "${exe_link_flags}" CACHE STRING "" FORCE)
    set(CMAKE_SHARED_LINKER_FLAGS "${shared_link_flags}" CACHE STRING "" FORCE)
endif()

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

_protect_and_sanitize()
_compose_handy_generator_expressions()
_introduce_noopt()
_O2_instead_of_O3()
_fix_ndebug()

# disable deprecation warnings for Intel Classic compilers
# when using oneAPI
if(WIN32)
  set(_flag /Q)
else()
  set(_flag -)
endif()
if(CMAKE_C_COMPILER_ID STREQUAL Intel
AND CMAKE_C_COMPILER_VERSION VERSION_GREATER 2021.0)
  set(icc_deprecation_warning_disable ${_flag}diag-disable=10441)
endif()

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
  list(APPEND _gnu_flags -fno-strict-aliasing -Werror -Wall -pedantic -Wno-unused-function -Wno-unused-but-set-variable -Wno-unused-variable -Wno-unknown-pragmas -Wno-unused-label)
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
  "$<${linux_and_nodebug}:_FORTIFY_SOURCE=2>"

  "$<${msvc}:WIN32;MSC;_CRT_SECURE_NO_DEPRECATE;_CRT_SECURE_NO_WARNINGS;$<IF:$<BOOL:HAVE_THREADLOCALSTORAGE>,__thread=__declspec(thread),__thread=>>"
  "$<${unix}:LINUX;_FILE_OFFSET_BITS=64>"
  "$<$<BOOL:${APPLE}>:MACOS>"
  "$<$<BOOL:${OpenMP_FOUND}>:ENABLE_OPENMP>"
  "$<$<BOOL:${CYGWIN}>:CYGWIN>"

  "$<$<NOT:$<BOOL:${ASSERT}>>:NDEBUG>"
  "$<$<NOT:$<BOOL:${ASSERT2}>>:NDEBUG2>"
  "$<${debug}:DEBUG>"

  "$<$<BOOL:${PCRE}>:__WITHPCRE__>"
  "$<$<OR:$<BOOL:${GKREGEX}>,$<BOOL:${MINGW}>,$<BOOL:${MSVC}>>:USE_GKREGEX>"
  "$<$<BOOL:${GKRAND}>:USE_GKRAND>"

  "$<$<BOOL:${HAVE_SYS_RESOURCE_H}>:HAVE_SYS_RESOURCE_H>"
  "$<$<BOOL:${HAVE_EXECINFO_H}>:HAVE_EXECINFO_H>"
  "$<$<BOOL:${HAVE_GETLINE}>:HAVE_GETLINE>"
)
add_compile_options(
  "${stack_protect}"
  "$<${msvc}:$<${asan}:/fsanitize=address>>"
  "$<${fuzzer}:/fsanitize=fuzzer>"
  "$<${nomsvc}:$<${asan_and_debug}:-fsanitize=address>>"
  "$<${nomsvc}:$<${asan_and_nodebug}:-O1;-fsanitize=address;-fno-omit-frame-pointer;-fno-optimize-sibling-calls>>"
  "$<${tsan}:-fsanitize=thread>"
  "$<${lsan}:-fsanitize=leak>"
  "${icc_deprecation_warning_disable}"
  "$<$<AND:$<C_COMPILER_ID:MSVC>,$<NOT:$<CONFIG:Debug>>>:/Ox>"
  "$<${gnu}:${_gnu_flags}>"
  "$<${intel}:$<IF:${win},/QxHost,-xHost>>"
  "${deal_with_corrupt_pdb}"
)
add_link_options(
  "$<${nomsvc}:$<${asan}:-fsanitize=address>>"
  "$<${tsan}:-fsanitize=thread>"
  "$<${lsan}:-fsanitize=leak>"
  "$<${unix}:${icc_deprecation_warning_disable}>"
)
if(WITH_ASAN_POINTER_COMPARE)
    add_compile_options(-fsanitize=pointer-compare)
    add_link_options(-fsanitize=pointer-compare)
endif()
if(WITH_ASAN_POINTER_SUBTRACT)
    add_compile_options(-fsanitize=pointer-subtract)
    add_link_options(-fsanitize=pointer-subtract)
endif()
