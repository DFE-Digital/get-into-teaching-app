require "rails_helper"

describe MailingList::Steps::DegreeStatus do
  include_context "with wizard step"
  include_context "with wizard data"

  it_behaves_like "a with wizard step"

  it { is_expected.to respond_to :degree_status_id }

  describe "validations" do
    subject { instance.tap(&:valid?).errors.messages }

    it { is_expected.to include(:degree_status_id) }
  end

  describe "#degree_status_id" do
    it { is_expected.to allow_values(222_750_000, 222_750_006, 222_750_004).for :degree_status_id }
    it { is_expected.not_to allow_value(nil).for :degree_status_id }
    it { is_expected.not_to allow_value("").for :degree_status_id }
    it { is_expected.not_to allow_value(12_345).for :degree_status_id }
  end

  describe "#wizard_magic_link_token_used?" do
    it { is_expected.not_to be_magic_link_token_used }

    context "when magic link token was used" do
      before { wizardstore["auth_method"] = GITWizard::Base::Auth::MAGIC_LINK_TOKEN }

      it { is_expected.to be_magic_link_token_used }
    end
  end
end
