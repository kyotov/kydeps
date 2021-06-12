include_guard(GLOBAL)

KyDepsInstall(nginx
        URL http://nginx.org/download/nginx-1.20.1.zip
        URL_HASH 3571530609629e97d06a2c575c4724c7e1246273

        CONFIGURE_COMMAND ${CMAKE_COMMAND} -E echo "skipped"
        BUILD_COMMAND ${CMAKE_COMMAND} -E echo "skipped"
        INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR> <INSTALL_DIR>)
