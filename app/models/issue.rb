class Issue < ActiveRecord::Base
  belongs_to :project
  validates :title, :url, presence: true

  def label_string
    labels.join(", ") if labels
  end

  def number
    /github\.com\/[a-zA-Z\-_0-9]+\/[a-zA-Z\-_0-9]+\/?\/issues\/(?<number>\d+)/ =~ url
    number
  end
end
