# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += %i[
  address_postcode
  email
  first_name
  last_name
  password
  telephone
  timed_one_time_password
]
