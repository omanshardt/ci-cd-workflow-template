# Basisimage PHP 8.3 + Apache
FROM php:8.3-apache

# Arbeitsverzeichnis
WORKDIR /var/www/html

# Paketliste aktualisieren und Basiswerkzeuge installieren
RUN apt-get update && apt-get install -y \
  wget \
  less \
  unzip \
  nano

# Apache Module aktivieren
RUN a2enmod rewrite ssl

# PHP MySQL Extension installieren
RUN docker-php-ext-install pdo_mysql

# Composer installieren
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === 'c8b085408188070d5f52bcfe4ecfbee5f727afa458b2573b8eaaf77b3419b0bf2768dc67c86944da1544f06fa544fd47') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); exit(1); }" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer

# Apache VirtualHost kopieren
COPY ./docker/apache/ssl/server.crt /etc/apache2/ssl/server.crt
COPY ./docker/apache/ssl/server.key /etc/apache2/ssl/server.key
COPY ./docker/apache/apache.conf /etc/apache2/sites-enabled/000-default.conf

# Standardbefehl: Apache im Vordergrund
CMD ["apache2-foreground"]
