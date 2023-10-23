# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

require 'prometheus/middleware/exporter'
require_relative 'lib/rack/deflater_with_exclusions'

EXTENSIONS_TO_EXCLUDE = %w(.jpg .jpeg .png .gif .pdf .jp2 .webp .svg .ttf).freeze

use Rack::DeflaterWithExclusions, exclude: proc { |env|
  File.extname(env["PATH_INFO"]).in?(EXTENSIONS_TO_EXCLUDE)
}
use Prometheus::Middleware::Exporter

run Rails.application
