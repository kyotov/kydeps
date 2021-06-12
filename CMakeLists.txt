cmake_minimum_required(VERSION 3.18)
project(kydeps)

list(APPEND CMAKE_MESSAGE_INDENT "  KyDeps : ")
list(APPEND CMAKE_MODULE_PATH
        ${CMAKE_SOURCE_DIR}/utils
        ${CMAKE_SOURCE_DIR}/deps)

include(KyDepsTools)
include(KyDepsOptions)
include(KyDepsEpilogue)

file(GLOB_RECURSE PACKAGES RELATIVE ${CMAKE_SOURCE_DIR}/deps ${CMAKE_SOURCE_DIR}/deps/**)
list(TRANSFORM PACKAGES REPLACE "\\.cmake$" "")

#set(PACKAGES "google/flags")
set(KYDEPS_PACKAGE_CACHE_DIRECTORY "c:/kamen/kydeps_cache")
set(KYDEPS_PACKAGE_CACHE_FROZEN TRUE)

set_if_empty(KYDEPS_UPLOAD OFF)
set_if_empty(KYDEPS_RELAX_PACKAGE_HASH ON)
set_if_empty(KYDEPS_URL_PREFIX_DEFAULT "https://kydeps.s3.us-east-2.amazonaws.com")
set_if_empty(KYDEPS_S3_PREFIX_DEFAULT "s3://kydeps")
set_if_empty(KYDEPS_PACKAGE_CACHE_DIRECTORY "${CMAKE_BINARY_DIR}/content_cache")
set_if_empty(KYDEPS_PACKAGE_CACHE_FROZEN FALSE)
set_if_empty(KYDEPS_PACKAGES "${PACKAGES}")

foreach (PACKAGE ${KYDEPS_PACKAGES})
    include(${PACKAGE})
endforeach ()

dump_config()

set(COMPLETE)
foreach (PACKAGE_NAME ${PACKAGE_NAMES})
    list(APPEND COMPLETE "${${PACKAGE_NAME}_ROOT_PATH}/complete")
endforeach ()

add_custom_target(complete ALL
        COMMAND ${CMAKE_COMMAND} -D "CONFIG=${CMAKE_BINARY_DIR}/_/config.cmake" -P "${CMAKE_SOURCE_DIR}/utils/KyDepsGenerateInstall.cmake"
        DEPENDS ${COMPLETE})

list(POP_BACK CMAKE_MESSAGE_INDENT)
