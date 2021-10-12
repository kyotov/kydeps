include_guard(GLOBAL)

include(zlib)

KyDepsInstall(protobuf
        GIT_REPOSITORY https://github.com/protocolbuffers/protobuf.git
        GIT_REF 436bd7880e458532901c58f4d9d1ea23fa7edd52 # v3.15.8

        SOURCE_SUBDIR cmake

        CMAKE_ARGS
        -Dprotobuf_BUILD_TESTS=OFF
        -Dprotobuf_MSVC_STATIC_RUNTIME=ON

        DEPENDS zlib)
