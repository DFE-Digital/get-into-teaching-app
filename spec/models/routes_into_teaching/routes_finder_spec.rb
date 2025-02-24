require "rails_helper"

RSpec.describe RoutesIntoTeaching::RoutesFinder do
  let(:answers) do
    {
      "undergraduate_degree" => "Yes",
      "unqualified_teacher" => "Yes",
      "location" => "Yes",
    }
  end

  describe "#initialize" do
    it "sets up routes and answers" do
      finder = described_class.new(answers: answers)
      expect(finder.routes).to be_an(Array)
      expect(finder.answers).to eq(answers)
    end

    it "initializes with nil answers" do
      finder = described_class.new(answers: nil)
      expect(finder.routes).to be_an(Array)
      expect(finder.answers).to be_nil
    end
  end

  describe "#recommended" do
    let(:routes) do
      [
        {
          "title" => "Route 1",
          "matches" => [
            { "question" => "undergraduate_degree", "answers" => %w[Yes] },
            { "question" => "unqualified_teacher", "answers" => ["*"] },
            { "question" => "location", "answers" => %w[Yes] },
          ],
        },
        {
          "title" => "Route 2",
          "matches" => [
            { "question" => "undergraduate_degree", "answers" => %w[Yes] },
            { "question" => "unqualified_teacher", "answers" => %w[No] },
            { "question" => "location", "answers" => %w[No] },
          ],
        },
      ]
    end

    before do
      allow(YAML).to receive(:load_file)
        .with(RoutesIntoTeaching::Route::ROUTES_CONFIG_PATH)
        .and_return({ "routes" => routes })
    end

    describe "#recommended" do
      subject { described_class.new(answers: answers).recommended }

      context "when initialized with answers" do
        context "when all matching rules are satisfied" do
          it "returns routes that match all criteria" do
            expect(subject.size).to eq(1)
            expect(subject.map(&:title)).to contain_exactly(
              "Route 1",
            )
          end
        end

        context "when some matching rules are not satisfied" do
          it "filters out routes that do not match all criteria" do
            answers["location"] = "No"
            expect(subject).to be_empty
          end
        end

        context "with a wildcard matching rule" do
          it "matches Yes answers" do
            answers["unqualified_teacher"] = "Yes"
            expect(subject.size).to eq(1)
            expect(subject.first.title).to eq("Route 1")
          end

          it "matches No answers" do
            answers["unqualified_teacher"] = "No"
            expect(subject.size).to eq(1)
            expect(subject.first.title).to eq("Route 1")
          end
        end

        context "with missing answers" do
          let(:answers) { { "location" => "Yes" } }

          it "does not recommend routes with missing required answers" do
            expect(subject).to be_empty
          end
        end
      end

      context "when initialized with no answers" do
        let(:answers) { nil }

        it "returns all routes" do
          expect(subject.size).to eq(2)
          expect(subject.map(&:title)).to eq(routes.map { |r| r["title"] })
        end
      end
    end
  end
end
