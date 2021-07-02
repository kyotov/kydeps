cmake_minimum_required(VERSION 3.18)
project(kydeps)

include(../../install/KyDeps.cmake)

#set(FETCHCONTENT_QUIET ON)

include(Boost)

add_executable(main
        main.cpp)
target_link_libraries(main
        PRIVATE Boost::regex)

add_custom_target(run
        COMMAND main)
