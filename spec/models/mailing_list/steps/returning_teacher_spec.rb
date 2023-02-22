require "rails_helper"

describe MailingList::Steps::ReturningTeacher do
  include_context "with wizard step"
  it_behaves_like "a with wizard step"

  it { is_expected.to respond_to(:qualified_to_teach) }

  describe "validations" do
    it { is_expected.to allow_values(true, false).for(:qualified_to_teach) }
    it { is_expected.not_to allow_value(nil).for(:qualified_to_teach) }
  end
end
