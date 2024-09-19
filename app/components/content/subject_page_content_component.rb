# Description: This component is used to display the content for the subject page.
module Content
  class SubjectPageContentComponent < ViewComponent::Base
    attr_reader :subject_name, :salary, :salary_in_london

    include ContentHelper

    def initialize(subject_name:, salary_in_london: nil)
      super
      @subject_name = substitute_values(subject_name)
      @salary_in_london = salary_in_london || "or higher in London"
    end
  end
end
