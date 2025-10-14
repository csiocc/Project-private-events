# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!
config.active_job.queue_adapter = :async
