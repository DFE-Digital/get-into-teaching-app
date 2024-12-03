require "csv"
require "yaml"
require "assessment_only_provider"

namespace :assessment_only_providers do
  desc "Generate the assessment only providers page"
  task generate: :environment do
    csv = CSV.read("lib/tasks/support/assessment_only_providers.csv", headers: true)

    provider_groups = csv.each.with_object({}) do |row, h|
      next if row[0].blank? || row["region"].blank?

      AssessmentOnlyProvider.new(row).tap do |provider|
        provider.regions.each do |region|
          h[region] ||= {}
          h[region]["providers"] ||= []
          h[region]["providers"] << provider.to_h
        end
      end
    end

    provider_groups = provider_groups.transform_values { |v| v["providers"].sort_by { |a| a["header"].to_s.downcase } }.sort_by { |x, _y| [case x when "Non-UK"then 2; when "National" then 0; else 1 end, x] }

    File.open("app/views/content/train-to-be-a-teacher/assessment-only-route-to-qts.md", "w") do |f|
      f.write ERB.new(File.read("lib/tasks/support/assessment-only-route-to-qts.md.erb"), trim_mode: "<>").result(binding)
    end
  end
end
