class Issue < ActiveRecord::Base
  belongs_to :project
  has_many :labels, dependent: :destroy
  validates :title, :url, presence: true

  default_scope ->{ order('github_updated_at DESC') }

  def number
    /github\.com\/[a-zA-Z\-_0-9]+\/[a-zA-Z\-_0-9]+\/?\/issues\/(?<number>\d+)/ =~ url
    number
  end

end
