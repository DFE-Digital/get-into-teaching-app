require "markdown_pages/template_handler"

ActionView::Template.register_template_handler :md, MarkdownPages::TemplateHandler
ActionView::Template.register_template_handler :markdown, MarkdownPages::TemplateHandler
