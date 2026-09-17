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

## Compile-time vs request-time rendering

By default a content component is rendered **once, when the template is
compiled**, and its HTML is baked into the compiled template. The Markdown
handler does this because it is cheap: the Markdown → HTML conversion happens on
the first request after a deploy and is then cached for the life of the process.

This is fine for components whose output only depends on their front matter. It
is **wrong** for a component whose output depends on request state — the current
time, `params`, the session — because a baked component captures that state once
at compile time and never sees it again. `TimedFinancialContentComponent` is the
motivating example: baked, it read the clock once (so the dated content only
switched on a process restart, never at the configured boundary) and could not
read `?now=`/`?branch=` debug params.

### `RUNTIME_COMPONENT_TYPES`

Components whose type is listed in `RUNTIME_COMPONENT_TYPES` (in
[`lib/template_handlers/markdown.rb`](../../lib/template_handlers/markdown.rb))
are rendered **per-request** instead. If you add a component that needs request
state, add its type there as well as to `COMPONENT_TYPES`.

How it works:

1. Instead of rendering the component at compile time, the handler records it and
   leaves a marker in the Markdown: `<div data-dynamic-component="<nonce>-<n>"></div>`.
   The nonce is random per compile, so authored content can never collide with a
   marker.
2. Kramdown, Rinku and the table-caption pass run as usual; the marker survives.
3. `compile_body` splits the rendered HTML on the markers and rebuilds it as a
   `safe_join` of the literal segments and live `render(...)` calls. Those render
   calls run in the real view context on every request, so the component sees the
   current time and `params`.

Two things to keep in step if you touch this code:

* `runtime_marker` (the builder) and `runtime_marker_pattern` (the splitter) are a
  matched pair. Change one, change the other. The pattern deliberately matches the
  marker in both its raw form and the HTML-escaped form Kramdown emits when a
  token is used inline.
* A runtime component renders per request but its **front matter is still baked**
  into the compiled template as a literal. That is fine — front matter is static
  per deploy — but it means front matter changes still need a recompile, only the
  render itself is per-request.

### Debug overrides

`TimedFinancialContentComponent` reads two request params to make dated content
previewable without changing the clock or the config:

* `?now=<date>` — evaluate the date logic as if it were that date.
* `?branch=<key>` — force a named branch, ignoring the date.

Both are gated behind `Rails.env.local?`, so they are inert in production. A
malformed value falls through to the real date rather than erroring the page. If
you build another previewable component, follow the same pattern: gate any
request-param override to local environments.
