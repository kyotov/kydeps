message(NOTICE "KyDeps Local Build")

include(cmake/KyDepsCommon.cmake)

set(ROOT ".")
set(BUILD_TYPES Debug Release)

set_if_empty(KYDEPS_UPLOAD FALSE)
set_if_empty(KYDEPS_PACKAGE_CACHE_FROZEN FALSE)
set_if_empty(KYDEPS_PACKAGE_CACHE_DIRECTORY "${ROOT}/cache")

find_program(GIT NAMES git REQUIRED)

foreach (BUILD_TYPE ${BUILD_TYPES})
    set(BINARY_DIR "${ROOT}/build/${BUILD_TYPE}")
    file(MAKE_DIRECTORY "${BINARY_DIR}")

    execute_and_check(COMMAND ${CMAKE_COMMAND} -S ${ROOT} -B ${BINARY_DIR} -G Ninja
            -D KYDEPS_UPLOAD=${KYDEPS_UPLOAD}
            -D KYDEPS_PACKAGE_CACHE_FROZEN=${KYDEPS_PACKAGE_CACHE_FROZEN}
            -D CMAKE_BUILD_TYPE=${BUILD_TYPE})

    execute_and_check(COMMAND ${CMAKE_COMMAND} --build ${BINARY_DIR} --config ${BUILD_TYPE})
endforeach ()

execute_and_check(
        WORKING_DIRECTORY "${ROOT}/install"
        COMMAND ${GIT} commit -am "automated artifact update")

execute_and_check(
        WORKING_DIRECTORY "${ROOT}/install"
        COMMAND ${GIT} push origin HEAD:main)