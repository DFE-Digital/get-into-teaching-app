require "rails_helper"

describe TeacherTrainingAdviser::Steps::LifeStage do
  include_context "with wizard step"

  let(:in_education) { build(:situation, :in_education) }             # 222_750_000
  let(:on_break) { build(:situation, :on_break) }                     # 222_750_001
  let(:first_career) { build(:situation, :first_career) }             # 222_750_002
  let(:graduated) { build(:situation, :graduated) }                   # 222_750_003
  let(:change_career) { build(:situation, :change_career) }           # 222_750_004
  let(:teaching_assistant) { build(:situation, :teaching_assistant) } # 222_750_005
  let(:not_working) { build(:situation, :not_working) }               # 222_750_006
  let(:qualified_teacher) { build(:situation, :qualified_teacher) }   # 222_750_007

  let(:all_situations) do
    [in_education, on_break, first_career, graduated, change_career, teaching_assistant, not_working, qualified_teacher]
  end
  let(:valid_situation_ids) { valid_situations.map(&:id) }
  let(:invalid_situation_ids) { (all_situations - valid_situations).map(&:id) }

  before do
    allow(instance).to receive(:other_step).with(:degree_status) { instance_double(TeacherTrainingAdviser::Steps::DegreeStatus, degree_status_step_conditions) }
    allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to receive(:get_candidate_situations) { all_situations }
  end

  shared_examples "validate situation values" do
    it { is_expected.to respond_to :situation }
    it { is_expected.not_to allow_value(nil).for :situation }
    it { is_expected.not_to allow_value("").for :situation }
    it { is_expected.not_to allow_value(12_345).for :situation }
    it { is_expected.not_to allow_values(0).for(:situation) }
    it { is_expected.to validate_inclusion_of(:situation).in_array(valid_situation_ids) }
    it { is_expected.not_to validate_inclusion_of(:situation).in_array(invalid_situation_ids) }
  end

  it_behaves_like "a with wizard step"

  context "when has a degree" do
    let(:degree_status_step_conditions) { { has_degree?: true, degree_in_progress?: false, no_degree?: false } }
    let(:valid_situations) { [graduated, change_career, teaching_assistant, not_working] }

    it_behaves_like "validate situation values"
  end

  context "when degree in progress" do
    let(:degree_status_step_conditions) { { has_degree?: false, degree_in_progress?: true, no_degree?: false } }
    let(:valid_situations) { [first_career, change_career, teaching_assistant] }

    it_behaves_like "validate situation values"
  end

  context "when has not selected a degree stage" do
    let(:degree_status_step_conditions) { { has_degree?: false, degree_in_progress?: false, no_degree?: false } }
    let(:valid_situations) { [first_career, change_career, teaching_assistant] }

    it_behaves_like "validate situation values"
  end
end
