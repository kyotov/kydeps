include_guard(GLOBAL)

include(zlib)

KyDepsInstall(protobuf
        https://github.com/protocolbuffers/protobuf.git
        v3.15.8

        DEPENDS zlib

        SOURCE_SUBDIR cmake

        CMAKE_ARGS
        -Dprotobuf_BUILD_TESTS=OFF
        -Dprotobuf_MSVC_STATIC_RUNTIME=ON)
