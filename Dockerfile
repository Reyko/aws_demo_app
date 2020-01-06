FROM ruby:2.5.3

ENV APP_HOME /aws_demo_app

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


RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install

ADD . $APP_HOME

CMD bundle exec rails s -p ${PORT} -b '0.0.0.0'
