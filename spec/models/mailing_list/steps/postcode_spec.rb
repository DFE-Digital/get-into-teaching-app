require "rails_helper"

describe MailingList::Steps::Postcode do
  include_context "wizard step"
  it_behaves_like "a wizard step"

  it { is_expected.to respond_to :address_postcode }

  context "address_postcode" do
    it { is_expected.to allow_value("TE57 1NG").for :address_postcode }
    it { is_expected.to allow_value("  TE571NG  ").for :address_postcode }
    it { is_expected.not_to allow_value(nil).for :address_postcode }
    it { is_expected.not_to allow_value("").for :address_postcode }
    it { is_expected.not_to allow_value("random").for :address_postcode }
  end
end
