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

set(CONFIG ${CMAKE_BINARY_DIR}/config.cmake)

set(COMMANDS_1)
foreach (INSTALL_PATH ${INSTALL_PATHS})
    list(APPEND COMMANDS_1 COMMAND ${CMAKE_COMMAND} -E echo "  ${INSTALL_PATH}" >> ${CONFIG})
endforeach ()

set(COMMANDS_2)
foreach (PACKAGE_NAME ${PACKAGE_NAMES})
    list(APPEND COMMANDS_2 COMMAND ${CMAKE_COMMAND} -E echo "find_package(${PACKAGE_NAME} REQUIRED NO_MODULE)" >> ${CONFIG})
endforeach ()

add_custom_command(
        OUTPUT ${CONFIG}
        DEPENDS ${PACKAGE_PATHS}
        COMMAND ${CMAKE_COMMAND} -E echo "list(APPEND CMAKE_PREFIX_PATH" > ${CONFIG}
        ${COMMANDS_1}
        COMMAND ${CMAKE_COMMAND} -E echo ")" >> ${CONFIG}
        COMMAND ${CMAKE_COMMAND} -E echo "" >> ${CONFIG}
        ${COMMANDS_2}
)

add_custom_target(packages ALL DEPENDS ${PACKAGE_PATHS} ${CONFIG})
set_target_properties(packages
        PROPERTIES ADDITIONAL_CLEAN_FILES "${CMAKE_BINARY_DIR}/install;${CMAKE_BINARY_DIR}/package")

#
#add_custom_target()
#message(STATUS "PACKAGE NAMES = ${PACKAGE_NAMES}")
#message(STATUS "PACKAGE PATHS = ${PACKAGE_PATHS}")
#message(STATUS "INSTALL PATHS = ${INSTALL_PATHS}")

if (KYDEPS_DEEP_CLEAN)
    add_deep_clean_target()
endif ()

if (KYDEPS_UPLOAD)
    add_fingerprints_target()
endif ()

list(POP_BACK CMAKE_MESSAGE_INDENT)
