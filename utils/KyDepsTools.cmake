include_guard(GLOBAL)

include(ExternalProject)

macro(set_if_empty NAME)
    if ("${${NAME}}" STREQUAL "")
        message(STATUS "${NAME} not specified, using default `${ARGN}`")
        set(${NAME} ${ARGN})
    else ()
        message(STATUS "${NAME} = ${${NAME}}")
    endif ()
endmacro()

macro(check_not_empty NAME)
    if ("${${NAME}}" STREQUAL "")
        message(FATAL_ERROR "required ${NAME} is not specified")
    endif ()
endmacro()

function(check_result RESULT MESSAGE)
    if (NOT "${RESULT}" EQUAL "0")
        message(FATAL_ERROR ${ARG_MESSAGE})
    endif ()
endfunction()

function(get_git_remote_revision GIT_REPO_URL GIT_REF GIT_REVISION)
    execute_process(
            COMMAND git ls-remote --exit-code ${GIT_REPO_URL} ${GIT_REF}
            RESULT_VARIABLE EXIT_CODE
            OUTPUT_VARIABLE GIT_REVISION
            OUTPUT_STRIP_TRAILING_WHITESPACE)
    if (EXIT_CODE EQUAL 2)
        message(FATAL_ERROR "unable to resolve reference ${GIT_REF} from ${GIT_REPO_URL}")
    endif ()
    string(REGEX REPLACE "^([^\t]*)\t.*$" "\\1" GIT_REVISION ${GIT_REVISION})
    set(GIT_REVISION ${GIT_REVISION} PARENT_SCOPE)
endfunction()

function(get_flavor OUTPUT_VARIABLE)
    math(EXPR BIT "8 * ${CMAKE_SIZEOF_VOID_P}")
    set(${OUTPUT_VARIABLE} "${BIT}-bit ${CMAKE_SYSTEM_NAME} ${CMAKE_BUILD_TYPE}" PARENT_SCOPE)
endfunction()

function(get_package_hash PACKAGE_NAME GIT_REPO GIT_REF)
    list(APPEND CMAKE_MESSAGE_INDENT "get_package_hash : ")

    get_flavor(FLAVOR)
    set(MANIFEST "-- package --" "${PACKAGE_NAME} ${FLAVOR}")

    # FIXME: re-enable when done testing!
#    file(GLOB FILES
#            RELATIVE ${CMAKE_SOURCE_DIR}
#            ${CMAKE_SOURCE_DIR}/CMakeLists.txt
#            ${CMAKE_SOURCE_DIR}/utils/**
#            ${CMAKE_SOURCE_DIR}/deps/${PACKAGE_NAME}.cmake)

    list(APPEND MANIFEST "-- files --")
    foreach (FILE ${FILES})
        file(SHA1 ${CMAKE_SOURCE_DIR}/${FILE} HASH)
        list(APPEND MANIFEST "${HASH} ${FILE}")
    endforeach ()

    get_git_remote_revision(${GIT_REPO} ${GIT_REF} GIT_REVISION)
    list(APPEND MANIFEST "-- source --" "${GIT_REF} (${GIT_REVISION}) @ ${GIT_REPO}")

    cmake_parse_arguments(X "" "" "DEPENDS;CMAKE_ARGS" ${ARGN})

    list(APPEND MANIFEST "-- depends --")
    foreach (DEPEND ${X_DEPENDS})
        list(APPEND MANIFEST "${DEPEND} -> ${${DEPEND}_HASH}")
        list(APPEND PREFIX_PATH "${CMAKE_BINARY_DIR}/install/${DEPEND}_${${DEPEND}_HASH}")
    endforeach ()

    list(APPEND MANIFEST "-- cmake args --" ${X_CMAKE_ARGS})
    list(APPEND MANIFEST "-- other args --" ${X_UNPARSED_ARGUMENTS})
    list(APPEND MANIFEST "-- end --")

    string(SHA1 HASH "${MANIFEST}")

    if (KYDEPS_SHOW_MANIFEST)
        string(JOIN "\n" STRING_MANIFEST ${HASH} ${MANIFEST})
        message(STATUS "${STRING_MANIFEST}")
    endif ()

    set("${PACKAGE_NAME}_HASH" ${HASH} PARENT_SCOPE)
    set(PREFIX_PATH ${PREFIX_PATH} PARENT_SCOPE)

    list(POP_BACK CMAKE_MESSAGE_INDENT)
endfunction()

function(KyDepsInstall PACKAGE_NAME GIT_REPO GIT_REF)
    list(APPEND CMAKE_MESSAGE_INDENT "${PACKAGE_NAME} : ")

    get_package_hash(${PACKAGE_NAME} ${GIT_REPO} ${GIT_REF} ${ARGN})

    set(HASH ${${PACKAGE_NAME}_HASH})
    message(STATUS "${GIT_REPO} @ ${GIT_REF} (package hash ${HASH})")

    set(${PACKAGE_NAME}_HASH ${HASH} PARENT_SCOPE)

    set(INSTALL_PATH ${CMAKE_BINARY_DIR}/install/${PACKAGE_NAME}_${HASH})
    set(PACKAGE_PATH ${CMAKE_BINARY_DIR}/package/${PACKAGE_NAME}_${HASH}.zip)

    list(APPEND PACKAGE_PATHS ${PACKAGE_PATH})
    set(PACKAGE_PATHS ${PACKAGE_PATHS} PARENT_SCOPE)

    if (KYDEPS_DOWNLOAD)
        list(GET ${PACKAGE_NAME}_${HASH}_sha1sum 0 SHA1)
        ExternalProject_Add(${PACKAGE_NAME}
                URL ${KYDEPS_URL_PREFIX_DEFAULT}/${PACKAGE_NAME}_${HASH}.zip
                URL_HASH SHA1=${SHA1}
                PREFIX ${CMAKE_BINARY_DIR}/download
                CONFIGURE_COMMAND ""
                BUILD_COMMAND ""
                INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_BINARY_DIR}/download/src/install/${PACKAGE_NAME}_${HASH} ${CMAKE_BINARY_DIR}/install/${PACKAGE_NAME}_${HASH})

        add_custom_command(
                OUTPUT ${PACKAGE_PATH}
                WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/package
                COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_BINARY_DIR}/download/src/${PACKAGE_NAME}_${HASH}.zip ${PACKAGE_NAME}_${HASH}.zip
                DEPENDS ${PACKAGE_NAME})
    else ()
        ExternalProject_Add(${PACKAGE_NAME}
                GIT_REPOSITORY ${GIT_REPO}
                GIT_TAG ${GIT_REF}
                PREFIX ${CMAKE_BINARY_DIR}/build
                CMAKE_ARGS
                -DBUILD_SHARED_LIBS=FALSE
                -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                -DCMAKE_PREFIX_PATH=${PREFIX_PATH}
                -DCMAKE_INSTALL_PREFIX:PATH=${INSTALL_PATH}
                -DCMAKE_MSVC_RUNTIME_LIBRARY=${CMAKE_MSVC_RUNTIME_LIBRARY}
                -DCMAKE_POLICY_DEFAULT_CMP0091=NEW
                ${ARGN})

        if (KYDEPS_UPLOAD)
            set(PACKAGE_S3_URI ${KYDEPS_S3_PREFIX_DEFAULT}/${PACKAGE_NAME}_${HASH}.zip)
            set(UPLOAD_COMMAND COMMAND aws s3 cp ${PACKAGE_PATH} ${PACKAGE_S3_URI})
        endif ()

        add_custom_command(
                OUTPUT ${PACKAGE_PATH}
                WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/package
                COMMAND ${CMAKE_COMMAND} -E tar c ${PACKAGE_PATH} --format=zip ${INSTALL_PATH}
                ${UPLOAD_COMMAND}
                DEPENDS ${PACKAGE_NAME})
    endif ()

    list(POP_BACK CMAKE_MESSAGE_INDENT)
endfunction()
