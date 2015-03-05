class User < ActiveRecord::Base
  include Omniauthable
  include Rolable

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable
  devise :omniauthable, omniauth_providers: [:facebook, :twitter, :linkedin, :stripe_connect]

  validates :full_name, presence: true
  validates :roles, presence: true, if: :persisted?

  has_roles [:sponsor, :fundraiser, :cakester]
  
  belongs_to :role, polymorphic: true

  has_one :fundraiser_email_setting, dependent: :destroy
  has_one :sponsor_email_setting, dependent: :destroy
  has_one :cakester_email_setting, dependent: :destroy

  def notify_account_update
    UserNotification.account_updated(self.id).deliver if self.send("#{self.role_type.downcase}_email_setting").account_change
  end

  #User roles methods
  def set_role(role_obj)
    self.roles = [role_obj.class.name.downcase.to_sym]
    self.role = role_obj
    self.registered = true
    self.save
  end

  def sponsor
    self.role if self.role_type == 'Sponsor'
  end

  def fundraiser
    self.role if self.role_type == 'Fundraiser'
  end

  def cakester
    self.role if self.role_type == 'Cakester'
  end
end
