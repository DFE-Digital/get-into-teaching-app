module Events
  module Steps
    class ContactDetails < ::GITWizard::Step
      attribute :address_telephone
      validates :address_telephone, telephone: true, allow_blank: true

      before_validation if: :address_telephone do
        self.address_telephone = address_telephone.to_s.strip.presence
      end

      def optional?
        true
      end
    end
  end
end
