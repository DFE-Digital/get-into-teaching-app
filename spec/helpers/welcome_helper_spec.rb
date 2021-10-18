require "rails_helper"

RSpec.describe WelcomeHelper, type: :helper do
  describe "#greeting" do
    context "when the first name is known" do
      let(:name) { "Joey" }

      before { allow(session).to receive(:dig).with("mailinglist", "first_name") { name } }

      specify "returns a personalised greeting" do
        expect(greeting).to eql("Hey #{name}")
      end
    end

    context "when the first name isn't known" do
      specify "returns a generic greeting" do
        expect(greeting).to eql("Hello")
      end
    end
  end

  describe "#teaching_subject" do
    subject { teaching_subject }

    context "when the subject is known" do
      context "when the subject name is a proper noun" do
        {
          "Art and design" => "7e2655a1-2afa-e811-a981-000d3a276620",
          "Biology" => "802655a1-2afa-e811-a981-000d3a276620",
          "Chemistry" => "842655a1-2afa-e811-a981-000d3a276620",
          "General science" => "982655a1-2afa-e811-a981-000d3a276620",
          "Languages (other)" => "a22655a1-2afa-e811-a981-000d3a276620",
          "Maths" => "a42655a1-2afa-e811-a981-000d3a276620",
          "Physics with maths" => "ae2655a1-2afa-e811-a981-000d3a276620",
          "Physics" => "ac2655a1-2afa-e811-a981-000d3a276620",
        }.each do |subject_name, subject_id|
          describe "#{subject_name} is lowercased" do
            before { allow(session).to receive(:dig).with("mailinglist", "preferred_teaching_subject_id") { subject_id } }

            it { is_expected.to eql("teaching <mark>#{subject_name.downcase}.</mark>") }
          end
        end
      end

      context "when the subject name is a common noun" do
        {
          "English" => "942655a1-2afa-e811-a981-000d3a276620",
          "German" => "9c2655a1-2afa-e811-a981-000d3a276620",
          "Spanish" => "b82655a1-2afa-e811-a981-000d3a276620",
          "French" => "962655a1-2afa-e811-a981-000d3a276620",
        }.each do |subject_name, subject_id|
          describe "#{subject_name} is not lowercased" do
            before { allow(session).to receive(:dig).with("mailinglist", "preferred_teaching_subject_id") { subject_id } }

            it { is_expected.to eql("teaching <mark>#{subject_name}.</mark>") }
          end
        end
      end
    end

    context "when the subject is unset" do
      it { is_expected.to eql("<mark>teaching.</mark>") }
    end

    context "when the subject isn't recognised" do
      before { allow(session).to receive(:dig).with("mailinglist", "preferred_teaching_subject_id").and_return("11111111-2222-3333-4444-555555555555") }

      it { is_expected.to eql("<mark>teaching.</mark>") }
    end
  end
end
