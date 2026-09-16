# Creating a content component

Content components are ViewComponents that can be rendered inside our Markdown
content pages via a `$placeholder$` reference in the page (see the
[content guide](../content.md) for how editors use them). If you just want to
render a component from an ERB partial you do **not** need to follow these steps.
This is specifically for components that are driven from Markdown front matter.

There are two easy-to-miss steps when adding a new one.

## 1. Namespace the component under `Content`

The component **must** live in `app/components/content/` and be namespaced under
`Content::`, otherwise the injector won't be able to find it. For example, a
`timed_financial_content` component lives at:

```
app/components/content/timed_financial_content_component.rb
```

```ruby
module Content
  class TimedFinancialContentComponent < ViewComponent::Base
    # ...
  end
end
```

Its spec should mirror this location and namespace, at
`spec/components/content/timed_financial_content_component_spec.rb`.

## 2. Register the component type in `markdown.rb`

The Markdown template handler only substitutes component types that are listed in
the `COMPONENT_TYPES` array in
[`lib/template_handlers/markdown.rb`](../../lib/template_handlers/markdown.rb).
Add the snake_case type name (the same name used as the front matter key):

```ruby
COMPONENT_TYPES = %w[
  quote quote_list inset_text youtube_video steps expander
  cta_adviser cta_routes cta_mailinglist cta_arrow_link
  timed_financial_content
].freeze
```

The type name maps to the class name by camelizing it, so `timed_financial_content`
resolves to `Content::TimedFinancialContentComponent`
(see [`Content::ComponentInjector`](../../app/presenters/content/component_injector.rb)).

## 3. Reference it from a content page

In the page's front matter, nest the component's arguments under the type name and
a placeholder key. The nested hash is symbolized and passed to the component's
initializer as keyword arguments:

```yaml
---
timed_financial_content:
  compare_bursaries_and_scholarships:
    default:
      text: "Default text"
---

$compare_bursaries_and_scholarships$
```
