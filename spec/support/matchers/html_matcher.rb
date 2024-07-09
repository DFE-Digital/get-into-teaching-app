require "rspec/expectations"

RSpec::Matchers.define :match_html do |expected|
  match do |html|
    minify(expected) == minify(html)
  end

  failure_message do |html|
    "expected #{expected} to match html #{html}"
  end

  failure_message_when_negated do |html|
    "expected #{expected} not to match #{html}"
  end

  def minify(html)
    html.gsub(/>(\s+)</, "><").strip
  end
end
