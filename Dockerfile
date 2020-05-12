FROM ruby:2.6.6-alpine3.11

ENV RAILS_ENV=production \
    NODE_ENV=production \
    RAILS_SERVE_STATIC_FILES=true \
    RAILS_LOG_TO_STDOUT=true \
    RACK_TIMEOUT_SERVICE_TIMEOUT=60 \
    BUNDLE_BUILD__SASSC=--disable-march-tune-native

RUN mkdir /app
WORKDIR /app

EXPOSE 3000
ENTRYPOINT ["bundle", "exec"]
CMD ["rails", "server" ]

RUN apk add --no-cache build-base git tzdata nodejs yarn

# install NPM packages removign artifacts
COPY package.json yarn.lock ./
RUN yarn install && yarn cache clean

# Install bundler
RUN gem install bundler --version=2.1.4

# Install Gems removing artifacts
COPY .ruby-version Gemfile Gemfile.lock ./
RUN bundle install --without development --jobs=$(nproc --all) && \
    rm -rf /root/.bundle/cache && \
    rm -rf /usr/local/bundle/cache

# Add code and compile assets
COPY . .
RUN bundle exec rake assets:precompile
