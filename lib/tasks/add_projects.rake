namespace :add_projects do
  desc "Add all the groups on the CfAPI to the civic-tech collection."
  task add_cfapi_groups: :environment do
    require 'json'
    require 'open-uri'
    orgs = JSON.parse open('https://raw.githubusercontent.com/codeforamerica/brigade-information/master/organizations.json').read
    orgs.each do |org|
      if org["projects_list_url"].include? "https://github.com/"
        ap org["projects_list_url"]
        HTTParty.post('http://helpwanted.team/projects', body: { "project": { url: org["projects_list_url"], collection_id: "civic-tech" } })
        sleep (0.2)
      end
    end
  end
end
