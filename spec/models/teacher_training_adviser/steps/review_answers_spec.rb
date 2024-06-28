require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::ReviewAnswers do
  include_context "with a TTA wizard step"
  let(:answers_by_step) do
    {
      TeacherTrainingAdviser::Steps::Identity => { "first_name": "Joe" },
      TeacherTrainingAdviser::Steps::DateOfBirth => { "date_of_birth": 20.years.ago },
      TeacherTrainingAdviser::Steps::UkAddress => { "address_postcode": "TE5 1NG" },
      TeacherTrainingAdviser::Steps::UkTelephone => { "address_telephone": "123456789" },
      TeacherTrainingAdviser::Steps::HaveADegree => { "degree_options": "studying" },
      TeacherTrainingAdviser::Steps::ReturningTeacher => {
        "type_id": TeacherTrainingAdviser::Steps::ReturningTeacher::OPTIONS[:returning_to_teaching],
      },
    }
  end

  it_behaves_like "a with wizard step"

  describe "#seen?" do
    it { is_expected.not_to be_seen }
  end

  describe "#personal_detail_answers_by_step" do
    subject { instance.personal_detail_answers_by_step }

    before do
      allow_any_instance_of(described_class).to \
        receive(:answers_by_step).and_return answers_by_step
    end

    it {
      expect(subject).to eq(answers_by_step.except(
                              TeacherTrainingAdviser::Steps::HaveADegree,
                              TeacherTrainingAdviser::Steps::ReturningTeacher,
                            ))
    }
  end

  describe "#other_answers_by_step" do
    subject { instance.other_answers_by_step }

    before do
      allow_any_instance_of(described_class).to \
        receive(:answers_by_step).and_return answers_by_step
    end

    it {
      expect(subject).to eq(answers_by_step.slice(
                              TeacherTrainingAdviser::Steps::HaveADegree,
                              TeacherTrainingAdviser::Steps::ReturningTeacher,
                            ))
    }
  end
end
