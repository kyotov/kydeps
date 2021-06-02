cmake_minimum_required(VERSION 3.18)
project(kydeps)

list(APPEND CMAKE_MESSAGE_INDENT "  KyDeps : ")
list(APPEND CMAKE_MODULE_PATH
        ${CMAKE_SOURCE_DIR}/utils
        ${CMAKE_SOURCE_DIR}/deps)

include(FetchContent)
include(KyDepsTools)
include(KyDepsOptions)
include(KyDepsEpilogue)

set_if_empty(KYDEPS_UPLOAD OFF)
set_if_empty(KYDEPS_DOWNLOAD OFF)
set_if_empty(KYDEPS_PACKAGES "gflags;glog")
set_if_empty(KYDEPS_SHOW_MANIFEST OFF)
set_if_empty(KYDEPS_URL_PREFIX_DEFAULT "https://kydeps.s3.us-east-2.amazonaws.com")
set_if_empty(KYDEPS_S3_PREFIX_DEFAULT "s3://kydeps")

if (KYDEPS_DOWNLOAD AND KYDEPS_UPLOAD)
    message(FATAL_ERROR "KYDEPS_DOWNLOAD and KYDEPS_UPLOAD should not both be ON")
endif ()

set(FINGERPRINTS "${CMAKE_SOURCE_DIR}/fingerprints.cmake")

if (KYDEPS_DOWNLOAD)
    include(${FINGERPRINTS})

    foreach (PACKAGE ${KYDEPS_PACKAGES})
        include(${PACKAGE})
    endforeach ()

    add_custom_target(packages ALL DEPENDS ${PACKAGE_PATHS})
else ()
    foreach (PACKAGE ${KYDEPS_PACKAGES})
        include(${PACKAGE})
    endforeach ()

    get_flavor(FLAVOR)
    message(STATUS "FLAVOR : ${FLAVOR}")

    foreach (PACKAGE_PATH ${PACKAGE_PATHS})
        get_filename_component(KEY ${PACKAGE_PATH} NAME_WE)
        list(APPEND COMMANDS
                COMMAND ${CMAKE_COMMAND} -E echo "set(${KEY}_sha1sum" >> ${FINGERPRINTS}
                COMMAND ${CMAKE_COMMAND} -E echo_append "  " >> ${FINGERPRINTS}
                COMMAND ${CMAKE_COMMAND} -E sha1sum package/${KEY}.zip >> ${FINGERPRINTS}
                COMMAND ${CMAKE_COMMAND} -E echo "  ${FLAVOR})" >> ${FINGERPRINTS})
    endforeach ()

    add_custom_command(
            OUTPUT ${FINGERPRINTS}
            WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
            ${COMMANDS}
            DEPENDS ${PACKAGE_PATHS})

    add_custom_target(packages ALL DEPENDS ${FINGERPRINTS})
endif ()

list(POP_BACK CMAKE_MESSAGE_INDENT)
