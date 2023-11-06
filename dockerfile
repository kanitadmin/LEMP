FROM php:8.0-fpm
ENV TZ=Asia/Bangkok

ENV PHP_MAX_EXECUTION_TIME=60
ENV PHP_MAX_INPUT_VARS=10000
ENV PHP_MEMORY_LIMIT=256M
ENV PHP_POST_MAX_FILESIZE=256M
ENV PHP_UPLOAD_MAX_FILESIZE=50M
ENV PHP_MAX_INPUT_TIME=60
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN sed -ri -e 's|max_execution_time = 30|max_execution_time = ${PHP_MAX_EXECUTION_TIME}|g' "$PHP_INI_DIR/php.ini"
RUN sed -ri -e 's|;max_input_vars = 1000|max_input_vars = ${PHP_MAX_INPUT_VARS}|g' "$PHP_INI_DIR/php.ini"
RUN sed -ri -e 's|memory_limit = 128M|memory_limit = ${PHP_MEMORY_LIMIT}|g' "$PHP_INI_DIR/php.ini"
RUN sed -ri -e 's|post_max_size = 8M|post_max_size = ${PHP_POST_MAX_FILESIZE}|g' "$PHP_INI_DIR/php.ini"
RUN sed -ri -e 's|upload_max_filesize = 2M|upload_max_filesize = ${PHP_UPLOAD_MAX_FILESIZE}|g' "$PHP_INI_DIR/php.ini"
RUN sed -ri -e 's|max_input_time = 60|max_input_time = ${PHP_MAX_INPUT_TIME}|g' "$PHP_INI_DIR/php.ini"
RUN sed -ri -e 's|;date.timezone =|date.timezone = "Asia/Bangkok"|g' "$PHP_INI_DIR/php.ini"
RUN sed -ri -e 's|;sys_temp_dir = "/tmp"|sys_temp_dir = "/tmp"|g' "$PHP_INI_DIR/php.ini"
RUN sed -ri -e 's|MinProtocol = TLSv1.2|MinProtocol = TLSv1.0|g' "/etc/ssl/openssl.cnf"

RUN apt-get update && apt-get -y install apt-transport-https wget nano cron iputils-ping
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions
RUN install-php-extensions apcu bcmath bz2 calendar decimal exif gd gettext gmp igbinary imagick intl json_post ldap mcrypt memcache memcached msgpack mysqli oci8 shmop snmp soap sockets sodium sysvmsg sysvsem sysvshm tidy uuid xlswriter xmldiff xmlrpc xsl yaml zip opcache csv ffi ion pcntl
RUN install-php-extensions @composer

RUN echo 'pdo_sqlsrv.client_buffer_max_kb_size=524288' >> /usr/local/etc/php/conf.d/docker-php-ext-pdo_sqlsrv.ini
RUN echo 'client_buffer_max_kb_size=524288' >> /usr/local/etc/php/conf.d/docker-php-ext-pdo_sqlsrv.ini
RUN echo 'pdo_sqlsrv.client_buffer_max_kb_size=524288' >> /usr/local/etc/php/conf.d/docker-php-ext-sqlsrv.ini
RUN echo 'client_buffer_max_kb_size=524288' >> /usr/local/etc/php/conf.d/docker-php-ext-sqlsrv.ini