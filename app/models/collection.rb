class Collection < ActiveRecord::Base
  belongs_to :user
  has_many :projects, dependent: :destroy

  validates :name, presence: true

  def projects
    @projects = Project.where(collection: self)
  end

  def issues
    @issues = self.projects.map { |project| Issue.where(project: project) }.flatten
  end

  def update_projects
    projects.map do |project|
      project.update_project
      project.update_issues
    end
  end
end
