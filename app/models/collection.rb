class Collection < ActiveRecord::Base
  belongs_to :user
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
    puts "Updating #{self.name}'s projects"
    projects.map do |project|
      project.update_project
      project.update_issues
    end
  end
end
