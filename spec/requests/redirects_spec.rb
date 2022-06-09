require "rails_helper"

describe "Redirects", content: true, type: :request do
  before(:all) { @result = {} }

  let(:query_string) { "abc=def&ghi=jkl" }

  redirects = YAML.load_file(Rails.root.join("config/redirects.yml")).fetch("redirects")
  redirects.each do |from, to|
    describe "'#{from}' redirects to '#{to}'" do
      subject { get(build_url(from, query_string)) }

      specify "redirects successfully" do
        allow(Rails.logger).to receive(:info)

        expect(subject).to be 301
        expect(response).to redirect_to(build_url(to, query_string))
        expect(Rails.logger).to have_received(:info).with(redirect: { from: from, to: to })

        target = Nokogiri.parse(response.body).at_css("a")["href"].gsub(root_url, "/")

        # skip events stuff and the privacy policy because they're pulled from the CRM
        next if target =~ /event|privacy/

        @result[target] ||= get(target)

        expect(@result[target]).to be_in([200, 301, 302])
      end
    end
  end

  def build_url(base, query_string)
    [base, query_string].join("?")
  end
end
