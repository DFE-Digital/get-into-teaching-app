require "rails_helper"

RSpec.describe RoutesIntoTeaching::Routes, type: :model do
  let(:yaml) do
    {
      "routes" => [
        {
          "title" => "Route 1",
          "matches" => [
            { "question" => "undergraduate_degree", "answers" => ["Yes"] },
            { "question" => "unqualified_teacher", "answers" => ["*"] },
            { "question" => "location", "answers" => ["Yes"] }
          ]
        },
        {
          "title" => "Route 2",
          "matches" => [
            { "question" => "undergraduate_degree", "answers" => ["Yes"] },
            { "question" => "unqualified_teacher", "answers" => ["No"] },
            { "question" => "location", "answers" => ["No"] },
          ]
        }
      ]
    }
  end

  let(:answers) do
    {
      "undergraduate_degree" => "Yes",
      "unqualified_teacher" => "Yes",
      "location" => "Yes"
    }
  end

  before { allow(YAML).to receive(:load_file).and_return(yaml) }

  describe ".all" do
    subject { described_class.all }

    it "returns all routes from the YAML configuration" do
      expect(subject.size).to eq(2)
      expect(subject).to eq(yaml["routes"])
    end
  end

  describe ".recommended" do
    subject { described_class.recommended(answers) }

    context "when all matching rules are satisfied" do
      it "returns routes that match all criteria" do
        expect(subject.size).to eq(1)
        expect(subject.map { |r| r["title"] }).to contain_exactly(
          "Route 1"
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
      it "it matches Yes answers" do
        answers["unqualified_teacher"] = "Yes"
        expect(subject.size).to eq(1)
        expect(subject.first["title"]).to eq("Route 1")
      end

      it "it matches No answers" do
        answers["unqualified_teacher"] = "No"
        expect(subject.size).to eq(1)
        expect(subject.first["title"]).to eq("Route 1")
      end
    end

    context "with missing answers" do
      let(:answers) { { "location" => "Yes" } }
      it "does not recommend routes with missing required answers" do
        expect(subject).to be_empty
      end
    end
  end
end
