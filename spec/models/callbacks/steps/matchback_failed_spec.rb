require "rails_helper"

describe Callbacks::Steps::MatchbackFailed do
  include_context "wizard step"
  it_behaves_like "a wizard step"

  describe "#can_proceed?" do
    it "returns false" do
      expect(subject).not_to be_can_proceed
    end
  end

  describe "#skipped?" do
    it "returns false if authenticate is false or nil" do
      wizardstore["authenticate"] = false
      expect(subject).not_to be_skipped
      wizardstore["authenticate"] = nil
      expect(subject).not_to be_skipped
    end

    it "returns true if authenticate is true" do
      wizardstore["authenticate"] = true
      expect(subject).to be_skipped
    end
  end

  describe "#crm_unavailable?" do
    it "returns true if the last error code != 404" do
      wizardstore["last_matchback_failure_code"] = 500
      expect(subject).to be_crm_unavailable
    end

    it "returns false if the last error code == 404" do
      wizardstore["last_matchback_failure_code"] = 404
      expect(subject).not_to be_crm_unavailable
    end
  end

  describe "#try_again?" do
    it "returns true if matchback_failures are fewer than 3" do
      wizardstore["matchback_failures"] = nil
      expect(subject).to be_try_again

      wizardstore["matchback_failures"] = 0
      expect(subject).to be_try_again

      wizardstore["matchback_failures"] = 1
      expect(subject).to be_try_again

      wizardstore["matchback_failures"] = 2
      expect(subject).to be_try_again
    end

    it "returns false if matchback_failures are greater than 2" do
      wizardstore["matchback_failures"] = 3
      expect(subject).not_to be_try_again
    end
  end
end
