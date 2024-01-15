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

# Link with the required libraries
foreach(isize _i32 _i64)
  foreach(prog gpmetis ndmetis mpmetis m2gmetis graphchk cmpfillin)
    target_link_libraries(${prog}${isize} metis${isize} GKlib "$<$<BOOL:${UNIX}>:m>")
    list(APPEND all_exe ${prog}${isize})
  endforeach()
endforeach()

install(
    TARGETS ${all_exe}
    RUNTIME DESTINATION bin
)
