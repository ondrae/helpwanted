class Collection < ActiveRecord::Base
  has_many :projects, dependent: :destroy

  validates :name, presence: true

  def projects
    @projects = Project.where(collection: self)
  end

  def issues
    @issues = self.projects.map { |project| Issue.where(project: project) }.flatten
  end
end
