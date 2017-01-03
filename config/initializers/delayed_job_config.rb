Delayed::Worker.destroy_failed_jobs = false

# Quiet logs
ActiveRecord::Base.logger.level = 1

# logs
Delayed::Worker.logger = Logger.new(Rails.root.join('log', 'delayedjob.log'))
