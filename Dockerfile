# Our base image is Ruby 2.3, running on Alpine Linux.
FROM ruby:2.3-alpine

# Build packages are system packages that are only required for installing
# gems, precompiling assets, etc. They are not included in the final Docker
# image.
ENV BUILD_PACKAGES \
    # Required for the sqlite3 gem to compile.
    postgresql-dev

# Runtime packages are system packages that are required for the application
# to run. They are included in the final Docker image.
ENV RUNTIME_PACKAGES \
    # Required for the sqlite3 gem.
    postgresql-libs

# Copy your application into the container.
COPY . .

# Build your application.
RUN \
    # Upgrade old packages.
    apk --update upgrade && \
    # Ensure we have ca-certs installed.
    apk add --no-cache ca-certificates && \
    # Install build packages.
    apk add --virtual build-packages build-base $BUILD_PACKAGES && \
    # Install runtime packages.
    apk add --virtual runtime-packages nodejs tzdata $RUNTIME_PACKAGES && \
    # Install application gems.
    bundle install --jobs 4 --without development test --with production && \
    # Precompile Rails assets.
    RAILS_ENV=production bundle exec rake assets:precompile && \ 
    # Clean up build packages.
    apk del --purge build-packages && \
    # Delete APK and gem caches.
    find / -type f -iname \*.apk-new -delete && \
    rm -rf /var/cache/apk/* && \
    rm -rf /usr/local/lib/ruby/gems/*/cache/* && \
    rm -rf ~/.gem

# Run your application with Puma.
CMD puma -e production
