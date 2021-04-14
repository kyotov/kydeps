include_guard(GLOBAL)

set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")

#
# ensure whole program optimization is enabled in release mode
#
# NOTE: currently only covers MSVC
# TODO: add other compilers (gcc, clang)
#
if ("${CMAKE_BUILD_TYPE}" STREQUAL "Release")
    if (MSVC)
        add_compile_options("-GL")
        add_link_options("-LTCG")
    endif ()
endif ()
