require "rails_helper"

RSpec.describe Pages::Data do
  include_context "use fixture markdown pages"

  let(:instance) { described_class.new }

  describe "#find_page" do
    subject { instance.find_page "/page1" }
    it { is_expected.to include title: "Hello World 1" }
  end
end
