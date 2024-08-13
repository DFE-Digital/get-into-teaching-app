require "rails_helper"

RSpec.describe SearchesController, type: :request do
  subject { response }

  describe "#show" do
    describe "JSON format" do
      let(:json) { JSON.parse response.body }

      context "with search term" do
        before { get search_path(search: { search: "teaching" }, format: :json), xhr: true }

        it { is_expected.to have_http_status :success }
        it { is_expected.to have_attributes media_type: "application/json" }
        it { expect(json).to be_a Array }
        it { expect(json).to all be_a Hash }
      end

      context "without search term" do
        before { get search_path(format: :json), xhr: true }

        it { is_expected.to have_http_status :success }
        it { is_expected.to have_attributes media_type: "application/json" }
        it { expect(json).to be_empty }
      end

      context "with a search key but no value" do
        before { get search_path(search: "", format: :json), xhr: true }

        it { is_expected.to have_http_status :success }
        it { is_expected.to have_attributes media_type: "application/json" }
        it { expect(json).to be_empty }
      end
    end

    describe "HTML format" do
      context "with search term" do
        before { get search_path(search: { search: "teaching" }) }

        it { is_expected.to have_http_status :success }
        it { is_expected.to have_attributes media_type: "text/html" }
        it { is_expected.not_to be_indexed }
      end

      context "without search term" do
        before { get search_path }

        it { is_expected.to have_http_status :success }
        it { is_expected.to have_attributes media_type: "text/html" }
        it { is_expected.not_to be_indexed }
      end

      context "with a search key but no value" do
        before { get search_path(search: "") }

        it { is_expected.to have_http_status :success }
        it { is_expected.to have_attributes media_type: "text/html" }
        it { is_expected.not_to be_indexed }
      end
    end
  end
end
