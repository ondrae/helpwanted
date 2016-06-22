class Project < ActiveRecord::Base
  belongs_to :collection
  has_many :issues
end
