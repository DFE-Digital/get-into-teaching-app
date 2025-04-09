module Content
  class YoutubeVideoComponent < ViewComponent::Base
    attr_reader :id, :title, :orientation

    include ContentHelper

    def initialize(id:, title:, orientation: :landscape)
      super

      @id = id
      @title = substitute_values(title)
      @orientation = orientation
    end

    def src
      "https://www.youtube-nocookie.com/embed/#{id}"
    end

  private

    def before_render
      validate!
    end

    def validate!
      %i[id title].each do |required_attr|
        error_message = "#{required_attr} must be present"
        fail(ArgumentError, error_message) if send(required_attr).blank?
      end
    end
  end
end
