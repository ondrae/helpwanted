class User < ActiveRecord::Base
  has_many :collections, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  extend FriendlyId
  friendly_id :github_name

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

  def github_update
    puts "Updating #{self.github_name}'s Collections"
    collections.each(&:github_update)
  end
end
