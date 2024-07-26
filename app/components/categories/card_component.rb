class Categories::CardComponent < ViewComponent::Base
  attr_reader :title, :description, :path, :heading_tag

  include ContentHelper

  def initialize(card:, heading_tag: "h2")
    @title       = substitute_values(card.title)
    @description = substitute_values(card.description)
    @path        = card.path
    @heading_tag = heading_tag

    super
  end
end
