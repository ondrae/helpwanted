class Organization < ActiveRecord::Base
  belongs_to :collection
  validates :collection_id, presence: true

  def get_new_projects
    Delayed::Worker.logger.debug "Asking #{name} for new projects"

    existing_urls = collection.projects.map(&:url)

    GithubOrganization.new(name).projects.each do |gh_project|
      unless existing_urls.include? gh_project.html_url
        gh_project_params = {
          name: gh_project.name,
          description: gh_project.description,
          url: gh_project.html_url,
          github_updated_at: gh_project.pushed_at,
          owner_login: gh_project.owner.login,
          owner_avatar_url: gh_project.owner.avatar_url,
          collection_id: collection_id
        }
        project = Project.create!(gh_project_params)
        if project.valid?
          project.delay(priority: 1).update_issues
        end
      end
      sleep 0.1
    end
  end
end
