FROM ruby:2.5.3

RUN apt-get update -qq \
  && apt-get install -y \
    libpq-dev \
    build-essential \
    nodejs \
  && apt-get clean autoclean \
  && apt-get autoremove \
  && rm -rf /var/lib/get \
            /var/lib/log \
            /var/lib/dpkg \
            /var/lib/cache

ENV APP_HOME /aws_demo_app

ENV BUNDLE_PATH=/box \
    BUNDLE_BIN=/box/bin \
    GEM_HOME=/box
ENV PATH="${BUNDLE_BIN}:${PATH}"

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD . $APP_HOME
