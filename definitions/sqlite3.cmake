include_guard(GLOBAL)

set(SQLite3_FIND_OVERRIDE [[find_package(SQLite3 REQUIRED)]])

if (WIN32)
    file(WRITE ${CMAKE_BINARY_DIR}/sqlite3.CMakeLists.txt [[
            cmake_minimum_required(VERSION 3.20)
            project(sqlite3)

            add_library(sqlite3 sqlite3.c)
    ]])

    KyDepsInstall(SQLite3
            URL https://www.sqlite.org/2021/sqlite-amalgamation-3360000.zip
            URL_HASH 0c049c365896b71b6e291c9a262d2d0fbce7b4e6

            PATCH_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_BINARY_DIR}/sqlite3.CMakeLists.txt CMakeLists.txt
            INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different <BINARY_DIR>/sqlite3.lib <INSTALL_DIR>/lib/sqlite3.lib
            COMMAND ${CMAKE_COMMAND} -E copy_if_different <SOURCE_DIR>/sqlite3.h <INSTALL_DIR>/include/sqlite3.h)
else ()
    KyDepsInstall(SQLite3
            URL https://www.sqlite.org/2021/sqlite-autoconf-3360000.tar.gz
            URL_HASH a4bcf9e951bfb9745214241ba08476299fc2dc1e

            CONFIGURE_COMMAND <SOURCE_DIR>/configure --srcdir <SOURCE_DIR> --prefix <INSTALL_DIR>)
endif ()