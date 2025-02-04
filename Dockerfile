# To use or update to a ruby version, change BASE_RUBY_IMAGE
ARG BASE_RUBY_IMAGE=ruby:3.4.1-alpine3.21

FROM ${BASE_RUBY_IMAGE} AS base

ENV RAILS_ENV=production \
    NODE_ENV=production \
    RAILS_SERVE_STATIC_FILES=true \
    RAILS_LOG_TO_STDOUT=true \
    RACK_TIMEOUT_SERVICE_TIMEOUT=60 \
    BUNDLE_WITHOUT=development \
    BUNDLE_JOBS=4

RUN mkdir /app
WORKDIR /app

RUN apk update

RUN apk add --no-cache \
  "procps-ng=4.0.4-r0" \
  "libproc2=4.0.4-r0"

RUN apk add --no-cache build-base tzdata shared-mime-info nodejs npm yarn git \
        chromium chromium-chromedriver postgresql-libs postgresql-dev && rm -rf /var/lib/apt/lists/*

# Install bundler
RUN gem install bundler --version=2.3.4

# Install NPM packages removing artifacts
COPY package.json yarn.lock ./
# hadolint ignore=DL3060
RUN yarn install

# Install Gems removing artifacts
COPY .ruby-version Gemfile Gemfile.lock ./
RUN bundle install --jobs=$(nproc --all) && \
    rm -rf /root/.bundle/cache && \
    rm -rf /usr/local/bundle/cache

# Add all remaining files
COPY . .


FROM base AS release-build

RUN apk update
RUN apk add --no-cache \
        pngquant jpegoptim imagemagick parallel \
        && rm -rf /var/lib/apt/lists/*

COPY --from=base /app /app

# See https://github.com/rails/rails/issues/32947 for why we
# bypass the credentials here.
RUN SECRET_KEY_BASE=1 RAILS_BUILD=1 bundle exec rake assets:precompile

# Remove node_modules since they are only used to generated the assets and take a lot of space
RUN rm -rf node_modules

# Cap images to have a max width of 1000px
# Lossless optimize PNGs
# Optimize JPEG at 90% quality
RUN find public -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) -exec magick {} -resize 1000\> {} \; \
    && find public -type f -iname "*.png" -exec pngquant --quality=65-80 {} \; \
    && find public -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) -exec jpegoptim -m75 --strip-all {} \;

# Convert to WebP/JPEG-2000 formats (size constraint avoids an error on empty images)
# At 75% quality the images still look good and they are roughly half the size.
# We need to convert after the fingerprinting so the file names are consistent.
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN find public \( -type f -a \( -iname "*.jpg" -o -iname ".jpeg" -o -iname ".png" \) \) | parallel -eta magick {} -quality 75 "{.}.webp" \
    && find public \( -type f -a \( -iname "*.jpg" -o -iname ".jpeg" \) \) | parallel -eta magick {} -quality 75 "{.}.jp2"


FROM ${BASE_RUBY_IMAGE} AS release

ENV RAILS_ENV=production \
    RAILS_SERVE_STATIC_FILES=true \
    RAILS_LOG_TO_STDOUT=true \
    RACK_TIMEOUT_SERVICE_TIMEOUT=60

RUN mkdir /app
WORKDIR /app

# Install production image dependencies
RUN apk update

RUN apk add --no-cache tzdata shared-mime-info postgresql-libs postgresql-dev && \
    rm -rf /var/lib/apt/lists/*

RUN apk add --no-cache \
  "procps-ng=4.0.4-r0" \
  "libproc2=4.0.4-r0"

COPY --from=release-build /app /app
COPY --from=release-build /usr/local/bundle/ /usr/local/bundle/

EXPOSE 3000
ENTRYPOINT ["bundle", "exec"]
CMD ["rails server"]

ARG SHA
RUN echo "sha-${SHA}" > /etc/get-into-teaching-app-sha
