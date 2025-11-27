# syntax=docker/dockerfile:1

# ------------------------------
# Base image with Ruby
# ------------------------------
ARG RUBY_VERSION=3.2.1
FROM ruby:$RUBY_VERSION-slim AS base

LABEL maintainer="Your Name"

# Set working directory
WORKDIR /rails

# Set environment variables
ENV RAILS_ENV=production \
    RACK_ENV=production \
    BUNDLE_WITHOUT="development:test" \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_DEPLOYMENT=1 \
    RAILS_LOG_TO_STDOUT=1 \
    RAILS_SERVE_STATIC_FILES=true

# Install bundler version that matches Gemfile.lock
RUN gem update --system --no-document && \
    gem install bundler -v 2.4.14

# ------------------------------
# Build stage
# ------------------------------
FROM base AS build

# Install build dependencies for gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
        build-essential \
        libpq-dev \
        nodejs \
        yarn \
        curl \
        git \
    && rm -rf /var/lib/apt/lists/*

# Copy Gemfiles and install dependencies
COPY --link Gemfile Gemfile.lock ./
RUN bundle install && \
    bundle exec bootsnap precompile --gemfile

# Copy the rest of the application
COPY --link . .

# Precompile bootsnap cache for faster boot
RUN bundle exec bootsnap precompile app/ lib/

# ------------------------------
# Final stage
# ------------------------------
FROM base

# Install runtime dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
        postgresql-client \
        nodejs \
        yarn \
    && rm -rf /var/lib/apt/lists/*

# Add non-root user
RUN useradd --create-home --shell /bin/bash rails
USER rails:rails

# Copy application and gems from build stage
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build --chown=rails:rails /rails /rails

# Entrypoint and default command
ENTRYPOINT ["/rails/bin/docker-entrypoint"]
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]

# Expose Rails port
EXPOSE 3000
