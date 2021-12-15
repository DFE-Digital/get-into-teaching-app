require "rails_helper"

describe MailingList::Steps::Subject do
  include_context "with wizard step"
  before do
    allow_any_instance_of(GetIntoTeachingApiClient::LookupItemsApi).to \
      receive(:get_teaching_subjects).and_return(teaching_subject_types)
  end

  let(:teaching_subject_types) do
    TeachingSubject::ALL.map { |k, v| GetIntoTeachingApiClient::LookupItem.new({ id: v, value: k }) }
  end

  it_behaves_like "a with wizard step"

  it { is_expected.to respond_to :preferred_teaching_subject_id }

  describe "#preferred_teaching_subject_id" do
    let(:options) { teaching_subject_types.map(&:id) }

    it { is_expected.to allow_value(options.first).for :preferred_teaching_subject_id }
    it { is_expected.to allow_value(options.last).for :preferred_teaching_subject_id }
    it { is_expected.not_to allow_value(nil).for :preferred_teaching_subject_id }
    it { is_expected.not_to allow_value("").for :preferred_teaching_subject_id }
    it { is_expected.not_to allow_value("random").for :preferred_teaching_subject_id }
  end

  describe "#teaching_subject_ids" do
    subject { instance.teaching_subject_ids }

    let(:teaching_subject_types) do
      subjects = TeachingSubject::ALL.merge(TeachingSubject::IGNORED)
      subjects.map { |k, v| GetIntoTeachingApiClient::LookupItem.new({ id: v, value: k }) }
    end

    it { is_expected.to eq(TeachingSubject.all_uuids) }
  end
end
