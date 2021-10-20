module Callbacks
  module Steps
    class MatchbackFailed < ::DFEWizard::Step
      def skipped?
        @store["authenticate"]
      end

      def can_proceed?
        false
      end

      def try_again?
        matchback_failures <= 2
      end

      def crm_unavailable?
        @store["last_matchback_failure_code"] != 404
      end

    private

      def matchback_failures
        @store["matchback_failures"].to_i
      end
    end
  end
end
