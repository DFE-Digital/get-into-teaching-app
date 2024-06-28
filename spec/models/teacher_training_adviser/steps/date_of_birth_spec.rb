require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::DateOfBirth do
  include_context "with a TTA wizard step"
  it_behaves_like "a with wizard step"

  it { is_expected.to be_contains_personal_details }

  describe "attributes" do
    it { is_expected.to respond_to :date_of_birth }
  end

  describe "#date_of_birth" do
    it { is_expected.not_to allow_value(nil).for :date_of_birth }
    it { is_expected.not_to allow_value(Date.new(1900, 1, 1)).for :date_of_birth }
    it { is_expected.not_to allow_value(1.year.from_now).for :date_of_birth }
    it { is_expected.not_to allow_value(13.years.ago).for :date_of_birth }
    it { is_expected.to allow_value(18.years.ago).for :date_of_birth }

    context "when validating" do
      it "adds a custom error when an invalid date is entered" do
        subject.date_of_birth = { 3 => -1, 2 => -1, 1 => -1 }
        expect(subject).not_to be_valid
        expect(subject.errors[:date_of_birth]).to include("You did not enter a valid date of birth")
      end
    end
  end

  describe "#reviewable_answers" do
    subject { instance.reviewable_answers }

    let(:date) { Date.new(1986, 3, 12) }

    before { instance.date_of_birth = date }

    it { is_expected.to eq({ "date_of_birth" => date }) }
  end
end
