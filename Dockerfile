FROM ruby:2.7.5-alpine3.14

ENV RAILS_ENV=production \
    NODE_ENV=production \
    RAILS_SERVE_STATIC_FILES=true \
    RAILS_LOG_TO_STDOUT=true \
    RACK_TIMEOUT_SERVICE_TIMEOUT=60 \
    BUNDLE_WITHOUT=development

RUN mkdir /app
WORKDIR /app

EXPOSE 3000
ENTRYPOINT ["bundle", "exec"]
CMD ["rails", "server" ]

RUN apk add --no-cache build-base git tzdata shared-mime-info nodejs yarn\
    wget xvfb unzip chromium chromium-chromedriver \
    pngquant jpegoptim imagemagick parallel

# install NPM packages removign artifacts
COPY package.json yarn.lock ./
RUN yarn install && yarn cache clean

# Install bundler
RUN gem install bundler --version=2.2.23

# Install Gems removing artifacts
COPY .ruby-version Gemfile Gemfile.lock ./
RUN bundle install --jobs=$(nproc --all) && \
    rm -rf /root/.bundle/cache && \
    rm -rf /usr/local/bundle/cache

# Add code and compile assets
COPY . .
ARG RAILS_MASTER_KEY
RUN RAILS_MASTER_KEY="${RAILS_MASTER_KEY}" bundle exec rake assets:precompile

# Cap images to have a max width of 1000px
RUN find public -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) -exec convert --resize '1000' {} \;
# Lossless optimize PNGs
RUN find public -type f -iname "*.png" -exec pngquant --quality=65-80 {} \;
# Optimize JPEG at 90% quality
RUN find public -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) -exec jpegoptim -m75 --strip-all {} \;

# Convert to WebP/JPEG-2000 formats (size constraint avoids an error on empty images)
# At 75% quality the images still look good and they are roughly half the size.
# We need to convert after the fingerprinting so the file names are consistent.
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN find public -name "*.jpg" -size "+1b" | parallel -eta magick {} -quality 75 "{.}.webp"
RUN find public -name "*.jpeg" -size "+1b" | parallel -eta magick {} -quality 75 "{.}.webp"
RUN find public -name "*.png" -size "+1b" | parallel -eta magick {} -quality 75 "{.}.webp"
RUN find public -name "*.jpg" -size "+1b" | parallel -eta magick {} -quality 75 "{.}.jp2"
RUN find public -name "*.jpeg" -size "+1b" | parallel -eta magick {} -quality 75 "{.}.jp2"

ARG SHA
RUN echo "sha-${SHA}" > /etc/get-into-teaching-app-sha

