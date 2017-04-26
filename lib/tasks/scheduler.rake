desc "Regularly updates everyone's collections, project, and issues"
task :update_collections => :environment do
  Delayed::Worker.logger "Updating all users collections"
  User.all.each do |user|
    user.update_collections
    sleep(1)
  end
  puts "done"
end
