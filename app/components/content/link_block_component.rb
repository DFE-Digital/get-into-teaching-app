module Content
  class LinkBlockComponent < ViewComponent::Base
    attr_reader :title, :links

    def initialize(title: "On this page:", links: [])
      @title = title
      @links = links
    end

    def render?
      links&.any?
    end
  end
end
