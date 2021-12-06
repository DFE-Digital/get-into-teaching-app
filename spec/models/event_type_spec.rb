require "rails_helper"

describe EventType do
  describe "class_methods" do
    describe ".school_or_university_event_id" do
      subject { described_class.school_or_university_event_id }

      it { is_expected.to eq(222_750_009) }
    end

    describe ".train_to_teach_event_id" do
      subject { described_class.train_to_teach_event_id }

      it { is_expected.to eq(222_750_001) }
    end

    describe ".online_event_id" do
      subject { described_class.online_event_id }

      it { is_expected.to eq(222_750_008) }
    end

    describe ".question_time_event_id" do
      subject { described_class.question_time_event_id }

      it { is_expected.to eq(222_750_007) }
    end

    describe ".lookup_by_name" do
      specify "returns the id given the corresponding name" do
        expect(described_class.lookup_by_name("Question Time")).to eq(222_750_007)
      end

      specify "errors when an unrecognised name is passed in" do
        expect { described_class.lookup_by_name("Bingo night") }.to raise_error(KeyError)
      end
    end

    describe ".lookup_by_names" do
      specify "returns the ids given the corresponding names" do
        expect(described_class.lookup_by_names("Question Time", "Online event")).to eq([222_750_007, 222_750_008])
      end

      specify "errors when an unrecognised name is passed in" do
        expect { described_class.lookup_by_names("Bingo night") }.to raise_error(KeyError)
      end
    end

    describe ".lookup_by_id" do
      specify "returns the id given the corresponding id" do
        expect(described_class.lookup_by_id(222_750_007)).to eq("Question Time")
      end

      specify "errors when an unrecognised id is passed in" do
        expect { described_class.lookup_by_id(999_888_777) }.to raise_error(KeyError)
      end
    end

    describe ".lookup_by_ids" do
      specify "returns the ids given the corresponding class names" do
        expect(described_class.lookup_by_ids(222_750_007, 222_750_008)).to eq(["Question Time", "Online event"])
      end

      specify "errors when an unrecognised name is passed in" do
        expect { described_class.lookup_by_ids(999_888_777) }.to raise_error(KeyError)
      end
    end
  end

  subject { described_class.new(build(:event_api)) }

  it { is_expected.to respond_to(:type_id) }

  %i[lookup_by_id online_event_id school_or_university_event_id train_to_teach_event_id question_time_event_id]
    .each do |delegated_method|
      it { is_expected.to delegate_method(delegated_method).to(:class).as(delegated_method) }
    end

  describe "#online_qa_event?" do
    subject { described_class.new(build(:event_api, :online_event)) }

    it { is_expected.to be_a_online_qa_event }

    it { is_expected.not_to be_a_provider_event }
    it { is_expected.not_to be_a_question_time_event }
    it { is_expected.not_to be_a_train_to_teach_event }
  end

  describe "#train_to_teach_event?" do
    subject { described_class.new(build(:event_api, :train_to_teach_event)) }

    it { is_expected.to be_a_train_to_teach_event }

    it { is_expected.not_to be_a_provider_event }
    it { is_expected.not_to be_a_question_time_event }
    it { is_expected.not_to be_a_online_qa_event }
  end

  describe "#school_or_university_event?" do
    subject { described_class.new(build(:event_api, :school_or_university_event)) }

    it { is_expected.to be_a_provider_event }

    it { is_expected.not_to be_a_question_time_event }
    it { is_expected.not_to be_a_online_qa_event }
    it { is_expected.not_to be_a_train_to_teach_event }
  end

  describe "#question_time_event?" do
    subject { described_class.new(build(:event_api, :question_time_event)) }

    it { is_expected.to be_a_question_time_event }

    it { is_expected.not_to be_a_online_qa_event }
    it { is_expected.not_to be_a_train_to_teach_event }
    it { is_expected.not_to be_a_provider_event }
  end

  describe "#train_to_teach_or_question_time_event?" do
    context "when train_to_teach_event" do
      subject { described_class.new(build(:event_api, :train_to_teach_event)) }

      it { is_expected.to be_a_train_to_teach_or_question_time_event }
    end

    context "when question_time_event" do
      subject { described_class.new(build(:event_api, :question_time_event)) }

      it { is_expected.to be_a_train_to_teach_or_question_time_event }
    end
  end
end
