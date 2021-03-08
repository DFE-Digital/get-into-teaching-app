# Don't load in dev or test environments
# Mirrors behaviour of actionpack-cloudfront
unless Rails.env.development? || Rails.env.test?
  require "cloud_front_ip_filter"
  CloudFrontIpFilter.configure!
end
