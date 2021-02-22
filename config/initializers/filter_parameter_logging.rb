# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += %i[
  email
  first_name
  last_name
  password
  telephone
  timed_one_time_password
  firstName
  lastName
  timedOneTimePassword
]
