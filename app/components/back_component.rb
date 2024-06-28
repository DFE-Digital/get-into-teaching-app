class BackComponent < ViewComponent::Base
  attr_reader :path, :text, :options

  def initialize(path: :back, text: "Back", **options)
    super
    @path = path
    @text = text
    @options = options
    @options[:class] = "govuk-back-link #{options[:class]}".strip
  end
end
