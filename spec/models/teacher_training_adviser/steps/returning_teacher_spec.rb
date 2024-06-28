require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::ReturningTeacher do
  include_context "with a TTA wizard step"
  it_behaves_like "a with wizard step"

  describe "attributes" do
    it { is_expected.to respond_to :type_id }
  end

  describe "#returning_to_teaching" do
    subject { instance.returning_to_teaching }

    context "when type_id is :returning_to_teaching" do
      before { instance.type_id = described_class::OPTIONS[:returning_to_teaching] }

      it { is_expected.to be_truthy }
    end

    context "when type_id is :interested_in_teaching" do
      before { instance.type_id = described_class::OPTIONS[:interested_in_teaching] }

      it { is_expected.to be_falsy }
    end
  end

  describe "#type_id" do
    it { is_expected.not_to allow_values("", nil, 123).for :type_id }
    it { is_expected.to allow_value(*described_class::OPTIONS.values).for :type_id }
  end

  describe "#reviewable_answers" do
    subject { instance.reviewable_answers }

    context "when returning to teaching" do
      before { instance.type_id = described_class::OPTIONS[:returning_to_teaching] }

      it { is_expected.to eq({ "returning_to_teaching" => "Yes" }) }
    end

    context "when interested in teaching" do
      before { instance.type_id = described_class::OPTIONS[:interested_in_teaching] }

      it { is_expected.to eq({ "returning_to_teaching" => "No" }) }
    end
  end
end
