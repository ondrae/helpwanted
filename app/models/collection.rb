class Collection < ActiveRecord::Base
  belongs_to :user
  has_many :projects, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  default_scope ->{ order('updated_at DESC') }

  extend FriendlyId
  friendly_id :name, use: :slugged
end
