require "rails_helper"

describe Wizard::Store do
  let(:backingstore) do
    { "first_name" => "Joe", "age" => 20, "region" => "Manchester" }
  end
  let(:instance) { described_class.new backingstore }
  subject { instance }

  describe ".new" do
    context "with valid source data" do
      it { is_expected.to be_instance_of(Wizard::Store) }
      it { is_expected.to have_attributes data: backingstore }
      it { is_expected.to respond_to :[] }
      it { is_expected.to respond_to :[]= }
    end

    context "with invalid source data" do
      subject { described_class.new nil }

      it "should raise an InvalidBackingStore" do
        expect { subject }.to raise_exception(Wizard::Store::InvalidBackingStore)
      end
    end
  end

  describe "#[]" do
    context "first_name" do
      subject { instance["first_name"] }
      it { is_expected.to eql "Joe" }
    end

    context "age" do
      subject { instance["age"] }
      it { is_expected.to eql 20 }
    end
  end

  describe "#[]=" do
    it "will update stored value" do
      expect { subject["first_name"] = "Jane" }.to \
        change { subject["first_name"] }.from("Joe").to("Jane")
    end
  end

  describe "#fetch" do
    context "with multiple keys" do
      subject { instance.fetch :first_name, :region }
      it "will return hash of requested keys" do
        is_expected.to eql({ "first_name" => "Joe", "region" => "Manchester" })
      end
    end

    context "with array of keys" do
      subject { instance.fetch %w[first_name region] }
      it "will return hash of requested keys" do
        is_expected.to eql({ "first_name" => "Joe", "region" => "Manchester" })
      end
    end
  end

  describe "#purge!" do
    before { instance.purge! }
    subject { instance.keys }

    it "will remove all keys" do
      is_expected.to have_attributes empty?: true
    end
  end
end
