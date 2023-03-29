require "rails_helper"

describe OptionSetHelper, type: "helper" do
  describe "#degree_status_text" do
    let(:option) { GetIntoTeachingApiClient::PickListItem.new(id: 1, value: "Graduate or postgraduate") }

    subject { degree_status_text(option) }

    it { is_expected.to eq("Yes, I already have a degree") }

    context "when the option is not recognised" do
      let(:option) { GetIntoTeachingApiClient::PickListItem.new(id: 1, value: "Postgrad") }

      it { is_expected.to eq("Postgrad") }
    end
  end
end
