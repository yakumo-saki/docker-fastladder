# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=4.0.5
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim-bookworm

#RUN gem install foreman

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# Install packages needed to build gems
RUN <<EOF
apt-get update -qq
apt-get install -y --no-install-recommends \
        build-essential git libvips pkg-config \
        libpq-dev libsqlite3-dev libmariadb-dev \
        imagemagick libyaml-dev \
        libjemalloc2
apt-get clean
rm -rf /var/lib/apt/lists/*
EOF

RUN /usr/bin/git --version

# Install application gems
COPY ./build/Gemfile ./build/Gemfile.lock ./
RUN <<EOF
#bundle lock --add-platform aarch64-linux
bundle install
rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git 
EOF

# Copy application code
COPY ./build/ .

COPY docker-entrypoint.sh /
RUN chmod +x /rails/bin/docker-entrypoint

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
#
RUN <<EOF
SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile
EOF

# Run and own only the runtime files as a non-root user for security
RUN <<EOF
useradd rails --create-home --shell /bin/bash
chown -R rails:rails db tmp
EOF

USER rails:rails

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 5000
ENV PORT=5000
ENV RAILS_LOG_TO_STDOUT=true

CMD ["/docker-entrypoint.sh","./bin/rails", "server"]

