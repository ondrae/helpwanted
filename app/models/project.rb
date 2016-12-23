class Project < ActiveRecord::Base
  belongs_to :collection
  has_many :issues, -> { order(updated_at: :desc) }, dependent: :destroy

  validates :url, presence: true
  validates :name, presence: true, uniqueness: true

  extend FriendlyId
  friendly_id :name, use: :slugged

  def owner
    collection.owner
  end

  def update_project
    gh_project = GithubProject.new(self.url)
    self.update!(name: gh_project.name, description: gh_project.description)
  end

  def update_issues
    puts "Updating issues of #{self.url}"
    gh_project = GithubProject.new(self.url)
    unless gh_project.issues.blank?
      gh_project.issues.map do |gh_issue|
        exisiting_issue = Issue.where(project_id: self.id, url: gh_issue.html_url).first
        if exisiting_issue
          if gh_issue.gh_labels
            exisiting_issue.update(title: gh_issue.title, labels: gh_issue.gh_labels)
          else
            exisiting_issue.update(title: gh_issue.title)
          end
        else
          Issue.create(title: gh_issue.title, project: self, url: gh_issue.html_url, labels: gh_labels(gh_issue))
        end
      end
    end
  end
  handle_asynchronously :update_issues

  private

  def gh_labels(gh_issue)
    gh_issue.labels.map do |label|
      Label.new(name: label.name, color: label.color)
    end
  end
end
