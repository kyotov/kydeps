message(NOTICE "KyDeps Local Build")

include(cmake/KyDepsCommon.cmake)

set(ROOT ".")
set(BUILD_TYPES Debug Release)

set_if_empty(KYDEPS_TARGET all)
set_if_empty(KYDEPS_UPLOAD FALSE)
set_if_empty(KYDEPS_PACKAGE_CACHE_DIRECTORY "${ROOT}/build/cache")

get_filename_component(KYDEPS_PACKAGE_CACHE_DIRECTORY "${KYDEPS_PACKAGE_CACHE_DIRECTORY}" ABSOLUTE)

find_program(GIT NAMES git REQUIRED)

foreach (BUILD_TYPE ${BUILD_TYPES})
    set(BINARY_DIR "${ROOT}/build/${BUILD_TYPE}")
    file(MAKE_DIRECTORY "${BINARY_DIR}")

    execute_and_check(COMMAND ${CMAKE_COMMAND} -S ${ROOT} -B ${BINARY_DIR} -G Ninja
            -D KYDEPS_UPLOAD=${KYDEPS_UPLOAD}
            -D KYDEPS_PACKAGE_CACHE_DIRECTORY=${KYDEPS_PACKAGE_CACHE_DIRECTORY}
            -D CMAKE_BUILD_TYPE=${BUILD_TYPE})

    execute_and_check(COMMAND ${CMAKE_COMMAND} --build ${BINARY_DIR} --config ${BUILD_TYPE} --target ${KYDEPS_TARGET})
endforeach ()

if (KYDEPS_UPLOAD)
    execute_and_check(
            WORKING_DIRECTORY "${ROOT}/install"
            COMMAND ${GIT} pull --ff-only origin main)

    execute_and_check(
            WORKING_DIRECTORY "${ROOT}/install"
            COMMAND ${GIT} add .)

    execute_and_check(
            WORKING_DIRECTORY "${ROOT}/install"
            COMMAND ${GIT} commit -m "automated artifact update")

    execute_and_check(
            WORKING_DIRECTORY "${ROOT}/install"
            COMMAND ${GIT} push origin HEAD:main)
endif ()