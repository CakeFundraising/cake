class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, 
  :rememberable, :trackable, :validatable, :confirmable

  validates :full_name, presence: true
end
