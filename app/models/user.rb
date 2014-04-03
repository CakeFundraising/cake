class User < ActiveRecord::Base
  include Omniauthable
  include Rolable

  devise :database_authenticatable, :registerable, :recoverable, 
  :rememberable, :trackable, :validatable, :confirmable
  devise :omniauthable, :omniauth_providers => [:twitter, :facebook, :linkedin]

  validates :full_name, presence: true

  has_roles [:sponsor, :fundraiser]

  has_one :public_profile, dependent: :destroy

  after_create do
    create_public_profile
  end
end
