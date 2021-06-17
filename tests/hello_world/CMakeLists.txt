cmake_minimum_required(VERSION 3.18)
project(kydeps)

set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")

include(../../install/KyDeps.cmake)

#set(FETCHCONTENT_QUIET ON)

include(gflags)
include(glog)

add_executable(main
        main.cpp)
target_link_libraries(main
        PRIVATE gflags
        PRIVATE glog::glog)

add_custom_target(run
        COMMAND main)
