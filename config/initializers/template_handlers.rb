require "template_handlers/markdown"

ActionView::Template.register_template_handler :md, TemplateHandlers::Markdown
ActionView::Template.register_template_handler :markdown, TemplateHandlers::Markdown
