include_guard(GLOBAL)

include(zlib)

IF (WIN32)
    # based on https://stackoverflow.com/a/41815728/4720732

    KyDepsInstall(openssl
            https://github.com/openssl/openssl.git
            OpenSSL_1_1_1k

            # avoid updating any of the git submodules ... we don't need them (also they make filenames too long on windows)
            GIT_SUBMODULES krb5 boringssl

            USES_TERMINAL_BUILD TRUE

            # TODO: figure out if we can't put some include directory...
            PATCH_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_BINARY_DIR}/install/zlib_${zlib_HASH}/include/zlib.h <SOURCE_DIR>/zlib.h
            COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_BINARY_DIR}/install/zlib_${zlib_HASH}/include/zconf.h <SOURCE_DIR>/zconf.h

            CONFIGURE_COMMAND ${CMAKE_COMMAND} -E chdir <SOURCE_DIR> ${CMAKE_BINARY_DIR}/build/src/perl/perl/bin/perl Configure VC-WIN64A-masm zlib no-shared no-zlib-dynamic threads --prefix=<INSTALL_DIR> --openssldir=<INSTALL_DIR> CC=cl ${CMAKE_C_FLAGS}

            # NOTE: there is some non-determinism in the configuration that looks like `RANLIB => "CODE(0x273a5f0)"`
            #       ranlib is not used on windows, so we just remove the lines about it to remove the non-determinism
            COMMAND ${CMAKE_COMMAND} -E chdir <SOURCE_DIR> ${CMAKE_BINARY_DIR}/build/src/perl/perl/bin/perl -pi.orig -e "s/RANLIB => .*,//g;" configdata.pm

            # NOTE: we cache the new configuration if it is different from last time.
            #       then we copy the cache over the new configuration.
            #       the effect is that if the configuration is unchanged, its timestamp does not increase!!!
            COMMAND ${CMAKE_COMMAND} -E copy_if_different <SOURCE_DIR>/configdata.pm <SOURCE_DIR>/configdata.cache
            # NOTE: we need a copy command that preserves the timestamp of the source...
            #       `cmake -E copy` does not
            #       the system one does... note we are in windows specific section here so using windows syntax
            COMMAND ${CMAKE_COMMAND} -E chdir <SOURCE_DIR> cmd /c "copy /y configdata.cache configdata.pm"

            # NOTE: this used to be necessary when building any linked artifacts (shared libraries, executables, etc.)
            #       because we only build static libraries, it is not needed anymore!
            # COMMAND ${CMAKE_COMMAND} -E chdir <SOURCE_DIR> <INSTALL_DIR>/src/perl/perl/bin/perl -pi.orig -e s/ZLIB1/zlib.lib/g; makefile

            BUILD_COMMAND ${CMAKE_COMMAND} -E chdir <SOURCE_DIR> nmake build_libs
            INSTALL_COMMAND ${CMAKE_COMMAND} -E chdir <SOURCE_DIR> nmake install_dev

            DEPENDS zlib)

    if (NOT KYDEPS_DOWNLOAD)
        ExternalProject_Add(
                perl
                URL https://strawberryperl.com/download/5.32.1.1/strawberry-perl-5.32.1.1-64bit-portable.zip
                PREFIX ${CMAKE_BINARY_DIR}/build

                USES_TERMINAL_DOWNLOAD TRUE

                CONFIGURE_COMMAND ""
                BUILD_COMMAND ""
                INSTALL_COMMAND ""
        )

        add_dependencies(openssl perl)
    endif ()
ELSE ()
    KyDepsInstallGit(https://github.com/openssl/openssl.git OpenSSL_1_1_1k
            CONFIGURE_COMMAND ${CMAKE_COMMAND} -E chdir <SOURCE_DIR> ./config no-shared no-dso --prefix=<INSTALL_DIR>/install --openssldir=<INSTALL_DIR>/install
            BUILD_COMMAND make -C <SOURCE_DIR> build_libs
            INSTALL_COMMAND make -C <SOURCE_DIR> install_dev)
ENDIF ()
