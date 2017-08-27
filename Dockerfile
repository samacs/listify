FROM ruby:2.4.1-alpine

ENV BUILD_PACKAGES="curl-dev ruby-dev build-base" \
    DEV_PACKAGES="zlib-dev libxml2-dev libxslt-dev tzdata yaml-dev sqlite-dev postgresql-dev mysql-dev nodejs"

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apk --update --upgrade add $BUILD_PACKAGES $DEV_PACKAGES

RUN mkdir /listify
WORKDIR /listify

COPY Gemfile Gemfile.lock ./

ENV BUNDLE_GEMFILE=/listify/Gemfile \
    BUNDLE_JOBS=2 \
    BUNDLE_PATH=/bundle

RUN bundle install --binstubs

COPY . .

CMD bundle exec puma -C config/puma.rb
