class User < ActiveRecord::Base
  include Omniauthable
  include Rolable

  devise :database_authenticatable, :registerable, :recoverable, 
  :rememberable, :trackable, :validatable, :confirmable
  devise :omniauthable, :omniauth_providers => [:twitter, :facebook, :linkedin]

  validates :full_name, presence: true

  has_roles [:sponsor, :fundraiser]
  
  has_one :fundraiser_profile, dependent: :destroy
  has_one :organization
  has_one :email_setting, dependent: :destroy

  after_create do
    create_fundraiser_profile
    create_organization
    create_email_setting
  end
end
