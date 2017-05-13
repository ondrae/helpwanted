class Organization < ActiveRecord::Base
  belongs_to :collection
  validates :url, presence: true, uniqueness: { scope: :collection, message: "can only add a GitHub organization once per collection" }
  validates :collection_id, presence: true

  # def get_new_projects
  #   begin
  #     puts "Asking #{url} for new projects"
  #
  #     existing_urls = collection.projects.pluck(:url)
  #
  #     GithubOrganization.new(url).projects.each do |gh_project|
  #       unless existing_urls.include? gh_project.html_url
  #         gh_project_params = {
  #           name: gh_project.name,
  #           description: gh_project.description,
  #           url: gh_project.html_url,
  #           github_updated_at: gh_project.pushed_at,
  #           owner_login: gh_project.owner.login,
  #           owner_avatar_url: gh_project.owner.avatar_url,
  #           collection_id: collection_id
  #         }
  #         project = Project.create!(gh_project_params)
  #         puts "Adding #{gh_project.name} to #{collection.name}"
  #         if project.valid?
  #           project.update_issues
  #         end
  #       end
  #     end
  #   rescue
  #     puts "#{url} doesn't exist anymore."
  #   end
  # end

end
