require "rails_helper"

RSpec.describe ProviderEvents::Steps::RegistrationDetails do
  include_context "with wizard step"

  it_behaves_like "a with wizard step"

  it { is_expected.to respond_to :registration_option }
  it { is_expected.to respond_to :registration_email }
  it { is_expected.to respond_to :registration_website }

  it { is_expected.to respond_to :website_registration? }
  it { is_expected.to respond_to :email_registration? }

  it { is_expected.to validate_presence_of :registration_option }
  it { is_expected.to validate_inclusion_of(:registration_option).in_array(%w[website email]) }

  it { is_expected.not_to be_skipped }

  context "when email registration" do
    before { subject.registration_option = "email" }

    it { expect(subject.email_registration?).to be true }
    it { expect(subject.website_registration?).to be false }

    it { is_expected.to validate_presence_of(:registration_email) }
    it { is_expected.to validate_length_of(:registration_email).is_at_most(100) }

    it { is_expected.not_to validate_presence_of(:registration_website) }
  end

  context "when website registration" do
    before { subject.registration_option = "website" }

    it { expect(subject.email_registration?).to be false }
    it { expect(subject.website_registration?).to be true }

    it { is_expected.to validate_presence_of(:registration_website) }
    it { is_expected.to validate_length_of(:registration_website).is_at_most(300) }

    it { is_expected.not_to validate_presence_of(:registration_email) }

    it_behaves_like "a validated url", :registration_website
  end
end
