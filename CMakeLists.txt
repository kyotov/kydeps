cmake_minimum_required(VERSION 3.18)
project(kydeps)

list(APPEND CMAKE_MESSAGE_INDENT "  KyDeps : ")
list(APPEND CMAKE_MODULE_PATH
        ${CMAKE_SOURCE_DIR}/cmake
        ${CMAKE_SOURCE_DIR}/definitions)

include(KyDepsTools)
include(KyDepsOptions)

set_if_empty(KYDEPS_UPLOAD OFF)
set_if_empty(KYDEPS_URL_PREFIX "https://kydeps.s3.us-east-2.amazonaws.com")
set_if_empty(KYDEPS_S3_PREFIX "s3://kydeps")

set_if_empty(KYDEPS_PACKAGE_CACHE_DIRECTORY "${CMAKE_SOURCE_DIR}/cache")
set_if_empty(KYDEPS_PACKAGE_CACHE_FROZEN FALSE)

set_if_empty(KYDEPS_USES_TERMINAL FALSE)

file(GLOB_RECURSE KYDEPS_PACKAGES RELATIVE ${CMAKE_SOURCE_DIR}/definitions ${CMAKE_SOURCE_DIR}/definitions/**)
list(TRANSFORM KYDEPS_PACKAGES REPLACE "\\.cmake$" "")

set_if_empty(KYDEPS_RELAX_PACKAGE_HASH ON)

foreach (PACKAGE ${KYDEPS_PACKAGES})
    include(${PACKAGE})
endforeach ()

list(POP_BACK CMAKE_MESSAGE_INDENT)

enable_testing()

add_test(NAME tests
        COMMAND ${CMAKE_COMMAND}
        -D "BINARY_DIR=${CMAKE_BINARY_DIR}/tests/hello_world"
        -D CMAKE_BUILD_TYPE=Debug
        -P "${CMAKE_SOURCE_DIR}/tests/hello_world/run_test.cmake")
