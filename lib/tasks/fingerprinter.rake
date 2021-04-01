require "fingerprinter"

desc "Fingerprinting of assets"
namespace :fingerprinter do
  desc "Fingerprint all content assets"
  task run: :environment do
    puts "Fingerprinting..."

    Fingerprinter.new(
      Rails.root.join("app/views/content"),
      Rails.root.join("public/assets"),
      "/assets",
    )
    .run
  end
end
