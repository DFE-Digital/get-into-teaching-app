require "rails_helper"

describe MailingList::Steps::TeacherTraining do
  include_context "wizard step", MailingList::Wizard
  it_behaves_like "a wizard step"

  let(:consideration_journey_stage_types) do
    GetIntoTeachingApiClient::Constants::CONSIDERATION_JOURNEY_STAGES.map do |k, v|
      GetIntoTeachingApiClient::TypeEntity.new({ id: v, value: k })
    end
  end

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::TypesApi).to \
      receive(:get_candidate_journey_stages).and_return(consideration_journey_stage_types)
  end

  it { is_expected.to respond_to :consideration_journey_stage_id }

  context "consideration_journey_stage_id" do
    let(:options) { consideration_journey_stage_types.map(&:id) }
    it { is_expected.to allow_value(options.first).for :consideration_journey_stage_id }
    it { is_expected.to allow_value(options.last).for :consideration_journey_stage_id }
    it { is_expected.not_to allow_value(nil).for :consideration_journey_stage_id }
    it { is_expected.not_to allow_value("").for :consideration_journey_stage_id }
    it { is_expected.not_to allow_value(12_345).for :consideration_journey_stage_id }
  end
end
