#[[ -------------------------------------------

perl
URL
https://strawberryperl.com/download/5.32.1.1/strawberry-perl-5.32.1.1-64bit-portable.zip
URL_HASH
SHA1=fac226b31461f2392702822052a3a5628917f857
REVISION
fac226b31461f2392702822052a3a5628917f857
FLAVOR
64-bit Windows Debug
HASH
8970b13fd773396129a83c86df4bf3aed4e08e58

-------------------------------------------- ]]

include_guard(GLOBAL)


KyDepsPopulate("perl"
    "file://C:/kamen/clion/kydeps_new/cmake-build-debug/_/perl_8970b13fd773396129a83c86df4bf3aed4e08e58/package.zip"
    "c035f56befc37e8b0d124d4dae2b7dea77a01590")

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/perl/perl_8970b13fd773396129a83c86df4bf3aed4e08e58/install")

find_package(perl REQUIRED NO_MODULE)
