require "csv"
require "yaml"
require "internship_provider"
require "agency"

desc "CSV to Yaml import"
namespace :csv_to_yaml do
  desc "Convert internship providers CSV to Yaml"
  task internship_providers: :environment do
    csv = CSV.read("internship_providers.csv", headers: true)

    providers = csv.each.with_object({}) do |r, h|
      ip = InternshipProvider.new(r)
      h[ip.region.to_s] ||= {}
      h[ip.region.to_s]["providers"] ||= []
      h[ip.region.to_s]["providers"] << ip.to_h
    end

    providers.transform_values! { |v| { "providers" => v["providers"].sort_by { |a| a["header"] } } }

    puts providers.sort.to_h.to_yaml
  end

  desc "Convert agencies CSV to Yaml"
  task agencies: :environment do
    csv = CSV.read("agencies.csv", headers: true)

    agencies = csv.each.with_object(Hash.new { |h, k| h[k] = [] }) do |r, h|
      a = Agency.new(r)
      h[a.region.to_s] << a.to_h
    end

    agencies.transform_values! { |v| v.sort_by { |a| a["name"] } }

    puts agencies.sort.to_h.to_yaml
  end
end
