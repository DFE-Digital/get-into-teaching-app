shared_context "wizard store" do
  let(:backingstore) { { "name" => "Joe", "age" => 35 } }
  let(:wizardstore) { Wizard::Store.new backingstore }
end

shared_examples "a wizard step" do
  it { expect(subject.class).to respond_to :key }
  it { is_expected.to respond_to :save }
end

class TestWizard < Wizard::Base
  class Name < Wizard::Step
    attribute :name
    validates :name, presence: true
  end

  class Age < Wizard::Step
    attribute :age, :integer
    validates :age, presence: true
  end

  class Postcode < Wizard::Step
    attribute :postcode
    validates :postcode, presence: true
  end

  self.steps = [Name, Age, Postcode].freeze
end
