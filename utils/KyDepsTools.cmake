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

    if (NOT KYDEPS_RELAX_PACKAGE_HASH)
        file(GLOB FILES
                RELATIVE ${CMAKE_SOURCE_DIR}
                ${CMAKE_SOURCE_DIR}/CMakeLists.txt
                ${CMAKE_SOURCE_DIR}/utils/**
                ${CMAKE_SOURCE_DIR}/deps/${PACKAGE_NAME}.cmake)
    endif ()

    list(APPEND MANIFEST "-- files --")
    foreach (FILE ${FILES})
        file(SHA1 ${CMAKE_SOURCE_DIR}/${FILE} HASH)
        list(APPEND MANIFEST "${HASH} ${FILE}")
    endforeach ()

    get_git_remote_revision(${GIT_REPO} ${GIT_REF} GIT_REVISION)
    list(APPEND MANIFEST "-- source --" "${GIT_REF} (${GIT_REVISION}) @ ${GIT_REPO}")

    # NOTE: for the sake of simplicity, we require DEPENDS to be last and we don't need others
    # cmake_parse_arguments(X "" "" "DEPENDS;CMAKE_ARGS;SOURCE_SUBDIR" ${ARGN})
    cmake_parse_arguments(X "" "" "DEPENDS" ${ARGN})

    list(APPEND MANIFEST "-- depends --")
    foreach (DEPEND ${X_DEPENDS})
        if ("${${DEPEND}_HASH}" STREQUAL "")
            message(FATAL_ERROR "ERROR: dependency '${DEPEND}' not found for package '${PACKAGE_NAME}'!\nHINT: Make sure DEPENDS is the last section on KyDepsInstall call.")
        endif ()
        list(APPEND MANIFEST "${DEPEND} -> ${${DEPEND}_HASH}")
        list(APPEND PREFIX_PATH "${CMAKE_BINARY_DIR}/install/${DEPEND}_${${DEPEND}_HASH}")
    endforeach ()

    # NOTE: we have the hash of the .cmake module, which subsumes the arguments!
    # list(APPEND MANIFEST "-- args --" ${ARGN})
    list(APPEND MANIFEST "-- end --")

    list(TRANSFORM MANIFEST REPLACE "${CMAKE_BINARY_DIR}" "\${CMAKE_BINARY_DIR}")
    list(TRANSFORM MANIFEST REPLACE "^.*/cmake.exe$" "\${CMAKE_COMMAND}")

    string(SHA1 HASH "${MANIFEST}")

    string(JOIN "\n" STRING_MANIFEST ${HASH} ${MANIFEST})
    file(WRITE "${CMAKE_BINARY_DIR}/deps.manifest/${PACKAGE_NAME}.manifest" "${STRING_MANIFEST}")

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

    list(APPEND PACKAGE_NAMES ${PACKAGE_NAME})
    set(PACKAGE_NAMES ${PACKAGE_NAMES} PARENT_SCOPE)

    list(APPEND INSTALL_PATHS ${INSTALL_PATH})
    set(INSTALL_PATHS ${INSTALL_PATHS} PARENT_SCOPE)

    list(APPEND PACKAGE_PATHS ${PACKAGE_PATH})
    set(PACKAGE_PATHS ${PACKAGE_PATHS} PARENT_SCOPE)

    if (KYDEPS_DOWNLOAD)
        list(GET ${PACKAGE_NAME}_${HASH}_sha1sum 0 SHA1)

        if (APPLE)
            set(EXTRACT_DIR ${PACKAGE_NAME})
        else ()
            set(EXTRACT_DIR install)
        endif ()

        ExternalProject_Add(${PACKAGE_NAME}
                URL ${KYDEPS_URL_PREFIX_DEFAULT}/${PACKAGE_NAME}_${HASH}.zip
                URL_HASH SHA1=${SHA1}
                DOWNLOAD_NO_PROGRESS TRUE
                PREFIX ${CMAKE_BINARY_DIR}/download
                CONFIGURE_COMMAND ""
                BUILD_COMMAND ""
                INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/../${EXTRACT_DIR}/${PACKAGE_NAME}_${HASH} ${INSTALL_PATH}
                COMMAND ${CMAKE_COMMAND} -E copy <DOWNLOAD_DIR>/${PACKAGE_NAME}_${HASH}.zip ${PACKAGE_PATH})

        add_custom_command(
                OUTPUT ${PACKAGE_PATH}
                DEPENDS ${PACKAGE_NAME})
    else ()
        ExternalProject_Add(${PACKAGE_NAME}
                GIT_REPOSITORY ${GIT_REPO}
                GIT_TAG ${GIT_REF}
                GIT_SHALLOW TRUE
                PREFIX ${CMAKE_BINARY_DIR}/build/${PACKAGE_NAME}_${HASH}
                INSTALL_DIR ${INSTALL_PATH}

                GIT_PROGRESS TRUE
                USES_TERMINAL_DOWNLOAD TRUE
                USES_TERMINAL_UPDATE TRUE
                USES_TERMINAL_CONFIGURE TRUE
                USES_TERMINAL_BUILD TRUE
                USES_TERMINAL_INSTALL TRUE
                USES_TERMINAL_TEST TRUE

                CMAKE_ARGS
                -DBUILD_SHARED_LIBS=FALSE
                -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                -DCMAKE_PREFIX_PATH=${PREFIX_PATH}
                -DCMAKE_INSTALL_PREFIX:PATH=${INSTALL_PATH}
                -DCMAKE_MSVC_RUNTIME_LIBRARY=${CMAKE_MSVC_RUNTIME_LIBRARY}
                -DCMAKE_POLICY_DEFAULT_CMP0091=NEW
                -DCMAKE_POLICY_DEFAULT_CMP0097=NEW
                -DCMAKE_INSTALL_MESSAGE=NEVER
                ${ARGN})

        if (KYDEPS_UPLOAD)
            set(PACKAGE_S3_URI ${KYDEPS_S3_PREFIX_DEFAULT}/${PACKAGE_NAME}_${HASH}.zip)
            set(UPLOAD_COMMAND COMMAND aws s3 cp ${PACKAGE_PATH} ${PACKAGE_S3_URI})
        endif ()

        # FIXME(kyotov): this does not always trigger -- if the zip is already there it is a noop.
        #   I would have expected that rebuilding ${PACKAGE_NAME} would invalidate it!
        add_custom_command(
                OUTPUT ${PACKAGE_PATH}
                COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/package
                COMMAND ${CMAKE_COMMAND} -E tar c ${PACKAGE_PATH} --format=zip ${INSTALL_PATH}
                ${UPLOAD_COMMAND}
                DEPENDS ${PACKAGE_NAME})
    endif ()

    list(POP_BACK CMAKE_MESSAGE_INDENT)
endfunction()

if (WIN32)
    set(LP "(")
    set(RP ")")
else ()
    set(LP "\\(")
    set(RP "\\)")
endif ()

function(add_fingerprints_target)
    get_flavor(FLAVOR)

    foreach (PACKAGE_PATH ${PACKAGE_PATHS})
        get_filename_component(KEY ${PACKAGE_PATH} NAME_WE)
        list(APPEND COMMANDS
                COMMAND ${CMAKE_COMMAND} -E echo "set${LP}${KEY}_sha1sum" >> ${FINGERPRINTS}
                COMMAND ${CMAKE_COMMAND} -E echo_append "  " >> ${FINGERPRINTS}
                COMMAND ${CMAKE_COMMAND} -E sha1sum package/${KEY}.zip >> ${FINGERPRINTS}
                COMMAND ${CMAKE_COMMAND} -E echo "  ${FLAVOR}${RP}" >> ${FINGERPRINTS})
    endforeach ()

    set(DEPS_MANIFEST_DIR "${CMAKE_SOURCE_DIR}/deps.manifest/${CMAKE_BUILD_TYPE}/${CMAKE_SYSTEM_NAME}")

    add_custom_target(fingerprints ALL
            COMMAND ${CMAKE_COMMAND} -E echo "" >> ${FINGERPRINTS}
            ${COMMANDS}
            COMMAND ${CMAKE_COMMAND} -E make_directory "${DEPS_MANIFEST_DIR}"
            COMMAND ${CMAKE_COMMAND} -E copy_directory "${CMAKE_BINARY_DIR}/deps.manifest" "${DEPS_MANIFEST_DIR}"
            WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
            DEPENDS ${PACKAGE_PATHS})
endfunction()

function(add_deep_clean_target)
    add_custom_target(deep_clean ALL)
    set_target_properties(deep_clean
            PROPERTIES ADDITIONAL_CLEAN_FILES "${CMAKE_BINARY_DIR}/build;${CMAKE_BINARY_DIR}/download")
endfunction()

function(add_targets)
    set(FINGERPRINTS "${CMAKE_SOURCE_DIR}/deps.manifest/fingerprints.cmake")
    set(CONFIG ${CMAKE_BINARY_DIR}/config.cmake)

    if (KYDEPS_DOWNLOAD)
        include(${FINGERPRINTS})
    endif ()

    foreach (PACKAGE ${KYDEPS_PACKAGES})
        include(${PACKAGE})
    endforeach ()

    set(COMMANDS_1)
    foreach (INSTALL_PATH ${INSTALL_PATHS})
        list(APPEND COMMANDS_1 COMMAND ${CMAKE_COMMAND} -E echo "  ${INSTALL_PATH}" >> ${CONFIG})
    endforeach ()

    set(COMMANDS_2)
    foreach (PACKAGE_NAME ${PACKAGE_NAMES})
        if ("${${PACKAGE_NAME}_find_package_options}" STREQUAL "")
            set(${PACKAGE_NAME}_find_package_options NO_MODULE)
        endif ()
        list(APPEND COMMANDS_2 COMMAND ${CMAKE_COMMAND} -E echo "find_package${LP}${PACKAGE_NAME} REQUIRED ${${PACKAGE_NAME}_find_package_options}${RP}" >> ${CONFIG})
    endforeach ()

    add_custom_command(
            OUTPUT ${CONFIG}
            DEPENDS ${PACKAGE_PATHS}
            COMMAND ${CMAKE_COMMAND} -E echo "list${LP}APPEND CMAKE_PREFIX_PATH" > ${CONFIG}
            ${COMMANDS_1}
            COMMAND ${CMAKE_COMMAND} -E echo "${RP}" >> ${CONFIG}
            COMMAND ${CMAKE_COMMAND} -E echo "" >> ${CONFIG}
            ${COMMANDS_2}
    )

    add_custom_target(packages ALL DEPENDS ${PACKAGE_PATHS} ${CONFIG})
    set_target_properties(packages
            PROPERTIES ADDITIONAL_CLEAN_FILES "${CMAKE_BINARY_DIR}/install;${CMAKE_BINARY_DIR}/package")

    if (KYDEPS_DEEP_CLEAN)
        add_deep_clean_target()
    endif ()

    if (KYDEPS_UPLOAD)
        add_fingerprints_target()
    endif ()

endfunction()
