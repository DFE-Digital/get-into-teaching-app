require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Feedback do
  include_context "sanitize fields", %i[unsuccessful_visit_explanation improvements]

  describe "attributes" do
    it { is_expected.to respond_to :rating }
    it { is_expected.to respond_to :successful_visit }
    it { is_expected.to respond_to :unsuccessful_visit_explanation }
    it { is_expected.to respond_to :improvements }

    it do
      expect(subject).to define_enum_for(:rating).with_values(%i[
        very_satisfied
        satisfied
        neither_satisfied_or_dissatisfied
        dissatisfied
        very_dissatisfied
      ])
    end
  end

  describe "validation" do
    it { is_expected.to validate_presence_of(:rating) }
    it { is_expected.to allow_values(true, false).for(:successful_visit) }
    it { is_expected.not_to allow_values(nil, "").for(:successful_visit) }

    context "when successful_visit is false" do
      before { allow(subject).to receive(:successful_visit).and_return(false) }

      it { is_expected.to validate_presence_of(:unsuccessful_visit_explanation) }
    end

    context "when successful_visit is nil" do
      before { allow(subject).to receive(:successful_visit).and_return(nil) }

      it { is_expected.not_to validate_presence_of(:unsuccessful_visit_explanation) }
    end

    context "when successful_visit is true" do
      before { allow(subject).to receive(:successful_visit).and_return(true) }

      it { is_expected.not_to validate_presence_of(:unsuccessful_visit_explanation) }
    end
  end

  describe "scope" do
    describe ".recent" do
      subject { described_class.recent.map(&:created_at) }

      before do
        5.times do
          create(:feedback).tap { |f| f.update(created_at: rand(-5..5).days.ago) }
        end
      end

      it { is_expected.to eq(subject.sort.reverse) }
    end
  end

  describe "created_at scopes" do
    let(:date) { Time.zone.local(2021, 10, 5, 12) }
    let!(:feedback_before) do
      create(:feedback).tap { |f| f.update(created_at: date - 1.day) }
    end
    let!(:feedback_on_after) do
      create(:feedback).tap { |f| f.update(created_at: date + 10.minutes) }
    end
    let!(:feedback_on_before) do
      create(:feedback).tap { |f| f.update(created_at: date - 10.minutes) }
    end
    let!(:feedback_after) do
      create(:feedback).tap { |f| f.update(created_at: date + 1.day) }
    end

    describe ".on_or_after" do
      subject { described_class.on_or_after(date.to_date) }

      it { is_expected.to contain_exactly(feedback_on_before, feedback_on_after, feedback_after) }
    end

    describe ".on_or_before" do
      subject { described_class.on_or_before(date.to_date) }

      it { is_expected.to contain_exactly(feedback_on_before, feedback_on_after, feedback_before) }
    end
  end
end
