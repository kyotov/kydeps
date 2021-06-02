cmake_minimum_required(VERSION 3.18)
project(kydeps)

list(APPEND CMAKE_MESSAGE_INDENT "  KyDeps : ")
list(APPEND CMAKE_MODULE_PATH
        ${CMAKE_SOURCE_DIR}/utils
        ${CMAKE_SOURCE_DIR}/deps)

include(KyDepsTools)
include(KyDepsOptions)
include(KyDepsEpilogue)

set_if_empty(KYDEPS_UPLOAD OFF)
set_if_empty(KYDEPS_DOWNLOAD OFF)
set_if_empty(KYDEPS_SHOW_MANIFEST OFF)
set_if_empty(KYDEPS_URL_PREFIX_DEFAULT "https://kydeps.s3.us-east-2.amazonaws.com")
set_if_empty(KYDEPS_S3_PREFIX_DEFAULT "s3://kydeps")
set_if_empty(KYDEPS_PACKAGES "google/flags;google/log;google/test;google/protobuf;fmt")

if (KYDEPS_DOWNLOAD)
    if (KYDEPS_UPLOAD)
        message(FATAL_ERROR "KYDEPS_DOWNLOAD and KYDEPS_UPLOAD should not both be ON")
    endif ()
    include(fingerprints.cmake)
endif ()

foreach (PACKAGE ${KYDEPS_PACKAGES})
    include(${PACKAGE})
endforeach ()

add_custom_target(packages ALL DEPENDS ${PACKAGE_PATHS})

if (KYDEPS_UPLOAD)
    add_fingerprints_target()
endif ()

list(POP_BACK CMAKE_MESSAGE_INDENT)
