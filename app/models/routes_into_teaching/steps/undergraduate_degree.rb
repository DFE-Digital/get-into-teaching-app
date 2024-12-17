module RoutesIntoTeaching::Steps
  class UndergraduateDegree < GITWizard::Step
    attribute :undergraduate_degree

    validates :undergraduate_degree, presence: true

    def options
      option_struct = Struct.new(:answer, :text, keyword_init: true)

      [
        option_struct.new(answer: "Yes", text: "Yes"),
        option_struct.new(answer: "No", text: "No"),
        option_struct.new(answer: "Not yet", text: "Not yet, I'm studying for one"),
      ]
    end

    def seen?
      false
    end
  end
end
