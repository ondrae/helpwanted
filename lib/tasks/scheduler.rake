desc "Regularly updates everyone's collections, project, and issues"
task :update_collections => :environment do
  Delayed::Worker.logger.debug "Updating all users collections"
  User.all.each do |user|
    user.update_collections
  end
  puts "done"
end
