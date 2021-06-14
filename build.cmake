message(NOTICE "KyDeps Local Build")

include(cmake/KyDepsCommon.cmake)

set(ROOT ".")
set(BUILD_TYPES Debug Release)

set_if_empty(KYDEPS_UPLOAD FALSE)
set_if_empty(KYDEPS_PACKAGE_CACHE_FROZEN FALSE)
set_if_empty(KYDEPS_PACKAGE_CACHE_DIRECTORY "${ROOT}/cache")

foreach (BUILD_TYPE ${BUILD_TYPES})
    set(BINARY_DIR "${ROOT}/build/${BUILD_TYPE}")
    file(MAKE_DIRECTORY "${BINARY_DIR}")

    execute_and_check(${CMAKE_COMMAND} -S ${ROOT} -B ${BINARY_DIR} -G Ninja -D CMAKE_BUILD_TYPE=${BUILD_TYPE})
    execute_and_check(${CMAKE_COMMAND} --build ${BINARY_DIR} --config ${BUILD_TYPE})
endforeach ()
