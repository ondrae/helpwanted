class Project < ActiveRecord::Base
  belongs_to :collection
  has_many :issues, dependent: :destroy

  validates :url, presence: true

  def update_project
    gh_project = GithubProject.new(self.url)
    self.update(name: gh_project.name, description: gh_project.description)
    rate_limit_check(gh_project)
    update_issues
  end

  private

  def update_issues
    gh_project = GithubProject.new(self.url)
    unless gh_project.issues.blank?
      gh_project.issues.map do |issue|
        exisiting_issue = Issue.where(project_id: self.id, url: issue.html_url).first
        if exisiting_issue
          exisiting_issue.update(title: issue.title, labels: labels(issue.labels))
        else
          Issue.create(title: issue.title, project: self, url: issue.html_url, labels: labels(issue.labels))
        end
      end
    end
    rate_limit_check(gh_project)
  end

  def labels(labels)
    labels.map { |label| label[:name] }
  end

  def rate_limit_check(gh_project)
    puts "GITHUB LIMIT REMAINING: " + gh_project.github_api.last_response.headers["x-ratelimit-remaining"]
  end
end
