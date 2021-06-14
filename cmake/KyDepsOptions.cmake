include_guard(GLOBAL)

set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")

#
# ensure whole program optimization is enabled in release mode
#
# NOTE: currently only covers MSVC
# TODO: add other compilers (gcc, clang)
#
if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    add_compile_options(-nologo)
    add_link_options(-nologo)
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    #add_link_options(-static-libgcc -static-libstdc++ -static)
    #add_link_options(-static)
endif ()

if ("${CMAKE_BUILD_TYPE}" STREQUAL "Release")
    if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
        # consider -Ob3
#        add_compile_options(-MT -GL)
        add_compile_options(-MT)
#        add_link_options(-LTCG -ignore:4099)
        add_link_options(-ignore:4099)
    elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
#        add_compile_options(-flto)
    endif ()
elseif ("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
    if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
        add_compile_options(-MTd)
        add_link_options(-ignore:4099)
    endif ()
endif ()
