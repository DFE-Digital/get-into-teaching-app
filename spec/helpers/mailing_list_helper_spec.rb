require "rails_helper"

describe MailingListHelper, type: :helper do
  describe ".have_degree_low_commitment?" do
    it "returns true for low commitment candidates with a degree" do
      expect(call_method(:have_degree_low_commitment?, :graduate_or_postgraduate, :i_m_not_sure_and_finding_out_more)).to be(true)
    end

    it "returns false for high commitment candidates with a degree" do
      expect(call_method(:have_degree_low_commitment?, :graduate_or_postgraduate, :i_m_very_sure_and_think_i_ll_apply)).to be(false)
    end

    it "returns false for low commitment candidates without a degree" do
      expect(call_method(:have_degree_low_commitment?, :final_year, :it_s_just_an_idea)).to be(false)
    end
  end

  describe ".have_degree_high_commitment" do
    it "returns true for high commitment candidates with a degree" do
      expect(call_method(:have_degree_high_commitment?, :graduate_or_postgraduate, :i_m_very_sure_and_think_i_ll_apply)).to be(true)
    end

    it "returns false for low commitment candidates with a degree" do
      expect(call_method(:have_degree_high_commitment?, :graduate_or_postgraduate, :i_m_not_sure_and_finding_out_more)).to be(false)
    end

    it "returns false for high commitment candidates without a degree" do
      expect(call_method(:have_degree_high_commitment?, :final_year, :i_m_very_sure_and_think_i_ll_apply)).to be(false)
    end
  end

  describe ".final_year_low_commitment" do
    it "returns true for low commitment candidates in their final year of study" do
      expect(call_method(:final_year_low_commitment?, :final_year, :i_m_not_sure_and_finding_out_more)).to be(true)
    end

    it "returns true for high commitment candidates in their final year of study" do
      expect(call_method(:final_year_low_commitment?, :final_year, :i_m_very_sure_and_think_i_ll_apply)).to be(false)
    end

    it "returns true for low commitment candidates not in their final year of study" do
      expect(call_method(:final_year_low_commitment?, :second_year, :i_m_not_sure_and_finding_out_more)).to be(false)
    end
  end

  describe ".final_year_high_commitment" do
    it "returns true for high commitment candidates in their final year of study" do
      expect(call_method(:final_year_high_commitment?, :final_year, :i_m_very_sure_and_think_i_ll_apply)).to be(true)
    end

    it "returns true for low commitment candidates in their final year of study" do
      expect(call_method(:final_year_high_commitment?, :final_year, :i_m_not_sure_and_finding_out_more)).to be(false)
    end

    it "returns true for high commitment candidates not in their final year of study" do
      expect(call_method(:final_year_high_commitment?, :second_year, :i_m_very_sure_and_think_i_ll_apply)).to be(false)
    end
  end

  describe ".first_or_second_year_low_commitment" do
    it "returns true for low commitment candidates in their first or second year of study" do
      expect(call_method(:first_or_second_year_low_commitment?, :first_year, :i_m_not_sure_and_finding_out_more)).to be(true)
    end

    it "returns true for high commitment candidates in their first or second year of study" do
      expect(call_method(:first_or_second_year_low_commitment?, :first_year, :i_m_very_sure_and_think_i_ll_apply)).to be(false)
    end

    it "returns true for low commitment candidates not in their first or second year of study" do
      expect(call_method(:first_or_second_year_low_commitment?, :other, :i_m_not_sure_and_finding_out_more)).to be(false)
    end
  end

  describe ".first_or_second_year_high_commitment" do
    it "returns true for high commitment candidates in their first or second year of study" do
      expect(call_method(:first_or_second_year_high_commitment?, :first_year, :i_m_very_sure_and_think_i_ll_apply)).to be(true)
    end

    it "returns true for low commitment candidates in their first or second year of study" do
      expect(call_method(:first_or_second_year_high_commitment?, :first_year, :i_m_not_sure_and_finding_out_more)).to be(false)
    end

    it "returns true for high commitment candidates not in their first or second year of study" do
      expect(call_method(:first_or_second_year_high_commitment?, :other, :i_m_very_sure_and_think_i_ll_apply)).to be(false)
    end
  end

  describe ".no_degree_low_commitment" do
    it "returns true for low commitment candidates with no degree (and are not studying)" do
      expect(call_method(:no_degree_low_commitment?, :i_don_t_have_a_degree_and_am_not_studying_for_one, :i_m_not_sure_and_finding_out_more)).to be(true)
    end

    it "returns true for high commitment candidates with no degree (and are not studying)" do
      expect(call_method(:no_degree_low_commitment?, :i_don_t_have_a_degree_and_am_not_studying_for_one, :i_m_very_sure_and_think_i_ll_apply)).to be(false)
    end

    it "returns true for low commitment candidates with a degree (or studying)" do
      expect(call_method(:no_degree_low_commitment?, :graduate_or_postgraduate, :i_m_not_sure_and_finding_out_more)).to be(false)
    end
  end

  describe ".no_degree_high_commitment" do
    it "returns true for high commitment candidates with no degree (and are not studying)" do
      expect(call_method(:no_degree_high_commitment?, :i_don_t_have_a_degree_and_am_not_studying_for_one, :i_m_very_sure_and_think_i_ll_apply)).to be(true)
    end

    it "returns true for low commitment candidates with no degree (and are not studying)" do
      expect(call_method(:no_degree_high_commitment?, :i_don_t_have_a_degree_and_am_not_studying_for_one, :i_m_not_sure_and_finding_out_more)).to be(false)
    end

    it "returns true for high commitment candidates with a degree (or studying)" do
      expect(call_method(:no_degree_high_commitment?, :graduate_or_postgraduate, :i_m_very_sure_and_think_i_ll_apply)).to be(false)
    end
  end

  describe ".other_low_commitment" do
    it "returns true for low commitment candidates who specify a degree status of 'other'" do
      expect(call_method(:other_low_commitment?, :other, :i_m_not_sure_and_finding_out_more)).to be(true)
    end

    it "returns true for high commitment candidates who specify a degree status of 'other'" do
      expect(call_method(:other_low_commitment?, :other, :i_m_very_sure_and_think_i_ll_apply)).to be(false)
    end

    it "returns true for low commitment candidates who do not specify a degree status of 'other'" do
      expect(call_method(:other_low_commitment?, :graduate_or_postgraduate, :i_m_not_sure_and_finding_out_more)).to be(false)
    end
  end

  describe ".other_high_commitment" do
    it "returns true for high commitment candidates who specify a degree status of 'other'" do
      expect(call_method(:other_high_commitment?, :other, :i_m_very_sure_and_think_i_ll_apply)).to be(true)
    end

    it "returns true for low commitment candidates who specify a degree status of 'other'" do
      expect(call_method(:other_high_commitment?, :other, :i_m_not_sure_and_finding_out_more)).to be(false)
    end

    it "returns true for high commitment candidates who do not specify a degree status of 'other'" do
      expect(call_method(:other_high_commitment?, :graduate_or_postgraduate, :i_m_very_sure_and_think_i_ll_apply)).to be(false)
    end
  end

  def call_method(method, degree_status_key, consideration_journey_stage_key)
    degree_status = Crm::OptionSet.lookup_by_key(:degree_status, degree_status_key)
    consideration_journey_stage = Crm::OptionSet.lookup_by_key(:consideration_journey_stage, consideration_journey_stage_key)

    helper.public_send(method, degree_status: degree_status, consideration_journey_stage: consideration_journey_stage)
  end
end
