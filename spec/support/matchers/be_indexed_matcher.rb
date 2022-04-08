require "rspec/expectations"

RSpec::Matchers.define :be_indexed do |_expected|
  match do |response|
    !response.body.include?(%(<meta name="robots" content="noindex">))
  end

  failure_message do |response|
    "expected #{response.request.path} to be indexed"
  end

  failure_message_when_negated do |response|
    "expected #{response.request.path} not to be indexed"
  end
end
