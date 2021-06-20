include_guard(GLOBAL)

set(nginx_BUILD_TYPE_OVERRIDE "Release")
set(nginx_FIND_OVERRIDE [[find_program(NGINX REQUIRED NAMES nginx)]])

if (WIN32)
    KyDepsInstall(nginx
            URL http://nginx.org/download/nginx-1.20.1.zip
            URL_HASH 3571530609629e97d06a2c575c4724c7e1246273

            CONFIGURE_COMMAND ${CMAKE_COMMAND} -E echo "skipped"
            BUILD_COMMAND ${CMAKE_COMMAND} -E echo "skipped"
            INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different <SOURCE_DIR>/nginx.exe <INSTALL_DIR>/nginx.exe)
else ()
    set(OPTIONS
            --without-select_module
            --without-poll_module
            --without-http_charset_module
            --without-http_gzip_module
            --without-http_ssi_module
            --without-http_userid_module
            --without-http_access_module
            --without-http_auth_basic_module
            --without-http_mirror_module
            --without-http_autoindex_module
            --without-http_geo_module
            --without-http_map_module
            --without-http_split_clients_module
            --without-http_referer_module
            --without-http_rewrite_module
            --without-http_proxy_module
            --without-http_fastcgi_module
            --without-http_uwsgi_module
            --without-http_scgi_module
            --without-http_grpc_module
            --without-http_memcached_module
            --without-http_limit_conn_module
            --without-http_limit_req_module
            --without-http_empty_gif_module
            --without-http_browser_module
            --without-http_upstream_hash_module
            --without-http_upstream_ip_hash_module
            --without-http_upstream_least_conn_module
            --without-http_upstream_random_module
            --without-http_upstream_keepalive_module
            --without-http_upstream_zone_module
            --without-http-cache
            --without-mail_pop3_module
            --without-mail_imap_module
            --without-mail_smtp_module
            --without-stream_limit_conn_module
            --without-stream_access_module
            --without-stream_geo_module
            --without-stream_map_module
            --without-stream_split_clients_module
            --without-stream_return_module
            --without-stream_set_module
            --without-stream_upstream_hash_module
            --without-stream_upstream_least_conn_module
            --without-stream_upstream_random_module
            --without-stream_upstream_zone_module
            --without-pcre)

    KyDepsInstall(nginx
            URL http://nginx.org/download/nginx-1.20.1.tar.gz
            URL_HASH 6b4ab4eff3c617e133819f43fdfc14708e593a79

            CONFIGURE_COMMAND ${CMAKE_COMMAND} -E chdir <SOURCE_DIR>
            ./configure --prefix=. --builddir=<BINARY_DIR> ${OPTIONS}

            BUILD_COMMAND ${CMAKE_COMMAND} -E chdir <SOURCE_DIR> make -j

            INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different <BINARY_DIR>/nginx <INSTALL_DIR>/nginx)
endif ()