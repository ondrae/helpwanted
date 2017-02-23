class Organization < ActiveRecord::Base
  belongs_to :collection
  validates :collection_id, presence: true

  def update_projects
    puts "Updating #{name}'s projects"

    @projects = GithubOrganization.new(name).projects
    @projects.map do |gh_project|
      gh_project_params = {
        name: gh_project.name,
        description: gh_project.description,
        url: gh_project.html_url,
        github_updated_at: gh_project.pushed_at,
        owner_login: gh_project.owner.login,
        owner_avatar_url: gh_project.owner.avatar_url,
        collection_id: collection_id
      }
      project = Project.create(gh_project_params)
      if project.valid?
        project.update_issues
      end
    end
  end

end
