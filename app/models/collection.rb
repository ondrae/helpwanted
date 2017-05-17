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

  def github_update
    puts "Updating #{self.name}'s projects"
    projects.each(&:github_update)
  end

end
