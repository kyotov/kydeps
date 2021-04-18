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
    set(singleValueArgs PREBUILT_URL_PREFIX SOURCE_DIR BINARY_DIR)
    set(multiValueArgs DEPENDS)
    cmake_parse_arguments(KYDEPS "${options}" "${singleValueArgs}" "${multiValueArgs}" ${ARGN})

    if (NOT DEFINED KYDEPS_PREBUILT_URL_PREFIX)
        set(KYDEPS_PREBUILT_URL_PREFIX "file://${CMAKE_BINARY_DIR}")
    endif ()

    include(${KYDEPS_SOURCE_DIR}/utils/KyDepsPackage.cmake)
    get_package_name("${KYDEPS_SOURCE_DIR}" "${KYDEPS_DEPENDS}" KYDEPS_PACKAGE_NAME)

    if (NOT ${KYDEPS_USE_PREBUILT_PACKAGE})
        if (NOT EXISTS ${CMAKE_BINARY_DIR}/${KYDEPS_PACKAGE_NAME}.zip)
            message(STATUS "didn't find ${KYDEPS_PACKAGE_NAME}.zip in ${CMAKE_BINARY_DIR}. building it...")

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
        else ()
            message(STATUS "found ${KYDEPS_PACKAGE_NAME}.zip in ${CMAKE_BINARY_DIR}. going to use it...")
        endif ()
    endif ()

    # TODO: skip the population if it is "up-to-date"... particularly important when remote and fetching is expensive
    #       https://app.asana.com/0/1200197137515364/1200201316220330/f
    FetchAndPopulate(kydeps_prebuilt
            URL "${KYDEPS_PREBUILT_URL_PREFIX}/${KYDEPS_PACKAGE_NAME}.zip")

    set(CMAKE_PREFIX_PATH "${kydeps_prebuilt_SOURCE_DIR}/deps/install" PARENT_SCOPE)

endfunction()
