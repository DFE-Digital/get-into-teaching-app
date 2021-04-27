require "rails_helper"

describe FundingWidget do
  describe "attributes" do
    it { is_expected.to respond_to :subject }
  end

  describe "validations" do
    describe "#subject" do
      it { is_expected.to allow_value("test").for :subject }
      it { is_expected.to_not allow_values("", nil).for :subject }
    end
  end

  describe "#subject_data" do
    let(:subject_data) { described_class.new(subject: "Biology").subject_data }

    describe "hash key and values" do
      describe "education key" do
        it "is included" do
          expect(subject_data).to have_key(:education)
        end

        it "has a string value" do
          expect(subject_data[:education]).to be_a String
        end
      end

      describe "sub_head key" do
        it "is included" do
          expect(subject_data).to have_key(:sub_head)
        end

        it "has a string value" do
          expect(subject_data[:sub_head]).to be_a String
        end
      end

      describe "funding key" do
        it "is included" do
          expect(subject_data).to have_key(:funding)
        end

        it "has a string value" do
          expect(subject_data[:funding]).to be_a String
        end
      end
    end
  end
end
