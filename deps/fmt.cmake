include_guard(GLOBAL)

KyDepsInstall(fmt
        https://github.com/fmtlib/fmt.git
        7.1.3

        CMAKE_ARGS
        -DFMT_TEST=FALSE)
