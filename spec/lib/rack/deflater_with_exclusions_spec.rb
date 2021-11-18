require "rails_helper"
require_relative "../../../lib/rack/deflater_with_exclusions"

describe Rack::DeflaterWithExclusions do
  let(:app) { ->(_env) { [200, { "Content-Type" => "text/plain" }, %w[OK]] } }
  let(:instance) do
    described_class.new(
      app,
      exclude: proc { |_env|
        exclude
      },
    )
  end

  describe "#call" do
    let(:env) { {} }

    subject(:call) { instance.call(env) }

    context "when not excluded" do
      let(:exclude) { false }

      it "calls parent" do
        expect_any_instance_of(Rack::Deflater).to receive(:call)
        call
      end
    end

    context "when excluded" do
      let(:exclude) { true }

      it "does not call parent, instead calls on app" do
        expect_any_instance_of(Rack::Deflater).not_to receive(:call)
        expect(app).to receive(:call)
        call
      end
    end
  end
end
