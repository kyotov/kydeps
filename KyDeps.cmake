include_guard(GLOBAL)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/utils)

include(KyDepsTools)
include(KyDepsOptions)

set(KYDEPS_URL_PREFIX_DEFAULT "https://kydeps.s3.us-east-2.amazonaws.com")
set(KYDEPS_S3_PREFIX_DEFAULT "s3://kydeps")

set_if_empty(CMAKE_BUILD_TYPE Debug)

function(download_package)
    set(PACKAGE_URL "${KYDEPS_URL_PREFIX_DEFAULT}/${PACKAGE_NAME}.zip")
    set(PACKAGE_PATH "${CMAKE_BINARY_DIR}/${PACKAGE_NAME}.zip")

    set(DOWNLOAD FALSE)
    if (EXISTS ${PACKAGE_PATH})
        file(SIZE ${PACKAGE_PATH} PACKAGE_SIZE)
        if ("${PACKAGE_SIZE}" EQUAL "0")
            set(DOWNLOAD TRUE)
        endif ()
    else ()
        set(DOWNLOAD TRUE)
    endif ()

    if (DOWNLOAD)
        message(STATUS "downloading ${PACKAGE_URL} ...")
        file(DOWNLOAD "${PACKAGE_URL}" "${PACKAGE_PATH}")
    endif ()

    file(SIZE ${PACKAGE_PATH} PACKAGE_SIZE)
    if ("${PACKAGE_SIZE}" EQUAL "0")
        message(FATAL_ERROR "cached package not found")
    endif ()

    file(SHA256 "${PACKAGE_PATH}" KYDEPS_ACTUAL_SHA256)
    include(${EXPECTED_SHA256_PATH})
    if (NOT "${KYDEPS_ACTUAL_SHA256}" STREQUAL "${KYDEPS_EXPECTED_SHA256}")
        message(FATAL_ERROR "cached package SHA256 mismatch, expected ${KYDEPS_EXPECTED_SHA256}, found ${KYDEPS_ACTUAL_SHA256}")
    endif ()

    if (NOT EXISTS "${CMAKE_BINARY_DIR}/${PACKAGE_NAME}")
        message(STATUS "extracting ${PACKAGE_PATH} ...")
        execute_process(COMMAND ${CMAKE_COMMAND} -E tar x "${PACKAGE_PATH}")
        message(STATUS "  done!")
    else ()
        message(STATUS "found ${CMAKE_BINARY_DIR}/${PACKAGE_NAME} ...")
    endif ()

    set(CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/${PACKAGE_NAME}/install" PARENT_SCOPE)
endfunction()

function(build_package)
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

    set(CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/kydeps/deps/install" PARENT_SCOPE)
endfunction()

function(upload_package)
    set(PACKAGE_PATH "${CMAKE_BINARY_DIR}/kydeps/deps/${PACKAGE_NAME}.zip")
    set(PACKAGE_URL "${KYDEPS_S3_PREFIX_DEFAULT}/${PACKAGE_NAME}.zip")

    execute_process(COMMAND aws s3 cp ${PACKAGE_PATH} ${PACKAGE_URL}
            RESULT_VARIABLE RESULT)
    check_result(${RESULT} "unable to upload")

    file(SHA256 "${PACKAGE_PATH}" KYDEPS_ACTUAL_SHA256)
    file(CONFIGURE OUTPUT ${CMAKE_SOURCE_DIR}/kydeps_sha256_${CMAKE_SYSTEM_NAME}_${CMAKE_BUILD_TYPE}.cmake
            CONTENT "set(KYDEPS_EXPECTED_SHA256 ${KYDEPS_ACTUAL_SHA256})")
endfunction()

function(KyDeps)
    list(APPEND CMAKE_MESSAGE_INDENT "  KyDeps: ")

    set(options DOWNLOAD UPLOAD)
    set(one_value_args)
    set(multi_value_args DEPENDS)
    cmake_parse_arguments(KYDEPS "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})

    check_not_empty(KYDEPS_DEPENDS)

    get_package_name("${CMAKE_CURRENT_FUNCTION_LIST_DIR}" "${KYDEPS_DEPENDS}" PACKAGE_NAME)

    set(EXPECTED_SHA256_PATH ${CMAKE_SOURCE_DIR}/kydeps_sha256_${CMAKE_SYSTEM_NAME}_${CMAKE_BUILD_TYPE}.cmake)

    if (KYDEPS_DOWNLOAD)
        download_package()
    else ()
        build_package()
        if (KYDEPS_UPLOAD)
            upload_package()
        endif ()
    endif ()

    foreach (DEP ${KYDEPS_DEPENDS})
        message(STATUS "  ${DEP}")
        find_package(${DEP} REQUIRED NO_MODULE ${${DEP}_FIND_PACKAGE_OPTIONS})
    endforeach ()

    set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} PARENT_SCOPE)

    list(POP_BACK CMAKE_MESSAGE_INDENT)
endfunction()
