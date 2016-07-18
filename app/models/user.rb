class User < ActiveRecord::Base
  has_many :collections, dependent: :destroy

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

  def projects
    @projects = self.collections.map { |collection| Project.where(collection: collection) }.flatten
  end

  def update_collections
    collections.map { |collection| collection.update_projects }
  end
end
