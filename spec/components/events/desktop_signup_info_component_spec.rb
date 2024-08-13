require "rails_helper"

describe Events::DesktopSignupInfoComponent, type: "component" do
  let(:event) { build(:event_api) }

  subject { described_class.new(event) }

  it { is_expected.to be_a(Events::EventBoxComponent) }
end
