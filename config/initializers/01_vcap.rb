if ENV["VCAP_SERVICES"].present?
  Rails.application.config.x.vcap_services = JSON.parse(ENV["VCAP_SERVICES"])
end

if ENV["VCAP_APPLICATION"].present?
  Rails.application.config.x.vcap_app = JSON.parse(ENV["VCAP_APPLICATION"])
end
