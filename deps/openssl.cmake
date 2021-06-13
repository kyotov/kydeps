include_guard(GLOBAL)

include(zlib)

set(OpenSSL_FIND_OVERRIDE [[find_package(OpenSSL REQUIRED)]])
set(OpenSSL_DEPENDS_OVERRIDE zlib)

if (WIN32)
    # based on https://stackoverflow.com/a/41815728/4720732

    KyDepsInstall(perl
            URL https://strawberryperl.com/download/5.32.1.1/strawberry-perl-5.32.1.1-64bit-portable.zip
            URL_HASH fac226b31461f2392702822052a3a5628917f857

            CONFIGURE_COMMAND ${CMAKE_COMMAND} -E echo "skipped"
            BUILD_COMMAND ${CMAKE_COMMAND} -E echo "skipped"
            INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR> <INSTALL_DIR>)

    set(BIN_PERL "${perl_ROOT_PATH}/install/perl/bin/perl")

    KyDepsInstall(OpenSSL
            GIT_REPOSITORY https://github.com/openssl/openssl.git
            GIT_REF OpenSSL_1_1_1k

            # avoid updating any of the git submodules ... we don't need them (also they make filenames too long on windows)
            GIT_SUBMODULES " " #krb5 boringssl

            USES_TERMINAL_BUILD TRUE

            CONFIGURE_COMMAND ${CMAKE_COMMAND} -E chdir <SOURCE_DIR> ${BIN_PERL} Configure VC-WIN64A-masm zlib no-shared no-zlib-dynamic threads --prefix=<INSTALL_DIR> --openssldir=<INSTALL_DIR> CC=@cl ${CMAKE_C_FLAGS} -I${zlib_ROOT_PATH}/install/include

            # NOTE: there is some non-determinism in the configuration that looks like `RANLIB => "CODE(0x273a5f0)"`
            #       ranlib is not used on windows, so we just remove the lines about it to remove the non-determinism
            COMMAND ${CMAKE_COMMAND} -E chdir <SOURCE_DIR> ${BIN_PERL} -pi.orig -e "s/RANLIB => .*,//g;" configdata.pm

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
            INSTALL_COMMAND ${CMAKE_COMMAND} -E chdir <SOURCE_DIR> nmake install_dev > install.log

            DEPENDS perl zlib)
else ()
    KyDepsInstall(OpenSSL
            GIT_REPOSITORY https://github.com/openssl/openssl.git
            GIT_REF OpenSSL_1_1_1k

            CONFIGURE_COMMAND ${CMAKE_COMMAND} -E chdir <SOURCE_DIR> ./config no-shared no-dso --prefix=<INSTALL_DIR> --openssldir=<INSTALL_DIR>
            BUILD_COMMAND make -C <SOURCE_DIR> build_libs
            INSTALL_COMMAND make -C <SOURCE_DIR> install_dev

            DEPENDS zlib)
endif ()
