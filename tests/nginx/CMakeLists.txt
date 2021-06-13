cmake_minimum_required(VERSION 3.18)
project(kydeps)

set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")

include(../../install/KyDeps.cmake)

#set(FETCHCONTENT_QUIET ON)

include(nginx)
include(llvm)

message(STATUS ${NGINX})
message(STATUS ${CLANG_TIDY})