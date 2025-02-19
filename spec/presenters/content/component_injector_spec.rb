require "rails_helper"

RSpec.describe Content::ComponentInjector, type: :component do
  {
    "quote" => {
      "text" => "simple",
    },
  }.each do |type, params|
    describe "rendering a #{type} component" do
      subject { described_class.new(type, params).component }

      let(:component_class) { "Content::#{type.camelize}Component".constantize }

      it "generates a view component of the correct type" do
        is_expected.to be_a(component_class)
      end

      it "component receives the correct arguments" do
        expect(component_class).to receive(:new).with(params.deep_symbolize_keys)
        subject
      end
    end
  end
end
