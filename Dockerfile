FROM docker.productsup.com/cde/cde-php-cli-base:8.3

COPY src/ ./src
COPY config/ ./config
COPY bin/ ./bin
COPY .env composer.json composer.lock symfony.lock ./

RUN apt-get update && apt-get install -y jq

RUN wget https://github.com/duckdb/duckdb/releases/download/v1.0.0/duckdb_cli-linux-amd64.zip \
    && unzip duckdb_cli-linux-amd64.zip -d /usr/local/bin \
    && rm duckdb_cli-linux-amd64.zip
RUN duckdb -s "INSTALL json;LOAD json;"

ARG COMPOSER_AUTH=local
RUN composer install --no-dev
RUN bin/console cache:warmup --env=prod

CMD ["php", "bin/console"]