include_guard(GLOBAL)

include(zlib)
include(openssl)

if (WIN32)
    add_link_options(crypt32.lib)
endif ()

KyDepsInstall(libssh
        GIT_REPOSITORY https://git.libssh.org/projects/libssh.git
        GIT_REF da6d026c125712d197479a7930b4efc117bfe7af # libssh-0.9.6

        DEPENDS zlib OpenSSL)
