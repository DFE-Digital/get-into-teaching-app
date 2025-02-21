class ApplicationJob < ActiveJob::Base
  retry_on ActiveRecord::Deadlocked
  retry_on StandardError, wait: :exponentially_longer, attempts: 3
  discard_on ActiveJob::DeserializationError
end
