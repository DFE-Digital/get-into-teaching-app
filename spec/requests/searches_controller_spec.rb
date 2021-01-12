require "rails_helper"

RSpec.describe SearchesController do
  subject { response }

  describe "#show" do
    describe "JSON format" do
      context "with search term" do
        before { get search_path(q: "teaching", format: :json), xhr: true }

        it { is_expected.to have_http_status :success }
        it { is_expected.to have_attributes media_type: "application/json" }
      end

      context "without search term" do
        before { get search_path(format: :json), xhr: true }

        it { is_expected.to have_http_status :success }
        it { is_expected.to have_attributes media_type: "application/json" }
      end
    end

    describe "HTML format" do
      context "with search term" do
        before { get search_path(q: "teaching") }

        it { is_expected.to have_http_status :success }
        it { is_expected.to have_attributes media_type: "text/html" }
      end

      context "without search term" do
        before { get search_path }

        it { is_expected.to have_http_status :success }
        it { is_expected.to have_attributes media_type: "text/html" }
      end
    end
  end
end
