module MailingList
  module Steps
    class Subject < ::Wizard::Step
      SUBJECTS = [
        "Art and Design",
        "Biology",
        "Business Studies",
        "Chemistry",
        "Citizenship",
        "Classics",
        "Computing",
        "Dance",
        "Design",
        "Economics",
        "English",
        "French",
        "Geography",
        "German",
        "Health and social care",
        "History",
        "Languages (other)",
        "Maths",
        "Media studies",
        "French",
        "Music",
        "Physical education",
        "Physics",
        "Physics with maths",
        "Primary psycology",
        "Religious education",
        "Social sciences",
        "Spanish",
        "Vocational health",
        "Primary",
        "I don't know",
      ].freeze

      attribute :subject
      validates :subject,
                presence: true,
                inclusion: { in: SUBJECTS, allow_nil: true }

      class << self
        def subjects
          SUBJECTS
        end
      end
    end
  end
end
