FROM ruby:2.5.3-slim AS builder
ARG APP_HOME=/aws_demo_app
RUN apt-get update -qq \
  && apt-get install -y \
    libpq-dev \
    build-essential \
    nodejs
WORKDIR $APP_HOME
COPY Gemfile* $APP_HOME/
RUN bundle install
COPY . $APP_HOME

FROM ruby:2.5.3-slim
ARG APP_HOME=/aws_demo_app
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
WORKDIR /aws_demo_app
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=builder /aws_demo_app/ /aws_demo_app/

CMD bin/rails s -p ${PORT} -b '0.0.0.0'
