module RoutesIntoTeaching::Steps
  class UndergraduateDegree < GITWizard::Step
    attribute :undergraduate_degree

    validates :undergraduate_degree, presence: { message: RoutesIntoTeaching::Wizard::DEFAULT_ERROR_MESSAGE }

    def options
      option_struct = Struct.new(:answer, :text, keyword_init: true)

      [
        option_struct.new(answer: "Yes", text: "Yes"),
        option_struct.new(answer: "Not yet", text: "Not yet, I'm studying for one"),
        option_struct.new(answer: "No", text: "No"),
      ]
    end

    def seen?
      false
    end

    def title
      "degree"
    end
  end
end
