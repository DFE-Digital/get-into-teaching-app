module MailingList
  module Steps
    class Postcode < ::Wizard::Step
      attribute :postcode
      validates :postcode, presence: true, postcode: true

      before_validation if: :postcode do
        self.postcode = postcode.to_s.strip
      end
    end
  end
end
