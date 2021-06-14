include_guard(GLOBAL)

#-------------------- execute_and_check

function(execute_and_check)
    set(COMMAND ${ARGN})
    message(STATUS "RUNNING: ${COMMAND}")
    execute_process(
            COMMAND ${COMMAND}
            RESULT_VARIABLE EXIT_CODE)
    if (NOT EXIT_CODE EQUAL 0)
        message(FATAL_ERROR "FAILED: ${COMMAND}")
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

#-------------------- parent_scope

macro(parent_scope NAME)
    message(DEBUG "${NAME} -> ${${NAME}}")
    set(${NAME} ${${NAME}} PARENT_SCOPE)
endmacro()

