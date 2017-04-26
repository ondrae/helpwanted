class Collection < ActiveRecord::Base
  belongs_to :user
  has_many :organizations, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :issues, through: :projects

  validates :name, presence: true, uniqueness: true

  default_scope ->{ order('updated_at DESC') }

  extend FriendlyId
  friendly_id :name, use: :slugged

  def owner
    user
  end

  def update_projects
    Delayed::Worker.logger.debug "Updating #{self.name}'s projects"
    organizations.map(&:get_new_projects)

    projects.map do |project|
      project.delay(priority: 100).update_project
      project.delay(priority: 100).update_issues
    end
  end

end
