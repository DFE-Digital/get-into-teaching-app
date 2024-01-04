class BackComponent < ViewComponent::Base
  attr_reader :path, :text, :css_class

  def initialize(path: :back, text: "Back", **options)
    super
    @path = path
    @text = text
    @css_class = options[:class] || 'govuk-back-link'
  end
end
