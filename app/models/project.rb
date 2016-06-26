class Project < ActiveRecord::Base
  belongs_to :collection
  has_many :issues, dependent: :destroy

  validates :url, presence: true

end
