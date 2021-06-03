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

set_if_empty(KYDEPS_UPLOAD OFF)
set_if_empty(KYDEPS_DOWNLOAD OFF)
set_if_empty(KYDEPS_SHOW_MANIFEST OFF)
set_if_empty(KYDEPS_DEEP_CLEAN OFF)
set_if_empty(KYDEPS_URL_PREFIX_DEFAULT "https://kydeps.s3.us-east-2.amazonaws.com")
set_if_empty(KYDEPS_S3_PREFIX_DEFAULT "s3://kydeps")
set_if_empty(KYDEPS_PACKAGES "${PACKAGES}")

if (KYDEPS_DOWNLOAD)
    if (KYDEPS_UPLOAD)
        message(FATAL_ERROR "KYDEPS_DOWNLOAD and KYDEPS_UPLOAD should not both be ON")
    endif ()
    include(fingerprints.cmake)
endif ()

foreach (PACKAGE ${KYDEPS_PACKAGES})
    include(${PACKAGE})
endforeach ()

add_targets()

list(POP_BACK CMAKE_MESSAGE_INDENT)
