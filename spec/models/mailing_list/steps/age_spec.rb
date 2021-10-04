require "rails_helper"

describe MailingList::Steps::Age do
  include_context "with wizard step"
  it_behaves_like "a with wizard step"

  describe ".years" do
    subject { described_class.years }

    it { is_expected.to eq(described_class::MIN_AGE.year.downto(described_class::MAX_AGE.year).to_a) }
  end

  describe ".age_ranges" do
    subject { described_class.age_ranges }

    it do
      is_expected.to match_array([
        "28 or younger",
        "29 - 39",
        "40 - 50",
        "51 - 61",
        "62 or older",
      ])
    end
  end

  describe "validations for age_display_option" do
    it { is_expected.to validate_inclusion_of(:age_display_option).in_array(described_class::DISPLAY_OPTIONS.values) }
  end

  describe "validations for year_of_birth" do
    it { is_expected.to validate_inclusion_of(:year_of_birth).in_array(described_class.years).allow_blank }
    it { is_expected.not_to validate_presence_of(:year_of_birth) }

    context "when age_display_options is 'year_of_birth'" do
      before { subject.age_display_option = described_class::DISPLAY_OPTIONS[:year_of_birth] }

      it { is_expected.to validate_presence_of(:year_of_birth) }
    end
  end

  describe "validations for age_range" do
    it { is_expected.to validate_inclusion_of(:age_range).in_array(described_class.age_ranges).allow_blank }
    it { is_expected.not_to validate_presence_of(:age_range) }

    context "when age_display_options is 'age_range'" do
      before { subject.age_display_option = described_class::DISPLAY_OPTIONS[:age_range] }

      it { is_expected.to validate_presence_of(:age_range) }
    end
  end

  describe "validations for date_of_birth" do
    it { is_expected.to allow_values(nil, described_class::MIN_AGE, described_class::MAX_AGE).for(:date_of_birth) }
    it { is_expected.not_to allow_values(described_class::MIN_AGE + 1.year, described_class::MAX_AGE - 1.year).for(:date_of_birth) }
    it { is_expected.not_to validate_presence_of(:date_of_birth) }

    context "when an invalid date is entered" do
      before { subject.date_of_birth = { 3 => -1, 2 => -1, 1 => -1 } }

      it "adds a custom error message" do
        is_expected.not_to be_valid
        expect(subject.errors[:date_of_birth]).to include("You did not enter a valid date of birth")
      end
    end

    context "when age_display_options is 'date_of_birth'" do
      before { subject.age_display_option = described_class::DISPLAY_OPTIONS[:date_of_birth] }

      it { is_expected.to validate_presence_of(:date_of_birth) }
    end
  end

  describe "#export" do
    subject { instance.export }

    it { is_expected.to be_empty }
  end

  describe "#skipped" do
    context "when mailing_list_age_step is true" do
      before { allow(Rails.application.config.x).to receive(:mailing_list_age_step).and_return(true) }

      context "when age_display_option is 'none'" do
        before { subject.age_display_option = described_class::DISPLAY_OPTIONS[:none] }

        it { is_expected.to be_skipped }
      end

      described_class::DISPLAY_OPTIONS.excluding(:none).each do |display_option|
        context "when age_display_option is '#{display_option}'" do
          before { subject.age_display_option = display_option }

          it { is_expected.not_to be_skipped }
        end
      end
    end

    context "when mailing_list_age_step is false" do
      before { allow(Rails.application.config.x).to receive(:mailing_list_age_step).and_return(false) }

      described_class::DISPLAY_OPTIONS.each do |display_option|
        context "when age_display_option is '#{display_option}'" do
          before { subject.age_display_option = display_option }

          it { is_expected.to be_skipped }
        end
      end
    end
  end
end
