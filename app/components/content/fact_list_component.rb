module Content
  class FactListComponent < ViewComponent::Base
    attr_reader :facts

    def initialize(facts)
      super

      @facts = facts
    end

    def icon(icon_name)
      image_pack_tag("static/images/#{icon_name}.svg", **helpers.image_alt_attribs_for_text(""))
    end

  private

    def before_render
      validate!
    end

    def validate!
      facts.each_with_index do |fact, idx|
        %i[icon value title link].each do |required_key|
          error_message = "#{required_key} must be present for fact #{idx + 1}"
          fail(ArgumentError, error_message) if fact[required_key].blank?
        end
      end
    end
  end
end
