FROM php:5.6-alpine

# phpunit version
ENV PHPUNIT_VERSION 4.8

RUN apk update \
    && apk add --update --virtual autoconf \
    && apk add --no-cach bash \
    build-base \
    openrc \
    openssl \
    git \
    openssh

# Install xdebug
RUN apk add --no-cache $PHPIZE_DEPS \
	&& pecl install xdebug-2.5.5 \
	&& docker-php-ext-enable xdebug

# Install PHP Code Sniffer
RUN mkdir -p /root/src \
    && cd /root/src \
    && wget https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar \
    && wget https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar \
    && chmod +x phpcs.phar \
    && chmod +x phpcbf.phar \
    && mv phpcs.phar /usr/local/bin/phpcs \
    && mv phpcbf.phar /usr/local/bin/phpcbf \
    && phpcs --version \
    && phpcbf --version \
    && mkdir -p /usr/phpcs_standards \
    && git clone https://github.com/wimg/PHPCompatibility.git /usr/phpcs_standards/PHPCompatibility \
    && rm -rf /root/src \
    && phpcs --config-set installed_paths /usr/phpcs_standards/PHPCompatibility \
    && phpcs -i
