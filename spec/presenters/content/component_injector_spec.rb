require "rails_helper"

RSpec.describe Content::ComponentInjector, type: :component do
  {
    "quote" => {
      "text" => "simple",
    },
  }.each do |type, params|
    describe "rendering a #{type} component" do
      subject { described_class.new(type, params).component }

      it "generates a view component of the correct type from the arguments" do
        component_class = "Content::#{type.camelize}Component".constantize
        expect(component_class).to receive(:new)
          .with(params.deep_symbolize_keys).and_call_original
        is_expected.to be_a(component_class)
      end
    end
  end
end
