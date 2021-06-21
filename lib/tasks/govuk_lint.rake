desc "Lint ruby code"
namespace :lint do
  desc "Lint ruby code"
  task ruby: :environment do
    puts "Linting ruby..."
    system "bundle exec rubocop app config db lib spec Gemfile --format clang -a"
  end
end
