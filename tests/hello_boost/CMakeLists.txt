cmake_minimum_required(VERSION 3.18)
project(kydeps)

# TODO: this should be automatic!?
set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")

include(../../install/KyDeps.cmake)

#set(FETCHCONTENT_QUIET ON)

set(Boost_USE_STATIC_RUNTIME ON)
include(boost)

#set(Boost_DEBUG ON)
#find_package(Boost 1.70 REQUIRED COMPONENTS regex)

add_executable(main
        main.cpp)
target_link_libraries(main
        PRIVATE Boost::regex)

add_custom_target(run
        COMMAND main)
