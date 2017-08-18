class Project < ActiveRecord::Base
  belongs_to :collection

  validates :url, presence: true, uniqueness: { scope: :collection, message: "can only add a project once per collection" }
  validates_format_of :url, with: /github\.com\/[a-zA-Z\-_0-9]+\/[a-zA-Z\-_0-9\.]+\/?/, on: :create

  default_scope -> { order(:url) }


  def full_name
    url.split("github.com/").last
  end
end
