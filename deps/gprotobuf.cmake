include_guard(GLOBAL)

KyDepsInstall(
        https://github.com/protocolbuffers/protobuf.git
        v3.15.8

        SOURCE_SUBDIR cmake

        CMAKE_ARGS
        -Dprotobuf_BUILD_TESTS=OFF
        -Dprotobuf_MSVC_STATIC_RUNTIME=ON)
