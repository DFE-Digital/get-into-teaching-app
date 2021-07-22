module Callbacks
  module Steps
    class TalkingPoints < ::Wizard::Step
      OPTIONS = [
        "Eligibility to become a teacher",
        "Routes into teaching",
        "Funding your training",
        "Gaining classroom experience",
        "Finding training providers",
        "Applying for teacher training",
        "Support with international qualifications",
        "Something else",
      ].freeze

      attribute :talking_points

      validates :talking_points, inclusion: { in: OPTIONS }
    end
  end
end
