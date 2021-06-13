#[[ -------------------------------------------

nginx
URL
http://nginx.org/download/nginx-1.20.1.zip
URL_HASH
SHA1=3571530609629e97d06a2c575c4724c7e1246273
REVISION
3571530609629e97d06a2c575c4724c7e1246273
FLAVOR
64-bit Windows Debug
HASH
85fd5a860268ba76bb744e4d086381816f2911a1

-------------------------------------------- ]]

include_guard(GLOBAL)


KyDepsPopulate(nginx 85fd5a860268ba76bb744e4d086381816f2911a1
    "file://C:/kamen/clion/kydeps_new/cmake-build-debug/_/nginx_85fd5a860268ba76bb744e4d086381816f2911a1/package.zip"
    bea3cfd7d117582cdcdcb03a76b2b87f02bd14ec)

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/nginx/nginx_85fd5a860268ba76bb744e4d086381816f2911a1/install")

#find_package(nginx REQUIRED NO_MODULE)
find_program(NGINX
        REQUIRED
        NAMES nginx
        PATHS "${CMAKE_BINARY_DIR}/.deps/nginx/nginx_85fd5a860268ba76bb744e4d086381816f2911a1/install"
        NO_DEFAULT_PATH)
