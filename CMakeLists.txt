cmake_minimum_required(VERSION 3.15)

get_property(gen_is_multiconfig GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)

project(METIS LANGUAGES C)

if(CMAKE_SYSTEM_NAME MATCHES Linux)
    set(LINUX TRUE)
endif()

# GEL PATCH: vanilla metis clearly requires C99 though it never
# admits it
set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_STANDARD_EXTENSIONS OFF)

# GEL PATCH: vanilla metis cannot be built as native DLL on Windows
# (with any compiler other than MINGW) because no symbols are
# DLL-exported. The following variable fixes this for function symbols.
# Global data symbols must be handled separately with an appropriate
# export header (dllexport/dllimport) which is introduced.
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)

# GEL PATCH: intel classic compilers in recent oneAPI versions issue
# deprecation warnings which pollute the build log. The following
# compile options will silence them.
function(_disable_deprecation_warnings_for_intel_classic)
    set(_C_val       10441)
    if(WIN32)
        set(_s /Q)
    else()
        set(_s -)
    endif()
    foreach(lang C)
        if(CMAKE_${lang}_COMPILER_ID STREQUAL Intel
        AND CMAKE_${lang}_COMPILER_VERSION VERSION_GREATER 2021.0)
            set(_flag ${_s}diag-disable=${_${lang}_val})
            if(UNIX)
                separate_arguments(CMAKE_${lang}_FLAGS UNIX_COMMAND "${CMAKE_${lang}_FLAGS}")
            elseif(WIN32)
                separate_arguments(CMAKE_${lang}_FLAGS WINDOWS_COMMAND "${CMAKE_${lang}_FLAGS}")
            else()
                separate_arguments(CMAKE_${lang}_FLAGS)
            endif()
            list(FIND CMAKE_${lang}_FLAGS "${_flag}" _found)
            if(_found EQUAL -1)
                list(PREPEND CMAKE_${lang}_FLAGS "${_flag}")
            endif()
            string(REPLACE ";" " " CMAKE_${lang}_FLAGS "${CMAKE_${lang}_FLAGS}")
            set(CMAKE_${lang}_FLAGS "${CMAKE_${lang}_FLAGS}" CACHE STRING "Flags used by the ${lang} compiler" FORCE)
        endif()
    endforeach()
endfunction()

# Clear erroneous -DNDEBUG polluting the Intel compiler flags
# on Windows (it's /DNDEBUG instead, which is already present)
function(_fix_ndebug)
    if(MSVC AND CMAKE_C_COMPILER_ID STREQUAL Intel)
        foreach(lang C)
            foreach(bt RELEASE MINSIZEREL RELWITHDEBINFO)
                if(UNIX)
                    separate_arguments(CMAKE_${lang}_FLAGS_${bt} UNIX_COMMAND "${CMAKE_${lang}_FLAGS_${bt}}")
                elseif(WIN32)
                    separate_arguments(CMAKE_${lang}_FLAGS_${bt} WINDOWS_COMMAND "${CMAKE_${lang}_FLAGS_${bt}}")
                else()
                    separate_arguments(CMAKE_${lang}_FLAGS_${bt})
                endif()
                list(REMOVE_ITEM CMAKE_${lang}_FLAGS_${bt} -DNDEBUG)
                string(REPLACE ";" " " CMAKE_${lang}_FLAGS_${bt} "${CMAKE_${lang}_FLAGS_${bt}}")
                set(CMAKE_${lang}_FLAGS_${bt} "${CMAKE_${lang}_FLAGS_${bt}}" CACHE STRING "Flags used by the ${lang} compiler during ${bt} builds" FORCE)
            endforeach()
        endforeach()
    endif()
endfunction()

# drop the optimization level from 3 to 2 replacing the -O3 optimization
# flag with -O2 for Release & RelWithDebInfo configs
function(_O2_instead_of_O3)
    foreach(lang C Fortran)
        foreach(bt RELEASE RELWITHDEBINFO MINSIZEREL)
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
    set(noasan $<NOT:$<BOOL:${WITH_ASAN}>>)
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
    set(linux_and_nodebug_and_noasan $<AND:${linux},${nodebug},${noasan}>)
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

_protect_and_sanitize()
_compose_handy_generator_expressions()
_disable_deprecation_warnings_for_intel_classic()
_fix_ndebug()
_O2_instead_of_O3()

include(${CMAKE_SOURCE_DIR}/GKlib/GKlibSystem.cmake)

# Add include directories.
include_directories(${CMAKE_SOURCE_DIR}/GKlib)

add_subdirectory(GKlib)
add_subdirectory(libmetis)
add_subdirectory(programs)

configure_file(${CMAKE_SOURCE_DIR}/metis_sanitizers.cmake.in
    ${CMAKE_BINARY_DIR}/metis_sanitizers.cmake
)
install(FILES ${CMAKE_BINARY_DIR}/metis_sanitizers.cmake DESTINATION lib/cmake)
