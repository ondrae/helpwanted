class Organization < ActiveRecord::Base
  belongs_to :collection
  validates :url, presence: true, uniqueness: { scope: :collection, message: "can only add an organization once per collection" }
  validates_format_of :url, with: /github\.com\/[a-zA-Z\-_0-9]+/, on: :create

  default_scope -> { order(:url) }

  def name
    url.split("github.com/").last
  end
end
