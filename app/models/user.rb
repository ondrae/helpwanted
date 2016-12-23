class User < ActiveRecord::Base
  has_many :collections, -> { order(updated_at: :desc) }, dependent: :destroy
  has_many :projects, -> { order(github_updated_at: :desc) }, through: :collections
  has_many :issues, -> { order(github_updated_at: :desc) }, through: :projects

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
     user.provider = auth.provider
     user.uid = auth.uid
     user.email = auth.info.email
     user.password = Devise.friendly_token[0,20]
     user.github_name = auth.info.nickname
     user.image = auth.info.image
    end
  end

  def update_collections
    puts "Updating #{self.github_name}'s Collections"
    collections.map { |collection| collection.update_projects }
  end
end
