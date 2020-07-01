require "rails_helper"

describe MailingList::Steps::Postcode do
  include_context "wizard step"
  it_behaves_like "a wizard step"

  it { is_expected.to respond_to :postcode }

  context "postcode" do
    it { is_expected.to allow_value("TE57 1NG").for :postcode }
    it { is_expected.to allow_value("  TE571NG  ").for :postcode }
    it { is_expected.not_to allow_value(nil).for :postcode }
    it { is_expected.not_to allow_value("").for :postcode }
    it { is_expected.not_to allow_value("random").for :postcode }
  end
end
