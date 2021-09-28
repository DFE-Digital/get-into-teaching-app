require "better_html"
require "better_html/better_erb/erubi_implementation"
require "rails_helper"

describe "ERB Implementation Check" do # rubocop:disable RSpec/DescribeClass
  erb_glob = Rails.root.join(
    "app/views/**/{*.htm,*.html,*.htm.erb,*.html.erb,*.html+*.erb}",
  )

  Dir[erb_glob].each do |filename|
    pathname = Pathname.new(filename).relative_path_from(Rails.root)
    it "does not have html errors in #{pathname}" do
      data = File.read(filename)
      BetterHtml::BetterErb::ErubiImplementation.new(data).validate!
    end
  end
end
