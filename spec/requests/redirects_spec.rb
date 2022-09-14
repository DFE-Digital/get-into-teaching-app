require "rails_helper"

describe "Redirects", content: true, type: :request do
  before(:all) { @result = {} }

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

        target = Nokogiri.parse(response.body).at_css("a")["href"].gsub(root_url, "/")

        # skip events stuff and the privacy policy because they're pulled from the CRM
        next if target =~ /event|privacy/

        @result[target] ||= get(target)

        expect(@result[target]).to be_in(valid_results)
      end
    end
  end

  describe "path redirects" do
    {
      "/life-as-a-teacher/some-old-page" => "/blog",
      "/life-as-a-teacher/some-old-page/some-old-subpage" => "/blog",
      "/why-teach" => "/blog",
      "/why-teach/why-teach-subpage" => "/blog",
      "/content/stories" => "/blog",
      "/content/stories/subpage" => "/blog",
    }.each do |from, to|
      describe "'#{from}' redirects to '#{to}'" do
        subject { get(build_url(from, query_string)) }

        specify "redirects successfully" do
          allow(Rails.logger).to receive(:info)

          expect(subject).to be 301
          expect(response).to redirect_to(build_url(to, expected_query_string))

          target = Nokogiri.parse(response.body).at_css("a")["href"].gsub(root_url, "/")

          @result[target] ||= get(target)

          expect(@result[target]).to be_in(valid_results)
        end
      end
    end
  end

  def build_url(base, query_string)
    [base, query_string].join("?")
  end
end
