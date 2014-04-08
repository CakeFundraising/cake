class User < ActiveRecord::Base
  include Omniauthable
  include Rolable

  devise :database_authenticatable, :registerable, :recoverable, 
  :rememberable, :trackable, :validatable, :confirmable
  devise :omniauthable, :omniauth_providers => [:twitter, :facebook, :linkedin]

  validates :full_name, presence: true

  has_roles [:sponsor, :fundraiser]
  
  has_one :email_setting, dependent: :destroy
  belongs_to :fundraiser
  belongs_to :sponsor

  after_create do
    create_email_setting
  end

  def set_fundraiser(fr)
    self.fundraiser = fr
    self.save
  end

  def set_sponsor(sp)
    self.sponsor = sp
    self.save
  end
end
