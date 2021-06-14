#[[ -------------------------------------------

httplib
GIT_REPOSITORY
https://github.com/kyotov/cpp-httplib.git
GIT_TAG
v0.8.9-windows-patch
REVISION
2e4fbb5c286a3cad5e7f88304ffc0acfe2b8575c
FLAVOR
64-bit Windows Release
DEPENDS
OpenSSL 47e39a4fec1130d9be561c1056a305e8bed34e46
HASH
04c49d52c477018d0758caa604c21df7e6dff257

-------------------------------------------- ]]

include_guard(GLOBAL)

include(OpenSSL)

KyDepsPopulate(httplib 04c49d52c477018d0758caa604c21df7e6dff257
    "file://C:/kamen/clion/kydeps_new/build/Release/_/httplib_04c49d52c477018d0758caa604c21df7e6dff257/package.zip"
    ec5806d418fdd606251c774188346a9fa93af42d)

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/httplib/httplib_04c49d52c477018d0758caa604c21df7e6dff257/install")

find_package(httplib REQUIRED NO_MODULE)
