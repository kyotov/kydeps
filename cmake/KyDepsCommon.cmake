include_guard(GLOBAL)

find_program(GIT NAMES git REQUIRED)

#-------------------- parent_scope

macro(parent_scope NAME)
    message(DEBUG "${NAME} -> ${${NAME}}")
    set(${NAME} ${${NAME}} PARENT_SCOPE)
endmacro()

#-------------------- execute_and_check

function(execute_and_check)
    cmake_parse_arguments(X
            ""
            "OUTPUT_VARIABLE"
            "COMMAND"
            ${ARGN})

    message(DEBUG "RUNNING: ${X_COMMAND} | ${X_UNPARSED_ARGUMENTS}")

    if (DEFINED X_OUTPUT_VARIABLE)
        set(OUTPUT_VARIABLE_CLAUSE OUTPUT_VARIABLE ${X_OUTPUT_VARIABLE})
    endif ()

    execute_process(
            RESULT_VARIABLE EXIT_CODE
            ${OUTPUT_VARIABLE_CLAUSE}
            COMMAND ${X_COMMAND}
            ${X_UNPARSED_ARGUMENTS})

    if (NOT EXIT_CODE EQUAL 0)
        message(FATAL_ERROR "FAILED(${EXIT_CODE}): ${X_COMMAND}")
    endif ()

    if (DEFINED X_OUTPUT_VARIABLE)
        parent_scope(${X_OUTPUT_VARIABLE})
    endif ()

endfunction()

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

#-------------------- get_git_revision

function(get_git_revision GIT_REPO_DIRECTORY GIT_REF GIT_REVISION)

    execute_and_check(
            OUTPUT_VARIABLE ${GIT_REVISION}
            OUTPUT_STRIP_TRAILING_WHITESPACE
            WORKING_DIRECTORY "${GIT_REPO_DIRECTORY}"
            COMMAND "${GIT}" log -n 1 --format=%H "${GIT_REF}")

    parent_scope(${GIT_REVISION})

endfunction()
