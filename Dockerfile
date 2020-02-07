FROM ruby:2.5.3 AS builder
ENV APP_HOME /aws_demo_app
RUN apt-get update -qq \
  && apt-get install -y \
    libpq-dev \
    build-essential \
    nodejs
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/
RUN bundle install
ADD . $APP_HOME

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
RUN mkdir /aws_demo_app
WORKDIR /aws_demo_app
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=builder /aws_demo_app/ /aws_demo_app/

CMD bin/rails s -p ${PORT} -b '0.0.0.0'
