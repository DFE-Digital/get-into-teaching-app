require "rails_helper"

describe Internal::Event do
  describe "attributes" do
    it { is_expected.to respond_to :id }
    it { is_expected.to respond_to :name }
    it { is_expected.to respond_to :summary }
    it { is_expected.to respond_to :description }
    it { is_expected.to respond_to :building }
    it { is_expected.to respond_to :is_online }
    it { is_expected.to respond_to :start_at }
    it { is_expected.to respond_to :end_at }
    it { is_expected.to respond_to :provider_contact_email }
    it { is_expected.to respond_to :provider_organiser }
    it { is_expected.to respond_to :provider_target_audience }
    it { is_expected.to respond_to :provider_website_url }
  end

  describe "validations" do
    describe "#name" do
      it { is_expected.to allow_value("test").for :name }
      it { is_expected.to_not allow_value("").for :name }
      it { is_expected.to_not allow_value(nil).for :name }
    end

    describe "#summary" do
      it { is_expected.to allow_value("test").for :summary }
      it { is_expected.to_not allow_value("").for :summary }
      it { is_expected.to_not allow_value(nil).for :summary }
    end

    describe "#description" do
      it { is_expected.to allow_value("test").for :description }
      it { is_expected.to_not allow_value("").for :description }
      it { is_expected.to_not allow_value(nil).for :description }
    end

    describe "#is_online" do
      it { is_expected.to allow_value(true).for :is_online }
      it { is_expected.to allow_value(false).for :is_online }
      it { is_expected.to_not allow_value(nil).for :is_online }
    end

    describe "#start_at" do
      it { is_expected.to_not allow_value(nil).for :start_at }
      it { is_expected.to_not allow_value(Time.zone.now - 1.minute).for :start_at }
      it { is_expected.to_not allow_value(Time.zone.now).for :start_at }
      it { is_expected.to allow_value(Time.zone.now + 1.minute).for :start_at }
    end

    describe "#end_at" do
      it { is_expected.to_not allow_value(nil).for :end_at }
      it { is_expected.to_not allow_value(Time.zone.now - 1.minute).for :end_at }
      it { is_expected.to_not allow_value(Time.zone.now).for :end_at }
      it { is_expected.to allow_value(Time.zone.now + 1.minute).for :end_at }

      it "is expected not to allow end at to be the same as start at" do
        subject.start_at = Time.zone.now + 1.minute
        is_expected.to_not allow_value(Time.zone.now + 1.minute).for :end_at
      end

      it "is expected not to allow end at to be earlier than start at" do
        subject.start_at = Time.zone.now + 2.minutes
        is_expected.to_not allow_value(Time.zone.now + 1.minute).for :end_at
      end

      it "is expected to allow end at to be later than start at" do
        subject.start_at = Time.zone.now + 1.minute
        is_expected.to allow_value(Time.zone.now + 2.minutes).for :end_at
      end
    end

    describe "#provider contact email" do
      it { is_expected.to allow_value("test@test.com").for :provider_contact_email }
      it { is_expected.to_not allow_value("test").for :provider_contact_email }
      it { is_expected.to_not allow_value("").for :provider_contact_email }
      it { is_expected.to_not allow_value(nil).for :provider_contact_email }
      it { is_expected.to validate_length_of(:provider_contact_email).is_at_most(100) }
    end

    describe "#provider organiser" do
      it { is_expected.to allow_value("test").for :provider_organiser }
      it { is_expected.to_not allow_value("").for :provider_organiser }
      it { is_expected.to_not allow_value(nil).for :provider_organiser }
    end

    describe "#provider target audience" do
      it { is_expected.to allow_value("test").for :provider_target_audience }
      it { is_expected.to_not allow_value("").for :provider_target_audience }
      it { is_expected.to_not allow_value(nil).for :provider_target_audience }
    end

    describe "#provider website url" do
      it { is_expected.to allow_value("test").for :provider_website_url }
      it { is_expected.to_not allow_value("").for :provider_website_url }
      it { is_expected.to_not allow_value(nil).for :provider_website_url }
    end
  end
end
