# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

require 'prometheus/middleware/exporter'
require_relative 'lib/rack/deflater_with_exclusions'

if ENV.has_key?("VCAP_APPLICATION")
  EXTENSIONS_TO_EXCLUDE = %w(.jpg .jpeg .png .gif .pdf).freeze
else
  EXTENSIONS_TO_EXCLUDE = %w(.jpg .jpeg .png .gif .pdf .jp2 .webp .svg .ttf).freeze
end

use Rack::DeflaterWithExclusions, exclude: proc { |env|
  File.extname(env["PATH_INFO"]).in?(EXTENSIONS_TO_EXCLUDE)
}
use Prometheus::Middleware::Exporter

run Rails.application
