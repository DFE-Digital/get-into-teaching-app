require "rails_helper"

describe Wizard::Step do
  include_context "with wizard store"

  class FirstStep < Wizard::Step
    attribute :name
    attribute :age, :integer
    validates :name, presence: true
  end

  let(:attributes) { {} }
  subject { FirstStep.new nil, wizardstore, attributes }

  describe ".key" do
    it { expect(described_class.key).to eql "step" }
    it { expect(FirstStep.key).to eql "first_step" }
  end

  describe ".title" do
    it { expect(described_class.title).to eql "Step" }
    it { expect(FirstStep.title).to eql "First step" }
  end

  describe ".new" do
    let(:attributes) { { age: "20" } }
    it { is_expected.to be_instance_of FirstStep }
    it { is_expected.to have_attributes key: "first_step" }
    it { is_expected.to have_attributes id: "first_step" }
    it { is_expected.to have_attributes persisted?: true }
    it { is_expected.to have_attributes name: "Joe" }
    it { is_expected.to have_attributes age: 20 }
    it { is_expected.to have_attributes skipped?: false }
    it { is_expected.to have_attributes optional?: false }
    it { is_expected.to have_attributes can_proceed?: true }
  end

  describe "#skipped?" do
    context "when optional" do
      before { expect(subject).to receive(:optional?) { true } }

      context "when values for all attributes are present in the CRM" do
        before do
          crm_backingstore["name"] = "John"
          crm_backingstore["age"] = 18
        end

        it { is_expected.to be_skipped }
      end

      context "when values for some attributes are present in the CRM" do
        before do
          crm_backingstore["name"] = "John"
          crm_backingstore["age"] = nil
        end

        it { is_expected.not_to be_skipped }
      end
    end

    context "when not optional" do
      before { expect(subject).to receive(:optional?) { false } }

      context "when values for all attributes are present in the CRM" do
        before do
          crm_backingstore["name"] = "John"
          crm_backingstore["age"] = 18
        end

        it { is_expected.to_not be_skipped }
      end
    end
  end

  describe "#flash_error" do
    before { subject.flash_error("error message") }

    it { expect(subject.errors[:base]).to include("error message") }
  end

  describe "#save" do
    let(:backingstore) { {} }

    context "when valid" do
      let(:attributes) { { name: "Jane" } }
      let!(:result) { subject.save }

      it { expect(result).to be true }
      it { expect(wizardstore[:name]).to eql "Jane" }
    end

    context "when invalid" do
      let(:attributes) { { age: 30 } }
      let!(:result) { subject.save }

      it { expect(result).to be false }
      it { is_expected.to have_attributes errors: hash_including(:name) }
    end
  end

  describe "#export" do
    let(:backingstore) { { "name" => "Joe" } }
    let(:instance) { FirstStep.new nil, wizardstore, age: 35 }
    subject { instance.export }
    it { is_expected.to include "name" => "Joe" }
    it { is_expected.to include "age" => nil } # should only export persisted data

    context "when the step is skipped" do
      let(:crm_backingstore) { { "name" => "Jimmy" } }

      before { expect(instance).to receive(:skipped?) { true } }

      it { is_expected.to include "name" => "Jimmy" }
      it { is_expected.to include "age" => nil } # should only export persisted data
    end
  end
end
