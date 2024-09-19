# Description: This component is used to display the content for the subject page.
module Content
  class SubjectPageContentComponent < ViewComponent::Base
    attr_reader :subject_name

    include ContentHelper

    def initialize(subject_name:)
      super
      @subject_name = substitute_values(subject_name)
    end
  end
end
