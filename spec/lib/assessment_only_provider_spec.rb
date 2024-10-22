require "spec_helper"
require "assessment_only_provider"
require "csv"

describe AssessmentOnlyProvider do
  let(:csv) do
    CSV.parse("provider,region,website,contact,email,phone\nProvider1,Region1;Region2,www.example.com,Someone,test@test.test,01234 56789\n", headers: true)
  end
  let(:data) do
    described_class.new(csv.first)
  end

  describe "#provider" do
    subject { data.provider }

    it { is_expected.to eql("Provider1") }
  end

  describe "#regions" do
    subject { data.regions }

    it { is_expected.to match_array(%w[Region1 Region2]) }
  end

  describe "#website" do
    subject { data.website }

    it { is_expected.to eql("www.example.com") }
  end

  describe "#contact" do
    subject { data.contact }

    it { is_expected.to eql("Someone") }
  end

  describe "#email" do
    subject { data.email }

    it { is_expected.to eql("test@test.test") }
  end

  describe "#phone" do
    subject { data.phone }

    it { is_expected.to eql("01234 56789") }
  end

  describe "#to_h" do
    subject { data.to_h }

    it { is_expected.to eql({ "email" => "test@test.test", "header" => "Provider1", "link" => "www.example.com", "name" => "Someone", "telephone" => "01234 56789" }) }
  end

  describe "#to_str" do
    subject { data.to_str }

    it { is_expected.to eql("Provider1|Region1;Region2|www.example.com|Someone|test@test.test|01234 56789") }
  end
end
