require "rails_helper"

describe OptionSetHelper, type: "helper" do
  describe "#format_option_value" do
    let(:option) { GetIntoTeachingApiClient::PickListItem.new(id: 222_750_000, value: "Graduate or postgraduate") }
    let(:translation) { "mailing_list_steps.teacher_training.degree_status" }

    subject { format_option_value(option, translation) }

    it { is_expected.to eq("Yes") }

    context "when the option is not recognised" do
      let(:option) { GetIntoTeachingApiClient::PickListItem.new(id: 1, value: "Postgrad") }

      it { is_expected.to eq("Postgrad") }
    end
  end
end
