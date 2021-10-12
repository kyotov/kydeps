include_guard(GLOBAL)

KyDepsInstall(fmt
        GIT_REPOSITORY https://github.com/fmtlib/fmt.git
        GIT_REF 7bdf0628b1276379886c7f6dda2cef2b3b374f0b # 7.1.3

        CMAKE_ARGS
        -DFMT_TEST=FALSE)
