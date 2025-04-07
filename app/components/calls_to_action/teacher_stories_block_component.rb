module CallsToAction
  class TeacherStoriesBlockComponent < ViewComponent::Base
    attr_reader :title, :image, :title_color, :links

    include ContentHelper

    def initialize(
      title: "Teacher stories",
      image: "teacher-stories-block-promo.jpg",
      title_color: "pink",
      links: [
        { text: "Ben's favourite thing about teaching", url: "/life-as-a-teacher/why-teach/bens-favourite-things-about-teaching" },
        { text: "Turning a tough lesson into a success", url: "/life-as-a-teacher/teaching-as-a-career/turning-a-tough-lesson-into-a-success" },
        { text: "Abigail's career progression story", url: "/life-as-a-teacher/teaching-as-a-career/abigails-career-progression-story" },
      ]
    )

      super
      @title = title
      @image = image
      @title_color = title_color
      @links = links
    end
  end
end
