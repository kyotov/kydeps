cmake_minimum_required(VERSION 3.18)

project(kydeps)

include("../utils/KyDepsTools.cmake")
include("../utils/KyDepsOptions.cmake")
include("../utils/KyDepsEpilogue.cmake")

check_not_empty(KYDEPS)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/../deps)
foreach (MODULE ${KYDEPS})
    include(${MODULE}.cmake)
endforeach ()

install(DIRECTORY ${CMAKE_BINARY_DIR}/install DESTINATION ".")

get_package_name("${CMAKE_SOURCE_DIR}" "${KYDEPS}" PACKAGE_NAME)
set(CPACK_PACKAGE_FILE_NAME "${PACKAGE_NAME}")
set(CPACK_GENERATOR ZIP)
include(CPack)
