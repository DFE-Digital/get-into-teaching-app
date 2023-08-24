require "rails_helper"

describe Feedback::Wizard do
  subject { described_class.new wizardstore, "feedback" }

  let(:uuid) { SecureRandom.uuid }
  let(:store) do
    { uuid => {
      "rating" => 1,
      "topic" => "adviser",
      "successful_visit" => "Yes",
      "unsuccessful_visit_explanation" => "Blabla",
    } }
  end
  let(:wizardstore) { GITWizard::Store.new store[uuid], {} }

  describe ".steps" do
    subject { described_class.steps }

    it do
      is_expected.to eql [
        Feedback::Steps::Purpose,
        Feedback::Steps::Website,
        Feedback::Steps::WebsiteExperience,
        Feedback::Steps::WebsiteIssue,
        Feedback::Steps::Signup,
      ]
    end
  end
end
