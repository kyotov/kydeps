include_guard(GLOBAL)

function(get_package_name DEPS_GIT_REPO_DIRECTORY DEPS_LIST OUTPUT_VARIABLE)

    execute_process(
            COMMAND git rev-parse HEAD
            WORKING_DIRECTORY ${DEPS_GIT_REPO_DIRECTORY}
            OUTPUT_VARIABLE GIT_REVISION
            OUTPUT_STRIP_TRAILING_WHITESPACE
    )

    string(JOIN "+" DEPS_STR ${DEPS_LIST})

    set(${OUTPUT_VARIABLE} "${GIT_REVISION}-${CMAKE_SYSTEM_NAME}-${CMAKE_BUILD_TYPE}-${DEPS_STR}" PARENT_SCOPE)

endfunction()