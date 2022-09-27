RSpec::Matchers.define :be_an_optimised_image do |expected|
  match do |image|
    File.size(image) < 500.kilobytes
  end
end
