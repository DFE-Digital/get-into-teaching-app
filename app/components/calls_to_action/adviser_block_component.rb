module CallsToAction
class AdviserBlockComponent < ViewComponent::Base
    attr_reader :title, :image_path, :title_color, :text, :link_text, :link_target

    def initialize(
      title:"Get an adviser", 
      image_path: "static/images/adviser-black.png",
      title_color: "yellow",
      text: "An adviser with years of teaching experience can help you to become a teacher. Chat by phone, text, or email as little or often as you need.",
      link_text: "Find out more about advisers",
      link_target: "/teacher-training-advisers"
    )
      super

      @title = title
      @image_path = image_path
      @title_color = title_color
      @text = text
      @link_text = link_text
      @link_target = link_target
    end
  end
end  
