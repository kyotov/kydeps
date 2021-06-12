include_guard(GLOBAL)

KyDepsInstall(fmt
        GIT_REPOSITORY https://github.com/fmtlib/fmt.git
        GIT_REF 7.1.3

        CMAKE_ARGS
        -DFMT_TEST=FALSE)
