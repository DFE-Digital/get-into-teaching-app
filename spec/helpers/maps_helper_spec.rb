require "rails_helper"

RSpec.describe MapsHelper, type: :helper do
  let(:destination) { "7 Main Street, Edinburgh" }
  let(:uri_encoded_destination) { "7%20Main%20Street%2C%20Edinburgh" }
  let(:zoom) { 8 }

  before do
    allow(Rails.application.config.x).to receive(:google_maps_key).and_return("12345")
  end

  describe ".static_map_url" do
    subject do
      static_map_url(destination, mapsize: [300, 200], zoom: zoom)
    end

    it("returns a correct Google Maps url") do
      url = "https://maps.googleapis.com/maps/api/staticmap"
      params = "center=#{uri_encoded_destination}&key=12345&markers=#{uri_encoded_destination}&scale=2&size=300x200&zoom=#{zoom}"
      expect(subject).to eq("#{url}?#{params}")
    end
  end

  describe ".ajax_map" do
    subject { ajax_map(destination, mapsize: [300, 200], zoom: zoom) }

    it "includes wrapping div" do
      expect(subject).to match('class="embedded-map"')
    end

    it "includes map container div" do
      expect(subject).to match('class="embedded-map__inner-container"')
    end

    it "includes nested non-js fallback img" do
      expect(subject).to match(/<img /)
      expect(subject).to match(";markers=#{uri_encoded_destination}")
    end
  end

  describe ".external_map_url" do
    subject { external_map_url(destination: destination, name: "test", zoom: zoom) }

    it "adds in destination" do
      expect(subject).to \
        eq("https://www.google.com/maps/dir/?api=1&destination=#{uri_encoded_destination}")
    end
  end
end
