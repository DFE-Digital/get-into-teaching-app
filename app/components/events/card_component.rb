class Events::CardComponent < ViewComponent::Base
  attr_reader :title, :description, :path, :heading_tag

  def initialize(card:, heading_tag: "h3")
    @title       = card.title
    @description = card.description
    @path        = card.path
    @heading_tag = heading_tag

    super
  end
end
