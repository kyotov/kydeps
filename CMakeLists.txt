cmake_minimum_required(VERSION 3.18)
project(kydeps_bootstrap)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/utils)
list(APPEND CMAKE_MESSAGE_INDENT "  KyDepsPackage: ")

include(FetchContent)
include(KyDepsTools)

check_not_empty(KYDEPS)

get_package_name(${CMAKE_SOURCE_DIR} "${KYDEPS}" PACKAGE_NAME)
file(WRITE ${CMAKE_BINARY_DIR}/package_name.current ${PACKAGE_NAME})

add_custom_command(
        OUTPUT package_name.target
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${CMAKE_BINARY_DIR}/package_name.current
        ${CMAKE_BINARY_DIR}/package_name.target)

add_custom_command(
        OUTPUT package_generate.target
        COMMAND ${CMAKE_COMMAND}
        -S ${CMAKE_SOURCE_DIR}/deps
        -B ${CMAKE_BINARY_DIR}/deps
        -G ${CMAKE_GENERATOR}
        "-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
        "-DKYDEPS=${KYDEPS}"

        COMMAND ${CMAKE_COMMAND} -E touch ${CMAKE_BINARY_DIR}/package_generate_build.target.target
        USES_TERMINAL
        DEPENDS package_name.target)

add_custom_command(
        OUTPUT package_build.target ${PACKAGE_NAME}.zip
        COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR}/deps --target package
        COMMAND ${CMAKE_COMMAND} -E echo_append ">>>>> SHA256 "
        COMMAND ${CMAKE_COMMAND} -E sha256sum ${CMAKE_BINARY_DIR}/deps/${PACKAGE_NAME}.zip
        COMMAND ${CMAKE_COMMAND} -E touch ${CMAKE_BINARY_DIR}/package_execute_build.target
        USES_TERMINAL
        DEPENDS package_generate.target)

add_custom_target(package ALL
        ${CMAKE_COMMAND} -E true
        DEPENDS package_build.target)

list(POP_BACK CMAKE_MESSAGE_INDENT)
