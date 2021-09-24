require "better_html"
require "better_html/test_helper/safe_erb_tester"
require "rails_helper"

describe "ERB Safety Check" do # rubocop:disable RSpec/DescribeClass
  include BetterHtml::TestHelper::SafeErbTester

  erb_glob = Rails.root.join(
    "app/views/**/{*.htm,*.html,*.htm.erb,*.html.erb,*.html+*.erb}",
  )

  Dir[erb_glob].each do |filename|
    pathname = Pathname.new(filename).relative_path_from(Rails.root)
    it "escapes all Javascript in #{pathname}" do
      assert_erb_safety(File.read(filename))
    end
  end
end
