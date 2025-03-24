require "rails_helper"

RSpec.describe RoutesIntoTeaching::Route do
  let(:route_finder) { instance_double(RoutesIntoTeaching::RoutesFinder, answers: answers) }
  let(:answers) { { "question1" => "answer1", "question2" => "answer2" } }

  let(:route_data) do
    {
      "title" => "Test Route",
      "course_length" => "1 year",
      "course_fee" => "£9,250",
      "funding" => "Bursaries available",
      "description" => "A test route description",
      "cta_text" => "Learn more",
      "cta_link" => "/test-link",
      "matches" => [
        { "question" => "question1", "answers" => %w[answer1] },
      ],
      "highlight" => {
        "text" => "Highlighted route",
        "matches" => [
          { "question" => "question2", "answers" => %w[answer2] },
        ],
      },
    }
  end

  describe ".all" do
    before do
      allow(YAML).to receive(:load_file)
        .with(described_class::ROUTES_CONFIG_PATH)
        .and_return({ "routes" => [route_data] })
    end

    it "loads routes from YAML file" do
      routes = described_class.all
      expect(routes).to be_an(Array)
      expect(routes.first).to be_a(described_class)
    end

    it "passes route_finder to each route when provided" do
      routes = described_class.all(route_finder: route_finder)
      expect(routes.first.route_finder).to eq(route_finder)
    end
  end

  describe "#initialize" do
    subject(:route) { described_class.new(route_data, route_finder) }

    it "sets all attributes from the route data" do
      expect(route.title).to eq("Test Route")
      expect(route.course_length).to eq("1 year")
      expect(route.course_fee).to eq("£9,250")
      expect(route.funding).to eq("Bursaries available")
      expect(route.description).to eq("A test route description")
      expect(route.cta_text).to eq("Learn more")
      expect(route.cta_link).to eq("/test-link")
      expect(route.matches).to be_an(Array)
      expect(route.highlight).to be_a(Hash)
      expect(route.highlight_text).to eq("Highlighted route")
      expect(route.route_finder).to eq(route_finder)
    end

    context "when initialized without a route_finder" do
      subject(:route) { described_class.new(route_data) }

      it "sets route_finder to nil" do
        expect(route.route_finder).to be_nil
      end
    end
  end

  describe "#highlighted?" do
    subject(:route) { described_class.new(route_data, route_finder) }

    context "when route has no route_finder" do
      let(:route_finder) { nil }

      it "returns false" do
        expect(route).not_to be_highlighted
      end
    end

    context "when route has no highlight data" do
      let(:route_data) { super().tap { |d| d.delete("highlight") } }

      it "returns false" do
        expect(route).not_to be_highlighted
      end
    end

    context "when all highlight match conditions are met" do
      it "returns true" do
        expect(route).to be_highlighted
      end
    end

    context "when highlight matches include wildcard" do
      let(:route_data) do
        super().tap do |d|
          d["highlight"]["matches"] = [
            { "question" => "question2", "answers" => ["*"] },
          ]
        end
      end

      it "returns true for any answer" do
        expect(route).to be_highlighted
      end
    end

    context "when highlight match conditions are not met" do
      let(:answers) { { "question2" => "wrong_answer" } }

      it "returns false" do
        expect(route).not_to be_highlighted
      end
    end
  end
end
