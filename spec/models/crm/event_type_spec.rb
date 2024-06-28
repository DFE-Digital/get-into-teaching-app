require "rails_helper"

describe Crm::EventType do
  describe "class_methods" do
    describe ".all_ids" do
      subject { described_class.all_ids }

      it { is_expected.to eq([222_750_012, 222_750_008, 222_750_009]) }
    end

    describe ".school_or_university_event_id" do
      subject { described_class.school_or_university_event_id }

      it { is_expected.to eq(222_750_009) }
    end

    describe ".get_into_teaching_event_id" do
      subject { described_class.get_into_teaching_event_id }

      it { is_expected.to eq(222_750_012) }
    end

    describe ".online_event_id" do
      subject { described_class.online_event_id }

      it { is_expected.to eq(222_750_008) }
    end

    describe ".lookup_by_name" do
      specify "returns the id given the corresponding name" do
        expect(described_class.lookup_by_name("School or University event")).to eq(222_750_009)
      end

      specify "errors when an unrecognised name is passed in" do
        expect { described_class.lookup_by_name("Bingo night") }.to raise_error(KeyError)
      end
    end

    describe ".lookup_by_names" do
      specify "returns the ids given the corresponding names" do
        expect(described_class.lookup_by_names("School or University event", "Online event")).to eq([222_750_009, 222_750_008])
      end

      specify "errors when an unrecognised name is passed in" do
        expect { described_class.lookup_by_names("Bingo night") }.to raise_error(KeyError)
      end
    end

    describe ".lookup_by_id" do
      specify "returns the id given the corresponding id" do
        expect(described_class.lookup_by_id(222_750_009)).to eq("School or University event")
      end

      specify "errors when an unrecognised id is passed in" do
        expect { described_class.lookup_by_id(999_888_777) }.to raise_error(KeyError)
      end
    end

    describe ".lookup_by_ids" do
      specify "returns the ids given the corresponding class names" do
        expect(described_class.lookup_by_ids(222_750_009, 222_750_008)).to eq(["School or University event", "Online event"])
      end

      specify "errors when an unrecognised name is passed in" do
        expect { described_class.lookup_by_ids(999_888_777) }.to raise_error(KeyError)
      end
    end

    describe ".lookup_by_query_param" do
      specify "returns the id given the corresponding query param" do
        expect(described_class.lookup_by_query_param("git")).to eq(222_750_012)
      end

      specify "errors when an unrecognised name is passed in" do
        expect { described_class.lookup_by_query_param("other") }.to raise_error(KeyError)
      end
    end

    describe ".lookup_by_query_params" do
      specify "returns the id given the corresponding query params" do
        expect(described_class.lookup_by_query_params("git", "onlineqa")).to eq([222_750_012, 222_750_008])
      end

      specify "ignores unrecognised values" do
        expect(described_class.lookup_by_query_params("onlineqa", "other")).to eq([222_750_008])
      end
    end
  end

  subject { described_class.new(build(:event_api)) }

  it { is_expected.to respond_to(:type_id) }

  %i[lookup_by_id online_event_id school_or_university_event_id get_into_teaching_event_id]
    .each do |delegated_method|
      it { is_expected.to delegate_method(delegated_method).to(:class).as(delegated_method) }
    end

  describe "#online_qa_event?" do
    subject { described_class.new(build(:event_api, :online_event)) }

    it { is_expected.to be_a_online_qa_event }

    it { is_expected.not_to be_a_provider_event }
    it { is_expected.not_to be_a_get_into_teaching_event }
  end

  describe "#get_into_teaching_event_id?" do
    subject { described_class.new(build(:event_api, :get_into_teaching_event)) }

    it { is_expected.to be_a_get_into_teaching_event }

    it { is_expected.not_to be_a_provider_event }
    it { is_expected.not_to be_a_online_qa_event }
  end

  describe "#school_or_university_event?" do
    subject { described_class.new(build(:event_api, :school_or_university_event)) }

    it { is_expected.to be_a_provider_event }

    it { is_expected.not_to be_a_online_qa_event }
    it { is_expected.not_to be_a_get_into_teaching_event }
  end
end
