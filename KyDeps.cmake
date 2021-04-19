include_guard(GLOBAL)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/utils)

include(KyDepsTools)
include(KyDepsOptions)

set_if_empty(CMAKE_BUILD_TYPE Debug)

function(KyDeps)
    list(APPEND CMAKE_MESSAGE_INDENT "  KyDeps: ")

    set(options CACHED)
    set(one_value_args URL_PREFIX EXPECTED_SHA256)
    set(multi_value_args DEPENDS)
    cmake_parse_arguments(KYDEPS "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})

    check_not_empty(KYDEPS_DEPENDS)

    if (KYDEPS_CACHED)
        set_if_empty(KYDEPS_URL_PREFIX "https://kydeps.s3.us-east-2.amazonaws.com")
        check_not_empty(KYDEPS_EXPECTED_SHA256)

        get_package_name("${CMAKE_CURRENT_FUNCTION_LIST_DIR}" "${KYDEPS_DEPENDS}" PACKAGE_NAME)
        set(PACKAGE_URL "${KYDEPS_URL_PREFIX}/${PACKAGE_NAME}.zip")
        set(PACKAGE_PATH "${CMAKE_BINARY_DIR}/${PACKAGE_NAME}.zip")

        if (NOT EXISTS ${PACKAGE_PATH})
            message(STATUS "downloading ${PACKAGE_URL} ...")
            file(DOWNLOAD "${PACKAGE_URL}" "${PACKAGE_PATH}" EXPECTED_HASH SHA256=${KYDEPS_EXPECTED_SHA256})
            message(STATUS "  done!")
        else ()
            message(STATUS "found ${PACKAGE_PATH} ...")
            file(SHA256 "${PACKAGE_PATH}" KYDEPS_ACTUAL_SHA256)
            if (NOT "${KYDEPS_ACTUAL_SHA256}" STREQUAL "${KYDEPS_EXPECTED_SHA256}")
                message(FATAL_ERROR "SHA256 mismatch, expected ${KYDEPS_EXPECTED_SHA256}, found ${KYDEPS_ACTUAL_SHA256}")
            endif ()
        endif ()

        if (NOT EXISTS "${CMAKE_BINARY_DIR}/${PACKAGE_NAME}")
            message(STATUS "extracting ${PACKAGE_PATH} ...")
            execute_process(COMMAND ${CMAKE_COMMAND} -E tar x "${PACKAGE_PATH}")
            message(STATUS "  done!")
        else ()
            message(STATUS "found ${CMAKE_BINARY_DIR}/${PACKAGE_NAME} ...")
        endif ()

        set(CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/${PACKAGE_NAME}/install")
    else () # NOT CACHED
        execute_process(
                COMMAND
                ${CMAKE_COMMAND}
                -S ${CMAKE_CURRENT_FUNCTION_LIST_DIR}
                -B ${CMAKE_BINARY_DIR}/kydeps
                -G ${CMAKE_GENERATOR}
                "-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
                "-DKYDEPS=${KYDEPS_DEPENDS}")
        execute_process(COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR}/kydeps)

        set(CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/kydeps/deps/install")
    endif ()

    message(STATUS "finding ...")
    foreach (DEP ${KYDEPS_DEPENDS})
        message(STATUS "  ${DEP}")
        find_package(${DEP} REQUIRED NO_MODULE)
    endforeach ()

    set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} PARENT_SCOPE)

    list(POP_BACK CMAKE_MESSAGE_INDENT)
endfunction()
