require "ostruct"

module Feedback
  module Steps
    class Purpose < ::GITWizard::Step
      OPTIONS = [
        OpenStruct.new(id: "Give feedback about the website", value: "Give feedback about the website"),
        OpenStruct.new(id: "Give feedback about signing up for an adviser", value: "Give feedback about signing up for an adviser"),
        OpenStruct.new(id: "Give feedback about signing up for emails", value: "Give feedback about signing up for emails"),
        OpenStruct.new(id: "Give feedback about signing up for an event", value: "Give feedback about signing up for an event"),
        OpenStruct.new(id: "Give feedback about booking a callback", value: "Give feedback about booking a callback"),
      ].freeze

      attribute :topic
      validates :topic, presence: true, inclusion: { in: OPTIONS.map(&:id) }

      def options
        OPTIONS
      end
    end
  end
end
