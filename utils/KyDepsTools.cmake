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
    if ("${NAME}" STREQUAL "")
        message(FATAL_ERROR "required ${NAME} is not specified")
    endif ()
endmacro()

function(get_git_revision GIT_REPO_DIR GIT_REVISION)
    execute_process(
            COMMAND git rev-parse HEAD
            WORKING_DIRECTORY ${GIT_REPO_DIR}
            OUTPUT_VARIABLE GIT_REVISION
            OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    set(GIT_REVISION ${GIT_REVISION} PARENT_SCOPE)
endfunction()

function(get_package_name DEPS_GIT_REPO_DIR DEPS_LIST OUTPUT_VARIABLE)
    get_git_revision(DEPS_GIT_REPO_DIR GIT_REVISION)
    string(JOIN "-" DEPS_STR ${DEPS_LIST})
    set(${OUTPUT_VARIABLE} "${GIT_REVISION}-${CMAKE_SYSTEM_NAME}-${CMAKE_BUILD_TYPE}-${DEPS_STR}" PARENT_SCOPE)
endfunction()

function(KyDepsInstallBase)
    get_filename_component(MODULE_NAME "${CMAKE_CURRENT_LIST_FILE}" NAME_WE)
    message(NOTICE ">>>>> ${MODULE_NAME}")
    ExternalProject_Add(
            ${MODULE_NAME}
            PREFIX ${CMAKE_BINARY_DIR}
            ${ARGN})
endfunction()

function(KyDepsInstallGit GIT_REPO GIT_REF)
    KyDepsInstallBase(
            GIT_REPOSITORY ${GIT_REPO}
            GIT_TAG ${GIT_REF}
            ${ARGN})
    message(NOTICE ">>>>> \t ${GIT_REF} @ ${GIT_REPO}")
endfunction()

function(KyDepsInstall GIT_REPO GIT_REF)
    KyDepsInstallGit(${GIT_REPO} ${GIT_REF}
            CMAKE_ARGS
            -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
            -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_BINARY_DIR}/install
            -DCMAKE_MSVC_RUNTIME_LIBRARY=${CMAKE_MSVC_RUNTIME_LIBRARY}
            -DCMAKE_POLICY_DEFAULT_CMP0091=NEW
            # TODO: check it is ok to remove
            # -DBUILD_SHARED_LIBS=FALSE
            ${ARGN})
endfunction()
