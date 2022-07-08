require "rails_helper"

describe EventStatus do
  let(:event) { build(:event_api) }

  describe "class_methods" do
    describe ".pending_id" do
      subject { described_class.pending_id }

      it { is_expected.to eq(222_750_003) }
    end

    describe ".open_id" do
      subject { described_class.open_id }

      it { is_expected.to eq(222_750_000) }
    end

    describe ".closed_id" do
      subject { described_class.closed_id }

      it { is_expected.to eq(222_750_001) }
    end
  end

  subject { described_class.new(event) }

  it { is_expected.to respond_to(:event) }

  describe "#closed?" do
    let(:event) { build(:event_api, :closed) }

    it { is_expected.to be_closed }
    it { is_expected.not_to be_pending }
    it { is_expected.not_to be_open }
  end

  describe "#open?" do
    it { is_expected.to be_open }
    it { is_expected.not_to be_closed }
    it { is_expected.not_to be_pending }
  end

  describe "#pending?" do
    let(:event) { build(:event_api, :pending) }

    it { is_expected.to be_pending }
    it { is_expected.not_to be_closed }
    it { is_expected.not_to be_open }
  end

  describe "viewable?" do
    context "when closed, future-dated" do
      let(:event) { build(:event_api, :closed) }

      it { is_expected.not_to be_viewable }
    end

    context "when closed, past" do
      let(:event) { build(:event_api, :closed, :past) }

      it { is_expected.not_to be_viewable }
    end

    context "when pending, future-dated" do
      let(:event) { build(:event_api, :pending) }

      it { is_expected.not_to be_viewable }
    end

    context "when open, future-dated" do
      let(:event) { build(:event_api) }

      it { is_expected.to be_viewable }
    end

    context "when open, past" do
      let(:event) { build(:event_api, :past) }

      it { is_expected.not_to be_viewable }
    end
  end

  describe "#accepts_online_registration?" do
    context "when QT, future-dated, open" do
      let(:event) { build(:event_api, :question_time_event) }

      it { is_expected.to be_accepts_online_registration }
    end

    context "when TTT, future-dated, open" do
      let(:event) { build(:event_api, :train_to_teach_event) }

      it { is_expected.to be_accepts_online_registration }
    end

    context "when not TTT/QT, future-dated, open" do
      let(:event) { build(:event_api, :online_event) }

      it { is_expected.not_to be_accepts_online_registration }
    end

    context "when TTT/QT, past, open" do
      let(:event) { build(:event_api, :train_to_teach_event, :past) }

      it { is_expected.not_to be_accepts_online_registration }
    end

    context "when TTT/QT, future-dated, closed" do
      let(:event) { build(:event_api, :question_time_event, :closed) }

      it { is_expected.not_to be_accepts_online_registration }
    end
  end
end
