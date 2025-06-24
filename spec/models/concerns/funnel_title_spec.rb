require "rails_helper"

describe FunnelTitle do
  let(:testing_class) do
    Class.new do
      include ActiveModel::Model
      include ActiveModel::Attributes
      include FunnelTitle

      attribute :attrib1, :integer

      def self.name
        "Namespace::ExampleClass"
      end
    end
  end

  let(:instance) { testing_class.new }

  describe "#title_attribute" do
    subject { instance.title_attribute }

    it { is_expected.to eql("attrib1") }
  end

  describe "#title_class_name_scope" do
    subject { instance.title_class_name_scope }

    it { is_expected.to eql("namespace_example_class") }
  end

  describe "#title_base_scopes" do
    subject { instance.title_base_scopes }

    it { is_expected.to contain_exactly(%i[helpers legend], %i[helpers label]) }
  end

  describe "#title" do
    before do
      instance.title_base_scopes.each do |s|
        scope = s + %w[namespace_example_class]
        allow(I18n).to receive(:exists?).with("attrib1", scope: scope) { translation_exists }
        allow(I18n).to receive(:t).with("attrib1", scope: scope).and_return("Hello World")
      end
    end

    subject { instance.title }

    context "when translation is present" do
      let(:translation_exists) { true }

      it { is_expected.to eql("Hello World") }
    end

    context "when translation is missing" do
      let(:translation_exists) { false }

      it { is_expected.to be_nil }
    end
  end
end
