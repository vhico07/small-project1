FROM php:7.4-fpm-alpine

MAINTAINER Vhico <vhicoputra.vp@gmail.com>

# Install some dependencies
RUN apk --update add \
  git \
  supervisor \
  nginx \
  nano \
  curl

# Enable PHP extensions
RUN docker-php-ext-install \
  opcache \
  bcmath \
  pdo_mysql \
  pcntl


# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf
RUN rm /etc/nginx/conf.d/default.conf

# Configure php-fpm
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/www.conf
COPY config/php.ini /etc/php7/conf.d/custom.ini

# Configure supervisor
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Set our workdir
WORKDIR /var/www/html

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody.nobody /var/www/html && \
  chown -R nobody.nobody /run && \
  chown -R nobody.nobody /var/lib/nginx && \
  chown -R nobody.nobody /var/log/nginx

# Switch to use a non-root user from here on
USER nobody

COPY --chown=nobody . /var/www/html/

# Expose ports
EXPOSE 8080

# Let supervisord start nginx & php-fpm
CMD [ "supervisord", "--nodaemon", "-c", "/etc/supervisor/conf.d/supervisord.conf" ]


