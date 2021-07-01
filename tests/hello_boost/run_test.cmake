function(main)

    set(SOURCE_DIR ${CMAKE_CURRENT_FUNCTION_LIST_DIR})

    file(REMOVE_RECURSE "${BINARY_DIR}")
    execute_process(
            COMMAND "${CMAKE_COMMAND}" -D "CMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}" -S "${SOURCE_DIR}" -B "${BINARY_DIR}"
            RESULT_VARIABLE EXIT_CODE)
    if (NOT "${EXIT_CODE}" STREQUAL "0")
        message(FATAL_ERROR "configure error")
    endif ()

    execute_process(
            COMMAND "${CMAKE_COMMAND}" --build "${BINARY_DIR}"
            RESULT_VARIABLE EXIT_CODE)
    if (NOT "${EXIT_CODE}" STREQUAL "0")
        message(FATAL_ERROR "build error")
    endif ()

    execute_process(
            COMMAND "${CMAKE_COMMAND}" --build "${BINARY_DIR}" --target run
            RESULT_VARIABLE EXIT_CODE)
    if (NOT "${EXIT_CODE}" STREQUAL "0")
        message(FATAL_ERROR "run error")
    endif ()

endfunction()

main()