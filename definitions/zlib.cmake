include_guard(GLOBAL)

KyDepsInstall(zlib
        GIT_REPOSITORY https://github.com/kyotov/zlib.git
        GIT_REF 68cf39d20a32cf9659e62b10f95fccc0575b0b31 # kyotov-fix

        CMAKE_ARGS
        -DAMD64=TRUE)
