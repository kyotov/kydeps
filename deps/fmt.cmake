include_guard(GLOBAL)

include(gflags)

KyDepsInstall(
        https://github.com/fmtlib/fmt.git
        7.1.3

        CMAKE_ARGS
        -DFMT_TEST=FALSE)


