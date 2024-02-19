include(${CMAKE_CURRENT_SOURCE_DIR}/GKlibSystem.cmake)

add_library(GKlib_i32 STATIC ${GKlib_sources} ${GKlib_includes})
target_compile_definitions(GKlib_i32 PUBLIC IDXTYPEWIDTH=32)
target_include_directories(GKlib_i32 PUBLIC
  $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/GKlib>
)
add_library(GKlib_i64 STATIC ${GKlib_sources} ${GKlib_includes})
target_compile_definitions(GKlib_i64 PUBLIC IDXTYPEWIDTH=64)
target_include_directories(GKlib_i64 PUBLIC
  $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/GKlib>
)
target_link_libraries(GKlib_i32 "$<$<BOOL:${UNIX}>:m>")
target_link_libraries(GKlib_i64 "$<$<BOOL:${UNIX}>:m>")

if(BUILD_SHARED_LIBS)
  set_target_properties(GKlib_i32 GKlib_i64
    PROPERTIES POSITION_INDEPENDENT_CODE ON
  )
else()
  install(TARGETS GKlib_i32 GKlib_i64
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
    ARCHIVE DESTINATION lib
  )
endif()

add_subdirectory(test)
