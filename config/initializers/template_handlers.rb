require "template_handlers/markdown"
require "template_handlers/erb"

ActionView::Template.register_template_handler :erb, TemplateHandlers::ERB
ActionView::Template.register_template_handler :md, TemplateHandlers::Markdown
ActionView::Template.register_template_handler :markdown, TemplateHandlers::Markdown
