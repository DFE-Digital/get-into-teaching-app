require "rails_helper"

describe Wizard::Base do
  include_context "wizard store"

  class Name < Wizard::Step
    attribute :name
  end

  class Age < Wizard::Step
    attribute :age, :integer
  end

  class Postcode < Wizard::Step
    attribute :postcode
  end

  class TestWizard < Wizard::Base
    self.steps = [Name, Age, Postcode].freeze
  end

  let(:wizardclass) { TestWizard }
  let(:wizard) { wizardclass.new wizardstore, "age" }

  describe ".indexed_steps" do
    subject { wizardclass.indexed_steps }
    it { is_expected.to eql("name" => Name, "age" => Age, "postcode" => Postcode) }
  end

  describe ".step" do
    it "will return steps class for valid step" do
      expect(wizardclass.step("age")).to eql Age
    end

    it "will raise exception for unknown step" do
      expect { wizardclass.step("unknown") }.to \
        raise_exception(Wizard::UnknownStep)
    end
  end

  describe ".step_index" do
    it "will return index for known step" do
      expect(wizardclass.step_index("age")).to eql 1
    end

    it "will raise exception for unknown step" do
      expect { wizardclass.step_index("unknown") }.to \
        raise_exception(Wizard::UnknownStep)
    end
  end

  describe ".step_keys" do
    subject { wizardclass.step_keys }
    it { is_expected.to eql %w[name age postcode] }
  end

  describe ".new" do
    it "should return instance for known step" do
      expect(wizardclass.new(wizardstore, "name")).to be_instance_of wizardclass
    end

    it "should raise exception for unknown step" do
      expect { wizardclass.new wizardstore, "unknown" }.to \
        raise_exception Wizard::UnknownStep
    end
  end

  describe "#current_step" do
    subject { wizardclass.new(wizardstore, "name").current_step }
    it { is_expected.to eql "name" }
  end

  describe "#find" do
    subject { wizard.find("age") }
    it { is_expected.to be_instance_of Age }
    it { is_expected.to have_attributes age: 35 }
  end

  describe "#find_current_step" do
    subject { wizard.find_current_step }
    it { is_expected.to be_instance_of Age }
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

    context "when no step supplied" do
      subject { wizard.previous_step }
      it { is_expected.to eql "name" }
    end
  end

  describe "#next_step" do
    context "when there are more steps" do
      subject { wizard.next_step("age") }
      it { is_expected.to eql "postcode" }
    end

    context "when there are no more steps" do
      subject { wizard.next_step("postcode") }
      it { is_expected.to be_nil }
    end

    context "when no step supplied" do
      subject { wizard.next_step }
      it { is_expected.to eql "postcode" }
    end
  end
end
