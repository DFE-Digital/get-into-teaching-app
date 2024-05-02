require "rails_helper"

describe Value do
  describe "##data (class method)" do
    subject { described_class.data }

    it { is_expected.to be_a Hash }
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
            "data1_example_amount" => "£1,234.56",
            "data1_example_date" => "01/02/2003",
            "data2_example_number" => 0.01,
            "data2_example_string" => "Hello World!",
          },
        )
      }
    end
  end
end
