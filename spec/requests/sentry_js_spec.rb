require "rails_helper"

describe "Sentry JS", type: :request do
  subject do
    get root_path
    response.body
  end

  it { is_expected.not_to include("data-sentry-dsn") }
  it { is_expected.to include(%(data-sentry-environment="test")) }

  context "when a Sentry DSN is set" do
    before { allow(Sentry.configuration).to receive(:dsn).and_return(OpenStruct.new(raw_value: "1234")) }

    it { is_expected.to include(%(data-sentry-dsn="1234")) }
    it { is_expected.to include(%(data-sentry-environment="test")) }

    context "when production" do
      before { allow(Rails).to receive(:env) { "production".inquiry } }

      it { is_expected.not_to include("data-sentry-dsn") }
    end
  end
end
