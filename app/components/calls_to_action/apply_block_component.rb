module CallsToAction
  class ApplyBlockComponent < ViewComponent::Base
    attr_reader :title, :image, :title_color, :text, :link_text, :link_target

    def initialize(
      title: "Start your application",
      image: "apply-block-promo.jpg",
      title_color: "green",
      text: "Create an account and start your application for a teacher training course.",
      link_text: "Apply for a course",
      link_target: "https://www.gov.uk/apply-for-teacher-training"
    )
      super
      @title = title
      @image = image
      @title_color = title_color
      @text = text
      @link_text = link_text
      @link_target = link_target
    end
  end
end
