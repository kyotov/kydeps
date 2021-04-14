cmake_minimum_required(VERSION 3.18)

project(kydeps
        VERSION 1.0)

include(KyDeps.cmake)

KyDepsAdd(
        gflags
#        glog
#        gprotobuf
#        gtest

#        httplib
#        openssl
#        xxhash
#        zlib
#       zstd
)

install(DIRECTORY ${CMAKE_BINARY_DIR}/install
        DESTINATION package)

set(CPACK_GENERATOR ZIP)
set(CPACK_PACKAGE_FILE_NAME "${CMAKE_PROJECT_NAME}-${CMAKE_PROJECT_VERSION}-${CMAKE_BUILD_TYPE}-${CMAKE_SYSTEM_NAME}")

include(CPack)
