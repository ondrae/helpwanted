class Issue < ActiveRecord::Base
  belongs_to :project
  validates :title, :url, presence: true
end
