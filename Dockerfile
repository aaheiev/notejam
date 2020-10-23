# docker build -t notejam .

FROM ruby:1.9.3

# APP
ARG http_port=3000
ARG app_group=notejam
ARG app_user=notejam
ARG app_home=/notejam
ARG uid=1000
ARG gid=1000

# CI
ARG product_version=0.0.1
ARG assembly_version=0.0.1.1

ENV APP_HOME         $app_home
ENV HTTP_PORT        $http_port
ENV HEALTHCHECK_URL  "http://127.0.0.1:${http_port}"
ENV PRODUCT_VERSION  $product_version
ENV ASSEMBLY_VERSION $assembly_version
ENV WEB_CONCURRENCY  2
ENV RAILS_ENV        "test"

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs \
    && groupadd -g ${gid} ${app_group} \
    && useradd -d "$APP_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${app_user} \
    && chown ${uid}:${gid} $APP_HOME

WORKDIR $APP_HOME

COPY . $APP_HOME/

RUN bundle install
RUN rake test
RUN chown -R ${app_user}:${app_group} $APP_HOME

EXPOSE ${http_port}

USER ${app_user}

ENTRYPOINT bin/rake db:migrate \
    && bundle exec rails server -b 0.0.0.0 -p $HTTP_PORT

HEALTHCHECK --interval=15s --timeout=5s --retries=10 CMD curl --silent --fail "${HEALTHCHECK_URL}" || exit 1
