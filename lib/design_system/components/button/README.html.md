# Button

This is a button...

## Example Usage

<% example = DesignSystem::Components::Button::Helper.button_tag("Save", style: "primary", disabled: false, disable_with: "Please wait...") %>

<%= example %>

### HTML

```html
<%= example %>
```

### Helper

```ruby
DesignSystem::Components::Button::Helper.button_tag("Save", style: "primary", disabled: false, disable_with: "Please wait...")
```

### Markdown

```markdown
[button Save]
```
