class Project < ActiveRecord::Base
  belongs_to :collection
  has_many :issues, dependent: :destroy

  validates :url, presence: true, uniqueness: { scope: :collection, message: "can only add a project once per collection" }
  validates_format_of :url, with: /github\.com\/[a-zA-Z\-_0-9]+\/[a-zA-Z\-_0-9\.]+\/?/, on: :create
  default_scope -> { order(:name) }

  def owner
    collection.owner
  end

  def update_project
    puts "Updating #{self.url}"
    logger.debug "Updating #{self.url}"
    gh_project = GithubProject.new(self.url)
    self.update!(name: gh_project.name, description: gh_project.description, github_updated_at: gh_project.pushed_at, owner_login: gh_project.owner_login, owner_avatar_url: gh_project.owner_avatar_url)
  end

  def update_issues
    puts "Updating issues of #{self.url}"
    gh_project = GithubProject.new(self.url)
    unless gh_project.issues.blank?
      gh_project.issues.map do |gh_issue|
        existing_issue = Issue.where(project_id: self.id, url: gh_issue.html_url).first
        if existing_issue
          existing_issue.update(title: gh_issue.title, github_updated_at: gh_issue.updated_at, labels: gh_labels(gh_issue))
        else
          Issue.create(title: gh_issue.title, project: self, url: gh_issue.html_url, github_updated_at: gh_issue.updated_at, labels: gh_labels(gh_issue))
        end
      end
    end
    delete_closed_issues(open_issues: gh_project.issues, project_issues: self.issues)
    sleep 0.1
  end
  handle_asynchronously :update_issues

  private

  def delete_closed_issues(open_issues:, project_issues:)
    project_issues.each do |issue|
      unless open_issues.map(&:html_url).include? issue.url
        Delayed::Worker.logger.debug "Removing closed issue #{issue.title} from #{self.url}"
        issue.destroy
      end
    end
  end

  def gh_labels(gh_issue)
    gh_issue.labels.map do |label|
      Label.new(name: label.name, color: label.color)
    end
  end
end
