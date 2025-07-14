require "rails_helper"

describe MailingList::Steps::LifeStage do
  include_context "with wizard step"

  let(:in_education) { build(:situation, :in_education) }
  let(:graduated) { build(:situation, :graduated) }
  let(:change_career) { build(:situation, :change_career) }
  let(:qualified_teacher) { build(:situation, :qualified_teacher) }
  let(:situations) do
    [in_education, graduated, change_career, qualified_teacher]
  end

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
      receive(:get_candidate_situations).and_return(situations)
  end

  it_behaves_like "a with wizard step"

  it { is_expected.to respond_to :situation }

  describe "#situation" do
    it { is_expected.to allow_value(graduated.id).for :situation }
    it { is_expected.to allow_value(change_career.id).for :situation }
    it { is_expected.to allow_value(qualified_teacher.id).for :situation }

    it { is_expected.not_to allow_value(in_education.id).for :situation }
    it { is_expected.not_to allow_value(nil).for :situation }
    it { is_expected.not_to allow_value("").for :situation }
    it { is_expected.not_to allow_value(12_345).for :situation }
    it { is_expected.not_to allow_values(0).for(:situation) }
  end
end
