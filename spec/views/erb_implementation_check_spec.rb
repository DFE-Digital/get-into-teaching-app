require "rails_helper"
require "better_html"
require "better_html/better_erb/erubi_implementation"

describe "ERB Implementation Check" do
  erb_glob = Rails.root.join(
    "app/views/**/{*.htm,*.html,*.htm.erb,*.html.erb,*.html+*.erb}",
  )

  Dir[erb_glob].each do |filename|
    pathname = Pathname.new(filename).relative_path_from(Rails.root)
    it "does not have html errors in #{pathname}" do
      data = File.read(filename)

      expect {
        BetterHtml::BetterErb::ErubiImplementation.new(data).validate!
      }.not_to raise_error
    end
  end
end
