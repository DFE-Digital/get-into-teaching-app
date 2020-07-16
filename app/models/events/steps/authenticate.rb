module Events
  module Steps
    class Authenticate < ::Wizard::Step
      attribute :timed_one_time_password

      validates :timed_one_time_password, presence: true, length: { is: 6 }, format: { with: /\A[0-9]*\z/, message: "can only contain numbers" }

      before_validation if: :timed_one_time_password do
        self.timed_one_time_password = timed_one_time_password.to_s.strip
      end

      def skipped?
        @store["authenticate"] == false
      end
    end
  end
end
