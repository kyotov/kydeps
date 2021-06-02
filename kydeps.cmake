include_guard(GLOBAL)

include(${CMAKE_CURRENT_LIST_DIR}/utils/KyDepsTools.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/utils/KyDepsOptions.cmake)

macro(kydeps PACKAGES)
    execute_process(
            COMMAND ${CMAKE_COMMAND}
            -S ${CMAKE_SOURCE_DIR}/kydeps
            -B ${CMAKE_BINARY_DIR}/kydeps
            -G ${CMAKE_GENERATOR}
            "-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
            "-DKYDEPS_DOWNLOAD=ON"
            "-DKYDEPS_PACKAGES=${PACKAGES}"
            RESULT_VARIABLE RESULT)
    check_result(${RESULT} "kydeps configure failure")

    execute_process(
            COMMAND ${CMAKE_COMMAND}
            --build ${CMAKE_BINARY_DIR}/kydeps
            --config ${CMAKE_BUILD_TYPE}
            RESULT_VARIABLE RESULT)
    check_result(${RESULT} "kydeps build failure")

    add_custom_target(kdeps_clean ALL)
    set_target_properties(kdeps_clean
            PROPERTIES ADDITIONAL_CLEAN_FILES ${CMAKE_BINARY_DIR}/kydeps)

    include(${CMAKE_BINARY_DIR}/kydeps/config.cmake)
endmacro()
