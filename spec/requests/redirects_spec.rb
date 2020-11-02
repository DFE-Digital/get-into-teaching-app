require "rails_helper"

describe "Redirects" do
  redirects = YAML.load_file(Rails.root.join("config/redirects.yml")).fetch("redirects")

  redirects.each do |from, to|
    specify "'#{from}' redirects to '#{to}'" do
      expect(get(from)).to eql(301)
      expect(response).to redirect_to(to)
    end
  end
end
