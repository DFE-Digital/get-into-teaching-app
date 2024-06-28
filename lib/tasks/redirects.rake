desc "Redirects"
namespace :redirects do
  # Given an export of used redirects (obtained from the 'Used Redirects' visualization
  # in Kibana) this will print out the entries in our redirects.yml that have received
  # no traffic.
  #
  # Example usage:
  #
  # rake 'redirects:find_unused[redirects-6-to-21-june.csv]'
  #
  # Optionally omit redirects below a certain threshold; for example to treat redirects
  # with < 3 requests as unused:
  #
  # rake 'redirects:find_unused[redirects-6-to-21-june.csv, 3]'
  desc "Find unused redirects"
  task :find_unused, %i[file threshold] => :environment do |_t, args|
    require "csv"

    threshold = args[:threshold]&.to_i || 0
    redirects = YAML.load_file(Rails.root.join("config/redirects.yml")).fetch("redirects")
    csv = File.read(args[:file])
    used_redirects = CSV.parse(csv, headers: true)
      .reject { |r| r["Count"].to_i < threshold }
      .map { |r| r[0] }

    puts(redirects.reject { |k| k.in?(used_redirects) })
  end
end
