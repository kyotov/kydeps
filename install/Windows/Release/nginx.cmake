#[[ -------------------------------------------

nginx
URL
http://nginx.org/download/nginx-1.20.1.zip
URL_HASH
SHA1=3571530609629e97d06a2c575c4724c7e1246273
REVISION
3571530609629e97d06a2c575c4724c7e1246273
FLAVOR
64-bit Windows Release
HASH
5284c7d072eba4febc728eb18004c8e307b74d13

-------------------------------------------- ]]

include_guard(GLOBAL)


KyDepsPopulate(nginx 5284c7d072eba4febc728eb18004c8e307b74d13
    "file://C:/kamen/clion/kydeps_new/cmake-build-release/_/nginx_5284c7d072eba4febc728eb18004c8e307b74d13/package.zip"
    514e7b5e6d3e52d53b79a96afcc276850c8047c9)

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/nginx/nginx_5284c7d072eba4febc728eb18004c8e307b74d13/install")

find_package(nginx REQUIRED NO_MODULE)
