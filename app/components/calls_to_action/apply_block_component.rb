module CallsToAction
  class ApplyBlockComponent < ViewComponent::Base
    attr_reader :title, :image, :image_classes, :title_color, :text, :link_text, :link_target

    def initialize(
      title: "Start your application",
      image: "person-paper.svg",
      image_classes: "image-background gitbluetint padding-small",
      title_color: "gitgreenpastel",
      text: "Create an account and start your application for a teacher training course.",
      link_text: "Apply for teacher training",
      link_target: "https://www.gov.uk/apply-for-teacher-training"
    )
      super
      @title = title
      @image = image
      @image_classes = image_classes
      @title_color = title_color
      @text = text
      @link_text = link_text
      @link_target = link_target
    end
  end
end
