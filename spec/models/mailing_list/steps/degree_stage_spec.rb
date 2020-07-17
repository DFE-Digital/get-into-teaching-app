require "rails_helper"

describe MailingList::Steps::DegreeStage do
  include_context "wizard step"
  it_behaves_like "a wizard step"

  let(:degree_status_option_types) do
    GetIntoTeachingApi::Constants::DEGREE_STATUS_OPTIONS.map do |k, v|
      GetIntoTeachingApiClient::TypeEntity.new({ id: v, value: k })
    end
  end

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::TypesApi).to \
      receive(:get_qualification_degree_status).and_return(degree_status_option_types)
  end

  it { is_expected.to respond_to :degree_status_id }

  context "degree_status_id" do
    let(:options) { degree_status_option_types.map(&:id) }
    it { is_expected.to allow_value(options.first).for :degree_status_id }
    it { is_expected.to allow_value(options.last).for :degree_status_id }
    it { is_expected.not_to allow_value(nil).for :degree_status_id }
    it { is_expected.not_to allow_value("").for :degree_status_id }
    it { is_expected.not_to allow_value("random").for :degree_status_id }
  end

  context "skipped?" do
    subject { described_class.new nil, Wizard::Store.new(store), {} }

    context "when describe_yourself_option_id equals 'Student'" do
      let(:store) { { "describe_yourself_option_id" => GetIntoTeachingApi::Constants::DESCRIBE_YOURSELF_OPTIONS["Student"] } }
      it { is_expected.to have_attributes skipped?: false }
    end

    context "when describe_yourself_option_id does not equal student" do
      let(:store) { { "describe_yourself_option_id" => GetIntoTeachingApi::Constants::DESCRIBE_YOURSELF_OPTIONS["Looking to change career"] } }
      it { is_expected.to have_attributes skipped?: true }
    end

    context "when describe_yourself_option_id is not set" do
      let(:store) { {} }
      it { is_expected.to have_attributes skipped?: true }
    end
  end
end
