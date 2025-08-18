require "rails_helper"

describe MailingList::Steps::VisaStatus do
  include_context "with wizard step"

  let(:visa_statuses) do
    %i[yes_i_have_a_visa no_i_will_need_to_apply_for_a_visa not_sure].map { |trait| build(:visa_status, trait) }
  end
  let(:visa_status_ids) { visa_statuses.map(&:id) }

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to receive(:get_candidate_visa_status) { visa_statuses }
  end

  it_behaves_like "a with wizard step"
  it { is_expected.to respond_to :visa_status }
  it { is_expected.not_to allow_value(nil).for :visa_status }
  it { is_expected.not_to allow_value("").for :visa_status }
  it { is_expected.not_to allow_value(12_345).for :visa_status }
  it { is_expected.not_to allow_values(0).for(:visa_status) }
  it { is_expected.to validate_inclusion_of(:visa_status).in_array(visa_status_ids) }

  describe "skipped?" do
    before do
      allow(instance).to receive(:other_step).with(:citizenship) { instance_double(MailingList::Steps::Citizenship, uk_citizen?: uk_citizen) }
    end

    context "when a UK citizen" do
      let(:uk_citizen) { true }

      it "is skipped when a UK citizen" do
        is_expected.to be_skipped
      end
    end

    context "when a non-UK citizen" do
      let(:uk_citizen) { false }

      it "is not skipped when a non-UK citizen" do
        is_expected.not_to be_skipped
      end
    end
  end
end
