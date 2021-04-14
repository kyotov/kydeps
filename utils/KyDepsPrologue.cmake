include_guard(GLOBAL)

#
# ensure CMAKE_BUILD_TYPE is specified -- we don't support multi-config build yet!
#
if ("${CMAKE_BUILD_TYPE}" STREQUAL "")
    message(FATAL_ERROR "CMAKE_BUILD_TYPE not defined")
else ()
    message(NOTICE "Using CMAKE_BUILD_TYPE = ${CMAKE_BUILD_TYPE}")
endif ()
