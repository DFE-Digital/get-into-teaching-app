require "rails_helper"

describe Events::MobileSignupInfo, type: "component" do
  let(:event) { build(:event_api) }
  let(:subject) { described_class.new(event) }

  describe "#date" do
    specify "formats the date in the GOV.UK style" do
      expect(subject.date).to eql(event.start_at.to_date.to_formatted_s(:govuk))
    end
  end

  describe "#start_at" do
    specify "retrieves the start time from correctly (HH:MM)" do
      expect(subject.start_time).to eql(event.start_at.strftime("%H:%M"))
    end
  end

  describe "#end_at" do
    specify "retrieves the start time from correctly (HH:MM)" do
      expect(subject.end_time).to eql(event.end_at.strftime("%H:%M"))
    end
  end
end
