module Events
  module Steps
    class ContactDetails < ::Wizard::Step
      attribute :telephone
      validates :telephone, telephone: true, allow_blank: true

      before_validation if: :telephone do
        self.telephone = telephone.to_s.strip.presence
      end

      def optional?
        true
      end
    end
  end
end
