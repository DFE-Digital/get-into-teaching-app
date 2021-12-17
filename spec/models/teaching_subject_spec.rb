require "rails_helper"

describe TeachingSubject do
  describe "class_methods" do
    describe ".lookup_by_key" do
      it { expect(described_class.lookup_by_key(:physics)).to eq("ac2655a1-2afa-e811-a981-000d3a276620") }
      it { expect(described_class.lookup_by_key(:languages_other)).to eq("a22655a1-2afa-e811-a981-000d3a276620") }
      it { expect { described_class.lookup_by_key(:unknown) }.to raise_error(KeyError) }
    end

    describe ".lookup_by_keys" do
      it "returns uuids for matching subjects" do
        expect(described_class.lookup_by_keys(:physics, :languages_other)).to \
          eq(%w[ac2655a1-2afa-e811-a981-000d3a276620 a22655a1-2afa-e811-a981-000d3a276620])
      end

      it { expect { described_class.lookup_by_keys(:physics, :unknown) }.to raise_error(KeyError) }
    end

    describe ".lookup_by_uuid" do
      it { expect(described_class.lookup_by_uuid("ac2655a1-2afa-e811-a981-000d3a276620")).to eq("Physics") }
      it { expect(described_class.lookup_by_uuid("a22655a1-2afa-e811-a981-000d3a276620")).to eq("Languages (other)") }
      it { expect(described_class.lookup_by_uuid("00000000-0000-0000-0000-000000000000")).to be_nil }
    end

    describe ".keyed_subjects" do
      subject(:keyed_subjects) { described_class.keyed_subjects }

      it { is_expected.to include({ physics: "ac2655a1-2afa-e811-a981-000d3a276620" }) }
      it { is_expected.to include({ languages_other: "a22655a1-2afa-e811-a981-000d3a276620" }) }
      it { expect(keyed_subjects.count).to eq(described_class::ALL.count) }
    end

    describe ".key_with_uuid" do
      it { expect(described_class.key_with_uuid("ac2655a1-2afa-e811-a981-000d3a276620")).to eq(:physics) }
      it { expect(described_class.key_with_uuid("a22655a1-2afa-e811-a981-000d3a276620")).to eq(:languages_other) }
      it { expect(described_class.key_with_uuid("00000000-0000-0000-0000-000000000000")).to be_nil }
    end

    describe ".all_uuids" do
      subject { described_class.all_uuids }

      it { is_expected.to eq(described_class::ALL.values) }
    end

    describe ".all_subjects" do
      subject { described_class.all_subjects }

      it { is_expected.to eq(described_class::ALL.keys) }
    end

    describe ".ignore?" do
      it { expect(described_class).to be_ignore(described_class::IGNORED.values.sample) }
      it { expect(described_class).not_to be_ignore(described_class.all_uuids.sample) }
    end
  end
end
