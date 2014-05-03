class User < ActiveRecord::Base
  include Omniauthable
  include Rolable

  devise :database_authenticatable, :registerable, :recoverable, 
  :rememberable, :trackable, :validatable, :confirmable
  devise :omniauthable, :omniauth_providers => [:twitter, :facebook, :linkedin]

  validates :full_name, presence: true

  has_roles [:sponsor, :fundraiser]
  
  belongs_to :fundraiser
  belongs_to :sponsor
  has_one :fundraiser_email_setting, dependent: :destroy
  has_one :sponsor_email_setting, dependent: :destroy

  after_create do
    create_fundraiser_email_setting if has_role?(:fundraiser)
    create_sponsor_email_setting if has_role?(:sponsor)
  end

  def notify_account_update
    if fundraiser? and fundraiser_email_setting.account_change
      UserNotification.account_updated(self).deliver
    elsif sponsor? and sponsor_email_setting.account_change
      UserNotification.account_updated(self).deliver
    end
  end

  #User roles methods
  def sponsor?
    sponsor_id.present?
  end

  def fundraiser?
    fundraiser_id.present?
  end

  def set_fundraiser(fr)
    unless sponsor?
      self.fundraiser = fr 
      self.save
    end
  end

  def set_sponsor(sp)
    unless fundraiser?
      self.sponsor = sp
      self.save
    end
  end
end
