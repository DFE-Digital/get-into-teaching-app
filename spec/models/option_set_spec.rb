require "rails_helper"

describe OptionSet do
  describe "class_methods" do
    describe ".lookup_by_key" do
      it { expect(described_class.lookup_by_key(:degree_status, :final_year)).to eq(222_750_001) }
      it { expect(described_class.lookup_by_key(:mailing_list_channel, :careers_services_activity)).to eq(222_750_037) }
      it { expect { described_class.lookup_by_key(:degree_status, :unknown) }.to raise_error(KeyError) }
    end

    describe ".lookup_by_keys" do
      it { expect(described_class.lookup_by_keys(:degree_status, :final_year, :first_year)).to eq([222_750_001, 222_750_003]) }
      it { expect(described_class.lookup_by_keys(:mailing_list_channel, :careers_services_activity, :students_union_media)).to eq([222_750_037, 222_750_038]) }
      it { expect { described_class.lookup_by_keys(:degree_status, :final_year, :unknown) }.to raise_error(KeyError) }
    end

    describe ".lookup_const" do
      it { expect(described_class.lookup_const(:degree_status)).to eq(expected_const(described_class::DEGREE_STATUSES)) }
      it { expect(described_class.lookup_const(:consideration_journey_stage)).to eq(expected_const(described_class::CONSIDERATION_JOURNEY_STAGES)) }
      it { expect(described_class.lookup_const(:mailing_list_channel)).to eq(expected_const(described_class::MAILING_LIST_CHANNELS)) }
    end
  end

  def expected_const(const)
    const.transform_keys { |k| k.parameterize(separator: "_").to_sym }
  end
end
