FROM ruby:2.7.2
LABEL maintainer="kleinjm007@gmail.com"

RUN apt-get update -yqq && \
    apt-get install -yqq --no-install-recommends \
    nodejs

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update && apt install yarn

COPY Gemfile* /usr/src/app/
WORKDIR /usr/src/app

RUN bundle install
RUN rails webpacker:install

COPY . /usr/src/app/

CMD ["bin/rails", "s", "-b", "0.0.0.0"]
