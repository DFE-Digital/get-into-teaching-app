module RoutesIntoTeaching
  class RoutesFinder
    attr_reader :routes, :answers

    def initialize(answers:)
      @routes = RoutesIntoTeaching::Route.all(route_finder: self)
      @answers = answers
    end

    def recommended
      return @routes if @answers.nil?

      recommended_routes = @routes.select do |route|
        next false if route.matches.blank?

        route.matches.all? do |matching_rule|
          question_id = matching_rule["question"]
          matching_answers = matching_rule["answers"]

          matching_answers.include?("*") || matching_answers.include?(@answers[question_id])
        end
      end

      recommended_routes.partition(&:highlighted?).flatten
    end
  end
end
