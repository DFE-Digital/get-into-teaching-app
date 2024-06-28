require "rails_helper"

describe Events::DesktopSignupInfoComponent, type: "component" do
  let(:event) { build(:event_api) }
  let(:subject) { described_class.new(event) }

  it { is_expected.to be_a_kind_of(Events::EventBoxComponent) }
end
