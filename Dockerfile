ARG BUILD_TYPE

FROM ruby:3.1.1-alpine3.14 as base

ENV RAILS_ENV=production \
    NODE_ENV=production \
    RAILS_SERVE_STATIC_FILES=true \
    RAILS_LOG_TO_STDOUT=true \
    RACK_TIMEOUT_SERVICE_TIMEOUT=60 \
    BUNDLE_WITHOUT=development \
    BUNDLE_JOBS=4

RUN mkdir /app
WORKDIR /app

RUN apk add --no-cache build-base tzdata shared-mime-info nodejs-current yarn \
    chromium chromium-chromedriver && rm -rf /var/lib/apt/lists/*

# Copy node_modules/gem as cache
# hadolint ignore=DL3022
COPY --from=ghcr.io/dfe-digital/get-into-teaching-frontend:master /usr/local/bundle /usr/local/bundle
# hadolint ignore=DL3022
COPY --from=ghcr.io/dfe-digital/get-into-teaching-frontend:master /app/node_modules /app/node_modules

# install NPM packages removign artifacts
COPY package.json yarn.lock ./
# hadolint ignore=DL3060
RUN yarn install

# Install bundler
RUN gem install bundler --version=2.3.4

# Install Gems removing artifacts
COPY .ruby-version Gemfile Gemfile.lock ./
RUN bundle install --jobs=$(nproc --all) && \
    rm -rf /root/.bundle/cache && \
    rm -rf /usr/local/bundle/cache

FROM base AS build-release

# Extra dependencies for image processing
# Test packages are also removed (added earlier to benefit the cache)
RUN apk add --no-cache pngquant jpegoptim imagemagick parallel && \
    rm -rf /var/lib/apt/lists/* && \
    apk del chromium chromium-chromedriver

# Add code and compile assets
COPY . .

# See https://github.com/rails/rails/issues/32947 for why we
# bypass the credentials here.
RUN SECRET_KEY_BASE=1 RAILS_BUILD=1 bundle exec rake assets:precompile

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

FROM base AS build-test

# Add code and compile assets
COPY . .

# hadolint ignore=DL3006
FROM build-${BUILD_TYPE} AS final

EXPOSE 3000
ENTRYPOINT ["bundle", "exec"]
CMD ["rails", "server" ]

ARG SHA
RUN echo "sha-${SHA}" > /etc/get-into-teaching-app-sha
