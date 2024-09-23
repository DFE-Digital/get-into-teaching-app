# This component is used to display the content for the subject page.
module Content
  class SubjectPageContentComponent < ViewComponent::Base
    attr_reader :subject_name

    include ContentHelper

    def initialize(subject_name: "a subject")
      # do we need a defalut value for subject_name and if so is this appropriate? Alternatively I think we can throw an error if no subject_name is provided? Will need to adjust tests if default value is removed or changed
      super
      @subject_name = substitute_values(subject_name)
    end
  end
end
