module DesignSystem::Components::Button::Helper
  def self.button_tag(text, style: "primary", disabled: false, disable_with: nil)
    DesignSystem::ViewRenderer.render(__FILE__, {
      text: text,
      klass: "git-button git-button--#{style}", 
      disabled: disabled, 
      disable_with: disable_with,
      controller: "components--button--button",
    })
  end
end