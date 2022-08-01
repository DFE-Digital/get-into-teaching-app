require "rails_helper"

RSpec.describe Pages::Data do
  include_context "with fixture markdown pages"

  let(:instance) { described_class.new }

  describe "#find_page" do
    include_context "with fixture markdown pages"

    subject { instance.find_page "/page1" }

    it { is_expected.to include title: "Hello World 1 Upwards" }
  end

  describe "#featured_page" do
    subject { instance.featured_page }

    before { allow(::Pages::Page).to receive(:featured).and_call_original }

    it { is_expected.to be_kind_of ::Pages::Page }
  end
end
