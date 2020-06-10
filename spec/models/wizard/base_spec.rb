require "rails_helper"

describe Wizard::Base do
  class Name < Wizard::Step
    attribute :name
  end

  class Age < Wizard::Step
    attribute :age, :integer
  end

  class Address < Wizard::Step
    attribute :postcode
  end

  class TestWizard < Wizard::Base
    self.steps = [Name, Age, Address].freeze
  end

  let(:wizardclass) { TestWizard }
  let(:backingstore) { { name: "Joe", age: 35 } }
  let(:store) { Wizard::Store.new backingstore }
  let(:wizard) { wizardclass.new store }

  describe ".indexed_steps" do
    subject { wizardclass.indexed_steps }
    it { is_expected.to eql("name" => Name, "age" => Age, "address" => Address) }
  end

  describe ".step" do
    it "will return steps class for valid step" do
      expect(wizardclass.step("age")).to eql Age
    end

    it "will raise exception for unknown step" do
      expect { wizardclass.step("unknown") }.to \
        raise_exception(Wizard::Base::UnknownStep)
    end
  end

  describe ".step_index" do
    it "will return index for known step" do
      expect(wizardclass.step_index("age")).to eql 1
    end

    it "will raise exception for unknown step" do
      expect { wizardclass.step_index("unknown") }.to \
        raise_exception(Wizard::Base::UnknownStep)
    end
  end

  describe "#find" do
    subject { wizard.find("age") }
    it { is_expected.to be_instance_of Age }
    it { is_expected.to have_attributes age: 35 }
  end

  describe "#previous_step" do
    context "when there are more steps" do
      subject { wizard.previous_step("age") }
      it { is_expected.to eql "name" }
    end

    context "when there are no more steps" do
      subject { wizard.previous_step("name") }
      it { is_expected.to be_nil }
    end
  end

  describe "#next_step" do
    context "when there are more steps" do
      subject { wizard.next_step("age") }
      it { is_expected.to eql "address" }
    end

    context "when there are no more steps" do
      subject { wizard.next_step("address") }
      it { is_expected.to be_nil }
    end
  end
end
