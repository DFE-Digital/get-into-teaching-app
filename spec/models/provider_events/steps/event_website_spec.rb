require "validate_url/rspec_matcher"
require "rails_helper"

RSpec.describe ProviderEvents::Steps::EventWebsite do
  include_context "with wizard step"

  it_behaves_like "a with wizard step"

  it { is_expected.to respond_to :event_website }

  it { is_expected.to validate_presence_of :event_website }

  it { is_expected.to validate_length_of(:event_website).is_at_most(300) }

  it { is_expected.not_to be_skipped }

  describe "event_website" do
    context "when it is invalid" do
      it { is_expected.not_to allow_value("http://localhost/foo/bar").for :event_website }
      it { is_expected.not_to allow_value("ftp://foo.bar/").for :event_website }
      it { is_expected.not_to allow_value("https://foo/bar").for :event_website }
    end

    context "when it is valid" do
      it { is_expected.to allow_value("http://foo.bar/foo/bar").for :event_website }
      it { is_expected.to allow_value("https://foo.bar/foo/bar").for :event_website }
    end
  end
end
