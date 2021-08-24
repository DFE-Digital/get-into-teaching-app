require "rails_helper"

describe Events::DesktopSignupInfo, type: "component" do
  let(:event) { build(:event_api) }
  let(:subject) { described_class.new(event) }

  it { is_expected.to be_a_kind_of(Events::EventBoxComponent) }

  describe "#divider_thin" do
    specify "generates a diviider with the thin class" do
      expect(subject.divider_thin).to start_with("<hr")
      expect(subject.divider_thin).to include("event-box__divider thin")
    end
  end
end
