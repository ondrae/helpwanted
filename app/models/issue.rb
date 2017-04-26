class Issue < ActiveRecord::Base
  belongs_to :project
  has_many :labels, dependent: :destroy
  validates :title, :url, presence: true

  default_scope { order(featured: :desc).order('github_updated_at DESC') }
  scope :help_wanted, -> { joins(:labels).where("labels.name ILIKE '%help wanted%'") }


  def number
    /github\.com\/[a-zA-Z\-_0-9]+\/[a-zA-Z\-_0-9]+\/?\/issues\/(?<number>\d+)/ =~ url
    number
  end

end
