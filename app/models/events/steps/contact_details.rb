module Events
  module Steps
    class ContactDetails < ::DFEWizard::Step
      attribute :telephone
      validates :telephone, telephone: true, allow_blank: true

      before_validation if: :telephone do
        self.telephone = telephone.to_s.strip.presence
      end
    end
  end
end
