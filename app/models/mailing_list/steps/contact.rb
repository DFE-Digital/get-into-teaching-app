module MailingList
  module Steps
    class Contact < ::Wizard::Step
      attribute :telephone
      attribute :more_info
      attribute :accept_privacy_policy, :boolean

      validates :telephone, telephone: true
      validates :more_info, presence: true, if: -> { telephone.present? }
      validates :more_info, number_of_words: { less_than: 200 }
      validates :accept_privacy_policy, acceptance: true, allow_nil: false

      before_validation if: :telephone do
        self.telephone = telephone.to_s.strip
      end

      before_validation if: :more_info do
        self.more_info = more_info.to_s.strip
      end
    end
  end
end
