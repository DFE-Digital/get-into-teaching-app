module RoutesIntoTeaching
  class Routes
    def self.all
      YAML.load_file(Rails.root.join("config/routes_into_teaching.yml"))["routes"]
    end

    def self.recommended(answers_hash = {})
      all.select do |teaching_route|
        next false if teaching_route["matches"].blank?

        teaching_route["matches"].all? do |matching_rule|
          question_id, matching_answers = matching_rule["question"], matching_rule["answers"]

          matching_answers.include?("*") || matching_answers.include?(answers_hash[question_id])
        end
      end
    end
  end
end
