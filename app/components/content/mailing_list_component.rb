module Content
  class MailingListComponent < ViewComponent::Base
    attr_reader :title, :intro, :color, :margin, :heading

    def initialize(title:, intro: nil, color: "pink", margin: true, heading: :m)
      super

      @title = title
      @intro = intro
      @color = color
      @margin = margin
      @heading = heading
    end

    def classes
      %w[action-container].tap do |c|
        c << "action-container--#{color}"
        c << "action-container--no-margin" unless margin
      end
    end

    def heading_classes
      %w[].tap do |c|
        c << "heading-#{heading}"
        c << "heading--box-#{color}" unless color == "transparent"
      end
    end

    def privacy_policy
      @privacy_policy ||= GetIntoTeachingApiClient::PrivacyPoliciesApi.new.get_latest_privacy_policy
    end
  end
end
