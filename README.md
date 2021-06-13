# TODO

WIP: This is outdated... needs to be refreshed.

* introduce a mixed mode where we downloaded if available and build otherwise
* introduce different types of dependencies (build time vs. runtime) 

# kydeps

TL;DR:

1. create a new cmake-based project
    1. add kydeps submodule with `git submodule add https://github.com/kyotov/kydeps.git kydeps`
    1. create a `main.cpp` as follows:
        ```c++
        #include <glog/logging.h>
        
        int main() {
            LOG(INFO) << "Hello, World!" << std::endl;
            return 0;
        }
        ```
    1. create a `CMakeLists.txt` as follows:
        ```cmake
        cmake_minimum_required(VERSION 3.18)
        
        project(kydeps_test)
        
        set(CMAKE_CXX_STANDARD 20)
        
        include(kydeps/KyDeps.cmake)
        KyDeps(#CACHED
            DEPENDS gflags glog
            EXPECTED_SHA256 f4a3efc5d13a420d75aa64d319ae9ef14fe26420872bd86664666e05a323cf0d)
        
        add_executable(kydeps_test main.cpp)
        target_link_libraries(kydeps_test
            gflags
            glog::glog)
        ```
    1. configure the project with `cmake -STATEMENT ... -B ...`. among other things, this will:
        1. build `gflags` and `glog` as external projects
        1. make them available to your code using `find_package`
        1. generate `<git-sha>-<os>-Debug-gflags-glog.zip`

    1. build the project with `cmake --build ...`
    1. execute the example binary

If you update the `kydeps` submodule to revision `e3eaecfddc822b46f4b330876e9709e49586156b` 
you may be able to play with uncommenting `CACHED` in the makefile and the dependencies will be
downloaded from AWS/S3 instead of built.

> // find_package(nginx REQUIRED NO_MODULE)
```cmake
find_program(NGINX
    REQUIRED
    NAMES nginx
    PATHS "${CMAKE_BINARY_DIR}/.deps/nginx/nginx_85fd5a860268ba76bb744e4d086381816f2911a1/install"
    NO_DEFAULT_PATH)
```
