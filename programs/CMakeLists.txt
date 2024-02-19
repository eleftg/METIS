# These programs use internal metis data structures.
include_directories(${CMAKE_SOURCE_DIR}/libmetis)

# Build program.
foreach(isize _i32 _i64)
  add_executable(gpmetis${isize} gpmetis.c cmdline_gpmetis.c io.c stat.c)
  add_executable(ndmetis${isize} ndmetis.c cmdline_ndmetis.c io.c smbfactor.c)
  add_executable(mpmetis${isize} mpmetis.c cmdline_mpmetis.c io.c stat.c)
  add_executable(m2gmetis${isize} m2gmetis.c cmdline_m2gmetis.c io.c)
  add_executable(graphchk${isize} graphchk.c io.c)
  add_executable(cmpfillin${isize} cmpfillin.c io.c smbfactor.c)
endforeach()

foreach(isize _i32 _i64)
  foreach(prog gpmetis ndmetis mpmetis m2gmetis graphchk cmpfillin)
    target_link_libraries(${prog}${isize} metis${isize} GKlib${isize})
    list(APPEND all_exe ${prog}${isize})
endforeach()
endforeach()

install(TARGETS ${all_exe}
    RUNTIME DESTINATION bin
)
# Try to find subversion revision.
set(SVNREV "")
file(TO_NATIVE_PATH ${PROJECT_SOURCE_DIR}/.svn svn_dir)
if(IS_DIRECTORY ${svn_dir})
  include(FindSubversion)
  if(Subversion_FOUND)
    Subversion_WC_INFO(${PROJECT_SOURCE_DIR} metis)
    set(SVNREV ${metis_WC_REVISION})
  endif(Subversion_FOUND)
endif()
add_compile_definitions(SVNINFO="${SVNREV}")
