require "rails_helper"

RSpec.describe Pages::Page do
  include_context "use fixture markdown pages"

  describe "#find" do
    context "with markdown page" do
      subject { described_class.find "/page1" }

      it { is_expected.to be_instance_of Pages::Page }
      it { is_expected.to have_attributes title: "Hello World 1" }
      it { is_expected.to have_attributes path: "/page1" }
      it { is_expected.to have_attributes template: "content/page1" }
    end

    context "with non markdown page" do
      subject { described_class.find "/unknown" }

      it { is_expected.to be_instance_of Pages::Page }
      it { is_expected.to have_attributes title: nil }
      it { is_expected.to have_attributes path: "/unknown" }
      it { is_expected.to have_attributes template: "content/unknown" }
    end
  end
end
