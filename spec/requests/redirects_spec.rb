require "rails_helper"

describe "Redirects", :content, type: :request do
  before(:all) { @result = {} }

  let(:teaching_vacancies_url) { "https://teaching-vacancies.service.gov.uk/jobseeker-guides/return-to-teaching-in-england/return-to-teaching/" }
  let(:query_string) { "#{expected_query_string}&page=5" }
  let(:expected_query_string) { "abc=def&ghi=jkl" }
  let(:valid_results) { [200, 301, 302] }

  redirects = YAML.load_file(Rails.root.join("config/redirects.yml")).fetch("redirects")
  redirects.each do |from, to|
    describe "'#{from}' redirects to '#{to}'" do
      let(:url) { build_url(from, query_string) }

      subject { get(url) }

      specify "redirects successfully" do
        allow(Rails.logger).to receive(:info)

        expect(subject).to be 301
        expect(response).to redirect_to(build_url(to, expected_query_string))
        expect(Rails.logger).to have_received(:info).with(redirect: { request: url, from: from, to: to })

        # Skip the parsing logic if no redirect is present
        next if response.location.nil?

        # Parse the body for the <a> tag if not a redirect
        target = Nokogiri.parse(response.body).at_css("a")&.[]("href")
        # Ensure the link is not nil before using it
        next if target.nil?

        # skip events stuff and the privacy policy because they're pulled from the CRM
        next if target =~ /event|privacy/

        @result[target] ||= get(target)

        expect(@result[target]).to be_in(valid_results)
      end
    end
  end

  describe "path redirects" do
    {
      "/why-teach" => "/life-as-a-teacher/pay-and-benefits",
      "/why-teach/why-teach-subpage" => "/life-as-a-teacher",
      "/content/stories" => "/life-as-a-teacher",
      "/content/stories/subpage" => "/life-as-a-teacher",
      "/my-story-into-teaching" => "/life-as-a-teacher",
      "/my-story-into-teaching/subpage" => "/life-as-a-teacher",
    }.each do |from, to|
      describe "'#{from}' redirects to '#{to}'" do
        subject { get(build_url(from, query_string)) }

        specify "redirects successfully" do
          allow(Rails.logger).to receive(:info)

          expect(subject).to be 301
          expect(response).to redirect_to(build_url(to, expected_query_string))

          # Parse the body and check for the <a> tag only if it's not a redirect
          target = Nokogiri.parse(response.body).at_css("a")&.[]("href")
          # Skip if no <a> tag is found
          next if target.nil?

          # Skip events and privacy-related URLs
          next if target =~ /event|privacy/

          @result[target] ||= get(target)

          expect(@result[target]).to be_in(valid_results)
        end
      end
    end
  end

  describe "page 'returning-to-teaching' redirects" do
    it "redirects to school vacancies url" do
      get "/returning-to-teaching"
      expect(response.code).to eq("301")
      expect(response.location).to eq(teaching_vacancies_url)
    end
  end

  def build_url(base, query_string)
    [base, query_string].join("?")
  end
end
