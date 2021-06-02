FROM ruby:2.7.2
LABEL maintainer="kleinjm007@gmail.com"

# Allow apt to work with https-based sources
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
    apt-transport-https

# Ensure we install an up-to-date version of Node
# See https://github.com/yarnpkg/yarn/issues/2888
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -

# Ensure latest packages for Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | \
  tee /etc/apt/sources.list.d/yarn.list

# Install packages
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  nodejs \
  yarn

# Copy the Gemfile and Gemfile.lock first to cache the gem list and prevent
# re-bundling
COPY Gemfile* /usr/src/app/
# Set the working directory inside the docker container
WORKDIR /usr/src/app
# Set BUNDLE_PATH env var to value `/gem`
ENV BUNDLE_PATH /gem
RUN bundle install

# Sync the pwd from the host to the app directory in the Docker container
COPY . /usr/src/app/

# ENTRYPOINT is a command to prepend to the CMD run upon starting a new container
ENTRYPOINT ["./docker-entrypoint.sh"]
# The command to run when strating the container
CMD ["bin/rails", "s", "-b", "0.0.0.0"]
