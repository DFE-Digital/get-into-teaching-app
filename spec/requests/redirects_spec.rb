require "rails_helper"

describe "Redirects" do
  let(:query_string) { "abc=def&ghi=jkl" }

  redirects = YAML.load_file(Rails.root.join("config/redirects.yml")).fetch("redirects")

  def build_url(base, query_string)
    [base, query_string].join("?")
  end

  redirects.each do |from, to|
    describe "'#{from}' redirects to '#{to}'" do
      context "without a query string" do
        subject { get(from) }

        specify "redirects successfully" do
          expect(subject).to be 301
          expect(response).to redirect_to(to)
        end
      end

      context "with a query string" do
        subject { get(build_url(from, query_string)) }

        specify "redirects successfully and maintains the query string" do
          expect(subject).to be(301)
          expect(response).to redirect_to(build_url(to, query_string))
        end
      end
    end
  end
end
