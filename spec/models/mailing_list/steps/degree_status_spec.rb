require "rails_helper"

describe MailingList::Steps::DegreeStatus do
  include_context "with wizard step"
  before do
    allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
      receive(:get_qualification_degree_status).and_return(degree_status_option_types)
  end

  let(:degree_status_option_types) do
    OptionSet::DEGREE_STATUSES.map do |k, v|
      GetIntoTeachingApiClient::PickListItem.new({ id: v, value: k })
    end
  end

  it_behaves_like "a with wizard step"

  it { is_expected.to respond_to :degree_status_id }

  describe "validations" do
    subject { instance.tap(&:valid?).errors.messages }

    it { is_expected.to include(:degree_status_id) }
  end

  describe "#degree_status_id" do
    let(:options) { degree_status_option_types.map(&:id) }

    it { is_expected.to allow_value(options.first).for :degree_status_id }
    it { is_expected.to allow_value(options.last).for :degree_status_id }
    it { is_expected.not_to allow_value(nil).for :degree_status_id }
    it { is_expected.not_to allow_value("").for :degree_status_id }
    it { is_expected.not_to allow_value(12_345).for :degree_status_id }
  end

  describe "#wizard_magic_link_token_used?" do
    it { is_expected.not_to be_magic_link_token_used }

    context "when magic link token was used" do
      before { wizardstore["auth_method"] = DFEWizard::Base::Auth::MAGIC_LINK_TOKEN }

      it { is_expected.to be_magic_link_token_used }
    end
  end
end
