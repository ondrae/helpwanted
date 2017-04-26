Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.max_attempts = 1

# Quiet logs
ActiveRecord::Base.logger.level = 1

# logs
Delayed::Worker.logger = Logger.new(Rails.root.join('log', 'delayedjob.log'))
