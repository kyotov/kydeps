cmake_minimum_required(VERSION 3.18)
project(kydeps)

set(KYDEPS_URL_PREFIX_DEFAULT "https://kydeps.s3.us-east-2.amazonaws.com")
set(KYDEPS_S3_PREFIX_DEFAULT "s3://kydeps")

set(KYDEPS_SHOW_MANIFEST OFF)

if ("${KYDEPS_PACKAGES}" STREQUAL "")
    set(KYDEPS_PACKAGES gflags glog)
endif ()

list(APPEND CMAKE_MESSAGE_INDENT "  KyDeps : ")

list(APPEND CMAKE_MODULE_PATH
        ${CMAKE_CURRENT_LIST_DIR}/utils
        ${CMAKE_CURRENT_LIST_DIR}/deps)

include(FetchContent)
include(KyDepsTools)
include(KyDepsOptions)
include(KyDepsEpilogue)

set_if_empty(KYDEPS_UPLOAD OFF)
set_if_empty(KYDEPS_DOWNLOAD OFF)

get_flavor(FLAVOR)
message(STATUS "FLAVOR : ${FLAVOR}")

if (KYDEPS_DOWNLOAD)
    include(fingerprints.cmake)
endif ()

foreach (PACKAGE ${KYDEPS_PACKAGES})
    include(${PACKAGE})
endforeach ()

get_flavor(FLAVOR)
set(FINGERPRINTS "${CMAKE_SOURCE_DIR}/fingerprints.cmake")

if (NOT KYDEPS_DOWNLOAD)
    foreach (PACKAGE_PATH ${PACKAGE_PATHS})
        get_filename_component(KEY ${PACKAGE_PATH} NAME_WE)
        list(APPEND COMMANDS
                COMMAND ${CMAKE_COMMAND} -E echo "set(${KEY}_sha1sum" >> ${FINGERPRINTS}
                COMMAND ${CMAKE_COMMAND} -E echo_append "  " >> ${FINGERPRINTS}
                COMMAND ${CMAKE_COMMAND} -E sha1sum package/${KEY}.zip >> ${FINGERPRINTS}
                COMMAND ${CMAKE_COMMAND} -E echo "  ${FLAVOR})" >> ${FINGERPRINTS})
    endforeach ()
endif ()

add_custom_command(
        OUTPUT ${FINGERPRINTS}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        ${COMMANDS}
        DEPENDS ${PACKAGE_PATHS})

add_custom_target(packages ALL DEPENDS ${FINGERPRINTS})

list(POP_BACK CMAKE_MESSAGE_INDENT)

#file(GLOB hmm RELATIVE ${CMAKE_SOURCE_DIR}/deps ${CMAKE_SOURCE_DIR}/deps/**)
#message(STATUS "${hmm}")
