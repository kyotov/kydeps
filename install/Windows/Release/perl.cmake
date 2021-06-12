#[[ -------------------------------------------

perl
URL
https://strawberryperl.com/download/5.32.1.1/strawberry-perl-5.32.1.1-64bit-portable.zip
URL_HASH
SHA1=fac226b31461f2392702822052a3a5628917f857
REVISION
fac226b31461f2392702822052a3a5628917f857
FLAVOR
64-bit Windows Release
HASH
fc6dec7e8728ff02b2f044baa7d5b14b215f52ca

-------------------------------------------- ]]

include_guard(GLOBAL)


KyDepsPopulate("perl"
    "file://C:/kamen/clion/kydeps_new/cmake-build-release/_/perl_fc6dec7e8728ff02b2f044baa7d5b14b215f52ca/package.zip"
    "4cfe48d16e58db9ee2a2351558bc38eecc987586")

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/perl/perl_fc6dec7e8728ff02b2f044baa7d5b14b215f52ca/install")

find_package(perl REQUIRED NO_MODULE)
