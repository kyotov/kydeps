include_guard(GLOBAL)

macro(FetchAndPopulate NAME)
    FetchContent_Declare(${NAME} ${ARGN})
    FetchContent_GetProperties(${NAME})
    if (NOT ${NAME}_POPULATED)
        FetchContent_Populate(${NAME})
    endif ()
endmacro()

function(KyDepsBoot)

    set(options USE_PREBUILT_PACKAGE)
    set(singeValueArgs PREBUILT_URL_PREFIX SOURCE_DIR BINARY_DIR)
    set(multiValueArgs DEPENDS)
    cmake_parse_arguments(KYDEPS "${options}" "${singleValueArgs}" "${multiValueArgs}" ${ARGN})

    message(${ARGN})

    if (NOT DEFINED KYDEPS_PREBUILT_URL_PREFIX)
        set(KYDEPS_PREBUILT_URL_PREFIX "file://${CMAKE_BINARY_DIR}")
    endif ()

    include(${KYDEPS_SOURCE_DIR}/utils/KyDepsPackage.cmake)
    get_package_name("${KYDEPS_SOURCE_DIR}" "${KYDEPS_DEPENDS}" KYDEPS_PACKAGE_NAME)

    if (${KYDEPS_USE_PREBUILT_PACKAGE})
        FetchAndPopulate(kydeps_prebuilt
                URL "${KYDEPS_PREBUILT_URL_PREFIX}/${KYDEPS_PACKAGE_NAME}.zip")

        set(CMAKE_PREFIX_PATH "${kydeps_prebuilt_SOURCE_DIR}/deps/install" PARENT_SCOPE)
    else ()
        execute_process(
                COMMAND_ECHO STDOUT
                COMMAND ${CMAKE_COMMAND}
                -S ${KYDEPS_SOURCE_DIR}
                -B ${KYDEPS_BINARY_DIR}
                -G ${CMAKE_GENERATOR}
                -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                "-DKYDEPS=${KYDEPS_DEPENDS}")

        execute_process(
                COMMAND ${CMAKE_COMMAND} --build ${KYDEPS_BINARY_DIR} --target package)
        execute_process(
                COMMAND ${CMAKE_COMMAND} -E copy_if_different ${KYDEPS_BINARY_DIR}/${KYDEPS_PACKAGE_NAME}.zip ${CMAKE_BINARY_DIR}/${KYDEPS_PACKAGE_NAME}.zip)

        set(CMAKE_PREFIX_PATH "${KYDEPS_BINARY_DIR}/install" PARENT_SCOPE)
    endif ()

endfunction()
