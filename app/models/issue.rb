class Issue
  include ActiveModel::Model

  attr_reader :title, :url, :labels, :updated_at,
              :repo_name, :repo_url, :owner_login,
              :project, :collection

  def initialize(github_issue)
    @title = github_issue.title
    @url = github_issue.html_url
    @labels = github_issue.labels
    @updated_at = github_issue.updated_at
    @repo_name = github_issue.html_url.split("/")[4]
    @repo_url = github_issue.html_url.split('/issues')[0]
    @project = Project.find_by_url @repo_url
  end
end
