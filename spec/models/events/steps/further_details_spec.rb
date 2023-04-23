require "rails_helper"

describe Events::Steps::FurtherDetails do
  include_context "with wizard step"
  it_behaves_like "a with wizard step"

  describe "attributes" do
    it { is_expected.to respond_to :subscribe_to_mailing_list }
  end

  describe "validations" do
    describe "for subscribe_to_mailing_list" do
      it { is_expected.to allow_values("1").for :subscribe_to_mailing_list }
      it { is_expected.to allow_value("0").for :subscribe_to_mailing_list }
      it { is_expected.not_to allow_value("").for :subscribe_to_mailing_list }
    end

    describe "#already_subscribed_to_mailing_list" do
      let(:backingstore) { { "already_subscribed_to_mailing_list" => true } }

      it { is_expected.to allow_value("1").for :subscribe_to_mailing_list }
      it { is_expected.to allow_value("0").for :subscribe_to_mailing_list }
      it { is_expected.to allow_value("").for :subscribe_to_mailing_list }
    end

    describe "#already_subscribed_to_teacher_training_adviser" do
      let(:backingstore) { { "already_subscribed_to_teacher_training_adviser" => true } }

      it { is_expected.to allow_value("1").for :subscribe_to_mailing_list }
      it { is_expected.to allow_value("0").for :subscribe_to_mailing_list }
      it { is_expected.to allow_value("").for :subscribe_to_mailing_list }
    end
  end

  describe "#skipped?" do
    let(:backingstore) { { "already_subscribed_to_mailing_list" => false } }

    it { is_expected.not_to be_skipped }

    context "when already subscribed to the mailing list" do
      let(:backingstore) { { "already_subscribed_to_mailing_list" => true } }

      it { is_expected.to be_skipped }
    end
  end

  describe "#save" do
    context "when invalid" do
      before do
        subject.subscribe_to_mailing_list = nil
      end

      it "does not update the store" do
        expect(subject).not_to be_valid
        subject.save
        expect(wizardstore["subscribe_to_mailing_list"]).to be_nil
      end
    end

    context "when valid" do
      it "updates the store if the candidate subscribes" do
        subject.subscribe_to_mailing_list = true
        expect(subject).to be_valid
        subject.save
        expect(wizardstore["subscribe_to_mailing_list"]).to be_truthy
      end

      it "updates the store if the candidate does not subscribe" do
        subject.subscribe_to_mailing_list = false
        expect(subject).to be_valid
        subject.save
        expect(wizardstore["subscribe_to_mailing_list"]).to be_falsy
      end
    end
  end
end
