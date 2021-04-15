cmake_minimum_required(VERSION 3.18)

project(kydeps
        VERSION 1.0)

include(KyDeps.cmake)

if ("${KYDEPS}" STREQUAL "")
    set(KYDEPS gflags)
endif ()

KyDepsAdd(${KYDEPS}) # gflags glog gprotobuf gtest httplib openssl xxhash zlib zstd

install(DIRECTORY ${CMAKE_BINARY_DIR}/install
        DESTINATION deps)

include(KyDepsPackage)

get_package_name(${CMAKE_SOURCE_DIR} "${KYDEPS}" CPACK_PACKAGE_FILE_NAME)

set(CPACK_GENERATOR ZIP)

#set(CPACK_PACKAGE_FILE_NAME "${GIT_REVISION}-${CMAKE_SYSTEM_NAME}-${CMAKE_BUILD_TYPE}-${KYDEPS}")
#set(CPACK_PACKAGE_FILE_NAME "${GIT_REVISION}-${CMAKE_SYSTEM_NAME}-${CMAKE_BUILD_TYPE}-${KYDEPS}")

include(CPack)
