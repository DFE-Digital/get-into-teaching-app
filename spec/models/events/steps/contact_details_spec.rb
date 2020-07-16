require "rails_helper"

describe Events::Steps::ContactDetails do
  include_context "wizard step"

  it_behaves_like "a wizard step"

  it { is_expected.to respond_to :telephone }

  context "validations" do
    it { is_expected.to allow_value("").for :telephone }
    it { is_expected.to allow_value("01234567890").for :telephone }
    it { is_expected.to allow_value("01234 567890").for :telephone }
    it { is_expected.not_to allow_value("invalid").for :telephone }
    it { is_expected.not_to allow_value("01234").for :telephone }
  end

  context "data cleaning" do
    let(:attributes) { { telephone: "  01234567890 " } }
    before { subject.valid? }
    it { is_expected.to have_attributes telephone: "01234567890" }
  end
end
