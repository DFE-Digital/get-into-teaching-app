require "rails_helper"

describe Value do
  describe "##data (class method)" do
    subject { described_class.data }

    it { is_expected.to be_a Hash }
  end

  describe "##normalise_key (class method)" do
    subject { described_class.normalise_key(key) }

    context "when the key contains unsupported characters" do
      let(:key) { "this-is!a{test}_key#123£567" }

      it { is_expected.to be(:this_is_a_test__key_123_567) }

      it { is_expected.to be_a Symbol }
    end
  end

  describe "##get (class method)" do
    before do
      described_class.remove_class_variable :@@data if described_class.class_variable_defined? :@@data
      stub_const("Value::PATH", "spec/fixtures/files/example_values/**/*.yml")
    end

    after do
      described_class.remove_class_variable :@@data if described_class.class_variable_defined? :@@data
    end

    subject { described_class.get(key) }

    context "when the key contains hyphens" do
      let(:key) { "data2-example-value-with-hyphens" }

      it { is_expected.to eql("A-value-with-hyphens") }
    end

    context "when the key contains undersscores" do
      let(:key) { :data2_example_value_with_hyphens }

      it { is_expected.to eql("A-value-with-hyphens") }
    end
  end

  describe "#get" do
    subject { described_class.new(path).get(key) }

    let(:path) { "spec/fixtures/files/example_values/**/*.yml" }

    context "when the key contains hyphens" do
      let(:key) { "data2-example-value-with-hyphens" }

      it { is_expected.to eql("A-value-with-hyphens") }
    end

    context "when the key contains underscores" do
      let(:key) { :data2_example_value_with_hyphens }

      it { is_expected.to eql("A-value-with-hyphens") }
    end
  end

  describe "#data" do
    subject { instance.data }

    let(:instance) { described_class.new(path) }

    context "with default path" do
      let(:path) { nil }

      it { is_expected.to be_a Hash }
    end

    context "with specific file path" do
      let(:path) { "spec/fixtures/files/example_values/**/*.yml" }

      it {
        is_expected.to eql(
          {
            data1_example_amount: "£1,234.56",
            data1_example_date: "01/02/2003",
            data2_example_number: 0.01,
            data2_example_string: "Hello World!",
            "data2_example_value_with_hyphens": "A-value-with-hyphens",
          },
        )
      }
    end
  end
end
