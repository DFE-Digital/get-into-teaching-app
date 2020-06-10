require "rails_helper"

describe Wizard::Step do
  class FirstStep < Wizard::Step
    attribute :name
    attribute :age, :integer
    validates :name, presence: true
  end

  describe ".key" do
    it { expect(described_class.key).to eql "step" }
    it { expect(FirstStep.key).to eql "first_step" }
  end

  describe ".new" do
    let(:store) { Wizard::Store.new name: "Joe", age: 30 }
    subject { FirstStep.new store, age: "20" }
    it { is_expected.to be_instance_of FirstStep }
    it { is_expected.to have_attributes name: "Joe" }
    it { is_expected.to have_attributes age: 20 }
  end

  describe "#save" do
    let(:backingstore) { {} }
    let(:store) { Wizard::Store.new backingstore }

    context "when valid" do
      subject { FirstStep.new store, name: "Jane" }
      let!(:result) { subject.save }

      it { expect(result).to be true }
      it { expect(store[:name]).to eql "Jane" }
    end

    context "when invalid" do
      subject { FirstStep.new store, age: 30 }
      let!(:result) { subject.save }

      it { expect(result).to be false }
      it { is_expected.to have_attributes errors: hash_including(:name) }
    end
  end
end
