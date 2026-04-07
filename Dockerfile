FROM ruby:3.4.7 AS base

WORKDIR /usr/src

RUN apt-get update -qq \
  && apt-get install -yq --no-install-recommends \
    build-essential \
    git

RUN mkdir -p lib/omniauth/infinum_azure
COPY lib/omniauth/infinum_azure/version.rb ./lib/omniauth/infinum_azure/version.rb
COPY Gemfile omniauth-infinum_azure.gemspec ./

RUN bundle install
