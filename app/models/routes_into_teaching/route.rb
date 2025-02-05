module RoutesIntoTeaching
  class Route
    ROUTES_CONFIG_PATH = Rails.root.join("config/routes_into_teaching.yml")

    attr_reader :title, :course_length, :course_fee, :funding, :description, :cta_text, :cta_link, :matches, :highlight, :highlight_text, :route_finder

    def self.all(route_finder: nil)
      routes = YAML.load_file(ROUTES_CONFIG_PATH)["routes"]

      routes.map { |route| self.new(route, route_finder) }
    end

    def initialize(route, route_finder = nil)
      @title = route["title"]
      @course_length = route["course_length"]
      @course_fee = route["course_fee"]
      @funding = route["funding"]
      @description = route["description"]
      @cta_text = route["cta_text"]
      @cta_link = route["cta_link"]
      @matches = route["matches"]
      @highlight = route["highlight"]
      @highlight_text = route.dig("highlight", "text")
      @route_finder = route_finder
    end

    def highlighted?
      return false unless @route_finder && @highlight

      self.highlight["matches"].all? do |rule|
        question_id = rule["question"]
        matching_answers = rule["answers"]

        matching_answers.include?("*") || matching_answers.include?(@route_finder.answers[question_id])
      end
    end
  end
end
