FROM ruby:2.7.5-alpine3.14 as build-env

ENV RAILS_ENV=production \
    NODE_ENV=production \
    RAILS_SERVE_STATIC_FILES=true \
    RAILS_LOG_TO_STDOUT=true \
    RACK_TIMEOUT_SERVICE_TIMEOUT=60 \
    BUNDLE_WITHOUT=development \
    BUNDLE_JOBS=4

RUN mkdir /app
WORKDIR /app

RUN apk add --no-cache build-base git tzdata shared-mime-info nodejs yarn\
    wget xvfb unzip chromium chromium-chromedriver \
    pngquant jpegoptim imagemagick parallel && rm -rf /var/lib/apt/lists/*

# install NPM packages removign artifacts
COPY package.json yarn.lock ./
# hadolint ignore=DL3060
RUN yarn install

# hadolint ignore=DL3022
COPY --from=ghcr.io/dfe-digital/get-into-teaching-frontend:master /usr/local/bundle /usr/local/bundle

# Install bundler
RUN gem install bundler --version=2.3.4

# Install Gems removing artifacts
COPY .ruby-version Gemfile Gemfile.lock ./
RUN bundle install --jobs=$(nproc --all) && \
    rm -rf /root/.bundle/cache && \
    rm -rf /usr/local/bundle/cache

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
RUN find public -name "*.jpg" -size "+1b" | parallel -eta magick {} -quality 75 "{.}.webp" \ 
    && find public -name "*.jpeg" -size "+1b" | parallel -eta magick {} -quality 75 "{.}.webp" \
    && find public -name "*.png" -size "+1b" | parallel -eta magick {} -quality 75 "{.}.webp" \
    && find public -name "*.jpg" -size "+1b" | parallel -eta magick {} -quality 75 "{.}.jp2" \
    && find public -name "*.jpeg" -size "+1b" | parallel -eta magick {} -quality 75 "{.}.jp2"

FROM ruby:2.7.5-alpine3.14

ENV RAILS_ENV=production \
    NODE_ENV=production \
    RAILS_SERVE_STATIC_FILES=true \
    RAILS_LOG_TO_STDOUT=true \
    RACK_TIMEOUT_SERVICE_TIMEOUT=60

EXPOSE 3000
ENTRYPOINT ["bundle", "exec"]
CMD ["rails", "server" ]

RUN apk add --no-cache tzdata nodejs yarn shared-mime-info chromium chromium-chromedriver \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /app
WORKDIR /app

COPY --from=build-env /usr/local/bundle/ /usr/local/bundle/

COPY --from=build-env /app .

ARG SHA
RUN echo "sha-${SHA}" > /etc/get-into-teaching-app-sha
