module Content
  module Subject
    class BenefitsComponent < ViewComponent::Base
      attr_reader :subject_name

      include ContentHelper

      def initialize(subject_name:)
        super
        @subject_name = substitute_values(subject_name)
      end

    private

      def before_render
        validate!
      end

      def validate!
        %i[subject_name].each do |required_attr|
          error_message = "#{required_attr} must be present"
          fail(ArgumentError, error_message) if send(required_attr).blank?
        end
      end
    end
  end
end
