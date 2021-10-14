include_guard(GLOBAL)

include(ExternalProject)
include(FetchContent)
include(CMakePrintHelpers)
include(KyDepsCommon)

#-------------------- check_result

function(check_result RESULT MESSAGE)
    if (NOT "${RESULT}" EQUAL "0")
        message(FATAL_ERROR ${ARG_MESSAGE})
    endif ()
endfunction()

#-------------------- get_flavor

function(get_flavor OUTPUT_VARIABLE)
    math(EXPR BIT "8 * ${CMAKE_SIZEOF_VOID_P}")
    set(${OUTPUT_VARIABLE} "${BIT}-bit ${CMAKE_SYSTEM_NAME} ${CMAKE_BUILD_TYPE}" PARENT_SCOPE)
endfunction()

#-------------------- package_fetch

function(package_fetch PACKAGE_NAME)

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

        set(${PACKAGE_NAME}_SOURCE "${X_GIT_REF} @ ${X_GIT_REPOSITORY}")
        set(${PACKAGE_NAME}_LOCATION GIT_REPOSITORY "${X_GIT_REPOSITORY}" GIT_TAG "${X_GIT_REF}")
        set(${PACKAGE_NAME}_REVISION "${X_GIT_REF}")

    elseif (DEFINED X_URL)

        if (DEFINED X_GIT_REPOSITORY OR DEFINED X_GIT_REF)
            message(FATAL_ERROR "URL is incompatible with GIT_REPOSITORY and GIT_REF")
        endif ()

        if (NOT DEFINED X_URL_HASH)
            message(FATAL_ERROR "URL specified but URL_HASH not specified")
        endif ()

        set(${PACKAGE_NAME}_SOURCE "${X_URL_HASH} @ ${X_URL}")
        set(${PACKAGE_NAME}_LOCATION URL "${X_URL}" URL_HASH "SHA1=${X_URL_HASH}")
        set(${PACKAGE_NAME}_REVISION "${X_URL_HASH}")

    endif ()

    set(${PACKAGE_NAME}_DEPENDS ${X_DEPENDS})
    set(${PACKAGE_NAME}_ARGS ${X_UNPARSED_ARGUMENTS} DEPENDS ${X_DEPENDS})

    parent_scope(${PACKAGE_NAME}_DEPENDS)
    parent_scope(${PACKAGE_NAME}_ARGS)
    parent_scope(${PACKAGE_NAME}_SOURCE)
    parent_scope(${PACKAGE_NAME}_LOCATION)
    parent_scope(${PACKAGE_NAME}_REVISION)

endfunction()

#-------------------- package_generate_manifest

function(package_generate_manifest PACKAGE_NAME)

    check_not_empty(${PACKAGE_NAME}_SOURCE)

    get_flavor(FLAVOR)

    set(MANIFEST
            "${PACKAGE_NAME}"
            "${${PACKAGE_NAME}_SOURCE}"
            "${FLAVOR}")

    if (NOT KYDEPS_RELAX_PACKAGE_HASH)

        file(GLOB FILES
                RELATIVE ${CMAKE_SOURCE_DIR}
                ${CMAKE_SOURCE_DIR}/CMakeLists.txt
                ${CMAKE_SOURCE_DIR}/cmake/**
                ${CMAKE_SOURCE_DIR}/definitions/${PACKAGE_NAME}.cmake)

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

#-------------------- rig_cmake_command

function(rig_cmake_command)

    get_property(KYDEPS_COMPILE_OPTIONS DIRECTORY PROPERTY COMPILE_OPTIONS)
    string(JOIN " " KYDEPS_COMPILE_OPTIONS_STR ${KYDEPS_COMPILE_OPTIONS})
    #message(NOTICE "${CMAKE_CURRENT_LIST_FILE}: Using COMPILE_OPTIONS = ${KYDEPS_COMPILE_OPTIONS_STR}")

    get_property(KYDEPS_LINK_OPTIONS DIRECTORY PROPERTY LINK_OPTIONS)
    string(JOIN " " KYDEPS_LINK_OPTIONS_STR ${KYDEPS_LINK_OPTIONS})
    #message(NOTICE "${CMAKE_CURRENT_LIST_FILE}: Using LINK_OPTIONS = ${KYDEPS_LINK_OPTIONS_STR}")

    set(CMAKE_COMMAND
            ${CMAKE_COMMAND} -E env
            CFLAGS=${KYDEPS_COMPILE_OPTIONS_STR}
            CXXFLAGS=${KYDEPS_COMPILE_OPTIONS_STR}
            LDFLAGS=${KYDEPS_LINK_OPTIONS_STR}
            ${CMAKE_COMMAND})

    parent_scope(CMAKE_COMMAND)

endfunction()

#-------------------- package_build_external_project

function(package_build_external_project PACKAGE_NAME)

    rig_cmake_command()

    ExternalProject_Add(${PACKAGE_NAME}
            ${${PACKAGE_NAME}_LOCATION}

            PREFIX ${CMAKE_BINARY_DIR}/_

            SOURCE_DIR "${DIR}/src"
            BINARY_DIR "${DIR}/build"
            INSTALL_DIR "${DIR}/install"
            STAMP_DIR "${DIR}/stamp"
            TMP_DIR "${DIR}/tmp"

            USES_TERMINAL_DOWNLOAD ${KYDEPS_USES_TERMINAL}
            USES_TERMINAL_UPDATE ${KYDEPS_USES_TERMINAL}
            USES_TERMINAL_CONFIGURE ${KYDEPS_USES_TERMINAL}
            USES_TERMINAL_BUILD ${KYDEPS_USES_TERMINAL}
            USES_TERMINAL_INSTALL ${KYDEPS_USES_TERMINAL}
            USES_TERMINAL_TEST ${KYDEPS_USES_TERMINAL}

            CMAKE_CACHE_ARGS
            -DCMAKE_PREFIX_PATH:STRING=${${PACKAGE_NAME}_PREFIX_PATH}

            CMAKE_ARGS
            -DBUILD_SHARED_LIBS=FALSE
            -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
            -DCMAKE_PREFIX_PATH=${${PACKAGE_NAME}_PREFIX_PATH}
            -DCMAKE_INSTALL_PREFIX:PATH=${DIR}/install
            -DCMAKE_MSVC_RUNTIME_LIBRARY=${CMAKE_MSVC_RUNTIME_LIBRARY}
            -DCMAKE_POLICY_DEFAULT_CMP0091=NEW
            -DCMAKE_POLICY_DEFAULT_CMP0097=NEW
            -DCMAKE_INSTALL_MESSAGE=NEVER

            UPDATE_COMMAND ${CMAKE_COMMAND} -E touch ${DIR}/stamp/${PACKAGE_NAME}-update

            ${ARGN})

endfunction()

#-------------------- package_build

function(package_build PACKAGE_NAME)

    check_not_empty(${PACKAGE_NAME}_LOCATION)
    check_not_empty(${PACKAGE_NAME}_REVISION)
    check_not_empty(${PACKAGE_NAME}_HASH)
    check_not_empty(${PACKAGE_NAME}_ROOT_PATH)

    dump_package_config(${PACKAGE_NAME})

    set(PACKAGE_FILE_NAME "${PACKAGE_NAME}_${${PACKAGE_NAME}_HASH}.zip")
    set(PACKAGE_S3_URI ${KYDEPS_S3_PREFIX}/${PACKAGE_FILE_NAME})

    set(DIR ${${PACKAGE_NAME}_ROOT_PATH})

    # Determine if we can reuse remote bits. This happens when all of the following hold:
    #
    #   1. KYDEPS_QUICK is ON
    #   2. ${DIR}/package.zip (i.e. previous local build) does not exist
    #   3. ${PACKAGE_S3_URI} (i.e. remote cached bits) exist
    #
    # NOTE: If a local build has been performed at all before in this dir, remote bits are not reused.
    #       This is largely because we are not sure if the local build is not more current than anything remote.
    #       Thus we stay on the safe side and rebuild (hopefully incrementally) locally.
    #
    if (KYDEPS_QUICK AND NOT EXISTS "${DIR}/package.zip")
        if (EXISTS "${DIR}/remote_package.zip")
            set(USE_REMOTE TRUE)
        else ()
            execute_process(
                    COMMAND aws s3 ls "${PACKAGE_S3_URI}"
                    RESULT_VARIABLE EXIT_CODE)
            if (EXIT_CODE EQUAL 0)
                set(USE_REMOTE TRUE)
            endif ()
        endif ()
    endif ()

    if (USE_REMOTE)
        message(DEBUG "reusing remote bits in quick mode!")

        if (NOT EXISTS "${DIR}/remote_stage_2.zip")
            execute_and_check(COMMAND aws s3 cp "${PACKAGE_S3_URI}" "${DIR}/remote_stage_1.zip")
            file(ARCHIVE_EXTRACT INPUT "${DIR}/remote_stage_1.zip" DESTINATION "${CMAKE_BINARY_DIR}")
            file(RENAME "${DIR}/remote_stage_1.zip" "${DIR}/remote_stage_2.zip")
        endif ()

        add_custom_target(${PACKAGE_NAME}
                DEPENDS ${DIR}/remote_stage_2.zip)

        set(DONE_DEPENDS "${DIR}/remote_stage_2.zip")
    else ()

        package_build_external_project(${PACKAGE_NAME} ${ARGN})

        add_custom_command(
                OUTPUT ${DIR}/package.zip
                COMMAND ${CMAKE_COMMAND} -E tar c ${DIR}/package.zip --format=zip ${DIR}/install
                DEPENDS ${DIR}/stamp/${PACKAGE_NAME}-install)

        if (KYDEPS_UPLOAD)

            add_custom_command(
                    OUTPUT "${DIR}/uploaded"
                    COMMAND aws s3 cp "${DIR}/package.zip" "${PACKAGE_S3_URI}"
                    COMMAND ${CMAKE_COMMAND} -E touch "${DIR}/uploaded"
                    DEPENDS "${DIR}/package.zip"
            )

            set(UPLOAD_OUTPUT "${DIR}/uploaded")

        endif ()

        set(DONE_DEPENDS "${DIR}/package.zip" ${UPLOAD_OUTPUT})
    endif ()

    add_custom_target(${PACKAGE_NAME}-done ALL
            COMMAND ${CMAKE_COMMAND} -D "CONFIG=${DIR}/config.cmake" -P "${CMAKE_SOURCE_DIR}/cmake/KyDepsGenerateInstall.cmake"
            DEPENDS ${DONE_DEPENDS})

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

    package_fetch(${PACKAGE_NAME} ${ARGN})
    package_generate_manifest(${PACKAGE_NAME})
    package_build(${PACKAGE_NAME} ${${PACKAGE_NAME}_ARGS})

    list(APPEND PACKAGE_NAMES ${PACKAGE_NAME})
    parent_scope(PACKAGE_NAMES)

    parent_scope(${PACKAGE_NAME}_HASH)
    parent_scope(${PACKAGE_NAME}_ROOT_PATH)

    list(POP_BACK CMAKE_MESSAGE_INDENT)
endfunction()
