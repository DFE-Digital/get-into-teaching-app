require "rails_helper"

describe Feedback::PageHelpful do
  it { is_expected.to respond_to :url }
  it { is_expected.to respond_to :answer }

  context "url" do
    it {
      is_expected.to allow_values(
        "http://test.com/test",
        "https://test.com/test",
        "http://www.test.com/test",
        "https://www.test.com/test",
      ).for :url
    }
    it { is_expected.to_not allow_values(nil, "", " ", "not-a-url").for :url }
  end

  context "answer" do
    it { is_expected.to allow_values("yes", "no").for :answer }
    it { is_expected.to_not allow_values(nil, "", true, false, "maybe").for :answer }
  end
end
