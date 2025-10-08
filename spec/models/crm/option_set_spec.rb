require "rails_helper"

describe Crm::OptionSet do
  describe "class_methods" do
    describe ".lookup_by_key" do
      it { expect(described_class.lookup_by_key(:consideration_journey_stage, :it_s_just_an_idea)).to eq(222_750_000) }
      it { expect(described_class.lookup_by_key(:mailing_list_channel, :careers_services_activity)).to eq(222_750_037) }
      it { expect { described_class.lookup_by_key(:legacy_degree_status_for_advertising, :unknown) }.to raise_error(KeyError) }
    end

    describe ".lookup_by_keys" do
      it { expect(described_class.lookup_by_keys(:consideration_journey_stage, :i_m_not_sure_and_finding_out_more, :i_m_very_sure_and_think_i_ll_apply)).to eq([222_750_001, 222_750_003]) }
      it { expect(described_class.lookup_by_keys(:mailing_list_channel, :careers_services_activity, :students_union_media)).to eq([222_750_037, 222_750_038]) }
      it { expect { described_class.lookup_by_keys(:legacy_degree_status_for_advertising, :final_year, :unknown) }.to raise_error(KeyError) }
    end

    describe ".lookup_const" do
      it { expect(described_class.lookup_const(:consideration_journey_stage)).to eq(expected_const(described_class::CONSIDERATION_JOURNEY_STAGES)) }
      it { expect(described_class.lookup_const(:mailing_list_channel)).to eq(expected_const(described_class::MAILING_LIST_CHANNELS)) }
    end

    describe ".lookup_by_value" do
      it { expect(described_class.lookup_by_value(:consideration_journey_stage, 222_750_001)).to eq(:i_m_not_sure_and_finding_out_more) }
      it { expect(described_class.lookup_by_value(:mailing_list_channel, 222_750_037)).to eq(:careers_services_activity) }
      it { expect { described_class.lookup_by_value(:legacy_degree_status_for_advertising, 0) }.to raise_error(KeyError) }
    end

    describe ".lookup_by_values" do
      it { expect(described_class.lookup_by_values(:consideration_journey_stage, 222_750_001, 222_750_003)).to eq(%i[i_m_not_sure_and_finding_out_more i_m_very_sure_and_think_i_ll_apply]) }
      it { expect(described_class.lookup_by_values(:mailing_list_channel, 222_750_037, 222_750_038)).to eq(%i[careers_services_activity students_union_media]) }
      it { expect { described_class.lookup_by_values(:legacy_degree_status_for_advertising, 222_750_037, 0) }.to raise_error(KeyError) }
    end
  end

  def expected_const(const)
    const.transform_keys { |k| k.parameterize(separator: "_").to_sym }
  end
end
