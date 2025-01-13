# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
#ARG RUBY_VERSION=3.2.2
#FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim-bookworm as base

FROM ghcr.io/moritzheiber/ruby-jemalloc:3.3.6-slim AS base

#RUN gem install foreman

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# Install gnupg and receive keys
# RUN apt-get update -qq && apt-get install gnupg
# RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys \
#         0E98404D386FA1D9 6ED0E7B82643E131 F8D2585B8783D481 \
#         54404762BBB6E853 BDE6D2B9216EC7A8

# Install packages needed to build gems
RUN apt-get update -qq
RUN apt-get install --no-install-recommends -y \
        build-essential git libvips pkg-config \
        libpq-dev libsqlite3-dev libmariadb-dev \
        imagemagick  && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install application gems
COPY ./build/Gemfile ./build/Gemfile.lock ./
RUN bundle lock --add-platform aarch64-linux
RUN bundle install -j20 && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git 

# Copy application code
COPY ./build/. .

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN bundle lock --add-platform aarch64-linux
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Run and own only the runtime files as a non-root user for security
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log tmp
USER rails:rails

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 5000
ENV PORT=5000
ENV RAILS_LOG_TO_STDOUT=true

CMD ["./bin/rails", "server"]

