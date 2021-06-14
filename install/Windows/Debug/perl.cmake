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


KyDepsPopulate(perl 8970b13fd773396129a83c86df4bf3aed4e08e58
    "https://kydeps.s3.us-east-2.amazonaws.com/perl_8970b13fd773396129a83c86df4bf3aed4e08e58.zip"
    a0b443ffff892cf808d56edf3a300834f63829ee)

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/perl/perl_8970b13fd773396129a83c86df4bf3aed4e08e58/install")

find_package(perl REQUIRED NO_MODULE)
