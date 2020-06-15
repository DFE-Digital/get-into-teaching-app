shared_context "wizard store" do
  let(:backingstore) { { name: "Joe", age: 35 } }
  let(:wizardstore) { Wizard::Store.new backingstore }
end

shared_examples "a wizard step" do
  it { expect(subject.class).to respond_to :key }
  it { is_expected.to respond_to :save }
end
