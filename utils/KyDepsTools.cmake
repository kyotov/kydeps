include_guard(GLOBAL)

include(ExternalProject)
include(FetchContent)
include(CMakePrintHelpers)

#-------------------- set_if_empty

macro(set_if_empty NAME)
    if ("${${NAME}}" STREQUAL "")
        message(STATUS "${NAME} not specified, using default `${ARGN}`")
        set(${NAME} ${ARGN})
    else ()
        message(STATUS "${NAME} = ${${NAME}}")
    endif ()
endmacro()

#-------------------- check_not_empty

macro(check_not_empty NAME)
    if ("${${NAME}}" STREQUAL "")
        message(FATAL_ERROR "required ${NAME} is not specified")
    endif ()
endmacro()

#-------------------- check_result

function(check_result RESULT MESSAGE)
    if (NOT "${RESULT}" EQUAL "0")
        message(FATAL_ERROR ${ARG_MESSAGE})
    endif ()
endfunction()

#-------------------- parent_scope

macro(parent_scope NAME)
    message(DEBUG "${NAME} -> ${${NAME}}")
    set(${NAME} ${${NAME}} PARENT_SCOPE)
endmacro()

#-------------------- get_git_revision

function(get_git_revision GIT_REPO_DIRECTORY GIT_REF GIT_REVISION)

    execute_process(
            COMMAND git show-ref ${GIT_REF}
            RESULT_VARIABLE EXIT_CODE
            OUTPUT_VARIABLE GIT_REVISION
            OUTPUT_STRIP_TRAILING_WHITESPACE)

    if (NOT EXIT_CODE EQUAL 0)
        message(FATAL_ERROR "unable to resolve reference ${GIT_REF}")
    endif ()

    string(REGEX REPLACE "^([^ ]*) .*$" "\\1" GIT_REVISION ${GIT_REVISION})

    parent_scope(GIT_REVISION)

endfunction()

#-------------------- get_flavor

function(get_flavor OUTPUT_VARIABLE)

    math(EXPR BIT "8 * ${CMAKE_SIZEOF_VOID_P}")

    set(${OUTPUT_VARIABLE} "${BIT}-bit ${CMAKE_SYSTEM_NAME} ${CMAKE_BUILD_TYPE}" PARENT_SCOPE)

endfunction()

#-------------------- package_parse_fetch_location

function(package_parse_fetch_location PACKAGE_NAME)

    cmake_parse_arguments(
            X
            ""
            "GIT_REPOSITORY;GIT_REF;URL;URL_HASH"
            "DEPENDS"
            ${ARGN}
    )

    if (DEFINED X_GIT_REPOSITORY)

        if (DEFINED X_URL OR DEFINED X_URL_HASH)
            message(FATAL_ERROR "GIT_REPOSITORY is incompatible with URL and URL_HASH")
        endif ()

        if (NOT DEFINED X_GIT_REF)
            message(FATAL_ERROR "GIT_REPOSITORY specified but GIT_REF not specified")
        endif ()

        set(${PACKAGE_NAME}_FETCH_PROTOCOL "GIT")

        set(${PACKAGE_NAME}_FETCH_LOCATION
                GIT_REPOSITORY ${X_GIT_REPOSITORY}
                GIT_TAG ${X_GIT_REF})

        set(${PACKAGE_NAME}_LOCAL_FETCH_LOCATION
                GIT_REPOSITORY "${KYDEPS_PACKAGE_CACHE_DIRECTORY}/${PACKAGE_NAME}/data"
                GIT_TAG ${X_GIT_REF})

        message(STATUS "${X_GIT_REF} @ ${X_GIT_REPOSITORY}")

    elseif (DEFINED X_URL)

        if (DEFINED X_GIT_REPOSITORY OR DEFINED X_GIT_REF)
            message(FATAL_ERROR "URL is incompatible with GIT_REPOSITORY and GIT_REF")
        endif ()

        if (NOT DEFINED X_URL_HASH)
            message(FATAL_ERROR "URL specified but URL_HASH not specified")
        endif ()

        set(${PACKAGE_NAME}_FETCH_PROTOCOL "URL")

        set(${PACKAGE_NAME}_FETCH_LOCATION
                URL ${X_URL}
                URL_HASH SHA1=${X_URL_HASH})

        set(${PACKAGE_NAME}_LOCAL_FETCH_LOCATION
                DOWNLOAD_COMMAND
                ${CMAKE_COMMAND} -E copy_directory
                "${KYDEPS_PACKAGE_CACHE_DIRECTORY}/${PACKAGE_NAME}/data"
                <SOURCE_DIR>)

        set(${PACKAGE_NAME}_REVISION "${X_URL_HASH}")

        message(STATUS "${X_URL} (SHA1=${X_URL_HASH})")

    endif ()

    set(${PACKAGE_NAME}_DEPENDS ${X_DEPENDS})
    set(${PACKAGE_NAME}_ARGS ${X_UNPARSED_ARGUMENTS} DEPENDS ${X_DEPENDS})

    parent_scope(${PACKAGE_NAME}_FETCH_PROTOCOL)
    parent_scope(${PACKAGE_NAME}_FETCH_LOCATION)
    parent_scope(${PACKAGE_NAME}_LOCAL_FETCH_LOCATION)
    parent_scope(${PACKAGE_NAME}_REVISION)
    parent_scope(${PACKAGE_NAME}_DEPENDS)
    parent_scope(${PACKAGE_NAME}_ARGS)

endfunction()

#-------------------- package_cache

function(package_cache PACKAGE_NAME)

    check_not_empty(${PACKAGE_NAME}_FETCH_LOCATION)

    set(DIR "${KYDEPS_PACKAGE_CACHE_DIRECTORY}/${PACKAGE_NAME}")

    file(LOCK "${DIR}" DIRECTORY)

    if (NOT KYDEPS_PACKAGE_CACHE_FROZEN)

        FetchContent_Populate(${PACKAGE_NAME}-CACHE
                ${${PACKAGE_NAME}_FETCH_LOCATION}

                SOURCE_DIR "${DIR}/data"
                BINARY_DIR "${DIR}/build"
                SUBBUILD_DIR "${DIR}/sub-build")

    endif ()

    if ("${${PACKAGE_NAME}_FETCH_PROTOCOL}" STREQUAL "GIT")
        execute_process(
                COMMAND git rev-parse HEAD
                WORKING_DIRECTORY "${DIR}/data"
                RESULT_VARIABLE EXIT_CODE
                OUTPUT_VARIABLE ${PACKAGE_NAME}_REVISION
                OUTPUT_STRIP_TRAILING_WHITESPACE)
        check_result(${EXIT_CODE} "error determining revision")
    else ()
        check_not_empty(${PACKAGE_NAME}_REVISION)
    endif ()

    file(LOCK "${DIR}" DIRECTORY RELEASE)

    message(DEBUG "revision -> ${${PACKAGE_NAME}_REVISION}")

    parent_scope(${PACKAGE_NAME}_REVISION)
    parent_scope(${PACKAGE_NAME}_CACHE_ROOT_DIR)

endfunction()

#-------------------- package_generate_manifest

function(package_generate_manifest PACKAGE_NAME)

    check_not_empty(${PACKAGE_NAME}_FETCH_LOCATION)

    get_flavor(FLAVOR)

    package_cache(${PACKAGE_NAME})

    set(MANIFEST
            "${PACKAGE_NAME}"
            "${${PACKAGE_NAME}_FETCH_LOCATION}"
            "REVISION"
            "${${PACKAGE_NAME}_REVISION}"
            "FLAVOR"
            "${FLAVOR}")

    if (NOT KYDEPS_RELAX_PACKAGE_HASH)

        file(GLOB FILES
                RELATIVE ${CMAKE_SOURCE_DIR}
                ${CMAKE_SOURCE_DIR}/CMakeLists.txt
                ${CMAKE_SOURCE_DIR}/utils/**
                ${CMAKE_SOURCE_DIR}/deps/${PACKAGE_NAME}.cmake)

        foreach (FILE ${FILES})
            file(SHA1 ${CMAKE_SOURCE_DIR}/${FILE} HASH)
            list(APPEND MANIFEST "FILE" "${FILE} ${HASH}")
        endforeach ()

    endif ()

    foreach (DEPEND ${${PACKAGE_NAME}_DEPENDS})
        check_not_empty(${DEPEND}_HASH
                "${PACKAGE_NAME} is missing dependency ${DEPEND}")
        check_not_empty(${DEPEND}_ROOT_PATH)

        list(APPEND MANIFEST "DEPENDS" "${DEPEND} ${${DEPEND}_HASH}")
        list(APPEND ${PACKAGE_NAME}_PREFIX_PATH "${${DEPEND}_ROOT_PATH}/install")
    endforeach ()

    string(JOIN "\n" MANIFEST ${MANIFEST})
    string(SHA1 ${PACKAGE_NAME}_HASH "${MANIFEST}")

    set(${PACKAGE_NAME}_ROOT_PATH "${CMAKE_BINARY_DIR}/_/${PACKAGE_NAME}_${${PACKAGE_NAME}_HASH}")
    set(${PACKAGE_NAME}_MANIFEST "${MANIFEST}")

    parent_scope(${PACKAGE_NAME}_MANIFEST)
    parent_scope(${PACKAGE_NAME}_REVISION)
    parent_scope(${PACKAGE_NAME}_HASH)
    parent_scope(${PACKAGE_NAME}_ROOT_PATH)
    parent_scope(${PACKAGE_NAME}_PREFIX_PATH)

endfunction()

#-------------------- package_install

function(package_build PACKAGE_NAME)

    check_not_empty(${PACKAGE_NAME}_FETCH_LOCATION)
    check_not_empty(${PACKAGE_NAME}_LOCAL_FETCH_LOCATION)
    check_not_empty(${PACKAGE_NAME}_REVISION)
    check_not_empty(${PACKAGE_NAME}_HASH)
    check_not_empty(${PACKAGE_NAME}_ROOT_PATH)

    dump_package_config(${PACKAGE_NAME})

    set(DIR ${${PACKAGE_NAME}_ROOT_PATH})

    ExternalProject_Add(${PACKAGE_NAME}
            ${${PACKAGE_NAME}_LOCAL_FETCH_LOCATION}

            PREFIX ${CMAKE_BINARY_DIR}/_

            SOURCE_DIR "${DIR}/src"
            BINARY_DIR "${DIR}/build"
            INSTALL_DIR "${DIR}/install"
            STAMP_DIR "${DIR}/stamp"
            TMP_DIR "${DIR}/tmp"

            USES_TERMINAL_DOWNLOAD TRUE
            USES_TERMINAL_UPDATE TRUE
            USES_TERMINAL_CONFIGURE TRUE
            USES_TERMINAL_BUILD TRUE
            USES_TERMINAL_INSTALL TRUE
            USES_TERMINAL_TEST TRUE

            CMAKE_ARGS
            -DBUILD_SHARED_LIBS=FALSE
            -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
            -DCMAKE_PREFIX_PATH=${${PACKAGE_NAME}_PREFIX_PATH}
            -DCMAKE_INSTALL_PREFIX:PATH=${DIR}/install
            -DCMAKE_MSVC_RUNTIME_LIBRARY=${CMAKE_MSVC_RUNTIME_LIBRARY}
            -DCMAKE_POLICY_DEFAULT_CMP0091=NEW
            -DCMAKE_POLICY_DEFAULT_CMP0097=NEW
            -DCMAKE_INSTALL_MESSAGE=NEVER

            ${ARGN})

    add_custom_command(
            OUTPUT ${DIR}/package.zip
            COMMAND ${CMAKE_COMMAND} -E tar c ${DIR}/package.zip --format=zip ${DIR}/install
            DEPENDS ${DIR}/stamp/${PACKAGE_NAME}-install)

    if (KYDEPS_UPLOAD)

        set(PACKAGE_S3_URI ${KYDEPS_S3_PREFIX_DEFAULT}/${PACKAGE_NAME}_${HASH}.zip)

        add_custom_command(
                OUTPUT ${DIR}/uploaded
                COMMAND aws s3 cp ${DIR}/package.zip ${PACKAGE_S3_URI}
                COMMAND ${CMAKE_COMMAND} -E touch ${DIR}/uploaded
                DEPENDS ${DIR}/package.zip
        )

        set(UPLOAD_OUTPUT ${PATH}/uploaded)

    endif ()

    add_custom_command(
            OUTPUT ${CMAKE_SOURCE_DIR}/install/${PACKAGE_NAME}.cmake
            COMMAND ${CMAKE_COMMAND} -D "CONFIG=${DIR}/config.cmake" -P "${CMAKE_SOURCE_DIR}/utils/KyDepsGenerateInstall.cmake"
            DEPENDS ${DIR}/package.zip ${UPLOAD_OUTPUT}
    )

    add_custom_target(${PACKAGE_NAME}-done ALL
            DEPENDS ${CMAKE_SOURCE_DIR}/install/${PACKAGE_NAME}.cmake)

endfunction()

#-------------------- dump_package_config_item

function(dump_config_value VARIABLE_NAME)
    set(VALUE "${${VARIABLE_NAME}}")
    list(JOIN VALUE "\;" VALUE)
    string(CONFIGURE "set(${VARIABLE_NAME} \"${VALUE}\")\n" TERM)
    file(APPEND ${CONFIG_FILE} ${TERM})
endfunction()

#-------------------- dump_package_config

function(dump_package_config PACKAGE_NAME)
    set(${PACKAGE_NAME}_NAME "${PACKAGE_NAME}")
    set(${PACKAGE_NAME}_DIR "${CMAKE_SOURCE_DIR}/install")
    set(${PACKAGE_NAME}_SUBDIR "${CMAKE_SYSTEM_NAME}/${CMAKE_BUILD_TYPE}")

    if (KYDEPS_UPLOAD)
        set(${PACKAGE_NAME}_URL "${KYDEPS_URL_PREFIX}/${PACKAGE_NAME}_${${PACKAGE_NAME}_HASH}.zip")
    else ()
        set(${PACKAGE_NAME}_URL "file://${${PACKAGE_NAME}_ROOT_PATH}/package.zip")
    endif ()

    if (NOT "${${PACKAGE_NAME}_DEPENDS_OVERRIDE}" STREQUAL "")
        set(${PACKAGE_NAME}_DEPENDS "${${PACKAGE_NAME}_DEPENDS_OVERRIDE}")
    endif ()

    set(CONFIG_FILE "${${PACKAGE_NAME}_ROOT_PATH}/config.cmake")
    file(WRITE ${CONFIG_FILE} "")
    foreach (VAR NAME DIR SUBDIR URL ROOT_PATH FETCH_LOCATION REVISION HASH DEPENDS BUILD_TYPE_OVERRIDE FIND_OVERRIDE MANIFEST)
        file(APPEND ${CONFIG_FILE} "set(KYDEPS_${VAR} \"${${PACKAGE_NAME}_${VAR}}\")\n")
    endforeach ()
endfunction()

#-------------------- KyDepsInstall

function(KyDepsInstall PACKAGE_NAME)
    list(APPEND CMAKE_MESSAGE_INDENT "${PACKAGE_NAME} : ")

    if (NOT "${${PACKAGE_NAME}_BUILD_TYPE_OVERRIDE}" STREQUAL "" AND
            NOT "${${PACKAGE_NAME}_BUILD_TYPE_OVERRIDE}" STREQUAL "${CMAKE_BUILD_TYPE}")
        message(STATUS "SKIPPED")
        return()
    endif ()

    package_parse_fetch_location(${PACKAGE_NAME} ${ARGN})
    package_generate_manifest(${PACKAGE_NAME})
    package_build(${PACKAGE_NAME} ${${PACKAGE_NAME}_ARGS})

    list(APPEND PACKAGE_NAMES ${PACKAGE_NAME})
    parent_scope(PACKAGE_NAMES)

    parent_scope(${PACKAGE_NAME}_HASH)
    parent_scope(${PACKAGE_NAME}_ROOT_PATH)

    list(POP_BACK CMAKE_MESSAGE_INDENT)
endfunction()
