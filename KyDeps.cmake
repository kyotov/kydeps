include_guard(GLOBAL)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/utils)

include(KyDepsTools)
include(KyDepsOptions)

set(KYDEPS_URL_PREFIX_DEFAULT "https://kydeps.s3.us-east-2.amazonaws.com")
set(KYDEPS_S3_PREFIX_DEFAULT "s3://kydeps")

set_if_empty(CMAKE_BUILD_TYPE Debug)

function(KyDeps)
    list(APPEND CMAKE_MESSAGE_INDENT "  KyDeps: ")

    set(options CACHED UPLOAD)
    set(one_value_args URL_PREFIX)
    set(multi_value_args DEPENDS)
    cmake_parse_arguments(KYDEPS "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})

    check_not_empty(KYDEPS_DEPENDS)

    get_package_name("${CMAKE_CURRENT_FUNCTION_LIST_DIR}" "${KYDEPS_DEPENDS}" PACKAGE_NAME)

    set(EXPECTED_SHA256_PATH ${CMAKE_SOURCE_DIR}/kydeps_sha256_${CMAKE_SYSTEM_NAME}_${CMAKE_BUILD_TYPE}.cmake)

    if (KYDEPS_CACHED)
        set_if_empty(KYDEPS_URL_PREFIX ${KYDEPS_URL_PREFIX_DEFAULT})
        check_not_empty(KYDEPS_EXPECTED_SHA256)

        set(PACKAGE_URL "${KYDEPS_URL_PREFIX}/${PACKAGE_NAME}.zip")
        set(PACKAGE_PATH "${CMAKE_BINARY_DIR}/${PACKAGE_NAME}.zip")

        include(${EXPECTED_SHA256_PATH})

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
                "-DKYDEPS=${KYDEPS_DEPENDS}"
                RESULT_VARIABLE RESULT)
        check_result(${RESULT} "unable to configure")
        execute_process(COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR}/kydeps
                RESULT_VARIABLE RESULT)
        check_result(${RESULT} "unable to build")

        set(CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/kydeps/deps/install")

        set(PACKAGE_PATH "${CMAKE_BINARY_DIR}/kydeps/deps/${PACKAGE_NAME}.zip")
        set(PACKAGE_URL "${KYDEPS_S3_PREFIX_DEFAULT}/${PACKAGE_NAME}.zip")

        if (KYDEPS_UPLOAD)
            execute_process(COMMAND aws s3 cp ${PACKAGE_PATH} ${PACKAGE_URL}
                    RESULT_VARIABLE RESULT)
            check_result(${RESULT} "unable to upload")

            file(SHA256 "${PACKAGE_PATH}" KYDEPS_ACTUAL_SHA256)
            file(CONFIGURE OUTPUT ${CMAKE_SOURCE_DIR}/kydeps_sha256_${CMAKE_SYSTEM_NAME}_${CMAKE_BUILD_TYPE}.cmake
                    CONTENT "set(KYDEPS_EXPECTED_SHA256 ${KYDEPS_ACTUAL_SHA256})")
        endif ()
    endif ()

    set(httplib_FIND_PACKAGE_OPTIONS PATHS ${CMAKE_PREFIX_PATH}/CMake/httplib)

    message(STATUS "finding ...")
    foreach (DEP ${KYDEPS_DEPENDS})
        message(STATUS "  ${DEP}")
        find_package(${DEP} REQUIRED NO_MODULE ${${DEP}_FIND_PACKAGE_OPTIONS})
    endforeach ()

    set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} PARENT_SCOPE)

    list(POP_BACK CMAKE_MESSAGE_INDENT)
endfunction()
