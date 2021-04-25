cmake_minimum_required(VERSION 3.18)
project(kydeps_bootstrap)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/utils)
list(APPEND CMAKE_MESSAGE_INDENT "  KyDepsPackage: ")

include(FetchContent)
include(KyDepsTools)

check_not_empty(KYDEPS)

# FIXME: the hash in this is not correct if there are changed files in the repo
get_package_name(${CMAKE_SOURCE_DIR} "${KYDEPS}" PACKAGE_NAME)
file(WRITE ${CMAKE_BINARY_DIR}/package_name.current ${PACKAGE_NAME})

# FIXME: this should be done with implicit dependencies...
file(GLOB_RECURSE FILES ${CMAKE_SOURCE_DIR}/*.*)

add_custom_command(
        OUTPUT ${CMAKE_BINARY_DIR}/deps/${PACKAGE_NAME}.zip

        COMMAND ${CMAKE_COMMAND}
        -S ${CMAKE_SOURCE_DIR}/deps
        -B ${CMAKE_BINARY_DIR}/deps
        -G ${CMAKE_GENERATOR}
        "-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
        "-DKYDEPS=${KYDEPS}"

        COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR}/deps --target package

        COMMAND ${CMAKE_COMMAND} -E sha256sum ${CMAKE_BINARY_DIR}/deps/${PACKAGE_NAME}.zip

        VERBATIM
        USES_TERMINAL
        DEPENDS ${FILES})

add_custom_target(package ALL
        ${CMAKE_COMMAND} -E true
        DEPENDS ${CMAKE_BINARY_DIR}/deps/${PACKAGE_NAME}.zip)

list(POP_BACK CMAKE_MESSAGE_INDENT)
