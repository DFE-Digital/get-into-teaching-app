require "rails_helper"

describe GetIntoTeachingApi::EventTypes do
  include_examples "api support"

  let(:apicall) { "types/teaching_event/types" }

  let(:testdata) do
    [
      { "id": 1, "value": "First" },
      { "id": 2, "value": "Second" },
    ]
  end

  describe "#call" do
    it { is_expected.to be_kind_of Array }
    it { is_expected.to have_attributes length: 2 }
    it { is_expected.to all respond_to :id }
    it { is_expected.to all respond_to :value }

    describe "first result" do
      subject { client.call.first }
      it { is_expected.to have_attributes id: 1 }
      it { is_expected.to have_attributes value: "First" }
    end
  end
end
