require "rails_helper"

describe Crm::EventRegion do
  describe "class_methods" do
    describe ".all_ids" do
      subject { described_class.all_ids }

      it { is_expected.to eq((222_750_000..222_750_010).to_a) }
    end

    describe ".lookup_by_id" do
      specify "returns the region for the corresponding id" do
        expect(described_class.lookup_by_id(222_750_000)).to eq("East Midlands")
      end

      specify "errors when an unrecognised id is passed in" do
        expect { described_class.lookup_by_id(222_750_011) }.to raise_error(KeyError)
      end
    end
  end
end
