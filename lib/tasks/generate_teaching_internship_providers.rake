require "csv"
require "yaml"
require "internship_provider"

namespace :teaching_internship_providers do
  desc "Generate the teaching internship providers page"
  task generate: :environment do
    csv = CSV.read("lib/tasks/support/internship_providers.csv", headers: true)

    providers = csv.each.with_object({}) do |r, h|
      ip = InternshipProvider.new(r)
      h[ip.region.to_s] ||= {}
      h[ip.region.to_s]["providers"] ||= []
      h[ip.region.to_s]["providers"] << ip.to_h
    end

    providers.transform_values! { |v| v["providers"].sort_by { |a| a["header"] } }
    provider_groups = providers.sort

    File.open("app/views/content/is-teaching-right-for-me/teaching-internship-providers.md", "w") do |f|
      f.write ERB.new(File.read("lib/tasks/support/teaching-internship-providers.md.erb"), trim_mode: "<>").result(binding)
    end
  end
end
