require "rails_helper"

describe Wizard::Stores::Combined do
  let(:app_data) { { "first_name" => "Joe", "age" => 20 } }
  let(:crm_data) { { "first_name" => "James", "region" => "Manchester" } }
  let(:instance) { described_class.new app_data, crm_data }

  describe "#[]" do
    context "when the attribute exists in app and crm data" do
      subject { instance["first_name"] }

      it { is_expected.to eq("Joe") }
    end

    context "when the attribute exists in only the app data" do
      subject { instance["age"] }

      it { is_expected.to eq(20) }
    end

    context "when the attribute exists in only the crm data" do
      subject { instance["region"] }

      it { is_expected.to eq("Manchester") }
    end
  end

  describe "#crm" do
    it { expect(instance.crm(:first_name)).to eq("James") }
    it { expect(instance.crm(:age)).to be_nil }
  end

  describe "#fetch" do
    context "with multiple keys" do
      subject { instance.fetch :first_name, :age, :region, source: source }

      context "when source is both" do
        let(:source) { :both }

        it { is_expected.to eql({ "first_name" => "Joe", "age" => 20, "region" => "Manchester" }) }
      end

      context "when source is app" do
        let(:source) { :app }

        it { is_expected.to eql({ "first_name" => "Joe", "age" => 20, "region" => nil }) }
      end

      context "when source is crm" do
        let(:source) { :crm }

        it { is_expected.to eql({ "first_name" => "James", "age" => nil, "region" => "Manchester" }) }
      end
    end

    context "with array of keys" do
      subject { instance.fetch %w[first_name age region] }

      it { is_expected.to eql({ "first_name" => "Joe", "age" => 20, "region" => "Manchester" }) }
    end

    context "when a key is not present in the store" do
      subject { instance.fetch %w[first_name missing_key] }

      it "will return it with a nil value in the hash" do
        is_expected.to eql({ "first_name" => "Joe", "missing_key" => nil })
      end
    end
  end

  describe "#persist" do
    let(:source) { :app }

    before { instance.persist({ first_name: "Jim", age: 23 }, source: source) }
    subject { instance.fetch(:first_name, :age, source: source) }

    it { is_expected.to be_truthy }
    it { is_expected.to eq({ "first_name" => "Jim", "age" => 23 }) }

    context "when source is crm" do
      let(:source) { :crm }

      it { is_expected.to eq({ "first_name" => "Jim", "age" => 23 }) }
    end

    context "when soruce is not app/crm" do
      it { expect { instance.persist({}, source: :both) }.to raise_error(ArgumentError) }
    end
  end

  describe "#purge!" do
    before { instance.purge! }
    subject { instance.keys }

    it "removes all keys" do
      is_expected.to have_attributes empty?: true
    end
  end
end
